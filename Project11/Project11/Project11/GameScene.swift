//
//  GameScene.swift
//  Project11
//
//  Created by Matthew Zierl on 7/26/24.
//

import SpriteKit

class GameScene: SKScene {

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: 2778, height: 1284)
        background.position = CGPoint(x: 1389, y: 642)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 694.5, y: 0))
        makeBouncer(at: CGPoint(x: 1389, y: 0))
        makeBouncer(at: CGPoint(x: 2083.5, y: 0))
        makeBouncer(at: CGPoint(x: 2778, y: 0))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self) // get position in whole of game scene
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.9 // refers to bounciness 0-1 not-bouncy
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.size = CGSize(width: 250, height: 250)
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false // object will not be moved, is fixed in place
        addChild(bouncer)
    }
}
