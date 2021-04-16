//
//  ViewController.swift
//  ContainerScrollViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: ContainerScrollView!

    private let imageNames = [
        "bunny",
        "parrot",
        "puppy",
        "kitty"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
            scrollView.contentView.addSubview(tableView)
        }
    }
}
