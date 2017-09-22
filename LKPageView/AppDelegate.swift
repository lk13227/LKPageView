//
//  AppDelegate.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
}

func getRandomColor() -> UIColor {
    return UIColor(
        red: CGFloat(arc4random_uniform(256))/255.0,
        green: CGFloat(arc4random_uniform(256))/255.0,
        blue: CGFloat(arc4random_uniform(256))/255.0,
        alpha: 1.0)
}
