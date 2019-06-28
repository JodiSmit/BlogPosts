//
//  DetailTableViewController.swift
//  BlogPosts
//
//  Created by Jodi Smit on 6/27/19.
//  Copyright © 2019 Kabbage. All rights reserved.
//
import UIKit

class DetailTableViewController: UITableViewController {
	
	private let apiService = APIService()
	private var posts = [String]()
	private let cellIdentifier = "DetailTableViewCell"
	private let child = SpinnerViewController()
	var postType = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addSpinner()
		getPostsForTypeAPICall()
	}
	
	
	func getPostsForTypeAPICall() {
		apiService.fetchPosts(for: postType) { (fullResponseResult) in
			switch fullResponseResult {
			case let .success (postsResult):
				for item in postsResult {
					self.posts.append(item.title)
				}
				DispatchQueue.main.async { [weak self] in
					self?.removeSpinner()
					self?.tableView.reloadData()
				}
			case let .failure(error):
				print("Error getting post types - returned nil: \(error)")
			}
		}
	}

	func addSpinner() {
		addChild(child)
		child.view.frame = view.frame
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}
	
	func removeSpinner() {
		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if posts.count == 0 {
			self.removeSpinner()
			self.tableView.setEmptyMessage("Looks like this type has no content!")
		} else {
			self.tableView.restore()
		}
		return posts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		let title = posts[indexPath.row]
		
		cell.textLabel?.text = title
		
		return cell
	}
}

