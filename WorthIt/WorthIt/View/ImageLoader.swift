//
// ImageLoader.swift
// WorthIt
//
// Created by Glen Emmanuel Solo on 9/10/25
//


import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = true

    private var cancellable: AnyCancellable?

    func load(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
                self?.isLoading = false
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
