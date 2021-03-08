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
    let body: CommentBody
}

// MARK: - Body
struct CommentBody: Codable {
    var id: Int
    var content: String
    var createdAt, updatedAt: String
    var likers: [Liker]?
    var reComment: [CommentBody]?
    var user: UserBody?
    
    enum CodingKeys: String, CodingKey {
        case id, content, createdAt, updatedAt
        case reComment
        case likers
        case user
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
        updatedAt = (try? values.decode(String.self, forKey: .updatedAt)) ?? ""
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? []
        reComment = (try? values.decode([CommentBody].self, forKey: .reComment)) ?? []
        user = (try? values.decode(UserBody.self, forKey: .user))
    }
}
