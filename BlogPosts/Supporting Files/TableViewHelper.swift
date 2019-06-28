//
//  TableViewHelper.swift
//  BlogPosts
//
//  Created by Jodi Smit on 6/27/19.
//  Copyright © 2019 Kabbage. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
	var spinner = UIActivityIndicatorView(style: .whiteLarge)
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 0.7)
		
		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.startAnimating()
		view.addSubview(spinner)
		
		spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
}

extension UITableView {
	
	func setEmptyMessage(_ message: String) {
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
		messageLabel.text = message
		messageLabel.textColor = .black
		messageLabel.numberOfLines = 0;
		messageLabel.textAlignment = .center;
		messageLabel.sizeToFit()
		
		self.backgroundView = messageLabel;
		self.separatorStyle = .none;
	}
	
	func restore() {
		self.backgroundView = nil
		self.separatorStyle = .singleLine
	}
}

