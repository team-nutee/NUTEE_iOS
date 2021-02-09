//
//  UploadImage.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/09.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

    // MARK: - Comment
struct UploadImage: Codable {
    let code: Int
    let message: String
    let body: [String]
    let links: PostLinks
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        body = (try? values.decode([String].self, forKey: .body)) ?? []
        links = (try? values.decode(PostLinks.self, forKey: .links)) ?? PostLinks.init(linksSelf: nil, updatePost: nil, removePost: nil, getFavoritePosts: nil, getCategoryPosts: nil, getComments: nil)
    }
}
