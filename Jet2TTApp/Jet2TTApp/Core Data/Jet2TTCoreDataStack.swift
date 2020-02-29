//
//  Jet2TTCoreDataStack.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 29/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import CoreData

class Jet2TTCoreDataStack {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores{ (persistentStoreDescription, error) in
            if let error = error as NSError? {
                print("Error : \(error)")
            }
        }
        return container
    }()
    
    func newDerivedContext() -> NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        self.saveContext(self.mainContext)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        
        if context !== mainContext {
            self.saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error: \(error)")
            }
        }
    }
    
    func saveDerivedContext(_ context: NSManagedObjectContext) {
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error: \(error)")
            }
        }
        
        self.saveContext(self.mainContext)
    }
}
