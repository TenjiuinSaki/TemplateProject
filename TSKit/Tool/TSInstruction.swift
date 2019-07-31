//
//  TSInstruction.swift
//  JunxinSecurity
//
//  Created by mc on 2019/5/29.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit
import Instructions

struct TSMark {
    let view: UIView
    let tip: String
}

class TSInstruction: CoachMarksControllerDataSource {
    let coachMarksCtrl = CoachMarksController()
    
    var marks = [TSMark]()
    
    init() {
        coachMarksCtrl.overlay.allowTap = true
        coachMarksCtrl.dataSource = self
//        coachMarksCtrl.delegate = self
        coachMarksCtrl.overlay.color = UIColor.black.withAlphaComponent(0.6)
        
//        let skipView = TSMarkSkipView()
//        coachMarksCtrl.skipView = skipView
//        skipView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.equalTo(220.em)
//            $0.height.equalTo(50.em)
//        }
    }
    
    func start(marks: [TSMark], vc: UIViewController) {
        self.marks = marks
        coachMarksCtrl.start(in: .window(over: vc))
    }
    
//    标记数量
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return marks.count
    }
//    标记视图
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        let view = marks[index].view
        let mark = coachMarksController.helper.makeCoachMark(for: view, pointOfInterest: nil) { (rect: CGRect) -> UIBezierPath in
            return UIBezierPath(arcCenter: rect.center, radius: 30, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        return mark
    }
//    提示信息，箭头
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let body = TSMarkBodyView()
        body.tipLabel.attributeText = marks[index].tip
        
        var arrow: TSMarkArrowView? = nil
        if let orientation = coachMark.arrowOrientation {
            arrow = TSMarkArrowView(orientation: orientation)
        }
        
        return (bodyView: body, arrowView: arrow)
    }
    
//    func coachMarksController(_ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint]? {
//        let hlc = NSLayoutConstraint(item: skipView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: -20)
//        let vlc = NSLayoutConstraint(item: skipView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: -150)
//        return [hlc, vlc]
//    }
}


class TSMarkBodyView: UIControl, CoachMarkBodyView {
    var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?
    
    var nextControl: UIControl? {
        get {
            return self
        }
    }
    
    var tipLabel = TSAttributeLabel()
    convenience init() {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tipLabel.font = 24.font("BoLeYouHuati")
        tipLabel.color = UIColor.white
        tipLabel.lineSpacing = 5
    }
}

class TSMarkArrowView: TSImageView, CoachMarkArrowView {
    init(orientation: CoachMarkArrowOrientation) {
        super.init(frame: .zero)
        
        let circle = TSImageView()
        circle.setImage(.mark_circle)
        addSubview(circle)
        if orientation == .top {
            setImage(.bottom_arrow)
            circle.snp.makeConstraints {
                $0.width.height.equalTo(80)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(self.snp.top).offset(8)
            }
        } else {
            setImage(.top_arrow)
            circle.snp.makeConstraints {
                $0.width.height.equalTo(80)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.snp.bottom).offset(-8)
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TSMarkSkipView: UIButton, CoachMarkSkipView {
    var skipControl: UIControl? {
        return self
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 150.em, height: 60.em))
        
        image = TSAssets.btn_skip.image
        translatesAutoresizingMaskIntoConstraints = false
    }
}
