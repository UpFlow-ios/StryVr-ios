//
//  DocumentPicker.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//


import SwiftUI
import UniformTypeIdentifiers

/// iOS-native video file picker using UIDocumentPickerViewController
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let selectedURL = urls.first {
                parent.videoURL = selectedURL
            } else {
                // Handle the case where no document was selected
                parent.videoURL = nil
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle the case where the document picker was cancelled
            parent.videoURL = nil
        }
    }
}
```
