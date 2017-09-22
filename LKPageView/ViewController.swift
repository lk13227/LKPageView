//
//  ViewController.swift
//  LKPageView
//
//  Created by LiuKai on 2017/8/7.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

private let KCollectionViewCellID = "KCollectionViewCellID"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        /**
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height)
        let titles = ["推荐", "游戏", "娱乐", "趣玩", "推推推推荐", "游推戏", "娱推推推推推推推推推推乐", "趣玩"]
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            
            childVCs.append(vc)
        }
        
        let style = LKPageStyle()
        style.isScrollEnable = true
        style.isNeedScale = true
        style.isShowCover = true
        
        let pageView = LKPageView(frame: pageFrame, titles: titles, style: style, childVCs: childVCs, parentVC: self)
        
        view.addSubview(pageView)
        */
        
        let pageFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        let titles = ["西宫硝子", "贞德", "玛修", "霞之丘诗羽"]
        let style = LKPageStyle()
        style.isShowBottomLine = true
        
        let layout = LKPageCollectionLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemMargin = 10
        layout.lineMargin = 10
        layout.cols = 7
        layout.rows = 3
        
        let pageCollectionView = LKPageCollectionView(frame: pageFrame, titles: titles, style: style, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.registerCell(UICollectionViewCell.self, reusableIdentifier: KCollectionViewCellID)
        view.addSubview(pageCollectionView)
        
    }


}

extension ViewController: LKPageCollectionViewDataSource
{
    func numberOfSectionInPageCollectionView(_ pageCollectionView: LKPageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: LKPageCollectionView, numberOfSection section: Int) -> Int {
        return 100
    }
    
    func pageCollectionView(_ pageCollectionView: LKPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCollectionViewCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
        
    }
}

