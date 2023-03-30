//
//  CampaignCategoryCollectionViewCell.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import UIKit

class CampaignCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var data:CampaignCategory! {
        didSet {
            guard let data else {
                return
            }
            
            textLabel.text = data.name
            iconImageView.image = getImage(id: data.id)
            isCurrent = data.isChecked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: 0.863, green: 0.957, blue: 0.969, alpha: 1.0).cgColor
        layer.shadowRadius = 16
        
    }
    
    func setupConstraints() {
        if #available(iOS 12, *) {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
            let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
            let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
            let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                layer.shadowColor = UIColor(red: 0.863, green: 0.957, blue: 0.969, alpha: 1.0).cgColor
            }
        }
    }
    
    var isCurrent: Bool = false {
        didSet {
            changeUI()
        }
    }
    let baseForegroundDefaultText = UIColor(red: 0.275, green: 0.306, blue: 0.310, alpha: 1)
    let baseColorPrimary = UIColor(red: 0.098, green: 0.702, blue: 0.796, alpha: 1)
    
    func changeUI() {
        textLabel.textColor = isCurrent ? .white : baseForegroundDefaultText
        backgroundColor = isCurrent ? baseColorPrimary : .white
        iconImageView.tintColor = isCurrent ? .white : baseForegroundDefaultText
    }
    
    private func getImage(id:Int) -> UIImage?{
        return UIImage(namedInModule: getImageName(id: id))
    }
    
    private func getImageName(id:Int) -> String {
        switch(id) {
        case 1:
            return "star"
        case 2:
            return "food"
        case 3:
            return "pot"
        case 4:
            return "clothes"
        case 5:
            return "online_shopping"
        case 6:
            return "automotive"
        case 7:
            return "food_drink"
        case 8:
            return "art"
        case 9:
            return "trip"
        case 10:
            return "lifestyle"
        case 11:
            return "education"
        case 12:
            return "support"
        case 13:
            return "privilege"
        default:
            return "star"
        }
    }
}
