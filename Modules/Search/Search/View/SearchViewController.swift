//
//  SearchViewController.swift
//  Search
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import UIKit
import Common
import Combine


public final class SearchViewController: UIViewController {
    
    public var didSendEventClosure: ((Game) -> Void)?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    public var viewModel: SearchViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var games:[Game]=[]
    

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search"
        
        addIconSearchTextField()
        triggerSearchTextField()
        setTableView()
        showLoading(isLoading: false)
        showError(message: "", isVisible: false)        
    }
    
        
    private func searchGame(value:String){
        showLoading(isLoading: true)
        viewModel.searchGames(query: value).receive(on: DispatchQueue.main).sink(receiveCompletion: {completion in
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
            self.loadingIndicator.startAnimating()
        }else{
            self.loadingIndicator.stopAnimating()
        }
        
        self.loadingIndicator.isHidden = !isLoading
        self.gameTableView.isHidden = isLoading
    }
    
    private func showError(message:String, isVisible:Bool){
        self.errorImage.image = UIImage(named: "warning", in: Bundle(identifier: "org.cocoapods.Common"), with: nil)
        self.errorImage.isHidden = !isVisible
        self.errorLabel.isHidden = !isVisible
        self.errorLabel.text = message
    }
    
    private func addIconSearchTextField(){
        self.searchTextField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: "magnifyingglass")
        imageView.image = image
        self.searchTextField.leftView = imageView
    }
    
    private func triggerSearchTextField(){
        let searchPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.searchTextField)
             .map { ($0.object as? UITextField)?.text }
             .replaceNil(with: "")

        searchPublisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main).sink(receiveValue: { value in
           self.searchGame(value: value)
       }).store(in: &cancellables)
    }
    
    private func setTableView(){
        self.gameTableView.dataSource = self
        self.gameTableView.delegate = self
        self.gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: Bundle(identifier: "org.cocoapods.Common")), forCellReuseIdentifier: "gameTableViewCell")
    }
        
}


extension SearchViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game = games[indexPath.row]
        didSendEventClosure?(game)
    }
}

extension SearchViewController: UITableViewDataSource {

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
