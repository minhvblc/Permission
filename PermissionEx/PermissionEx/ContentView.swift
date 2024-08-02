//
//  ContentView.swift
//  PermissionEx
//
//  Created by minh on 26/7/24.
//
import SwiftUI
import Permission

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                await AppPermission.photoVideo().requestPermission()
            }
        }
    }
}

#Preview {
    ContentView()
}
