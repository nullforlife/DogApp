import Foundation
import UIKit

struct ImageService {
    
    let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func loadImageFrom(url: URL, completion: @escaping(_ image: UIImage?) -> Void) -> URLSessionDataTask? {
        return network.loadImageData(url: url) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
