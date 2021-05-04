//
//  BookDetailViewController.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/03.
//

import UIKit

final class BookDetailViewController: UIViewController {
    
    private lazy var bookDetailLoader = BookDetailLoader()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = ContentView()
    
    private var book: Book!
    
    init(book: Book) {
        super.init(nibName: nil, bundle: nil)
        self.book = book
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScrollView()
        setupContentView()
        setupLoader()
        
        loadData()
    }
}

// MARK: - SetUp
private extension BookDetailViewController {
    func setupView() {
        title = "Detail"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Memo", style: .plain, target: self, action: #selector(didClickRight))
    }
    
    func setupScrollView() {
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.frame = view.frame
        view.addSubview(scrollView)
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
        
        contentView.onAction = { [weak self] action in
            switch action {
            case .onClickUrl:
                guard let url = self?.book?.url else { return }
                URL(string: url)?.openBrowser()
            }
        }
        
        contentView.set(data: book)
    }
    
    func setupLoader() {
        bookDetailLoader.onChangeStatus = { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .dataChanged(let detail):
                self.contentView.set(data: detail)
            case .fail(let error):
                self.showAlert(message: error.localizedDescription, defaultTitle: "Retry") {
                    self.loadData()
                }
            }
        }
    }
    
    func loadData() {
        bookDetailLoader.load(with: book.isbn13)
    }
}

// MARK: - Action
private extension BookDetailViewController {
    @objc func didClickRight() {
        let viewController = MemoViewController(isbn13: book.isbn13)
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - ContentView
private extension BookDetailViewController {
    final class ContentView: UIView {
        enum Action {
            case onClickUrl
        }
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.numberOfLines = 0
            return label
        }()
        private lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            return label
        }()
        private lazy var bookImageView: UIImageView = {
            let imageView = UIImageView()
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 300),
                imageView.heightAnchor.constraint(equalToConstant: 350)
            ])
            return imageView
        }()
        private lazy var linkButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Open Url", for: .normal)
            button.addTarget(self, action: #selector(onClickUrl), for: .touchUpInside)
            return button
        }()
        private lazy var moreInformationLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.numberOfLines = 0
            return label
        }()
        
        var onAction: ((Action) -> ())?
        
        init() {
            super.init(frame: .zero)
            
            translatesAutoresizingMaskIntoConstraints = false
            
            let views = [titleLabel, subTitleLabel, bookImageView, linkButton, moreInformationLabel]
            let centerViews = [bookImageView, linkButton]
            
            for (index, view) in views.enumerated() {
                let spacing: CGFloat = index == 0 ? 0 : 7
                let last = index == views.count - 1
                let center = centerViews.contains(view)
                add(view, spacing: spacing, center: center, last: last)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func set(data: Book) {
            titleLabel.text = data.title
            subTitleLabel.text = data.subtitle
            bookImageView.loadImage(url: data.image)
        }
        
        func set(data: BookDetail) {
            moreInformationLabel.text = moreInformation(with: data)
        }
        
        private func add(_ view: UIView, spacing: CGFloat, center: Bool = false, last: Bool = false) {
            let lastAnchor = subviews.last?.bottomAnchor ?? topAnchor
            
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)

            var constraints: [NSLayoutConstraint] = []
            
            constraints.append(view.topAnchor.constraint(equalTo: lastAnchor, constant: spacing))
            
            if center {
                constraints.append(view.centerXAnchor.constraint(equalTo: centerXAnchor))
            } else {
                constraints.append(view.leftAnchor.constraint(equalTo: leftAnchor))
                constraints.append(view.rightAnchor.constraint(equalTo: rightAnchor))
            }
            
            if last {
                constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor))
            }
            
            NSLayoutConstraint.activate(constraints)
        }
        
        private func moreInformation(with data: BookDetail) -> String {
            return [
                "Price: \(data.price)",
                "Authors: \(data.authors)",
                "Publisher: \(data.publisher)",
                "Language: \(data.language)",
                "Pages: \(data.pages)",
                "Year: \(data.year)",
                "Rating: \(ratingEmoticon(data.rating))",
                "ISBN-13: \(data.isbn13)",
                "",
                "Description",
                "\(data.desc)"
            ].joined(separator: "\n")
        }
        
        private func ratingEmoticon(_ rating: String) -> String {
            guard let value = Int(rating),
                  value > 0 else { return "😭" }
            return String(repeating: "🥰", count: value)
        }
        
        @objc func onClickUrl() {
            onAction?(.onClickUrl)
        }
    }
}
