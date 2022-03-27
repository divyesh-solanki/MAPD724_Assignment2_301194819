//
//  UserDefaultManager.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import Foundation

struct UserDefaultsManager {
    static let applicationDefaults = UserDefaults.standard
    static var Balance: Int {
        get {
            let value = applicationDefaults.integer(forKey: UserDefaultsKey.Balance)
            return value == 0 ? 1000 : value
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.Balance)
            applicationDefaults.synchronize()
        }
    }
}
