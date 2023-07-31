//
//  LoadImageView.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 31.07.2023.
//

import UIKit
import SnapKit

// MARK: - protocol
protocol LoadImageViewDelegate: AnyObject {
    func didSelectChooseButton()
    func didSelectChangeButton()
    func didSelectDeleteButton()
}

final class LoadImageView: UIView {

    // MARK: - property
    weak var delegate: LoadImageViewDelegate?
    
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loadImageView")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(tapChooseButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backSelectImageView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 12
        backView.addSubview(selectImageView)
        backView.addSubview(stackView)
        
        selectImageView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview().inset(16)
            $0.width.equalTo(70)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.left.equalTo(selectImageView.snp.right).inset(-16)
            $0.right.equalToSuperview().inset(32)
        }
        
        return backView
    }()
    
    private lazy var selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, weightLabel, buttonsStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        buttonsStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium.size(15)
        label.textColor = UIColor(hex: "1D1D1D")
        label.text = "cover.jpg"
        
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium.size(15)
        label.textColor = UIColor(hex: "58606C")
        label.text = "\(Int.random(in: 0...5)) Мб"
        
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeButton, deleteButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Font.semiBold.size(15)
        button.backgroundColor = UIColor(hex: "3888FF")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapChangeButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor(hex: "3888FF"), for: .normal)
        button.titleLabel?.font = Font.semiBold.size(15)
        button.backgroundColor = UIColor(hex: "EEEEEE")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        
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
    
    // MARK: - func
    func configurate(_ image: UIImage) {
        backImageView.removeFromSuperview()
        chooseButton.removeFromSuperview()
        selectImageView.image = image
        addSubview(backSelectImageView)
        
        backSelectImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func clear() {
        backSelectImageView.removeFromSuperview()
        commonInit()
    }
    
    func getImage() -> UIImage? {
        return selectImageView.image
    }
    
    // MARK: - private func
    private func commonInit() {
        addSubview(backImageView)
        addSubview(chooseButton)
        
        backImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        chooseButton.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
     // MARK: - obj-c
    @objc private func tapChooseButton() {
        delegate?.didSelectChooseButton()
    }
    
    @objc private func tapChangeButton() {
        delegate?.didSelectChangeButton()
    }
    
    @objc private func tapDeleteButton() {
        delegate?.didSelectDeleteButton()
    }
    
}
