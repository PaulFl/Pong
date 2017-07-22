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
        self.path = CGPath(roundedRect: CGRect(origin: CGPoint.zero, size: rectOfSize), cornerWidth: rectOfSize.width / 8, cornerHeight: rectOfSize.height / 2, transform: nil)
        self.fillColor = NSColor.black
        self.strokeColor = NSColor.white
        self.lineWidth = 2.7
        
        self.label = SKLabelNode(text: labelText)
        self.label.fontName = "SFUIText-Ultralight"
        self.label.fontSize = 37
        self.label.horizontalAlignmentMode = .center
        self.label.verticalAlignmentMode = .center
        self.label.position.x = self.frame.size.width / 2
        self.label.position.y = rectOfSize.height / 2
        self.label.name = labelText
        addChild(self.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(_ selected: Bool) {
        self.selected = selected
        if selected {
            label.fontColor = NSColor.black
            self.fillColor = NSColor.white
            self.strokeColor = NSColor.black
        } else {
            label.fontColor = NSColor.white
            self.fillColor = NSColor.black
            self.strokeColor = NSColor.white
        }
    }
}
