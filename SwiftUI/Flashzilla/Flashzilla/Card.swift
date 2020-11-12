//
//  Card.swift
//  Flashzilla
//
//  Created by Cristiano Calicchia on 09/11/2020.
//

import Foundation

struct Card {
    let prompt: String
    let answer: String

    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
