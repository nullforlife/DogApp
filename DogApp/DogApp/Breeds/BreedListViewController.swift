import UIKit

class BreedListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableViewHandler: BreedTableViewHandler?
    var breeds: [String]?
    var parentBreed: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dogImagesView = segue.destination as? DogImagesViewController, let breed = sender as? Breed {
            dogImagesView.breed = breed
            dogImagesView.title = breed.breed
        }
    }
    
    private func setup() {
        if let breeds = breeds?.map({ Breed(breed: $0, subBreeds: [], parent: parentBreed) }) {
            setupTableViewWith(breeds: breeds)
        } else {
            fetchBreedList()
        }
    }
    
    private func fetchBreedList() {
        DogService(network: Network()).fetchAllBreeds { [weak self] breeds in
            guard let breeds = breeds else { return }
            DispatchQueue.main.async {
                self?.setupTableViewWith(breeds: breeds)
            }
        }
    }
    
    private func setupTableViewWith(breeds: [Breed]) {
        tableViewHandler = BreedTableViewHandler(breeds: breeds, delegate: self)
        tableView.dataSource = tableViewHandler
        tableView.delegate = tableViewHandler
        tableView.reloadData()
    }
}

extension BreedListViewController: BreedSelectionDelegate {
    func breedSelected(_ breed: Breed) {
        if  breed.hasSubBreeds,
            let breedView = storyboard?.instantiateViewController(identifier: "BreedListViewController") as? BreedListViewController {
            breedView.breeds = breed.subBreeds
            breedView.parentBreed = breed.breed
            breedView.title = breed.breed
            navigationController?.pushViewController(breedView, animated: true)
        } else {
            performSegue(withIdentifier: "DogImagesViewController", sender: breed)
        }
    }
}

protocol BreedSelectionDelegate: class {
    func breedSelected(_ breed: Breed)
}

