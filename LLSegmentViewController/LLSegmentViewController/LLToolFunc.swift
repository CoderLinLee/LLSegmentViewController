//
//  LLSegmentConst.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/19.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


public func interpolationFrom(from:CGFloat,to:CGFloat,percent:CGFloat) -> CGFloat{
    let ratio = max(0, min(1, percent))
    return from + (to - from)*ratio
}

public func interpolationColorFrom(fromColor:UIColor,toColor:UIColor,percent:CGFloat) ->UIColor {
    var fromR:CGFloat = 0
    var fromG:CGFloat = 0
    var fromB:CGFloat = 0
    var fromA:CGFloat = 0
    fromColor.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
    
    var toR:CGFloat = 0
    var toG:CGFloat = 0
    var toB:CGFloat = 0
    var toA:CGFloat = 0
    toColor.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
    
    let red = interpolationFrom(from: fromR, to: toR, percent: percent)
    let green = interpolationFrom(from: fromG, to: toG, percent: percent)
    let blue = interpolationFrom(from: fromB, to: toB, percent: percent)
    let alpha = interpolationFrom(from: fromA, to: toA, percent: percent)
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
}


//https://github.com/wanhmr/QQMessageButton
internal func qqShapPath(smallRect:CGRect,bigRect:CGRect) -> UIBezierPath  {
    let center1 = CGPoint.init(x: smallRect.midX, y: smallRect.midY)
    let r1 = smallRect.width/2
    let center2 = CGPoint.init(x: bigRect.midX, y: bigRect.midY)
    let r2 = bigRect.width/2
    let d = pointToPointDistanceWithPoint(point1: center1, point2: center2)
    
    let path = UIBezierPath()
    let smallRectPath = UIBezierPath.init(arcCenter: center1, radius: smallRect.width/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
    let bigRectPath = UIBezierPath.init(arcCenter: center2, radius: bigRect.width/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
    path.append(smallRectPath)
    path.append(bigRectPath)
    if d == 0 {
        return path
    }
    
    let x1 = center1.x
    let x2 = center2.x
    let y1 = center1.y
    let y2 = center2.y
    let cosθ = (y2 - y1) / d
    let sinθ = (x2 - x1) / d
    let A = CGPoint(x: x1 - r1 * cosθ, y: y1 + r1 * sinθ)
    let B = CGPoint(x: x1 + r1 * cosθ, y: y1 - r1 * sinθ)
    let C = CGPoint(x: x2 + r2 * cosθ, y: y2 - r2 * sinθ)
    let D = CGPoint(x: x2 - r2 * cosθ, y: y2 + r2 * sinθ)
    let O = CGPoint(x: A.x + sinθ * d / 2 , y:  A.y + cosθ * d / 2)
    let P = CGPoint(x: B.x + sinθ * d / 2 , y:  B.y + cosθ * d / 2)
    
    path.move(to: A)
    path.addLine(to: B)
    path.addQuadCurve(to: C, controlPoint: P)
    path.addLine(to: D)
    path.addQuadCurve(to: A, controlPoint: O)
    return path
}

//MARK: - 两点之间距离
fileprivate func pointToPointDistanceWithPoint(point1: CGPoint, point2: CGPoint) ->CGFloat {
    let xDistance = point2.x - point1.x
    let yDistance = point2.y - point1.y
    return sqrt(xDistance * xDistance + yDistance * yDistance)
}


extension String {
    internal func LLGetStrSize(font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        let strSize = (self as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
        return strSize
    }
}


//导航栏+状态栏的高度
public func mTopHeight(mNavBarHeight:CGFloat = 44)->CGFloat {
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
    let IPHONEX = (mScreenHeight == 812 && mScreenWidth == 375) || (mScreenHeight == 375 && mScreenWidth == 812)
    let IPHONEXS_Max = (mScreenHeight == 896 && mScreenWidth == 414) || (mScreenHeight == 414 && mScreenWidth == 896)
    let IsAllScreen = (IPHONEX || IPHONEXS_Max)
    let mStatusBarHeight: CGFloat = IsAllScreen ? 44.0 : 20.0
    return mStatusBarHeight + mNavBarHeight
}

public func mSafeBottomMargin()->CGFloat {
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
    let IPHONEX = (mScreenHeight == 812 && mScreenWidth == 375) || (mScreenHeight == 375 && mScreenWidth == 812)
    let IPHONEXS_Max = (mScreenHeight == 896 && mScreenWidth == 414) || (mScreenHeight == 414 && mScreenWidth == 896)
    let IsAllScreen = (IPHONEX || IPHONEXS_Max)
    let mSafeBottomMargin: CGFloat = IsAllScreen ? 34 : 0
    return mSafeBottomMargin
}


extension UIViewController{
    internal func ctlTitle()->String{
        var title = ""
        if self.title != nil {
            title = self.title ?? ""
        }else if self.tabBarItem.title != nil{
            title = self.tabBarItem.title ?? ""
        }
        return title
    }
}

