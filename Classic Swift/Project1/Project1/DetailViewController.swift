//
//  DetailViewController.swift
//  Project 1
//
//  Created by Cristiano Calicchia on 28/08/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  var numberOfImage: String?
  var totalImageNumber: String?
  
  override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(numberOfImage!) of \(totalImageNumber!)"
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }

        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.hidesBarsOnTap = false
  }

}
