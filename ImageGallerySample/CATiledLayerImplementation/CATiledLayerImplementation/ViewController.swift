//
//  ViewController.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 9/4/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI controls (boilerplate)
    private lazy var scrollView: GalleryScrollView = {
        let scrollView = GalleryScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.delegate = self

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

        setupViews()
    }

    private func setupViews() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollViewConstraints)
        scrollView.loadTiles()
    }
}

// MARK: - Delegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollView.viewForZooming
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        NSLog("Zoomed to scale \(scale)")
    }
}
