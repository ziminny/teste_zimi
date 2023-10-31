//
//  JsonService.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 29/10/23.
//

import Foundation

enum JSONError:Error {
    case unknown
}


class JsonService {
    
    private let fileManager = FileManager.default
    private let jsonFileName = "zimi_network_test.json"
    private var networkName:String?
    
    func addNetwork(withNetworkName networkName:String) throws {
        self.networkName = networkName
        try self.firstSaveJson()
    }
    
    private func getDirectoryURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    private func getFullDirectoryURLWithJsonPath() -> URL {
        return self.getDirectoryURL().appendingPathComponent(jsonFileName)
    }
    
    private func makeModel(withDevices devices:[Device]) -> ZimiNetwork {
        var zimiNetwork = ZimiNetwork()
        var network = Network()
        network.name = networkName
        
        zimiNetwork.network = network
        zimiNetwork.devices = devices
        
        return zimiNetwork
    }
    
    private func makeData(withDevices devices:[Device] = []) throws -> Data {
      
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let zimiNetwork = self.makeModel(withDevices: devices)
        
        return try encoder.encode(zimiNetwork)
        
    }
    
    private func firstSaveJson() throws {
        let jsonURL = self.getFullDirectoryURLWithJsonPath()
        let data = try self.makeData()
        
        try data.write(to: jsonURL)
    }
    
    func saveAndUpdateJson(devices:[Device]) throws {
        let jsonURL = self.getFullDirectoryURLWithJsonPath()
        let data = try self.makeData(withDevices: devices)
        
        try data.write(to: jsonURL)
    }
    
    func isEmptyFileDirectory() -> Bool {
        let jsonURL = self.getFullDirectoryURLWithJsonPath()
        return !fileManager.fileExists(atPath: jsonURL.path)
    }
    
    func getModel() throws -> ZimiNetwork {
        
        let jsonURL = self.getFullDirectoryURLWithJsonPath()
        let data = try Data(contentsOf: jsonURL,options: [])
        
        let decoder = JSONDecoder()
        return try decoder.decode(ZimiNetwork.self, from: data)
    }
    
    func getDevice(id:String) throws -> Device? {
        let model = try self.getModel()
        
        return model.devices?.first(where: { device in
            return device.id == id
        })
        
    }
    
    func updateDevice(newDevice:Device) throws {
        
        let model = try self.getModel()
        
        guard let devices = model.devices else { return }
        
        var filteredDevice = devices.filter { device in
            return device.id != newDevice.id
        }
        
        filteredDevice.append(newDevice)
        
        try self.saveAndUpdateJson(devices:filteredDevice)
        
    }
    
}
