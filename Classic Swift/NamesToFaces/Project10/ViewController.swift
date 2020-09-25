//
//  ViewController.swift
//  Project10
//
//  Created by Cristiano Calicchia on 10/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var people = [Person]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
		
  }
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			guard let image = info[.editedImage] as? UIImage else { return }
			
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
				picker.sourceType = .camera
			}
			let imageName = UUID().uuidString
			let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

			if let jpegData = image.jpegData(compressionQuality: 0.8) {
					try? jpegData.write(to: imagePath)
			}
			
			let person = Person(name: "Unknown", image: imageName)
			people.append(person)
			collectionView.reloadData()
			
			dismiss(animated: true)
	}

	func getDocumentsDirectory() -> URL {
			let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			return paths[0]
	}
	
	@objc func addNewPerson() {
			let picker = UIImagePickerController()
			picker.allowsEditing = true
			picker.delegate = self
			present(picker, animated: true)
	}
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
  }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
			let person = people[indexPath.item]
			let index = indexPath.item

			let ac = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)

			let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] action in
				self?.rename(person: person)
				}
			ac.addAction(renameAction)
		
			let deleteAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
				self?.delete(index: index)
				}
			ac.addAction(deleteAction)
		
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
			present(ac, animated: true)
	}
	
	func rename(person: Person) {
		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
				guard let newName = ac?.textFields?[0].text else { return }
				person.name = newName

				self?.collectionView.reloadData()
		})

		present(ac, animated: true)
	}
	
	func delete(index: Int) {
		people.remove(at: index)
		collectionView.reloadData()
	}

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
					fatalError("Unable to dequeue PersonCell.")
			}

			let person = people[indexPath.item]

			cell.name.text = person.name

			let path = getDocumentsDirectory().appendingPathComponent(person.image)
			cell.imageView.image = UIImage(contentsOfFile: path.path)

			cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
			cell.imageView.layer.borderWidth = 2
			cell.imageView.layer.cornerRadius = 3
			cell.layer.cornerRadius = 7

			return cell
	}


}

