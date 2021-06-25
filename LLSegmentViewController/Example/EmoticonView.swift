//
//  EmoticonView.swift
//  LLSegmentViewController
//
//  Created by apple on 2021/6/25.
//  Copyright © 2021 lilin. All rights reserved.
//

import UIKit


class EmoticonView: UIView {
    let segCtlHeight:CGFloat = 40
    let segCtlView:LLSegmentedControl
    var colView:UICollectionView
    var items = [LLSegmentItemTitleImageTabBarItem]()
    
    var indexToList = [Int:UIView]()
    override init(frame: CGRect) {
        let colFrame = CGRect.init(x: 0, y: segCtlHeight, width: frame.width, height: frame.height - segCtlHeight)
        self.items = EmoticonView.creatItem()
        self.colView = EmoticonView.creatCol(frame: colFrame)
        
        let segFrame = CGRect.init(x: 0, y: 0, width: frame.width, height: segCtlHeight)
        segCtlView = LLSegmentedControl.init(frame: segFrame, tabBarItems: items)
        super.init(frame: frame)
        
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleImageView.self
        ctlViewStyle.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        ctlViewStyle.itemViewStyle = titleViewStyle
        segCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        segCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        addSubview(segCtlView)
        segCtlView.reloadData()
        
        colView.delegate = self
        colView.dataSource = self
        addSubview(colView)
        segCtlView.associateScrollerView = colView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonView {
    static func creatItem()->[LLSegmentItemTitleImageTabBarItem] {
        var items = [LLSegmentItemTitleImageTabBarItem]()
        let datas:[(title:String,imageStr:String,style:LLTitleImageButtonStyle)] = [
            ("螃蟹","watermelon",LLTitleImageButtonStyle.titleEmty),
            ("麻辣小龙虾","lobster",LLTitleImageButtonStyle.titleEmty),
            ("苹果","grape", LLTitleImageButtonStyle.titleEmty),
            ("营养胡萝卜","crab",LLTitleImageButtonStyle.titleEmty),
            ("葡萄","carrot",LLTitleImageButtonStyle.titleEmty),
            ("美味西瓜","apple",LLTitleImageButtonStyle.titleEmty),]
        for (title,imageStr, diyStyle) in datas {
            let tabBarItem = LLSegmentItemTitleImageTabBarItem.init(
                                            title: title,
                                            image: UIImage(named: imageStr),
                                            selectedImage: UIImage(named: imageStr + "_selected"))
            
            tabBarItem.style = diyStyle
            tabBarItem.setImageBlock = { (imageView,isSelected,tabBarItem) in
                imageView.image = isSelected ? tabBarItem.selectedImage ?? tabBarItem.image : tabBarItem.image
            }
            items.append(tabBarItem)
        }
        return items
    }
    
    static func creatCol(frame:CGRect) -> UICollectionView {
        let viewWidth = frame.width
        let viewHeight = frame.height
        let interitemSpacing:CGFloat = 0
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemSizeWidth:CGFloat = viewWidth
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: viewHeight)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.isPagingEnabled = true

        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        colView.contentInset = contentInset
        return colView
    }
}

extension EmoticonView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let viewTag = 100
        cell.contentView.viewWithTag(viewTag)?.removeFromSuperview()
        let addView:UIView
        let frame = CGRect.init(origin: CGPoint.zero, size: self.colView.bounds.size)
        if let view = indexToList[indexPath.row] {
            addView = view
        }else{
            let newView = EmoticonListView.init(frame: frame)
            indexToList[indexPath.row] = newView
            addView = newView
        }
        addView.frame = frame
        addView.tag = viewTag
        cell.contentView.addSubview(addView)
        return cell
    }
}


/// 这里就需要自己根据业务需求进行拓展了
class EmoticonListView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    let colView:UICollectionView
    let cellIdentifier = "cell"
    let randomColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
    override init(frame: CGRect) {
        let colViewFrame = CGRect.init(origin: CGPoint.zero, size: frame.size)
        colView = EmoticonListView.creatCol(frame: colViewFrame, cellIdentifier: cellIdentifier)
        super.init(frame: frame)
        colView.delegate = self
        colView.dataSource = self
        addSubview(colView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func creatCol(frame:CGRect,cellIdentifier:String) -> UICollectionView {
        let rowCount = 5
        let viewWidth = frame.width
        let interitemSpacing:CGFloat = 22
        
        let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let itemSizeWidth:CGFloat = (viewWidth - CGFloat(rowCount-1) * interitemSpacing - contentInset.left - contentInset.right)/CGFloat(rowCount)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = 22
        
        let colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        colView.contentInset = contentInset
        return colView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.contentView.backgroundColor = randomColor
        return cell
    }
}
