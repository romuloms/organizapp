import Foundation

enum Priority: Int {
    case high = 0
    case medium = 1
    case low = 2
    case none = 3
}

struct Task {
    var title: String
    var description: String
    var priority: Priority
    
    init(_ title: String, _ description: String, _ priority: Priority) {
        self.title = title
        self.description = description
        self.priority = priority
    }
}
