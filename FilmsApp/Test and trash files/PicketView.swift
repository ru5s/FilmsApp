//
//  PicketView.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 29/05/23.
//

import Foundation


/*
 
 var switchTypeMovies: UIPickerView = {
     let pickerView = UIPickerView()
     pickerView.translatesAutoresizingMaskIntoConstraints = false
     
     return pickerView
 }()
 
 let options = ["Popular", "Top Rated", "Now playing", "Upcoming"]
 
 viewDidLoad
 switchTypeMovies.delegate = self
 switchTypeMovies.dataSource = self
 
 collectionView.addSubview(switchTypeMovies)
 
 viewDidLayoutSubviews
 ,
 switchTypeMovies.heightAnchor.constraint(equalToConstant: 120),
//            switchTypeMovies.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
 switchTypeMovies.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
 switchTypeMovies.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
 
 
 extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return options.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return options[row]
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         // Handle the selection of a row
         let selectedOption = options[row]
         print("Selected option: \(selectedOption)")
     }
     
     func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
         
         pickerView.subviews.forEach { view in
             view.backgroundColor = .clear
             view.tintColor = UIColor(named: "navigatorColor")
         }
         
         let label = UILabel()
         label.text = options[row]
         label.textAlignment = .center
         label.font = UIFont.systemFont(ofSize: 24) // Set the desired font size
         label.textColor = UIColor(named: "navigatorColor")
 //        label.backgroundColor = .black
 //        label.backgroundColor = .clear
         
         return label
     }
 }

 */
