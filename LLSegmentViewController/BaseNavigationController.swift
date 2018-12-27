//
//  BaseNavigationController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/27.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backBtnItem = UIBarButtonItem(image: UIImage(named: "pop-icon-back-normal"), style: .plain, target: self, action: #selector(popAction))
        viewController.navigationItem.leftBarButtonItem = backBtnItem
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func popAction() {
        popViewController(animated: true)
    }
}
