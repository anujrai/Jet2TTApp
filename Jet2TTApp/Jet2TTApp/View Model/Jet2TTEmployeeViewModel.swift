//
//  Jet2TTEmployeeViewModel.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

final class Jet2TTEmployeeViewModel {
    
    // MARK: - Variables
    private static let memberUrlString = "https://randomuser.me/api/?results=20"
    var memberResponse: MemberResponse?
    var member:[Member]?
    var totalCount = 200
    
    func fetchMembers(onSuccess success: @escaping () -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        guard let memberURL = URL(string: type(of: self).memberUrlString) else { return }
        
        guard Reachability.isConnectedToNetwork() else {
            failure(Jet2TTError.noInternet)
            return
        }
        
        NetworkWrapper.sharedInstance.makeNetworkRequest(url: memberURL, modelResponse: MemberResponse.self) { (error, response) in
            
            DispatchQueue.main.async {
                guard let response = response, error == nil else {
                    failure(error)
                    return
                }
                if self.member == nil {
                    self.memberResponse = response
                    self.member = response.results
                } else {
                    guard let result = response.results else {
                        success()
                        return
                    }
                    
                    for member in result {
                        self.member?.append(member)
                    }
                }
                success()
            }
        }
    }
    
}
