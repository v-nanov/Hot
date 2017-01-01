//
//  UIColor+HexExtension.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/15.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit

extension UIColor{
    static func colorWithHexString(_ hexString:String) -> UIColor{
        var red:UInt32 = 0;
        var green:UInt32 = 0;
        var blue:UInt32 = 0;
        
        /** R G B */
        var range = NSMakeRange(0, 2)
        
        /** R */
        let rHex = (hexString as NSString).substring(with:range)
        
        /** G */
        range.location = 2
        let gHex = (hexString as NSString).substring(with:range)
        
        /** B */
        range.location = 4
        let bHex = (hexString as NSString).substring(with:range)
        
        Scanner(string: rHex).scanHexInt32(&red)
        Scanner(string: gHex).scanHexInt32(&green)
        Scanner(string: bHex).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}
