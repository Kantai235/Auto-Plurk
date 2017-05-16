//
//  PlurkOAuthManagement.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/20.
//  Copyright © 2017年 乾太. All rights reserved.
//
//
//import Foundation
//import OAuthSwift
//
//class PlurkOAuthManagement {
//    
//    // OAuthSwift 建構全局函式
//    public private(set) var Controller : OAuth1Swift
//    
//    // 讀取記事本
//    let preferences = UserDefaults.standard
//
//    // Plurk API Path
//    let url :String = "http://www.plurk.com/APP/"
//    
//    init() {
//        self.PlurkOAuthManagement = OAuth1Swift(
//            consumerKey:    "W8gQY0ZeZnQS",
//            consumerSecret: "PYx6lJlibaxa5gwVlVSRd6iy7s8Hq5NH",
//            requestTokenUrl: "http://www.plurk.com/OAuth/request_token",
//            authorizeUrl:    "http://www.plurk.com/m/authorize",
//            accessTokenUrl:  "http://www.plurk.com/OAuth/access_token"
//        )
//    }
//
//}
