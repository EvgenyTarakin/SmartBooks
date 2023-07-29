//
//  AdditionButton.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

// MARK: - protocol
protocol AdditionButtonDelegate: AnyObject {
    func didSelectButton()
}

final class AdditionButton: UIView {

    // MARK: - property
    weak var delegate: AdditionButtonDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addition")
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить"
        label.textColor = UIColor(hex: "3888FF")
        label.font = Font.semiBold.size(15)
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - private func
    private func commonInit() {
        addSubview(stackView)
        addSubview(button)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    // MARK: - obj-c
    @objc private func tapButton() {
        delegate?.didSelectButton()
    }

}
