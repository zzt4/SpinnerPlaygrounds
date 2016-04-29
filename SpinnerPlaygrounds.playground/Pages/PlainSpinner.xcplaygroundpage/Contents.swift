//: [Previous](@previous)
// Playground - noun: a place where people can play

import Cocoa

import SpriteKit
import XCPlayground

let sceneSize = CGSize(width: 480.0, height: 480.0)

enum rotationDirection {
    case ClockWise
    case CounterClockWise
}

class MyScene: SKScene {
    let outerTotalSegments = 60
    let innerTotalSegments = 12
    
    let outerWheelSegmentSize = CGSize(width: 5, height: 15)
    let innerWheelSegmentSize = CGSize(width: 10, height: 43)//10,43
    
    let lowestAlpha: CGFloat = 0.1
    let highestAlpha: CGFloat = 1.0
    
    let totalSpinTime = 1.0
    
    let outerWheelColor = NSColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
    let innerWheelColor = NSColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
    
    let outerWheelRotationDirection = rotationDirection.ClockWise
    let innerWheelRotationDirection = rotationDirection.ClockWise
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = NSColor.blackColor()
        
        let sceneSize = view.frame.size
        let center = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        
        // set fade in/out times for outer circle
        let fadeInTime = totalSpinTime / Double(outerTotalSegments)
        let fadeOutTime = totalSpinTime / Double(outerTotalSegments) + 0.8
        
        // set fade in/out times for inner circle
        let fadeInTimeInner = totalSpinTime / Double(innerTotalSegments)
        let fadeOutTimeInner = totalSpinTime / Double(innerTotalSegments) + 0.8
        
        let outerWheelDirection = outerWheelRotationDirection == rotationDirection.ClockWise ? 1.0 : -1.0
        
        // create the outer wheel
        for index in 0 ..< outerTotalSegments {
            let currentSegment = SKSpriteNode(color: outerWheelColor, size: CGSize(width: outerWheelSegmentSize.width, height: outerWheelSegmentSize.height))
            // set initial alpha
            currentSegment.alpha = 0.2
            
            // set position and rotation of each segment
            let segmentRatio: CGFloat = CGFloat(index) / CGFloat(outerTotalSegments)
            let constant = 2 * outerWheelDirection * M_PI
            let constant2 = 2 * outerWheelDirection * M_PI * Double(segmentRatio)
            let x_position = center.x + CGFloat(Double(center.x - 34.0) * sin(constant2))
            let y_position = center.y + CGFloat(Double(center.y - 34.0) * cos(constant2))
            currentSegment.position = CGPoint(x: x_position, y: y_position)
            currentSegment.zRotation = segmentRatio * CGFloat(-constant)
            
            // set fade times and wait time for next fade in
            let actions = [
                SKAction.fadeAlphaTo(highestAlpha, duration: fadeInTime),
                SKAction.fadeAlphaTo(lowestAlpha, duration: fadeOutTime),
                SKAction.waitForDuration(NSTimeInterval(totalSpinTime - (fadeInTime + fadeOutTime) ))
            ]
            // set fade in time for initial fade
            let actionSequence = [
                SKAction.waitForDuration((Double(index) / Double(outerTotalSegments))),
                SKAction.repeatActionForever(SKAction.sequence(actions))
            ]
            // add actions to the segment
            currentSegment.runAction(SKAction.sequence(actionSequence))
            
            self.addChild(currentSegment)
        }
        
        
        let innerWheelDirection = innerWheelRotationDirection == rotationDirection.ClockWise ? 1.0 : -1.0
        
        // create the inner wheel
        for index in 0 ..< innerTotalSegments {
            let currentSegment = SKSpriteNode(color: innerWheelColor, size: CGSize(width: innerWheelSegmentSize.width, height: innerWheelSegmentSize.height))
            // set initial alpha
            currentSegment.alpha = 0.2
            
            // set position and rotation of each segment
            let segmentRatio: CGFloat = CGFloat(index) / CGFloat(innerTotalSegments)
            let constant = 2 * innerWheelDirection * M_PI
            let constant2 = 2 * innerWheelDirection * M_PI * Double(segmentRatio)
            let x_position = center.x + CGFloat(Double(center.x - 48.0) * sin(constant2))
            let y_position = center.y + CGFloat(Double(center.y - 48.0) * cos(constant2))
            currentSegment.position = CGPoint(x: x_position, y: y_position)
            currentSegment.zRotation = segmentRatio * CGFloat(-constant)
            
            // set fade times and wait time for next fade in
            let actions = [
                SKAction.fadeAlphaTo(highestAlpha, duration: fadeInTimeInner),
                SKAction.fadeAlphaTo(lowestAlpha, duration: fadeOutTimeInner),
                SKAction.waitForDuration(NSTimeInterval(totalSpinTime - (fadeInTimeInner + fadeOutTimeInner) ))
            ]
            // set fade in time for initial fade
            let actionSequence = [
                SKAction.waitForDuration((Double(index) / Double(innerTotalSegments))),
                SKAction.repeatActionForever(SKAction.sequence(actions))
            ]
            
            // add actions to the segment
            currentSegment.runAction(SKAction.sequence(actionSequence))
            
            self.addChild(currentSegment)
        }
    }
}

var view = SKView(frame:CGRect(x: 0.0, y: 0.0, width: sceneSize.width, height: sceneSize.height))
XCPlaygroundPage.currentPage.liveView = view
//XCPShowView("View", view: view)
var scene = MyScene(size: sceneSize)
view.showsFPS = false
view.presentScene(scene)
//scene.backgroundColor = NSColor.blackColor()

//: [Next](@next)
