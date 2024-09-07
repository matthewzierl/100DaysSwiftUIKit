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

class GameScene: SKScene {
    
    let screenWidth: CGFloat = 2778
    let screenHeight: CGFloat = 1284
    
    weak var viewController: GameViewController?
    
    var buildings = [BuildingNode]()
    
    // give scene dark blue color
    // call method to call buildings
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
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
    
    func launch(angle: Int, velocity: Int) {
        
    }
    
}
