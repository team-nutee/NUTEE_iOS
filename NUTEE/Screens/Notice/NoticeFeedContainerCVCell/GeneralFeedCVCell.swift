//
//  GeneralFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/06.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class GeneralFeedCVCell: NoticeFeedContainerCVCell {

    override func fetchNoticeFeed() {
        let url = APIConstants.NoticeGeneral
        
        getNoticeService(url: url, completionHandler: { [self] ()-> Void in
            afterFetchNotice()
        })
    }
    
}
