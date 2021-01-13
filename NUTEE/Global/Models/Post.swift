//
//  Post.swift
//  NUTEE
//
//  Created by eunwoo on 2020/12/26.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation

// MARK: - Post

struct Post: Codable {
    let code: Int
    let message: String
    let body: [PostBody]
    let links: PostLinks

    enum CodingKeys: String, CodingKey {
        case code, message, body
        case links
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode([PostBody].self, forKey: .body)) ?? []
        links = (try? values.decode(PostLinks.self, forKey: .links)) ?? PostLinks.init(linksSelf: nil, updatePost: nil, removePost: nil, getFavoritePosts: nil, getCategoryPosts: nil, getComments: nil)
    }
}

// MARK: - Body

class PostBody: Codable {
    let id: Int
    let title, content, createdAt, updatedAt: String
    let user: User
    let images: [PostImage]?
    let likers: [Liker]?
    let commentNum: Int
    let retweet: PostBody?
    let category: String
    let hits: Int
    let blocked: Bool
    let deleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt, updatedAt, deleted, blocked
        case user
        case images
        case commentNum
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
        deleted = (try? values.decode(Bool.self, forKey: .deleted)) ?? false
        blocked = (try? values.decode(Bool.self, forKey: .blocked)) ?? false
        user = (try? values.decode(User.self, forKey: .user)) ?? User.init(id: 0, nickname: "", image: nil)
        images = (try? values.decode([PostImage].self, forKey: .images)) ?? []
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? []
        retweet = (try? values.decode(PostBody.self, forKey: .retweet)) ?? nil
        commentNum = (try? values.decode(Int.self, forKey: .commentNum)) ?? 0
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        hits = (try? values.decode(Int.self, forKey: .hits)) ?? 0
    }
}

// MARK: - Image
struct PostImage: Codable {
    let src: String?
}

// MARK: - Liker

struct Liker: Codable {
    let id: Int?
    let nickname: String?
    let image: UserImage?

    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case image
    }
}

// MARK: - User

struct User: Codable {
    let id: Int?
    let nickname: String?
    let image: UserImage?

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case image
    }
}

struct UserImage: Codable {
    let src: String?
}


// MARK: - Links

struct PostLinks: Codable {
    let linksSelf, updatePost, removePost, getFavoritePosts, getCategoryPosts, getComments: Link?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case updatePost = "update-post"
        case removePost = "remove-post"
        case getFavoritePosts = "get-favorite-posts"
        case getCategoryPosts = "get-category-posts"
        case getComments = "get-comments"
    }
}

// MARK: - GetFavoritePosts

struct Link: Codable {
    let href: String
}
