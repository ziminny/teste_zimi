//
//  HomeViewModel.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import Foundation
import SwiftUI

 

@MainActor
class HomeViewModel:ObservableObject {
    
    @Published var addNewNetworkIsPresent = false
    @Published var addNewDeviceIsPresent = false
    @Published var networkName = ""
    @Published var model:ZimiNetwork?

    @Published var outputNames:[String] = [""]
    @Published var infos:[String] = ["0000"]
    @Published var isItemOn:[Bool] = [false]
    
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
            if !isEmptyFileDirectory {
                self.getModel()
            }
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
        
        var channels:[Channel] = []
        
        for index in 0..<outputNames.count {
            var channel = Channel(outputName: outputNames[index],info: infos[index])
            channels.append(channel)
        }
        
       
        device.channels = channels
        device.numberOfChannel = channels.count
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
