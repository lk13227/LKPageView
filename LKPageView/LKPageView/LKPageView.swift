//
//  LKPageView.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

class LKPageView: UIView {

    // MARK: - 属性
    var titles: [String]
    var style: LKPageStyle
    var childVCs: [UIViewController]
    var parentVC: UIViewController
    
    // MARK: - 构造函数
    init(frame: CGRect, titles: [String], style: LKPageStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        
        self.titles = titles
        self.style = style
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 设置UI
extension LKPageView {
    
    fileprivate func setupUI() {
        
        // 创建titleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = LKTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = .blue
        addSubview(titleView)
        
        // 创建contentView
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = LKContentView(frame: contentFrame, childVCs: childVCs, parentVC: parentVC)
        contentView.backgroundColor = .red
        addSubview(contentView)
        
        // 联动
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
}
