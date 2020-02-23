//
//  Members.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 22/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

struct MemberResponse: Decodable {
    let pageInfo: PageInfo?
    let results: [Member]?
    
    private enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results
    }
}
struct PageInfo: Decodable {
    let pageNumber: Int?
    let version: String?
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case version
    }
    
}

struct Member: Decodable {
    let gender: String?
    let name: Name?
    let email: String?
    let phone: String?
    let profilePicture: Picture
    let dob: DOB?
    let location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case gender
        case name
        case email
        case phone
        case profilePicture = "picture"
        case dob
        case location
    }
}

struct Name: Decodable {
    let title: String?
    let first: String?
    let last: String?
}

struct Picture: Decodable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

struct DOB: Decodable {
    let date: String?
    let age: Int?
}

struct Location: Decodable {
    let city, state, country: String?
    //let postcode: Int?
}

extension Location {

    var fullAddress: String {

        // As response format is changing for Street some times from url, that is why not created model of street and not using that
        var address: String = ""
       
        if let city = self.city {
            address += "City- " + " " + city + " "
        }
        if let state = self.state {
            address += state + " "
        }

        if let country = self.country {
            address += "Country- " + " " + country + " "
        }

        return address
    }
}

extension Member {
    
    var fullName: String {
        var name: String = ""
        if let firstName = self.name?.first {
            name += firstName + " "
        }
        
        if let lastName = self.name?.last {
            name += lastName
        }
        return name
    }
}

enum HeaderType: String, CaseIterable {
    case Email
    case Phone
    case Dob
    case Location
    
    func getTypeAndDetails(with memeber: Member) -> (header: String, iconName: String, detail: String) {
        switch self {
        case .Email:
            return ("Email", "mail", memeber.email ?? "")
        case .Phone:
            return ("Phone Number", "phone", memeber.phone ?? "")
        case .Dob:
            return ("Date Of Birth", "dob", memeber.dob?.date ?? "")
        case .Location:
            return ("Location", "location", memeber.location?.fullAddress ?? "")
        }
    }
}
