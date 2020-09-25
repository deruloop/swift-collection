//
//  ContentView.swift
//  WorldScramble
//
//  Created by Cristiano Calicchia on 21/09/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                Text("Score: \(score) - Words: \(usedWords.count)")
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading:
                Button(action: {
                    startGame()
                    usedWords.removeAll()
                    score = 0
                    newWord = ""
                }) {
                    Text("Refresh")
                }
            )
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func wordPoint(word: String) {
        switch word.count {
        case 3...4:
            score += 1
        case 5...6:
            score += 2
        case 7...8:
            score += 3
        default:
            print("Error")
        }
        
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.count < 3 {
            return false
        }

        return misspelledRange.location == NSNotFound
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        guard answer.count > 0 else {
            return
        }

        guard answer != rootWord else {
            wordError(title: "That's the actual word", message: "Be more original")
            return
        }
            
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        usedWords.insert(answer, at: 0)
        wordPoint(word: answer)
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
