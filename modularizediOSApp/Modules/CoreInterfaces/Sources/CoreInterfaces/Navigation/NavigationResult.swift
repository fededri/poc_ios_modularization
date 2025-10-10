//
//  NavigationResult.swift
//  Core
//
//  Created by Federico Torres on 01/09/25.
//

import Foundation

public protocol NavigationResult: Codable {
    static var resultType: String { get }
}