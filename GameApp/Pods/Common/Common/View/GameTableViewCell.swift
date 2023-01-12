//
//  GameTableViewCell.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 04/01/23.
//

import UIKit
import Kingfisher

public class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    public func setCellWithValuesOf(_ game: Game) {
        setupUI(game.name, game.backgroundImage, game.released, game.rating)
    }
    
    private func setupUI(_ name: String, _ backgroundImage: String, _ releaseDate: String, _ rating: Double) {
        self.gameLabel.text = name
        
        let processor = DownsamplingImageProcessor(size: self.gameImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 8)
        
        self.gameImageView.contentMode = .scaleToFill
        self.gameImageView.kf.indicatorType = .activity
        self.gameImageView.kf.setImage(with: URL(string:backgroundImage), options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
        self.ratingLabel.text = String(rating)
        self.releaseLabel.text = releaseDate
    }
    
}
