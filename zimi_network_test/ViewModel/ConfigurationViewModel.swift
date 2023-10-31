//
//  ConfigurationViewModel.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 30/10/23.
//

import Foundation

class ConfigurationViewModel:ObservableObject {
    
    private let jsonService:JsonService
    @Published var device:Device?
    
    init() {
        jsonService = JsonService()
    }
    
    func getCurrentDevice(id:String) {
        do {
            self.device = try jsonService.getDevice(id: id)
        } catch {
            print("Error \(error)")
        }
    }
    
    func updateDevice(device:Device) {
        do {
          try jsonService.updateDevice(newDevice: device)
        } catch {
            print("Error \(error)")
        }
    }
}
