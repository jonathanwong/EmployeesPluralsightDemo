import UIKit
import Combine
import RepositoryKit

class RemoteImageView: UIImageView {
    var cancellable: AnyCancellable?
    var imageRepository: ImageRepository = LocalImageRepository()
    
    func setImage(imageName: String) {
        cancelImageRequest()
        image = nil
        
        cancellable = imageRepository
            .loadImageWithDelay(imageName: imageName, delayTime: 0.5)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)

    }
    
    func cancelImageRequest() {
        cancellable = nil
    }
    
}
