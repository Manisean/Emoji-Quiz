//
//  HomeViewController.swift
//  EmojiQuiz
//
//  Created by Mark Hunnewell on 2/27/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var durationCtr: UILabel!
    @IBOutlet weak var catPick: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationCtr.text = "1"
        
    }
    
    @IBAction func durationStpr(_ sender: UIStepper) {
        durationCtr.text = Int(sender.value).description;
    }
    
    @IBAction func setBtn(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "QuizVC") as! QuizViewController
        
        controller.durationCtr = durationCtr.text
        controller.catPick = catPick.selectedSegmentIndex
        present(controller, animated: true, completion: nil)
    }
    
    
}
