//
//  LLTestViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

func LLRandomRGB() -> UIColor {
    return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
}

func factoryCtl(title:String,imageName:String,selectedImageNameStr:String) -> UIViewController {
    let test2Ctl = TestViewController()
    test2Ctl.title = title
    test2Ctl.tabBarItem.image = UIImage.init(named: imageName)
    test2Ctl.tabBarItem.selectedImage = UIImage.init(named: selectedImageNameStr)
    return test2Ctl
}


class TestViewController: UIViewController {
    var showTableView = true
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = LLRandomRGB()
        if showTableView == true {
            initSubView()
        }
    }
}

extension TestViewController {
    func initSubView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
}


extension TestViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = (self.title ?? "") + "第\(indexPath.row)行"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarItem.badgeValue = "99"
    }
}
