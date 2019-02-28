//
//  FontConst.swift
//  Beehive
//
//  Created by yilunzheluo on 2019/2/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

import UIKit

class FontConst: NSObject {
    //PingFang字体
    @objc
    static func PingFangSCRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: size)
    }
    
    @objc
    static func PingFangSCSemibold(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: size)
    }
    
    @objc
    static func PingFangSCMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: size)
    }
}
