//
//  ServerListItemView.swift
//  AppCore
//

import Foundation
import UIKit

public class ServerListItemView: UIView, Loadable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lockedIcon: UIImageView!
    @IBOutlet weak var premiumIcon: UIImageView!
    @IBOutlet weak var checkmarkIcon: UIImageView!
    
    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }
    
    private func setupViews() {
        titleLabel.font = Font.init(type: .regular, size: .normal).font
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.font = Font.init(type: .regular, size: .small).font
        
        topContentView.layer.borderWidth = 1.0
        topContentView.layer.borderColor = Color.disabled.color.withAlphaComponent(0.3).cgColor
        topContentView.layer.cornerRadius = 26
        
        containerView.layer.cornerRadius = 26
        
        flagImageView.contentMode = .scaleAspectFill
        flagImageView.layer.masksToBounds = true
        flagImageView.layer.cornerRadius = 16
        flagImageView.layer.borderWidth = 0.5
        flagImageView.layer.borderColor = Color.disabled.color.cgColor
        flagImageView.image = R.image.imgLogo()
    }
    
    func configure(data: VPNProfileModel?) {
        guard let data = data else {
            lockedIcon.isHidden = true
            premiumIcon.isHidden = true
            checkmarkIcon.isHidden = true
            descriptionStack.isHidden = true
            titleLabel.text = Localizable.mainConnectionStatusNoserver()
            return
        }
        
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        descriptionStack.isHidden = data.description == nil
        lockedIcon.isHidden = !data.isLocked
        premiumIcon.isHidden = !data.isLocked
        checkmarkIcon.isHidden = !data.isActive
        descriptionLabel.textColor = data.isLocked ? Color.disabled.color : Color.secondaryText.color
        
        if let string = data.flagImageUrl, let url = URL(string: string) {
            flagImageView.downloaded(from: url, greyscale: data.isLocked)
        } else {
            flagImageView.image = R.image.imgLogo()
        }
    }
}
