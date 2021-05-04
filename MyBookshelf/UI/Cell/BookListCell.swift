//
//  BookListCell.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension BookListCell {
    static let cellHeight: CGFloat = 100
    
    private static let imageSize: CGSize = .init(width: 60, height: 70)
    private static let imageLeftMargin: CGFloat = 10
    private static let contentLeftMargin: CGFloat = 10
    private static let contentRightMargin: CGFloat = 10
    private static let subTitleTopMargin: CGFloat = 3
    private static let priceTopMargin: CGFloat = 3
    private static let isbnTopMargin: CGFloat = 3
}

final class BookListCell: UITableViewCell {
    
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    private lazy var isbnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.cancelLoadImage()
        bookImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        priceLabel.text = nil
        isbnLabel.text = nil
    }
    
    func set(data: Book) {
        bookImageView.loadImage(url: data.image)
        titleLabel.text = data.title
        subTitleLabel.text = data.subtitle
        priceLabel.text = data.price
        isbnLabel.text = "ISBN-13 : \(data.isbn13)"
    }
}

private extension BookListCell {
    func setupView() {
        // Image

        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookImageView)
        
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalToConstant: Self.imageSize.width),
            bookImageView.heightAnchor.constraint(equalToConstant: Self.imageSize.height),
            bookImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Self.imageLeftMargin),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Container
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: Self.contentLeftMargin),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Self.contentRightMargin),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Title
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // Subtitle
        
        view.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Self.subTitleTopMargin)
        ])
        
        // Price
        
        view.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            priceLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: Self.priceTopMargin)
        ])
        
        // isbn-13
        
        view.addSubview(isbnLabel)
        
        NSLayoutConstraint.activate([
            isbnLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            isbnLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            isbnLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Self.isbnTopMargin),
            isbnLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
