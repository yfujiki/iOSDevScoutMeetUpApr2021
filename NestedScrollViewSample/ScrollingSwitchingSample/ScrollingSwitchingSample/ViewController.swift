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

    private let colors: [UIColor] = [
        .blue,
        .red
    ]

    private var tableViews = [UITableView]()
    private var scrollViewInControl: UIScrollView?

    private var topPadding: CGFloat {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        return navigationBarHeight + statusBarHeight
    }

    private var bottomPadding: CGFloat {
        let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return safeAreaHeight
    }

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

        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false

        var lastTableView: UITableView?

        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
            tableView.bounces = false
            tableView.delegate = self

            scrollView.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false

            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -topPadding).isActive = true

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

            tableViews.append(tableView)
            lastTableView = tableView
        }

        lastTableView?.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: bottomPadding).isActive = true
    }

    // MARK: - Switch Scrolling Control
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchScrolling()
    }

    private func switchScrolling() {
        let newScrollViewInCharge = scrollViewInCharge()

        scrollView.isScrollEnabled = newScrollViewInCharge == scrollView
        tableViews.forEach { (tableView) in
            tableView.isScrollEnabled = newScrollViewInCharge == tableView
        }

        scrollViewInControl = newScrollViewInCharge
    }

    private func scrollViewInCharge() -> UIScrollView {
        var visibleScrollViews = [UIScrollView]()
        let scrollViewBounds = scrollView.bounds.inset(by: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0))

        tableViews.forEach { (tableView) in
            if tableView.frame.intersects(scrollViewBounds) {
                visibleScrollViews.append(tableView)
            }
        }

        if visibleScrollViews.count == 1 {
            let visibleScrollView = visibleScrollViews.first!
            if visibleScrollView.isReachingToTop(in: scrollViewInControl) {
                if visibleScrollView != tableViews.first {
                    return scrollView
                }
            }
            if visibleScrollView.isReachingToEnd(in: scrollViewInControl) {
                if visibleScrollView != tableViews.last {
                    return scrollView
                }
            }
            return visibleScrollView
        }
        return scrollView
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollViewInControl?.isUserInteracted == true else { return }
        switchScrolling()
    }
}
