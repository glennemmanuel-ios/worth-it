//
// RemoteImage.swift
// WorthIt
//
// Created by Glen Emmanuel Solo on 9/10/25
//


import SwiftUI

struct RemoteImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL

    var body: some View {
        Group {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Failed to load image")
            }
        }
        .onAppear {
            loader.load(from: url)
        }
        .onChange(of: url) { newValue in
            loader.load(from: newValue)
        }
    }
}
