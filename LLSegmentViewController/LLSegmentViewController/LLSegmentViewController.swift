//
//  LLSegmentViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

 open class LLSegmentViewController: UIViewController {
    var viewCtlContainerColView:UICollectionView!
    let segmentCtlView = LLSegmentedControl(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    var ctls:[UIViewController]!
    private let cellIdentifier = "cellIdentifier"
    let layout = UICollectionViewFlowLayout()
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initSubviews()
    }
}

extension LLSegmentViewController{
    public func layout(segmentCtlFrame:CGRect,containerFrame:CGRect) {
        segmentCtlView.frame = segmentCtlFrame
        viewCtlContainerColView.frame = containerFrame
        viewCtlContainerColView.reloadData()
    }
    
    public func reloadViewControllers(ctls:[UIViewController]) {
        segmentCtlView.ctls = ctls
        self.ctls = ctls
        
        for ctl in ctls{
            addChildViewController(ctl)
        }
        
        let contentSizeWidth = viewCtlContainerColView.bounds.size.width * CGFloat(ctls.count)
        viewCtlContainerColView.contentSize = CGSize.init(width: contentSizeWidth, height: 0)
        viewCtlContainerColView.reloadData()
    }
    
    public func insertOneViewController(ctl:UIViewController,index:NSInteger){
        if !self.childViewControllers.contains(ctl) {
            addChildViewController(ctl)
            let itemIndex = max(0, min(index, ctls.count))
            self.ctls.insert(ctl, at: itemIndex)
            
            let contentSizeWidth = viewCtlContainerColView.bounds.size.width * CGFloat(ctls.count)
            viewCtlContainerColView.contentSize = CGSize.init(width: contentSizeWidth, height: 0)
            viewCtlContainerColView.reloadData()
            viewCtlContainerColView.scrollToItem(at: IndexPath.init(item: itemIndex, section: 0), at: .centeredHorizontally, animated: false)
            
            segmentCtlView.ctls = ctls
            
            segmentCtlView.ctlViewStyle.defaultSelectedIndex = itemIndex
            segmentCtlView.reloadData()
        }
    }
    
    func selected(at Index:NSInteger,animation:Bool)  {
        guard ctls != nil && ctls.count < Index else {
            return
        }
        segmentCtlView.selected(at: Index, animation: animation)
    }
}

extension LLSegmentViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ctls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let ctl = ctls[indexPath.item]
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        ctl.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(ctl.view)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return viewCtlContainerColView.bounds.size
    }
}

extension LLSegmentViewController{
    private func initSubviews() {
        view.addSubview(segmentCtlView)
        let tab = UITabBarController()
        tab.selectedIndex = 1
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        colView.delegate = self
        colView.dataSource = self
        colView.showsHorizontalScrollIndicator = false
        viewCtlContainerColView = colView
        
        view.addSubview(viewCtlContainerColView)
        viewCtlContainerColView.isPagingEnabled = true
        segmentCtlView.associateScrollerView = viewCtlContainerColView
        if #available(iOS 11.0, *) {
            viewCtlContainerColView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
