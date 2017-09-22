//
//  LKPageCollectionLayout.swift
//  LKPageView
//
//  Created by LiuKai on 2017/9/14.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

class LKPageCollectionLayout: UICollectionViewLayout
{
    
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    var itemMargin: CGFloat = 0
    var lineMargin: CGFloat = 0
    var cols: Int = 4
    var rows: Int = 2
    
    fileprivate lazy var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var totalWidth: CGFloat = 0
    
}

extension LKPageCollectionLayout
{
    override func prepare()
    {
        super.prepare()
        
        //  对collectionView进行校验
        guard let collectionView = collectionView else { return }
        
        //  获取collectionView中的组
        let sections = collectionView.numberOfSections
        
        //  计算itemSize
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - itemMargin * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - lineMargin * CGFloat(rows - 1)) / CGFloat(rows)
        var previousNumOfPage = 0
        
        //  遍历所有组
        for section in 0..<sections
        {
            //  获取每组中有多少个items
            let items = collectionView.numberOfItems(inSection: section)
            
            //  遍历所有的items
            for item in 0..<items
            {
                // 根据section和item创建UICollectionViewLayoutAtrribute
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //  给attribute中的frame赋值
                let currenPage = item / (cols * rows) //    获得页数
                let currentIndex = item % (cols * rows) //  获得当前页第几个
                let itemX: CGFloat = CGFloat(previousNumOfPage + currenPage) * collectionView.bounds.width + sectionInset.left + (itemW + itemMargin) * CGFloat(currentIndex % cols)
                let itemY: CGFloat = sectionInset.top + (itemH + lineMargin) * CGFloat(currentIndex / cols)
                
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                //  将attribute保存起来
                attributes.append(attribute)
            }
            
            previousNumOfPage += (items - 1) / (cols * rows) + 1
            
        }
        
        //  获取总宽度
        totalWidth = CGFloat(previousNumOfPage) * collectionView.bounds.width
        
    }
    
}

extension LKPageCollectionLayout
{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return attributes
    }
    
}

extension LKPageCollectionLayout
{
    override var collectionViewContentSize: CGSize {
        return CGSize(width: totalWidth, height: 0)
    }
    
}
