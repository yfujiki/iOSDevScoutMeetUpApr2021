//
//  GalleryScrollView.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 14/4/21.
//

import UIKit

class GalleryScrollView: UIScrollView {

    var viewForZooming: UIView { return galleryView }

    private(set) var galleryView: GalleryView!

    func loadTiles() {
        let minImageSize = CGSize(width: GalleryView.tileWidth * 1, height: GalleryView.tileHeight * 1)
        let maxImageSize = CGSize(width: GalleryView.tileWidth * 4, height: GalleryView.tileHeight * 4)

        // This size defines the GalleryView at zoomScale=1
        galleryView = GalleryView(size: minImageSize)
        addSubview(galleryView)

        setMinMaxZoomScale(forMaxFileSize: maxImageSize)
    }

    private func setMinMaxZoomScale(forMaxFileSize fileSize: CGSize) {
        // maximum
        var expectedWidthZoomScale = (fileSize.width / galleryView.bounds.size.width)
        var expectedHeightZoomScale = (fileSize.width / galleryView.bounds.size.width)
        maximumZoomScale = max(expectedWidthZoomScale, expectedHeightZoomScale)

        // minimum
        let bounds = UIScreen.main.bounds
        expectedWidthZoomScale = bounds.width / galleryView.bounds.size.width
        expectedHeightZoomScale = bounds.height / galleryView.bounds.size.height
        minimumZoomScale = min(expectedWidthZoomScale, expectedHeightZoomScale)

        // current
        zoomScale = minimumZoomScale
    }

    // MARK: - Center image

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImageView()
    }

    private func centerImageView() {
        guard let galleryView = self.galleryView else { return }

        let boundsSize = bounds.size
        var galleryViewFrame = galleryView.frame

        if galleryViewFrame.size.width < boundsSize.width {
            galleryViewFrame.origin.x = (boundsSize.width - galleryViewFrame.width) / 2
        } else {
            galleryViewFrame.origin.x = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        if galleryViewFrame.size.height < boundsSize.height {
            galleryViewFrame.origin.y = (boundsSize.height - galleryViewFrame.height) / 2
        } else {
            galleryViewFrame.origin.y = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        galleryView.frame = galleryViewFrame
    }
}
