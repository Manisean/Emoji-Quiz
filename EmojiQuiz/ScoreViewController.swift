//
//  ScoreViewController.swift
//  EmojiQuiz
//
//  Created by Mark Hunnewell on 2/27/24.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var leadBody: UILabel!
    
    var plistPath: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readPlist()
    }
    
    func readPlist() {
        if let infoPlistPath = Bundle.main.path(forResource: "highscores", ofType: "plist"),
           let dict = NSArray(contentsOfFile: infoPlistPath) as? [String] {
            plistPath = dict
        }
        
        let scoreList = plistPath?.joined(separator: "")
        leadBody.numberOfLines = 0
        leadBody.text = scoreList
    }
}
