//
//  MainTabBarController.swift
//
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - property
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "B8B8C1", alpha: 0.35)
        
        return separator
    }()

//    MARK: -lifecycle TabBarController
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        generateTabBar()
    }
    
//    MARK: -private func
    private func commonInit() {
        tabBar.backgroundColor = UIColor(hex: "F9F9F9")
        
        tabBar.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    private func generateTabBar() {
        let readersViewController = ReadersViewController()
        let booksViewController = BooksViewController()
        viewControllers = [
            generateViewController(readersViewController,
                                   typeNavigationView: .mainReaders,
                                   title: "Читатели",
                                   image: UIImage(named: "unselectedUsers"),
                                   selectedImage: UIImage(named: "selectedUsers")),
            generateViewController(booksViewController,
                                   typeNavigationView: .mainBooks,
                                   title: "Книги",
                                   image: UIImage(named: "unselectedBook"),
                                   selectedImage: UIImage(named: "selectedBook"))
        ]
    }
    
    private func generateViewController(_ viewController: UIViewController,
                                        typeNavigationView: TypeNavigationView,
                                        title: String,
                                        image: UIImage?,
                                        selectedImage: UIImage?) -> UINavigationController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : Font.semiBold.size(11)], for: .normal)
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        viewController.setupDefaultSettings(typeNavigationView)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        return navigationController
    }
    
}
