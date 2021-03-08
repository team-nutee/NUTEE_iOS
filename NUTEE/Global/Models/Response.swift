//
//  Response.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/08.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

// MARK: - ChangeCategory
struct ResponseChangeCategory: Codable {
    let code: Int
    let message: String
    let body: [String]
    let links: Links

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links = "_links"
    }
}
