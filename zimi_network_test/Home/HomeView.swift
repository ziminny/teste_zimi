//
//  ContentView.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel:HomeViewModel = .init()
    
    var body: some View {
        VStack {
            
            if let model = viewModel.model {
              
                NavigationView {
                    VStack(alignment:.leading) {

                        HStack {
                            VStack(alignment:.leading) {
                                // MARK: Header
                                Text(model.network?.name ?? "Unknown name")
                                    .font(.system(size: 16,weight: .semibold))
                                Button(action: {
                                    viewModel.addNewDeviceIsPresent.toggle()
                                }, label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add new device")
                                    }
                                })
                                .offset(y:4)
                                .sheet(isPresented: $viewModel.addNewDeviceIsPresent, content: {
                                    self.addNewDevice()
                                })
                            }
                            Spacer()
                        }.padding(.top) // End header
                        
                        if let devices = viewModel.model?.devices {
           
                            VStack(alignment:.leading) {
                                List(devices, id:\.id) { device in
     
                                    Section(device.deviceType?.rawValue ?? "sem nome") {
                                        if let channels = device.channels {
                                            HStack(alignment:.center) {
                                                VStack(alignment:.leading,spacing:8) {
                                                    ForEach(channels, id:\.id) { channel in
                                                        VStack {
                                                            Button {
                                                                 
                                                            } label: {
                                                                HStack {
                                                                    if let deviceType = device.deviceType {
                                                                        // TODO: Logical on of here
                                                                        Image(systemName:deviceType.icon.on)
                                                                            .font(.system(size: 24,weight:.semibold))
                                                                            .foregroundStyle(Color.red)
                                                                    }
                                                                    
                                                                    Text(channel.outputName ?? "Unknown name")
                                                                }
                                                            }

                                                        }
                                                    }
                                                }
                                                Spacer()
                                                NavigationLink(destination: ConfigurationView(device: device)) {}
                                                
                                            }
                                            
        
                                            
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                            }
                            .padding(.top)
                            .onAppear {
                                model.devices?.forEach({ item in
                                    print(item.channels)
                                })
                            }
                        }
                        
                        Spacer()
                    }.padding()
                }
            } else {
                EmptyHomeView()
                  .environmentObject(viewModel)

            }
 
        }
        
    }
    
    func addNewDevice() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    // MARK: Header
                    HStack {
                        // FIX: All get las item array
                        Text("Add new device")
                            .font(.system(size: 16,weight: .semibold))
                        Spacer()
                        Button(action: {
                            
                           // TODO: aqui
                          
                            viewModel.outputNames.append("")
                            viewModel.isItemOn.append(false)
                            viewModel.infos.append("0000")
                            
                            let currentItem = viewModel.isItemOn[viewModel.isItemOn.count - 2]
                            
                            if currentItem {
                                viewModel.infos[viewModel.infos.count - 1] = "00F3"
                            }
                            
                            viewModel.infos.forEach { res in
                                print(res)
                            }

                            
                          
                        }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 16,weight: .semibold))
                        })
                    } // End Header
                    
                    // MARK: Device type
                    VStack(alignment:.leading) {
                        
                        Text("Device type:")
                            .font(.system(size: 14,weight: .regular))
                        
                        HStack {
                        ForEach(DeviceType.allCases,id:\.rawValue) { item in
                          
                                HStack {
                                    ZStack {
                                        Circle()
                                            .frame(width:14)
                                        Circle()
                                            .frame(width:12)
                                            .foregroundStyle(viewModel.selectedDeviceType == item ? .sucess : .black)
                                    }.onTapGesture {
                                        viewModel.selectedDeviceType = item
                                    }
                                    Text(item.rawValue)
                                        .font(.system(size: 14,weight: .regular))
                                }
                                
                                
                            }
                        }
                        

                    }.padding(.top) // End Device type
                    
                    // MARK: Device item
  
                        
                    ScrollView(showsIndicators: false) {
                        ForEach(0..<viewModel.outputNames.count,id: \.self) { index in
                            VStack {
                               
                                // MARK: Output name
                                VStack(alignment:.leading) {
                                    Text("Output name:")
                                        .font(.system(size: 14,weight: .regular))
                                    
                                    TextField("Output name", text: $viewModel.outputNames[index])
                                        .textFieldStyle(.roundedBorder)
                                         
                                }
                               // END Output name
                                
                                // MARK: Aoto off
                                VStack(alignment:.leading) {
                                    Text("Auto off")
                                        .font(.system(size: 14,weight: .regular))
                                    HStack {
                                       
                                        Toggle(isOn: $viewModel.isItemOn[index], label: {
                                            Text("60 min")
                                        })
                                    }
                                }
                                .padding(.top) // END Auto off
                                
                            }
                            .padding()
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }

                   
                    Button(action: {
                        viewModel.addNewDevice()
                    }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 16,weight: .semibold))
                                Text("ADD DEVICE")
                                Spacer()
                            }
                        }).buttonStyle(BorderedProminentButtonStyle())
                    

                        
                    
                }
                
                Spacer()
            }
            Spacer()
        }.padding()
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
