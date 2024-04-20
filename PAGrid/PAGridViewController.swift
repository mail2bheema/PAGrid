//
//  ViewController.swift
//  PAGrid
//
//  Created BheemaBadri on 15/04/24.
//

import UIKit

class PAGridViewController: UIViewController {

    var collectionView: UICollectionView!
    
    private let networkingManager = NetworkingManager.shared
    private let imageCacheManager = ImageCacheManager.shared
    private var mediaObjectsList: [MediaCoverage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        fetchImagesFromServer()
        collectionView.dataSource = self
    }
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let itemWidth = (view.frame.size.width - 40) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.addSubview(collectionView)
    }
    
    func fetchImagesFromServer() {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }
        
        networkingManager.fetchData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                // Handle successful data retrieval
                print("Data fetched successfully:", data)
                do {
                    self?.mediaObjectsList = try JSONDecoder().decode([MediaCoverage].self, from: data)

                    DispatchQueue.main.async { [self] in
                        self?.collectionView.reloadData()
                    }
                } catch {
                    print("Failed to decode data:", error.localizedDescription)
                }
            case .failure(let error):
                // Handle failure
                print("Failed to fetch data:", error.localizedDescription)
            }
        }
    }
  
}
    

extension PAGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjectsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let mediaObject = mediaObjectsList[indexPath.item]
        cell.imageView.image = nil
        
        ImageCacheManager.shared.getImage(mediaObj:mediaObject ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.imageView.image = image
                case .failure(let error):
                    print("Error fetching image: \(error)")
                }
            }
        }

        return cell
    }

}

