//
//  CD_Location+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Location> {
        return NSFetchRequest<CD_Location>(entityName: "CD_Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var member: CD_Member?

}
