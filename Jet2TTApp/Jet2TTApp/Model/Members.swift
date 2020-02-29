//
//  Member.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.

import Foundation
import CoreData

struct MemberResponse: Codable {
    let pageInfo: PageInfo?
    let results: [Member]?
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results
    }
}

struct PageInfo: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case pagenumber = "page"
        case version
    }
    
    let pagenumber: Int16?
    let version: String?
}

struct Member: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case gender
        case name
        case email
        case phone
        case picture = "picture"
        case dob
        case location
    }
    
    let gender: String?
    let name: Name?
    let email: String?
    let phone: String?
    var picture: Picture?
    let dob: Dob?
    let location: Location?
}

struct Name: Codable {
    
    let title: String?
    let first: String?
    let last: String?
}

struct Picture: Codable {

    let large: String?
    let medium: String?
    let thumbnail: String?
    
    var largeData: Data?
    var mediumData: Data?
    var thumbnailData: Data?
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    mutating func updateThumnailData(_ data: Data?) {
        guard let imageData = data else { return }
        self.thumbnailData = imageData
    }
    
    mutating func updateLargeData(_ data: Data?) {
        guard let imageData = data else { return }
        self.largeData = imageData
    }
    
    mutating func updateMediumData(_ data: Data?) {
        guard let imageData = data else { return }
        self.mediumData = imageData
    }
}

struct Dob: Codable {
    
    let date: String?
    let age: Int16?
}

struct Location: Codable {
    
    let city: String?
    let state: String?
    let country: String?
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
