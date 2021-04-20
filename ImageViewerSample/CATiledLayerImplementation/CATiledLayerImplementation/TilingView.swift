//
//  TilingView.swift
//  CATiledLayerImplementation
//
//  Created by Yuichi Fujiki on 14/4/21.
//

import QuartzCore
import CoreGraphics
import UIKit

class TilingView: UIView {
    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    static let imageNameRoot = "Sample"
    static let tileWidth = CGFloat(2560) / UIScreen.main.scale
    static let tileHeight = CGFloat(1440) / UIScreen.main.scale

    init(size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        if let tiledLayer = self.layer as? CATiledLayer {
            // This corresponds to the total levels we have. If you don't have negative zoom level, then it is levelsOfDetailBias + 1
            tiledLayer.levelsOfDetail = 3
            // This corresponds to the levels we have toward the positive zoom scale
            tiledLayer.levelsOfDetailBias = 2

            tiledLayer.tileSize = CGSize(width: Self.tileWidth * UIScreen.main.scale, height: Self.tileHeight * UIScreen.main.scale)
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let scale = context.ctm.a // This scale is retina scale * zoom scale
        let zoomScale = scale / UIScreen.main.scale
        NSLog("Scale \(scale)")

        let logicalRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        NSLog("Drawing logical rect origin : \(logicalRect.origin), size: \(logicalRect.size)")

        let logicalTileWidth = Self.tileWidth * UIScreen.main.scale
        let logicalTileHeight = Self.tileHeight * UIScreen.main.scale

        let firstCol = Int(logicalRect.minX / logicalTileWidth)
        let firstRow = Int(logicalRect.minY / logicalTileHeight)
        let lastCol = Int((logicalRect.maxX - 1) / logicalTileWidth)
        let lastRow = Int((logicalRect.maxY - 1) / logicalTileHeight)

        for row in firstRow...lastRow {
            for col in firstCol...lastCol {
                let tile = self.tileImage(for: zoomScale, row: row, col: col)
                let logicalTileRect = CGRect(x: logicalTileWidth * CGFloat(col), y: logicalTileHeight * CGFloat(row), width: logicalTileWidth, height: logicalTileHeight)
                let tileRect = logicalTileRect.applying(CGAffineTransform(scaleX: scale, y: scale).inverted())
                tile?.draw(in: tileRect)
            }
        }
    }

    private func tileImage(for zoomScale: CGFloat, row: Int, col: Int) -> UIImage? {
        let level = min(max(Int(log2(zoomScale)), 0), 2)
        NSLog("Using level \(level)")
        let imageName = "\(Self.imageNameRoot)-L\(level)-R\(row)-C\(col)"
        guard let path = Bundle.main.path(forResource: imageName, ofType: "jpg") else { return nil }
        return UIImage(contentsOfFile: path)
    }
}
