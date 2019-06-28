//
//  APIService.swift
//  BlogPosts
//
//  Created by Jodi Smit on 6/27/19.
//  Copyright © 2019 Kabbage. All rights reserved.
//

import Foundation

enum Result<ExpectedType> {
	case success(ExpectedType)
	case failure(Error)
}

enum BlogAPI {
	case getPostTypes
	case getPostsByType(String)
}

class APIService {
	
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}()


	func fetchPostTypes(completionHandler: @escaping (Result<FullResponse>) -> Void) {
		fetch(with: BlogAPI.getPostTypes.request, completionHandler: completionHandler)
	}
	
	func fetchPosts(for type: String, completionHandler: @escaping (Result<[PostsFullResponse]>) -> Void) {
		fetch(with: BlogAPI.getPostsByType(type).request, completionHandler: completionHandler)
	}
	
	func fetch<ExpectedType: Decodable>(with request: URLRequest, completionHandler: @escaping (Result<ExpectedType>) -> Void) {
		let task = session.dataTask(with: request) { (data, _, error) in

			guard let jsonData = data else {return}

			let decoder = JSONDecoder()

			do {
				let expectedType = try decoder.decode(ExpectedType.self, from: jsonData)

				completionHandler(.success(expectedType))
			} catch {
				completionHandler(.failure(error))
			}
		}
		task.resume()
	}
	
}

extension BlogAPI: Endpoint {
	
	var base: String {
		return "https://www.kabbage.com"
	}
	
	var path: String {
		switch self {
		case .getPostTypes: return "/blog/wp-json/posts/types/post"
		case .getPostsByType: return "/blog/wp-json/posts"
		}
	}
	
	var queryItems: URLQueryItem {
		switch self {
		case .getPostsByType(let postType): return URLQueryItem(name: "type", value: postType)
		case .getPostTypes: return URLQueryItem(name: "", value: "")
		}
	}
}

protocol Endpoint {
	var base: String { get }
	var path: String { get }
	var queryItems: URLQueryItem { get }
}
extension Endpoint {
	
	var urlComponents: URLComponents {
		var components = URLComponents(string: base)!
		components.path = path
		components.queryItems = [queryItems]
		return components
	}
	
	var request: URLRequest {
		let url = urlComponents.url!
		return URLRequest(url: url)
	}
}
