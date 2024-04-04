import SwiftUI

struct ContentView: View {
    @State var selectedEmployee: Employee?
    @State var selectedTab: Int = 0

    var body: some View {        
        // FIXME: Investigate solution for earlier versions of iOS
        NavigationStack {
            TabView(selection: $selectedTab) {
                VStack {
                    EmployeesViewControllerView { employee in
                        self.selectedEmployee = employee
                    }
                }
                .tabItem {
                    Label(
                        title: { Text("Managers") },
                        icon: { Image(systemName: "person.2.circle.fill") }
                    )
                }
                .tag(0)
                
                VStack {
                    if let selectedEmployee {
                        ProfileView(employee: selectedEmployee)
                    } else {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.secondary)
                        Text("No employee selected")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                .tabItem {
                    Label(
                        title: { Text("Employee") },
                        icon: { Image(systemName: "person.fill") }
                    )
                }
                .tag(1)
            }
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView(selectedEmployee: Employee.sampleEmployeeData, selectedTab: 0)
}
