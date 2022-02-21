public struct SwiftfulSaving {
    
    public static func addLogging(service: ServiceType, actions: [ServiceAction]) {
        Task {
            await Logger.shared.addLogging(service: service, actions: actions)
        }
    }

    public enum ServiceType: String {
        case coreData = "CoreData"
        case fileManager = "FileManager"
        case keychain = "Keychain"
        case userDefaults = "UserDefaults"
        case nsCache = "NSCache"
        
        var icon: String {
            switch self {
            case .coreData: return "🗳"
            case .fileManager: return "📁"
            case .keychain: return "🔑"
            case .userDefaults: return "🔖"
            case .nsCache: return "🗂"
            }
        }
    }
        
    public enum ServiceAction: String {
        case read = "Read from "
        case write = "Write to "
        case delete = "Delete from "
        case notFound = "Not found in "
    }

}
