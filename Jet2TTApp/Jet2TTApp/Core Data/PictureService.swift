//
//  PictureService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class PictureService {
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension PictureService {
    
    func storePicture(_ thumbNailData: Data?,
                      _ mediumData: Data?,
                      _ largeData: Data?) -> CD_Picture {
        let picture = CD_Picture(context: managedObjectContext)
        picture.thumbnailImage = thumbNailData as NSData?
        picture.mediumImage = mediumData as NSData?
        picture.largeImage = largeData as NSData?
        
        coreDataStack.saveContext(managedObjectContext)
        return picture
    }
}
