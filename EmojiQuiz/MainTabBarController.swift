//
//  MainTabBarController.swift
//  EmojiQuiz
//
//  Created by Mark Hunnewell on 2/27/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    @IBInspectable var initialIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex;
        
    }
    
    
}
