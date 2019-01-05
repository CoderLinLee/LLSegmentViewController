//
//  LLSegmentItemBadgeTitleView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/20.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

let LLSegmentRedBadgeValue = "redBadgeValue"
class LLSegmentItemBadgeTitleView:LLSegmentItemTitleView {
    let badgeValueLabel = UILabel()
    private let badgeValueObserverKeyPath = "badgeValue"
    required init(frame: CGRect) {
        super.init(frame: frame)

        badgeValueLabel.backgroundColor = UIColor.red
        badgeValueLabel.textAlignment = .center
        badgeValueLabel.textColor = UIColor.white
        badgeValueLabel.font = UIFont.systemFont(ofSize: 12)
        badgeValueLabel.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        badgeValueLabel.center = CGPoint.init(x: bounds.width - 10, y: 10)
        addSubview(badgeValueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var associateViewCtl: UIViewController? {
        didSet{
            associateViewCtl?.tabBarItem.addObserver(self, forKeyPath: badgeValueObserverKeyPath, options: [.new], context: nil)
        }
    }
    
    deinit {
        associateViewCtl?.tabBarItem.removeObserver(self, forKeyPath: badgeValueObserverKeyPath)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        badgeValueLabel.text = associateViewCtl?.tabBarItem.badgeValue
        badgeValueLabel.sizeToFit()
        if let badgeColor = associateViewCtl?.tabBarItem.badgeColor {
            badgeValueLabel.backgroundColor = badgeColor
        }
        
        var badgeValueLabelFrame = badgeValueLabel.frame
        if associateViewCtl?.tabBarItem.badgeValue == LLSegmentRedBadgeValue {
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width = 5
            badgeValueLabelFrame.size.height = 5
            badgeValueLabel.text = ""
        }else if associateViewCtl?.tabBarItem.badgeValue == nil {
            badgeValueLabel.isHidden = true
        }else{
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width += 10
            badgeValueLabelFrame.size.height += 5
            badgeValueLabelFrame.size.width = max(badgeValueLabelFrame.width, badgeValueLabelFrame.height)
        }
        badgeValueLabel.frame = badgeValueLabelFrame
        badgeValueLabel.center = CGPoint.init(x: titleLabel.frame.maxX + 5, y: titleLabel.frame.minY - 5)
        
        badgeValueLabel.layer.cornerRadius = badgeValueLabel.bounds.height/2
        badgeValueLabel.clipsToBounds = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath ==  badgeValueObserverKeyPath{
            layoutSubviews()
        }
    }
}
