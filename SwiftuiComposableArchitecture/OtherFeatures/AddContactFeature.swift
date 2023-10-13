//
//  AddContactFeature.swift
//  SwiftuiComposableArchitecture
//
//  Created by Mudassir Asghar on 03/10/2023.
//


import ComposableArchitecture
import SwiftUI

struct AddContactFeature: Reducer {
  struct State: Equatable {
    var contact: Contact
  }
  enum Action: Equatable {
    case cancelButtonTapped
    case saveButtonTapped
    case setName(String)
  }
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .cancelButtonTapped:
      return .none

    case .saveButtonTapped:
      return .none

    case let .setName(name):
      state.contact.name = name
      return .none
    }
  }
}

struct AddContactView: View {
  let store: StoreOf<AddContactFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
        Button("Save") {
          viewStore.send(.saveButtonTapped)
        }
      }
      .toolbar {
        ToolbarItem {
          Button("Cancel") {
            viewStore.send(.cancelButtonTapped)
          }
        }
      }
    }
  }
}

struct AddContactPreviews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AddContactView(
        store: Store(
          initialState: AddContactFeature.State(
            contact: Contact(
              id: UUID(),
              name: "Blob"
            )
          )
        ) {
          AddContactFeature()
        }
      )
    }
  }
}
