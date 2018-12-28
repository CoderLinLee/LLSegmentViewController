//
//  ViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

let indicatiorcustomTabs = [CellModel(title: "Segment样式", viewControllerClass: LLMsgViewController.self),
                            CellModel(title: "Title样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "京东样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "爱奇艺样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "回滚样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "与cell同宽样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "分割线样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "方形样式", viewControllerClass: TitleViewController.self),
                            CellModel(title: "椭圆形样式", viewControllerClass: TitleViewController.self),]

let customTab = [CellModel(title: "微信样式", viewControllerClass: SimpleTabViewController.self),
                 CellModel(title: "微博样式", viewControllerClass: SinaViewController.self)]

class ViewController: UIViewController {
    var dataArr = ["指示器样式","特殊样式","自定义TabViewController"]
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
        tableView.rowHeight = 60
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
            
        }else if indexPath.row == 2 {
            styleListCtl.customTabs = customTab
        }
        self.navigationController?.pushViewController(styleListCtl, animated: true)

    }
}
