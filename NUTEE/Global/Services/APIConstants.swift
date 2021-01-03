//
//  APIConstants.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

struct APIConstants {
    
    // BaseURL
    static let BaseURL = "http://13.124.232.115:9596"
    static let TestURL = "http://13.124.232.115:9425"
    
    static let AuthURL = "http://3.34.61.71:9708"
    
    // Login
    static let Login = AuthURL + "/auth/login"
    static let Logout = AuthURL + "/auth/logout"
    
    static let FindID = AuthURL + "/auth/findid"
    static let FindPW = AuthURL + "/auth/findpw"
    
    // SignUp
    static let SignUp = AuthURL + "/auth/signup"
    
    static let OTPSend = AuthURL + "/auth/sendotp"
    static let OTPCheck = AuthURL + "/auth/checkotp"
    static let IDCheck = AuthURL + "/auth/checkid"
    static let NickCheck = AuthURL + "/auth/checknickname"

    // Notice
    static let NoticeURL = "http://nutee.kr:9709/crawl"
    
    static let NoticeBachelor = NoticeURL + "/haksa"
    static let NoticeClass = NoticeURL + "/sooup"
    static let NoticeExchange = NoticeURL + "/hakjum"
    static let NoticeScholarship = NoticeURL + "/janghak"
    static let NoticeGeneral = NoticeURL + "/ilban"
    static let NoticeEvent = NoticeURL + "/hangsa"
}
