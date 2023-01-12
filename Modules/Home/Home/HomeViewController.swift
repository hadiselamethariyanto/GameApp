//
//  HomeViewController.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import UIKit
import Kingfisher
import Combine
import Common

public class HomeViewController: UIViewController {
    
    public var didSendEventClosure: ((Game) -> Void)?

    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    
    public var viewModel: HomeViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var games:[Game]=[]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        
        let bundle = Bundle(identifier: "org.cocoapods.Common")
        
        errorImage.image = UIImage(named: "warning", in: bundle, with: nil)
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: bundle), forCellReuseIdentifier: "gameTableViewCell")
        
        showLoading(isLoading: true)
        showError(message: "", isVisible: false)                
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getGames().receive(on: RunLoop.main).sink(receiveCompletion: {completion in
            switch completion{
            case .failure:
                self.showError(message: String(describing: completion), isVisible: true)
            case .finished:
                self.showLoading(isLoading: false)
            }
        }, receiveValue: {games in
            self.games = games
            self.gameTableView.reloadData()
        }).store(in: &cancellables)
    }
    
    private func showLoading(isLoading:Bool){
        if(isLoading){
            self.indicatorLoading.startAnimating()
        }else{
            self.indicatorLoading.stopAnimating()
        }
        
        self.indicatorLoading.isHidden = !isLoading
        self.gameTableView.isHidden = isLoading
    }
    
    private func showError(message:String, isVisible:Bool){
        self.errorImage.isHidden = !isVisible
        self.errorLabel.isHidden = !isVisible
        self.errorLabel.text = message
    }


}

extension HomeViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game = games[indexPath.row]
        didSendEventClosure?(game)
//        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
//        detail.game = games[indexPath.row]
//        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return games.count
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell else {
          fatalError("DequeueReusableCell failed while casting")
      }
      let game = games[indexPath.row]
      cell.setCellWithValuesOf(game)
      return cell
  }
  

}
