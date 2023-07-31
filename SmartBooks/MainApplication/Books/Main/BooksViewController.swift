//
//  BooksViewController.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 28.07.2023.
//

import UIKit
import SnapKit

// MARK: - protocol
protocol BooksViewToPresenter: AnyObject {
    init(view: BooksPresenterToView)
    func viewDidLoad()
    func viewWillAppear()
}

final class BooksViewController: UIViewController {
    
    // MARK: - property
    private var books: [Book] = []
    
    private lazy var presenter: BooksViewToPresenter = {
        return BooksPresenter(view: self)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = UIColor(hex: "E9EEF3")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: - private func
    private func commonInit() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            self.makePhotoSectionLayout()
        }
        return layout
    }
    
    private func makePhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),  heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

}

// MARK: - UICollectionViewDelegate
extension BooksViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension BooksViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath) as? BookCell
        else { return UICollectionViewCell() }
        if let name = books[indexPath.item].name,
           let author = books[indexPath.item].author {
            cell.configurate(name: name, author: author, count: books[indexPath.item].count)
        }
        
        return cell
    }
}

// MARK: - BooksPresenterToView
extension BooksViewController: BooksPresenterToView {
    func fetchData(_ books: [Book]) {
        self.books = books
        collectionView.reloadData()
    }
}
