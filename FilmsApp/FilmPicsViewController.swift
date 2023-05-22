//
//  FilmPicsViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class FilmPicsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Film pictures"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openFullPic))
    }
    
    @objc private func openFullPic(){
        let fullPicVC = FullPicViewController()
        
        navigationController?.pushViewController(fullPicVC, animated: true)
    }

}
