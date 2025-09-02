import SwiftUI
import PhotosUI

struct ImagePicker: View {
  @Binding var selectedImage: UIImage?
  @State private var selectedItem: PhotosPickerItem?

  var body: some View {
    PhotosPicker(selection: $selectedItem, matching: .images) {
      ZStack {
        Circle()
          .fill(.neutral800)
          .frame(width: 96, height: 96)

        if let selectedImage {
          Image(uiImage: selectedImage)
            .resizable()
            .scaledToFill()
            .frame(width: 96, height: 96)
            .clipShape(Circle())
        } else {
          Image(.iconAvator)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundStyle(.primary500)
        }
      }
    }
    .onLongPressGesture {
      selectedImage = nil
      selectedItem = nil
    }
    .onChange(of: selectedItem) { _, newItem in
      Task {
        if let data = try? await newItem?.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
          await MainActor.run {
            selectedImage = image
          }
        }
      }
    }
  }
}

#Preview {
  VStack {
    ImagePicker(selectedImage: .constant(nil))
    ImagePicker(selectedImage: .constant(.img1))
  }
}
