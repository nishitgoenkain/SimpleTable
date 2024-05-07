//
//  ProductListViewModel.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 05/05/24.
//

import Foundation

protocol PostListViewModelProtocol {
    var posts: [Post] { get }
    func fetchPostList(pageNo: Int, success: @escaping (Bool) -> ())
    func shouldFetchNextPage(for currentPageNo: Int) -> Bool
}

class PostListViewModel {
    var pageLimit = 10
    static let urlString = "https://jsonplaceholder.typicode.com/posts"
    var posts: [Post] = []
    
}

extension PostListViewModel: PostListViewModelProtocol {
    func fetchPostList(pageNo: Int, success: @escaping (Bool) -> ()) {
        let paginatedUrlString = PostListViewModel.urlString + "?_page=\(pageNo)&_limit=\(pageLimit)"
        
        guard let url = URL(string: paginatedUrlString) else {
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
                    self?.posts.append(contentsOf: postList)
                    success(true)
                } catch {
                    success(false)
                }
            }
        }.resume()
    }
    
    func shouldFetchNextPage(for currentPageNo: Int) -> Bool {
        return posts.count == pageLimit * currentPageNo
    }
}
