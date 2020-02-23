//
//  EmployeePicture+CoreDataProperties.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import CoreData


extension EmployeePicture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
        return NSFetchRequest<EmployeePicture>(entityName: "EmployeePicture")
    }

    @NSManaged public var large: Data?
    @NSManaged public var medium: Data?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var employee: Employee?

}
