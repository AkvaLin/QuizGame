//
//  NetworkServer.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 05.11.2022.
//

import Foundation
import Network

protocol NetworkServerDelegate: AnyObject
{
    func serverBecameReady()
    func connectionOpened(id: Int)
    func connectionReceivedData(id: Int, data: Data)
}

class NetworkServer: NetworkConnectionDelegate
{
    weak var delegate: NetworkServerDelegate?
    let listener: NWListener
    
    private var serverQueue: DispatchQueue?
    
    private var connectionsByID: [Int: NetworkConnection] = [:]
    private var namesByID: [Int: String] = [:]
    
    init(name: String?)
    {
        self.listener = try! NWListener(using: .tcp)
        self.listener.service = NWListener.Service(name: name, type: "_quiz._tcp")
    }
    
    func start(queue: DispatchQueue) throws
    {
        self.serverQueue = queue
        
        self.listener.stateUpdateHandler = self.onStateDidChange(to:)
        self.listener.newConnectionHandler = self.onNewConnectionAccepted(nwConnection:)
        self.listener.start(queue: queue)
    }

    func onStateDidChange(to newState: NWListener.State)
    {
        switch newState {
        case .setup:
            break
        case .waiting:
            break
        case .ready:
            self.delegate?.serverBecameReady()
            break
        case .failed(let error):
            print("server did fail, error: \(error)")
            self.stop()
        case .cancelled:
            break
        default:
            break
        }
    }

    private func onNewConnectionAccepted(nwConnection: NWConnection)
    {
        let connection = NetworkConnection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.delegate = self
        connection.start(queue: self.serverQueue!)
        
        print("Server accepted connection \(connection)")
    }
    
    func addNewName(id: Int, name: String) {
        self.namesByID[id] = name
    }

    func stop()
    {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        closeAllConnections()
    }

    private func heartbeat() {
        let timestamp = Date()
        print("server heartbeat, timestamp: \(timestamp)")
        for connection in self.connectionsByID.values {
            let data = "heartbeat, connection: \(connection.id), timestamp: \(timestamp)\r\n"
            connection.send(data: Data(data.utf8))
        }
    }
    
    func closeAllConnections()
    {
        for connection in self.connectionsByID.values{
            connection.close()
        }
        // Theoretically next call shouldn't have to remove anything as the connections
        // removed them selves by calling our connectionClosed function
        self.connectionsByID.removeAll()
    }
    
    func sendToAll(data: Data)
    {
        for conn in self.connectionsByID {
            conn.value.send(data: data)
        }
    }
    
    func sendTo(id: Int, data: Data)
    {
        self.connectionsByID[id]?.send(data: data)
    }
    
    func sendToAllExcept(id: Int, data: Data)
    {
        for conn in self.connectionsByID
        {
            if (conn.value.id != id)
            {
                conn.value.send(data: data)
            }
        }
    }
    
    var port: NWEndpoint.Port?
    {
        get {
            return self.listener.port
        }
    }
    
    // MARK: NetworkConnectionDelegate
    func connectionOpened(connection: NetworkConnection)
    {
        print("Server connection opened")
        self.delegate?.connectionOpened(id: connection.id)
    }
    
    func connectionClosed(connection: NetworkConnection)
    {
        self.connectionsByID.removeValue(forKey: connection.id)
        self.namesByID.removeValue(forKey: connection.id)
        print("Server connection closed (\(connection))")
    }
    
    func connectionError(connection: NetworkConnection, error: Error)
    {
        print("Server connection error: \(error) (\(connection))")
    }
    
    func connectionReceivedData(connection: NetworkConnection, data: Data)
    {
        self.delegate?.connectionReceivedData(id: connection.id, data: data)
    }
}
