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

        // Setting estimatedRowHeight to close to what you get eventually, is important.
        // If estimatedRowHeight is much smaller than actual height, iOS will end up caching more cells for reuse than necessary.
        // iOS would think more cells would occupy the screen at one time.
        estimatedRowHeight = 320
        showsVerticalScrollIndicator = false

        dataSource = self

        switch imageNameRoot {
        case "hawaii":
            backgroundColor = .blue
        case "rome":
            backgroundColor = .red
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
        let imageName = "\(imageNameRoot)-\(indexPath.row + 1)"
        if let url = Bundle.main.url(forResource: imageName, withExtension: "jpg"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data, scale: UIScreen.main.scale) {
            cell.setImage(image)
        }
//        cell.setNumber(indexPath.row)

        cell.contentView.backgroundColor = backgroundColor

        return cell
    }
}

class ImageTableViewCell: UITableViewCell {

    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = .systemFont(ofSize: 72)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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

    func setNumber(_ number: Int) {
        numberLabel.text = "\(number)"
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

        posterView.addSubview(numberLabel)

        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: posterView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: posterView.centerYAnchor)
        ])
    }

}
