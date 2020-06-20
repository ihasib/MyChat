//
//  InitialPageViewController.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 6/19/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

class InitialPageViewController: UITabBarController {
    override func viewDidLoad() {
        view.backgroundColor = .red
        self.viewControllers = [DialPageViewController(nibName: "DialPage", bundle: nil),
                                SettingsPageViewController(nibName: "SettingsPage")]
    }
}

class DialPageViewController: UIViewController {
    override func viewDidLoad() {
        self.tabBarItem = .init(title: "Call", image: #imageLiteral(resourceName: "call"), selectedImage: #imageLiteral(resourceName: "call"))
        view.backgroundColor = .gray
    }
}

class SettingsPageViewController: UIViewController {
    
    init(nibName: String) {
        super.init(nibName: nibName, bundle:nil)
        self.tabBarItem = .init(title: "Settings", image: #imageLiteral(resourceName: "settings"), selectedImage: #imageLiteral(resourceName: "settings"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .gray
    }
}
