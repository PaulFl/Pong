//
//  EndMenu.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 24/07/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Foundation
import SpriteKit

class EndMenuScene: SKScene {
    let buttonSize = CGSize(width: 300, height: 65)
    var endGameButton = Button()
    var newGameButton = Button()
    var winPlayer: Int
    
    init(size: CGSize, winPlayer: Int) {
        self.winPlayer = winPlayer
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = NSColor.whiteColor()
        
        let winPlayerLabel = SKLabelNode(text: "Player \(winPlayer) won !")
        winPlayerLabel.fontSize = 50
        winPlayerLabel.fontColor = NSColor.blackColor()
        winPlayerLabel.position.x = self.size.width / 2
        winPlayerLabel.position.y = self.size.height - winPlayerLabel.frame.size.height * 3
        
        endGameButton = Button(rectOfSize: buttonSize, label: "End Game")
        newGameButton = Button(rectOfSize: buttonSize, label: "New Game")
        
        endGameButton.position.x = self.size.width / 2 - endGameButton.frame.size.width / 2
        newGameButton.position.x = self.size.width / 2 - newGameButton.frame.size.width / 2
        newGameButton.position.y = self.size.height * 3 / 6
        endGameButton.position.y = self.size.height / 5
        
        newGameButton.zPosition = 1
        endGameButton.zPosition = 1
        
        newGameButton.name = "New Game"
        endGameButton.name = "End Game"
        
        addChild(endGameButton)
        addChild(newGameButton)
        addChild(winPlayerLabel)
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if let name = node.name {
            if name == newGameButton.name && !newGameButton.selected {
                newGameButton.selected(true)
            } else if name == endGameButton.name && !endGameButton.selected {
                endGameButton.selected(true)
            }
        } else {
            if newGameButton.selected {
                newGameButton.selected(false)
            } else if endGameButton.selected {
                endGameButton.selected(false)
            }
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if let _ = node.name {
            if node.name == newGameButton.name {
                let scene = MenuScene(size: self.size)
                scene.scaleMode = .AspectFill
                self.view?.presentScene(scene, transition: SKTransition.fadeWithDuration(0.6))
            } else if node.name == endGameButton.name {
                exit(EXIT_SUCCESS)
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        while (inputStream.hasBytesAvailable){
            var buffer = [UInt8](count: 4096, repeatedValue: 0)
            let len = inputStream.read(&buffer, maxLength: buffer.count)
            if(len > 0){
                let input = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                if (input != "" && input != nil){
                    if input!.containsString("up") {
                        newGameButton.selected(true)
                        endGameButton.selected(false)
                    } else if input!.containsString("down") {
                        newGameButton.selected(false)
                        endGameButton.selected(true)
                    } else if input!.containsString("enter") {
                        if newGameButton.selected {
                            let scene = MenuScene(size: self.size)
                            scene.scaleMode = .AspectFill
                            self.view?.presentScene(scene, transition: SKTransition.fadeWithDuration(0.6))
                        } else if endGameButton.selected {
                            exit(EXIT_SUCCESS)
                        }
                    }
                }
            }
        }
    }
}