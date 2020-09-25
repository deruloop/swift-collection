//
//  Petition.swift
//  Project 7
//
//  Created by Cristiano Calicchia on 07/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
