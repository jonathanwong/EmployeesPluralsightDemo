import Foundation

public struct Employee: Codable, Hashable, Identifiable {
    
    public var id: UUID
    public var firstName: String
    public var lastName: String
    public var imageSmall: String
    public var image: String
    public var team: String
    public var location: String
    public var interests: [Interest]
    public var skills: [Skill]
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        imageSmall: String,
        image: String,
        team: String,
        location: String,
        interests: [Interest],
        skills: [Skill]
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageSmall = imageSmall
        self.image = image
        self.team = team
        self.location = location
        self.interests = interests
        self.skills = skills
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case imageSmall = "profileSmall"
        case image = "profile"
        case team = "team"
        case location = "location"
        case interests = "interests"
        case skills = "skills"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let imageSmall = try container.decode(String.self, forKey: .imageSmall)
        let image = try container.decode(String.self, forKey: .image)
        let team = try container.decode(String.self, forKey: .team)
        let location = try container.decode(String.self, forKey: .location)
        let interests = try container.decode([Interest].self, forKey: .interests)
        let skills = try container.decode([Skill].self, forKey: .skills)
        
        let id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        
        self.init(
            id: id,
            firstName: firstName,
            lastName: lastName,
            imageSmall: imageSmall,
            image: image,
            team: team,
            location: location,
            interests: interests,
            skills: skills
        )
    }
}

public struct Skill: Identifiable, Codable, Hashable {
    public var id = UUID()
    public var color: Int
    public var title: String
    
    public init(id: UUID = UUID(), color: Int, title: String) {
        self.id = id
        self.color = color
        self.title = title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color = try container.decode(Int.self, forKey: .color)
        let title = try container.decode(String.self, forKey: .title)
        
        let id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        
        self.init(id: id, color: color, title: title)
    }
}

public struct Interest: Identifiable, Codable, Hashable {
    public var id = UUID()
    public var color: Int
    public var title: String
    
    public init(id: UUID = UUID(), color: Int, title: String) {
        self.id = id
        self.color = color
        self.title = title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color = try container.decode(Int.self, forKey: .color)
        let title = try container.decode(String.self, forKey: .title)
        
        let id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        
        self.init(id: id, color: color, title: title)
    }
}

public extension Employee {
    static var sampleEmployeesData: [Employee] = {
        [
            Employee(
                firstName: "Julie",
                lastName: "Evans",
                imageSmall: "Profile-1-small",
                image: "Profile-1",
                team: "UI Systems",
                location: "Albuquerque, NM",
                interests: [
                    Interest(color: 0, title: "BBQ"),
                    Interest(color: 1, title: "Coffee"),
                ],
                skills: [
                    Skill(color: 2, title: "SwiftUI"),
                    Skill(color: 3, title: "Swift"),
                    Skill(color: 4, title: "Objective-C"),
                ])
        ]
    }()
    
    static var sampleEmployeeData: Employee = {
        sampleEmployeesData.first!
    }()
}

