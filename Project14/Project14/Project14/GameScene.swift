//
//  GameScene.swift
//  Project14
//
//  Created by Matthew Zierl on 8/5/24.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var slots = [WhackSlot]()
    
    var popupTime = 0.85
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.size = CGSize(width: 2778, height: 1284)
        background.position = CGPoint(x: 1389, y: 642)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 70, y: 30)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 80
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 400 + (i * 250), y: 700)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 500 + (i * 250), y: 550)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 400 + (i * 250), y: 400)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 500 + (i * 250), y: 250)) }
        
        // start showing penguins after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        popupTime *= 0.991
        
        slots.shuffle()
        
        slots[0].show(hideTime: popupTime) // show moves the penguin out of the mask
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        // call itself to keep creating enemies after a certain delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
