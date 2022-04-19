//
//  PhotoSearchViewController.swift
//  PhotoSearchGallary
//
//  Created by Daniel 18/04/22.
//

import UIKit
import Combine

class PhotoSearchViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let pendingOperations = PendingOperations()

    private var bindings = Set<AnyCancellable>()
    
    private let viewModel:PhotoSearchViewModelType = PhotoSearchViewModel(serviceManager: ServiceManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bindViewModelState()
        bindSearchTextFieldToViewModel()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func bindSearchTextFieldToViewModel() {

        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)

        publisher
            .map {
                ($0.object as! UISearchTextField).text!
            }
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [weak self] searchedText in


                self?.viewModel.search(searchedText: searchedText)
            }.store(in: &bindings)
    }
    
    private func bindViewModelState() {
        let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            collectionView.isHidden = true
        case .loading:
            collectionView.isHidden = true
            activityIndicator.startAnimating()

        case .finishedLoading:
            collectionView.isHidden = false
            collectionView.reloadData()
            searchBar.resignFirstResponder()
            activityIndicator.stopAnimating()

        case .error(_):
            collectionView.reloadData()
            searchBar.resignFirstResponder()
            activityIndicator.startAnimating()

        }
    }
    
    private func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloader = ImageDownloader(photoRecord)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
            
            self.collectionView.reloadItems(at: [indexPath])
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }

}

extension PhotoSearchViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:100)
    }

}

extension PhotoSearchViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoDetailsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photoDetails = viewModel.photoRecords[indexPath.row]

        switch (photoDetails.state) {
       
        case .failed:
            print("")
        case .new :
              startDownload(for: photoDetails, at: indexPath)
          
        case .downloaded :
            cell.photoImageView.image = photoDetails.image
        }
        
        
        return cell
    }
}

