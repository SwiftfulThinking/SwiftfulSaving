//
//  File.swift
//  
//
//  Created by Nick Sarno on 2/21/22.
//

import Foundation

final actor Logger {
    
    static let shared = Logger()
    
    private var servicesEnabled: [(service: ServiceType, actions: [ServiceAction])] = []
    
    func addLogging(service: ServiceType, actions: [ServiceAction]) {
        servicesEnabled.append((service, actions))
    }
        
    func log(action: ServiceAction, at service: ServiceType, object: Any, filename: String = #file, line: Int = #line, functionName: String = #function) {
        let message = service.icon + " " + action.rawValue + service.rawValue + " \(object)"
        
        // Only print if service and action are enabled
        if let enabledService = servicesEnabled.first(where: { $0.service == service }), enabledService.actions.contains(action) {
            Swift.print(message)
        }
    }
    
    enum ServiceType: String {
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
        
    enum ServiceAction: String {
        case read = "Read from "
        case write = "Write to "
        case delete = "Delete from "
        case notFound = "Not found in "
    }
}
