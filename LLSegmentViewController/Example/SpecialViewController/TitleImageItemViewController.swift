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
        let models = getModels(style: style)
        for model in models {
            let ctl = TitleImageViewController()
            ctl.showTableView = true
            ctl.model = model
            ctl.title = model.title
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





class TitleImageViewController: TestViewController,LLSegmentItemTitleImageViewProtocol {
    func refreshWhenPercentChange(titleLabel:UILabel,imageView: UIImageView, percent: CGFloat) {
        if percent < 0.5 {
            titleLabel.textColor = UIColor.lightGray
            imageView.image = UIImage.init(named: model.imgeStr)
        }else {
            titleLabel.textColor = UIColor.black
            imageView.image = UIImage.init(named: model.imgeStr + "_selected")
        }
    }
    
    var model:LLTitleImageModel!
}





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
        let tableView = addTableView()
        tableView.delegate = self
        tableView.dataSource = self
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




func getModels(style:LLTitleImageButtonStyle?)->[LLTitleImageModel] {
    let datas:[(title:String,imageStr:String)] = [
        ("螃蟹","watermelon"),
        ("麻辣小龙虾","lobster"),
        ("苹果","grape"),
        ("营养胡萝卜","crab"),
        ("葡萄","carrot"),
        ("美味西瓜","apple"),
        ("香蕉","grape")]
    var models = [LLTitleImageModel]()
    let margin:CGFloat = 2
    for (index,data) in datas.enumerated() {
        var newStyle = LLTitleImageButtonStyle.titleEmty
        if style != nil {
            newStyle = style!
        }else{
            if index == 0 {
                newStyle = LLTitleImageButtonStyle.titleTop(margin: margin)
            }else if index == 1{
                newStyle = LLTitleImageButtonStyle.titleRight(margin: margin)
            }else if index == 2{
                newStyle = LLTitleImageButtonStyle.titleLeft(margin: margin)
            }else if index == 3{
                newStyle = LLTitleImageButtonStyle.titleBottom(margin: margin)
            }else if index == 4{
                newStyle = LLTitleImageButtonStyle.titleEmty
            }else if index == 5{
                newStyle = LLTitleImageButtonStyle.titleOnly
            }
        }
        let model = LLTitleImageModel(title: data.title, imgeStr: data.imageStr, style: newStyle)
        models.append(model)
    }
    return models
}
