//
//  CommentReCommentList.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/08.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

struct ReplyList {
    var type: ReplyType?
    var body: CommentBody?
    
    init() {
        type = .comment
        
        body?.id = 0
        body?.content = ""
        body?.createdAt = ""
        body?.updatedAt = ""
        body?.likers = []
        body?.reComment = []
        body?.user = nil
    }
}
