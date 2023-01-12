//
//  DetailGameViewController.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import UIKit
import Combine
import Common


public class DetailGameViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageError: UIImageView!
    
    public var game:Game? = nil
    private var cancellables: Set<AnyCancellable> = []
    public var viewModel: DetailGameViewModel!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Detail Game"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        
        let image = UIImage(named: "heart", in: Bundle(identifier: "org.cocoapods.Common"), with: nil)?.withRenderingMode(.alwaysTemplate)
        favoriteButton.backgroundColor = .blue
        favoriteButton.layer.cornerRadius = 23
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.addTarget(self, action: #selector(setFavoriteGame), for: .touchUpInside)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

        showError(message: "", isVisible: false)
        
        if let result = game{
            gameImageView.contentMode = .scaleToFill
            gameImageView.kf.setImage(with: URL(string:result.backgroundImage), options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
            titleLabel.text = result.name
            releaseLabel.text = result.released

            
            showLoading(isLoading: true)
            viewModel.getDetailGame(id: String(result.id)).receive(on: RunLoop.main).sink(receiveCompletion: {completion in
                switch completion{
                case .failure:
                    self.showError(message: String(describing: completion), isVisible: true)
                case .finished:
                    self.showLoading(isLoading: false)
                }
            }, receiveValue:{game in
                self.game = game
                self.descriptionLabel.text = game.description?.htmlToString
                self.setFavoriteButton(game: game)
            }).store(in: &cancellables)
        }
    }
    
    private func showLoading(isLoading:Bool){
        self.titleLabel.isHidden = isLoading
        self.releaseLabel.isHidden = isLoading
        self.descriptionLabel.isHidden = isLoading
        self.indicatorLoading.isHidden = !isLoading
        self.favoriteButton.isHidden = isLoading
        if(isLoading){
            self.indicatorLoading.startAnimating()
        }else{
            self.indicatorLoading.stopAnimating()
        }
    }
    
    private func showError(message:String, isVisible:Bool){
        self.imageError.isHidden = !isVisible
        self.errorLabel.isHidden = !isVisible
        self.errorLabel.text = message
    }
    
    @objc func setFavoriteGame(){
        if let result = game{
            let isFavorited:Bool = {if result.isFavorited{ return false } else { return true }}()
            let newGame = Game(id: result.id, name: result.name, released: result.released, backgroundImage: result.backgroundImage, rating: result.rating, ratingCount: result.ratingCount, description: result.description, isFavorited: isFavorited)
            viewModel.setFavorite(game: newGame).receive(on: RunLoop.main).sink(receiveCompletion: {completion in }, receiveValue: {game in
                self.game = game
                self.setFavoriteButton(game: game)
            }).store(in: &cancellables)
        }
    }
    
    private func setFavoriteButton(game:Game){
        if(game.isFavorited){
            self.favoriteButton.tintColor = .red
        }else{
            self.favoriteButton.tintColor = .white
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

}
