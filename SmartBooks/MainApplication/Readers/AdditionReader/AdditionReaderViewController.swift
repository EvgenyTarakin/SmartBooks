//
//  AdditionReaderViewController.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

// MARK: - protocol
protocol AdditionReaderViewToPresenter {
    init(view: AdditionReaderPresenterToView)
    func didChangeDate(_ date: String?)
    func didSelectSaveButton(nameText: String?, dateText: String?)
}

final class AdditionReaderViewController: UIViewController {
    
    // MARK: - property
    private var presenter: AdditionReaderViewToPresenter {
        return AdditionReaderPresenter(view: self)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "E9EEF3")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(mainStackView)
        contentView.addSubview(saveButton)
        
        mainStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).inset(-24)
            $0.bottom.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        return contentView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameStackView, dateStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        
        return stackView
    }()
    
    // MARK: name
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, nameErrorLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        nameErrorLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("ФИО читателя")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var nameErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите ФИО читателя"
        label.textColor = UIColor(hex: "FF3236")
        label.font = Font.medium.size(13)
        label.isHidden = true
        
        return label
    }()
    
    // MARK: date
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateTextField, dateErrorLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        dateTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        dateErrorLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        return stackView
    }()
    
    private let datePicker = UIDatePicker()

    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Дата рождения")
        textField.delegate = self
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        textField.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([leftSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolBar


        return textField
    }()
    
    private lazy var dateErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите дату рождения читателя"
        label.textColor = UIColor(hex: "FF3236")
        label.font = Font.medium.size(13)
        label.isHidden = true
        
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Font.semiBold.size(15)
        button.backgroundColor = UIColor(hex: "3888FF")
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        
        return button
    }()

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    // MARK: - private func
    private func commonInit() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - obj-c
    @objc private func tapSaveButton() {
        presenter.didSelectSaveButton(nameText: nameTextField.text, dateText: dateTextField.text)
    }
    
    @objc private func doneAction() {
        view.endEditing(true)
    }
    
    @objc private func changeDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        presenter.didChangeDate(dateTextField.text)
    }
    
}

// MARK: - AdditionReaderPresenterToView
extension AdditionReaderViewController: AdditionReaderPresenterToView {
    func backToMainVC() {
        nameTextField.layer.borderColor = UIColor(hex: "E3E3EB").cgColor
        nameErrorLabel.isHidden = true
        dateTextField.layer.borderColor = UIColor(hex: "E3E3EB").cgColor
        dateErrorLabel.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    func showErrorValidation(_ error: ErrorValidation) {
        switch error {
        case .name:
            nameTextField.layer.borderColor = UIColor(hex: "FF3236").cgColor
            nameErrorLabel.isHidden = false
            dateTextField.layer.borderColor = UIColor(hex: "E3E3EB").cgColor
            dateErrorLabel.isHidden = true
        case .date:
            nameTextField.layer.borderColor = UIColor(hex: "E3E3EB").cgColor
            nameErrorLabel.isHidden = true
            dateTextField.layer.borderColor = UIColor(hex: "FF3236").cgColor
            dateErrorLabel.isHidden = false
        case .all:
            nameTextField.layer.borderColor = UIColor(hex: "FF3236").cgColor
            nameErrorLabel.isHidden = false
            dateTextField.layer.borderColor = UIColor(hex: "FF3236").cgColor
            dateErrorLabel.isHidden = false
        }
        view.endEditing(true)
    }
}

extension AdditionReaderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            dateStackView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return false
    }
}
