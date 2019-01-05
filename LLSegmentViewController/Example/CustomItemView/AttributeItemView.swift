//
//  AttributeItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class AttributeItemView: LLSegmentBaseItemView {
    let titleLabel = UILabel()
    required init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.frame = bounds
        titleLabel.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var associateViewCtl: UIViewController?{
        didSet{
            var titleStr1 = ""
            if let titleStr = associateViewCtl?.title{
                titleStr1 = titleStr
            }
            let titles = titleStr1.components(separatedBy: "\n")
            if let fistTitle = titles.first,
               let lastTitle = titles.last {
                let contentStr = fistTitle + "\n" + lastTitle
                let firstAttributes = [NSAttributedStringKey.foregroundColor:UIColor.blue]
                let lastAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]

                let attributedText = NSMutableAttributedString(string: contentStr, attributes: nil)
                attributedText.addAttributes(firstAttributes, range: NSRange.init(location: 0, length: fistTitle.count))
                attributedText.addAttributes(lastAttributes, range: NSRange.init(location: contentStr.count - lastTitle.count, length: lastTitle.count))
                attributedText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)], range: NSRange.init(location: 0, length: contentStr.count))
                titleLabel.attributedText = attributedText
            }
        }
    }
    
    override func itemWidth() -> CGFloat {
        return 100
    }
}



class AttributeItemViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initCtls()
        initSegmentCtlView()
    }
    
    func initCtls() {
        let segmentCtlFrame =  CGRect.init(x: 0, y: 64, width: view.bounds.width, height: 50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
        let titles = ["周一\n8月20号","周二\n8月21号","周三\n8月22号","周四\n8月23号","周五\n8月24号","周六\n8月25号","周七\n8月26号"]
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = TestViewController()
            ctl.showTableView = false
            ctl.title = title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }
    
    func initSegmentCtlView() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        let ctlViewStyle = LLSegmentCtlViewStyle(itemSpacing: 0, segmentItemViewClass: AttributeItemView.self, itemViewStyle: titleViewStyle, defaultSelectedIndex: 0)
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
