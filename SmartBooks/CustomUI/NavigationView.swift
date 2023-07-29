//
//  NavigationView.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

// MARK: - TypeNavigationView
enum TypeNavigationView {
    case mainReaders
    case secondaryReaders
    case mainBooks
    case secondaryBooks
}

// MARK: - protocol
protocol NavigationViewDelegate: AnyObject {
    func didSelectBackButton()
    func didSelectAdditionButton(_ type: TypeNavigationView)
    func changeSearchTextField(_ textField: UITextField)
}

final class NavigationView: UIView {

    // MARK: - property
    weak var delegate: NavigationViewDelegate?
    private var type: TypeNavigationView?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backView, titleStackView, searchTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        backView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        titleStackView.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        return stackView
    }()
    
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .clear
        
        let backButton = UIButton()
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        backView.addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalTo(backButton.snp.height)
        }
        
        return backView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, additionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        additionButton.snp.makeConstraints {
            $0.width.equalTo(104)
        }
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.extraBold.size(28)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var additionButton: AdditionButton = {
        let button = AdditionButton()
        button.delegate = self
        
        return button
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.delegate = self
        
        return textField
    }()
    
    // MARK: - init
    init(frame: CGRect, type: TypeNavigationView) {
        super.init(frame: frame)
        self.type = type
        commonInit()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - private func
    private func commonInit() {
        backgroundColor = .white
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupUI() {
        guard let type else { return }
        switch type {
        case .mainReaders:
            backView.isHidden = true
            titleLabel.text = "Читатели"
            additionButton.isHidden = false
            searchTextField.isHidden = false
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск по ФИО",
                                                                       attributes: [NSAttributedString.Key.font : Font.medium.size(15),
                                                                                    NSAttributedString.Key.foregroundColor : UIColor(hex: "1B1F3B", alpha: 0.65)])
        case .secondaryReaders:
            backView.isHidden = false
            titleLabel.text = "Добавить читателя"
            additionButton.isHidden = true
            searchTextField.isHidden = true
        case .mainBooks:
            backView.isHidden = true
            titleLabel.text = "Книги"
            additionButton.isHidden = false
            searchTextField.isHidden = false
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск по названию",
                                                                       attributes: [NSAttributedString.Key.font : Font.medium.size(15),
                                                                                    NSAttributedString.Key.foregroundColor : UIColor(hex: "1B1F3B", alpha: 0.65)])
        case .secondaryBooks:
            backView.isHidden = false
            titleLabel.text = "Добавить книгу"
            additionButton.isHidden = true
            searchTextField.isHidden = true
        }
    }
    
    // MARK: - obj-c
    @objc private func tapBackButton() {
        delegate?.didSelectBackButton()
    }
    
}

// MARK: - AdditionButtonDelegate
extension NavigationView: AdditionButtonDelegate {
    func didSelectButton() {
        guard let type else { return }
        delegate?.didSelectAdditionButton(type)
    }
}

// MARK: - AdditionButtonDelegate
extension NavigationView: UISearchTextFieldDelegate {

}
