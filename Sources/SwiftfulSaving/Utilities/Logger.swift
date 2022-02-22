//
//  File.swift
//  
//
//  Created by Nick Sarno on 2/21/22.
//

import Foundation

final actor Logger {
    
    static let shared = Logger()
    
    private var servicesEnabled: [(service: SwiftfulSaving.ServiceType, actions: [SwiftfulSaving.ServiceAction])] = []
    
    func addLogging(service: SwiftfulSaving.ServiceType, actions: [SwiftfulSaving.ServiceAction]) {
        servicesEnabled.append((service, actions))
    }
        
    func log(action: SwiftfulSaving.ServiceAction, at service: SwiftfulSaving.ServiceType, object: Any, filename: String = #file, line: Int = #line, functionName: String = #function) {
        let message = service.icon + " " + action.rawValue + service.rawValue + " \(object)"
        
        // Only print if service and action are enabled
        if let enabledService = servicesEnabled.first(where: { $0.service == service }), enabledService.actions.contains(action) {
            Swift.print(message)
        }
    }
    
}
