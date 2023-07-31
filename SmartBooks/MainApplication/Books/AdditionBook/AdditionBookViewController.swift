//
//  AdditionBookViewController.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit
import AVFoundation
import Photos

// MARK: - protocol
protocol AdditionBookViewToPresenter {
    func didSelectSaveButton(name: String, author: String, count: String, image: UIImage)
}

final class AdditionBookViewController: UIViewController {
    
    // MARK: - property
    private lazy var presenter: AdditionBookViewToPresenter = {
        AdditionBookPresenter(view: self)
    }()
    
    private var imagePicker: UIImagePickerController?
        
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
        let stackView = UIStackView(arrangedSubviews: [loadView, nameTextField, authorTextField, countTextField, textFieldsStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        authorTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        countTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        textFieldsStackView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        return stackView
    }()
    
    private lazy var loadView: LoadImageView = {
        let loadView = LoadImageView()
        loadView.delegate = self
        
        return loadView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Название")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var authorTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Автор")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var countTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Количество")
        textField.keyboardType = .numberPad
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearTextField, indexTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var yearTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Год")
        textField.keyboardType = .numberPad
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var indexTextField: UITextField = {
        let textField = UITextField()
        textField.setupTextField("Индекс")
        textField.keyboardType = .numberPad
        textField.delegate = self
        
        return textField
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
        setupImagePicker()
        registerForKeyboardNotifications()
    }
    
    // MARK: - private func
    private func commonInit() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = false
        imagePicker?.delegate = self
        imagePicker?.sourceType = .photoLibrary
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - obj-c
    @objc private func tapSaveButton() {
        guard let name = nameTextField.text,
              let author = authorTextField.text,
              let count = countTextField.text,
              let image = loadView.getImage() else { return }
        presenter.didSelectSaveButton(name: name, author: author, count: count, image: image)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var inset = scrollView.contentInset
            inset.bottom = keyboardSize.height
            scrollView.contentInset.bottom = inset.bottom + 8
        }
    }
   
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
    
    // MARK: - deinit
    deinit {
        removeKeyboardNotifications()
    }
    
}

// MARK: - AdditionBookPresenterToView
extension AdditionBookViewController: AdditionBookPresenterToView {
    func backToMainVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - LoadImageViewDelegate
extension AdditionBookViewController: LoadImageViewDelegate {
    func didSelectChooseButton() {
        guard let imagePicker else { return }
        present(imagePicker, animated: true)
    }
    
    func didSelectChangeButton() {
        guard let imagePicker else { return }
        present(imagePicker, animated: true)
    }
    
    func didSelectDeleteButton() {
        loadView.clear()
    }
}

// MARK: UINavigationControllerDelegate
extension AdditionBookViewController: UINavigationControllerDelegate { }

// MARK: UIImagePickerControllerDelegate
extension AdditionBookViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            loadView.configurate(image)
            picker.dismiss(animated: true)
            return
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension AdditionBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: authorTextField.becomeFirstResponder()
        case authorTextField: countTextField.becomeFirstResponder()
        case countTextField: yearTextField.becomeFirstResponder()
        case yearTextField: indexTextField.becomeFirstResponder()
        default: view.endEditing(true)
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.activateTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.inactivateTextField()
    }
}
