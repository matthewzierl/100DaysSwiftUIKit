//
//  GameScene.swift
//  Project26
//
//  Created by Matthew Zierl on 8/30/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let width = 2778
    let height = 1284
    
    var player: SKSpriteNode!
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
        // order of numbers allow for unique combinations of collision types
    }
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: width/2, y: height/2)
        background.blendMode = .replace
        background.size.width = CGFloat(width)
        background.size.height = CGFloat(height)
        background.zPosition = -1
        addChild(background)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self // set self as delegate for physics
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 32, y: 32)
        scoreLabel.zPosition = 2
        scoreLabel.setScale(1.8)
        addChild(scoreLabel)
        score = 0
    }
    
    func loadLevel() {
        
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt as a string")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (112 * column) + 512, y: (112 * row) + 16)
                
                var node: SKSpriteNode
                
                if letter == "x" {
                    // load wall
                    node = createSprite(type: "block", position: position)
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                } else if letter == "v" {
                    // load vortex
                    
                    node = createSprite(type: "vortex", position: position)
                    
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue // want to be told when touched by player
                    node.physicsBody?.collisionBitMask = 0 // bounces off nothing
                } else if letter == "s" {
                    // load start
                    node = createSprite(type: "star", position: position)
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                } else if letter == "f" {
                    // load finish point
                    node = createSprite(type: "finish", position: position)
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                } else if letter == " " {
                    // this is an empty space - do nothing!
                    continue
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
                addChild(node)
            }
        }
    }
    
    func createSprite(type: String, position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: type)
        node.setScale(1.8)
        node.position = position
        node.name = type
        
        if type == "block" {
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size) // rectangular
        } else {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2) // circular
        }
        
        node.physicsBody?.isDynamic = false
        
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let dif = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: dif.x / 100, dy: dif.y / 100) // bring down strength
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.setScale(1.8)
        player.position = CGPoint(x: 625, y: 1125)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        
        addChild(player)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // go to next level
        }
    }
}
