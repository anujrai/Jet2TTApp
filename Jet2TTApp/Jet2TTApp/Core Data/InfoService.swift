//
//  InfoService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class InfoService {
    
    let coreDataStack: Jet2TTCoreDataStack
    let managedObjectContext: NSManagedObjectContext
    
    init(with managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
}

extension InfoService {
    
    func storePageInfo(_ pagenumber: Int32?, _ version: String?) -> CD_PageInfo {
        let info = CD_PageInfo(context: self.managedObjectContext)
        info.pagenumber = pagenumber ?? -1
        info.version = version
        
        coreDataStack.saveContext(self.managedObjectContext)
        return info
    }
}
