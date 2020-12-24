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
    let body: SignInBody
    
}

struct SignInBody: Codable {
    let accessToken, refreshToken: String
}
