//
//  File.swift
//  
//
//  Created by Nick Sarno on 2/23/22.
//

import Foundation
import SwiftfulSaving

extension ItemEntity: IdentifiableByKey { }

struct Item: CoreDataTransformable {
    typealias Entity = ItemEntity

    var title: String
    let entity: Entity?
    
    var key: String {
        title
    }

    init(title: String) {
        self.title = title
        self.entity = nil
    }

    init?(from object: Entity) {
        guard let title = object.title else { return nil }
        self.title = title
        self.entity = object
    }
    
    mutating func update(title: String) {
        self.title = title
    }
    
    func updatingValues(forEntity entity: inout Entity) {
        entity.title = title
    }
    
}
