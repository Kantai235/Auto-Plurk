//
//  PlurkLoginViewController.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/15.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit
import OAuthSwift
import NVActivityIndicatorView
import PopupDialog

class PlurkLoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    var loginView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNVActivityView()
        self.loginView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.preferencesCheck() {
            self.loginPlurkAuth()
        } else {
            self.loginView.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginPlurkAuth() -> Void {
        let popup = PopupDialog(title: "系統通知", message: "已自動載入預設。", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false)
        let button = DefaultButton(title: "好ㄛ") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            self.present(vc, animated: true, completion: nil)
        }
        popup.addButtons([button])
        self.loginView.stopAnimating()
        self.present(popup, animated: true, completion: nil)
    }
    
    func createNVActivityView() -> Void {
        self.loginView = NVActivityIndicatorView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height
            ),
            type: NVActivityIndicatorType.ballScaleRippleMultiple,
            color: UIColor(red: (234/255.0), green: (70/255.0), blue: (64/255.0), alpha: 1),
            padding: CGFloat(self.view.frame.width / 4)
        )
        self.loginView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.view.addSubview(self.loginView)
    }
    
    func preferencesCheck() -> Bool {
        NSLog("__PlurkToken = \(String(describing: preferences.string(forKey: "__PlurkToken")))")
        NSLog("__PlurkTokenSecret = \(String(describing: preferences.string(forKey: "__PlurkTokenSecret")))")
        if preferences.string(forKey: "__PlurkToken") != nil || preferences.string(forKey: "__PlurkTokenSecret") != nil {
            _OAuthSwift.client.credential.oauthToken = preferences.string(forKey: "__PlurkToken")!
            _OAuthSwift.client.credential.oauthTokenSecret = preferences.string(forKey: "__PlurkTokenSecret")!
            self.loginButton.isEnabled = false
            return true
        } else {
            self.loginButton.isEnabled = true
            return false
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        self.loginView.startAnimating()
        if self.preferencesCheck() {
            self.loginPlurkAuth()
        } else {
            _OAuthSwift.authorize(
                withCallbackURL: URL(string: "AutoPlurk://oauth-callback/plurk")!,
                success: { credential, response, parameters in
                    _OAuthSwift.client.credential.oauthToken = credential.oauthToken
                    _OAuthSwift.client.credential.oauthTokenSecret = credential.oauthTokenSecret
                    NSLog("[Success] OAuth Token = \(credential.oauthToken)")
                    NSLog("[Success] OAuth Token Secret = \(credential.oauthTokenSecret)")
                    if (credential.oauthToken != "" || credential.oauthTokenSecret != "") {
                        preferences.setValue(credential.oauthToken, forKey: "__PlurkToken")
                        preferences.setValue(credential.oauthTokenSecret, forKey: "__PlurkTokenSecret")
                        preferences.synchronize()
                        self.viewDidAppear(true);
                    } else {
                        let popup = PopupDialog(title: "系統通知", message: "無法從噗浪當中獲取帳戶資料，請您重新嘗試。")
                        let button = DefaultButton(title: "好ㄛ") {}
                        popup.addButtons([button])
                        self.loginView.stopAnimating()
                        self.present(popup, animated: true, completion: nil)
                    }
                },
                failure: { error in
                    NSLog(error.localizedDescription)
                }
            )
        }
        self.loginView.stopAnimating()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// OAuthSwift 建構全局函式
let _OAuthSwift : OAuth1Swift = OAuth1Swift(
    consumerKey:    "W8gQY0ZeZnQS",
    consumerSecret: "PYx6lJlibaxa5gwVlVSRd6iy7s8Hq5NH",
    requestTokenUrl: "https://www.plurk.com/OAuth/request_token",
    authorizeUrl:    "https://www.plurk.com/m/authorize",
    accessTokenUrl:  "https://www.plurk.com/OAuth/access_token"
)

// 讀取記事本
let preferences = UserDefaults.standard

// Plurk API Path
let url :String = "https://www.plurk.com/APP/"
