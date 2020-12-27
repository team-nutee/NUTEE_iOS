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
    static let AuthURL = "http://3.34.61.71:9708/auth"
    static let BackURL = "http://3.34.61.71:9425/sns"
    
    // Notice
    static let NoticeBaseURL = "http://nutee.kr:9709/crawl"
    
    static let NoticeBachelor = NoticeBaseURL + "/haksa"
    static let NoticeClass = NoticeBaseURL + "/sooup"
    static let NoticeExchange = NoticeBaseURL + "/hakjum"
    static let NoticeScholarship = NoticeBaseURL + "/janghak"
    static let NoticeGeneral = NoticeBaseURL + "/ilban"
    static let NoticeEvent = NoticeBaseURL + "/hangsa"

    static let SignUp = AuthURL + "/signup"
    
    static let OTPSend = AuthURL + "/sendotp"
    static let OTPCheck = AuthURL + "/checkotp"
    static let IDCheck = AuthURL + "/checkid"
    static let NickCheck = AuthURL + "/checknickname"

    static let Login = AuthURL + "/login"
    // POST { userId : id , password: pw }
    static let Logout = AuthURL + "/logout"
    // POST
    
    static let Posts = BackURL + "/post/"

}
