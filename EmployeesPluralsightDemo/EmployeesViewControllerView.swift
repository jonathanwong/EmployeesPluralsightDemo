import SwiftUI

protocol CurrentEmployeeProvider {
    func currentEmployee() -> ((Employee) -> Void)
}

struct EmployeesViewControllerView: UIViewControllerRepresentable {
    
    var didSelectEmployee: (Employee?) -> Void
    
    typealias UIViewControllerType = EmployeesViewController
    
    func makeUIViewController(
        context: Context
    ) -> EmployeesViewController {
        let viewController = EmployeesViewController()
        viewController
            .selectedEmployeePublisher
            .sink { employee in
                didSelectEmployee(employee)
            }
            .store(in: &viewController.cancellables)
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: EmployeesViewController, 
        context: Context
        ) {
        // no-op
    }
}

#Preview {
    EmployeesViewControllerView(didSelectEmployee: { _ in })
}
