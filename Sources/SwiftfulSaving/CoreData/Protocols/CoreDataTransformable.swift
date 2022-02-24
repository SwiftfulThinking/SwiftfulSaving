//
//  CoreDataTransformable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/7/22.
//

import Foundation
import CoreData

public protocol IdentifiableByKey: NSManagedObject {
     var key: String? { get set }
}

public protocol CoreDataTransformable {
    associatedtype Entity: IdentifiableByKey
    init?(from: Entity)
    func updatingValues(forEntity: inout Entity)
    var entity: Entity? { get }
}
