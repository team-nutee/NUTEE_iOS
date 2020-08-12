//
//  User.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation

// MARK: - Notice

struct NoticeElement: Codable {
    let no, title: String
    let href: String
    let author: String
    let date: String
}

typealias Notice = [NoticeElement]
