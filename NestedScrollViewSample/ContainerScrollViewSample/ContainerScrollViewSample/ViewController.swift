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
        "hawaii",
        "rome"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Travel Destinations"

        setupViews()
    }

    private func setupViews() {
        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
            scrollView.contentView.addSubview(tableView)
        }
    }
}
