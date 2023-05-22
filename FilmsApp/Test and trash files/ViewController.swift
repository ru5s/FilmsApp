//
//  ViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = ViewController()
        firstVC.title = "Home"
        firstVC.navigationController?.title = "Home page"
        
        viewControllers = [firstVC, SecondViewController()]
        
        tabBar.tintColor = .white
        
        
        
//        let favoriteBarButtonItem = UIBarButtonItem (barButtonSystemItem: .save, target: self, action: #selector(openSaveFilms))
//        let detailBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openDetailFilm))
    }
    
    
}

class ViewController: UIViewController {
    
    let secondVCs = SecondViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGreen
        navigationItem.title = "Films app"
        navigationController?.isToolbarHidden = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil),
                                              UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)]
        navig()
        
        navigationController?.isNavigationBarHidden = false
        
        
        
    }
    
    func navig(){
        var items = [UIBarButtonItem]()
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        let item: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(openSecond2))
        item.tintColor = .blue
        
        items.append(item)
                     
        items.append(UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(openSecond)))
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
//        toolbarItems = items
        setToolbarItems(items, animated: true)
    }

    @objc func openSecond(){
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
    @objc func openSecond2(){
        
    }
}


class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink
        navigationItem.title = "Films pink app"
        tabBarItem.title = "title2"
        tabBarItem.image = UIImage(systemName: "questionmark.folder.fill")
        
        
        
        
    }

}
