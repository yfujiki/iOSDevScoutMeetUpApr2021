//
//  ContainerScrollView.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 25/7/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

var observersDict: [UIView: [NSObjectProtocol]] = [:]

class ContainerScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews() {
        _ = contentView
    }

    private var contentViewHeightConstraint: NSLayoutConstraint!

    private(set) lazy var contentView: ContainerScrollContentView = {
        let contentView = ContainerScrollContentView()

        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        self.contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        self.contentViewHeightConstraint.isActive = true

        return contentView
    }()

    func didAddContentSubview(_ subview: UIView) {
        guard let tableView = subview as? UIScrollView else { return }
        tableView.isScrollEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let contentView = subviews.first(where: { $0 is ContainerScrollContentView }) else { return }

        var lastTableViewMaxY = CGFloat(0)

        for innerTableView in contentView.subviews.filter({ $0 is UITableView }) {
            let tableView = innerTableView as! UITableView

            updateFrameAndBounds(tableView, &lastTableViewMaxY)
        }

        contentSize = CGSize(width: self.bounds.width, height: lastTableViewMaxY)
        contentViewHeightConstraint.constant = lastTableViewMaxY
    }
    
    private func updateFrameAndBounds(_ tableView: UITableView, _ lastTableViewMaxY: inout CGFloat) {
        let offsetY = contentOffset.y - lastTableViewMaxY
        let maxY = offsetY + frame.height

        if maxY <= 0 {
            // Lower than the window
            tableView.frame = CGRect(x: 0, y: lastTableViewMaxY,
                                     width: tableView.frame.width, height: 0)
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        } else if offsetY >= tableView.contentSize.height {
            // Higher than the window
            tableView.frame = CGRect(x: 0, y: lastTableViewMaxY - tableView.contentSize.height,
                                     width: tableView.frame.width, height: 0)
            tableView.contentOffset = CGPoint(x: 0, y: offsetY)
        } else if offsetY >= 0 {
            // Lower part is visible
            let tableViewHeight = min(tableView.contentSize.height - offsetY, frame.height)
            tableView.frame = CGRect(x: 0, y: lastTableViewMaxY + offsetY,
                                     width: tableView.frame.width, height: tableViewHeight)
            tableView.contentOffset = CGPoint(x: 0, y: offsetY)
        } else {
            // Upper part is visible
            let tableViewHeight = min(maxY, frame.height)
            tableView.frame = CGRect(x: 0, y: lastTableViewMaxY,
                                     width: tableView.frame.width, height: tableViewHeight)
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        }

        lastTableViewMaxY += tableView.contentSize.height
    }
}

class ContainerScrollContentView: UIView {
    override func didAddSubview(_ subview: UIView) {
        guard let superScrollView = superview as? ContainerScrollView else { return }
        superScrollView.didAddContentSubview(subview)
    }
}
