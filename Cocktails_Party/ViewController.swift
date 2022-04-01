//
//  ViewController.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 31.03.2022.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    var presenter: PresenterProtocol!
    
    private let cocktailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Cocktail name"
        textField.font = .systemFont(ofSize: 15)
        textField.textAlignment = .center
        textField.backgroundColor = .blue
        textField.returnKeyType = .done
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.shadowOpacity = 2
        textField.layer.shadowRadius = 2
        textField.layer.cornerRadius = 8
        textField.layer.shadowOffset = CGSize(width: 1, height: 2)
        textField.layer.shadowColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let collectionView: UICollectionView = {
        let layout = CustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CustomCell.self,
                                forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupCollectionView()
        presenter.fetchCocktails()
    }
    
    
    
}

//MARK: - Private Functions

private extension ViewController {
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(60)
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.cocktails.isEmpty ? 0: presenter.cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var item = presenter.cocktails[indexPath.row]
        item.isSelected.toggle()
        collectionView.reloadItems(at: [indexPath])
        
    }
}

extension ViewController: ViewInputProtocol {
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
        
        guard let textFieldText = textField.text, !textFieldText.isEmpty else {
            return false
        }
        
        let text = textFieldText.replacingCharacters(in: Range(range, in: textFieldText)!,
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


