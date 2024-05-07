//
//  ViewController.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 05/05/24.
//

import UIKit

final class PostListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: PostListViewModelProtocol = PostListViewModel()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let cellId = "PostListCell"
    private var currentPageNo = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        self.tableView.tableHeaderView = UIView()
        showActivityIndicator()
        fetchPosts()
    }

    private func showActivityIndicator() {
        activityIndicator.startAnimating()
    }

    @objc private func fetchPosts() {
        viewModel.fetchPostList(pageNo: currentPageNo, success: {[weak self] isSuccess in
            if isSuccess {
                self?.tableView.reloadData()
                self?.currentPageNo += 1
            } else {
                self?.showAlert()
            }
            self?.activityIndicator.stopAnimating()
        })
    }

    private func showAlert() {
        let alert = UIAlertController.init(title: "Error", message: "Unable to fetch data. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostListCell
        if let pCell = tableView.dequeueReusableCell(withIdentifier: PostListViewController.cellId) as? PostListCell {
            cell = pCell
        } else {
            cell = PostListCell()
        }

        let post = viewModel.posts[indexPath.row]
        cell.titleLabel.text = "\(post.id)"
        cell.subtitleLabel.text = post.title
        cell.descLabel.text = post.body
        return cell
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentPostsCount = viewModel.posts.count
        if indexPath.row == currentPostsCount - 1 {
            if viewModel.shouldFetchNextPage(for: currentPageNo - 1) {
                fetchPosts()
                activityIndicator.startAnimating()
            }
        }
    }
}

extension PostListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostDetails", let vc = segue.destination as? PostDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            vc.details = viewModel.getPostDetails(for: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
