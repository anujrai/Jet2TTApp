//
//  LocationService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class LocationService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension LocationService {
    
    func storeLoaction(_ city: String?,
                       _ country: String?,
                       _ state: String?) -> CD_Location {
        let location = CD_Location(context: self.managedObjectContext)
        location.city = city
        location.state = state
        location.country = country
        
        coreDataStack.saveContext(managedObjectContext)
        return location
    }
}
