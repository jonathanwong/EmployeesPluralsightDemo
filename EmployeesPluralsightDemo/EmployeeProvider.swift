import Foundation
import Combine
import RepositoryKit

class EmployeeProvider: ObservableObject {
    
    public enum State {
        case loading
        case loaded([Employee])
        case failed
    }
    
    @Published
    public var isLoading = false
    
    @Published
    public var state: State = .loading
    
    @Published
    public var employees: [Employee] = []
    
    let repository: AnyDataRepository<[Employee]>
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var dataChanged = PassthroughSubject<Void, Never>()
    
    public init() {
        self.repository = AnyDataRepository(EmployeeDataRepository())
    }
    
    public func loadEmployees() {
        isLoading = true
        fetchEmployees()
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .catch { [unowned self] error -> Just<[Employee]> in
                self.state = .failed
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [unowned self] in
                self.isLoading = false
                self.state = .loaded($0)
                dataChanged.send()
                self.employees = $0
            })
            .store(in: &cancellables)
    }
    
    func fetchEmployees() -> AnyPublisher<[Employee], Error> {
        repository.loadAndDecode(bundle: Bundle.main)
    }
}

class EmployeeDataRepository: DataRepository {
    typealias DataType = [Employee]
    
    let employeeRepository = Repository([Employee].self, filename: "employees", fileExtension: "json")
    
    func save(_ data: [Employee]) {
        employeeRepository.save(data)
    }
    
    func load() -> [Employee]? {
        employeeRepository.load()
    }
    
    func loadAndDecode(bundle: Bundle) -> AnyPublisher<[Employee], Error> {
        employeeRepository.loadAndDecode()
    }
}
