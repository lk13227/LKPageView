//
//  LKContentView.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol LKContentViewDelegate: class {
    func contentView(_ contentView: LKContentView, didEndScroll inIndex: Int)
    func contentView(_ contentView: LKContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class LKContentView: UIView {

    // MARK: - 属性
    weak var delegate: LKContentViewDelegate?
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidDelegate: Bool = false
    
    fileprivate lazy var collectionView: UICollectionView = {
        //  创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        //  给 collectionView 添加属性
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        
        return collectionView
    }()
    
    // MARK: - 构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        
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
extension LKContentView {
    
    fileprivate func setupUI() {
        
        //  将childVCs中所有的控制器添加到parentVC中
        for childVC in childVCs
        {
            parentVC.addChildViewController(childVC)
        }
        
        //  将collection添加到视图上
        addSubview(collectionView)
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension LKContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 先将之前的view删除
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        // 将对应的view添加到cell中
        let childVc = childVCs[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension LKContentView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    
    private func scrollViewDidEndScroll() {
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, didEndScroll: index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //  获取现在的偏移量
        let contentOffsetX = scrollView.contentOffset.x
        
        //  判断有没有滑动
        guard contentOffsetX != startOffsetX && !isForbidDelegate else {
            return
        }
        
        //  定义出需要获取的变量
        var sourceIndex = 0
        var targetIndex = 0
        var progress: CGFloat = 0
        
        //  获取需要的参数
        let collectionWidth = collectionView.bounds.width
        if contentOffsetX > startOffsetX
        {
            //  左滑动
            sourceIndex = Int(contentOffsetX / collectionWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            progress = (contentOffsetX - startOffsetX) / collectionWidth
            
            if (contentOffsetX - startOffsetX) == collectionWidth {
                targetIndex = sourceIndex
            }
            
        } else {
            //  右滑动
            targetIndex = Int(contentOffsetX / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = (startOffsetX - contentOffsetX) / collectionWidth
        }
        
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        
    }
    
}

// MARK: - LKTitleViewDelegate
extension LKContentView: LKTitleViewDelegate {
    func titleView(_ titleView: LKTitleView, targetIndex: Int) {
        //  禁止执行代理方法
        isForbidDelegate = true
        //  根据targetIndex 创建IndexPath
        let indexPath = IndexPath(item: targetIndex, section: 0)
        //  滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
