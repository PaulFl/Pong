//
//  GameScene.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 23/07/15.
//  Copyright (c) 2015 Paul Fleury. All rights reserved.
//

import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let racketSize = CGSize(width: 30, height: 135)
let ballRadius: CGFloat = 13

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Player   : UInt32 = 0b1
    static let Ball     : UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    //Create nodes
    let player1 = Racket(ellipseOfSize: racketSize)
    let player2 = Racket(ellipseOfSize: racketSize)
    let ball = Ball(circleOfRadius: ballRadius)
    var scoreLabel = SKLabelNode()
    
    var velocity = CGVector()
    var numberOfPoints: Int
    
    init(size: CGSize, matchLenght: Int) {
        numberOfPoints = matchLenght
        super.init(size: size)
        ball.position = CGPoint(x: self.size.width / 2 - ball.frame.size.width / 2, y: self.size.height / 2 - ball.frame.size.width / 2)
        
        player1.zPosition = 1
        player2.zPosition = 1
        ball.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor.white
        
        //Add players and ball to the scene
        addChild(player1)
        addChild(player2)
        addChild(ball)
        
        //Create score label and add it to the scene
        scoreLabel.text = "\(player1.score) | \(player2.score)"
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - scoreLabel.frame.size.height)
        scoreLabel.fontColor = NSColor.black
        scoreLabel.fontSize = 50
        addChild(scoreLabel)
        
        //World physics
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        
        //Launch game
        newPoint()
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        //Pause & menu buttons coming soon?
        
        //let location = theEvent.locationInNode(self)
    }
    
    override func keyDown(with theEvent: NSEvent) {
        handleKeyEvent(theEvent, keyDown: true)
    }
    
    override func keyUp(with theEvent: NSEvent) {
        handleKeyEvent(theEvent, keyDown: false)
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Create array with the players -> same actions on both players in for loop
        let players = [player1, player2]
        
        //Direction of the playr's racket
        var direction: CGFloat
        
        for player in players {
            if (player.movingDown != player.movingUp) { //If player is moving (either up or down)
                if Date().timeIntervalSinceReferenceDate - player.pastTime > TimeInterval(0.05) { //Racket speed acceleration
                    player.movingSpeed += 1
                    player.pastTime = Date().timeIntervalSinceReferenceDate
                }
                if player.movingUp {
                    direction = 1
                } else {
                    direction = -1
                }
                //Move the racket
                player.run(SKAction.moveBy(x: 0, y: sqrt(player.movingSpeed) * 3 * direction, duration: 0.1))
            }
            //Remote move
            if player.remoteSpeed != 0 {
                var remoteDirection: Int
                if player.remoteSpeed > 0 {
                    remoteDirection = 1
                } else {
                    remoteDirection = -1
                }
                let remoteSpeed = CGFloat(abs(player.remoteSpeed)) / CGFloat(100)
                player.run(SKAction.moveBy(x: 0, y: sqrt(remoteSpeed) * 3 * CGFloat(remoteDirection), duration: 0.1))
            }
            
            //Prevent the player from going out of the screen
            keepPlayerInScreen(player)
        }
        //Check if someone won the point
        isPointFinished()
        
        //Remote -- SO DIRTY BUT IT WORKS... Spent a whole day on this
        var values = [Int]()
        var isNegative = false
        while (inputStream.hasBytesAvailable){
            var buffer = [UInt8](repeating: 0, count: MemoryLayout<Int>.size)
            let len = inputStream.read(&buffer, maxLength: 1)
            if(len > 0){
                let input = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                if (input != nil){
                    if input!.contains("a") {
                        var theFinalValue = Int()
                        switch values.count {
                        case 3:
                            theFinalValue = values[0] * 100 + values[1] * 10 + values[2]
                        case 2:
                            theFinalValue = values[0] * 10 + values[1]
                        case 1:
                            theFinalValue = values[0]
                        default: break
                        }
                        if isNegative {
                            theFinalValue = -theFinalValue
                        }
                        player1.remoteSpeed = CGFloat(theFinalValue)
                        values.removeAll()
                        isNegative = false
                    } else if input!.contains("b"){
                        var theFinalValue = Int()
                        switch values.count {
                        case 3:
                            theFinalValue = values[0] * 100 + values[1] * 10 + values[2]
                        case 2:
                            theFinalValue = values[0] * 10 + values[1]
                        case 1:
                            theFinalValue = values[0]
                        default: break
                        }
                        if isNegative {
                            theFinalValue = -theFinalValue
                        }
                        player2.remoteSpeed = CGFloat(theFinalValue)
                        values.removeAll()
                        isNegative = false
                    } else if input!.contains("-") {
                        isNegative = true
                    } else {
                        values.append(input!.integerValue)
                    }
                }
            }
        }
    }
    
    func handleKeyEvent(_ event:NSEvent, keyDown:Bool) {
        //Get the key
        if let key = event.charactersIgnoringModifiers?.unicodeScalars.first!.value {
            //Get racket direction and reset speed if direction changed
            switch Int(key) {
            case NSUpArrowFunctionKey:
                player2.movingUp = keyDown
                if !keyDown {
                    player2.movingSpeed = 2
                }
            case NSDownArrowFunctionKey:
                player2.movingDown = keyDown
                if !keyDown {
                    player2.movingSpeed = 2
                }
            case 122:
                player1.movingUp = keyDown
                if !keyDown {
                    player1.movingSpeed = 2
                }
            case 115:
                player1.movingDown = keyDown
                if !keyDown {
                    player1.movingSpeed = 2
                }
            default: break
            }
        }
    }
    
    func keepPlayerInScreen(_ player: Racket) {
        if player.position.y > self.size.height - player.frame.size.height {
            player.position.y = self.size.height - player.frame.size.height
            player.movingSpeed = 0
        } else if player.position.y < 0 {
            player.position.y = 0
            player.movingSpeed = 0
        }
    }
    
    func isPointFinished() {
        if ball.position.x < 10 {
            player2.score += 1
            if player2.score == numberOfPoints {
                let scene = EndMenuScene(size: self.size, winPlayer: 2)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.6))
                
            }
            newPoint()
        } else if ball.position.x + ball.frame.size.width > self.size.width - 10 {
            player1.score += 1
            if player1.score == numberOfPoints {
                let scene = EndMenuScene(size: self.size, winPlayer: 1)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.6))
            }
            newPoint()
        }
    }
    
    func ballDidHitRacket() {
        //Check on which side did the collision happen
        if ball.physicsBody?.velocity.dx > 0 {
            //Getting the ball position in the racket (divised in  parts)
            let ballXPositionInRacket = (ball.position.y + ball.frame.size.height / 2 - player1.position.y) / player1.frame.size.height
            //Apply  direction regarding ball's position on the racket
            if ballXPositionInRacket < 1/5 {
                velocity.dx = 214.28
                velocity.dy = -285.71
            } else if ballXPositionInRacket < 2/5 {
                velocity.dx = 357.14
                velocity.dy = -214.28
            } else if ballXPositionInRacket < 3/5 {
                velocity.dx = 500
                velocity.dy = 0
                //If ball is centered, then accelerate the ball
                ball.movingSpeed += 1
            } else if ballXPositionInRacket < 4/5 {
                velocity.dx = 357.14
                velocity.dy = 214.28
            } else {
                velocity.dx = 214.28
                velocity.dy = 285.71
            }
        } else {
            let ballXPositionInRacket = (ball.position.y + ball.frame.size.height / 2 - player2.position.y) / player2.frame.size.height
            if ballXPositionInRacket < 1/5 {
                velocity.dx = -214.28
                velocity.dy = -285.71
            } else if ballXPositionInRacket < 2/5 {
                velocity.dx = -357.14
                velocity.dy = -214.28
            } else if ballXPositionInRacket < 3/5 {
                velocity.dx = -500
                velocity.dy = 0
                ball.movingSpeed += 1
            } else if ballXPositionInRacket < 4/5 {
                velocity.dx = -357.14
                velocity.dy = 214.28
            } else {
                velocity.dx = -214.28
                velocity.dy = 285.71
            }
        }
        //Apply direction, speed and acceleration to the ball
        ball.physicsBody?.velocity = velocity
        ball.physicsBody?.velocity.dx *= sqrt(ball.movingSpeed)/1.4
        ball.physicsBody?.velocity.dy *= sqrt(ball.movingSpeed)/1.4
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ball != 0)) {
                ballDidHitRacket()
        }
    }
    
    func newPoint() {
        let randomBool: Bool = arc4random_uniform(2) == 1
        let direction = (randomBool ? -1.0 : 1.0)
        scoreLabel.text = "\(player1.score) | \(player2.score)"
        player1.position = CGPoint(x: 0, y: self.size.height/2 - player1.frame.size.height/2)
        player2.position = CGPoint(x: self.size.width - player2.frame.size.width + 3, y: self.size.height/2 - player2.frame.size.height/2)
        ball.movingSpeed = 2
        ball.position = CGPoint(x: self.size.width / 2 - ball.frame.size.width / 2, y: self.size.height / 2 - ball.frame.size.width / 2)
        ball.physicsBody?.velocity = CGVector(dx: 250 * direction, dy: 0)
    }
}
