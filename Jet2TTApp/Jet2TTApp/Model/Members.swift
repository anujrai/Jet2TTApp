//
//  Members.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 22/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

struct Members {
    let gender: String?
    let name: Name?
    let email: String?
    let picture: Picture
    
}

struct Name {
    let title: String?
    let first: String?
    let last: String?
}

struct Picture {
      let large: String?
      let medium: String?
      let thumbnail: String?
}
