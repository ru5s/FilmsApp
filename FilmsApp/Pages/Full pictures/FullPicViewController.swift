//
//  FullPicViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class FullPicViewController: UIViewController {
    
    let fullimage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(fullimage)
        navigationItem.title = "Full pictures view"
        
        fullimage.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(backTap))
        fullimage.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        swipeDown.addTarget(self, action: #selector(backTap))
        fullimage.addGestureRecognizer(swipeDown)

    }
    
    @objc func backTap() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            fullimage.widthAnchor.constraint(equalToConstant: view.bounds.width),
            fullimage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            fullimage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}
