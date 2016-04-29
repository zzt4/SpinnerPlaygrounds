//: [Previous](@previous)

import Cocoa

import SpriteKit
import XCPlayground

let sceneSize = CGSize(width: 360.0, height: 360.0)

class MyScene: SKScene {
    var lastUpdateTimeInterval: NSTimeInterval = 0.0
    lazy var center = CGPoint(x: 0.0, y: 0.0)
    lazy var spinnerNode = SKEmitterNode()
    var pixellateFilter = CIFilter(name: "CIPixellate")
    var pixellateAmount = 10.0
    let newFilter = CIFilter(name: "CIGaussianBlur")
    var blurAmount = 0.0
    let blurAmountMax = 40.0
    
    var revolutionsPerSecond = 1.0
    
    let xOffset: CGFloat = 70.0
    let yOffset: CGFloat = 70.0
    
    // countdown starting number
    let countdownStart = 10
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = NSColor.blackColor()
        center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0)
        
        let outerTextNode = SKEffectNode()
        
        let node = SKLabelNode()
        node.verticalAlignmentMode = .Center
        node.horizontalAlignmentMode = .Center
        node.fontSize = 192
        node.color = NSColor.whiteColor()
        
        // create action sequence for scaling
        let easeScaleIn = SKAction.scaleTo(1.1, duration: 0.2)
        
        let easeScaleOut = SKAction.scaleTo(0.0, duration: 0.8)
        
        let scaleInGroup = SKAction.group([
            easeScaleIn,
            SKAction.moveByX(0.0, y: 10.0, duration: 0.2)
            ])
        scaleInGroup.timingMode = .EaseIn
        
        let scaleOutGroup = SKAction.group([
            easeScaleOut,
            SKAction.moveByX(0.0, y: 0.0, duration: 0.8)
            ])
        scaleOutGroup.timingMode = .EaseIn
        
        let scaleSequence = SKAction.sequence([
            scaleInGroup,
            scaleOutGroup
            ])
        
        // create action group for fade out and scale down
        let actionGroup = SKAction.group([
            SKAction.fadeAlphaTo(0, duration: 1.0),
            scaleSequence
            ])
        
        var countdownCurrent = countdownStart
        
        node.text = String(countdownCurrent)
        
        let actionGroupWithBlock = SKAction.sequence([
            actionGroup,
            SKAction.runBlock() {
                node.text = String(--countdownCurrent)
                if countdownCurrent > 0 {
                    self.blurAmount = 0.0
                    self.newFilter!.setValue(self.blurAmount, forKey: "inputRadius")
                    node.setScale(1.0)
                    node.alpha = 1.0
                    node.position = CGPoint(x: 0.0, y: -10.0)
                }
            }
            ])
        
        newFilter!.setDefaults()
        newFilter!.setValue(10.0, forKey: "inputRadius")
        outerTextNode.shouldEnableEffects = true
        outerTextNode.filter = newFilter
        
        var actionArray = [SKAction]()
        
        for _ in 1 ... countdownStart {
            actionArray.append(actionGroupWithBlock)
        }
        
        node.runAction(SKAction.sequence(actionArray))
        
        outerTextNode.addChild(node)
        outerTextNode.position = center
        outerTextNode.setScale(0.5)
        let scaleNumbersAction = SKAction.scaleTo(1.0, duration: NSTimeInterval(countdownStart))
        scaleNumbersAction.timingMode = SKActionTimingMode.EaseOut
        outerTextNode.runAction(scaleNumbersAction)
        self.addChild(outerTextNode)
        
        // create particle spinner
        let spinnerResource = NSBundle.mainBundle().pathForResource("ProgressSpinner", ofType: "sks")
        spinnerNode = NSKeyedUnarchiver.unarchiveObjectWithFile(spinnerResource!) as! SKEmitterNode
        
        let sparksResource = NSBundle.mainBundle().pathForResource("SparkEnd", ofType: "sks")
        let sparksNode = NSKeyedUnarchiver.unarchiveObjectWithFile(sparksResource!)as! SKEmitterNode
        sparksNode.targetNode = self
        
        spinnerNode.targetNode = self
        spinnerNode.addChild(sparksNode)
        let outerNode = SKNode()
        outerNode.position = center
        outerNode.addChild(spinnerNode)
        self.addChild(outerNode)
        
        pixellateFilter = CIFilter(name: "CIPixellate")
        pixellateFilter!.setDefaults()
        pixellateFilter!.setValue(pixellateAmount, forKey: "inputScale")
        self.filter = pixellateFilter
        self.shouldEnableEffects = false
    }
    
    override func update(currentTime: NSTimeInterval) {
        // update particle spinner
        let constant = currentTime * revolutionsPerSecond * 2 * M_PI
        let xPosition = CGFloat(cos(constant)) * (center.x - xOffset)
        let yPosition = CGFloat(sin(constant)) * (center.y - yOffset)
        spinnerNode.position = CGPoint(x: xPosition, y: yPosition)
        if pixellateAmount > 0 {
            pixellateAmount -= pixellateAmount / Double(countdownStart - 1) / 45.0
            pixellateFilter!.setValue(pixellateAmount, forKey: "inputScale")
        } else {
            self.shouldEnableEffects = false
        }
        
        if blurAmount < blurAmountMax {
            blurAmount += 0.4
            newFilter!.setValue(blurAmount, forKey: "inputRadius")
        }
    }
}

var view = SKView(frame:CGRect(x: 0.0, y: 0.0, width: sceneSize.width, height: sceneSize.height))
XCPlaygroundPage.currentPage.liveView = view
//XCPShowView("Pretty Spinner", view: view)
var scene = MyScene(size: sceneSize)
view.showsFPS = false
view.presentScene(scene)

//: [Next](@next)
