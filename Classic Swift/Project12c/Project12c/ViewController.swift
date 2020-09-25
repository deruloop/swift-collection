//
//  ViewController.swift
//  Project12c
//
//  Created by Cristiano Calicchia on 12/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")

        let dict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        defaults.set(dict, forKey: "SavedDict")
        
        let array = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()
        defaults.set(array, forKey: "SavedArray")
    }


}

