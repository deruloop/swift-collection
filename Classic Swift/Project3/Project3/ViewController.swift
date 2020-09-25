//
//  ViewController.swift
//  Project 1
//
//  Created by Cristiano Calicchia on 28/08/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    // Do any additional setup after loading the view.
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)

    for item in items {
        if item.hasPrefix("nssl") {
            pictures.append(item)
        }
    }
    pictures.sort()
    print(pictures)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    cell.textLabel?.font = cell.textLabel?.font.withSize(20)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
      if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
          // 2: success! Set its selectedImage property
          vc.selectedImage = pictures[indexPath.row]
          vc.numberOfImage = String(indexPath.row + 1)
          vc.totalImageNumber = String(pictures.count)
        
          // 3: now push it onto the navigation controller
          navigationController?.pushViewController(vc, animated: true)
      }
  }
  
}

