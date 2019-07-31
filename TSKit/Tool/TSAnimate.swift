//
//  TSAnimate.swift
//  TSKit
//
//  Created by mc on 2018/9/11.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
import UIKit
import Spruce

enum TSAnimationType: String {
    // Positions
    case position = "position"
    case positionX = "position.x"
    case positionY = "position.y"
    // Transforms
    case transform  = "transform"
    case rotation  = "transform.rotation"
    case rotationX = "transform.rotation.x"
    case rotationY = "transform.rotation.y"
    case rotationZ = "transform.rotation.z"
    case scale  = "transform.scale"
    case scaleX = "transform.scale.x"
    case scaleY = "transform.scale.y"
    case scaleZ = "transform.scale.z"
    case translation  = "transform.translation"
    case translationX = "transform.translation.x"
    case translationY = "transform.translation.y"
    case translationZ = "transform.translation.z"
    // Stroke
    case strokeEnd = "strokeEnd"
    case strokeStart = "strokeStart"
    // Other properties
    case opacity = "opacity"
    case path = "path"
    case lineWidth = "lineWidth"
}

extension CAKeyframeAnimation {
    convenience init(type: TSAnimationType) {
        self.init(keyPath: type.rawValue)
    }
}

extension CABasicAnimation {
    convenience init(type: TSAnimationType) {
        self.init(keyPath: type.rawValue)
    }
}

extension UIView {
    func springPop() {
        let animation = CASpringAnimation(type: .scale)
        animation.initialVelocity = 20       // 初始速度-20~20
        animation.stiffness = 250      // 弹性默认100,增加刚度可以减少振荡次数并减少沉降时间。
        animation.duration = animation.settlingDuration    // 动画时长
        animation.fromValue = 1.15
        animation.toValue = 1
        layer.add(animation, forKey: nil)
    }
    
    func flash() {
        let animation = CAKeyframeAnimation(type: .opacity)
        animation.values = [0, 1, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 1
        layer.add(animation, forKey: nil)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(type: .positionX)
        let centerX = center.x
        animation.values = [centerX, centerX + 20, centerX - 20, centerX + 20, centerX]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0, 0.4, 1)
        animation.duration = 0.8
        layer.add(animation, forKey: nil)
    }
    
    func swing() {
        let animation = CAKeyframeAnimation(type: .rotation)
        animation.values = [0, 0.1, -0.1, 0.1 , 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.duration = 0.8
        layer.add(animation, forKey: nil)
    }
    
    func morph() {
        let morphX = CAKeyframeAnimation(type: .scaleX)
        morphX.values = [1, 1.1, 0.9, 1.1 , 1]
        morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        let morphY = CAKeyframeAnimation(type: .scaleY)
        morphY.values = [1, 0.9, 1.1, 0.9, 1]
        morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [morphX, morphY]
        animationGroup.duration = 0.6
        layer.add(animationGroup, forKey: nil)
    }
    
    func pop() {
        let animation = CAKeyframeAnimation(type: .scale)
        animation.values = [1, 1.1, 0.9, 1.1, 1]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.duration = 0.6
        layer.add(animation, forKey: nil)
    }
    
    func slideIn(direction: SlideDirection, spring: Bool) {
        let animations: [StockAnimation] = [.slide(direction, .severely), .fadeIn]
        spruce.prepare(with: animations)
        let sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.05)
        if spring {
            spruce.animate(animations, animationType: SpringAnimation(duration: 0.7), sortFunction: sortFunction)
        } else {
            spruce.animate(animations, animationType: StandardAnimation(duration: 0.5), sortFunction: sortFunction)
        }
    }
    
    func fadeIn() {
        let animations: [StockAnimation] = [.fadeIn]
        spruce.prepare(with: animations)
        let sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.05)
        spruce.animate(animations, animationType: StandardAnimation(duration: 0.5), sortFunction: sortFunction)
    }
    
    func start(animate: CAAnimation) {
        animate.isRemovedOnCompletion = false
        animate.fillMode = .forwards
        layer.add(animate, forKey: nil)
    }
}
