//
//  Posts.swift
//  BlogPosts
//
//  Created by Jodi Smit on 6/27/19.
//  Copyright © 2019 Kabbage. All rights reserved.
//

import Foundation

struct FullResponse: Decodable {
	struct Taxonomy: Decodable {
		let slug: String
		let types: [String]
	}
	
	let taxonomies: [Taxonomy]
	
	enum CodingKeys: String, CodingKey {
		case taxonomies
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		taxonomies = try container.decodeIfPresent([Taxonomy].self, forKey: .taxonomies)!
	}
}

struct PostsFullResponse: Decodable {
	let title: String
}

