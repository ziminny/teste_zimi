//
//  EmptyHomeView.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import SwiftUI

struct EmptyHomeView: View {
    
    @EnvironmentObject var viewModel:HomeViewModel
    
    var body: some View {
        VStack {
            
            // MARK: Top
            HStack {
                VStack(alignment:.leading) {
                    Text("Hello,")
                        .font(.system(size: 20,weight: .semibold))
                    Text("You don't have any network yet")
                }
                Spacer()
            }
            
            Spacer()
            
            // MARK: Middle
            VStack {
                Button(action: {
                    viewModel.toggleNetworkAlert()
                }, label: {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 54,weight: .bold))
                        Text("Add network")
                    }
                })
                .alert("Add new Network", isPresented: $viewModel.addNewNetworkIsPresent) {
                    TextField("Network name", text: $viewModel.networkName)
                    Button("Add") {
                        viewModel.addNetworkName()
                    }
                    Button("Cancel") {
                        viewModel.toggleNetworkAlert()
                    }
                } message: {
                    Text("Example: Room")
                }

            }
            .foregroundStyle(.sucess)
            
            Spacer()
            
            // MARK: Bottom
            VStack {
                Text("After building a network you can add as many devices as you want, each device can have a maximum of 4 channels")
            }
            
        }
        .padding()
    }
}

#Preview {
    EmptyHomeView()
        .environmentObject(HomeViewModel())
}
