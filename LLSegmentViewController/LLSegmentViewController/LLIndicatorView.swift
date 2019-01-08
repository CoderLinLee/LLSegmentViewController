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
    case equalToItemWidth
    case jdIqiyi(baseWidth:CGFloat,changeWidth:CGFloat)
    case stationary(baseWidth:CGFloat)
}

//指示器中心位置
public enum LLIndicatorViewCenterYGradientStyle {
    case center
    case top(margin:CGFloat)
    case bottom(margin:CGFloat)
}


//指示器形状样式
public enum LLIndicatorViewShapeStyle{
    /*自定义类型*/
    case custom
    /*三角形*/
    case triangle(size:CGSize,color:UIColor)
    /*椭圆*/
    case ellipse(widthChangeStyle:LLIndicatorViewWidthChangeStyle,height:CGFloat,shadowColor:UIColor?)
    /*横杆*/
    case crossBar(widthChangeStyle:LLIndicatorViewWidthChangeStyle,height:CGFloat)
    /*横杆*/
    case background(color:UIColor,img:UIImage?)
}


@objc public protocol LLIndicatorViewDelegate : NSObjectProtocol {
    @objc optional func indicatorView(indicatorView: LLIndicatorView, percent:CGFloat)
}


open class LLIndicatorView: UIView {
    public var contentView = UIView()
    public var delegate:LLIndicatorViewDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
                    selfCenter.y = selfSuperView.bounds.height - margin
                }
                self.center = selfCenter
            }
        }
    }
    
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
    
    public var shapeStyle = LLIndicatorViewShapeStyle.custom {
        didSet{
            self.layer.contents = nil
            switch shapeStyle {
            case .custom:
                break
            case .background(let color, let img):
                self.centerYGradientStyle = .center
                self.widthChangeStyle = .equalToItemWidth
                self.backgroundColor = color
                self.layer.contents = img?.cgImage
                
                var selfFrame = self.frame
                selfFrame.size.height = superview?.bounds.height ?? selfFrame.height
                self.frame = selfFrame
                self.autoresizingMask = [.flexibleHeight]
            case .crossBar(let widthChangeStyle,let height):
                self.widthChangeStyle = widthChangeStyle
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
            }
        }
    }
    
    internal func reloadLayout(leftItemView: LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView){
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
        }
        var selfBounds = self.bounds
        selfBounds.size.width = targetWidth
        self.bounds = selfBounds
        delegate?.indicatorView?(indicatorView: self, percent: leftItemView.percent)
    }
}



