//
//  ViewController.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 05/05/24.
//

import UIKit

class PostListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel: PostListViewModelProtocol?
    
    static let cellId = "PostListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = PostListViewModel()
        viewModel?.fetchPostList(success: {[weak self] isSuccess in
            if isSuccess {
                self?.tableView.reloadData()
            } else {
                self?.showAlert()
            }
        })
    }
    
    func showAlert() {
        let alert = UIAlertController.init(title: "Error", message: "Unable to fetch data. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }


}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostListCell
        if let pCell = tableView.dequeueReusableCell(withIdentifier: PostListViewController.cellId) as? PostListCell {
            cell = pCell
        } else {
            cell = PostListCell()
        }
        guard let post = viewModel?.posts[indexPath.row] else { return cell }
        cell.titleLabel.text = "\(post.id)"
        cell.subtitleLabel.text = post.title
        cell.descLabel.text = post.body
        return cell
    }
}

extension PostListViewController: UITableViewDelegate {
    
}

