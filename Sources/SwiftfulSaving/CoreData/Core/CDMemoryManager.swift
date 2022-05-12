//
//  CDMemoryManager.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/9/22.
//

import Foundation
import SwiftUI

// This actor will contain all instances of CDContext and CDContainer that are created.
// It is used to ensure CDContext/Containers are not duplicated (two folders reading/writing to same location can cause race conditions)

@globalActor final actor CDMemoryManager {
    
    static let shared = CDMemoryManager()
        
    var activeServices: [CDService] = []

    func add(_ service: CDService) {
        checkContextIsDuplicate(context: service.context)
        checkContextIsDuplicate(context: service.context)
        checkContainerIsDuplicate(container: service.context.container)
        activeServices.append(service)
    }
    
    private func checkContextNameIsValid(context: CDContext) {
        guard context.name.isEmpty else { return }
        log("You should not initialize a CDContext without a valid name (0 characters).")
    }
    
    private func checkContextIsDuplicate(context: CDContext) {
        let activeContexts = activeServices.map({ $0.context })
        guard activeContexts.contains(context) else { return }
        log("There are duplicate instances of CDContext that have the same name: \(context.name). This may lead to unwanted behavior and data races.")
    }
    
    private func checkContainerIsDuplicate(container: CDContainer) {
        let activeContainers = activeServices.map({ $0.context.container })
        
        // Make sure there is not already an existing Directory where the Directory has a different limit.
        // This is to avoid multiple different limits on the same Directory.
        guard activeContainers.contains(container) else { return }
        log("There are multiple CDContainer created with the same Container name. This may lead to unwanted behavior and data races.")
    }
    
    private func log(_ string: String) {
        print("🚨 WARNING 🚨" + string)
    }
    
    // Statistics
    func printUsage() {
        Task {
            var contexts: [ContextStats] = []
            var containers: [ContainerStats] = []
            
            for service in activeServices {
                let contextStats = await ContextStats(service: service)
                contexts.append(contextStats)
                
                let container = service.context.container
                if var containerStats = containers.first(where: { $0.name == container.name }) {
                    // Update directory stats with folder
                    containerStats.addContext(contextStats)
                } else {
                    // Add directory stats and update stats with folder
                    var containerStats = ContainerStats(container: container)
                    containerStats.addContext(contextStats)
                    containers.append(containerStats)
                }
            }
            
            print("""
            - - - - - - - - - -
            🚀 CDService Usage:
            - - - - - - - - - -
            """)
            
            for context in contexts {
                print(context.log())
            }
            for container in containers {
                print(container.log())
            }
            print("""
            - - - - - - - - - -
            🚀 END LOG
            - - - - - - - - - -
            """)
        }
    }
    
    private struct ContextStats {
        let name: String
        let contextReads: Int
        let contextWrites: Int
        let container: String
        
        init(service: CDService) async {
            self.name = service.context.container.name + "+" + service.context.name
            self.contextReads = await service.contextReads
            self.contextWrites = await service.contextWrites
            self.container = service.context.container.name
        }
        
        func log() -> String {
        """
        🗳 CDContext
        - Context Name: \(name)
        - Context Reads: \(contextReads)
        - Context Writes: \(contextWrites)
        - Container Name: \(container)
        
        """
        }
    }
    private struct ContainerStats {
        let name: String
        var numberOfReads: Int
        var numberOfWrites: Int
        var contexts: [String]
        
        init(container: CDContainer) {
            self.name = container.name
            self.numberOfReads = 0
            self.numberOfWrites = 0
            self.contexts = []
        }
        
        mutating func addContext(_ stats: ContextStats) {
            self.numberOfReads = numberOfReads + stats.contextReads
            self.numberOfWrites = numberOfWrites + stats.contextWrites
            self.contexts = contexts + [stats.name]
        }
        
        func log() -> String {
        """
        🗳🗳🗳 CDContainer
        - Container Name: \(name)
        - Container Reads: \(numberOfReads)
        - Container Writes: \(numberOfWrites)
        - Container Contexts: \(contexts)
                    
        """
        }
    }

    
}
