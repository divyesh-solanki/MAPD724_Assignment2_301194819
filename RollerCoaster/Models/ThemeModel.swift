//
//  ThemeModel.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import UIKit

struct ThemeConfig {
    var primaryColor : UIColor?
    var textColor : UIColor
}

enum Themes: String, CaseIterable {
    case Red = "Red"
    case Blue = "Blue"
    
    func themeConfig() -> ThemeConfig {
        switch self {
        case .Red:
            return ThemeConfig(primaryColor: UIColor(named: "AppRed"), textColor: UIColor(hex: "FFFFFF"))
        case .Blue:
            return ThemeConfig(primaryColor: UIColor(named: "AppBlue"), textColor: UIColor(hex: "FFFFFF"))
        }
    }
}
