//
//  ViewController.swift
//  Project 2
//
//  Created by Cristiano Calicchia on 31/08/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  var countries = [String]()
  var correctAnswer = 0
  var score = 0
  var highestScore = 0
  var questionAsked = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    countries.append("estonia")
    countries.append("france")
    countries.append("germany")
    countries.append("ireland")
    countries.append("italy")
    countries.append("monaco")
    countries.append("nigeria")
    countries.append("poland")
    countries.append("russia")
    countries.append("spain")
    countries.append("uk")
    countries.append("us")
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
    button2.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
    button3.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
    
    askQuestion(action: nil)
    
    let defaults = UserDefaults.standard
    if let savedHighScore = defaults.object(forKey: "highestScore") as? Data {
        if let decodedHighScore = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedHighScore) as? Int {
            highestScore = decodedHighScore
        }
    }
  }
  
  func askQuestion(action: UIAlertAction!) {
    countries.shuffle()
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    correctAnswer = Int.random(in: 0...2)
    title = countries[correctAnswer].uppercased() + "  Your score is \(score)"
  }
  
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String
    questionAsked += 1
    //print(questionAsked)

    if sender.tag == correctAnswer {
        score += 1
        if score > highestScore {
            highestScore = score
            title = "Correct, new high score!"
            save()
        } else {
            title = "Correct"
        }
    } else {
        title = "Wrong, that's the flag of \(countries[(sender.tag)])"
        score -= 1
    }
    
    if questionAsked == 10 {
      title = "Game over!"
      let ac2 = UIAlertController(title: title, message: "Your total score is \(score).", preferredStyle: .alert)
      ac2.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
      present(ac2, animated: true)
      score = 0
      questionAsked = 0
      highestScore = 0
    } else {
      let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
      present(ac, animated: true)
    }
  }
  
  @objc func shareTapped() {
      let vc = UIActivityViewController(activityItems: ["Your score is \(score)."], applicationActivities: [])
      vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      present(vc, animated: true)
  }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: highestScore, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highestScore")
        }
    }

}

