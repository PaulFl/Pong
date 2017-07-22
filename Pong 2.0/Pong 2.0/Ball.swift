//
//  Ball.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 23/07/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKShapeNode {
    var movingSpeed: CGFloat = 1
    
    init(circleOfRadius: CGFloat) {
        super.init()
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: circleOfRadius * 2, height: circleOfRadius * 2)), transform: nil)
        self.fillColor = NSColor.black
        self.strokeColor = NSColor.black

        self.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius, center: CGPoint(x: self.frame.size.width / 2 - 2, y: self.frame.size.height / 2 - 2))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
