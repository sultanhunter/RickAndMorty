//
//  SettingsView.swift
//  RickAndMorty
//
//  Created by Sultan on 14/04/24.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewVM

    init(viewModel: SettingsViewVM) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(6)
                        .foregroundStyle(.primary)
                        .background(Color(viewModel.iconColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(4)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: .init(cellViewModels: SettingsOptions.allCases.compactMap {
        SettingsCellViewModel(type: $0) { _ in
        }
    }))
}
