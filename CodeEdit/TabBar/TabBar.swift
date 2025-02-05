//
//  TabBar.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 17.03.22.
//

import SwiftUI
import WorkspaceClient

struct TabBar: View {
    var windowController: NSWindowController
    @ObservedObject var workspace: WorkspaceDocument

    var tabBarHeight = 28.0

    var body: some View {
        VStack(spacing: 0.0) {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { value in
                    HStack(alignment: .center, spacing: 0.0) {
                        ForEach(workspace.openFileItems, id: \.id) { item in
                            let isActive = workspace.selectedId == item.id

                            Button(
                                action: { workspace.selectedId = item.id },
                                label: {
                                    if isActive {
                                        TabBarItem(item: item, windowController: windowController, workspace: workspace)
                                            .background(Material.bar)
                                    } else {
                                        TabBarItem(item: item, windowController: windowController, workspace: workspace)
                                    }
                                }
                            )
                            .animation(.easeOut(duration: 0.2), value: workspace.openFileItems)
                            .buttonStyle(.plain)
                            .id(item.id)
                            .keyboardShortcut(
                                self.getTabId(fileName: item.fileName),
                                modifiers: [.command]
                            )
                        }
                    }
                    .onAppear {
                        value.scrollTo(self.workspace.selectedId)
                    }
                }
            }

            Divider()
                .foregroundColor(.gray)
                .frame(height: 1.0)
        }
        .background(Material.regular)
    }

    func getTabId(fileName: String) -> KeyEquivalent {
        for counter in 0..<9 where workspace.openFileItems.count > counter &&
        workspace.openFileItems[counter].fileName == fileName {
            return KeyEquivalent.init(
                Character.init("\(counter + 1)")
            )
        }

        return "0"
    }
}
