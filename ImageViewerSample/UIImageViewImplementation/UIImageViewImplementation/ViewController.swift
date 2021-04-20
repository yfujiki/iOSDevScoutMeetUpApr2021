//
//  ViewController.swift
//  UIImageViewImplementation
//
//  Created by Yuichi Fujiki on 9/4/21.
//

import UIKit

class ViewController: UIViewController {
    private static let imageWidth = CGFloat(10240)

    // MARK: - UI controls (boilerplate)
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.delegate = self

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        let url = Bundle.main.url(forResource: "Sample", withExtension: "jpg")!
        let data = try! Data(contentsOf: url)
        let image = UIImage(data: data, scale: UIScreen.main.scale)
        imageView.image = image

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var scrollViewConstraints: [NSLayoutConstraint] = {
        return [
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }()

    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        return [
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        ]
    }()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)

        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollViewConstraints)

        adjustZoomScaleToImage()
    }

    private func adjustZoomScaleToImage() {
        // max
        scrollView.maximumZoomScale = 1

        // min
        let minZoomScale = UIScreen.main.bounds.width / (Self.imageWidth / UIScreen.main.scale)
        scrollView.minimumZoomScale = minZoomScale

        // current
        scrollView.setZoomScale(minZoomScale, animated: false)
    }
}

// MARK: - Delegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
