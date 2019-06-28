//
//  MasterController.swift
//  BlogPosts
//
//  Created by Jodi Smit on 6/27/19.
//  Copyright © 2019 Kabbage. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

	private let apiService = APIService()
	private var postTypes: [String] = [""]
	private let cellIdentifier = "MasterTableViewCell"
	private let showDetail = "showDetail"
	private var selectedType = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getPostTypesAPICall()
	}


	func getPostTypesAPICall() {
		apiService.fetchPostTypes { (fullResponseResult) in
			
			switch fullResponseResult {
			case let .success (taxonomies):
				for item in taxonomies.taxonomies {
					if item.slug == "category" {
						self.postTypes = item.types
					}
				}
				DispatchQueue.main.async { [weak self] in
					self?.tableView.reloadData()
				}
			case let .failure(error):
				print("Error getting post types - returned nil: \(error)")
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postTypes.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		let type = postTypes[indexPath.row]

		cell.textLabel?.text = type

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedType = postTypes[indexPath.row]
		performSegue(withIdentifier: showDetail, sender: self)

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		switch segue.identifier {
		case showDetail:
			guard let destination = segue.destination as? DetailTableViewController else
			{
				return
			}
			destination.postType = selectedType
		default:
			return
		}
	}
}

