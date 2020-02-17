import UIKit

class DogImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    private var imageTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        imageTask?.cancel()
        imageTask = nil
        dogImageView.image = nil
    }
    
    func renderImageFrom(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageTask = ImageService(network: Network()).loadImageFrom(url: url, completion: { [weak self] image in
            self?.renderImage(image)
        })
    }
    
    private func renderImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.dogImageView.image = image
        }
    }
}
