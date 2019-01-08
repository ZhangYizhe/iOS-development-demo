//
//  ThemeManageModel.swift
//  themeManage
//
//  Created by Yizhe.Zhang on 2018/12/28.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit

class Theme {
    
    enum type {
        case day
        case night
    }
    
    var now : type {
        get {
            let defaults = UserDefaults.standard
            switch defaults.integer(forKey: "theme") {
            case 0:
                return .day
            case 1:
                return .night
            default:
                return .day
            }
        }
        set {
            switch newValue {
            case .day:
                let defaults = UserDefaults.standard
                defaults.set(0,forKey:"theme")
            case .night:
                let defaults = UserDefaults.standard
                defaults.set(1,forKey:"theme")
            }
            
        }
    }
    
    var background : UIColor {
        get {
            switch now {
            case .day:
                return .white
            case .night:
                return .black
            }
        }
    }
    
    var button : UIColor {
        get {
            switch now {
            case .day:
                return .blue
            case .night:
                return .white
            }
        }
    }
    
    var label : UIColor {
        get {
            switch now {
            case .day:
                return .black
            case .night:
                return .white
            }
        }
    }
    
    var line : UIColor {
        get {
            switch now {
            case .day:
                return .black
            case .night:
                return .white
            }
        }
    }
    
    
}
