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
    let links: Links

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links = "_links"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode(SignInBody.self, forKey: .body)) ?? SignInBody.init(memberId: 0, accessToken: "", refreshToken: "")
        links = (try? values.decode(Links.self, forKey: .links)) ?? Links.init(linksSelf: SelfClass.init(href: ""))
    }
}

// MARK: - SignInBody
struct SignInBody: Codable {
    let memberId: Int
    let accessToken, refreshToken: String
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: SelfClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}
