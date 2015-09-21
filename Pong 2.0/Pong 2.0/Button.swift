//
//  Button.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 24/07/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKShapeNode {
    var labelText: String = "11"
    var selected = false
    var label = SKLabelNode()
    
    override init() {
        super.init()
    }
    
    init(rectOfSize: CGSize, label:String) {
        self.labelText = label
        super.init()
        self.path = CGPathCreateWithRoundedRect(CGRect(origin: CGPoint.zero, size: rectOfSize), rectOfSize.width / 8, rectOfSize.height / 2, nil)
        self.fillColor = NSColor.blackColor()
        self.strokeColor = NSColor.whiteColor()
        self.lineWidth = 2.7
        
        self.label = SKLabelNode(text: labelText)
        self.label.fontName = "SFUIText-Ultralight"
        self.label.fontSize = 37
        self.label.horizontalAlignmentMode = .Center
        self.label.verticalAlignmentMode = .Center
        self.label.position.x = self.frame.size.width / 2
        self.label.position.y = rectOfSize.height / 2
        self.label.name = labelText
        addChild(self.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(selected: Bool) {
        self.selected = selected
        if selected {
            label.fontColor = NSColor.blackColor()
            self.fillColor = NSColor.whiteColor()
            self.strokeColor = NSColor.blackColor()
        } else {
            label.fontColor = NSColor.whiteColor()
            self.fillColor = NSColor.blackColor()
            self.strokeColor = NSColor.whiteColor()
        }
    }
}