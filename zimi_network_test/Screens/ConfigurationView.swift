//
//  ConfigurationView.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 30/10/23.
//

import SwiftUI

struct ConfigurationView: View {
    
    let deviceId:String
    
    @State var infos:[String] = []
    
    @StateObject var viewModel:ConfigurationViewModel = .init()
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.device?.deviceType?.rawValue ?? "Unknown device type")
                    .font(.system(size: 18,weight: .semibold,design: .rounded))
                Spacer()
            }
            .padding(.bottom)
            
            if let channels = viewModel.device?.channels {
                ForEach(channels,id:\.id) { channel in
                    VStack(spacing:16) {
                        HStack(spacing:16) {
                            Text(channel.outputName ?? "Unknown output name")
                                .font(.system(size: 15,weight: .semibold,design: .rounded))
                            Spacer()
                            // TODO: Logical on of here
                            if let icon = viewModel.device?.deviceType?.icon {
                                Image(systemName:icon.on)
                                    .font(.system(size: 15,weight:.semibold))
                                    .foregroundStyle(Color.red)
                            }

                        }
                        HStack {
                            Text("Auto off")
                                .font(.system(size: 14,weight: .regular))
                            Spacer()
                            
                            Toggle(isOn: .constant(Utils.outputState(withOutput: channel.info ?? "00")), label: {

                           }).scaleEffect(0.7)
                               .frame(width: 60, height: 30)
                               .offset(x:10)
                        }
                        .offset(y:-8)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .offset(y:-8)
                        
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.getCurrentDevice(id: deviceId)
        }
        .padding()

    }
}

#Preview {
    ConfigurationView(deviceId: "")
}
