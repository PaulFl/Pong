//
//  Racket.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 23/07/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Foundation
import SpriteKit

class Racket: SKShapeNode {
    var movingUp = false
    var movingDown = false
    var movingSpeed: CGFloat = 2
    var remoteSpeed: CGFloat = 0
    var score:Int = 0
    var pastTime = TimeInterval()
    
    init(ellipseOfSize size: CGSize) {
        super.init()
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: size), transform: nil)
        self.fillColor = NSColor.black
        self.strokeColor = NSColor.black
        
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        pastTime = Date().timeIntervalSinceReferenceDate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
