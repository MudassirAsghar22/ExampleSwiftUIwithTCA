//
//  CartItemDomain.swift
//  SwiftuiComposableArchitecture
//
//  Created by Mudassir Asghar on 06/10/2023.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        let cartItem: CartItem
    }

    enum Action: Equatable {
        case deleteCartItem(product: Product)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .deleteCartItem:
            return .none
        }
    }
}
