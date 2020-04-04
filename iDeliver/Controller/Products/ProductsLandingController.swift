//
//  ProductsLandingController.swift
//  iDeliver
//
//  Created by Hugo Flores on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductsLandingController: UIViewController {
    
    // MARK: Variables
    var data: [Int] = []//Array(0..<120)
    var topCategories: [Category] = []
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Your placeholder"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    let cartButton: UIButton = {
        let img = UIImage(named: "shopcart")
        let btn = UIButton()
        btn.setImage(img, for: .normal)
        btn.imageView!.contentMode = .scaleAspectFit
        btn.imageView!.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let mainCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()

    // MARK: View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()
        setUpMain()
        downloadScreenData()
    }
    
    // MARK: Set Up
    func setUpTopBar() {
        setUpCartIcon()
        setUpSearchbar()
    }
    
    func setUpCartIcon() {
        cartButton.addTarget(self, action: #selector(onCartPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let margins = navigationController?.navigationBar.layoutMargins
        NSLayoutConstraint.activate([
            cartButton.imageView!.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height - margins!.right * 2),
            cartButton.widthAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height + margins!.right)
        ])
    }
    
    func setUpSearchbar() {
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpMain() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(TopCategory.self, forCellWithReuseIdentifier: TopCategory.identifier)

        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: Data Handlers
    func downloadScreenData() {
        let data = ProductsAPI.getMockTopCategories()
        topCategories = data
        print(data)
    }
    
    // MARK: Action Handlers
    @objc func onCartPressed(sender:UIBarButtonItem) {
        print("Here")
    }

}

// MARK: Collection View Data Source & Delegation
extension ProductsLandingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + topCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0...(topCategories.count - 1):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategory.identifier, for: indexPath) as! TopCategory
            print("Setting data")
            cell.category = topCategories[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }

        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let data = self.data[indexPath.item - 1]
        cell.textLabel.text = String(data)
        cell.backgroundColor = .green
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blue.cgColor
         */
    }
}

extension ProductsLandingController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension ProductsLandingController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...(topCategories.count - 1):
            return TopCategory.preferredSize
        default:
            let size = (view.frame.width) / 6
            return CGSize(width: size, height: size)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
