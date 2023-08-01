//
//  BookCell.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 31.07.2023.
//

import UIKit
import SnapKit

final class BookCell: UICollectionViewCell {
    
    // MARK: - property
    static let reuseIdentifier = String(describing: BookCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameBookLabel,
                                                       authorBookLabel, countBookLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(frame.height / 1.5)
        }
        nameBookLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(20)
        }
        authorBookLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(20)
        }
        countBookLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var nameBookLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "181A2B")
        label.font = Font.bold.size(16)
        label.text = "cbveqiurvicqeiviepqifver"
        
        return label
    }()
    
    private lazy var authorBookLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "181A2B")
        label.font = Font.medium.size(13)
        label.text = "cbveqiurvicqeiviepqifver"
        
        return label
    }()
    
    private lazy var countBookLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(hex: "181A2B")
        label.font = Font.bold.size(20)
        label.text = "cbveqiurv"
        
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - override func
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameBookLabel.text = nil
        authorBookLabel.text = nil
        countBookLabel.text = nil
    }
    
    // MARK: - func
    func configurate(name: String, author: String, count: Int64, image: UIImage) {
        nameBookLabel.text = name
        authorBookLabel.text = author
        countBookLabel.text = "\(count) шт/ из \(count) шт"
        imageView.image = image
    }
    
    // MARK: - private func
    private func commonInit() {
        backgroundColor = .clear
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

}
