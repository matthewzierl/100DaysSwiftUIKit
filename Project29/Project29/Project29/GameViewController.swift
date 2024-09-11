//
//  GameViewController.swift
//  Project29
//
//  Created by Matthew Zierl on 9/6/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    var player1Score = 0
    var player2Score = 0
    
    var currentGame: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
        
        player1ScoreLabel.text = "Score: \(player1Score)"
        player2ScoreLabel.text = "Score: \(player2Score)"
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        velocitySlider.isHidden = true
        angleLabel.isHidden = true
        velocityLabel.isHidden = true
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER 1"
        } else {
            playerNumber.text = "PLAYER 2 >>>"
        }
        angleSlider.isHidden = false
        velocitySlider.isHidden = false
        angleLabel.isHidden = false
        velocityLabel.isHidden = false
        launchButton.isHidden = false
    }
    
    func updateScore(player: Int) {
        if player == 1 {
            player1Score += 1
            player1ScoreLabel.text = "Score: \(player1Score)"
        } else {
            player2Score += 1
            player2ScoreLabel.text = "Score: \(player2Score)"
        }
    }
    
    func endGame() {
        let label = UILabel()
        label.frame = view.frame
        label.font = UIFont(name: "Chalkduster", size: 128)
        label.textAlignment = .center
        label.text = "GAME OVER"
        view.addSubview(label)
    }
    
}
