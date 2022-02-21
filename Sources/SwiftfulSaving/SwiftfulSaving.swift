public struct SwiftfulSaving {
    
    static func addLogging(service: Logger.ServiceType, actions: [Logger.ServiceAction]) {
        Task {
            await Logger.shared.addLogging(service: service, actions: actions)
        }
    }

}
