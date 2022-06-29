//
//  ContentView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/17.
//

import SwiftUI

struct ContentView: View {
    let isLaunchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var body: some View {
        NavigationView {
            if !isLaunchedBefore {
                InitView()
            } else {
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
