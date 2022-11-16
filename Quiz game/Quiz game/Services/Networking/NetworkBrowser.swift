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
    
    func start(queue: DispatchQueue, completion: @escaping ([RoomModel]) -> Void) {
        self.browser.browseResultsChangedHandler = { (result, changed) in
            var completionArr = [RoomModel]()
            for room in result {
                if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = room.endpoint {
                    completionArr.append(RoomModel(name: name, maxPlayersAmount: 0, endPoint: room.endpoint))
                }
            }
            completion(completionArr)
        }
        
        self.browser.stateUpdateHandler = { state in
            switch state {
            case .ready:
                //
                print("Browser ready")
            case .failed(let error):
                //
                print("Browser failed with error: \(error)")
            default:
                break
            }
        }
        
        browser.start(queue: queue)
    }
    
    func cancel() {
        browser.cancel()
    }
}
