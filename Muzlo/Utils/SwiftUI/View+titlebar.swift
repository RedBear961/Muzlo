//
//  HostingWindow.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public extension View {

	func titlebar(visibility: UITitlebarTitleVisibility) -> some View {
		background(HostingWindow { window in
			if let titlebar = window?.windowScene?.titlebar {
				titlebar.titleVisibility = visibility
				if visibility == .hidden {
					titlebar.toolbar = nil
				}
			}
		})
	}
}

private struct HostingWindow: UIViewRepresentable {

	let onAppear: (UIWindow?) -> ()

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		Task { [weak view] in onAppear(view?.window) }
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {}
}
