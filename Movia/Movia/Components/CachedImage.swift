//
//  CachedImage.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct CachedImage: View {
    let url: String
    let cornerRadius: CGFloat
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                Color.gray.opacity(0.2)
            } else {
                Color.gray.opacity(0.2)
                    .onAppear { loadImage() }
            }
        }
        .cornerRadius(cornerRadius)
        .clipped()
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(url) {
            self.image = cachedImage
            return
        }
        
        guard let imageURL = URL(string: url) else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            ImageCache.shared.add(downloadedImage, for: url)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
                self.isLoading = false
            }
        }.resume()
    }
}
