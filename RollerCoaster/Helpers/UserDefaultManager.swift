//
//  UserDefaultManager.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import Foundation

struct UserDefaultsManager {
    static var Balance: Int {
        get {
            let value = Int(AppSettings.getSettings()?.balance ?? 0)
            return value == 0 ? 1000 : value
        }
        set {
            AppSettings.setSettings(balance: newValue)
        }
    }
    static var Theme: String {
        get {
            let value = AppSettings.getSettings()?.theme
            return value == nil ? "Red" : value!
        }
        set {
            AppSettings.setSettings(theme: newValue)
        }
    }
}
