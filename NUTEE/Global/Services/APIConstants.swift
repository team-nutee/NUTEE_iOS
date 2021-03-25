//
//  APIConstants.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

struct APIConstants {
    
    // BaseURL
    static let CurrentServiceURL = "http://13.124.232.115:9425" // current service NUTEE 1.0
    static let TestURL = "http://13.124.232.115:9596"
    
    static let AuthURL = "http://3.34.61.71:9708/auth"
    static let BackURL = "http://3.34.61.71:9425/sns"
    
    // Login
    static let Login = AuthURL + "/login"
    static let Logout = AuthURL + "/logout"
    
    static let FindID = AuthURL + "/user-id"
    static let FindPW = AuthURL + "/password"
    
    // SignUp
    static let User = AuthURL + "/user"
    
    static let OTPSend = AuthURL + "/otp"
    static let OTPCheck = AuthURL + "/check/otp"
    static let IDCheck = AuthURL + "/check/user-id"
    static let NickCheck = AuthURL + "/check/nickname"

    // Notice
    static let NoticeURL = "http://nutee.kr:9709/crawl"
    
    static let NoticeBachelor = NoticeURL + "/haksa"
    static let NoticeClass = NoticeURL + "/sooup"
    static let NoticeExchange = NoticeURL + "/hakjum"
    static let NoticeScholarship = NoticeURL + "/janghak"
    static let NoticeGeneral = NoticeURL + "/ilban"
    static let NoticeEvent = NoticeURL + "/hangsa"
    
    // Category
    static let Category = BackURL + "/category"
    
    // Post
    static let Post = BackURL + "/post"
    static let Image = BackURL + "/upload"

    // Profile
    static let Profile = BackURL + "/user"
    
    // Search
    static let Search = BackURL + "/search"
    
    // Hashtag
    static let Hashtag = BackURL + "/hashtag"
}
