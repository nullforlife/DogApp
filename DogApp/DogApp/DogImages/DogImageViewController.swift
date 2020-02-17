import UIKit

class DogImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var dogImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.image = dogImage
        scrollView.maximumZoomScale = 5
    }
}

extension DogImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale > 1 {
            UIView.animate(withDuration: 0.300, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                scrollView.zoomScale = 1
            }, completion: nil)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < 1 {
            scrollView.zoomScale = 1
        }
    }
}
