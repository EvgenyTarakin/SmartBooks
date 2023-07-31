//
//  BooksPresenter.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 31.07.2023.
//

import Foundation

// MARK: - protocol
protocol BooksPresenterToView: AnyObject {
    func fetchData(_ books: [Book])
}

final class BooksPresenter {
    
    // MARK: - property
    unowned let view: BooksPresenterToView
    private var dataManager = DataManager()
    private var book: [Book] = []
    
    // MARK: - init
    required init(view: BooksPresenterToView) {
        self.view = view
    }
}

// MARK: - BooksViewToPresenter
extension BooksPresenter: BooksViewToPresenter {
    func viewDidLoad() {
        book = dataManager.books
    }
    
    func viewWillAppear() {
        book = dataManager.books
        view.fetchData(book)
    }
}
