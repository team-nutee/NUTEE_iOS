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
    let body: PostBody
}

struct PostBody: Codable {
    let id: Int?
    let title, content, createdAt, updatedAt: String?
    let deleted, blocked: Bool
    let user: User
    let images: [PostImage]
    let likers: [Liker]
    let retweet: Retweet?
    let comments: [Comment]
    let category: String?
    let hits: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt, updatedAt, deleted, blocked
        case user
        case images
        case likers
        case retweet
        case comments
        case category
        case hits
    }
    
    init(from decoder: Decoder) throws {
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
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? [Liker.init(id: 0, nickname: "", image: nil)]
        retweet = (try? values.decode(Retweet.self, forKey: .retweet)) ?? nil
        comments = (try? values.decode([Comment].self, forKey: .comments)) ?? []
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        hits = (try? values.decode(Int.self, forKey: .hits)) ?? 0
    }
}

struct PostImage: Codable {
    let src: String?

    enum CodingKeys: String, CodingKey {
        case src
    }
}

// MARK: - Comment
struct Comment: Codable {
    let id: Int
    let content, createdAt, updatedAt: String
    let user: User
    let reComment: [ReComment]?

    enum CodingKeys: String, CodingKey {
        case id, content, createdAt, updatedAt
        case user
        case reComment
    }
}

struct ReComment: Codable {
    let id: Int
    let content, createdAt, updatedAt: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, content, createdAt, updatedAt
        case user
    }
}

// MARK: - Retweet
struct Retweet: Codable {
    let id: Int
    let title, content, createdAt, updatedAt: String
    let deleted, blocked: Bool
    let user: User
    let images: [PostImage]
    let comments: [Comment]
    let likers: [Liker]
    let category: String?
    let hits: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt, updatedAt, deleted, blocked
        case user
        case images
        case comments
        case likers
        case category
        case hits
    }
    
    init(from decoder: Decoder) throws {
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
        likers = (try? values.decode([Liker].self, forKey: .likers)) ?? [Liker.init(id: 0, nickname: "", image: nil)]
        comments = (try? values.decode([Comment].self, forKey: .comments)) ?? []
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        hits = (try? values.decode(Int.self, forKey: .hits)) ?? 0
    }
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


typealias Posts = [Post]

