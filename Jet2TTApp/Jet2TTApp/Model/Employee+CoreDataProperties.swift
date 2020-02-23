//
//  Employee+CoreDataProperties.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var gender: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var location: String?
    @NSManaged public var firstName: String?
    @NSManaged public var picture: EmployeePicture?

}
