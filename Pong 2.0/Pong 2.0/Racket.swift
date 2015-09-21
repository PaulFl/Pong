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
    var pastTime = NSTimeInterval()
    
    init(ellipseOfSize size: CGSize) {
        super.init()
        self.path = CGPathCreateWithEllipseInRect(CGRect(origin: CGPoint.zero, size: size), nil)
        self.fillColor = NSColor.blackColor()
        self.strokeColor = NSColor.blackColor()
        
        self.physicsBody = SKPhysicsBody(polygonFromPath: self.path!)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        pastTime = NSDate().timeIntervalSinceReferenceDate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}