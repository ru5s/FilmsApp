//
//  DetailFilmViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit
import CoreData

class DetailFilmViewController: UIViewController, UIViewControllerTransitioningDelegate  {
    
    //подключение кастомной анимации
    var transition: RoundingTransition = RoundingTransition()
    
    let posterPreviewImageView: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .top
        image.clipsToBounds = true
        
        image.layer.masksToBounds = true
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        image.backgroundColor = .systemBackground
        
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
//        label.textColor = .systemGray
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
        sv.backgroundColor = .systemBackground
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "allImageOfMovie")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemBackground
        
        return cv
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
//        label.textColor = .
        
        return label
    }()
    
    let blockDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.isScrollEnabled = true
        
        return tv
    }()
    
    let topBlockWithGradient: UIView = {
        let block = UIView()
        block.translatesAutoresizingMaskIntoConstraints = false
        block.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
        return block
    }()
    
    let model = Model()
    var curentFilm: Films?
    
    var data: NSManagedObject? {
        didSet{
            guard let unwrData = self.data else {return}
            
            if let film = unwrData as? Films {
                
                filmTitleLabel.text = film.filmTitle
                ratingLabel.text = String(film.filmRating)
                releaseYearLabel.text = String(film.filmYear)
                blockDescriptionTextView.text = film.about
                curentFilm = film
                
                guard let partOfUrl = film.filmPic else {return}
                
                model.getPoster(partOfUrl) { image in
                    self.posterPreviewImageView.image = image
                }
                
            } else {
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Detailed film"
        
        navigationController?.navigationBar.isTranslucent = true
        let barItem = UIBarButtonItem(title: "add to Like", style: .plain, target: self, action: #selector(openFilmPics))
        
        
        navigationItem.rightBarButtonItem = barItem
        
        
        view.backgroundColor = .systemBackground
        view.addSubview(posterPreviewImageView)
        
        posterPreviewImageView.addSubview(blackRectangle)
        posterPreviewImageView.addSubview(topBlockWithGradient)
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: #selector(doubleTap(_:)))
        posterPreviewImageView.isUserInteractionEnabled = true
        posterPreviewImageView.addGestureRecognizer(tap)
        
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
        
        DispatchQueue.main.async {
            self.model.getScreenshots(id: Int(self.curentFilm?.id ?? 0)) {
                self.collectionViewImagesOfMovie.reloadData()
            }
        }
        
        collectionViewImagesOfMovie.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
        let safeZone = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            posterPreviewImageView.topAnchor.constraint(equalTo: view.topAnchor),
            posterPreviewImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            posterPreviewImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2),
            posterPreviewImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blackRectangle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            blackRectangle.bottomAnchor.constraint(equalTo: posterPreviewImageView.bottomAnchor),
            blackRectangle.heightAnchor.constraint(equalToConstant: 80),
            topBlockWithGradient.topAnchor.constraint(equalTo: view.topAnchor),
            topBlockWithGradient.widthAnchor.constraint(equalToConstant: view.bounds.width),
            topBlockWithGradient.bottomAnchor.constraint(equalTo: safeZone.topAnchor),
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
    
    @objc private func doubleTap(_ gesture: UITapGestureRecognizer) {
        let fullPicVC = FullPicViewController()
        
        fullPicVC.fullimage.image = posterPreviewImageView.image
        fullPicVC.transitioningDelegate = self
        fullPicVC.modalPresentationStyle = .custom
        
        present(fullPicVC, animated: true)
    }
    
    @objc private func openFilmPics(){
        let filmPicsVC = FilmPicsViewController()
        
        navigationController?.pushViewController(filmPicsVC, animated: true)
    }

}

extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curentFilm?.backdrop_path?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allImageOfMovie", for: indexPath)
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        image.contentMode = .scaleAspectFill
        
        cell.addSubview(image)
        model.getPoster(curentFilm?.backdrop_path?[indexPath.row] ?? "", completiton: { testimage in
            image.image = testimage
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullPicVC = FullPicViewController()
        
        model.getPoster(curentFilm?.backdrop_path?[indexPath.row] ?? "", completiton: { testimage in
            fullPicVC.fullimage.image = testimage
        })
        
        fullPicVC.transitioningDelegate = self
        fullPicVC.modalPresentationStyle = .custom
        
        present(fullPicVC, animated: true)
    }
    
    //метод кастомной анимации при появлении
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .show
        transition.start = posterPreviewImageView.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    //метод кастомной анимации при исчезании
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .cancel
        transition.time = 1.0
        transition.start = posterPreviewImageView.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
}
