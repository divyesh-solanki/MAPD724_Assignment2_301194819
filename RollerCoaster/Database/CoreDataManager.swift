//
//  CoreDataManager.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 02/04/2022


import UIKit
import CoreData

class CoreDataManager: NSObject {
    static var sharedInstance = CoreDataManager()
    static var DB:String = "Database"
    var operationQueue = OperationQueue.init()
    
    override init() {
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    private lazy var applicationSupportDirectory: URL = {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataManager.DB, withExtension: "mom")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(CoreDataManager.DB + ".sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            managedObjectContext = self.persistentContainer.viewContext
            managedObjectContext?.mergePolicy = NSMergePolicy.init(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        } else {
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            managedObjectContext?.mergePolicy = NSMergePolicy.init(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)

        }
        return managedObjectContext!
    }()
    
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: CoreDataManager.DB)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    // MARK: - Core Data Saving support
    
    func saveContext (_ finished: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.managedObjectContext.perform {
                if self.managedObjectContext.hasChanges {
                    do {
                        try self.managedObjectContext.save()

                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        let detailedError = nserror.userInfo[NSDetailedErrorsKey]
                        if detailedError != nil {
                            print(detailedError!)
                        }
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                    print("reset")
                    if finished != nil {
                        finished?()
                    }
                } else {
                    if finished != nil {
                        finished?()
                    }
                }
            }
        }
    }
    
    func deleteData(forEntity entity : String ) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try self.managedObjectContext.execute(deleteRequest)
            self.saveContext()
        } catch {
            print("There was an error")
        }
    }
    
}
