//
//  InfoCollectionViewCell.swift
//  WeatherBit
//
//  Created by Mohamad Eslami on 2/17/1400 AP.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func generateCell(weatherInfo : WeatherInfo){
        infoLabel.text = weatherInfo.infoText
        infoLabel.adjustsFontSizeToFitWidth = true
        
        if weatherInfo.image != nil {
            nameLabel.isHidden = true
            infoImageView.isHidden = false
            infoImageView.image = weatherInfo.image
        } else {
            infoImageView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = weatherInfo.nameText
            nameLabel.adjustsFontSizeToFitWidth = true

        }
    }

}
