//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cristiano Calicchia on 15/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var wrong = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        if number == correctAnswer {
                            FlagImage(image: self.countries[number])
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                        } else {
                            FlagImage(image: self.countries[number])
                                .opacity(opacity)
                        }
                    }
                }
                
                Text("Score = \(score)")
                    .foregroundColor(.white)
                
                Spacer()
                
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    struct FlagImage: View {
        var image : String

        var body: some View {
            Image(image)
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
            
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                self.animationAmount += 360
                self.opacity = 0.75
            }
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
            score -= 1
            withAnimation {
                self.animationAmount += 360
                self.opacity = 0.75
            }
        }

        showingScore = true
    }
    
    func askQuestion() {
        self.opacity = 1.0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
