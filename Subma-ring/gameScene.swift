//
//  gameScene.swift
//  Subma-ring
//
//  Created by Kirsten Bauman on 5/2/17.
//  Copyright © 2017 Kirsten Bauman. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class gameScene: SKScene, SKPhysicsContactDelegate {
    
    var menu: menuScene? = nil
    var contentCreated = false
    var randomSource = GKLinearCongruentialRandomSource.sharedRandom()
    var points = 0
    let hitSound = SKAction.playSoundFileNamed("smw_coin.wav", waitForCompletion: false)
    let crashSound = SKAction.playSoundFileNamed("Glass_and_Metal_Collision.mp3", waitForCompletion: false)
    var selected: SKNode?
    let motion = CMMotionManager()
    var health = 3
    
    override func didMove(to view: SKView) {
        if contentCreated == false {
            createSceneContents()
            contentCreated = true
        }
        
        motion.startAccelerometerUpdates()
        motion.startDeviceMotionUpdates()
        
        
    }
    
    func createSceneContents() {
        backgroundColor = SKColor.blue
        scaleMode = .aspectFit
        
        createSub()
        
        physicsWorld.contactDelegate = self
        //physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.3)
        
        createBoundaries()
        
        let healthBarBG = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100.0, height: 15.0))
        healthBarBG.position = CGPoint(x: frame.width - 100.0, y: frame.height - 10.0)
        healthBarBG.zPosition = 20.0
        addChild(healthBarBG)
        
        let healthBarFG = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100.0, height: 15.0))
        healthBarFG.position = CGPoint(x: frame.width - 100.0, y: frame.height - 10.0)
        healthBarFG.zPosition = 25.0
        healthBarFG.name = "health"
        addChild(healthBarFG)
        
        let makeRing = SKAction.sequence([
            SKAction.perform(#selector(gameScene.addRing), onTarget: self),
            SKAction.wait(forDuration: 2.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeRing))
        
        
        let makeMine = SKAction.sequence([
            SKAction.perform(#selector(gameScene.addMine), onTarget: self),
            SKAction.wait(forDuration: 4.0, withRange: 1.0)])
        run(SKAction.repeatForever(makeMine))
        
        let scoreNode = SKLabelNode(fontNamed: "Futura Medium")
        scoreNode.text = "0"
        scoreNode.fontSize = 35.0
        scoreNode.position = CGPoint(x: 20.0, y: size.height - 40.0)
        scoreNode.zPosition = 20.0
        scoreNode.name = "Score"
        scoreNode.horizontalAlignmentMode = .left
        addChild(scoreNode)
    }
    
    
    func addPoints(value: Int) {
        points += value
        if let score = childNode(withName: "Score") as! SKLabelNode?{
            score.text = "\(points)"
        }
    }
    
    func createBoundaries() {
        let floor = SKSpriteNode(color: SKColor.green, size: CGSize(width: frame.width, height: 10))
        floor.position = CGPoint(x: frame.midX, y: -50.0)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        floor.name = "side"
        addChild(floor)
        
        let ceiling = SKSpriteNode(color: SKColor.green, size: CGSize(width: frame.width, height: 10))
        ceiling.position = CGPoint(x: frame.midX, y: frame.height + 50.0)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.isDynamic = false
        ceiling.name = "side"
        addChild(ceiling)
        
        let right = SKSpriteNode(color: SKColor.green, size: CGSize(width: 10, height: frame.height))
        right.position = CGPoint(x: frame.width + 50.0, y: frame.midY)
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        right.name = "side"
        addChild(right)
        
        let left = SKSpriteNode(color: SKColor.green, size: CGSize(width: 10, height: frame.height))
        left.position = CGPoint(x: -50.0, y: frame.midY)
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        left.name = "side"
        addChild(left)
    }
    
    func createSub() {
        let subTexture = SKTexture(imageNamed: "submarine.png")
        let sub = SKSpriteNode(texture: subTexture)
        sub.position = CGPoint(x: frame.midX, y: frame.midY)
        sub.zPosition = 5.0
        sub.size = CGSize(width: 63.5, height: 43.5)
        sub.name = "sub"
        sub.physicsBody = SKPhysicsBody(rectangleOf: sub.size)
        sub.physicsBody?.usesPreciseCollisionDetection = true
        sub.physicsBody?.friction = 0.3
        sub.physicsBody?.linearDamping = 0.2
        sub.physicsBody?.restitution = 0.5
        sub.physicsBody?.categoryBitMask = 1
        sub.physicsBody?.collisionBitMask = 1
        sub.physicsBody?.contactTestBitMask = 1
        sub.physicsBody?.isDynamic = true
        sub.physicsBody?.allowsRotation = false
        
        let prop = propeller()
        sub.addChild(prop)
        
        
        addChild(sub)
    }
    
    func addRing() {
        let ringTexture = SKTexture(imageNamed: "ring.png")
        let ring = SKSpriteNode(texture: ringTexture)
        ring.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: CGFloat(randomSource.nextUniform()) * size.height)
        ring.name = "ring"
        ring.size = CGSize(width: 35.0, height: 35.0)
        ring.physicsBody = SKPhysicsBody(rectangleOf: ring.size)
        ring.physicsBody?.usesPreciseCollisionDetection = true
        ring.physicsBody?.contactTestBitMask = 1
        ring.physicsBody?.isDynamic = false
        addChild(ring)
        
        
        // fade and grow actions then delete
        let scale = SKAction.scale(to: 2.0, duration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 3.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        
        let actions = SKAction.sequence([scale, fadeIn, pause, fadeOut, remove])
        ring.run(actions)
    }
    
    func addMine() {
        let mineTexture = SKTexture(imageNamed: "mine.png")
        let mine = SKSpriteNode(texture: mineTexture)
        mine.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: CGFloat(randomSource.nextUniform()) * size.height)
        mine.name = "mine"
        mine.size = CGSize(width: 35.35, height: 40.95)
        mine.physicsBody = SKPhysicsBody(rectangleOf: mine.size)
        mine.physicsBody?.usesPreciseCollisionDetection = true
        mine.physicsBody?.contactTestBitMask = 1
        mine.physicsBody?.isDynamic = false
        addChild(mine)
        
        
        // fade and grow actions then delete
        let scale = SKAction.scale(to: 2.0, duration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 3.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        
        let actions = SKAction.sequence([scale, fadeIn, pause, fadeOut, remove])
        mine.run(actions)
    }
    
    func propeller() -> (SKSpriteNode){
        let propellerTexture = SKTexture(imageNamed: "propeller.png")
        let propeller = SKSpriteNode(texture: propellerTexture)
        propeller.size = CGSize(width: 25.5, height: 24.5)
        propeller.physicsBody = nil
        
        let rotate = SKAction.rotate(byAngle: 10.0, duration: 0.5)
        
        let rotateRepeat = SKAction.repeatForever(rotate)
        propeller.run(rotateRepeat)
        
        return propeller
    }
    
    func removeRing(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let data = motion.accelerometerData {
            physicsWorld.gravity = CGVector(dx: data.acceleration.y * -5, dy: data.acceleration.x * 5)
        }
        if health == 0 {
            menu?.updateHighScore(value: points)
            let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(menu!, transition: open)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        if contact.bodyA.node?.name == "sub" && contact.bodyB.node?.name == "side" {
            menu?.updateHighScore(value: points)
            let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(menu!, transition: open)
        }
        if contact.bodyA.node?.name == "sub" && contact.bodyB.node?.name == "ring" {
            run(hitSound)
            addPoints(value: 1)
            removeRing(node: childNode(withName: "ring") as! SKSpriteNode)
        }
        if contact.bodyA.node?.name == "ring" && contact.bodyB.node?.name == "sub" {
            run(hitSound)
            addPoints(value: 1)
            removeRing(node: childNode(withName: "ring") as! SKSpriteNode)
        }
        if contact.bodyA.node?.name == "sub" && contact.bodyB.node?.name == "mine" {
            run(crashSound)
            health -= 1
            removeRing(node: childNode(withName: "mine") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 33.3
                healthBar.position.x -= 16.7
            }
        }
        if contact.bodyA.node?.name == "mine" && contact.bodyB.node?.name == "sub" {
            run(crashSound)
            health -= 1
            removeRing(node: childNode(withName: "mine") as! SKSpriteNode)
            if let healthBar = childNode(withName: "health") as! SKSpriteNode? {
                healthBar.size.width -= 33.3
                healthBar.position.x -= 16.7
            }
        }
    }


    
}


    
