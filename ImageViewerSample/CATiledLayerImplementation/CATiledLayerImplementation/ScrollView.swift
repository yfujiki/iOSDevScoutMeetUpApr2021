//
//  ContentCenteredScrollView.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 14/4/21.
//

import UIKit

class ContentCenteredScrollView: UIScrollView {
    
    private var contentView: UIView? {
        return subviews.first
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImageView()
    }

    private func centerImageView() {
        guard let contentView = self.contentView else { return }

        let boundsSize = bounds.size
        var contentViewFrame = contentView.frame

        if contentViewFrame.size.width < boundsSize.width {
            contentViewFrame.origin.x = (boundsSize.width - contentViewFrame.width) / 2
        } else {
            contentViewFrame.origin.x = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        if contentViewFrame.size.height < boundsSize.height {
            contentViewFrame.origin.y = (boundsSize.height - contentViewFrame.height) / 2
        } else {
            contentViewFrame.origin.y = 0 // When content view of a scrollview is bigger, the content view's placement is determined by contentOffset of the scrollview (bounds of scrollview), so origin can be always zero
        }

        contentView.frame = contentViewFrame
    }
}
