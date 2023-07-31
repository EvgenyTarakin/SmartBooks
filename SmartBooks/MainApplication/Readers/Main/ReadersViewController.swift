//
//  ReadersViewController.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 28.07.2023.
//

import UIKit
import SnapKit
import SwipeCellKit

// MARK: - protocol
protocol ReadersViewToPresenter {
    init(view: ReadersPresenterToView)
    func didSelectMenuFilterButton()
    func didSelectTapOnView()
    func didSelectFilterButton(_ type: TypeFilter)
    func loadData(_ filter: TypeFilter)
    func deleteReader(_ reader: Reader, filter: TypeFilter)
}

final class ReadersViewController: UIViewController {
    
    // MARK: - property
    private var presenter: ReadersViewToPresenter {
        return ReadersPresenter(view: self)
    }
    
    private var data: [Reader] = []
    private var filter: TypeFilter = .overdueBooks
        
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(hex: "E9EEF3")
        
        return backView
    }()
    
    private lazy var mainFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cначала просроченные книги", for: .normal)
        button.setTitleColor(UIColor(hex: "3888FF"), for: .normal)
        button.titleLabel?.font = Font.semiBold.size(14)
        button.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrowDown")
        
        return imageView
    }()
    
    private lazy var filterMenuView: UIView = {
        let menu = UIView()
        menu.backgroundColor = UIColor(hex: "1E1E21", alpha: 0.75)
        menu.layer.cornerRadius = 13
        menu.isHidden = true
        
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "C6C6C9", alpha: 0.35)
        menu.addSubview(separator)
        menu.addSubview(firstFilterMenuButton)
        menu.addSubview(secondFilterMenuButton)
        
        separator.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        firstFilterMenuButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(separator.snp.top)
        }
        secondFilterMenuButton.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
        return menu
    }()
    
    private lazy var firstFilterMenuButton: FilterMenuButton = {
        let button = FilterMenuButton(frame: .zero, type: .alphabet)
        button.configurate(false)
        button.delegate = self
        
        return button
    }()
    
    private lazy var secondFilterMenuButton: FilterMenuButton = {
        let button = FilterMenuButton(frame: .zero, type: .overdueBooks)
        button.configurate(true)
        button.delegate = self
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ReaderInfoCell.self, forCellReuseIdentifier: ReaderInfoCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadData(filter)
    }
    
    // MARK: - override func
    override func tapOnView() {
        presenter.didSelectTapOnView()
    }
    
    // MARK: - private func
    private func commonInit() {
        view.addSubview(backView)
        view.addSubview(mainFilterButton)
        view.addSubview(filterImageView)
        view.addSubview(tableView)
        view.addSubview(filterMenuView)
        
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        mainFilterButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.left.equalToSuperview().inset(8)
            $0.height.equalTo(54)
        }
        filterImageView.snp.makeConstraints {
            $0.centerY.equalTo(mainFilterButton.snp.centerY)
            $0.left.equalTo(mainFilterButton.snp.right)
            $0.height.width.equalTo(18)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainFilterButton.snp.bottom)
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        filterMenuView.snp.makeConstraints {
            $0.top.equalTo(mainFilterButton.snp.bottom).inset(8)
            $0.left.equalToSuperview().inset(8)
            $0.height.equalTo(100)
            $0.width.equalTo(270)
        }
    }
    
    // MARK: - obj-c
    @objc private func tapFilterButton() {
        presenter.didSelectMenuFilterButton()
    }

}

// MARK: - UITableViewDelegate
extension ReadersViewController: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension ReadersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReaderInfoCell.reuseIdentifier, for: indexPath) as? ReaderInfoCell
        else { return UITableViewCell() }
        if let name = data[indexPath.row].name,
           let date = data[indexPath.row].date {
            
            var typeInfo: InfoBook = .overdue
            if data[indexPath.row].info == 1 {
                typeInfo = .take
            } else if data[indexPath.row].info == 2 {
                typeInfo = .missing
            }
            cell.configurate(typeInfo, name: name, date: date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
            self.presenter.deleteReader(self.data[indexPath.row], filter: self.filter)
        }
        deleteItem.backgroundColor = UIColor(hex: "E9EEF3")
        deleteItem.image = UIImage(named: "trash")
        
        let editItem = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in }
        editItem.backgroundColor = UIColor(hex: "E9EEF3")
        editItem.image = UIImage(named: "edit")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        swipeActions.performsFirstActionWithFullSwipe = false

        return swipeActions
    }}

// MARK: - ReadersPresenterToView
extension ReadersViewController: ReadersPresenterToView {
    func showFilterMenu() {
        filterMenuView.isHidden = false
    }
    
    func hideFilterMenu() {
        UIView.animate(withDuration: 0.3) {
            self.filterMenuView.alpha = 0
        } completion: { _ in
            self.filterMenuView.alpha = 1
            self.filterMenuView.isHidden = true
        }
        view.endEditing(true)
    }
    
    func updateFilterMenu(_ type: TypeFilter) {
        filter = type
        switch type {
        case .alphabet:
            mainFilterButton.setTitle("По алфавиту", for: .normal)
            firstFilterMenuButton.configurate(true)
            secondFilterMenuButton.configurate(false)
        case .overdueBooks:
            mainFilterButton.setTitle("Cначала просроченные книги", for: .normal)
            firstFilterMenuButton.configurate(false)
            secondFilterMenuButton.configurate(true)
        }
        tapOnView()
    }
    
    func fetchData(_ data: [Reader]) {
        self.data = data
        tableView.reloadData()
    }
}

// MARK: - FilterMenuButtonDelegate
extension ReadersViewController: FilterMenuButtonDelegate {
    func didSelectButton(_ type: TypeFilter) {
        presenter.didSelectFilterButton(type)
    }
}
