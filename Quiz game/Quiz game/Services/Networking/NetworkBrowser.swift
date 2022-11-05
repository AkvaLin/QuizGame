//
//  NetworkBrowser.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 05.11.2022.
//

import Foundation
import Network

class NetworkBrowser {
    
    private let browser: NWBrowser
    
    init() {
        self.browser = NWBrowser(for: .bonjour(type: "_quiz._tcp", domain: nil), using: .tcp)
    }
    
    func start(queue: DispatchQueue) {
        self.browser.browseResultsChangedHandler = { result, changed in
            //
        }
        
        self.browser.stateUpdateHandler = { state in
            switch state {
            case .ready:
                //
                print()
            case .failed(let error):
                //
                print()
            default:
                break
            }
        }
        
        browser.start(queue: queue)
    }
    
    func stop() {
        browser.cancel()
    }
}
