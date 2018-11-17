//
//  GameScene.swift
//  Pong remote
//
//  Created by Paul Fleury on 27/07/15.
//  Copyright (c) 2015 Paul Fleury. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, AnalogStickProtocol {
    let moveAnalogStick: AnalogStick = AnalogStick(thumbImage: UIImage(named: "Thumb"), bgImage: UIImage(named: "Background"))
    var playerSelection = SKSpriteNode(imageNamed: "Player1")
    
    var selectedPlayer = 1
    
    override func didMove(to view: SKView) {
        //Connect to remote serv
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
        inputStream.open()
        outputStream.open()
        
        
        self.backgroundColor = SKColor.white
        
        //Joystick
        let bgDiametr: CGFloat = 250
        let thumbDiametr: CGFloat = 120
        let joysticksRadius = bgDiametr / 2
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPoint(x: joysticksRadius + 70, y: bgDiametr + 100)
        moveAnalogStick.delegate = self
        self.addChild(moveAnalogStick)
        
        
        //Gamepad
        let space: CGFloat = 30
        let size: CGFloat = 1.3
        
        let enter = SKSpriteNode(imageNamed: "Enter")
        enter.position.x = self.size.width - enter.size.width * 2
        enter.position.y = self.size.height / 2
        enter.name = "enter"
        enter.xScale = size
        enter.yScale = size
        self.addChild(enter)
        
        let left = SKSpriteNode(imageNamed: "Left")
        left.position.y = enter.position.y
        left.position.x = enter.position.x - enter.size.width + space
        left.name = "left"
        left.xScale = size
        left.yScale = size
        self.addChild(left)
        
        let right = SKSpriteNode(imageNamed: "Right")
        right.position.y = enter.position.y
        right.position.x = enter.position.x + enter.size.width - space
        right.name = "right"
        right.xScale = size
        right.yScale = size
        self.addChild(right)
        
        let up = SKSpriteNode(imageNamed: "Up")
        up.position.x = enter.position.x
        up.position.y = enter.position.y + enter.size.height - space
        up.name = "up"
        up.xScale = size
        up.yScale = size
        self.addChild(up)
        
        let down = SKSpriteNode(imageNamed: "Down")
        down.position.x = enter.position.x
        down.position.y = enter.position.y - enter.size.height + space
        down.name = "down"
        down.xScale = size
        down.yScale = size
        self.addChild(down)
        
        //PlayerSelection
        playerSelection.position.x = self.size.width/2 - playerSelection.size.height
        playerSelection.position.y = self.size.height - 2*playerSelection.size.height
        playerSelection.name = "playerSelection"
        self.addChild(playerSelection)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        if let _ = node.name {
            node.alpha = 0.5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        if let _ = node.name {
            if node.name != playerSelection.name {
                node.alpha = 1
                sendData(node.name!)
            } else if node.name == playerSelection.name {
                if selectedPlayer == 1 {
                    selectedPlayer = 2
                } else {
                    selectedPlayer = 1
                }
                node.alpha = 1
                playerSelection.texture = SKTexture(imageNamed: "Player\(selectedPlayer)")
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func sendData(_ string: String) {
        var string = string
        if selectedPlayer == 1 {
            string += "a"
        } else {
            string += "b"
        }
        let data = string.data(using: String.Encoding.utf8)
        if outputStream.write((data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count) == -1 {
        }
    }
    
    func moveAnalogStick(_ analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        if analogStick.isEqual(moveAnalogStick) {
            let ySpeed: Int = Int(velocity.y) * 5
            sendData(String(ySpeed))
        }
    }
}
