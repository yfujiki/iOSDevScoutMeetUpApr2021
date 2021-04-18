//
//  ViewController.swift
//  NaiveNestedTableViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

// ToDo:
// Implement panGestureTranslation with runtime in ScrollView
// Reset that translation value from previous scrollview when control switches
class ViewController: UIViewController {

    @IBOutlet weak var scrollView: OuterScrollView!

    private let imageNames = [
        "hawaii",
        "rome"
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
            tableView.bounces = false
            tableView.delegate = self
            tableView.estimatedRowHeight = 320
            tableView.tag = i + 1
            tableView.showsVerticalScrollIndicator = false

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

        // ToDo
        lastTableView?.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: bottomPadding).isActive = true
    }

    private func switchScrolling() {
        let newScrollViewInCharge = scrollViewInCharge()

//        if newScrollViewInCharge == scrollViewInControl { return }
//
//        if let currentPanTranslation = scrollViewInControl?.panGestureRecognizer.translation(in: scrollViewInControl) {
//            newScrollViewInCharge.panGestureRecognizer.setTranslation(currentPanTranslation, in: newScrollViewInCharge)
//        }

        scrollView.isScrollEnabled = newScrollViewInCharge == scrollView
        tableViews.forEach { (tableView) in
            tableView.isScrollEnabled = tableView == newScrollViewInCharge
        }

        scrollViewInControl = newScrollViewInCharge
    }

    private func scrollViewInCharge() -> UIScrollView {
        var visibleScrollViews = [UIScrollView]()
        let scrollViewBounds = scrollView.bounds.inset(by: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0))
        NSLog("ScrollView bounds \(scrollViewBounds)")

        tableViews.forEach { (tableView) in
            NSLog("TableView(\(tableView.tag)) frame \(tableView.frame)")
            if tableView.frame.intersects(scrollViewBounds) {
                visibleScrollViews.append(tableView)
            }
            NSLog("TableView(\(tableView.tag)) bounds \(tableView.bounds)")
            NSLog("TableView(\(tableView.tag)) content size \(tableView.contentSize)")
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
    private static var panTranslationKey = "panTranslationKey"

    var panTranslation: CGPoint? {
        get {
            let number = objc_getAssociatedObject(self, &UIScrollView.panTranslationKey) as? NSNumber
            return number?.cgPointValue
        }
        set {
            guard let point = newValue else { return }
            let number = NSNumber(cgPoint: point)
            objc_setAssociatedObject(self, &UIScrollView.panTranslationKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIScrollView {
    var isPanningDown: Bool {
        NSLog("* Pan translation : \(panGestureRecognizer.translation(in: self).y)")
        return panGestureRecognizer.translation(in: self).y < 0
//        NSLog("Pan velocity : \(panGestureRecognizer.velocity(in: self).y)")
//        return panGestureRecognizer.velocity(in: self).y < 0
    }

    var isPanningUp: Bool {
        return panGestureRecognizer.translation(in: self).y > 0
//        return panGestureRecognizer.velocity(in: self).y > 0
    }

    func isReachingToTop(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        NSLog("= Panning up?(\(scrollViewInControl.tag)) \(scrollViewInControl.isPanningUp)")
        NSLog("Bounds \(bounds)")
        NSLog("ContentSize \(contentSize)")
        return scrollViewInControl.isPanningUp &&
            bounds.origin.y < 100
    }

    func isReachingToEnd(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        NSLog("= Panning down?(\(scrollViewInControl.tag)) \(scrollViewInControl.isPanningDown)")
        NSLog("Bounds \(bounds)")
        NSLog("ContentSize \(contentSize)")
        return scrollViewInControl.isPanningDown &&
            bounds.origin.y + bounds.size.height + 100 > contentSize.height
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switchScrolling()
    }
}
