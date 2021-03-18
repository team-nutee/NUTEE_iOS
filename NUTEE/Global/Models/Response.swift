//
//  Response.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/09.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

struct Response: Codable {
    let code: Int
    let message: String
    let body: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode(String.self, forKey: .body)) ?? ""
    }
}
