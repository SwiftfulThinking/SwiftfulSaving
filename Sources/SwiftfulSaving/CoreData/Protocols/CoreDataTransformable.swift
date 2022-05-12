//
//  CoreDataTransformable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/7/22.
//

import Foundation
import CoreData

public protocol CoreDataIdentifiable: NSManagedObject {
     var key: String? { get set }
}

public protocol CoreDataTransformable {
    associatedtype Entity: CoreDataIdentifiable
    init?(from: Entity)
    func updatingValues(forEntity: inout Entity)
}
