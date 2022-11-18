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
    @Published var showQuestionView: Bool = false
    @Published var showResultsView: Bool = false
    @Published var alertError: Bool = false
    
    private var browser = NetworkBrowser()
    private var server: NetworkServer?
    private var connection: NetworkConnection?
    
    private var id: UUID?
    private var questions: QuizModel?
    
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
        server = NetworkServer(name: name, maxConnectionsAmount: currentRoom?.maxPlayersAmount ?? 0)
        server?.delegate = self
        try? server?.start(queue: DispatchQueue(label: "Server Queue"))
        id = UUID()
        server?.addNewName(id: id?.hashValue ?? -1, name: UserDefaults.standard.string(forKey: "playerName") ?? "Host")
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
    
    func cancelConnection() {
        connection?.close()
        connection = nil
    }
    
    func startGame(time: Double) {
        questions?.questionsModel.forEach { question in
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + time, execute: {
                let model = QuestionMessage(question: question.question,
                                           firstAnswer: question.firstAnswer,
                                           secondAnswer: question.secondAnswer,
                                           thirdAnswer: question.thirdAnswer,
                                           fourthAnswer: question.fourthAnswer,
                                           answer: question.answer)
                guard let data = try? JSONEncoder().encode(model) else { return }
                self.server?.sendToAll(data: data)
            })
        }
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
            guard let message = try? JSONDecoder().decode(PlayersMessage.self, from: data) else { return }
            DispatchQueue.main.async {
                self.currentRoom?.playersAmount = Int(message.playersAmount) ?? 0
                self.currentRoom?.maxPlayersAmount = Int(message.maxPlayersAmount) ?? 0
                self.currentRoom?.players = message.playersName
            }
        case "question":
            guard let message = try? JSONDecoder().decode(QuestionMessage.self, from: data) else { return }
            showQuestionView = true
        case "results":
            guard let message = try? JSONDecoder().decode(ResultsMessage.self, from: data) else { return }
            showResultsView = true
        case "accessDenied":
            DispatchQueue.main.async {
                self.alertError = true
            }
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
            server?.sendToAllPlayersData() { playersData in
                guard let players = try? JSONDecoder().decode(PlayersMessage.self, from: playersData) else { return }
                DispatchQueue.main.async {
                    self.currentRoom?.playersAmount = Int(players.playersAmount) ?? 0
                    self.currentRoom?.maxPlayersAmount = Int(players.maxPlayersAmount) ?? 0
                    self.currentRoom?.players = players.playersName
                }
            }
        case "answer":
            guard let message = try? JSONDecoder().decode(AnswerMessage.self, from: data) else { return }
            server?.addNewAnswer(id: id, answer: message.answer)
        default:
            break
        }
    }
    
    func connectionClosedUIUpdate(data: Data) {
        guard let players = try? JSONDecoder().decode(PlayersMessage.self, from: data) else { return }
        DispatchQueue.main.async {
            self.currentRoom?.playersAmount = Int(players.playersAmount) ?? 0
            self.currentRoom?.maxPlayersAmount = Int(players.maxPlayersAmount) ?? 0
            self.currentRoom?.players = players.playersName
        }
    }
}
