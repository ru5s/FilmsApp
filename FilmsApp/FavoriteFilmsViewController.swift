//
//  FavoriteFilmsViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class FavoriteFilmsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Favorite films"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(openDetailFilm))
    }
    
    @objc private func openDetailFilm(){
        let detailFilmVC = DetailFilmViewController()
        
        navigationController?.pushViewController(detailFilmVC, animated: true)
    }
}
