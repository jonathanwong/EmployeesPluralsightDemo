import SwiftUI

struct ProfileView: View {
    
    var employee: Employee
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Image(employee.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width * 0.6)
                    .clipShape(Circle())
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(employee.firstName) \(employee.lastName)")
                            .font(.title)
                        Text("\(employee.team)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("\(employee.location)")
                            .font(.system(size: 16))
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Interests")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.mint).opacity(0.8)
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(employee.interests) { interest in
                                Text(interest.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(colors[interest.color].opacity(0.75), in: Capsule())
                            }
                        }
                    }
                    Text("Skills")
                        .font(.callout)
                        .foregroundColor(.mint).opacity(0.8)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(employee.skills) { skill in
                                Text(skill.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(colors[skill.color].opacity(0.75), in: Capsule())
                            }
                        }
                    }
                }
                .padding(.top)
             
                Spacer()
            }
            .padding()
        }
        
    }
}

#Preview("Profile") {
    ProfileView(employee: Employee.sampleEmployeeData)
}

