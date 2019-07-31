//
//  TSView.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *                    .::::.
 *                  .::::::::.
 *                 :::::::::::
 *             ..:::::::::::'
 *           '::::::::::::'
 *             .::::::::::
 *        '::::::::::::::..
 *             ..::::::::::::.
 *           ``::::::::::::::::
 *            ::::``:::::::::'        .:::.
 *           ::::'   ':::::'       .::::::::.
 *         .::::'      ::::     .:::::::'::::.
 *        .:::'       :::::  .:::::::::' ':::::.
 *       .::'        :::::.:::::::::'      ':::::.
 *      .::'         ::::::::::::::'         ``::::.
 *  ...:::           ::::::::::::'              ``::.
 * ```` ':.          ':::::::::'                  ::::..
 *                    '.:::::'                    ':'````..
 */

import UIKit

class TSView: UIView {
    
    
    convenience init() {
        self.init(frame: .zero)
        color = ts.color.view
        onInit()
    }
    
    func onInit() {}
    
    var color: UIColor {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor ?? UIColor.clear
        }
    }
}


class TSLabel: UILabel, TSLocalize {
    @objc func setLocalizeText() {
        if let words = words {
            text = words.local
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        font = 15.light
        textColor = ts.color.text
        textAlignment = .center
        receiveNotice(.language, action: #selector(setLocalizeText))
    }
    
    func leftAlignment() {
        textAlignment = .left
    }
    
    func rightAlignment() {
        textAlignment = .right
    }
    
    deinit {
        rejectNotice()
    }
    
    var words: String? {
        willSet {
            text = newValue?.local
        }
    }
    
    convenience init(text: String) {
        self.init()
        self.words = text
        setLocalizeText()
    }
}

class TSAttributeLabel: UILabel {
    let para = NSMutableParagraphStyle()
    var lineSpacing: CGFloat {
        set {
            para.lineSpacing = newValue
        }
        get {
            return para.lineSpacing
        }
    }
    
    var paraSpacing: CGFloat {
        set {
            para.paragraphSpacing = newValue
        }
        get {
            return para.paragraphSpacing
        }
    }
    
    var firstLineHeadIndent: CGFloat {
        set {
            para.firstLineHeadIndent = newValue
        }
        get {
            return para.firstLineHeadIndent
        }
    }
    
    var alignment: NSTextAlignment {
        set {
            para.alignment = newValue
        }
        get {
            return para.alignment
        }
    }
    
    var attributeText: String = "" {
        didSet {
            attributedText = NSAttributedString(string: attributeText.local, attributes: [
                .paragraphStyle: para,
                .font: font,
                .foregroundColor: textColor
                ])
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        para.lineBreakMode = .byTruncatingTail
        font = 15.light
        textColor = ts.color.text
        numberOfLines = 0
    }
    
}

class TSImageView: UIImageView, TSImageable {
    convenience init() {
        self.init(frame: .zero)
        contentMode = .scaleAspectFit
        color = ts.color.text
    }
    
    func setImage(_ image: UIImage, with color: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.color = color
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
}

class TSButton: UIButton, TSImageable, TSLocalize {
    
    let activityView = UIView()
    
    var title: String? {
        willSet {
            setTitle(newValue?.local, for: .normal)
        }
    }
    
    convenience init() {
        self.init(type: .custom)
        adjustsImageWhenHighlighted = false
        clearColor()
        font = 15.light
        receiveNotice(.language, action: #selector(setLocalizeText))
        
        addSubview(activityView)
        activityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityView.isHidden = true
    }
    
    deinit {
        rejectNotice()
    }
    
    @objc func setLocalizeText() {
        if let title = title {
            setTitle(title.local, for: .normal)
        }
    }
    
    func verticalLayout() {
        imageView?.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        imageView?.contentMode = .center
        
        titleLabel?.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.55)
        }
        titleLabel?.textAlignment = .center
    }
    
    var spacing: Int {
        set {
            let offset = (newValue / 2).em
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
        }
        get {
            return 0
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            if let bgColor = backgroundColor {
                activityView.backgroundColor = bgColor
                if bgColor.isDark {
                    color = UIColor.white
                } else {
                    color = UIColor.black
                }
            }
        }
    }
    
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if backgroundColor!.isDark {
            activity.style = .white
        } else {
            activity.style = .gray
        }
        activityView.addSubview(activity)
        activity.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return activity
    }()
    
    func startLoading() {
        isEnabled = false
        activity.startAnimating()
    }
    
    func endLoading()  {
        isEnabled = true
        activity.stopAnimating()
    }
}

class TSTableView: UITableView {
    
    convenience init(style: UITableView.Style) {
        self.init(frame: .zero, style: style)
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        separatorInset = .zero
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        sectionFooterHeight = 0
        sectionHeaderHeight = 0
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        separatorColor = R.color.separator
        clearColor()
    }
}
class TSStackView: UIStackView {
    convenience init() {
        self.init(frame: .zero)
        distribution = .equalSpacing
        alignment = .center
    }
}

class TSTableViewCell: UITableViewCell {
    func didSelected() {}
    
    func onInit() {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = ts.color.view
        
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TSSegment: UISegmentedControl, TSLocalize {
    var titles = [String]() {
        didSet {
            setTitles()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        tintColor = ts.color.text
        
        receiveNotice(.language, action: #selector(setLocalizeText))
    }
    
    deinit {
        rejectNotice()
    }
    
    @objc func setLocalizeText() {
        setTitles()
    }
    
    func setTitles() {
        removeAllSegments()
        for (i, title) in titles.enumerated() {
            insertSegment(withTitle: title.local, at: i, animated: false)
        }
        selectedSegmentIndex = 0
    }
}

class TSButtonItem: UIControl, TSImageable {
    var image: UIImage? {
        didSet {
            icon.image = image?.shape
            snp.remakeConstraints {
                $0.width.height.equalTo(ts.height.navBar)
            }
        }
    }
    
    var title: String? {
        didSet {
            textLabel.words = title
            if let text = title?.local {
                snp.remakeConstraints {
                    $0.width.equalTo(text.size(attributes: [.font: 17.regular]).width + 20.em)
                    $0.height.equalTo(ts.height.navBar)
                }
            }
        }
    }
    
    lazy var icon: TSImageView = {
        let icon = TSImageView()
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(20.em)
        }
        icon.color = ts.color.item
        return icon
    }()
    
    lazy var textLabel: TSLabel = {
        let label = TSLabel()
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        label.font = 17.regular
        label.color = ts.color.item
        return label
    }()
}

class TSGradientView: UIView {
    var startColor = UIColor.white {
        didSet {
            setColors()
        }
    }
    var endColor = UIColor.white {
        didSet {
            setColors()
        }
    }
    
    func setColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(layer)
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
