//
//  AppDelegate.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 23/07/15.
//  Copyright (c) 2015 Paul Fleury. All rights reserved.
//


import Cocoa
import SpriteKit

let serverAddress: CFString = "localhost" as CFString
let serverPort: UInt32 = 5556

var inputStream: InputStream!
var outputStream: OutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Connect to remote serv
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
        inputStream.open()
        outputStream.open()
        
        /* Pick a size for the scene */
        let scene = MenuScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = false
        self.skView!.showsNodeCount = false
        self.skView!.showsPhysics = false
        window.acceptsMouseMovedEvents = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
