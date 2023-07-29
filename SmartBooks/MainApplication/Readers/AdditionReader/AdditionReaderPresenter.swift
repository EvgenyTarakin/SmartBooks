//
//  AdditionReaderPresenter.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import Foundation

// MARK: - ErrorValidation
enum ErrorValidation {
    case name
    case date
    case all
}

// MARK: - protocol
protocol AdditionReaderPresenterToView: AnyObject {
    func showErrorValidation(_ error: ErrorValidation)
    func backToMainVC()
}

final class AdditionReaderPresenter {
    
    // MARK: - property
    unowned let view: AdditionReaderPresenterToView
    
    private var name: String?
    private var date: String?
    
    // MARK: - init
    required init(view: AdditionReaderPresenterToView) {
        self.view = view
    }
    
}

// MARK: - AdditionReaderViewToPresenter
extension AdditionReaderPresenter: AdditionReaderViewToPresenter {
    func didChangeDate(_ date: String?) {
        self.date = date
    }
    
    func didSelectSaveButton(nameText: String?, dateText: String?) {
        if nameText == "", dateText == "" {
            view.showErrorValidation(.all)
        } else if nameText == "", dateText != "" {
            view.showErrorValidation(.name)
        } else if nameText != "", dateText == "" {
            view.showErrorValidation(.date)
        } else {
            name = nameText
            date = dateText
            view.backToMainVC()
        }
    }
}
