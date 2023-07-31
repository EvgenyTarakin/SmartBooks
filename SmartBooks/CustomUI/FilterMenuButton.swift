//
//  FilterMenuButton.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 30.07.2023.
//

import UIKit
import SnapKit

// MARK: TypeFilter
enum TypeFilter {
    case alphabet
    case overdueBooks
    
    var text: String {
        switch self {
        case .alphabet: return "По алфавиту"
        case .overdueBooks: return "Сначала просроченные книги"
        }
    }
}

// MARK: - protocol
protocol FilterMenuButtonDelegate: AnyObject {
    func didSelectButton(_ type: TypeFilter)
}

final class FilterMenuButton: UIView {

    // MARK: - property
    weak var delegate: FilterMenuButtonDelegate?
    
    private var type: TypeFilter?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selected")
        
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.medium.size(15)
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - init
    init(frame: CGRect, type: TypeFilter) {
        super.init(frame: frame)
        self.type = type
        label.text = type.text
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - func
    func configurate(_ isSelected: Bool) {
        imageView.isHidden = !isSelected
    }
    
    // MARK: - private func
    private func commonInit() {
        addSubview(label)
        addSubview(imageView)
        addSubview(button)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(36)
            $0.right.equalToSuperview().inset(16)
        }
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(label.snp.left).inset(-4)
            $0.height.width.equalTo(24)
        }
        button.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    // MARK: - obj-c
    @objc private func tapButton() {
        guard let type else { return }
        delegate?.didSelectButton(type)
    }

}
