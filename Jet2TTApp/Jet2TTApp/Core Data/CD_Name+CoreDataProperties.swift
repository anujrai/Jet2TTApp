//
//  CD_Name+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Name {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Name> {
        return NSFetchRequest<CD_Name>(entityName: "CD_Name")
    }

    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var title: String?
    @NSManaged public var member: CD_Member?

}
