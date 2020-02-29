//
//  CD_Picture+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Picture> {
        return NSFetchRequest<CD_Picture>(entityName: "CD_Picture")
    }

    @NSManaged public var mediumImage: NSData?
    @NSManaged public var thumbnailImage: NSData?
    @NSManaged public var member: CD_Member?

}
