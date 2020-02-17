import UIKit

class DogImagesViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var breed: Breed?
    private var collectionViewHandler: DogImagesCollectionViewHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDogImages()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let dogImageView = segue.destination as? DogImageViewController,
            let cell = sender as? DogImageCollectionViewCell {
            dogImageView.dogImage = cell.dogImageView.image
        }
    }
    
    private func fetchDogImages() {
        DogService(network: Network()).fetchDogImages(breed: breed) { [weak self] imageUrls in
            guard let urls = imageUrls else { return }
            DispatchQueue.main.async {
                self?.setupDogImageCollectionViewWith(urls: urls)
            }
        }
    }
    
    private func setupDogImageCollectionViewWith(urls: [String]) {
        collectionViewHandler = DogImagesCollectionViewHandler(urls: urls)
        collectionView.dataSource = collectionViewHandler
        collectionView.delegate = collectionViewHandler
    }
}
