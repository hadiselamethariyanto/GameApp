//
//  FavoriteViewController.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import UIKit
import Combine
import Common

public class FavoriteViewController: UIViewController {
    
    public var didSendEventClosure: ((Game) -> Void)?

    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    public var viewModel: FavoriteViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var games:[Game]=[]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorite"
                
        showEmptyView(isEmpty: false)
        
        let bundle = Bundle(identifier: "org.cocoapods.Common")
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: bundle), forCellReuseIdentifier: "gameTableViewCell")
                
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        viewModel.getFavorites().receive(on: DispatchQueue.main).sink(receiveCompletion: {completion in
        }, receiveValue: {games in
            self.games = games
            if(games.isEmpty){
                self.showEmptyView(isEmpty: true)
            }else{
                self.showEmptyView(isEmpty: false)
                self.gameTableView.reloadData()
            }
        }).store(in: &cancellables)
    }
    
    private func showEmptyView(isEmpty:Bool){
        self.gameTableView.isHidden = isEmpty
        self.emptyImage.isHidden = !isEmpty
        self.emptyLabel.isHidden = !isEmpty
        self.emptyImage.image = UIImage(named: "console",in: Bundle(identifier: "org.cocoapods.Common"), with: nil)
    }

}

extension FavoriteViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game = games[indexPath.row]
        didSendEventClosure?(game)
    }
}

extension FavoriteViewController: UITableViewDataSource {

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
