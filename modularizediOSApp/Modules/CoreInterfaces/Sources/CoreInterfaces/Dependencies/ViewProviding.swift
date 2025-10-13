//
//  File.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import SwiftUI

public protocol ViewProviding {
    associatedtype V: View
    @MainActor func make() -> V
}
