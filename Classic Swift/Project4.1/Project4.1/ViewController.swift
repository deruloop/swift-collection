//
//  ViewController.swift
//  Project 4
//
//  Created by Cristiano Calicchia on 01/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
  
  var websites = ["amazon.it", "hackingwithswift.com"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Select website"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return websites.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "webpage", for: indexPath)
      cell.textLabel?.text = websites[indexPath.row]
      return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let vc = storyboard?.instantiateViewController(withIdentifier: "webview") as? WebViewController {
          vc.websites = websites
          navigationController?.pushViewController(vc, animated: true)
      }
  }

}

