//
//  AppDelegate.swift
//  Pong 2.0
//
//  Created by Paul Fleury on 23/07/15.
//  Copyright (c) 2015 Paul Fleury. All rights reserved.
//


import Cocoa
import SpriteKit

let serverAddress: CFString = "localhost"
let serverPort: UInt32 = 5556

var inputStream: NSInputStream!
var outputStream: NSOutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        //Connect to remote serv
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
        
        /* Pick a size for the scene */
        let scene = MenuScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = false
        self.skView!.showsNodeCount = false
        self.skView!.showsPhysics = false
        window.acceptsMouseMovedEvents = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
