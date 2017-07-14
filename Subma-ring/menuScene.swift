//
//  menuScene.swift
//  Subma-ring
//
//  Created by Kirsten Bauman on 5/2/17.
//  Copyright © 2017 Kirsten Bauman. All rights reserved.
//

import SpriteKit

class menuScene: SKScene {
    
    var highScore = 0
    var contentsCreated = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.cyan
        if contentsCreated == false {
            createSceneContents()
            contentsCreated = true
        }
        
    }
    
    func createSceneContents() {
        let label = SKLabelNode(fontNamed: "Futura Medium")
        label.text = "SUBMA-RING"
        label.fontSize = 45
        label.fontColor = SKColor.white
        label.position = CGPoint(x: frame.midX, y: frame.midY - 40.0)
        addChild(label)
        
        let highScoreNode = SKLabelNode(fontNamed: "Futura Medium")
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 30.0
        highScoreNode.position = CGPoint(x: frame.midX, y: frame.midY + 40.0)
        highScoreNode.name = "HighScore"
        addChild(highScoreNode)
    }
    
    func updateHighScore(value: Int) {
        if value > highScore {
            highScore = value
            if let node = childNode(withName: "HighScore") as! SKLabelNode? {
                node.text = "HighScore: \(highScore)"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // A touch anywhere in this scene will cause a transition to GameScene
        
        let game = gameScene(size: size)
        game.menu = self
        let doors = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
        view?.presentScene(game, transition: doors)
        
    }

}
