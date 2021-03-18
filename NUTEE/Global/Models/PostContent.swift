//
//  PostContent.swift
//  NUTEE
//
//  Created by eunwoo on 2021/01/05.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

// MARK: - PostContent
struct PostContent: Codable {
    let body: PostContentBody
}

// MARK: - Body

class PostContentBody: Codable {
    let id: Int
    let title, content, createdAt, updatedAt: String
    let user: UserBody?
    let images: [PostImage]?
    let likers: [Liker]?
    let comments: [CommentBody]?
    let retweet: PostBody?
    let category: String
    let hits: Int
    let blocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt, updatedAt, blocked
        case user
        case images
        case comments
        case retweet
        case likers
        case category
        case hits
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
        updatedAt = (try? values.decode(String.self, forKey: .updatedAt)) ?? ""
        blocked = (try? values.decode(Bool.self, forKey: .blocked)) ?? false
        user = (try? values.decode(UserBody.self, forKey: .user))
        images = (try? values.decode([PostImage].self, forKey: .images)) ?? []
        comments = (try? values.decode([CommentBody].self, forKey: .comments)) ?? []
        retweet = (try? values.decode(PostBody.self, forKey: .retweet)) ?? nil
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? []
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        hits = (try? values.decode(Int.self, forKey: .hits)) ?? 0
    }
}


