//
//  DocumentPicker.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  📁 Native Video File Picker with Secure Binding & HIG Compliance
//

import SwiftUI
import UniformTypeIdentifiers

/// A secure, reusable SwiftUI wrapper for UIDocumentPickerViewController (for video files only).
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [UTType.movie]

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        picker.shouldShowFileExtensions = true

        return picker
    }

    func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {
        // No update logic needed here for one-time picker
    }

    // MARK: - Coordinator to handle file selection

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else {
                parent.videoURL = nil
                return
            }

            // Security-scoped resource access (required for sandboxed access)
            if selectedURL.startAccessingSecurityScopedResource() {
                parent.videoURL = selectedURL
                selectedURL.stopAccessingSecurityScopedResource()
            } else {
                // Log or handle the failure to access the resource
                parent.videoURL = nil
            }
        }

        func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
            parent.videoURL = nil
        }
    }
}
