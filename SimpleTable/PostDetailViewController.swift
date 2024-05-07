//
//  PostDetailViewController.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 07/05/24.
//

import UIKit

final class PostDetailViewController: UIViewController {
    var details = ""
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Details"
        self.detailLabel.text = details
    }
}
