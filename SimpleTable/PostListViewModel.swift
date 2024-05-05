//
//  ProductListViewModel.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 05/05/24.
//

import Foundation

protocol PostListViewModelProtocol {
    func fetchPostList(success: @escaping (Bool) -> ())
    var posts: [Post] { get }
}

class PostListViewModel {
    static let urlString = "https://jsonplaceholder.typicode.com/posts?_page=1&_limit=10"
    var posts: [Post] = []
}

extension PostListViewModel: PostListViewModelProtocol {
    func fetchPostList(success: @escaping (Bool) -> ()) {
        
        guard let url = URL(string: PostListViewModel.urlString) else {
            success(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error ==  nil, let data = data else {
                    success(false)
                    return
                }
                
                do {
                    let postList = try JSONDecoder().decode([Post].self, from: data)
                    self?.posts = postList
                    success(true)
                } catch {
                    success(false)
                }
            }
        }.resume()
    }
}
