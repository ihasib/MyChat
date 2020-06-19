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
        self.viewControllers = [MainViewController(),SecondViewController()]
    }
}

class MainViewController: UIViewController {
    override func viewDidLoad() {
        self.tabBarItem = .init(title: "Home", image: UIImage(named: "nearMe"), selectedImage: UIImage(named: "picture"))
        view.backgroundColor = .cyan
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .black
    }
}
