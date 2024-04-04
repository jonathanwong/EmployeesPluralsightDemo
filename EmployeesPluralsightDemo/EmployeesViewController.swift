import UIKit
import Combine

class EmployeesViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    var selectedEmployeePublisher: AnyPublisher<Employee?, Never> {
        currentEmployeeSubject.eraseToAnyPublisher()
    }
    
    var employeeProvider = EmployeeProvider()
    private var employeeCellRegistration: UICollectionView.CellRegistration<EmployeeCell, Employee>!
    private var currentEmployeeSubject: CurrentValueSubject<Employee?, Never>  = CurrentValueSubject(nil)
    
    private lazy var employeesCollectionView: UICollectionView! = {
        let layout = layoutProvider()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        employeeCellRegistration = UICollectionView.CellRegistration { employeeCell, indexPath, employee in
            employeeCell.employeeNameLabel.text = employee.firstName + " " + employee.lastName
            employeeCell.teamLabel.text = employee.team
            employeeCell.employeeImageView.setImage(imageName: employee.imageSmall)
        }
        
        return collectionView
    }()
    
    private func layoutProvider() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        }
        
        return layout
    }
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Employees"
        
        employeeProvider
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] data in
                switch data {
                case .loading:
                    self.view.addSubview(activityIndicatorView)
                    self.activityIndicatorView.center = view.center
                case .loaded(_):
                    UIView.transition(
                        with: view,
                        duration: 0.5, options: .transitionCrossDissolve,
                        animations: {
                            self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.removeFromSuperview()
                            self.setUpCollectionView()
                        },
                        completion: { _ in
                            self.employeesCollectionView.reloadData()
                        })
                case .failed:
                    let alert = UIAlertController(title: "Error", message: "Failed to load content", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
        
        fetchData()
    }

    private func fetchData() {
        employeeProvider.loadEmployees()
    }
    
    private func setUpCollectionView() {
        view.addSubview(employeesCollectionView)
        NSLayoutConstraint.activate([
            employeesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            employeesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            employeesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            employeesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension EmployeesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        employeeProvider.employees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let employee = employeeProvider.employees[indexPath.row]
        let employeeCell = collectionView.dequeueConfiguredReusableCell(using: employeeCellRegistration, for: indexPath, item: employee)
        
        return employeeCell
    }
}

extension EmployeesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let employee = employeeProvider.employees[indexPath.row]
        
        if currentEmployeeSubject.value == employee {
            // the same row was selected, deselect the row
            collectionView.deselectItem(at: indexPath, animated: true)
            currentEmployeeSubject.send(nil)
        } else {
            currentEmployeeSubject.send(employee)
        }
    }
}

#Preview {
    let employeeProvider = EmployeeProvider()
    employeeProvider.state = .loaded(Employee.sampleEmployeesData)
    let employeesViewController = EmployeesViewController()
    employeesViewController.employeeProvider = employeeProvider
    
    return employeesViewController
}
        
