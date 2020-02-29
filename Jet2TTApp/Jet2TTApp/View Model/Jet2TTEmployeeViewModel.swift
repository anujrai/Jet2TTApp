//
//  Jet2TTEmployeeViewModel.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

protocol MemberFetchable {
    func fetchMembers(onSuccess success: @escaping ([Member]?) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
}

enum SortBy: String {
    case age
    case lastName
}

final class Jet2TTEmployeeViewModel {
    
    let dataSource: MemberFetchable
    init(_ dataSource: MemberFetchable) {
        self.dataSource = dataSource
    }
    
    func getMembers(_ success: @escaping ([Member]?)->Void, _ failure: @escaping (Error?)->Void) {
        return dataSource.fetchMembers(onSuccess: { (member) in
            success(member)
        }, onFailure: { (error) in
        failure(error)
        })
    }
    
    func sortEmployee(by sort: SortBy, members: [Member])-> [Member] {
        switch sort {
            
        case .age:
            let sortedArray = members.sorted {
                let age0 = $0.dob?.age ?? -1
                let age1 = $1.dob?.age ?? -1
                return age0 < age1
            }
            return sortedArray
            
        case .lastName:
            let sortedArray = members.sorted {
                let lastName0 = $0.name?.last ?? ""
                let lastName1 = $1.name?.last ?? ""
                return lastName0 < lastName1
            }
            return sortedArray
        }
    }
}


/// Used for getting the response of memeber

final class GatewayFetcher: MemberFetchable {
    
    private var members: [Member]?
    private var memberResponse: MemberResponse?
    private static let memberUrlString = "https://randomuser.me/api/?results=20"
    
    func fetchMembers(onSuccess success: @escaping ([Member]?) -> Void, onFailure failure: @escaping (Error?) -> Void) {
        guard let memberURL = URL(string: type(of: self).memberUrlString) else { return }
        
        NetworkWrapper.sharedInstance.makeNetworkRequest(url: memberURL, modelResponse: MemberResponse.self) { (error, response) in
            
            guard let response = response, error == nil else {
                failure(error)
                return
            }
            if self.members == nil {
                self.memberResponse = response
                self.members = response.results
            } else {
                guard let result = response.results else {
                    success(self.members)
                    return
                }
                
                for member in result {
                    self.members?.append(member)
                }
            }
            
            success(self.members)
        }
    }
}
