//
//  NameService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class NameService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
}

extension NameService {
    
    func storeName(_ title: String?,
                   _ first: String?,
                   _ last: String?) -> CD_Name {
        let name = CD_Name(context: managedObjectContext)
        name.title = title
        name.first = first
        name.last = last
        
        coreDataStack.saveContext(managedObjectContext)
        return name
    }
}
