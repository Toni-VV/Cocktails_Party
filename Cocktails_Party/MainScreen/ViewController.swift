//
//  ViewController.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol!
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLAyout = CustomFlowLayot()
        collectionViewFlowLAyout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFlowLAyout.minimumInteritemSpacing = 8
        collectionViewFlowLAyout.minimumLineSpacing = 8
        collectionViewFlowLAyout.sectionInset = UIEdgeInsets(top: 20,
                                                             left: 20,
                                                             bottom: 20,
                                                             right: 20)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewFlowLAyout)
        collectionView.register(CustomCell.self,
                                forCellWithReuseIdentifier: CustomCell.identifier)
        return collectionView
        
    }()
    
    private let cocktailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cocktail name"
        textField.font = .systemFont(ofSize: 15)
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.shadowRadius = 2
        textField.layer.cornerRadius = 10
        textField.layer.shadowColor = UIColor.gray.cgColor
        return textField
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupCollectionView()
        presenter.fetchCocktails()
        addObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - Override Methods
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }

}

//MARK: - Private Functions

private extension ViewController {
    
    //MARK: - Setup
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        let height = view.bounds.height / 1.8
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(view.safeAreaInsets.top)
            $0.height.equalTo(height)
        }
        
    }
    
    func setupTextField() {
        view.addSubview(cocktailTextField)
        cocktailTextField.delegate = self
        
        cocktailTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Observers
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc  func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            cocktailTextField.snp.remakeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardRectangle.height)
                $0.height.equalTo(30)
            }
            cocktailTextField.layer.cornerRadius = 0
            view.layoutIfNeeded()
        }
    }
    
    @objc  func keyboardWillHide() {
        cocktailTextField.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(30)
        }
        cocktailTextField.layer.cornerRadius = 10
        view.layoutIfNeeded()
    }
    
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.cocktails.isEmpty ? 0: presenter.cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomCell.identifier,
                for: indexPath
            ) as? CustomCell
        else { return UICollectionViewCell() }
        
        let cocktail = presenter.cocktails[indexPath.row]
        cell.configure(with: cocktail)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        var cocktail = presenter.cocktails[indexPath.row]
        cocktail.isSelected.toggle()
    }
    
}

// MARK: - ViewInputProtocol

extension ViewController: ViewInputProtocol {
    
    func showAlert(message: String) {
        showAlert(with: message)
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
}

// MARK: - TextFiled Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let textFieldText = textField.text ?? ""
        let text = textFieldText.replacingCharacters(in: Range(range,
                                                               in: textFieldText)!,
                                                     with: string).lowercased()
        for (index, cocktail) in presenter.cocktails.enumerated() {
            let cocktailName = cocktail.name.lowercased()
            let indexPath = IndexPath(row: index, section: 0)
            if cocktailName.contains(text) {
                collectionView.selectItem(at: indexPath,
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
        return true
    }
    
}
