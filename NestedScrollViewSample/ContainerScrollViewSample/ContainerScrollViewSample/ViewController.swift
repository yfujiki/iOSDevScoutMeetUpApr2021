//
//  ViewController.swift
//  ContainerScrollViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

class ViewController: UIViewController {

    private let imageNames = [
        "hawaii",
        "rome"
    ]

    // MARK - UI controls boilder plate
    private lazy var scrollView: ContainerScrollView = {
        let scrollView = ContainerScrollView()

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

        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
            scrollView.contentView.addSubview(tableView)
        }
    }
}
