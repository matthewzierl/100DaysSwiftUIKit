//
//  GameScene.swift
//  Project11
//
//  Created by Matthew Zierl on 7/26/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var ballNames = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: 2778, height: 1284)
        background.position = CGPoint(x: 1389, y: 642)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 2650, y: 1200)
        scoreLabel.fontSize = 64
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 200, y: 1200)
        editLabel.fontSize = 64
        addChild(editLabel)
        
        
        makeSlot(at: CGPoint(x: 347.25, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 1041.75, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 1736.25, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 2430.75, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 694.5, y: 0))
        makeBouncer(at: CGPoint(x: 1389, y: 0))
        makeBouncer(at: CGPoint(x: 2083.5, y: 0))
        makeBouncer(at: CGPoint(x: 2778, y: 0))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self) // get position in whole of game scene
        
        let objects = nodes(at: location) // get nodes which exist at specified location
        
        if (objects.contains(editLabel)) { // did tap 'edit'
            editingMode.toggle()
        } else { // didn't tap 'edit'
            if editingMode { // create boxes
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: size)
                box.physicsBody?.isDynamic = false
                box.name = "obstacle"
                addChild(box)
            } else { // normal behavior
                
                let randIndex = Int.random(in: 0..<7)
                
                let ball = SKSpriteNode(imageNamed: ballNames[randIndex])
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.9 // refers to bounciness 0-1 not-bouncy
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 // allows us to detect collisions
                let ballPosition = CGPoint(x: location.x, y: 1284)
                ball.position = ballPosition
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.size = CGSize(width: 250, height: 250)
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false // object will not be moved, is fixed in place
        addChild(bouncer)
    }
    
    func makeSlot (at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.size = CGSize(width: 470, height: 6)
        slotBase.position = position
        slotGlow.size = CGSize(width: 470, height: 470)
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "obstacle" {
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
