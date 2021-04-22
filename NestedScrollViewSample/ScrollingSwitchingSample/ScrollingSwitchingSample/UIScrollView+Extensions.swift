//
//  UIScrollView+Extensions.swift
//  ScrollingSwitchingSample
//
//  Created by Yuichi Fujiki on 23/4/21.
//

import UIKit

extension UIScrollView {
    var isUserInteracted: Bool {
        return isTracking || isDragging || isDecelerating
    }

    var isPanningUp: Bool {
        return panGestureRecognizer.translation(in: self).y < 0
    }

    var isPanningDown: Bool {
        return panGestureRecognizer.translation(in: self).y > 0
    }

    func isReachingToTop(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        return scrollViewInControl.isPanningDown &&
            bounds.origin.y <= 0
    }

    func isReachingToEnd(in scrollViewInControl: UIScrollView?) -> Bool {
        guard let scrollViewInControl = scrollViewInControl else { return false }
        return scrollViewInControl.isPanningUp &&
            bounds.origin.y + bounds.size.height >= contentSize.height
    }
}
