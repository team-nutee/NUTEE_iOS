//
//  User.swift
//  NUTEE
//
//  Created by eunwoo on 2020/12/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    var body: UserBody
}

struct UserBody: Codable {
    let id: Int
    var nickname: String
    var image: UserProfileImage?
    var interests: [String]
    var majors: [String]
    let postNum, commentNum, likeNum: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case image
        case interests
        case majors
        case postNum, commentNum, likeNum
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        nickname = (try? values.decode(String.self, forKey: .nickname)) ?? ""
        image = (try? values.decode(UserProfileImage.self, forKey: .image)) ?? UserProfileImage.init(src: "")
        interests = (try? values.decode([String].self, forKey: .interests)) ?? []
        majors = (try? values.decode([String].self, forKey: .majors)) ?? []
        postNum = (try? values.decode(Int.self, forKey: .postNum)) ?? 0
        commentNum = (try? values.decode(Int.self, forKey: .commentNum)) ?? 0
        likeNum = (try? values.decode(Int.self, forKey: .likeNum)) ?? 0
    }
}

// MARK: - Image
struct UserProfileImage: Codable {
    let src: String
}
