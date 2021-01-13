//
//  Comment.swift
//  NUTEE
//
//  Created by eunwoo on 2021/01/11.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

// MARK: - Comment
struct Comment: Codable {
    let code: Int
    let message: String
    let body: CommentBody
    let links: PostLinks

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links = "_links"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode(CommentBody.self, forKey: .body))!
        links = (try? values.decode(PostLinks.self, forKey: .links)) ?? PostLinks.init(linksSelf: nil, updatePost: nil, removePost: nil, getFavoritePosts: nil, getCategoryPosts: nil, getComments: nil)
    }
}

// MARK: - Body
struct CommentBody: Codable {
    let id: Int
    let content: String
    let createdAt, updatedAt: String
    let reComment: [CommentBody]?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, content, createdAt, updatedAt
        case reComment
        case user
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
        updatedAt = (try? values.decode(String.self, forKey: .updatedAt)) ?? ""
        reComment = (try? values.decode([CommentBody].self, forKey: .reComment)) ?? []
        user = (try? values.decode(User.self, forKey: .user)) ?? User.init(id: 0, nickname: "", image: nil)
    }
}
