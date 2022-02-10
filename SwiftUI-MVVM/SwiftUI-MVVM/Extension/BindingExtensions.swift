//
//  BindingExtensions.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 09/02/22.
//

import Foundation
import SwiftUI

extension Binding {
    init<ObjectType: AnyObject>(
        to path: ReferenceWritableKeyPath<ObjectType, Value>,
        on object: ObjectType
    ) {
        self.init(
            get: { object[keyPath: path] },
            set: { object[keyPath: path] = $0 }
        )
    }
}
