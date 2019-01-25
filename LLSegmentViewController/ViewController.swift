//
//  ViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


let indicatiorcustomTabs = [CellModel(title: "0Segment样式", viewControllerClass: LLMsgViewController.self),
                            CellModel(title: "1Title样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "2京东样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "3爱奇艺样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "4回滚样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "5与cell同宽样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "6分割线样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "7背景样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "8椭圆形样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "9椭圆形阴影样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "10文字遮罩无背景样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "11文字遮罩有背景样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "12文字遮罩有背景有阴影样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "13三角形样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "14小红点和数字样式", viewControllerClass: BadgeValueViewController.self),
                            CellModel(title: "15点线效果样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "16QQ红点样式", viewControllerClass: TitleViewController.self),]

let customTab = [CellModel(title: "0微信样式", viewControllerClass: SimpleTabViewController.self),
                 CellModel(title: "1微博样式", viewControllerClass: SinaViewController.self),
                 CellModel(title: "2背景色或图片样式", viewControllerClass: BackColorViewController.self)]

let specialTab = [CellModel(title: "0嵌套样式", viewControllerClass: NestViewController.self),
                  CellModel(title: "1足球样式", viewControllerClass: FootballViewController.self),
                  CellModel(title: "2插入样式", viewControllerClass: InsertViewController.self),
                  CellModel(title: "3混合样式", viewControllerClass: MixViewController.self),
                  CellModel(title: "4IndicatorImageView底部样式", viewControllerClass: ChangeImageViewViewController.self),
                  CellModel(title: "5title&image样式", viewControllerClass: TitleImageItemViewController.self),
                  CellModel(title: "6上拉隐藏导航栏下拉显示导航栏", viewControllerClass: NavHidenChangeLayoutViewController.self)]

let customItemViewTab = [CellModel(title: "0背景色渐变样式", viewControllerClass:
    BackgroundColorGradientItemViewController.self),
                         CellModel(title: "1富文本样式", viewControllerClass: AttributeItemViewController.self),
                         CellModel(title: "3网易新闻样式", viewControllerClass: WangYiItemViewController.self),]


let detailItemViewTab = [CellModel(title: "0个人中心", viewControllerClass:PersonDetailViewController.self),
                         CellModel(title: "1导航栏隐藏", viewControllerClass: HidenNavViewController.self),
                         CellModel(title: "3列表刷新", viewControllerClass: ListRefreshViewController.self),
                         CellModel(title: "4顶部刷新", viewControllerClass: TopRefreshViewController.self),]

class ViewController: UIViewController {
    var dataArr = ["指示器样式","特殊样式","自定义TabViewController","自定义ItemView","详情页"]
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LLSegmentViewController"
        initSubView()
    }
}


extension ViewController {
    func initSubView() {
        let topInsert:CGFloat = 0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets.init(top: -topInsert, left: 0, bottom: 0, right: 0)
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let styleListCtl = StyleListViewController()
        styleListCtl.title = dataArr[indexPath.row]
        if indexPath.row == 0 {
            styleListCtl.customTabs = indicatiorcustomTabs
        }else if indexPath.row == 1 {
            styleListCtl.customTabs = specialTab
        }else if indexPath.row == 2 {
            styleListCtl.customTabs = customTab
        }else if indexPath.row == 3{
            styleListCtl.customTabs = customItemViewTab
        }else if indexPath.row == 4{
            styleListCtl.customTabs = detailItemViewTab
        }
        self.navigationController?.pushViewController(styleListCtl, animated: true)

    }
}
