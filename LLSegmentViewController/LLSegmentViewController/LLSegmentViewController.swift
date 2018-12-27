//
//  LLSegmentViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


class LLSegmentViewController: UIViewController {
    var ctls:[UIViewController]!
    var containerScrollerView:UICollectionView!
    let segmentCtlView = LLSegmentCtlView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    private let cellIdentifier = "cellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initSubviews()
    }
}

extension LLSegmentViewController{
    func initSubviews() {
        view.addSubview(segmentCtlView)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        colView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        colView.delegate = self
        colView.dataSource = self
        colView.showsHorizontalScrollIndicator = false
        containerScrollerView = colView
        
        view.addSubview(containerScrollerView)
        containerScrollerView.isPagingEnabled = true
        segmentCtlView.associateScrollerView = containerScrollerView
        if #available(iOS 11.0, *) {
            containerScrollerView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension LLSegmentViewController{
    func layout(segmentCtlFrame:CGRect,containerFrame:CGRect) {
        segmentCtlView.frame = segmentCtlFrame
        containerScrollerView.frame = containerFrame
    }
    
    func reloadContents(ctls:[UIViewController]) {
        self.ctls = ctls
        segmentCtlView.ctls = ctls
        
        for ctl in self.childViewControllers {
            ctl.removeFromParentViewController()
        }
        
        for ctl in ctls{
            addChildViewController(ctl)
        }
        containerScrollerView.contentSize = CGSize.init(width: view.bounds.size.width * CGFloat(ctls.count), height: 0)
        containerScrollerView.reloadData()
    }
}

extension LLSegmentViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ctls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let ctl = ctls[indexPath.item]
        ctl.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(ctl.view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return containerScrollerView.bounds.size
    }
}
