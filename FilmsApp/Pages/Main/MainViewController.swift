//
//  MainViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class MainViewController: UIViewController {
    
    
    lazy var mainSearchBar: UISearchBar = {
        /* add search bar*/
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width - 20, height: 50))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.backgroundColor = .white.withAlphaComponent(0.8)
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 5

        searchBar.delegate = self
//        navigationItem.titleView = searchBar
        /* end*/

        return searchBar
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 2
        let sizeToCell = (Int(UIScreen.main.bounds.width - 30) - (countOfCell * 10)) / countOfCell
        
        layout.itemSize = CGSize(width: sizeToCell, height: 350)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        cv.showsVerticalScrollIndicator = false
        cv.autoresizingMask = .flexibleHeight
        
        return cv
    }()
    
    let urlService = URLService()
    let coreDataService = CoreDataService()
    let imageAdress = "https://image.tmdb.org/t/p/w500/"
    
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        view.addSubview(mainSearchBar)
        mainSearchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "Films app"
        
        let favoriteBarButtonItem = UIBarButtonItem(title: "Like", style: .plain, target: self, action: #selector(openSaveFilms))
        let detailBarButtonItem = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(openDetailFilm))

        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, detailBarButtonItem]
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        mainSearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        mainSearchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        mainSearchBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainSearchBar.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])
        
//        view.constraints
    }
    
    @objc private func openDetailFilm(){
        let detailFilmVC = DetailFilmViewController()
        
        navigationController?.pushViewController(detailFilmVC, animated: true)
    }
    
    @objc private func openSaveFilms(){
        let favoriteFilms = FavoriteFilmsViewController()
        
        navigationController?.pushViewController(favoriteFilms, animated: true)
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return model.allFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.posterPreviewImageView.image = UIImage(named: testArray[indexPath.row].testPic!)
//        cell.filmTitleLabel.text = testArray[indexPath.row].testTitle
//        cell.releaseYearLabel.text = testArray[indexPath.row].testYear
//        cell.ratingLabel.text = testArray[indexPath.row].testRating
        
        cell.filmTitleLabel.text = model.allFilms[indexPath.row].value(forKeyPath: "filmTitle") as? String
        cell.releaseYearLabel.text = String(model.allFilms[indexPath.row].value(forKeyPath: "filmYear") as? Int ?? 0000)
        cell.ratingLabel.text = String(model.allFilms[indexPath.row].value(forKeyPath: "filmRating") as? Double ?? 0.0)
        
        guard let url = URL(string: imageAdress + "\(model.allFilms[indexPath.row].value(forKeyPath: "filmPic") as! String)") else {return cell}
        
        urlService.getSetPoster(withUrl: url) { image in
            cell.posterPreviewImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = DetailFilmViewController()
        
        detailedVC.posterPreviewImageView.image = UIImage(named: testArray[indexPath.row].testPic!)
        detailedVC.filmTitleLabel.text = testArray[indexPath.row].testTitle
        detailedVC.ratingLabel.text = testArray[indexPath.row].testRating
        detailedVC.releaseYearLabel.text = testArray[indexPath.row].testYear
        
        self.navigationController?.modalTransitionStyle = .partialCurl

        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
}

extension MainViewController: UISearchBarDelegate{
    
}
