//
//  ViewController.swift
//  Project 7
//
//  Created by Cristiano Calicchia on 07/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var petitions = [Petition]()
  var filteredPetitions = [Petition]()
  var filtered = false

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
    
    let urlString: String
    
    if navigationController?.tabBarItem.tag == 0 {
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }

    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
        } else {
          showError()
      }
    } else {
      showError()
    }
  }
  
  func parse(json: Data) {
      let decoder = JSONDecoder()

      if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
        petitions = jsonPetitions.results
        filteredPetitions = jsonPetitions.results
        tableView.reloadData()
      }
  }
  
  @objc func showCredits() {
    let ac = UIAlertController(title: "All the datas comes from the We The People API of Whitehouse", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
    ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(ac, animated: true)
  }
  
  @objc func showFilter() {
    let ac = UIAlertController(title: "Look for...", message: nil, preferredStyle: .alert)
    
    ac.addTextField()

    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
        guard let answer = ac?.textFields?[0].text else { return }
      self?.filter(answer: answer)
    }

    ac.addAction(submitAction)
    ac.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
    present(ac, animated: true)
  }
  
  func filter(answer: String) {
    
    //filter
    while(true) {
      let index = filteredPetitions.firstIndex {!$0.title.contains(answer) && !$0.body.contains(answer)}
      if index == nil {
        break
      }
      if let index = index {
          filteredPetitions.remove(at: index)
      }
    }
    
    filtered = true
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if !filtered {
      return petitions.count
    } else {
      return filteredPetitions.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      if !filtered {
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
      } else {
        let filteredPetition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = filteredPetition.title
        cell.detailTextLabel?.text = filteredPetition.body
        return cell
      }
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !filtered {
      let vc = DetailViewController()
      vc.detailItem = petitions[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    } else {
      let vc = DetailViewController()
      vc.detailItem = filteredPetitions[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }

  func showError() {
      let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
  }
}

