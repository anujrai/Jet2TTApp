//
//  DOBService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class DOBService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension DOBService {
    
    func storeDOB(_ age: Int16?, _ date: String?) -> CD_Dob {
        let dob = CD_Dob(context: self.managedObjectContext)
        dob.age = age ?? -1
        dob.date = date
        
        coreDataStack.saveContext(self.managedObjectContext)
        return dob
    }
}
