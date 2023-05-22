//
//  DetailFilmViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class DetailFilmViewController: UIViewController {
    
    let posterPreviewImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        
        return image
    }()
    
    let blackRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let filmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название фильма"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        
        return label
    }()
    
    let releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Год выпуска"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = .systemGray
        label.textColor = .white
        
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Рейтинг"
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = true
        
        return sv   
    }()
    
    let collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Кадры из фильма"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        
        return label
    }()
    
    let collectionViewImagesOfMovie: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "allImageOfMovie")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        
        return label
    }()
    
    let blockDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.isScrollEnabled = true
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Detailed film"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openFilmPics))
        
        view.addSubview(posterPreviewImageView)
        
        posterPreviewImageView.addSubview(blackRectangle)
        
        blackRectangle.addSubview(filmTitleLabel)
        blackRectangle.addSubview(releaseYearLabel)
        blackRectangle.addSubview(ratingLabel)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(collectionTitleLabel)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 520)
        scrollView.becomeFirstResponder()
        
        collectionViewImagesOfMovie.delegate = self
        collectionViewImagesOfMovie.dataSource = self
        
        scrollView.addSubview(collectionViewImagesOfMovie)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(blockDescriptionTextView)
        
        blockDescriptionTextView.text = bigTextTemp
    }
    
    override func viewDidLayoutSubviews() {
        
        let safeZone = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            posterPreviewImageView.topAnchor.constraint(equalTo: safeZone.topAnchor),
            posterPreviewImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            posterPreviewImageView.heightAnchor.constraint(equalToConstant: 400),
            posterPreviewImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blackRectangle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            blackRectangle.bottomAnchor.constraint(equalTo: posterPreviewImageView.bottomAnchor),
            blackRectangle.heightAnchor.constraint(equalToConstant: 80),
            filmTitleLabel.topAnchor.constraint(equalTo: blackRectangle.topAnchor, constant: 10),
            filmTitleLabel.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            releaseYearLabel.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            releaseYearLabel.bottomAnchor.constraint(equalTo: blackRectangle.bottomAnchor, constant: -10),
            ratingLabel.trailingAnchor.constraint(equalTo: safeZone.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: blackRectangle.bottomAnchor, constant: -10),
            scrollView.topAnchor.constraint(equalTo: posterPreviewImageView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            scrollView.bottomAnchor.constraint(equalTo: safeZone.bottomAnchor),
            collectionTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            collectionViewImagesOfMovie.topAnchor.constraint(equalTo: collectionTitleLabel.bottomAnchor, constant: 10),
            collectionViewImagesOfMovie.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewImagesOfMovie.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewImagesOfMovie.heightAnchor.constraint(equalToConstant: 100),
            descriptionTitleLabel.topAnchor.constraint(equalTo: collectionViewImagesOfMovie.bottomAnchor, constant: 10),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            blockDescriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            blockDescriptionTextView.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            blockDescriptionTextView.trailingAnchor.constraint(equalTo: safeZone.trailingAnchor),
            blockDescriptionTextView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    @objc private func openFilmPics(){
        let filmPicsVC = FilmPicsViewController()
        
        navigationController?.pushViewController(filmPicsVC, animated: true)
    }

}

extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allImageOfMovie", for: indexPath)
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        image.contentMode = .scaleAspectFill
        
        cell.addSubview(image)
        image.image = UIImage(named: testArray[indexPath.row].testPic!)
        
        return cell
    }
    
    
}
