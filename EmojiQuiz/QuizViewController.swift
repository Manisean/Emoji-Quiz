//
//  QuizViewController.swift
//  EmojiQuiz
//
//  Created by Mark Hunnewell on 2/27/24.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var guessInput: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    var plistPath: [String]?
    
    var catPick: Int?
    var durationCtr: String?
    var endMsg = ""
    var curRound = 0
    var cGuesses = 0
    var wGuesses = 0
    var totGuesses = 0
    var completed = 0
    
    var emojiArr = [String]()
    var letterMap = [Character]()
    var guessed = [Character]()
    var hiddenWord = [String]()
    
    let emojiArr1 = ["💟","☮️","✝️","☪️","🕉️","☸️","🪯","✡️","🔯","🕎","☯️","🛐","☦️","⛎","♈️","♉️","♊️","♋️","♎️","♏️","♐️","♑️","♌️","♍️","⚛️","🆔"]
    let emojiArr2 = ["😀","😃","😄","😁","😆","🥹","😅","😂","🤣","🥲","☺️","😊","🙃","😉","😌","😍","🥰","😘","😗","😙","😚","😋","😇","🙂","😫","😳"]
    let letterArr = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseWord()
        assignEmoji()
        
        print(durationCtr ?? "none")
        
        cGuesses = 0
        wGuesses = 0
        totGuesses = 0
        errLabel.text = String(wGuesses)
        completed = 0
        curRound = 1
    }
    
    func reset() {
        cGuesses = 0
        wGuesses = 0
        errLabel.text = String(wGuesses)
        
        emojiArr = [String]()
        letterMap = [Character]()
        guessed = [Character]()
        hiddenWord = [String]()
        
        UIView.animate(withDuration: 1){
            self.wordLabel.alpha = 1
        }
        
        chooseWord()
        assignEmoji()
    }
    
    func chooseWord() {
        let wordArr = readPlist()
        
        print(wordArr)
        
        let word = wordArr.randomElement()
        
        for letter in String(word!) {
            letterMap.append(letter)
        }
        print(letterMap)
    }
    
    func readPlist() -> [String] {
        if let infoPlistPath = Bundle.main.path(forResource: "questions", ofType: "plist"),
           let dict = NSArray(contentsOfFile: infoPlistPath) as? [String] {
            plistPath = dict
        }
        
        return plistPath!
    }
    
    func createDict(emoji: [String], letter: [String]) -> [String: String] {
        var dict: [String: String] = [:]
        var count = 0
        var e = emoji
        var l = letter
        
        e.shuffle()
        l.shuffle()
        
        for item in l {
            dict[item] = e[count]
            count += 1
        }
        return dict;
    }
    
    func assignEmoji() {
        if catPick == 0 {
            let temp = createDict(emoji: emojiArr1, letter: letterArr)
            for i in letterMap {
                hiddenWord.append(temp[String(i)]!)
            }
            let wordStr = hiddenWord.joined(separator: "")
            wordLabel.text = wordStr
            
        } else if catPick == 1{
            let temp = createDict(emoji: emojiArr2, letter: letterArr)
            for i in letterMap {
                hiddenWord.append(temp[String(i)]!)
            }
            let wordStr = hiddenWord.joined(separator: "")
            
            wordLabel.text = wordStr
        }
    }
    
    @IBAction func guessBtn(_ sender: UIButton) {
        let guess = Character(guessInput.text!.uppercased())
        var place = [Int]()
        var wordStr = ""
        var count = 0
        var check = true
        
        print(letterMap)
        print(hiddenWord)
        
        for symbol in letterMap {
            if symbol == guess && !guessed.contains(symbol) {
                place.append(contentsOf: letterMap.enumerated().compactMap {$1 == symbol ? $0 : nil})
                
                for it in place {
                    hiddenWord[it] = String(letterMap[it])
                }
                
                wordStr = hiddenWord.joined(separator: "")
                wordLabel.text = wordStr
                guessed.append(symbol)
            }
        }
        
        if place.isEmpty {
            wGuesses += 1
            errLabel.text = String(wGuesses)
            let soundPath = Bundle.main.path(forResource: "Beep", ofType: "mp3")
            let url = URL(fileURLWithPath: soundPath!)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Beep not found")
            }
        } else {
            cGuesses += 1
        }
        
        if wGuesses == 3 {
            endMsg = "YOU LOST:ENTER SCORE"
            trigScore()
        }
        
        for i in letterMap {
            if hiddenWord[count] != String(i) {
                check = false
            }
            count += 1
        }
        
        
        if check == true {
            completed += 1
            totGuesses += (cGuesses + wGuesses)
            
            let soundPath = Bundle.main.path(forResource: "Bell", ofType: "mp3")
            let url = URL(fileURLWithPath: soundPath!)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Bell not found")
            }
            
            if curRound < Int(durationCtr!)! {
                curRound += 1
                
                UIView.animate(withDuration: 1){
                    self.wordLabel.alpha = 0
                }
                
                reset()
            } else {
                endMsg = "YOU WON:ENTER SCORE"
                trigScore()
            }
        }
    }
    
    func trigScore() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopVC") as! popViewController
        
        controller.endMsg = endMsg
        controller.totGuesses = totGuesses
        controller.completed = completed
        
        present(controller, animated: true, completion: nil)
    }
}
