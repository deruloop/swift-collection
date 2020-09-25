//
//  ViewController.swift
//  Project 5
//
//  Created by Cristiano Calicchia on 02/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var allWords = [String]()
    
    var word = Word(title: "",usedWords: [String]())
  //var usedWords = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        if let startWords = try? String(contentsOf: startWordsURL) {
            allWords = startWords.components(separatedBy: "\n")
        }
    }

    if allWords.isEmpty {
        allWords = ["silkworm"]
    }
    
    let defaults = UserDefaults.standard

    if let savedWord = defaults.object(forKey: "word") as? Data {
        let jsonDecoder = JSONDecoder()

        do {
            word = try jsonDecoder.decode(Word.self, from: savedWord)
            title = word.title
        } catch {
            print("Failed to load word")
        }
    } else {
        startGame()
    }
    
  }
  
  @objc func startGame() {
      title = allWords.randomElement()
      word.title = title!
      word.usedWords.removeAll(keepingCapacity: true)
      save()
      tableView.reloadData()
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return word.usedWords.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
      cell.textLabel?.text = word.usedWords[indexPath.row]
      return cell
  }
  
  @objc func promptForAnswer() {
      let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
      ac.addTextField()

      let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
          guard let answer = ac?.textFields?[0].text else { return }
        self?.submit(answer: answer)
      }

      ac.addAction(submitAction)
      present(ac, animated: true)
  }
  
  func submit(answer: String) {
    let lowerAnswer = answer.lowercased()
    
    if (title! != lowerAnswer) {
          if isPossible(myword: lowerAnswer) {
              if isOriginal(myword: lowerAnswer) {
                  if isReal(myword: lowerAnswer) {
                      word.usedWords.insert(lowerAnswer, at: 0)
                      save()

                      let indexPath = IndexPath(row: 0, section: 0)
                      tableView.insertRows(at: [indexPath], with: .automatic)

                      return
                  } else {
                    showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!")
                  }
              } else {
                showErrorMessage(title: "Word used already",message: "Be more original!")
              }
          } else {
              guard let title = title?.lowercased() else { return }
              showErrorMessage(title: "Word not possible",message: "You can't spell that word from \(title)")
          }
        } else {
          showErrorMessage(title: "Same Word",message: "Well that's way too easy ain't it?")
        }
  }
  
  func isPossible(myword: String) -> Bool {
      guard var tempWord = title?.lowercased() else { return false }

      for letter in myword {
          if let position = tempWord.firstIndex(of: letter) {
              tempWord.remove(at: position)
          } else {
              return false
          }
      }

      return true
  }

  func isOriginal(myword: String) -> Bool {
    return !word.usedWords.contains(myword)
  }
  
  func showErrorMessage(title: String, message: String){
      let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
  }

  func isReal(myword: String) -> Bool {
      let checker = UITextChecker()
      let range = NSRange(location: 0, length: myword.utf16.count)
      let misspelledRange = checker.rangeOfMisspelledWord(in: myword, range: range, startingAt: 0, wrap: false, language: "en")

    return misspelledRange.location == NSNotFound &&  myword.utf16.count>2
  }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(word) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "word")
        } else {
            print("Failed to save word.")
        }
    }


}

