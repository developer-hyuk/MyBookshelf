//
//  MemoViewController.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/04.
//

import UIKit

final class MemoViewController: UIViewController {
    
    private var isbn13: String!
    
    private lazy var topBar = TopBar()
    private lazy var textView = UITextView()
    
    init(isbn13: String) {
        super.init(nibName: nil, bundle: nil)
        self.isbn13 = isbn13
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTopbar()
        setupTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
}

// MARK: - SetUp
private extension MemoViewController {
    func setupView() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    func setupTopbar() {
        view.addSubview(topBar)
        topBar.onAction = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .save:
                MemoStorage.shared.put(self.isbn13, memo: self.textView.text)
                self.dismiss(animated: true, completion: nil)
            case .close:
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func setupTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = MemoStorage.shared.get(isbn13)
        textView.font = UIFont.systemFont(ofSize: 15)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TopBar
private extension MemoViewController {
    final class TopBar: UIView {
        enum Action {
            case save
            case close
        }
        
        var onAction: ((Action) -> Void)?
        
        private lazy var titleLabel = UILabel()
        
        init() {
            super.init(frame: .zero)
            
            backgroundColor = .gray
            
            translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.text = "Memo"
            
            addSubview(titleLabel)
            
            let closeButton = UIButton(type: .custom)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(didTabClose), for: .touchUpInside)
            closeButton.setTitle("Close", for: .normal)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            addSubview(closeButton)
            
            let saveButton = UIButton(type: .custom)
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            saveButton.addTarget(self, action: #selector(didTabSave), for: .touchUpInside)
            saveButton.setTitle("Save", for: .normal)
            saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            addSubview(saveButton)
            
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: 50),
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                saveButton.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -10),
                saveButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func didTabSave() {
            onAction?(.save)
        }
        
        @objc private func didTabClose() {
            onAction?(.close)
        }
    }
}
