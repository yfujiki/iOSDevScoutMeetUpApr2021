//
//  ViewController.swift
//  NaiveNestedTableViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

// ToDo:
// Boundary issues => Maybe you can control this by transferring the contentOffset to other views
//  - Sometimes scroll up stuck at top of second
//  - Sometimes you need to scroll down couple of times after transitioning to second
//  - White background at the bottom
//  - Inertia in general
class ViewController: UIViewController {

    @IBOutlet weak var scrollView: OuterScrollView!

    private let imageNames = [
        "hawaii",
        "rome"
    ]

    private let colors: [UIColor] = [
        .blue,
        .red
    ]

    private var tableViews = [UITableView]()
    private var scrollViewInControl: UIScrollView? {
        didSet {
            var backgroundColor: UIColor = .white
            if scrollViewInControl == scrollView {
                backgroundColor = .yellow
            } else {
                for (i, tableView) in tableViews.enumerated() {
                    if scrollViewInControl == tableView {
                        backgroundColor = colors[i]
                        break
                    }
                }
            }
            navigationController?.navigationBar.backgroundColor = backgroundColor
        }
    }

    private var topPadding: CGFloat {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        return navigationBarHeight + statusBarHeight
    }

    private var bottomPadding: CGFloat {
        let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return safeAreaHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Travel Destinations"

        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchScrolling()
    }

    private func setupViews() {
        scrollView.tag = 0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self

        var lastTableView: UITableView?

        for (i, imageName) in imageNames.enumerated() {
//        imageNames.forEach { (imageName) in
            let tableView = ImageTableView(imageNameRoot: imageName)
//            tableView.bounces = false
            tableView.delegate = self
            tableView.tag = i + 1

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

    private func switchScrolling() {
        let newScrollViewInCharge = scrollViewInCharge()

        scrollView.isScrollEnabled = newScrollViewInCharge == scrollView
        tableViews.forEach { (tableView) in
            tableView.isScrollEnabled = tableView == newScrollViewInCharge
        }

        // Content Offset
        scrollViewInControl = newScrollViewInCharge
    }

    private func scrollViewInCharge() -> UIScrollView {
        var visibleScrollViews = [UIScrollView]()
        let scrollViewBounds = scrollView.bounds.inset(by: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0))
//        NSLog("ScrollView bounds \(scrollViewBounds)")

        tableViews.forEach { (tableView) in
//            NSLog("TableView(\(tableView.tag)) frame \(tableView.frame)")
            if tableView.frame.intersects(scrollViewBounds) {
                visibleScrollViews.append(tableView)
            }
//            NSLog("TableView(\(tableView.tag)) bounds \(tableView.bounds)")
//            NSLog("TableView(\(tableView.tag)) content size \(tableView.contentSize)")
        }

        if visibleScrollViews.count == 1 {
            let visibleScrollView = visibleScrollViews.first!
//            if visibleScrollView.frame.contains(scrollViewBounds) {
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
//            }
        }
        return scrollView
    }
}

extension UIScrollView {
    var isUserInteracted: Bool {
        return isTracking || isDragging || isDecelerating
    }

    var isPanningUp: Bool {
        NSLog("=* Pan translation : \(panGestureRecognizer.translation(in: self).y)")
        return panGestureRecognizer.translation(in: self).y < 0
    }

    var isPanningDown: Bool {
        NSLog("=* Pan translation : \(panGestureRecognizer.translation(in: self).y)")
        return panGestureRecognizer.translation(in: self).y > 0
    }

    func isReachingToTop(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        NSLog("=@ Panning down?(\(scrollViewInControl.tag)) \(scrollViewInControl.isPanningDown)")
        NSLog("#@ Bounds (checking top) \(bounds)")
        NSLog("#@ ContentSize (checking top) \(contentSize)")
        NSLog("#@ IsReachingToTop \(scrollViewInControl.isPanningDown && bounds.origin.y <= 0)")
        return scrollViewInControl.isPanningDown &&
            bounds.origin.y <= 0
    }

    func isReachingToEnd(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        NSLog("=@ Panning up?(\(scrollViewInControl.tag)) \(scrollViewInControl.isPanningUp)")
        NSLog("#@ Bounds (checking bottom) \(bounds)")
        NSLog("#@ ContentSize (checking bottom) \(contentSize)")
        NSLog("#@ IsReachingToEnd \(scrollViewInControl.isPanningUp && bounds.origin.y + bounds.size.height >= contentSize.height)")

        return scrollViewInControl.isPanningUp &&
            bounds.origin.y + bounds.size.height >= contentSize.height
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollViewInControl?.isUserInteracted == true else { return }
        switchScrolling()
    }
}
