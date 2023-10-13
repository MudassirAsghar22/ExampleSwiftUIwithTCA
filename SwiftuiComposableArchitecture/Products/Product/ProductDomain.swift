//
//  ProductDomain.swift
//  SwiftuiComposableArchitecture
//
//  Created by Mudassir Asghar on 05/10/2023.
//

import Foundation
import ComposableArchitecture

struct ProductDomain: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var addToCartState = AddToCartDomain.State()

        var count: Int {
            get { addToCartState.count }
            set { addToCartState.count = newValue }
        }
    }

    enum Action: Equatable {
        case addToCart(AddToCartDomain.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.addToCartState, action: /ProductDomain.Action.addToCart) {
            AddToCartDomain()
        }
        
        Reduce { state, action in
            switch action {
            case .addToCart(.didTapPlusButton):
                return .none
            case .addToCart(.didTapMinusButton):
                state.addToCartState.count = max(0, state.addToCartState.count)
                return .none
            }
        }
    }

}
