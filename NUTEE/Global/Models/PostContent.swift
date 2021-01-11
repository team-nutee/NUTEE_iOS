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
    let code: Int
    let message: String
    let body: PostContentBody
    let links: Links

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode(PostContentBody.self, forKey: .body))!
        links = (try? values.decode(Links.self, forKey: .links)) ?? Links.init(linksSelf: nil, updatePost: nil, removePost: nil, getFavoritePosts: nil, getCategoryPosts: nil, getComments: nil)
    }
}

// MARK: - Body

class PostContentBody: Codable {
    let id: Int
    let title, content, createdAt, updatedAt: String
    let user: User
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
        user = (try? values.decode(User.self, forKey: .user)) ?? User.init(id: 0, nickname: "", image: nil)
        images = (try? values.decode([PostImage].self, forKey: .images)) ?? []
        comments = (try? values.decode([CommentBody].self, forKey: .comments)) ?? []
        retweet = (try? values.decode(PostBody.self, forKey: .retweet)) ?? nil
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? []
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        hits = (try? values.decode(Int.self, forKey: .hits)) ?? 0
    }
}


