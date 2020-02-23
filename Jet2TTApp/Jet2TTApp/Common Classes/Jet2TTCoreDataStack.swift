//
//  Jet2TTCoreDataStack.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import CoreData

class VACoreDataStack {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let persistentContainer = NSPersistentContainer(name: self.modelName)
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error as NSError? {
                print("\(error)")
            }
        }
        return persistentContainer
        
    }()
    
    func saveContext() {
        do {
            guard mainContext.hasChanges else { return }
            try mainContext.save()
        } catch let error as NSError {
            print("\(error)")
        }
    }
}
