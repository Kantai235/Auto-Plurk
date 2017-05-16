//
//  TabMessageViewController.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/20.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit
import TextFieldEffects
import PopupDialog
import SwiftyJSON
import ActionSheetPicker_3_0

class TabMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // my user_id = 10879262
    // plurk_id = 1336170564
    
    @IBOutlet weak var selectTypeButton: UIButton!
    @IBOutlet weak var messageField: AkiraTextField!
    @IBOutlet weak var startMessageButton: UIButton!
    @IBOutlet weak var showTableVIew: UITableView!
    
    private var postList: [messagePost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTableVIew.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectTypeClick(_ sender: Any) {
        ActionSheetStringPicker.show(
            withTitle: "想說什麼呢？",
            rows: ["loves", "likes", "shares", "gives", "hates", "wants", "has", "will", "asks", "wishes", "was", "feels", "thinks", "says", "is", ":", "freestyle", "hopes", "needs", "wonders"],
            initialSelection: 1,
            doneBlock: { picker, value, index in
                self.selectTypeButton.setTitle(index as! String?, for: .normal)
                return
            },
            cancel: {
                ActionStringCancelBlock in return
            },
            origin: sender
        )
    }
    
    @IBAction func startMessageClick(_ sender: Any) {
        view.endEditing(true)
        if (self.messageField.text?.isEmpty)! {
            let popup = PopupDialog(title: "系統通知", message: "您不能宣傳空白的文宣！", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true)
            let buttonOne = CancelButton(title: "對ㄅ起") {}
            popup.addButton(buttonOne)
            self.present(popup, animated: true, completion: nil)
        } else {
            self.getPlurks(date: Date())
        }
    }

    private func getPlurks(date: Date!) {
        let _ = _OAuthSwift.client.get(
            "http://www.plurk.com/APP/Timeline/getPlurks",
            parameters: [
                "limit" : "3",
                "offset" : getDate(date: date)
            ],
            success: { response in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(2000)) {
                    let responseJson = JSON(data: response.data)
                    for (_, plurk):(String, JSON) in responseJson["plurks"] {
                        if plurk["owner_id"].int! == 10879262 {
                            
                            let _user = responseJson["plurk_users"][plurk["owner_id"].int!.description]
                            let _self = responseJson["plurk_users"][plurk["user_id"].int!.description]
                            
                            let object = messagePost()
                            object.requestImageViewURL = "https://avatars.plurk.com/\(_user["id"].int!)-big\(_user["avatar"].int!).jpg"
                            object.requestUsername = _user["display_name"].string!
                            object.requestMessage = plurk["content_raw"].string!
                            object.requestPosttime = plurk["posted"].string!
                            
                            object.responseImageViewURL = "https://avatars.plurk.com/\(_self["id"].int!)-big\(_self["avatar"].int!).jpg"
                            object.responseUsername = _self["display_name"].string!
                            
                            self.postResponsePlurk(
                                plurk_id: plurk["plurk_id"].int!,
                                message: self.messageField.text!,
                                qualifier: (self.selectTypeButton.titleLabel?.text!)!,
                                post: object
                            )
                        }
                    }
                    
                    // 再隔 2 秒之後，才再次搜尋
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(2000)) {
                        self.getPlurks(date: Calendar.current.date(byAdding: .minute, value: -5, to: date))
                    }
                }
        }, failure: { error in
            NSLog("getPlurks >> error: \(error.localizedDescription)")
        }
        )
    }
    
    private func postResponsePlurk(plurk_id: Int, message: String, qualifier: String, post: messagePost) {
        post.responseMessage = message
        let _ = _OAuthSwift.client.post(
            "http://www.plurk.com/APP/Responses/responseAdd",
            parameters: [
                "plurk_id" : plurk_id,
                "content" : message,
                "qualifier" : qualifier
            ],
            success: { response in
                let originaCount = self.postList.count
                self.postList.append(post)
                
                NSLog(response.debugDescription)
                
                let _ = AnimateTable(originalRow: originaCount, tableView: self.showTableVIew)
                // 這邊請加入回應成功的 TableView List
        }, failure: { error in
            NSLog("responseAdd >> error: \(error.localizedDescription)")
        }
        )
    }
    
    private func getDate(date: Date) -> String{
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = dateformatter.string(from: date)
        return dateString
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.showTableVIew.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        let post: messagePost = self.postList[indexPath.row]
        
        let _ = DownloadImage(url: post.requestImageViewURL, imageView: cell.requestImageView)
        cell.requestMessage.text = post.requestMessage
        cell.requestUsername.text = post.requestUsername
        cell.requestPosttime.text = post.requestPosttime
        let _ = DownloadImage(url: post.responseImageViewURL, imageView: cell.responseImageView)
        cell.responseMessage.text = post.responseMessage
        cell.responseUsername.text = post.responseUsername
        return cell
    }
}

class messagePost {
    
    public var requestImageViewURL: String = ""
    public var requestUsername: String = ""
    public var requestMessage: String = ""
    public var requestPosttime: String = ""

    public var responseImageViewURL: String = ""
    public var responseUsername: String = ""
    public var responseMessage: String = ""
    public var responsePosttime: String = ""
    
}
