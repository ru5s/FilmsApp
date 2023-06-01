//
//  MainCollectionViewExtension.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 29/05/23.
//

import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.arrayHelper?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        DispatchQueue.main.async {
            
            cell.data = self.model.arrayHelper?[indexPath.item]
            self.model.checkLike(id: Int(self.model.arrayHelper?[indexPath.row].value(forKey: "id") as? Int32 ?? 0)) ? (cell.heartImage.tintColor = .red) : (cell.heartImage.tintColor = .gray)
        }
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tappedHeart(_ :)))
        cell.heartImage.isUserInteractionEnabled = true
        cell.heartImage.tag = Int(model.arrayHelper?[indexPath.row].value(forKey: "id") as? Int32 ?? 0)
        cell.heartImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func tappedHeart(_ sender: UITapGestureRecognizer) {
        
        let id = sender.view?.tag
        guard let id = id else {return}
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2) {
                sender.view?.tintColor == .red ? (sender.view?.tintColor = .gray) : (sender.view?.tintColor = .red)
            }
            
            self.model.chooseFilm(id: id)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedVC = DetailFilmViewController()
        
        detailedVC.data = model.arrayHelper?[indexPath.item]
        
        self.navigationController?.modalTransitionStyle = .partialCurl

        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
}

