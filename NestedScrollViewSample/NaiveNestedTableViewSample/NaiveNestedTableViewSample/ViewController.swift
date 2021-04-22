//
//  ViewController.swift
//  NaiveNestedTableViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

class ViewController: UIViewController {

    private let imageNames = [
        "hawaii",
        "rome"
    ]

    // MARK: - UI controls (boilerplate)
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private lazy var scrollViewConstraints: [NSLayoutConstraint] = {
        return [
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Travel Destinations"

        setupViews()
    }

    private func setupViews() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollViewConstraints)

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

        lastTableView?.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
    }
}

