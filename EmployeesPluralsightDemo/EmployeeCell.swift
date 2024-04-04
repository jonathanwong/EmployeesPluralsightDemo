import UIKit
import Combine

class EmployeeCell: UICollectionViewCell {
    static let reuseIdentifier = "EmployeeCell"
    
    lazy var employeeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        
        return label
    }()
    
     lazy var employeeImageView: RemoteImageView = {
         let imageView = RemoteImageView()
         imageView.contentMode = .scaleAspectFit
        
         return imageView
     }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        let textStack = UIStackView(arrangedSubviews: [employeeNameLabel, teamLabel])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [employeeImageView, textStack])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            employeeImageView.widthAnchor.constraint(equalToConstant: 100),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        employeeImageView.cancelImageRequest()
        employeeImageView.image = nil
        backgroundColor = UIColor.clear
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.contentView.backgroundColor = UIColor(red: 115/255, green: 190/255, blue: 170/255, alpha: 1.0)
                    self.contentView.layer.cornerRadius = 10.0
                }
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.contentView.backgroundColor = .clear
                }
            }
        }
    }
}
