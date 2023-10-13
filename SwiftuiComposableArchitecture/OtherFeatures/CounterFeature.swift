//
//  CounterFeature.swift
//  SwiftUITestRun
//
//  Created by Mudassir Asghar on 26/09/2023.
//

import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {

    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
        @PresentationState var contacts: ContactsFeature.State?
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
        case contactButtonTapped
    }

    enum CancelID {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none

        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none

        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true

            return .run { [count = state.count] send in
                try await send(.factResponse(self.numberFact.fetch(count)))
            }

        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none

        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()

            if state.isTimerRunning {
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }.cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }

        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none

        case .contactButtonTapped:
            state.contacts = ContactsFeature.State (
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr"),
                ]
            )
            return .none
        }
    }
}


struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("\(viewStore.count)")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                    HStack {
                        Button("-") {
                            viewStore.send(.decrementButtonTapped)
                        }
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)

                        Button("+") {
                            viewStore.send(.incrementButtonTapped)
                        }
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                    }

                    Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
                        viewStore.send(.toggleTimerButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)

                    Button("Fact") {
                        viewStore.send(.factButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)

                    if viewStore.isLoading {
                        ProgressView()
                    } else if let fact = viewStore.fact {
                        Text(fact)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    Button("Move To Contacts Feature") {
                        viewStore.send(.contactButtonTapped)
                    }.font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct CounterPreview: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(initialState: CounterFeature.State()) {
                CounterFeature()
            }
        )
    }
}
