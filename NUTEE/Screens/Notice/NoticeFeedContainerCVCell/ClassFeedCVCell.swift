//
//  ClassFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/06.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class ClassFeedCVCell: NoticeFeedContainerCVCell {

    override func fetchNoticeFeed() {
        let url = APIConstants.NoticeClass
        
        getNoticeService(url: url, completionHandler: { [self] ()-> Void in
            afterFetchNotice()
        })
    }
    
}
