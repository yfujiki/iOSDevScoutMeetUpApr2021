//
//  ImageTableView.swift
//  NaiveNestedTableViewSample
//
//  Created by Yuichi Fujiki on 16/4/21.
//

import UIKit

class ImageTableView: UITableView {

    private let imageNameRoot: String

    init(imageNameRoot: String) {
        self.imageNameRoot = imageNameRoot
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1)), style: .plain)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        register(ImageTableViewCell.self, forCellReuseIdentifier: "Cell")
        dataSource = self

        switch imageNameRoot {
        case "bunny":
            backgroundColor = .systemPink
        case "parrot":
            backgroundColor = .blue
        case "puppy":
            backgroundColor = .brown
        case "kitty":
            backgroundColor = .yellow
        default:
            backgroundColor = .white
        }
    }

    // Self sizing
    override func layoutSubviews() {
         super.layoutSubviews()
         if bounds.size != intrinsicContentSize {
             invalidateIntrinsicContentSize()
         }
     }

     override var intrinsicContentSize: CGSize {
         return contentSize
     }
}

extension ImageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageTableViewCell
        let imageName = "\(imageNameRoot)-\(indexPath.row)"
        if let image = UIImage(named: imageName) {
            cell.setImage(image)
        }
        cell.contentView.backgroundColor = backgroundColor

        return cell
    }
}

class ImageTableViewCell: UITableViewCell {

    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        posterView.image = image
    }

    private func setup() {
        contentView.addSubview(posterView)

        posterView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

}
