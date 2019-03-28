//
//  LLIndicatorView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

//指示器宽度变化样式
public enum LLIndicatorViewWidthChangeStyle {
    /*跟Item等宽样式*/
    case equalToItemWidth(margin:CGFloat)
    /*爱奇艺宽带变化样式*/
    case jdIqiyi(baseWidth:CGFloat,changeWidth:CGFloat)
    /*固定宽度样式*/
    case stationary(baseWidth:CGFloat)
}

//指示器中心位置
public enum LLIndicatorViewCenterYGradientStyle {
    /*在正中心*/
    case center
    /*在顶部，跟顶部间距为margin*/
    case top(margin:CGFloat)
    /*在底部，跟底部间距为margin*/
    case bottom(margin:CGFloat)
}


//指示器形状样式:这里只是给定了几种常见的样式
public enum LLIndicatorViewShapeStyle{
    /*自定义类型,不做任何处理，由外部定义这个view的宽高*/
    case custom
    /*三角形*/
    case triangle(size:CGSize,color:UIColor)
    /*椭圆*/
    case ellipse(widthChangeStyle:LLIndicatorViewWidthChangeStyle,height:CGFloat,shadowColor:UIColor?)
    /*横杆*/
    case crossBar(widthChangeStyle:LLIndicatorViewWidthChangeStyle,height:CGFloat)
    /*背景*/
    case background(color:UIColor,img:UIImage?)
    /*QQ弹性小球*/
    case qqDragMsg(color:UIColor,height:CGFloat)
}


@objc public protocol LLIndicatorViewDelegate : NSObjectProtocol {
    @objc optional func indicatorView(indicatorView: LLIndicatorView, percent:CGFloat)
}


open class LLIndicatorView: UIView {
    public var contentView = UIView()
    public weak var delegate:LLIndicatorViewDelegate?
    private var qqShape:CAShapeLayer?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //上下变化位置
    public var centerYGradientStyle = LLIndicatorViewCenterYGradientStyle.bottom(margin: 0) {
        didSet{
            if let selfSuperView = self.superview {
                var selfCenter = self.center
                switch centerYGradientStyle {
                case .top(let margin):
                    selfCenter.y = margin + bounds.height/2
                case .center:
                    selfCenter.y = selfSuperView.bounds.height/2
                case .bottom(let margin):
                    selfCenter.y = selfSuperView.bounds.height - margin - bounds.height/2
                }
                self.center = selfCenter
            }
        }
    }
    
    //宽度变化样式
    public var widthChangeStyle = LLIndicatorViewWidthChangeStyle.stationary(baseWidth: 10) {
        didSet{
            var targetWidth = self.bounds.width
            switch widthChangeStyle {
            case .equalToItemWidth:
                return
            case .jdIqiyi(let baseWidth, _):
                targetWidth = baseWidth
            case .stationary(let baseWidth):
                targetWidth = baseWidth
            }
            var selfBounds = self.bounds
            selfBounds.size.width = targetWidth
            self.bounds = selfBounds
        }
    }
    
    //形状变化样式
    public var shapeStyle = LLIndicatorViewShapeStyle.custom {
        didSet{
            self.layer.contents = nil
            switch shapeStyle {
            case .custom:
                break
            case .background(let color, let img):
                self.centerYGradientStyle = .center
                self.widthChangeStyle = .equalToItemWidth(margin: 0)
                self.backgroundColor = color
                self.layer.contents = img?.cgImage
                
                var selfFrame = self.frame
                selfFrame.size.height = superview?.bounds.height ?? selfFrame.height
                self.frame = selfFrame
                self.autoresizingMask = [.flexibleHeight]
            case .crossBar(let widthChangeStyle,let height):
                self.widthChangeStyle = widthChangeStyle
                self.centerYGradientStyle = .bottom(margin: 0)
                var selfBounds = self.bounds
                selfBounds.size.height = height
                self.bounds = selfBounds
            case .triangle(let size,let color):
                self.widthChangeStyle = .stationary(baseWidth: size.width)
                self.centerYGradientStyle = .bottom(margin: 0)
                var selfBounds = self.bounds
                selfBounds.size = size
                self.bounds = selfBounds
                
                let trianglePath = UIBezierPath()
                trianglePath.move(to: CGPoint.init(x: size.width/2, y: 0))
                trianglePath.addLine(to: CGPoint.init(x: size.width, y: size.height))
                trianglePath.addLine(to: CGPoint.init(x: 0, y: size.height))
                trianglePath.close()
                
                let triangleShape = CAShapeLayer()
                triangleShape.path = trianglePath.cgPath
                triangleShape.lineWidth = 0
                triangleShape.fillColor = color.cgColor
                contentView.layer.addSublayer(triangleShape)
                
                self.backgroundColor = UIColor.clear
                self.contentView.backgroundColor = UIColor.clear
            case .ellipse(let widthChangeStyle, let height,let shadowColor):
                self.widthChangeStyle = widthChangeStyle
                self.centerYGradientStyle = .center
                
                var selfBounds = self.bounds
                selfBounds.size.height = height
                self.bounds = selfBounds
                
                self.layer.cornerRadius = height/2
                if shadowColor != nil {
                    self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
                    self.layer.shadowColor = shadowColor!.cgColor;
                    self.layer.shadowRadius = 3;
                    self.layer.shadowOffset = CGSize.init(width: 3, height: 4);
                    self.layer.shadowOpacity = 0.6;
                }
            case .qqDragMsg(_,let height):
                self.bounds = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: height)
                self.widthChangeStyle = .jdIqiyi(baseWidth: height, changeWidth: 5)
                self.centerYGradientStyle = .bottom(margin: 0)
                self.backgroundColor = UIColor.clear
                break
            }
        }
    }
}

extension LLIndicatorView{
    fileprivate func handleQQMsgStyle(leftItemView:LLSegmentBaseItemView) {
        switch self.shapeStyle {
        case .qqDragMsg(let color,let height):
            self.backgroundColor = UIColor.clear
            if qqShape == nil {
                let qqShape = CAShapeLayer()
                qqShape.backgroundColor = color.cgColor
                qqShape.lineWidth = 0
                qqShape.strokeColor = UIColor.clear.cgColor
                qqShape.fillColor = color.cgColor
                layer.addSublayer(qqShape)
                self.qqShape = qqShape
            }
            
            let baseRadius:CGFloat = 2
            let leftRectRadius:CGFloat = 7 * leftItemView.percent + baseRadius
            let leftRect = CGRect.init(x: 0, y: (bounds.height - leftRectRadius)/2, width: leftRectRadius, height: leftRectRadius)
            let rightRect = CGRect.init(x: bounds.width - height, y: 0, width: height, height: height)
            qqShape?.path = qqShapPath(smallRect: leftRect, bigRect: rightRect).cgPath
        default:
            qqShape?.removeFromSuperlayer()
        }
    }
}

extension LLIndicatorView{
    //滚动时变化宽度
    internal func reloadLayout(leftItemView: LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView){
        //center.X
        var selfCenter = self.center
        selfCenter.x = interpolationFrom(from: leftItemView.center.x, to: rightItemView.center.x, percent: rightItemView.percent)
        self.center = selfCenter
        
        //bounds.width
        var targetWidth = self.bounds.width
        switch widthChangeStyle {
        case .equalToItemWidth(let margin):
            let leftItemWidth = leftItemView.bounds.width
            let rightItemWidth = rightItemView.bounds.width
            targetWidth = interpolationFrom(from: leftItemWidth, to: rightItemWidth, percent: rightItemView.percent)
            targetWidth -= 2*margin
        case .jdIqiyi(let baseWidth,let changeWidth):
            let percent = 1 - abs(0.5-leftItemView.percent)*2   //变化范围（0....1.....0）
            let minX = leftItemView.center.x - baseWidth/2
            let maxX = rightItemView.center.x - baseWidth/2
            targetWidth = percent * (maxX - minX - changeWidth) + baseWidth
            
        case .stationary(let baseWidth):
            targetWidth = baseWidth
        }
        var selfBounds = self.bounds
        selfBounds.size.width = targetWidth
        self.bounds = selfBounds
        delegate?.indicatorView?(indicatorView: self, percent: leftItemView.percent)
        
        self.handleQQMsgStyle(leftItemView: leftItemView)
    }
    
    //最终停留不动下来的宽度
    internal func finalWidthOn(itemView:LLSegmentBaseItemView)->CGFloat{
        let itemViewWidth = itemView.frame.width
        var width:CGFloat = 0
        switch widthChangeStyle {
        case .equalToItemWidth(let margin):
            width = itemViewWidth - 2*margin
        case .jdIqiyi(let baseWidth,_):
            width = baseWidth
        case .stationary(let baseWidth):
            width = baseWidth
        }
        return width
    }
}



