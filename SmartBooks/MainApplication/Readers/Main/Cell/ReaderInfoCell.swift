//
//  ReaderInfoCell.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 30.07.2023.
//

import UIKit
import SnapKit

// MARK: - InfoBook
enum InfoBook {
    case overdue
    case take
    case missing
}

final class ReaderInfoCell: UITableViewCell {
    
    // MARK: - property
    static let reuseIdentifier = String(describing: ReaderInfoCell.self)
    
    private var info: InfoBook?
    
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 12
        
        backView.addSubview(arrayImageView)
        backView.addSubview(nameLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(infoView)
        
        arrayImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.right.equalToSuperview().inset(12)
            $0.height.equalTo(14)
            $0.width.equalTo(8)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(12)
            $0.right.equalTo(arrayImageView).inset(12)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).inset(-4)
            $0.left.equalToSuperview().inset(12)
            $0.right.equalTo(arrayImageView).inset(12)
        }
        infoView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-12)
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        return backView
    }()
    
    private lazy var arrayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrayRight")
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.layer.cornerRadius = 12
        infoView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
        
        return infoView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium.size(14)
        
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - override func
    override func prepareForReuse() {
        super.prepareForReuse()
        arrayImageView.isHidden = true
        nameLabel.text = nil
        dateLabel.text = nil
        infoView.isHidden = true
    }
    
    // MARK: - func
    func configurate(_ info: InfoBook, name: String, date: String) {
        switch info {
        case .overdue:
            infoView.backgroundColor = UIColor(hex: "FFE8E8")
            infoLabel.textColor = UIColor(hex: "D10000", alpha: 0.9)
            infoLabel.text = "Просроченные книги"
        case .take:
            infoView.backgroundColor = UIColor(hex: "FFF0D2")
            infoLabel.textColor = UIColor(hex: "D14B00", alpha: 0.9)
            infoLabel.text = "Взял книгу"
        case .missing:
            infoView.backgroundColor = UIColor(hex: "C7F9D5")
            infoLabel.textColor = UIColor(hex: "00862E", alpha: 0.9)
            infoLabel.text = "Нет книг"
        }
        arrayImageView.isHidden = false
        nameLabel.text = name
        dateLabel.text = date
        infoView.isHidden = false
    }
    
    // MARK: - private func
    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(backView)
        
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.left.right.equalToSuperview().inset(8)
        }
    }

}
