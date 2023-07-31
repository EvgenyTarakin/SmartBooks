//
//  AdditionBookPresenter.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 31.07.2023.
//

import UIKit

// MARK: - protocol
protocol AdditionBookPresenterToView: AnyObject {
    func backToMainVC()
}

final class AdditionBookPresenter {
    
    // MARK: - property
    unowned let view: AdditionBookPresenterToView
    private var dataManager = DataManager()
    
    // MARK: - init
    required init(view: AdditionBookPresenterToView) {
        self.view = view
    }
}

// MARK: - AdditionBookViewToPresenter
extension AdditionBookPresenter: AdditionBookViewToPresenter {
    func didSelectSaveButton(name: String, author: String, count: String, image: UIImage) {
        dataManager.saveBook(name: name, author: author, count: Int64(count) ?? 0, image: image)
        view.backToMainVC()
    }
}
