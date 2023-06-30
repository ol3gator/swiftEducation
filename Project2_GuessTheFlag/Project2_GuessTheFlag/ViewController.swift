//
//  ViewController.swift
//  Project2_GuessTheFlag
//
//  Created by Maxim on 03.04.2023.
//

// 1. Сделать так, чтобы Game Over выскакивал не через функцию нажатия

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var questionNumberLabel: UILabel!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionCounter: Int = 12 {
        didSet {
            if questionCounter <= 0 {
                let ac = UIAlertController(title: "Game Over", message: "Your score is \(score), mistakes \(12 - score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
                present(ac, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()) (Score: \(score))"
        questionNumberLabel.text = "Questions left: \(questionCounter)"
    }
    
    func restartGame(action: UIAlertAction! = nil) {
        score = 0
        questionCounter = 12
        correctAnswer = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            questionCounter -= 1
        } else {
            title = "Wrong, it's \(countries[sender.tag].uppercased())"
            score -= 1
            questionCounter -= 1
        }
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
}

