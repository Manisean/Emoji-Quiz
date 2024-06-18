//
//  popViewController.swift
//  EmojiQuiz
//
//  Created by Mark Hunnewell on 2/28/24.
//

import UIKit

class popViewController: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    var plistPath: [String]?
    
    var infoPlistPath: String?
    
    var endMsg: String?
    var totGuesses: Int?
    var completed: Int?
    var leadStr: String?
    var scoreList: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if endMsg != nil {
            msgLabel.text = endMsg
        }
        
        readPlist()
    }
    
    func readPlist() {
        infoPlistPath = Bundle.main.path(forResource: "highscores", ofType: "plist")
        let dict = NSArray(contentsOfFile: infoPlistPath ?? "") as? [String]
        
        plistPath = dict
    }
    
    @IBAction func enterBtn(_ sender: UIButton) {
        leadStr = "\(nameField.text ?? "0"): \(completed ?? 0) correct words in \(totGuesses ?? 0) guesses \n"
        
        do {
            let url = Bundle.main.url(forResource: "highscores", withExtension: "plist")
            
            plistPath?.append(leadStr ?? "")
            
            let data = try PropertyListSerialization.data(fromPropertyList: plistPath ?? "", format: .xml, options: 0)
            try data.write(to: url!)
            
        } catch {print("ERROR")}
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
}
