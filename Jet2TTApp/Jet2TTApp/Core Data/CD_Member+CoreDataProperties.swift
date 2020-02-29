//
//  CD_Member+CoreDataProperties.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Member> {
        return NSFetchRequest<CD_Member>(entityName: "CD_Member")
    }

    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var phone: String?
    @NSManaged public var dob: CD_Dob?
    @NSManaged public var location: CD_Location?
    @NSManaged public var name: CD_Name?
    @NSManaged public var picture: CD_Picture?

}
