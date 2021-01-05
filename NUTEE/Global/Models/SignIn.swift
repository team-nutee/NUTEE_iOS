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
    let code: Int
    let message: String
    let body: SignInBody

    enum CodingKeys: String, CodingKey {
        case code, message, body
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode(SignInBody.self, forKey: .body)) ?? SignInBody.init(accessToken: "", refreshToken: "")
    }
}

// MARK: - SignInBody
struct SignInBody: Codable {
    let accessToken, refreshToken: String
}
