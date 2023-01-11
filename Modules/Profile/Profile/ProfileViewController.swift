//
//  ProfileViewController.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import UIKit

public final class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        
        profileImageView.image = UIImage(named: "profile", in: Bundle(identifier: "hadi.Common"), with: nil)

    }
   
}
