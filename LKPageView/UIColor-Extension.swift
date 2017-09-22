//
//  UIColor-Extension.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/8.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(256))/255.0,
            green: CGFloat(arc4random_uniform(256))/255.0,
            blue: CGFloat(arc4random_uniform(256))/255.0,
            alpha: 1.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        
        guard hexString.characters.count >= 6 else {
            return nil
        }
        
        var hexTempString = hexString.uppercased()
        
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##") {
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        if hexTempString.hasPrefix("#") {
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        var r: uint = 0
        var g: uint = 0
        var b: uint = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
}

// MARK: - 从颜色中获取RGB的值
extension UIColor {
    
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat)
    {
        /**
        guard let cmps = cgColor.components else {
            fatalError("大失败!请确定该颜色是通过RGB创建")
        }
        
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
        */
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (red * 255, green * 255, blue * 255)
    }
    
}









