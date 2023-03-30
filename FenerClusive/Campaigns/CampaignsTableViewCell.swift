//
//  CampaignsTableViewCell.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import UIKit

class CampaignsTableViewCell: UITableViewCell {
    @IBOutlet weak var campaignView: UIView!
    @IBOutlet weak var timeOutView: UIView!
    @IBOutlet weak var soonOverView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var brandImageContainerView: UIView!
    @IBOutlet weak var brandImageBackgroundView: UIView!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var likeCountContainerView: UIView!
    @IBOutlet weak var brandImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewContainerWidthConstraint: NSLayoutConstraint!
    
    private var shadowLayer = CAShapeLayer()
    
    var likeTapped:(Bool)->() = {like in}
    
    var data:Campaign! {
        didSet {
            guard data != nil else {
                return
            }
            
            updateUI()
        }
    }
    
    private func updateUI() {
        setupImage()
        contentTitleLabel.text = data.spotTitle
        setupDistance()
        updateLikeStatus()
        checkCampaignOverState()
    }
    
    private func updateLikeStatus() {
        likeCount = (data?.likeCount).intValue
        isLiked = (data?.isLiked).falseValue
    }
    
    private var isLiked: Bool = false {
        didSet {
            let image = UIImage(namedInModule: isLiked ? "likedIcon" : "likeIcon")
            likeImageView.image = image
        }
    }
    
    private var likeCount: Int = 0 {
        didSet {
            if likeCount < 0 {
                likeCount = 0
                return
            }
            likeCountLabel.text = likeCount.description.getShortenNumber()
        }
    }
    
    private func setupDistance() {
        guard let data else { return }
        let distance = data.companyDistance.intValue
        distanceView.isHidden = (distance <= 0)
        distanceLabel.text = "\(distance) m"
    }
    
    private func checkCampaignOverState() {
        guard let data else { return }
        
        soonOverView.isHidden = true
        timeOutView.isHidden = true
        
        if data.isTimeOut {
            timeOutView.isHidden = false
        } else {
            soonOverView.isHidden = !data.isSoonOver
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }
            likeCountContainerView.addShadowToView(
                shadowLayer: shadowLayer,
                x: 0,
                y: 8,
                blur: 16,
                spread: -2,
                fillColor: UIColor(red: 0.278, green: 0.392, blue: 0.408, alpha: 1),
                color: .black,
                opacity: 0.4
            )
            likeButton.addShadowToView(
                shadowLayer: shadowLayer,
                x: 0,
                y: 4,
                blur: 8,
                spread: -2,
                fillColor: .white,
                color: .black,
                opacity: 0.4
            )
            brandImageBackgroundView.addShadowToView(
                shadowLayer: shadowLayer,
                x: 0,
                y: 8,
                blur: 16,
                spread: -4,
                // Give background color
                fillColor: .white,
                color: .black,
                opacity: 0.5
            )
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        campaignView.layer.cornerRadius = 5
        likeView.backgroundColor = UIColor.clear
        likeCountContainerView.layer.cornerRadius = likeCountContainerView.frame.width / 6.4
        likeCountContainerView.addShadowToView(
            shadowLayer: shadowLayer,
            x: 0,
            y: 8,
            blur: 16,
            spread: -4,
            fillColor: UIColor(red: 0.278, green: 0.392, blue: 0.408, alpha: 1),
            color: .black,
            opacity: 0.3
        )
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeButton.addShadowToView(
            shadowLayer: shadowLayer,
            x: 0,
            y: 8,
            blur: 16,
            spread: -4,
            fillColor: .white,
            color: .black,
            opacity: 0.3
        )
        likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
    }
    
    @objc func likeButtonAction() {
        likeTapped(!isLiked)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupImage() {
        brandImageContainerView.isHidden = true
        brandImageBackgroundView.isHidden = true
        brandImageView.image = nil
        brandImageView.backgroundColor = .white
        
        if let url = URL(string: data.image) {
            contentImageView.kf.setImage(with: url) { result in
                if self.contentImageView.image == nil {
                    DispatchQueue.main.async {
                        self.contentImageView.image = UIImage(namedInModule: "no_image")
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                self.contentImageView.image = UIImage(namedInModule: "no_image")
            }
        }
        
        if let url = URL(string: data.companyLogo) {
            brandImageView.kf.setImage(with: url) { result in
                DispatchQueue.main.async {
                    guard let image = self.brandImageView.image else {
                        self.brandImageContainerView.isHidden = true
                        self.brandImageBackgroundView.isHidden = true
                        return
                    }
                    var imageRatio = image.size.width / image.size.height
                    if imageRatio < 1 {
                        imageRatio = 1
                    }
                    let constant = imageRatio * 34
                    self.brandImageViewWidthConstraint.constant = constant
                    self.brandImageViewContainerWidthConstraint.constant = constant + 6
                    self.brandImageView.layoutIfNeeded()
                    self.brandImageContainerView.layoutIfNeeded()
                    
                    self.updateCornerRadius()
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }else {
            DispatchQueue.main.async {
                self.brandImageContainerView.isHidden = true
            }
        }
    }
    
    @IBAction func inspectTapped(_ sender: UIButton) {
        print("Hemen İncele")
    }
    
    
    private func updateCornerRadius() {
        brandImageBackgroundView.isHidden = false
        brandImageContainerView.isHidden = false
        brandImageContainerView.backgroundColor = UIColor.white
        brandImageView.backgroundColor = .clear
        
        guard brandImageView.image != nil else {
            brandImageContainerView.isHidden = true
            brandImageBackgroundView.isHidden = true
            return
        }
        brandImageBackgroundView.layer.cornerRadius = 20
        brandImageBackgroundView.layer.masksToBounds = false
        brandImageBackgroundView.addShadowToView(
            shadowLayer: shadowLayer,
            x: 0,
            y: 8,
            blur: 16,
            spread: -4,
            // Give background color
            fillColor: .white,
            color: .black,
            opacity: 0.5
        )
    }
}
