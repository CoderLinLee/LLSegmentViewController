//
//  LLIndicatorView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

public enum LLIndicatorViewWidthChangeStyle {
    case normal
    case equalToItemWidth
    case jdIqiyi(baseWidth:CGFloat,changeWidth:CGFloat)
    case stationary(baseWidth:CGFloat)
}

public enum LLIndicatorViewCenterYGradientStyle {
    case center
    case top(margin:CGFloat)
    case bottom(margin:CGFloat)
}


@objc protocol LLIndicatorViewDelegate : NSObjectProtocol {
    @objc optional func indicatorView(indicatorView: LLIndicatorView, percent:CGFloat)
}


public class LLIndicatorView: UIView {
    var contentView = UIView()
    var delegate:LLIndicatorViewDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var centerYGradientStyle = LLIndicatorViewCenterYGradientStyle.bottom(margin: 0) {
        didSet{
            if let selfSuperView = self.superview {
                var selfCenter = self.center
                switch centerYGradientStyle {
                case .top(let margin):
                    selfCenter.y = margin + bounds.height/2
                case .center:
                    selfCenter.y = selfSuperView.bounds.height/2
                case .bottom(let margin):
                    selfCenter.y = selfSuperView.bounds.height - margin
                }
                self.center = selfCenter
            }
        }
    }
    
    var widthChangeStyle = LLIndicatorViewWidthChangeStyle.normal {
        didSet{
            var targetWidth = self.bounds.width
            switch widthChangeStyle {
            case .equalToItemWidth:
                return
            case .jdIqiyi(let baseWidth, _):
                targetWidth = baseWidth
            case .stationary(let baseWidth):
                targetWidth = baseWidth
            default:
                break
            }
            var selfBounds = self.bounds
            selfBounds.size.width = targetWidth
            self.bounds = selfBounds
        }
    }
    
    func reloadIndicatorViewLayout(segMegmentCtlView: LLSegmentCtlView, leftItemView: LLSegmentCtlItemView,rightItemView:LLSegmentCtlItemView){
        //center.X
        var selfCenter = self.center
        selfCenter.x = interpolationFrom(from: leftItemView.center.x, to: rightItemView.center.x, percent: rightItemView.percent)
        self.center = selfCenter
        
        //bounds.width
        var targetWidth = self.bounds.width
        switch widthChangeStyle {
        case .equalToItemWidth:
            let leftItemWidth = leftItemView.bounds.width
            let rightItemWidth = rightItemView.bounds.width
            targetWidth = interpolationFrom(from: leftItemWidth, to: rightItemWidth, percent: rightItemView.percent)
        case .jdIqiyi(let baseWidth,let changeWidth):
            let percent = 1 - fabs(0.5-leftItemView.percent)*2   //变化范围（0....1.....0）
            let minX = leftItemView.center.x - baseWidth/2
            let maxX = rightItemView.center.x - baseWidth/2
            targetWidth = percent * (maxX - minX - changeWidth) + baseWidth
        case .stationary(let baseWidth):
            targetWidth = baseWidth
        default:
            break
        }
        var selfBounds = self.bounds
        selfBounds.size.width = targetWidth
        self.bounds = selfBounds
        delegate?.indicatorView?(indicatorView: self, percent: leftItemView.percent)
    }
}



