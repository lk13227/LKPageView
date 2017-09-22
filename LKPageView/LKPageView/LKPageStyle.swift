//
//  LKPageStyle.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

class LKPageStyle {

    var titleHeight: CGFloat = 44 //    标题view的高度
    var normalColor: UIColor = UIColor(r: 255, g: 255, b: 255) //    文本默认颜色
    var selectColor: UIColor = UIColor(r: 255, g: 127, b: 0) //   文本选中颜色
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14);  //  文字大小
    var isScrollEnable: Bool = false // titleView上的label是否能够滚动 默认不能
    var titleMargin: CGFloat = 20 //    能滚动的情况下, 间距
    var isShowBottomLine: Bool = true //    是否显示底部的滑动条
    var bottomLineColor: UIColor = UIColor.orange //    底部滑动条颜色
    var bottomLineHeight: CGFloat = 2 //    底部滑动条的高度
    var isNeedScale: Bool = false //    选中标题是否缩放
    var maxScale: CGFloat = 1.2 //  选中标题最大缩放程度
    var isShowCover: Bool = false //    是否显示遮盖
    var coverViewColor: UIColor = .black // 遮盖的颜色
    var coverViewAlpha: CGFloat = 0.3 //    遮盖的透明度
    var coverViewHeight: CGFloat = 25 //    遮盖的高度
    var coverViewRadius: CGFloat = 12 //    遮盖圆角大小
    var coverViewMargin: CGFloat = 4 // 遮盖的间距
    var pageControlHeight: CGFloat = 20 //  小圆点的高度
    var isTitleInTop: Bool = true //    标题view是否显示在上面
}
