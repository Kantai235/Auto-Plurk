//
//  DownloadImage.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/20.
//  Copyright © 2017年 乾太. All rights reserved.
//

import Foundation
import UIKit

class DownloadImage {

    public private(set) var url: URL
    public private(set) var imageView: UIImageView
    
    init(url: URL, imageView: UIImageView) {
        self.url = url
        self.imageView = imageView
        self.download()
    }

    init(url: String, imageView: UIImageView) {
        self.url = URL(string: url)!
        self.imageView = imageView
        self.download()
    }
    
    private func download() {
        self.getDataFromUrl(url: self.url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
                self.imageView.layer.borderWidth = 1
                self.imageView.layer.masksToBounds = false
                self.imageView.layer.borderColor = UIColor.black.cgColor
                self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
                self.imageView.clipsToBounds = true
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
