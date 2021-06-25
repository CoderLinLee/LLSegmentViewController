//
//  EmoticonView.swift
//  LLSegmentViewController
//
//  Created by apple on 2021/6/25.
//  Copyright © 2021 lilin. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let screenW  = UIScreen.main.bounds.size.width
        let screenH  = UIScreen.main.bounds.size.height
        let height:CGFloat = 300
        let emoticonView = EmoticonView.init(frame: CGRect.init(x: 0, y: screenH - height, width: screenW, height: height))
        view.addSubview(emoticonView)
        emoticonView.backgroundColor = UIColor.red
    }
}


class EmoticonView: UIView {
    let segCtlView:LLSegmentedControl
    var colView:UICollectionView!
    var items = [LLSegmentItemTitleImageTabBarItem]()
    
    var indexToList = [Int:UIView]()
    override init(frame: CGRect) {
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
        let segFrame = CGRect.init(x: 0, y: 0, width: frame.width, height: 40)
        segCtlView = LLSegmentedControl.init(frame: segFrame, tabBarItems: items)
        
        let colFrame = CGRect.init(x: 0, y: segFrame.maxY, width: frame.width, height: frame.height - segFrame.height)
        super.init(frame: frame)
        
        segCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleImageView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        addSubview(segCtlView)
        segCtlView.reloadData()
        
        colView = creatCol(frame: colFrame)
        addSubview(colView)
        segCtlView.associateScrollerView = colView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor =  UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
        cell.contentView.viewWithTag(100)?.removeFromSuperview()
        if let view = indexToList[indexPath.row] {
            view.frame = cell.contentView.bounds
            cell.contentView.addSubview(view)
        }else{
            let newView = EmoticonListView.init(frame: cell.contentView.bounds)
            indexToList[indexPath.row] = newView
            newView.frame = cell.contentView.bounds
            cell.contentView.addSubview(newView)
            newView.tag = 100
        }
        return cell
    }
    
    func creatCol(frame:CGRect) -> UICollectionView {
        let viewWidth = self.bounds.width
        let viewHeight = self.bounds.height

        let interitemSpacing:CGFloat = 22
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemSizeWidth:CGFloat = viewWidth
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: viewHeight)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.delegate = self
        colView.dataSource = self
        colView.isPagingEnabled = true

        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        colView.contentInset = contentInset
        return colView
    }
}


class EmoticonListView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var colView:UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        colView = creatCol(frame: frame)
        addSubview(colView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatCol(frame:CGRect) -> UICollectionView {
        let rowCount = 4
        let viewWidth = self.bounds.width
        let interitemSpacing:CGFloat = 22
        
        let contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let itemSizeWidth:CGFloat = (viewWidth - CGFloat(rowCount-1) * interitemSpacing - contentInset.left - contentInset.right)/CGFloat(rowCount)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = 33
        
        let colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.delegate = self
        colView.dataSource = self
        colView.backgroundColor = UIColor.clear
        colView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        colView.contentInset = contentInset
        return colView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .blue
        return cell
    }
}
