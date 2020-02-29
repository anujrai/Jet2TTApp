//
//  CD_PageInfo+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_PageInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_PageInfo> {
        return NSFetchRequest<CD_PageInfo>(entityName: "CD_PageInfo")
    }

    @NSManaged public var pagenumber: Int32
    @NSManaged public var version: String?

}
