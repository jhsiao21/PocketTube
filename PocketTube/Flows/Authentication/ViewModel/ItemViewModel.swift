//
//  ItemViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/24.
//

import Foundation

enum ItemViewModelType {
    case info
    case logout
}

struct ItemViewModel {
    let viewModelType: ItemViewModelType
    let sectionTitle: String
    let itemTitle: String
    let handler: (() -> Void)?
}
