//
//  MenuScene.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 24/07/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {    
    let buttonSize = CGSize(width: 250, height: 60)
    var points11 = Button()
    var points21 = Button()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor.white
        
        //Setup buttons
        points11 = Button(rectOfSize: buttonSize, label: "11 points")
        points21 = Button(rectOfSize: buttonSize, label: "21 points")
        points11.position.y = self.size.height / 3 - points11.frame.size.height / 2
        points21.position.y = points11.position.y
        points11.position.x = self.size.width / 4 - points11.frame.size.width / 2
        points21.position.x = self.size.width * 3 / 4 - points21.frame.size.width / 2
        points11.zPosition = 1
        points21.zPosition = 1
        points11.name = "11 points"
        points21.name = "21 points"
        
        //Setup label
        let titleLabel = SKLabelNode(text: "Pong 2.0")
        titleLabel.fontSize = 80
        titleLabel.fontColor = NSColor.black
        titleLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 + titleLabel.frame.size.height)
        
        addChild(points11)
        addChild(points21)
        addChild(titleLabel)
    }
    
    override func mouseMoved(with theEvent: NSEvent) {
        let location = theEvent.location(in: self)
        let node = self.atPoint(location)
        if let name = node.name {
            if name == points11.name && !points11.selected {
                points11.selected(true)
            } else if name == points21.name && !points21.selected {
                points21.selected(true)
            }
        } else {
            if points11.selected {
                points11.selected(false)
            } else if points21.selected {
                points21.selected(false)
            }
        }
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        var points: Int?
        let location = theEvent.location(in: self)
        let node = self.atPoint(location)
        if let _ = node.name {
            if node.name == points11.name {
                points = 11
            } else if node.name == points21.name {
                points = 21
            }
            launchGame(points!)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        while (inputStream.hasBytesAvailable){
            var buffer = [UInt8](repeating: 0, count: 4096)
            let len = inputStream.read(&buffer, maxLength: buffer.count)
            if(len > 0){
                let input = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                if (input != "" && input != nil){
                    if input!.contains("left") {
                        points11.selected(true)
                        points21.selected(false)
                    } else if input!.contains("right") {
                        points11.selected(false)
                        points21.selected(true)
                    } else if input!.contains("enter") {
                        if points11.selected {
                            launchGame(11)
                        } else if points21.selected {
                            launchGame(21)
                        }
                    }
                }
            }
        }
    }
    
    func launchGame(_ points: Int) {
        let scene = GameScene(size: self.size, matchLenght: points)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.6))
    }
}
