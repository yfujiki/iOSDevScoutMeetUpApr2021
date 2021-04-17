//
//  ViewController.swift
//  NaiveNestedTableViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: OuterScrollView!

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
        var lastTableView: UITableView?

        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
            scrollView.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false

            if let lastTableView = lastTableView {
                NSLayoutConstraint.activate([
                    tableView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    tableView.topAnchor.constraint(equalTo: lastTableView.bottomAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    tableView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    tableView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
                ])
            }

            lastTableView = tableView
        }
    }
}

