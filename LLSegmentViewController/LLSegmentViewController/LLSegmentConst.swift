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



extension String {
    func LLGetStrSize(font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        let strSize = (self as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil).size
        return strSize
    }
}



