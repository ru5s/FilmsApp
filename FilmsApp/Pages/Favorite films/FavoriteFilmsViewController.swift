//
//  FavoriteFilmsViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

protocol MainViewControllerDelegate {
    func updateData()
}

class FavoriteFilmsViewController: UIViewController {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 2
        let sizeToCell = (Int(UIScreen.main.bounds.width - 30) - (countOfCell * 10)) / countOfCell
        
        layout.itemSize = CGSize(width: sizeToCell, height: 350)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FavoriteFilmsCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCollectionCell")
        cv.showsVerticalScrollIndicator = false
        cv.autoresizingMask = .flexibleHeight
        
        return cv
    }()
    
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        model.arrayFavoritesFilms = model.allFilms
        model.favoritesFilms()
        
        navigationItem.title = "Favorite films"

//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(openDetailFilm))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        collectionView.reloadData()
    }
    
    @objc private func openDetailFilm(){
        let detailFilmVC = DetailFilmViewController()
        
        navigationController?.pushViewController(detailFilmVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("++ appear")
        model.arrayFavoritesFilms = model.allFilms
        model.favoritesFilms()
        collectionView.reloadData()
    }
}

extension FavoriteFilmsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.arrayFavoritesFilms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionCell", for: indexPath) as? FavoriteFilmsCollectionViewCell else {return UICollectionViewCell()}
        
        cell.data = model.arrayFavoritesFilms?[indexPath.item]
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tappedHeart(_ :)))
        cell.heartImage.isUserInteractionEnabled = true
        cell.heartImage.tag = Int(self.model.arrayFavoritesFilms?[indexPath.row].value(forKey: "id") as? Int32 ?? 0)
        cell.heartImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func tappedHeart(_ sender: UITapGestureRecognizer) {
        
        let id = sender.view?.tag
        guard let id = id else {return}
        
        model.chooseFilm(id: id)
        model.favoritesFilms()
        collectionView.reloadData()
        
//        let indexPath = IndexPath(item: id, section: 0)
//        model.deleteLikedArrayByIndex(index: index)
        
//        collectionView.performBatchUpdates({
//                collectionView.deleteItems(at: [indexPath])
//            }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        collectionView.performBatchUpdates {
//
//            model.chooseFilm(id: model.arrayFavoritesFilms?[indexPath.row].value(forKey: "id") as! Int)
//
//            model.favoritesFilms()
//
//            collectionView.deleteItems(at: [indexPath])
//        }
        
        let detailedVC = DetailFilmViewController()
        
        detailedVC.data = model.arrayFavoritesFilms?[indexPath.item]
        
        self.navigationController?.modalTransitionStyle = .partialCurl

        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? FavoriteFilmsCollectionViewCell {
            UIView.animate(withDuration: 1.0) {
                cell.alpha = 0.0
            }
        }
        
    }
    
    
    
}
