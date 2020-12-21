//
//  SignIn.swift
//  Nutee
//
//  Created by Junhyeon on 2020/02/13.
//  Copyright © 2020 S.OWL. All rights reserved.
//
import Foundation

// MARK: - SignIn
struct SignIn: Codable {
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = (try? values.decode(String.self, forKey: .accessToken)) ?? ""
        refreshToken = (try? values.decode(String.self, forKey: .refreshToken)) ?? ""
    }

}
