//
//  LKTitleView.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

protocol LKTitleViewDelegate: class {
    func titleView(_ titleView: LKTitleView, targetIndex: Int)
}

class LKTitleView: UIView {

    // MARK: - 属性
    weak var delegate: LKTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: LKPageStyle
    
    fileprivate var currentIndex = 0
    fileprivate lazy var titleLabels = [UILabel]()
    fileprivate lazy var normalRGB: (CGFloat, CGFloat, CGFloat) = self.style.normalColor.getRGBValue()
    fileprivate lazy var selectRGB: (CGFloat, CGFloat, CGFloat) = self.style.selectColor.getRGBValue()
    
    fileprivate lazy var deltaRGB: (CGFloat, CGFloat, CGFloat) = {
        let deltaR = self.selectRGB.0 - self.normalRGB.0
        let deltaG = self.selectRGB.1 - self.normalRGB.1
        let deltaB = self.selectRGB.2 - self.normalRGB.2
        return (deltaR, deltaG, deltaB)
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    // MARK: - 构造函数
    init(frame: CGRect, titles: [String], style: LKPageStyle) {
        
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 设置UI
extension LKTitleView {
    
    fileprivate func setupUI()
    {
        // 添加scrollView
        addSubview(scrollView)
        
        //  初始化所有的Label
        setupTitleLabels()
        
        //  初始化底部滑动条
        if style.isShowBottomLine
        {
            setupBottomLine()
        }
        
        //  初始化遮盖View
        if style.isShowCover
        {
            setupCoverView()
        }
        
    }
    
    private func setupCoverView()
    {
        scrollView.insertSubview(coverView, at: 0)
        
        guard let firstLabel = titleLabels.first else {
            return
        }
        
        var coverW: CGFloat = firstLabel.frame.width
        let coverH: CGFloat = style.coverViewHeight
        var coverX: CGFloat = firstLabel.frame.origin.x
        let coverY: CGFloat = (firstLabel.frame.height - coverH) * 0.3
        if style.isScrollEnable {
            coverX -= style.coverViewMargin
            coverW += style.coverViewMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
    
    private func setupBottomLine()
    {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
    }
    
    private func setupTitleLabels()
    {
        
        for (i, title) in titles.enumerated()
        {
            // 创建UILabel
            let titleLabel = UILabel()
            titleLabel.text = title;
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            titleLabel.font = style.titleFont
            titleLabel.isUserInteractionEnabled = true
            
            //  添加label
            scrollView.addSubview(titleLabel)
            
            //  监听label的点击
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(LKTitleView.titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            
            //  将label添加到数组中
            titleLabels.append(titleLabel)
        }
        
        //  判断是否可以滚动
        let labelH: CGFloat = style.titleHeight
        let labelY: CGFloat = 0
        var labelW: CGFloat = bounds.width / CGFloat(titles.count)
        var labelX: CGFloat = 0
        
        //  设置label的frame
        for (i, titleLabel) in titleLabels.enumerated()
        {
            
            if style.isScrollEnable
            {
                labelW = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: style.titleFont], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
        }
        
        //  设置scrollView的滚动范围
        if style.isScrollEnable
        {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
        //  设置缩放
        if style.isNeedScale
        {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
    }
    
}

// MARK: - 点击事件监听
extension LKTitleView {
    
    @objc func titleLabelClick(_ tapGes: UITapGestureRecognizer)
    {
        //  校验label的合法性
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        
        //  判断是否是之前点击的label
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        //  通知代理
        delegate?.titleView(self, targetIndex: targetLabel.tag)
        
        //  添加title
        addjustTitles(targetLabel)
        
    }
    
    //  添加label
    fileprivate func addjustTitles(_ targetLabel: UILabel)
    {
        //  让之前的label不选中,选中新的label
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        //  让新的tag作为currentIndex
        currentIndex = targetLabel.tag
        
        //  调整点击的label的位置 滚动到中间
        addjustLabelPosition()
        
        //  调整文字缩放
        if style.isNeedScale
        {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        //  调整滑动条的位置
        if style.isShowBottomLine
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        //  调整遮盖位置
        if style.isShowCover
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = self.style.isScrollEnable ? (targetLabel.frame.origin.x - self.style.coverViewMargin) : targetLabel.frame.origin.x
                self.coverView.frame.size.width = self.style.isScrollEnable ? (targetLabel.frame.width + self.style.coverViewMargin * 2) : targetLabel.frame.width
            })
        }
    }
    
    //  调整点击的label的位置 滚动到中间
    fileprivate func addjustLabelPosition() {
        
        guard style.isScrollEnable else {
            return
        }
        
        let targetLabel = titleLabels[currentIndex]
        
        //  调整点击的label的位置 滚动到中间
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
    
}

extension LKTitleView
{
    func setCurrentIndex(_ index: Int)
    {
        //  取出选中label
        let targetLabel = titleLabels[index]
        
        //  调整title
        addjustTitles(targetLabel)
    }
}

// MARK: - LKContentViewDelegate
extension LKTitleView: LKContentViewDelegate{
    
    func contentView(_ contentView: LKContentView, didEndScroll inIndex: Int) {
        
        currentIndex = inIndex
        
        addjustLabelPosition()
    }
    
    func contentView(_ contentView: LKContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        print(sourceIndex, targetIndex, progress)
        
        //  获取对应的标题label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //  颜色渐变
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        //  缩放的渐变
        if style.isNeedScale
        {
            let deltaScale = style.maxScale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - deltaScale * progress, y: style.maxScale - deltaScale * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        //  计算底部滑动条的宽和x
        let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        if style.isShowBottomLine
        {
            bottomLine.frame.size.width = deltaWidth * progress + sourceLabel.frame.width
            bottomLine.frame.origin.x = deltaX * progress + sourceLabel.frame.origin.x
        }
        
        //  coverView的渐变
        if style.isShowCover {
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverViewMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + style.coverViewMargin * 2 + deltaWidth * progress) : (sourceLabel.frame.width + deltaWidth * progress)
        }
        
    }
    
}
