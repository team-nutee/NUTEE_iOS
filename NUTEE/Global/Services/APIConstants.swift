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
    static let AuthURL = "http://3.34.61.71:9708/auth"
    static let BackURL = "http://3.34.61.71:9425/sns"
    
    // Login
    static let Login = AuthURL + "/auth/login"
    static let Logout = AuthURL + "/auth/logout"
    
    static let FindID = AuthURL + "/auth/findid"
    static let FindPW = AuthURL + "/auth/findpw"
    
    // SignUp
    static let SignUp = AuthURL + "/auth/signup"
    
    static let OTPSend = AuthURL + "/sendotp"
    static let OTPCheck = AuthURL + "/checkotp"
    static let IDCheck = AuthURL + "/checkid"
    static let NickCheck = AuthURL + "/checknickname"

    // Notice
    static let NoticeURL = "http://nutee.kr:9709/crawl"
    
    static let NoticeBachelor = NoticeURL + "/haksa"
    static let NoticeClass = NoticeURL + "/sooup"
    static let NoticeExchange = NoticeURL + "/hakjum"
    static let NoticeScholarship = NoticeURL + "/janghak"
    static let NoticeGeneral = NoticeURL + "/ilban"
    static let NoticeEvent = NoticeURL + "/hangsa"
    static let Login = AuthURL + "/login"
    static let Logout = AuthURL + "/logout"
    // POST
    
    static let Post = BackURL + "/post"

}
