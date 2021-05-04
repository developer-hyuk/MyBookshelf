//
//  EmptyListCell.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension EmptyListCell {
    static let cellHeight: CGFloat = 500
}

final class EmptyListCell: UITableViewCell {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Empty List"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyListCell {
    func setupView() {
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
