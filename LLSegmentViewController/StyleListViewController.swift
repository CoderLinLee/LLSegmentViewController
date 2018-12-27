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
        tableView.rowHeight = 60
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
}


extension StyleListViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customTabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = customTabs[indexPath.row].title + ":" + customTabs[indexPath.row].exampleCtlName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = customTabs[indexPath.row]
        let controllerName = cellModel.exampleCtlName
        
        //1:动态获取命名空间
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        
        
        if let classType: AnyObject.Type = NSClassFromString(spaceName + "." + controllerName){
            if let viewCtlType : UIViewController.Type = classType as? UIViewController.Type{
                let viewCtl: UIViewController = viewCtlType.init(nibName: nil, bundle: nil)
                viewCtl.title = cellModel.title
                self.navigationController?.pushViewController(viewCtl, animated: true)
            }
        }
    }
}
