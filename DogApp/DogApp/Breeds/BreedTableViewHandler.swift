import UIKit

class BreedTableViewHandler: NSObject, UITableViewDataSource {

    private var breeds: [Breed]
    private weak var delegate: BreedSelectionDelegate?
    
    init(breeds: [Breed], delegate: BreedSelectionDelegate) {
        self.breeds = breeds.sorted(by: { $0.breed < $1.breed })
        self.delegate = delegate
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell") as! BreedTableViewCell
        cell.renderBreed(breeds[indexPath.row])
        return cell
    }
}

extension BreedTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.breedSelected(breeds[indexPath.row])
    }
}
