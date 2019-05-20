//
//  GameScene.swift
//  NC1
//
//  Created by Johanes Steven on 17/05/19.
//  Copyright © 2019 bejohen. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var player = SKSpriteNode()
    var obstacle = SKSpriteNode()
    var plate = SKSpriteNode()
    var plate2 = SKSpriteNode()
    var x = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        player = self.childNode(withName: "player") as! SKSpriteNode
        //obstacle = self.childNode(withName: "obstacle") as! SKSpriteNode
        plate = self.childNode(withName: "plate") as! SKSpriteNode
        plate2 = self.childNode(withName: "base") as! SKSpriteNode
        
        //x = self.childNode(withName: "bola") as! SKSpriteNode
        //x.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        var firstBody:SKPhysicsBody
//        var secondBody:SKPhysicsBody
//
//        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//        if ((firstBody.categoryBitMask & player.physicsBody!.categoryBitMask) != 0 && (secondBody.categoryBitMask & obstacle.physicsBody!.categoryBitMask) != 0) {
//            collide(player: firstBody.node as! SKSpriteNode, obstacle: secondBody.node as! SKSpriteNode)
//        }
//    }
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "player" {
            collisionBetween(player: nodeA, object: nodeB)
        } else if nodeB.name == "player" {
            collisionBetween(player: nodeB, object: nodeA)
        }
    }
    
    func collisionBetween(player: SKNode, object: SKNode) {
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(x: self.position.x + 1000, duration: 0.5))
        if object.name == "plate" {
            print("collision with plate")
        } else if object.name == "obstacle" {
            print("collision with obstacle")
            object.alpha = 1
        } else if object.name == "trigger" {
            print("collision with trigger")
            let x: Float = Float(plate2.position.x) + 5000
            plate2.run(actionArray[0])
        }
    }
    
    func collide(player:SKSpriteNode, obstacle:SKSpriteNode){
        print("collide success")
    }
    
    func gameOver(){
        if player.position.y < plate.position.y {
            print("you lose")
            player.position = CGPoint(x: -620.127, y: -105.891)
        }
    }
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: location.x, duration: 0.5))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: location.x, duration: 0.5))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        gameOver()
    }
    
}
