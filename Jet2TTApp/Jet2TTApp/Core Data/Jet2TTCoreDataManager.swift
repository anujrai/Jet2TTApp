//
//  Jet2TTEmployeeViewController.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 29/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import CoreData

final class Jet2TTCoreDataManager: MemberFetchable {
    
    var members: [Member]?
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: Jet2TTCoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: Jet2TTCoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    func fetchMembers(onSuccess success: @escaping ([Member]?) -> Void,
                      onFailure failure: @escaping (Error?) -> Void) {
        
        let fetchRequest = NSFetchRequest<CD_Member>(entityName: "CD_Member")
        let asyncFetchRequest = NSAsynchronousFetchRequest<CD_Member>(fetchRequest: fetchRequest) { [weak self] (result: NSAsynchronousFetchResult) in
            
            guard let coreDataMembers = result.finalResult else { return }
            DispatchQueue.main.async {
                if let members = self?.getMembers(coreDataMembers),!members.isEmpty {
                    switch members.count {
                    case 0:
                        failure(Jet2TTError.noRecords)
                    default:
                        success(members)
                    }
                } else {
                    failure(Jet2TTError.noRecords)
                }
            }
        }
        
        do {
            try coreDataStack.mainContext.execute(asyncFetchRequest)
        } catch let error as NSError {
            print("Error \(error) and Description \(error.userInfo)")
            failure(error)
        }
    }
    
    private func getMembers(_ coreDataMembers: [CD_Member]) -> [Member] {
        
        var members: [Member] = []
        for coreDataMember in coreDataMembers {
            let name = Name(title: coreDataMember.name?.title,
                            first: coreDataMember.name?.first,
                            last: coreDataMember.name?.last)
            
            let location = Location(city: coreDataMember.location?.city,
                                    state: coreDataMember.location?.state,
                                    country: coreDataMember.location?.country)
            
            let dob = Dob(date: coreDataMember.dob?.date, age: coreDataMember.dob?.age)
            
            let picture = Picture(large: nil,
                                  medium: nil,
                                  thumbnail: nil,
                                  mediumData: coreDataMember.picture?.mediumImage as Data?,
                                  thumbnailData: coreDataMember.picture?.thumbnailImage as Data?)
            
            
            let member = Member(gender: coreDataMember.gender,
                                name: name,
                                email: coreDataMember.email,
                                phone: coreDataMember.phone,
                                picture: picture,
                                dob: dob,
                                location: location)
            
            members.append(member)
        }
        
        return members
    }
}


extension Jet2TTCoreDataManager {
    
    func storeMember(member: Member, _ thumbnailData: Data?, mediumData: Data?) {
        
        let nameService = NameService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
        let name = nameService.storeName(member.name?.title, member.name?.first, member.name?.last)
        
        let locationService = LocationService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
        let location = locationService.storeLoaction(member.location?.city, member.location?.state, member.location?.country)
        
        let dobService = DOBService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
        let dob = dobService.storeDOB(member.dob?.age, member.dob?.date)
        
        let pictureService = PictureService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
        let picture = pictureService.storePicture(thumbnailData, mediumData)
        
        let coreDatamember = MemberService(managedObjectContext: self.managedObjectContext, coreDataContext: self.coreDataStack)
        
        let _ = coreDatamember.storeMember(member.email,
                                                member.gender,
                                                member.phone,
                                                picture,
                                                name,
                                                location,
                                                dob)
    }
}
