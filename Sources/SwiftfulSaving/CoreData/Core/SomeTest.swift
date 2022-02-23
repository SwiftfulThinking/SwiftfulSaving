//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sarno on 2/23/22.
//

import SwiftUI

struct SwiftUIViewadsf: View {
    
    let service: CDService
    
    init() {
        let container = CDContainer(name: "ItemContainer")
        self.service = CDService(container: container, contextName: "MyViewModel", cacheLimitInMB: nil)
    }

    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                let item = Item(title: "test")
                Task {
                    try? await service.save(object: item, key: "test")
                }
            }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewadsf()
    }
}
