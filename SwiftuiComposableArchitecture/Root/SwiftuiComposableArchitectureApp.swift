//
//  SwiftUITestRunApp.swift
//  SwiftUITestRun
//
//  Created by Mudassir Asghar on 11/08/2023.
//

import SwiftUI

import ComposableArchitecture
import SwiftUI

@main
struct SwiftuiComposableArchitectureApp: App {

  var body: some Scene {
    WindowGroup {
        RootView(
            store: Store(
                initialState: RootDomain.State(),
                reducer: {
                    RootDomain.live
                }
            )
        )
    }
  }
}
