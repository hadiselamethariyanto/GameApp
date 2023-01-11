//
//  DetailCoordinator.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 11/01/23.
//

import Foundation
import UIKit
import Common
import Detail

protocol DetailCoordinatorProtocol: Coordinator {
    func showDetailViewController(game:Game)
}

class DetailCoordinator: DetailCoordinatorProtocol {
   
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .detail }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
//        self.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    func start(){
        
    }
        
    func start(game:Game) {
        showDetailViewController(game:game)
    }
    
    deinit {
        print("LoginCoordinator deinit")
    }
    
    
    func showDetailViewController(game:Game) {
        let detailVC: DetailGameViewController = container.resolve(DetailGameViewController.self)!
        detailVC.game = game        
        navigationController.pushViewController(detailVC, animated: true)
    }
}
