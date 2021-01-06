//
//  ExchangeFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/06.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class ExchangeFeedCVCell: NoticeFeedContainerCVCell {

    override func fetchNoticeFeed() {
        let url = APIConstants.NoticeExchange
        
        getNoticeService(url: url, completionHandler: { ()-> Void in
            self.noticeFeedTableView.reloadData()
        })
    }
    
}
