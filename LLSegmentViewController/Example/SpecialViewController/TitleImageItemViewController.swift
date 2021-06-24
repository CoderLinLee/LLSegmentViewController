//
//  TitleImageItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

//MARK:-自定义的使用
class TitleImageItemViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls(style: nil)
        setUpSegmentStyle()
        chooseStyleBtn()
    }
    
    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
        self.relayoutSubViews()
    }

    func loadCtls(style:LLTitleImageButtonStyle?) {
        var ctls = [UIViewController]()
        let margin: CGFloat = 5
        let datas:[(title:String,imageStr:String,style:LLTitleImageButtonStyle)] = [
            ("螃蟹","watermelon",LLTitleImageButtonStyle.titleTop(margin: margin)),
            ("麻辣小龙虾","lobster",LLTitleImageButtonStyle.titleRight(margin: margin)),
            ("苹果","grape", LLTitleImageButtonStyle.titleLeft(margin: margin)),
            ("营养胡萝卜","crab",LLTitleImageButtonStyle.titleBottom(margin: margin)),
            ("葡萄","carrot",LLTitleImageButtonStyle.titleEmty),
            ("美味西瓜","apple",LLTitleImageButtonStyle.titleOnly),]
        for (title,imageStr, diyStyle) in datas {
            let ctl = TestViewController.init()
            ctl.showTableView = true
            let tabBarItem = LLSegmentItemTitleImageTabBarItem.init(
                                            title: title,
                                            image: UIImage(named: imageStr),
                                            selectedImage: UIImage(named: imageStr + "_selected"))
            if let currentStyle = style {
                tabBarItem.style = currentStyle
            }else{
                tabBarItem.style = diyStyle
            }
            
            tabBarItem.setImageBlock = { (imageView,isSelected,tabBarItem) in
                imageView.image = isSelected ? tabBarItem.selectedImage : tabBarItem.image
            }
            ctl.tabBarItem = tabBarItem
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleImageView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
    
    func chooseStyleBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "设置", style: .plain, target: self, action: #selector(chooseStyleClick))
    }
    
    @objc func chooseStyleClick() {
        let ctl = ChooseTitleImageStyleViewController()
        self.navigationController?.pushViewController(ctl, animated: true)
        ctl.chooseStyleBlock = { [weak self](style) in
            self?.loadCtls(style: style)
            self?.segmentCtlView.reloadData()
        }
    }
}



//选择某种样式
class ChooseTitleImageStyleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    typealias chooseStyleBlockDefine = (LLTitleImageButtonStyle?)->Void
    var chooseStyleBlock:chooseStyleBlockDefine?
    let dataArr:[(title:String,style:LLTitleImageButtonStyle?)] = [("顶部",.titleTop(margin: 2)),
                                                                   ("左边",.titleLeft(margin: 2)),
                                                                   ("底部",.titleBottom(margin: 2)),
                                                                   ("右边",.titleRight(margin: 2)),
                                                                   ("只有图片",.titleEmty),
                                                                   ("只有文字",.titleOnly),
                                                                   ("混合",nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    func initTableView() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataArr[indexPath.row]
        chooseStyleBlock?(data.style)
        self.navigationController?.popViewController(animated: true)
    }
}
