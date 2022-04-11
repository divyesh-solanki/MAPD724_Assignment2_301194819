//
//  NSManagedObject.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 02/04/2022


import UIKit
import CoreData
func objcast<T>(obj: AnyObject) -> T {
    return obj as! T
}

extension NSManagedObject {

    class func createInContext(context:NSManagedObjectContext) -> Self {
        let classname = entityName()
        let object: AnyObject = NSEntityDescription.insertNewObject(forEntityName: classname, into: context)
        return objcast(obj: object)
    }
    
    class func entityName() -> String {
        let classString = NSStringFromClass(self)
        // The entity is the last component of dot-separated class name:
        let components = classString.components(separatedBy: ".").last
        return components ?? classString
    }
    
}
