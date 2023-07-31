//
//  CoreDataManager.swift
//  
//
//  Created by Евгений Таракин on 06.02.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(error):\(error.userInfo)")
            }
        }
        
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return CoreDataManager.persistentContainer.viewContext
    }()
    
    func saveContext() {
        let context = CoreDataManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("\(nsError):\(nsError.userInfo)")
            }
        }
    }
    
}
