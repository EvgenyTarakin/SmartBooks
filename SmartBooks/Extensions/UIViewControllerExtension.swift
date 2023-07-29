//
//  UIViewControllerExtension.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit

// MARK: - UIViewController
extension UIViewController {
    func setupDefaultSettings(_ type: TypeNavigationView) {
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        
        let navigationView = NavigationView(frame: .zero, type: type)
        navigationView.delegate = self
        
        view.addSubview(navigationView)
        view.addGestureRecognizer(tap)
        
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func tapOnView() {
        view.endEditing(true)
    }
}

// MARK: - NavigationViewDelegate
extension UIViewController: NavigationViewDelegate {
    func didSelectBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectAdditionButton(_ type: TypeNavigationView) {
        switch type {
        case .mainReaders:
            let controller = AdditionReaderViewController()
            controller.setupDefaultSettings(.secondaryReaders)
            navigationController?.pushViewController(controller, animated: true)
        case .mainBooks:
            let controller = AdditionBookViewController()
            controller.setupDefaultSettings(.secondaryBooks)
            navigationController?.pushViewController(controller, animated: true)
        case .secondaryReaders, .secondaryBooks: break
        }
    }
    
    func changeSearchTextField(_ text: String) {
        
    }
}
