//
//  GameScene.swift
//  Project29
//
//  Created by Matthew Zierl on 9/6/24.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let screenWidth: CGFloat = 2778
    let screenHeight: CGFloat = 1284
    
    weak var viewController: GameViewController?
    
    var buildings = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer = 1

    
    // give scene dark blue color
    // call method to call buildings
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        physicsWorld.contactDelegate = self
        causeWind()
    }
    
    func causeWind() {
        switch Int.random(in: 1 ..< 6) {
        case 1:
            print("Changing to right")
            physicsWorld.gravity.dx = 7 // to right
            viewController?.windLabel.text = "Wind: right"
        case 2:
            print("Changing to left")
            physicsWorld.gravity.dx = -7 // to left
            viewController?.windLabel.text = "Wind: left"
        default:
            print("Changing to none")
            physicsWorld.gravity.dx = 0 // none
            viewController?.windLabel.text = "Wind: none"
        }
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < screenWidth {
            let size = CGSize(width: Int.random(in: 2...4) * 80, height: Int.random(in: 350...700))
            currentX += size.width + 4
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2) // offset center (make it cutoff screen?)
            
            building.setup()
            addChild(building)
            buildings.append(building)
            
        }
        
    }
    
    // determine degree angle in radians
    // destory existing banana to create new banana
    // explosion effects
    // launching physics
    // player throw animations
    func launch(angle: Int, velocity: Int) {
        
        let speed = Double(velocity) / 2.0
        let radians = deg2grad(degrees: angle)
        
        if banana != nil { // free up any bananas
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.setScale(1.8)
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true // since banana is small/fast, need this for better detection
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 50, y: player1.position.y + 60)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed) // calculate push
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 50, y: player2.position.y + 60)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed) // calculate push
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func deg2grad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.setScale(1.8)
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + (player1Building.size.height + player1.size.height) / 2)
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.setScale(1.8)
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + (player2Building.size.height + player2.size.height) / 2)
        addChild(player2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
            viewController?.updateScore(player: 2)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
            viewController?.updateScore(player: 1)
        }
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        // create new game scene
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if self.viewController?.player1Score ?? 3 >= 3 || self.viewController?.player2Score ?? 3 >= 3 {
                // end game
                self.viewController?.endGame()
            } else { // continue to next
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController?.currentGame = newGame
                
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.reveal(with: .up, duration: 3)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        causeWind()
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    /*
        Called once per frame
     */
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 2500 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
}
