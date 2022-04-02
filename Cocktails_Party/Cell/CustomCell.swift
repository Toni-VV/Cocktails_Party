//
//  CustomCell.swift
//  Cocktails_Party
//
//  Created by Антон Волков on 02.04.2022.
//

import UIKit
import SnapKit

final class CustomCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CustomCell"

     let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.purple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return gradient
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }

    override var isSelected: Bool {
        didSet {
            isSelected ? addGradient() : removeGradient()
        }
    }
    
    func configure(with model: Cocktail) {
        isSelected =  model.isSelected
        nameLabel.text = model.name
        
    }

}

// MARK: - Private Functions

private extension CustomCell {
    
     func addGradient() {
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = 10
    }
    
     func removeGradient() {
        gradientLayer.removeFromSuperlayer()
    }
    
     func setupCell() {
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 10
        contentView.addSubview(nameLabel)
         
         nameLabel.snp.makeConstraints {
             $0.right.left.equalToSuperview().inset(8)
             $0.centerY.equalToSuperview()
         }
     
    }
    
}
