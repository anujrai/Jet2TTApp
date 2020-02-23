//
//  Jet2TTError.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

enum Jet2TTError: Error {
    case unknown
    case noInternet
    case badResponse
}

extension Jet2TTError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Something went wrong. Please try again later.", comment: "Error")
        case .badResponse:
            return NSLocalizedString("Response is not in appropriate format.", comment: "Bad Response")
        case .noInternet:
            return NSLocalizedString("Please check your internet connetion.", comment: "No Internet")
        }
    }
}
