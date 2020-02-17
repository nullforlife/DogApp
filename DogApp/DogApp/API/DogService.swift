import Foundation

struct DogService {
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func fetchAllBreeds(completion: @escaping(_ breeds: [Breed]?) -> Void) {
        let url = URL(string:"https://dog.ceo/api/breeds/list/all")!
        
        network.fetchData(url: url) { (response: BreedResponse?) in
            
            guard let breedResponse = response?.message else {
                completion(nil)
                return
            }
            let breedList = breedResponse.map({ Breed(breed: $0.key, subBreeds: $0.value) })
            completion(breedList)
        }
    }
    
    func fetchDogImages(breed: Breed? = nil, completion: @escaping(_ imageUrls: [String]?) -> Void) {
        let url = getDogImageURL(breed: breed)
        network.fetchData(url: url) { (response: ImageURLResponse?) in
            completion(response?.message)
        }
    }
    
    private func getDogImageURL(breed: Breed?) -> URL {
        if let breed = breed {
            if let parent = breed.parent {
                return URL(string: "https://dog.ceo/api/breed/\(parent)/\(breed.breed)/images")!
            }
            return URL(string: "https://dog.ceo/api/breed/\(breed.breed)/images")!
        }
        return URL(string: "https://dog.ceo/api/breeds/image/random/50")!
    }
}

struct Breed {
    
    let breed: String
    let subBreeds: [String]
    var parent: String?
    
    var hasSubBreeds: Bool {
        return subBreeds.count > 0
    }
}

private struct BreedResponse: Codable {
    
    let message: [String: [String]]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status
    }
}

private struct ImageURLResponse: Codable {
    
    let message: [String]
    let status: String
    
}
