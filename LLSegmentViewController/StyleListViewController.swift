//
//  StyleListViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/27.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit



class StyleListViewController: UIViewController {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var customTabs = [CellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initSubView()
        
    }
}

extension StyleListViewController {
    func initSubView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
}


extension StyleListViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customTabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = customTabs[indexPath.row].title + ":" + "\(customTabs[indexPath.row].viewControllerClass)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = customTabs[indexPath.row]
        let ctlClass = cellModel.viewControllerClass
        let ctl = ctlClass.init(nibName: nil, bundle: nil)
        ctl.title = cellModel.title
        
        if let ctl = ctl as? TitleViewController{
            let titleViewStyle = LLSegmentItemTitleViewStyle()
            titleViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            titleViewStyle.unSelectedColor = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)
            titleViewStyle.extraTitleSpace = 10
            titleViewStyle.selectedTitleScale = 1
            //固定长度
            if indexPath.row == 1 {
                ctl.indicatorViewWidthChangeStyle = .stationary(baseWidth: 20)
            }else if indexPath.row == 2 {
                ctl.indicatorViewWidthChangeStyle = .jdIqiyi(baseWidth: 30, changeWidth: 0)
            }else if indexPath.row == 3 {
                ctl.indicatorViewWidthChangeStyle = .jdIqiyi(baseWidth: 30, changeWidth: 40)
            }else if indexPath.row == 4 {
                ctl.indicatorViewWidthChangeStyle = .jdIqiyi(baseWidth: 30, changeWidth: 140)
            }else if indexPath.row == 5 {
                ctl.indicatorViewWidthChangeStyle = .equalToItemWidth
            }else if indexPath.row == 6 {
                ctl.segmentCtlView.separatorLineShowEnabled = true
                ctl.segmentCtlView.separatorLineColor = UIColor.lightGray.withAlphaComponent(0.5)
                ctl.segmentCtlView.separatorTopBottomMargin = (15,15)
            }else if indexPath.row == 7 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.lightGray.withAlphaComponent(0.5), img: nil)
            }else if indexPath.row == 8 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .ellipse(widthChangeStyle: .equalToItemWidth, height: 20, shadowColor: nil)
                ctl.segmentCtlView.indicatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            }else if indexPath.row == 9 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .ellipse(widthChangeStyle: .equalToItemWidth, height: 20, shadowColor: UIColor.red)
                ctl.segmentCtlView.indicatorView.backgroundColor = UIColor.lightGray
            }else if indexPath.row == 10 {
                titleViewStyle.titleLabelMaskEnabled = true
                ctl.indicatorViewWidthChangeStyle = .jdIqiyi(baseWidth: 30, changeWidth: 0)
            }else if indexPath.row == 11 {
                titleViewStyle.titleLabelMaskEnabled = true
                ctl.segmentCtlView.indicatorView.shapeStyle = .ellipse(widthChangeStyle: .equalToItemWidth, height: 20, shadowColor: nil)
                ctl.segmentCtlView.indicatorView.backgroundColor = UIColor.lightGray
            }else if indexPath.row == 12 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .ellipse(widthChangeStyle: .equalToItemWidth, height: 20, shadowColor: UIColor.red)
                ctl.segmentCtlView.indicatorView.backgroundColor = UIColor.lightGray
            }else if indexPath.row == 13 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .triangle(size: CGSize.init(width: 30, height: 20),color:UIColor.blue)
            }else if indexPath.row == 14 {
                ctl.segmentCtlView.indicatorView.shapeStyle = .triangle(size: CGSize.init(width: 30, height: 20),color:UIColor.blue)
            }

            ctl.titleViewStyle = titleViewStyle
        }
        self.navigationController?.pushViewController(ctl, animated: true)
    }
}
