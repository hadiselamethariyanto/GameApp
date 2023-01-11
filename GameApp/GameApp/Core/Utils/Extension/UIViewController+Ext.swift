//
//  UIViewController+Ext.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import UIKit
import Swinject

extension UIViewController {
    
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var container: Container {
        appDelegate.container
    }
}
