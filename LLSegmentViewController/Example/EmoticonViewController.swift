//
//  EmoticonView.swift
//  LLSegmentViewController
//
//  Created by apple on 2021/6/25.
//  Copyright © 2021 lilin. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let screenW  = UIScreen.main.bounds.size.width
        let screenH  = UIScreen.main.bounds.size.height
        let height:CGFloat = 400
        let emoticonView = EmoticonView.init(frame: CGRect.init(x: 0, y: screenH - height - mSafeBottomMargin(), width: screenW, height: height))
        view.addSubview(emoticonView)
    }
}
