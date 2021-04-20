//
//  ViewController.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 9/4/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI controls (boilerplate)
    private lazy var scrollView: ContentCenteredScrollView = {
        let scrollView = ContentCenteredScrollView()
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

    private lazy var tilingView: TilingView = {
        // This size defines the TilingView at zoomScale=1
        let tilingView = TilingView(size: TilingView.minImageSize)
        return tilingView
    }()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollViewConstraints)
        scrollView.addSubview(tilingView)
        
        setMinMaxZoomScale()
    }
    
    private func setMinMaxZoomScale() {
        // maximum
        var expectedWidthZoomScale = (TilingView.maxImageSize.width / tilingView.bounds.size.width)
        var expectedHeightZoomScale = (TilingView.maxImageSize.height / tilingView.bounds.size.width)
        scrollView.maximumZoomScale = max(expectedWidthZoomScale, expectedHeightZoomScale)

        // minimum
        let bounds = UIScreen.main.bounds
        expectedWidthZoomScale = bounds.width / tilingView.bounds.size.width
        expectedHeightZoomScale = bounds.height / tilingView.bounds.size.height
        scrollView.minimumZoomScale = min(expectedWidthZoomScale, expectedHeightZoomScale)

        // current
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

}

// MARK: - Delegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.tilingView
    }
}
