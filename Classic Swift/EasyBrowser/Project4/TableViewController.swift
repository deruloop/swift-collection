//
//  TableViewController.swift
//  Project 4
//
//  Created by Cristiano Calicchia on 01/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
    var websites = ["amazon.it", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            vc.websites = websites
            
        }
    }

}
