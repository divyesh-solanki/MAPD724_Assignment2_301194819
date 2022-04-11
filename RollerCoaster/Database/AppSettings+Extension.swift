//
//  AppSettings+Extension.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 02/04/2022

import Foundation
import CoreData

extension AppSettings {
    class func getSettings() -> AppSettings? {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSettings")
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchLimit = 1
        do {
            let arrData = try managedContext.fetch(fetchRequest)
            if let arr = arrData as? [AppSettings] {
                return arr.first
            }
        } catch let error {
            print("Could not fetch \(error), \(error.localizedDescription)")
        }
        return nil
    }
    class func setSettings(balance: Int? = nil, theme: String? = nil) {
        var model: AppSettings?
        if let objModel = getSettings() {
            model = objModel
        } else {
            model = AppSettings.createInContext(context: CoreDataManager.sharedInstance.managedObjectContext)
        }
        if let val = balance {
            model?.balance = Int64(val)
        }
        if let val = theme {
            model?.theme = val
        }
        CoreDataManager.sharedInstance.saveContext()
    }
}
