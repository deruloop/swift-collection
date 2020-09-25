//
//  ViewController.swift
//  Project 1
//
//  Created by Cristiano Calicchia on 28/08/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate {

	var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    DispatchQueue.global(qos: .userInitiated).async {
      let fm = FileManager.default
      let path = Bundle.main.resourcePath!
      let items = try! fm.contentsOfDirectory(atPath: path)
      for item in items {
          if item.hasPrefix("nssl") {
            self.pictures.append(item)
          }
      }
      self.pictures.sort()
    }
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
    
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pictures.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCell else {
					// we failed to get a PersonCell – bail out!
					fatalError("Unable to dequeue PersonCell.")
			}

			cell.name.text = pictures[indexPath.item]

			cell.imageView.image = UIImage(named: pictures[indexPath.item])

			cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
			cell.imageView.layer.borderWidth = 2
			cell.imageView.layer.cornerRadius = 3
			cell.layer.cornerRadius = 7
		
			return cell
	}
	
  /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    cell.textLabel?.font = cell.textLabel?.font.withSize(20)
    return cell
  }*/
  
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
	
  /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
      if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
          // 2: success! Set its selectedImage property
          vc.selectedImage = pictures[indexPath.row]
          vc.numberOfImage = String(indexPath.row + 1)
          vc.totalImageNumber = String(pictures.count)
        
          // 3: now push it onto the navigation controller
          navigationController?.pushViewController(vc, animated: true)
      }
  }*/
  
  @objc func shareTapped() {
    let vc = UIActivityViewController(activityItems: ["Scarica Project 1!"], applicationActivities: [])
      vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      present(vc, animated: true)
  }
  
}

