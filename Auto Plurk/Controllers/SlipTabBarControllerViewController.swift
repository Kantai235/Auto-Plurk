//
//  SlipTabBarControllerViewController.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/15.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit

class SlipTabBarControllerViewController: UITabBarController {

//     private var currentSelectedButton = UIButton()
//     private var selectionIndicatorImageView: UIImageView!
//     private var itemWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let rect = self.tabBar.frame
//        self.tabBar.removeFromSuperview()
//
//        let backgroundView = UIView(frame: rect)
//        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
//
//        self.view.addSubview(backgroundView)
//
//        itemWidth = backgroundView.frame.size.width / CGFloat(self.viewControllers!.count)
//
//        selectionIndicatorImageView = UIImageView(frame: CGRect(x:0, y:0, width:itemWidth, height:backgroundView.frame.size.height))
//        selectionIndicatorImageView.image = UIImage(named: "Roguso")
//        
//        backgroundView.addSubview(selectionIndicatorImageView)
//        
//        var imageArray = ["Like", "Chat", "Share", "People", "Game"]
//        
//        for i in 0 ..< viewControllers!.count {
//            
//            let button = UIButton(frame: CGRect(x:itemWidth * CGFloat(i), y:0, width:itemWidth, height:backgroundView.frame.size.height))
//            
//            let image = UIImage(named: imageArray[i])!
//            let selImage = UIImage(named: imageArray[i])!
//            
//            button.setImage(image, for: UIControlState.normal)
//            button.setImage(selImage, for: UIControlState.selected)
//            
//            button.addTarget(self, action: Selector("onClickFuckyou"), for: UIControlEvents.touchUpInside)
//            
//            button.tag = i
//            
//            button.adjustsImageWhenHighlighted = false
//            
//            backgroundView.addSubview(button)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    func onClickFuckyou(button: UIButton) {
//        self.currentSelectedButton.isSelected = false
//        button.isSelected = true
//        
//        self.currentSelectedButton = button
//        
//        let x = CGFloat(button.tag) + 0.5
//        
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
//            self.selectionIndicatorImageView.center.x = self.itemWidth * x
//        }, completion: nil)
//        
//        self.selectedIndex = button.tag
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
