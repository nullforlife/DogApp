import UIKit

class BreedTableViewCell: UITableViewCell {

    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    func renderBreed(_ breed: Breed) {
        breedNameLabel.text = breed.breed
        arrowRightImageView.isHidden = !breed.hasSubBreeds
    }
}
