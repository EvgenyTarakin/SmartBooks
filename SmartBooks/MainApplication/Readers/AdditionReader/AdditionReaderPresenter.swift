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
    
    private let dataManager = DataManager()
    
    private var name: String?
    private var date: String?
    private var type: Int16?
    
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
            type = Int16.random(in: 0...2)
            guard let name, let date, let type else { return }
            dataManager.saveReader(name: name, date: date, info: type)
            view.backToMainVC()
        }
    }
}
