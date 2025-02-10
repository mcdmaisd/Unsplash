//
//  BaseViewModel.swift
//  Unsplash
//
//  Created by ilim on 2025-02-10.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
