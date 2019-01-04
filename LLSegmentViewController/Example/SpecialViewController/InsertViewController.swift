//
//  InsertViewController.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class InsertViewController: TitleViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "添加", style: .plain, target: self, action: #selector(insert))
    }

    @objc func insert() {
        let ctl = TestViewController()
        let rang:UInt32 = UInt32(ctls.count)
        let index = Int(arc4random()%rang)
        ctl.title = "添加序号" + "\(index)"
        insertOneViewController(ctl: ctl, index: index)
    }

}
