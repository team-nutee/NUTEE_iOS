//
//  User.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation

// MARK: - Notice

struct Notice: Codable {
    let code: Int
    let message: String
    let body: [NoticeBody]
    let links: PostLinks

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode([NoticeBody].self, forKey: .body)) ?? []
        links = (try? values.decode(PostLinks.self, forKey: .links)) ?? PostLinks.init(linksSelf: nil, updatePost: nil, removePost: nil, getFavoritePosts: nil, getCategoryPosts: nil, getComments: nil)
    }
}

struct NoticeBody: Codable {
    let no, title: String
    let href: String
    let author: String
    let date: String
}
