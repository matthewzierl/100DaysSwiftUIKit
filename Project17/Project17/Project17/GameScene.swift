//
//  GameScene.swift
//  Project17
//
//  Created by Matthew Zierl on 8/9/24.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var totalNumEnemies = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")! // implicitly unwrapped bc we know we imported it
        starField.position = CGPoint(x: 1389, y: 642)
        starField.advanceSimulationTime(10) // move 10 seconds worth of particles now
        starField.zPosition = -1
        addChild(starField)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 400, y: 600)
        player.setScale(1.8)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.setScale(1.8)
        scoreLabel.position = CGPoint(x: 100, y: 80)
        scoreLabel.horizontalAlignmentMode = .left
        score = 0 // didset automatically sets text
        addChild(scoreLabel)
        
        
        physicsWorld.gravity = .zero // space
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else {
            return
        }
        
        if isGameOver { return }
        
        if (totalNumEnemies != 0 && totalNumEnemies % 20 == 0) {
            guard let prevInterval = gameTimer?.timeInterval else { return }
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: prevInterval - 0.1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 2800, y: Int.random(in: 100...1150))
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.fieldBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5 // spin
        sprite.physicsBody?.linearDamping = 0 // how fast slows down over time
        sprite.physicsBody?.angularDamping = 0 // never stop spinning
        addChild(sprite)
        
        totalNumEnemies += 1
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for sprite in children {
            if sprite.position.x < -200 {
                sprite.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    /*
        Called when player dragging finger
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 150 {
            location.y = 150
        } else if location.y > 1150 {
            location.y = 1150
        }
        
        player.position = location
    }
    
    /*
        Called when 2 things collide?
     */
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEffectNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
    }
    
    /*
        Called when touches have ended, so if player lifts figer, automatically
        kills player and ends the game
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if children.contains(player) {
            let explosion = SKEffectNode(fileNamed: "explosion")!
            explosion.position = player.position
            addChild(explosion)
            player.removeFromParent()
            isGameOver = true
        }
    }
}
