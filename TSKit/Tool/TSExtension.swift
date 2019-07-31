//
//  TSExtension.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *                                         ,s555SB@@&
 *                                      :9H####@@@@@Xi
 *                                     1@@@@@@@@@@@@@@8
 *                                   ,8@@@@@@@@@B@@@@@@8
 *                                  :B@@@@X3hi8Bs;B@@@@@Ah,
 *             ,8i                  r@@@B:     1S ,M@@@@@@#8;
 *            1AB35.i:               X@@8 .   SGhr ,A@@@@@@@@S
 *            1@h31MX8                18Hhh3i .i3r ,A@@@@@@@@@5
 *            ;@&i,58r5                 rGSS:     :B@@@@@@@@@@A
 *             1#i  . 9i                 hX.  .: .5@@@@@@@@@@@1
 *              sG1,  ,G53s.              9#Xi;hS5 3B@@@@@@@B1
 *               .h8h.,A@@@MXSs,           #@H1:    3ssSSX@1
 *               s ,@@@@@@@@@@@@Xhi,       r#@@X1s9M8    .GA981
 *               ,. rS8H#@@@@@@@@@@#HG51;.  .h31i;9@r    .8@@@@BS;i;
 *                .19AXXXAB@@@@@@@@@@@@@@#MHXG893hrX#XGGXM@@@@@@@@@@MS
 *                s@@MM@@@hsX#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,
 *              :GB@#3G@@Brs ,1GM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B,
 *            .hM@@@#@@#MX 51  r;iSGAM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8
 *          :3B@@@@@@@@@@@&9@h :Gs   .;sSXH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
 *      s&HA#@@@@@@@@@@@@@@M89A;.8S.       ,r3@@@@@@@@@@@@@@@@@@@@@@@@@@@r
 *   ,13B@@@@@@@@@@@@@@@@@@@5 5B3 ;.         ;@@@@@@@@@@@@@@@@@@@@@@@@@@@i
 *  5#@@#&@@@@@@@@@@@@@@@@@@9  .39:          ;@@@@@@@@@@@@@@@@@@@@@@@@@@@;
 *  9@@@X:MM@@@@@@@@@@@@@@@#;    ;31.         H@@@@@@@@@@@@@@@@@@@@@@@@@@:
 *   SH#@B9.rM@@@@@@@@@@@@@B       :.         3@@@@@@@@@@@@@@@@@@@@@@@@@@5
 *     ,:.   9@@@@@@@@@@@#HB5                 .M@@@@@@@@@@@@@@@@@@@@@@@@@B
 *           ,ssirhSM@&1;i19911i,.             s@@@@@@@@@@@@@@@@@@@@@@@@@@S
 *              ,,,rHAri1h1rh&@#353Sh:          8@@@@@@@@@@@@@@@@@@@@@@@@@#:
 *            .A3hH@#5S553&@@#h   i:i9S          #@@@@@@@@@@@@@@@@@@@@@@@@@A.
 *
 *
 */

import UIKit
import Foundation

public extension String {
    var color: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }
    
    /// get请求
    func get(_ params: NSDictionary? = nil) -> URLRequest? {
        var urlStr = self
        if let params = params {
            var paramStr = ""
            for (key, value) in params {
                paramStr.append("\(key)=\(value)&")
            }
            urlStr += ("?" + paramStr)
        }
        
        guard let url = urlStr.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        return request
    }
    
    var url: URL? {
        guard let str = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: str) else {
            return nil
        }
        return url
    }
    
    /// post请求
    func post(_ params: NSDictionary? = nil) -> URLRequest? {
        guard let url = URL(string: self) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        
        if let params = params {
            var paramStr = ""
            for (key, value) in params {
                paramStr.append("\(key)=\(value)&")
            }
            request.httpBody = paramStr.data(using: .utf8)
        }
        
        return request
    }
    
    func size(attributes: [NSAttributedString.Key: Any]) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    func height(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let rect = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
    
    var double: Double {
        return Double(self) ?? .nan
    }
    
    func remove(_ string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
    
    func last(_ count: Int) -> String {
        guard self.count > count else {
            return self
        }
        return (self as NSString).substring(with: NSMakeRange(self.count - count, count))
    }
    
    func first(_ count: Int) -> String {
        guard self.count > count else {
            return self
        }
        return (self as NSString).substring(to: count)
    }
    
    func isMatch(to regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    func matches(with regex: String) -> [String] {
        var resArray = [String]()
        do {
            let regular = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let res = regular.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, self.count))
            for checkRes in res {
                resArray.append((self as NSString).substring(with: checkRes.range))
            }
        } catch {}
        return resArray
    }
    
    var int: Int? {
        return Int(self)
    }
    
    func date(with format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func lineCount(_ max: Int) -> String {
        var res = ""
        for (index, char) in self.enumerated() {
            res.append(char)
            let i = index + 1
            if i % max == 0 && i < count {
                res.append("\n")
            }
        }
        return res
    }
    
    var QRCode: UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()
        
        let text = data(using: .utf8)
        filter.setValue(text, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            return UIImage(ciImage: outputImage, scale: 1, orientation: .up)
        }
        return nil
    }
}

extension UIColor {
    var isDark: Bool {
        var components: [CGFloat] {
            if let comps = cgColor.components {
                if comps.count == 4 {
                    return comps
                } else {
                    return [comps[0], comps[0], comps[0], comps[1]]
                }
            } else {
                return [0, 0, 0, 0]
            }
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (0.2126 * red + 0.7152 * green + 0.0722 * blue) < 0.5
    }
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
    
    class var random: UIColor {
        return UIColor(red: 255.random.cgfloat / 255,
                       green: 255.random.cgfloat / 255,
                       blue: 255.random.cgfloat / 255,
                       alpha: 1)
    }
}

extension CGFloat {
    
    static var width: CGFloat {
        let size = UIScreen.main.bounds.size
        return Swift.min(size.width, size.height)
    }
    static var height: CGFloat {
        let size = UIScreen.main.bounds.size
        return Swift.max(size.width, size.height)
    }
    
    static var safeBottom: CGFloat {
        guard let window = UIApplication.shared.keyWindow else {
            return 0
        }
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
    
    static var statusBar: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var int: Int {
        if isNaN || isInfinite {
            return 0
        }
        return Int(self)
    }
}

extension Double {
    /// 保留n位小数
    func keep(_ n: Int? = nil) -> String {
        if isNaN {
            return "0"
        }
        if let n = n {
            return String(format: "%.\(n)f", self)
        } else {
            return String(format: "%lf", self)
        }
    }
    
    func mostKeep(_ n: Int) -> String {
        return NSDecimalNumber(string: keep(n)).stringValue
    }
    
    var mostKeep: String {
        return NSDecimalNumber(string: keep()).stringValue
    }
    
    var cgfloat: CGFloat {
        return CGFloat(self)
    }
    
    var int: Int {
        if isNaN || isInfinite {
            return 0
        }
        return Int(self)
    }
    
    var priceString: String {
        var nums = mostKeep.components(separatedBy: ".")
        let firstCount = nums[0].count
        if firstCount <= 1 {
            return String(format: "%.5f", self)
        } else if firstCount >= 5 {
            return int.string
        } else if firstCount == 2 {
            return String(format: "%.3f", self)
        } else {
            let lastCount = 6 - firstCount
            return String(format: "%.\(lastCount)f", self)
        }
    }
    
    var avgPriceString: String {
        var nums = mostKeep.components(separatedBy: ".")
        let firstCount = nums[0].count
        if firstCount <= 1 {
            return String(format: "%.6f", self)
        } else if firstCount >= 5 {
            return String(format: "%.1f", self)
        } else if firstCount == 2 {
            return String(format: "%.4f", self)
        } else {
            let lastCount = 7 - firstCount
            return String(format: "%.\(lastCount)f", self)
        }
    }
    
    var moneyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positiveFormat = "###,##0.00"
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int {
    // 375标准等比缩放
    var em: CGFloat {
        if ts.helper.isPad && CGFloat.width > 700 {
//            return CGFloat(self) * .width / 768
            return CGFloat(self) * .height / 900
        }
        return CGFloat(self) * .width / 375
    }
    
    var medium: UIFont {
        return UIFont.systemFont(ofSize: em, weight: UIFont.Weight.medium)
    }
    
    var regular: UIFont {
        return UIFont.systemFont(ofSize: em, weight: UIFont.Weight.regular)
    }
    
    var light: UIFont {
        return UIFont.systemFont(ofSize: em, weight: UIFont.Weight.light)
    }
    
    var thin: UIFont {
        return UIFont.systemFont(ofSize: em, weight: UIFont.Weight.thin)
    }
    
    func font(_ name: String) -> UIFont {
        return UIFont(name: name, size: em) ?? regular
    }
    
    var random: Int {
        return Int(arc4random()) % self
    }
    
    var cgfloat: CGFloat {
        return CGFloat(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var string: String {
        return String(self)
    }
    
    var square: Int {
        return self * self
    }
    
    var cube: Int {
        return self * self * self
    }
}

extension Bool {
    mutating func toggle() {
        self = !self
    }
}

extension CGRect {
    var center: CGPoint {
        set {
            origin.x = newValue.x - width / 2
            origin.y = newValue.y - height / 2
        }
        get {
            return CGPoint(x: minX + width / 2, y: minY + height / 2)
        }
    }
    
    var yCenter: CGFloat {
        set {
            origin.y = newValue - height / 2
        }
        get {
            return minY + height / 2
        }
    }
    
    var xCenter: CGFloat {
        set {
            origin.x = newValue - width / 2
        }
        get {
            return minX + width / 2
        }
    }
    
    var xLeft: CGFloat {
        set {
            origin.x = newValue
        }
        get {
            return minX
        }
    }
    
    var xRight: CGFloat {
        set {
            origin.x = newValue - width
        }
        get {
            return maxX
        }
    }
}

extension CALayer {
    func clear() {
        sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        sublayers?.removeAll()
    }
}

extension UIBezierPath {
    func addRect(from point1: CGPoint, to point2: CGPoint) {
        move(to: point1)
        addLine(to: CGPoint(x: point1.x, y: point2.y))
        addLine(to: point2)
        addLine(to: CGPoint(x: point2.x, y: point1.y))
        close()
    }
    
    func addLines(points: [CGPoint]) {
        guard points.count > 0 else {
            return
        }
        move(to: points[0])
        if points.count == 1 {
            return
        } else if points.count == 2 {
            addLine(to: points[1])
        } else if points.count == 3 {
            addQuadCurve(to: points[2], controlPoint: points[1])
        } else if points.count > 500 {
            for i in 1..<points.count {
                addLine(to: points[i])
            }
        } else {
            addLine(to: points[1])
            for i in 3..<points.count {
                let p0 = points[i - 3]
                let p1 = points[i - 2]
                let p2 = points[i - 1]
                let p3 = points[i]
                
                let granularity = 500 / points.count
                for i in 1..<granularity {
                    let t = i.cgfloat / granularity.cgfloat
                    let tt = t * t
                    let ttt = tt * t
                    let x = 0.5 * (2 * p1.x + (p2.x - p0.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * tt + (3 * p1.x - p0.x - 3 * p2.x + p3.x) * ttt)
                    let y = 0.5 * (2 * p1.y + (p2.y - p0.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * tt + (3 * p1.y - p0.y - 3 * p2.y + p3.y) * ttt)
                    addLine(to: CGPoint(x: x, y: y))
                }
                addLine(to: p2)
            }
            addLine(to: points.last!)
        }
    }
}


extension UIGestureRecognizer {
    var touchPoint: CGPoint {
        return location(in: view)
    }
}

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func full() {
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func border(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func shadow(color: UIColor) {
        clipsToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func clearColor() {
        backgroundColor = UIColor.clear
    }
    
    func addBottomLine(with color: UIColor = ts.color.separator) {
        let line = TSView()
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        line.color = color
    }
    
    func addTopLine(with color: UIColor = ts.color.separator) {
        let line = TSView()
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        line.color = color
    }
    
    var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.clear
        }
    }
    
    var corner: CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.width
        }
    }
    
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.height
        }
    }
    
    var maxX: CGFloat {
        set {
            frame.origin.x = newValue - width
        }
        get {
            return frame.maxX
        }
    }
    
    static func xib<T: UIView>() -> T {
        let className = NSStringFromClass(T.self)
        let nibName = className.components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
    }
    
    var viewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.visible
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIViewController {
    
    func addSubviews(_ views: UIView ...) {
        views.forEach { (subview) in
            view.addSubview(subview)
        }
    }
    
    var color: UIColor? {
        set {
            view.backgroundColor = newValue
        }
        get {
            return view.backgroundColor
        }
    }
    
    var visible: UIViewController? {
        var current: UIViewController? = self
        
        if let present = presentedViewController {
            current = present.visible
        } else if self is UITabBarController {
            current = (self as! UITabBarController).selectedViewController?.visible
        } else if self is UINavigationController {
            current = (self as! UINavigationController).visibleViewController?.visible
        }
        return current
    }
}

extension UILabel {
    var color: UIColor {
        set {
            textColor = newValue
        }
        get {
            return textColor
        }
    }
}

extension UIButton {
    var color: UIColor {
        set {
            setTitleColor(newValue, for: .normal)
            imageView?.tintColor = newValue
        }
        get {
            return titleColor(for: .normal) ?? UIColor.clear
        }
    }
    
    var image: UIImage? {
        set {
            setImage(newValue, for: .normal)
        }
        get {
            return image(for: .normal)
        }
    }
    
    var font: UIFont {
        set {
            titleLabel?.font = newValue
        }
        get {
            return titleLabel?.font ?? UIFont()
        }
    }
}

extension UIImageView {
    var color: UIColor {
        set {
            tintColor = newValue
        }
        get {
            return tintColor
        }
    }
    
    func setMotion(_ value: CGFloat) {
        let effectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        let effectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        
        effectX.maximumRelativeValue = value
        effectX.minimumRelativeValue = -value
        
        effectY.maximumRelativeValue = value
        effectY.minimumRelativeValue = -value
        
        motionEffects = [effectX, effectY]
    }
}

extension UIImage {
    var shape: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func scaleImage(rate: CGFloat) -> UIImage {
        
        let scaleSize = size.applying(CGAffineTransform(scaleX: rate, y: rate))
        
        UIGraphicsBeginImageContext(scaleSize)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        draw(in: CGRect(origin: .zero, size: scaleSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func compress(with max: Int) -> String {
        var compression: CGFloat = 1
        if let data = jpegData(compressionQuality: compression), data.KB < max {
            return data.base64
        }
        var maxCompress: CGFloat = 1
        var minCompress: CGFloat = 0
        for _ in 0..<6 {
            compression = (maxCompress + minCompress) / 2
            if let data = jpegData(compressionQuality: compression) {
                if data.KB < (max.cgfloat * 0.9).int {
                    minCompress = compression
                } else if data.KB > max {
                    maxCompress = compression
                } else {
                    return data.base64
                }
            }
        }
        guard let data = jpegData(compressionQuality: compression) else {
            return ""
        }
        if data.KB < max {
            return data.base64
        }
        let rate = max.cgfloat / data.KB.cgfloat
        if let data = scaleImage(rate: rate).jpegData(compressionQuality: compression) {
            return data.base64
        }
        return ""
    }

}

extension UICollectionView {
    var color: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }
    
    func register<T: UICollectionViewCell>(class name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func reusable<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
extension UICollectionViewCell {
    var color: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }
}

extension ArraySlice {
    var array: Array<Element> {
        return Array(self)
    }
}
extension Array where Element: UIView {
    
    func stack(equalSize: Bool = true) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: self)
        if equalSize {
            stack.distribution = .fillEqually
        } else {
            stack.distribution = .equalSpacing
            stack.alignment = .center
        }
        return stack
    }
}

extension UIStackView {
    func clear() {
        arrangedSubviews.forEach { (view) in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func addArrangedSubviews(_ views: UIView ...) {
        views.forEach { (view) in
            addArrangedSubview(view)
        }
    }
}

// 数组转模型
extension NSArray {
    func models<T: Codable>() -> [T] {
        var models = [T]()
        let decoder = JSONDecoder()
        for obj in self {
            do {
                let data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                let model = try decoder.decode(T.self, from: data)
                models.append(model)
            } catch {
                assert(false, "模型转换失败")
            }
        }
        return models
    }
}
// 字典转模型
extension NSDictionary {
    func model<T: Codable>() -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            assert(false, "模型转换失败")
            return nil
        }
    }
}

extension Data {
    var gbkString: String? {
        let enc = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue)))
        return String(data: self, encoding: enc)
    }
    
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    var base64: String {
        return base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var KB: Int {
        return count / 1024
    }
}

extension UIResponder {
    func sendNotice(_ notice: TSNotice, obj: Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(notice.rawValue), object: obj)
    }
    func receiveNotice(_ notice: TSNotice, action: Selector) {
        NotificationCenter.default.addObserver(self, selector: action, name: NSNotification.Name(notice.rawValue), object: nil)
    }
    func rejectNotice() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Date {
    func time(with format: String = "MM-dd HH:mm") -> String {
        let now = Date()
        let interval = Int(now.timeIntervalSince(self))
        if interval < 60 {
            return "刚刚"
        }
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        if interval < 60 * 60 * 24 {
            return "\(interval / 60 / 60)小时前"
        }
        if interval < 60 * 60 * 24 * 3 {
            return "\(interval / 60 / 60 / 24)天前"
        }
        return string(with: format)
    }
    
    func string(with format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
}


extension UIScrollView {
    var paddingTop: CGFloat {
        set {
            contentInset.top = newValue
            scrollIndicatorInsets.top = newValue
        }
        get {
            return contentInset.top
        }
    }
    
    var paddingBottom: CGFloat {
        set {
            contentInset.bottom = newValue
            scrollIndicatorInsets.bottom = newValue
        }
        get {
            return contentInset.bottom
        }
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(class name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func reusable<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let className = "\(type(of: T.self))".components(separatedBy: ".").first!
        return dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
}

extension UITextField {
    func setPlaceHolder(_ placeholder: String, with color: UIColor = ts.color.lightText) {
        if placeholder.isEmpty { return }
        
        attributedPlaceholder = NSAttributedString(string: placeholder.local, attributes: [.foregroundColor: color])
    }
}


extension UINavigationController {
    func replace(_ viewController: UIViewController) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let count = self.viewControllers.count
            if count - 2 > 0 {
                self.viewControllers.remove(at: count - 2)
            }
        }
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}

extension Bundle {
    var version: String {
        let ver = infoDictionary?["CFBundleShortVersionString"] as? String
        return ver ?? "1.0"
    }
}
