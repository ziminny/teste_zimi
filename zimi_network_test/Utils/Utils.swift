//
//  Utils.swift
//  zimi_network_test
//
//  Created by Vagner Oliveira on 30/10/23.
//

import Foundation

class Utils {
    
    static func outputState(withOutput output:String) -> Bool {
        print(output)
        guard output.count != 4 else { return false }
        
        let outputState = output.prefix(2)
        
        if outputState == "00" { return false }
            
        return true
    }
    
}
