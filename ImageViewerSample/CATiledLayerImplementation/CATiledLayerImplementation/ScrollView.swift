//
//  ScrollView.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 14/4/21.
//

import UIKit

class ScrollView: UIScrollView {

    var viewForZooming: UIView { return tilingView }

    private(set) var tilingView: TilingView!

    func loadTiles() {
        let minImageSize = CGSize(width: TilingView.tileWidth * 1, height: TilingView.tileHeight * 1)
        let maxImageSize = CGSize(width: TilingView.tileWidth * 4, height: TilingView.tileHeight * 4)

        // This size defines the TilingView at zoomScale=1
        tilingView = TilingView(size: minImageSize)
        addSubview(tilingView)

        setMinMaxZoomScale(forMaxFileSize: maxImageSize)
    }

    private func setMinMaxZoomScale(forMaxFileSize fileSize: CGSize) {
        // maximum
        var expectedWidthZoomScale = (fileSize.width / tilingView.bounds.size.width)
        var expectedHeightZoomScale = (fileSize.width / tilingView.bounds.size.width)
        maximumZoomScale = max(expectedWidthZoomScale, expectedHeightZoomScale)

        // minimum
        let bounds = UIScreen.main.bounds
        expectedWidthZoomScale = bounds.width / tilingView.bounds.size.width
        expectedHeightZoomScale = bounds.height / tilingView.bounds.size.height
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
        guard let tilingView = self.tilingView else { return }

        let boundsSize = bounds.size
        var tilingViewFrame = tilingView.frame

        if tilingViewFrame.size.width < boundsSize.width {
            tilingViewFrame.origin.x = (boundsSize.width - tilingViewFrame.width) / 2
        } else {
            tilingViewFrame.origin.x = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        if tilingViewFrame.size.height < boundsSize.height {
            tilingViewFrame.origin.y = (boundsSize.height - tilingViewFrame.height) / 2
        } else {
            tilingViewFrame.origin.y = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        tilingView.frame = tilingViewFrame
    }
}
