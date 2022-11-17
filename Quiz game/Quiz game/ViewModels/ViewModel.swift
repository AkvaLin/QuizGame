//
//  ViewModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation
import Network

class ViewModel: ObservableObject {
    
    @Published var roomModel = [RoomModel]()
    @Published var quizModel = [QuizModel]()
    @Published var currentRoom: RoomModel? = nil
    
    private var browser = NetworkBrowser()
    private var server: NetworkServer?
    private var connection: NetworkConnection?
    
    init(quizModel: [QuizModel] = [QuizModel]()) {
        self.quizModel = quizModel
    }
    
    func startBrowsing() {
        browser.start(queue: DispatchQueue.main) { [weak self] (completion) in
            self?.roomModel = completion
        }
    }
    
    func cancelBrowsing() {
        browser.cancel()
        roomModel = [RoomModel]()
    }
    
    func startServer(name: String) {
        server = NetworkServer(name: name)
        server?.delegate = self
        try? server?.start(queue: DispatchQueue(label: "Server Queue"))
    }
    
    func stopServer() {
        server?.stop()
        server = nil
    }
    
    func startConnection(endPoint: NWEndpoint) {
        connection = NetworkConnection(nwConnection: NWConnection(to: endPoint, using: .tcp))
        connection?.delegate = self
        connection?.start(queue: DispatchQueue(label: "Client Queue"))
        guard let data = try? JSONEncoder().encode(HelloMessage(name: UserDefaults.standard.string(forKey: "playerName") ?? "Player")) else { return }
        connection?.send(data: data)
    }
    
    func updateData() {

    }
}

// MARK: - Delegates

extension ViewModel: NetworkConnectionDelegate {
    func connectionOpened(connection: NetworkConnection) {}
    
    func connectionClosed(connection: NetworkConnection) {}
    
    func connectionError(connection: NetworkConnection, error: Error) {}
    
    func connectionReceivedData(connection: NetworkConnection, data: Data) {
        guard let messageType = try? JSONDecoder().decode(MessageType.self, from: data) else { return }
        switch messageType.messageType {
        case "players":
            break
        case "question":
            break
        case "results":
            break
        default:
            break
        }
    }
}

extension ViewModel: NetworkServerDelegate {
    func serverBecameReady() {}
    
    func connectionOpened(id: Int) {}
    
    func connectionReceivedData(id: Int, data: Data) {
        print(id)
        guard let messageType = try? JSONDecoder().decode(MessageType.self, from: data) else { return }
        switch messageType.messageType {
        case "hello":
            guard let message = try? JSONDecoder().decode(HelloMessage.self, from: data) else { return }
            server?.addNewName(id: id, name: message.name)
        case "answer":
            guard let message = try? JSONDecoder().decode(AnswerMessage.self, from: data) else { return }
            server?.addNewAnswer(id: id, answer: message.answer)
        default:
            break
        }
    }
}
