//
//  ImagePicker.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
          let picker = UIImagePickerController()
          picker.delegate = context.coordinator
          picker.allowsEditing = true
          return picker
      }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context)
    {
        
    }
    
    func makeCoordinator() -> Coordinator {
          Coordinator(self)}
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker

            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            func imagePickerController(
                _ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
            ) {
                if let edited = info[.editedImage] as? UIImage {
                    parent.image = edited
                } else if let original = info[.originalImage] as? UIImage {
                    parent.image = original
                }
                picker.dismiss(animated: true)
            }
        }
}

