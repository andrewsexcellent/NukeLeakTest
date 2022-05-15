//
//  SheetModifier.swift
//
//

import Introspect
import SwiftUI
import UIKit
import SwiftUIX

struct Detents: OptionSet {
    let rawValue: Int

    static let medium = Detents(rawValue: 1 << 0)
    static let large = Detents(rawValue: 1 << 1)

    @available(iOS 15.0, *)
    var sheetDetents: [UISheetPresentationController.Detent] {
        var sheetDetents = [UISheetPresentationController.Detent]()

        if contains(.medium) {
            sheetDetents.append(.medium())
        }

        if contains(.large) {
            sheetDetents.append(.large())
        }

        return sheetDetents
    }
}

struct SheetModifier<ViewContent: View>: ViewModifier {
    @Binding var isPresented: Bool

    var onDismiss: (() -> Void)?

    var detents: Detents

    var content: () -> ViewContent

    @State private var presentingController: UIViewController!

    @State private var contentViewController: UIViewController!

    @State private var containerViewController = UIViewController()

    @State private var navigationControllerDelegateProxy = NavigationControllerDelegateProxy()

    @State private var presentationWorkItem: DispatchWorkItem?

    // swiftlint:disable:next function_body_length
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .introspectViewController { presentingController in
                    let content = self.content()
                        .introspectNavigationController { navigationController in
                            navigationController.delegate = navigationControllerDelegateProxy
                        }
                        .onDisappear {
                            onDismiss?()
                            isPresented = false
                        }
                    let contentViewController = UIHostingController(rootView: content)
                    if let sheet = containerViewController.sheetPresentationController {
                        sheet.detents = detents.sheetDetents
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.prefersEdgeAttachedInCompactHeight = true
                    }
                    if isPresented {
                        if presentingController.navigationController?.isPresenting == false {
                            presentingController.present(containerViewController, animated: true)
                        }
                        containerViewController.addChild(contentViewController)
                        containerViewController.view.addSubview(contentViewController.view)
                        contentViewController.didMove(toParent: containerViewController)
                        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            containerViewController.view.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
                            containerViewController.view.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
                            containerViewController.view.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
                            containerViewController.view.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor)
                        ])
                    }

                    navigationControllerDelegateProxy.navigationHandler = { navigationController in
                        guard let sheet = containerViewController.sheetPresentationController else {
                            return
                        }

                        if navigationController.viewControllers.count > 1 {
                            sheet.animateChanges {
                                sheet.selectedDetentIdentifier = .large
                            }
                        } else {
                            sheet.animateChanges {
                                sheet.selectedDetentIdentifier = .medium
                            }
                        }
                    }

                    self.presentingController = presentingController
                    self.contentViewController = contentViewController
                }
                .onChange(of: isPresented) { isPresented in
                    if isPresented {
                        if presentingController.navigationController?.isPresenting == false {
                            presentingController.present(containerViewController, animated: true)
                        }

                        if let view = contentViewController?.view {
                            containerViewController.addChild(contentViewController)
                            containerViewController.view.addSubview(view)
                            contentViewController.didMove(toParent: containerViewController)
                            view.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                containerViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                                containerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                containerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                containerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                            ])
                        }
                    } else {
                        presentingController.dismiss(animated: true)
                    }
                }
        } else {
            content
                .sheet(isPresented: $isPresented, onDismiss: onDismiss, content: self.content)
        }
    }
}

extension View {
    func sheet<Content: View>(isPresented: Binding<Bool>,
                              detents: Detents,
                              onDismiss: (() -> Void)? = nil,
                              content: @escaping () -> Content) -> some View {
        self.modifier(SheetModifier(isPresented: isPresented, onDismiss: onDismiss, detents: detents, content: content))
    }
}

class NavigationControllerDelegateProxy: NSObject, UINavigationControllerDelegate {
    var navigationHandler: ((UINavigationController) -> Void)?

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationHandler?(navigationController)
    }

}
