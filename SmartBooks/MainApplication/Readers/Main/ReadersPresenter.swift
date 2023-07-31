//
//  ReadersPresenter.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 30.07.2023.
//

import Foundation

// MARK: - protocol
protocol ReadersPresenterToView: AnyObject {
    func showFilterMenu()
    func hideFilterMenu()
    func updateFilterMenu(_ type: TypeFilter)
    func fetchData(_ data: [Reader])
}

final class ReadersPresenter {
    
    // MARK: - property
    unowned let view: ReadersPresenterToView
    
    private let dataManager = DataManager()
    private var readers: [Reader] = []
    private var filter: TypeFilter = .overdueBooks
    
    // MARK: - init
    required init(view: ReadersPresenterToView) {
        self.view = view
    }
    
}

// MARK: - ReadersViewToPresenter
extension ReadersPresenter: ReadersViewToPresenter {
    func didSelectMenuFilterButton() {
        view.showFilterMenu()
    }
    
    func didSelectTapOnView() {
        view.hideFilterMenu()
    }
    
    func didSelectFilterButton(_ type: TypeFilter) {
        filter = type
        switch type {
        case .alphabet:
            readers = dataManager.reader.sorted { $0.name ?? "" < $1.name ?? ""}
        case .overdueBooks:
            let overDueReaders = dataManager.reader.filter { $0.info == 0 }
            let otherReaders = dataManager.reader.filter { $0.info != 0 }
            readers = overDueReaders + otherReaders
        }
        view.fetchData(readers)
        view.updateFilterMenu(type)
    }
    
    func loadData() {
        didSelectFilterButton(filter)
    }
    
    func deleteReader(_ reader: Reader) {
        dataManager.deleteReader(reader)
        loadData()
    }
}
