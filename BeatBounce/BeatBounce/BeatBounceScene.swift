//
//  BeatBounceScene.swift
//  BeatBounce
//
//  Created by Akito van Troyer on 4/5/21.
//

import UIKit
import SpriteKit

class BeatBounceScene: SKScene, SKPhysicsContactDelegate {

    let circleRadius:CGFloat = 50
    var isTouchingBall = false
    var touchedBall:SKShapeNode!
    var touchLocation:CGPoint!
    
    let ballCategory: UInt32 = 0x1 << 0    //00000000000000000000000000000001
    let borderCategory: UInt32 = 0x1 << 1    //00000000000000000000000000000010
    
    let audioPlayer = Player()
    var count = 1
    
    override func didMove(to view: SKView) {
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 1
        border.restitution = 1
        self.physicsBody = border
        self.physicsBody?.categoryBitMask = borderCategory
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
    }
    
    //Function for collision detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        if bodyA != nil && (bodyA?.contains("ball"))! {
            audioPlayer.playSound(ball: bodyA!)
        }
        
        if bodyB != nil && (bodyB?.contains("ball"))! {
            audioPlayer.playSound(ball: bodyB!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let body = self.physicsWorld.body(at: location) {
                let name = body.node?.name
                if name != nil && (name?.contains("ball"))! {
                    isTouchingBall = true
                    touchedBall = body.node as? SKShapeNode
                    touchLocation = location
                }
            }
            else {
                createBall(location: CGPoint(x: location.x, y: location.y))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingBall {
            for touch in touches {
                touchLocation = touch.location(in: self)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingBall {
            isTouchingBall = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingBall {
            isTouchingBall = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchingBall {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchLocation.x-touchedBall.position.x, dy: touchLocation.y-touchedBall.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            touchedBall.physicsBody?.velocity = velocity
        }
    }
    
    func createBall(location: CGPoint){
        let ball = SKShapeNode(circleOfRadius: circleRadius)
        ball.position = location
        ball.name = "ball" + String(count)
        count += 1
        ball.strokeColor = SKColor.white
        ball.glowWidth = 4.0
        ball.fillColor = SKColor.init(displayP3Red: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1)
        
        self.addChild(ball)
        
        //Attach physics body to our balls
        ball.physicsBody = SKPhysicsBody(circleOfRadius: circleRadius)

        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.angularDamping = 0

        ball.physicsBody?.applyImpulse(CGVector(dx: random(min: -100, max: 100), dy: random(min: -100, max: 100)))
        
        //Set collision bit mask and tell SpriteKit to detect ball and border collision
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = ballCategory | borderCategory
        
        audioPlayer.linkSound(ball: ball.name!)
    }

    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    func start(){
        audioPlayer.start()
    }
    
    func stop(){
        audioPlayer.stop()
    }
}

