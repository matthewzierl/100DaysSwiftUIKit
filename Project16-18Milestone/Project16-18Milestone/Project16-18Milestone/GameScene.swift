//
//  GameScene.swift
//  Project16-18Milestone
//
//  Created by Matthew Zierl on 8/10/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var curtains: SKSpriteNode!
    
    var gameTimer: Timer?
    
    enum Tracks {
        case top
        case middle
        case bottom
    }
    
    enum Speed: Double {
        case slow = 2.1
        case medium = 1.6
        case fast = 1.1
    }
    
    var possibleTargets = ["target1", "target2", "target3"]
    var possibleTracks = [Tracks.top, Tracks.middle, Tracks.bottom]
    var possibleSpeeds = [Speed.slow, Speed.medium, Speed.fast]
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timeLabel: SKLabelNode!
    var timer: Timer?
    var time = 60 {
        didSet {
            timeLabel.text = "\(time)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 1389, y: 642)
        background.xScale = 3.8
        background.yScale = 2.2
        background.zPosition = -1
        addChild(background)
        
        curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 1389, y: 642)
        curtains.xScale = 3.8
        curtains.yScale = 2.2
        curtains.zPosition = 1
        addChild(curtains)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.setScale(3)
        scoreLabel.position = CGPoint(x: 200, y: 50)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.text = "60"
        timeLabel.setScale(3)
        timeLabel.position = CGPoint(x: 2600, y: 1150)
        timeLabel.zPosition = 2
        addChild(timeLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(spawnTargets), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTime() {
        time -= 1
        if (time <= 0) {
            timer?.invalidate()
        }
    }
    
    @objc func spawnTargets() {
        if time <= 0 { // stop spawning targets
            gameTimer?.invalidate()
            return
        }
        
        guard let target = possibleTargets.randomElement() else { // choose random target
            return
        }
        guard let track = possibleTracks.randomElement() else { // choose random track
            return
        }
        guard let speed = possibleSpeeds.randomElement() else { // choose random speed
            return
        }
        
        let sprite = SKSpriteNode(imageNamed: target)
        sprite.name = target
        sprite.setScale(1.5)
        
        // Create an action to move the sprite
        let moveAction: SKAction
        
        switch track {
        case .top:
            sprite.position = CGPoint(x: 0, y: 960)
            moveAction = SKAction.moveTo(x: 2880, duration: speed.rawValue)
        case .middle:
            sprite.position = CGPoint(x: 2880, y: 640)
            moveAction = SKAction.moveTo(x: -100, duration: speed.rawValue)
        case .bottom:
            sprite.position = CGPoint(x: 0, y: 320)
            moveAction = SKAction.moveTo(x: 2880, duration: speed.rawValue)
        }
        
        // Create an action to remove the sprite after it has moved off-screen
        let removeAction = SKAction.removeFromParent()
        
        // Run the move action, then remove the sprite
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        sprite.run(sequence)
        
        addChild(sprite)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let tappedNodes = nodes(at: location)
        
        run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
        
        for node in tappedNodes {
            if node.name == "target1" {
                score -= 1
                node.removeFromParent()
            } else if node.name == "target2" {
                score += 1
                node.removeFromParent()
            } else if node.name == "target3" {
                score += 2
                node.removeFromParent()
            }
        }
    }
}
