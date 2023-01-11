//
//  TabCoordinator.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 11/01/23.
//

import UIKit
import Search
import Profile
import Favorite
import Home
import Swinject
import Common

enum TabBarPage {
    case home
    case favorite
    case profile
    case search

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .favorite
        case 2:
            self = .profile
        case 3:
            self = .search
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .profile:
            return "Profile"
        case .search:
            return "Search"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .favorite:
            return 2
        case .profile:
            return 3
        }
    }

    // Add tab icon value
    func getImage() -> UIImage{
        switch self{
        case .home:
            return UIImage(systemName: "person")!
        case .favorite:
            return UIImage(systemName: "heart")!
        case .profile:
            return UIImage(systemName: "person")!
        case .search:
            return UIImage(systemName: "magnifyingglass")!
        }
    }
    
    func getSelectedImage() -> UIImage{
        switch self{
        case .home:
            return UIImage(systemName: "person.fill")!
        case .favorite:
            return UIImage(systemName: "heart.fill")!
        case .profile:
            return UIImage(systemName: "person.fill")!
        case .search:
            return UIImage(systemName: "magnifyingglass.circle.fill")!
        }
    }
    
    // Add tab icon selected / deselected color
    
    // etc
}


protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.tabBarController = .init()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .favorite, .profile, .search]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.isOpaque = false
                
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: true)
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.getImage(),
                                                     selectedImage: page.getSelectedImage())    

        switch page {
        case .home:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let homeVC = container.resolve(HomeViewController.self)
            homeVC!.didSendEventClosure = { [weak self] game in
                self?.showDetail(game:game)
            }
            navController.pushViewController(homeVC!, animated: true)
        case .favorite:
            let favoriteVC = container.resolve(FavoriteViewController.self)
            favoriteVC!.didSendEventClosure = {[weak self] game in
                self?.showDetail(game:game)
            }
            navController.pushViewController(favoriteVC!, animated: true)
        case .profile:
            let profileVC = container.resolve(ProfileViewController.self)
            navController.pushViewController(profileVC!, animated: true)
            
        case .search:
            let searchVC = container.resolve(SearchViewController.self)
            searchVC!.didSendEventClosure = { [weak self] game in
                self?.showDetail(game:game)
            }
            navController.pushViewController(searchVC!, animated: true)
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func showDetail(game:Game){
        let detailCoordinator = DetailCoordinator.init(navigationController)
        detailCoordinator.start(game: game)
        childCoordinators.append(detailCoordinator)
    }
    
    
}

extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}



extension Coordinator{
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var container: Container {
        appDelegate.container
    }
}
