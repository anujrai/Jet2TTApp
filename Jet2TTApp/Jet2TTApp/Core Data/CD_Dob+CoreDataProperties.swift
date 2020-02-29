//
//  CD_Dob+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Dob {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Dob> {
        return NSFetchRequest<CD_Dob>(entityName: "CD_Dob")
    }

    @NSManaged public var age: Int16
    @NSManaged public var date: String?
    @NSManaged public var member: CD_Member?

}
