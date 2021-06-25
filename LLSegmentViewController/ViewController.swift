//
//  ViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit
let simpleTabs = [CellModel(title: "0简单的样式", viewControllerClass: SimpDemoViewController.self),
                  CellModel(title: "1导航栏样式", viewControllerClass: NavViewController.self),]


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
                            CellModel(title: "16QQ红点样式", viewControllerClass: TitleViewController.self)]

let specialTab = [CellModel(title: "0嵌套样式", viewControllerClass: NestViewController.self),
                  CellModel(title: "1足球样式", viewControllerClass: FootballViewController.self),
                  CellModel(title: "2插入样式", viewControllerClass: InsertViewController.self),
                  CellModel(title: "3混合样式", viewControllerClass: MixViewController.self),
                  CellModel(title: "4IndicatorImageView底部样式", viewControllerClass: ChangeImageViewViewController.self),
                  CellModel(title: "5title&image样式", viewControllerClass: TitleImageItemViewController.self),
                  CellModel(title: "6上拉隐藏导航栏下拉显示导航栏", viewControllerClass: NavHidenChangeLayoutViewController.self)]

let customTab = [CellModel(title: "0微信样式", viewControllerClass: SimpleTabViewController.self),
                 CellModel(title: "1微博样式", viewControllerClass: SinaViewController.self),
                 CellModel(title: "2背景色或图片样式", viewControllerClass: BackColorViewController.self)]

let customItemViewTab = [CellModel(title: "0背景色渐变样式", viewControllerClass:
    BackgroundColorGradientItemViewController.self),
                         CellModel(title: "1富文本样式", viewControllerClass: AttributeItemViewController.self),
                         CellModel(title: "3网易新闻样式", viewControllerClass: WangYiItemViewController.self),]


let detailItemViewTab = [CellModel(title: "0个人中心", viewControllerClass:PersonDetailViewController.self),
                         CellModel(title: "1导航栏隐藏", viewControllerClass: HidenNavViewController.self),
                         CellModel(title: "3列表刷新", viewControllerClass: ListRefreshViewController.self),
                         CellModel(title: "4顶部刷新", viewControllerClass: TopRefreshViewController.self),
                         CellModel(title: "5商品详情", viewControllerClass: GoodsDetailViewController.self),]


let segMentViewTab = [CellModel(title: "0表情包", viewControllerClass:EmoticonViewController.self),]

struct ListItemModel {
    var title:String
    var customTabs: [CellModel]
}

class ViewController: UIViewController {
    
    let dataArr = [ListItemModel.init(title: "简单样式", customTabs: simpleTabs),
                   ListItemModel.init(title: "指示器样式", customTabs: indicatiorcustomTabs),
                   ListItemModel.init(title: "特殊样式", customTabs: specialTab),
                   ListItemModel.init(title: "自定义TabViewController", customTabs: customTab),
                   ListItemModel.init(title: "自定义ItemView", customTabs: customItemViewTab),
                   ListItemModel.init(title: "详情页", customTabs: detailItemViewTab),
                   ListItemModel.init(title: "segmentViewDemo", customTabs: segMentViewTab)]
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LLSegmentViewController"
        initTableView()
        
        var statusBarHeight:CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        }
        print(statusBarHeight)
    }
    
}


extension ViewController {
    static let cellIndentifier = "cell"
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: ViewController.cellIndentifier)
        view.addSubview(tableView)
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIndentifier)!
        cell.textLabel?.text = dataArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let styleListCtl = StyleListViewController()
        styleListCtl.customTabs = dataArr[indexPath.row].customTabs
        styleListCtl.title = dataArr[indexPath.row].title
        styleListCtl.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(styleListCtl, animated: true)
    }
}



class NumberO {
    var s = 0
    required init() {
        
    }
}

protocol BaseNumber {
    associatedtype S = NumberO
}

class Base:BaseNumber {
    var num:S = S()
}


class NumberOO: NumberO {
    var c = 0
}

class Item: Base {
    func test()->Base {
        num.s = 10
        
        
        let b = Base.init()
        b.num = NumberOO.init()
        return b
    }
}

