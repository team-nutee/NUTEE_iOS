//
//  APIConstants.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

struct APIConstants {
    
    static let BaseURL = "http://13.124.232.115:9596"
    static let TestURL = "http://13.124.232.115:9425"
    static let AuthURL = "http://3.34.61.71:9708"
    
    // Notice
    static let NoticeBaseURL = "http://nutee.kr:9709/crawl"
    
    static let NoticeBachelor = NoticeBaseURL + "/haksa"
    static let NoticeClass = NoticeBaseURL + "/sooup"
    static let NoticeExchange = NoticeBaseURL + "/hakjum"
    static let NoticeScholarship = NoticeBaseURL + "/janghak"
    static let NoticeGeneral = NoticeBaseURL + "/ilban"
    static let NoticeEvent = NoticeBaseURL + "/hangsa"

    static let SignUp = AuthURL + "/auth/signup"
    
    static let OTPSend = AuthURL + "/auth/sendotp"
    static let OTPCheck = AuthURL + "/auth/checkotp"
    static let IDCheck = AuthURL + "/auth/checkid"
    static let NickCheck = AuthURL + "/auth/checknickname"

    static let Login = AuthURL + "/auth/login"
    // POST { userId : id , password: pw }
    static let Logout = AuthURL + "/auth/logout"
    // POST
    static let FindID = AuthURL + "/auth/findid"
    static let FindPW = AuthURL + "/auth/findpw"
    
}
