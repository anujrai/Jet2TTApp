//
//  MemberService.swift
//  VAManagerBuddy
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//
//

import Foundation
import CoreData

final class MemberService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataContext: Jet2TTCoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataContext
    }
}

extension MemberService {
    
    func storeMember(_ email: String?,
                     _ gender: String?,
                     _ phone:String?,
                     _ picture: CD_Picture?,
                     _ name: CD_Name?,
                     _ location: CD_Location?,
                     _ dob: CD_Dob?) -> CD_Member {
        
        let member = CD_Member(context: self.managedObjectContext)
        member.email = email
        member.gender = gender
        member.phone = phone
        member.picture = picture
        member.name = name
        member.location = location
        member.dob = dob
        
        coreDataStack.saveContext(managedObjectContext)
        return member
    }
}
