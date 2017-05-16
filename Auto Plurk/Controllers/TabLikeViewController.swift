//
//  TabLikeViewController.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/15.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit
import SwiftyJSON

class TabLikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var likeTableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    var runStatus: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.likeTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allLikeClick(_ sender: Any) {
        if self.runStatus! {
            self.likeButton.setTitle("接受我無數的愛吧！", for: .normal)
            self.dislikeButton.setTitle("我沒有靈魂，沒辦法感受愛。", for: .normal)
            self.dislikeButton.isEnabled = true
            self.runStatus = false
        } else {
            self.likeButton.setTitle("運轉中，再次點擊即可停止。", for: .normal)
            self.dislikeButton.setTitle("你現在不能點我。", for: .normal)
            self.dislikeButton.isEnabled = false
            self.runStatus = true
            self.getPlurks(date: Date(), status: true)
        }
    }
    
    @IBAction func allDislikeClick(_ sender: Any) {
        if self.runStatus! {
            self.likeButton.setTitle("接受我無數的愛吧！", for: .normal)
            self.likeButton.isEnabled = true
            self.dislikeButton.setTitle("我沒有靈魂，沒辦法感受愛。", for: .normal)
            self.runStatus = false
        } else {
            self.likeButton.setTitle("你現在不能點我。", for: .normal)
            self.likeButton.isEnabled = false
            self.dislikeButton.setTitle("運轉中，再次點擊即可停止。", for: .normal)
            self.runStatus = true
            self.getPlurks(date: Date(), status: false)
        }
    }
    
    private func getDate(date: Date) -> String{
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = dateformatter.string(from: date)
        return dateString
    }
    
    private func getPlurks(date: Date!, status: Bool!){
        let originalRow : Int = self.list.count
        if self.runStatus! {
            let _ = _OAuthSwift.client.get(
                "https://www.plurk.com/APP/Timeline/getPlurks", // 正常狀態
//                "https://www.plurk.com/APP/Timeline/getPublicPlurks", // 特地搜尋某個人
                parameters: [
                    "limit" : "30",
//                    "user_id" : "8359388", // 特地搜尋某個人時要加的條件
                    "offset" : getDate(date: date)
                ],
                success: { response in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                        let json = JSON(data: response.data)
                        var likePlurks : [String] = []
                        for (_, plurk):(String, JSON) in json["plurks"] {
                            if plurk["favorite"].bool! != status {
//                                if plurk["owner_id"] == 8359388 { // 篩選歸屬人
                                    likePlurks.append((plurk["plurk_id"].int?.description)!)
                                    let user_id : String! = plurk["owner_id"].int?.description
                                    let _ = _OAuthSwift.client.get(
                                        "https://www.plurk.com/APP/Profile/getPublicProfile",
                                        parameters: [
                                            "user_id" : user_id
                                        ],
                                        success: { response in
                                            let user = JSON(data: response.data)
                                            
                                            self.list.append(likePost(
                                                username: user["user_info"]["display_name"].string!,
                                                user_id: (user["user_info"]["uid"].int?.description)!,
                                                avatar: (user["user_info"]["avatar"].int?.description)!,
                                                title: plurk["content_raw"].string!,
                                                date: plurk["posted"].string!,
                                                favorite: plurk["favorite"].bool!
                                            ))
                                            let _ = AnimateTable(originalRow: originalRow, tableView: self.likeTableView)
                                    }, failure: { error in
                                        NSLog(error.localizedDescription)
                                    }
                                    )
//                                }
                            }
                        }
                        self.likePlurk(plurk_ids: likePlurks.debugDescription, status: status, date : date)
                    }
            }, failure: { error in
                NSLog(error.localizedDescription)
            }
            )
        }
    }
    
    private func likePlurk(plurk_ids : String, status : Bool, date : Date) {
        var URL : String!
        if status {
            URL = "https://www.plurk.com/APP/Timeline/favoritePlurks"
        } else {
            URL = "https://www.plurk.com/APP/Timeline/unfavoritePlurks"
        }
        
        let _ = _OAuthSwift.client.get(
            URL,
            parameters: [
                "ids" : plurk_ids
            ],
            success: { response in
                self.getPlurks(date: Calendar.current.date(byAdding: .minute, value: -60, to: date), status: status)
                NSLog("[likePlurk] *Response => \(plurk_ids), *URL => \(URL)")
        }, failure: { error in
            NSLog(error.localizedDescription)
        }
        )
    }
    
    var list: [likePost] = []
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.likeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LikeTableViewCell
        cell.usernameLabel.text = list[indexPath.row].username
        cell.messageLabel.text = list[indexPath.row].title
        cell.postedLabel.text = list[indexPath.row].date
        cell.backgroundColor = UIColor.clear
        let _ = DownloadImage(url: list[indexPath.row].avatarURL, imageView: cell.avatarImage)
        if list[indexPath.row].favorite! {
            cell.imageStatus.image = #imageLiteral(resourceName: "Dislike-Status")
        } else {
            cell.imageStatus.image = #imageLiteral(resourceName: "Like-Status")
        }
        return cell
    }
}

class likePost {
    public private(set) var avatarURL: String!
    public private(set) var username: String!
    public private(set) var title: String!
    public private(set) var date: String!
    public private(set) var favorite: Bool!
    
    public init(username: String, user_id: String, avatar: String, title: String, date: String, favorite: Bool) {
        self.username = "\(username)(\(user_id))"
        self.avatarURL = "https://avatars.plurk.com/\(user_id)-big\(avatar).jpg"
        self.title = title
        self.date = date
        self.favorite = favorite
    }
}
