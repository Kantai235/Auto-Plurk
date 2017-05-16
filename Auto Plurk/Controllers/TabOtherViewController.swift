//
//  TabOtherViewController.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/15.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit
import PopupDialog

class TabOtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        let popup = PopupDialog(title: "系統通知", message: "您確定要登出噗浪小工具嗎？", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true)
        let YES_Button = DefaultButton(title: "是ㄉ") {
            preferences.removeObject(forKey: "__PlurkToken")
            preferences.removeObject(forKey: "__PlurkTokenSecret")
            let storage = HTTPCookieStorage.shared
            if let cookies = storage.cookies {
                for cookie in cookies {
                    storage.deleteCookie(cookie)
                }
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlurkLoginViewController")
            self.present(vc, animated: true, completion: nil)
        }
        let NO_Button = CancelButton(title: "ㄅ要") {
        }
        popup.addButtons([NO_Button, YES_Button])
        self.present(popup, animated: true, completion: nil)
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
