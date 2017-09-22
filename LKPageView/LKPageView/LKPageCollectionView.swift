//
//  LKPageCollectionView.swift
//  LKPageView
//
//  Created by LiuKai on 2017/9/13.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

private let kCollectionViewCellID = "kCollectionViewCellIDtest"

protocol LKPageCollectionViewDataSource: class
{
    //  有多少组数据
    func numberOfSectionInPageCollectionView(_ pageCollectionView: LKPageCollectionView) -> Int
    
    //  每组里有多少个数据
    func pageCollectionView(_ pageCollectionView: LKPageCollectionView, numberOfSection section: Int) -> Int
    
    //  每个cell的样式
    func pageCollectionView(_ pageCollectionView: LKPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
}

class LKPageCollectionView: UIView
{
    
    weak var dataSource: LKPageCollectionViewDataSource?
    
    fileprivate var titles: [String]
    fileprivate var style: LKPageStyle
    fileprivate var layout: LKPageCollectionLayout
    
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var titleView: LKTitleView!
    
    fileprivate lazy var currentIndex: IndexPath = IndexPath(item: 0, section: 0)

    init(frame: CGRect, titles: [String], style: LKPageStyle, layout: LKPageCollectionLayout)
    {
        self.titles = titles
        self.layout = layout
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LKPageCollectionView
{
    fileprivate func setupUI()
    {
        // titleView
        let titleY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        let titleView = LKTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        addSubview(titleView)
        self.titleView = titleView
        
        // UICollectionView
        let collectionY = style.isTitleInTop ? style.titleHeight : 0
        let collectionH = bounds.height - style.titleHeight - style.pageControlHeight
        let collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: collectionH)
        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        self.collectionView = collectionView
        
        // UIPageControl
        let pageFrame = CGRect(x: 0, y: collectionFrame.maxY, width: bounds.width, height: style.pageControlHeight)
        let pageControl = UIPageControl(frame: pageFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        self.pageControl = pageControl
        
    }
}

//  暴露一些方法用于外部使用
extension LKPageCollectionView
{
    func registerCell(_ cell: AnyClass?, reusableIdentifier: String)
    {
        collectionView.register(cell, forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    func registerNib(_ nib: UINib?, resuableIdentifier: String)
    {
        collectionView.register(nib, forCellWithReuseIdentifier: resuableIdentifier)
    }
    
    func reloadData()
    {
        collectionView.reloadData()
    }
    
}

extension LKPageCollectionView: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let sectionItemCount = dataSource?.pageCollectionView(self, numberOfSection: section) ?? 0
        if section == 0
        {
            pageControl.numberOfPages = (sectionItemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return sectionItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return (dataSource?.pageCollectionView(self, collectionView, cellAtIndexPath: indexPath))!
    }
    
}

extension LKPageCollectionView: UICollectionViewDelegate
{
    //  减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        scrollViewEndScroll()
    }
    //  拖拽停止
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        scrollViewEndScroll()
    }
    
    private func scrollViewEndScroll()
    {
        //  获取滚动位置对应的indexPath
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        //  判断是否需要改变组
        if indexPath.section != currentIndex.section
        {
            //  改变pageControl
            let itemsCount = dataSource?.pageCollectionView(self, numberOfSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemsCount - 1) / (layout.cols * layout.rows) + 1
            
            //  改变titleView的变化
            titleView.setCurrentIndex(indexPath.section)
            
            //  记录最新的indexPath
            currentIndex = indexPath
        }
        
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
        
    }
}

extension LKPageCollectionView: LKTitleViewDelegate
{
    func titleView(_ titleView: LKTitleView, targetIndex: Int)
    {
        //  根据index创建对应组的indexPath
        let indexPath = IndexPath(item: 0, section: targetIndex)
        
        //  滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        //  调整正确位置
        let sectionNumber = dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
        let sectionItemsNum = dataSource?.pageCollectionView(self, numberOfSection: targetIndex) ?? 0
        if targetIndex == sectionNumber - 1 && sectionItemsNum <= layout.cols * layout.rows
        {
            return
        }
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        //  设置最新的indexPath
        currentIndex = indexPath
        
        //  设置pageControl的个数
        pageControl.numberOfPages = (sectionItemsNum - 1) / (layout.cols * layout.rows) + 1
        pageControl.currentPage = 0
        
    }
}
