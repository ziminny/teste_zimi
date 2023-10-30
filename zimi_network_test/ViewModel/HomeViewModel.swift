//
//  HomeViewModel.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import Foundation
import SwiftUI

struct OutputValus {
    let id = UUID().uuidString
    let outputValue:Binding<String>
    let state:Binding<Bool>
}

@MainActor
class HomeViewModel:ObservableObject {
    
    @Published var addNewNetworkIsPresent = false
    @Published var addNewDeviceIsPresent = false
    @Published var networkName = ""
    @Published var model:ZimiNetwork?
 
    @Published var outputNames:[OutputValus] = []
    
    @Published var selectedDeviceType:DeviceType = .dimmer
    
    var inputValue:String = ""
    var tootlgeValue:Bool = false
    
    private let jsonService:JsonService
    
    var isEmptyFileDirectory: Bool {
        return jsonService.isEmptyFileDirectory()
    }
    
    init() {
        jsonService = JsonService()
        
        if !isEmptyFileDirectory {
            self.getModel()
        }
    }
    
    func toggleNetworkAlert() {
        addNewNetworkIsPresent.toggle()
    }
        
    func addNetworkName() {
        do {
            if networkName.isEmpty {
                throw JSONError.unknown
            }
            try jsonService.addNetwork(withNetworkName: self.networkName)
        } catch {
            print("ERROR save json -> \(error)")
        }
    }
    
    func getModel() {
        do {
            self.model = try jsonService.getModel()
 
           
        } catch {
            print("ERROR GET json -> \(error)")
        }
    }
    
    func addNewDevice() {
        
        var devices:[Device] = []
        if let savedDevices = try? self.jsonService.getModel().devices  {
            devices = savedDevices
        }
        var device = Device()
        
        var outputs:[String] = []
        var infos:[String] = []
        
        outputNames.forEach { item in
            outputs.append(item.outputValue.wrappedValue)
            if item.state.wrappedValue {
                infos.append("00F3")
            } else {
                infos.append("0000")
            }
            
        }
       
        device.outputNames = outputs
        device.info = infos
        device.numberOfChannel = outputs.count + (self.model?.devices?.count ?? 0)
        device.deviceType = selectedDeviceType
        
        devices.append(device)
        
        self.model?.devices = devices
 
        
        do {
            try self.jsonService.saveAndUpdateJson(devices: devices)
        } catch {
            print("ERROR \(error)")
        }
        
        devices = []
        addNewDeviceIsPresent.toggle()
    }
    
}
