//
//  GameScene.swift
//  Project20
//
//  Created by Matthew Zierl on 8/13/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 2778 + 22
    
    var batchesLaunched = 0
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 2778/2, y: 1284/2)
        background.blendMode = .replace
        background.zPosition = -1
        background.yScale = 1.8
        background.xScale = 2.7
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 300, y: 100)
        scoreLabel.setScale(2)
        addChild(scoreLabel)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero) // movet to where the firework starts
        path.addLine(to: CGPoint(x: xMovement, y: 1500))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        firework.setScale(1.8)
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        
        if batchesLaunched >= 6 {
            gameTimer?.invalidate()
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.position = CGPoint(x: 2778/2, y: 1284/2)
            gameOverLabel.setScale(3)
            gameOverLabel.text = "GAME OVER"
            addChild(gameOverLabel)
            return
        }
        
        let movementAmount: CGFloat = 4500
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire 5, straight up
            createFirework(xMovement: 0, x: 2778/2, y: bottomEdge)
            createFirework(xMovement: 0, x: 2778/2 - 500, y: bottomEdge)
            createFirework(xMovement: 0, x: 2778/2 - 250, y: bottomEdge)
            createFirework(xMovement: 0, x: 2778/2 + 250, y: bottomEdge)
            createFirework(xMovement: 0, x: 2778/2 + 500, y: bottomEdge)
        case 1:
            // fire 5, in a fan
            createFirework(xMovement: 0, x: 2778/2, y: bottomEdge)
            createFirework(xMovement: -500, x: 2778/2 - 500, y: bottomEdge)
            createFirework(xMovement: -250, x: 2778/2 - 250, y: bottomEdge)
            createFirework(xMovement: 250, x: 2778/2 + 250, y: bottomEdge)
            createFirework(xMovement: 500, x: 2778/2 + 500, y: bottomEdge)
        case 2:
            // fire 5, left to right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 1000)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 800)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 600)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
        case 3:
            // fire 5, right to left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 1000)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 800)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 600)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
        default:
            break;
        }
        
        batchesLaunched += 1
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // attempt to convert SKNode to SKSpriteNodes, else skip
        for case let node as SKSpriteNode in nodesAtPoint {
            
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0 // go back to default texture color (white)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 1280 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let wait = SKAction.wait(forDuration: 1.0)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([wait, remove])
            
            emitter.run(sequence)
            
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 5000
        }
        
    }
    
}
