//
//  ViewController.swift
//  Project 1
//
//  Created by Cristiano Calicchia on 28/08/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [Picture]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    DispatchQueue.global(qos: .userInitiated).async {
      let fm = FileManager.default
      let path = Bundle.main.resourcePath!
      var items = try! fm.contentsOfDirectory(atPath: path)
      items.sort()

        for item in items {
          if item.hasPrefix("nssl") {
            let pictureToInsert = Picture(picture: item,timesViewed: 0)
            self.pictures.append(pictureToInsert)
          }
        }
    }
    
    let defaults = UserDefaults.standard

    if let savedPictures = defaults.object(forKey: "pictures") as? Data {
        let jsonDecoder = JSONDecoder()

        do {
            pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
        } catch {
            print("Failed to load pictures")
        }
    }
    
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
    
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row].picture
    cell.textLabel?.font = cell.textLabel?.font.withSize(20)
    cell.detailTextLabel?.text = "Total views: \(pictures[indexPath.row].timesViewed)"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
      if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
          // 2: success! Set its selectedImage property
          vc.selectedImage = pictures[indexPath.row].picture
          pictures[indexPath.row].timesViewed += 1
          vc.numberOfImage = String(indexPath.row + 1)
          vc.totalImageNumber = String(pictures.count)
        
          // 3: now push it onto the navigation controller
          navigationController?.pushViewController(vc, animated: true)
      }
      save()
      self.tableView.reloadData()
  }
  
  @objc func shareTapped() {
    let vc = UIActivityViewController(activityItems: ["Scarica Project 1!"], applicationActivities: [])
      vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      present(vc, animated: true)
  }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
  
}

