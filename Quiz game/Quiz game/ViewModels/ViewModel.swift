//
//  ViewModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation
import Network
import CoreData

class ViewModel: ObservableObject {
    
    @Published var roomModel = [RoomModel]()
    @Published var quizModel = [QuizModel]()
    @Published var currentRoom: RoomModel? = nil
    @Published var currentQuestion: QuestionModel? = nil
    @Published var results: [ResultsModel] = []
    @Published var showQuestionView: Bool = false
    @Published var showResultsView: Bool = false
    @Published var showLobbyView: Bool = false
    @Published var alertError: Bool = false
    @Published var showEndGameAlert: Bool = false
    
    private var browser = NetworkBrowser()
    private var server: NetworkServer?
    private var connection: NetworkConnection?
    private var timer: Timer? = nil
    private var currentIndex: Int = 0
    
    private var id: UUID?
    private var questions: QuizModel?
    
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        if !UserDefaults.standard.hasLaunched {
            loadQuiz()
        }
        fetchData()
        UserDefaults.standard.hasLaunched = true
    }
    
    // MARK: - CoreData
    
    private func fetchData() {
        let request = NSFetchRequest<Quiz>(entityName: "Quiz")
        
        do {
            let fetched = try container.viewContext.fetch(request)
            var model = [QuizModel]()
            for quiz in fetched {
                guard let name = quiz.name else { return }
                guard let id = quiz.id else { return }
                guard let questions = quiz.questions?.allObjects as? [Questions] else { return }
                var questionModel = [QuestionModel]()
                for question in questions {
                    questionModel.append(QuestionModel(question: question.question ?? "error",
                                                       firstAnswer: question.firstAnswer ?? "error",
                                                       secondAnswer: question.secondAnswer ?? "error",
                                                       thirdAnswer: question.thirdAnswer ?? "error",
                                                       fourthAnswer: question.fourthAnswer ?? "error",
                                                       answer: question.answer ?? "error")
                    )
                }
                model.append(QuizModel(id: id, name: name, questionsModel: questionModel))
            }
            quizModel = model
            self.objectWillChange.send()
        } catch let error {
            print("Fetching error: \(error.localizedDescription)")
        }
    }
    
    func addData(quizModel: QuizModel) {
        let newQuiz = Quiz(context: container.viewContext)
        newQuiz.name = quizModel.name
        newQuiz.id = quizModel.id
        for question in quizModel.questionsModel {
            let newQuestion = Questions(context: container.viewContext)
            newQuestion.question = question.question
            newQuestion.firstAnswer = question.firstAnswer
            newQuestion.secondAnswer = question.secondAnswer
            newQuestion.thirdAnswer = question.thirdAnswer
            newQuestion.fourthAnswer = question.fourthAnswer
            newQuestion.answer = question.answer
            newQuiz.addToQuestions(newQuestion)
        }
        saveData()
    }
    
    func updateData(id: UUID, name: String, questions: [QuestionModel]) {
        let request = NSFetchRequest<Quiz>(entityName: "Quiz")
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        let results = try? container.viewContext.fetch(request)
        
        results?.first?.name = name
        results?.first?.questions = NSSet()
        for question in questions {
            let newQuestion = Questions(context: container.viewContext)
            newQuestion.question = question.question
            newQuestion.firstAnswer = question.firstAnswer
            newQuestion.secondAnswer = question.secondAnswer
            newQuestion.thirdAnswer = question.thirdAnswer
            newQuestion.fourthAnswer = question.fourthAnswer
            newQuestion.answer = question.answer
            results?.first?.addToQuestions(newQuestion)
        }
        saveData()
    }
    
    func deleteQuiz(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let id = quizModel[index].id
        
        let request = NSFetchRequest<Quiz>(entityName: "Quiz")
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        guard let result = try? container.viewContext.fetch(request).first else { return }
        
        container.viewContext.delete(result)
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchData()
        } catch let error {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UserDefaults
    
    func loadQuiz() {
        QuizModel.defaultQuiz.forEach { model in
            addData(quizModel: model)
        }
    }
    
    // MARK: - Networking
    
    func setQuestions(quizModel: QuizModel) {
        self.questions = quizModel
    }
    
    // MARK: Browsing
    
    func startBrowsing() {
        browser.start(queue: DispatchQueue.main) { (completion) in
            self.roomModel = completion
        }
    }
    
    func cancelBrowsing() {
        browser.cancel()
        roomModel = [RoomModel]()
    }
    
    // MARK: Server
    
    func startServer(name: String) {
        server = NetworkServer(name: name, maxConnectionsAmount: currentRoom?.maxPlayersAmount ?? 0)
        server?.delegate = self
        try? server?.start(queue: DispatchQueue(label: "Server Queue"))
        id = UUID()
        self.currentRoom?.players = [UserDefaults.standard.string(forKey: "playerName") ?? "Host"]
        server?.addNewName(id: id?.hashValue ?? -1, name: UserDefaults.standard.string(forKey: "playerName") ?? "Host")
    }
    
    func stopServer() {
        server?.stop()
        server = nil
    }
    
    // MARK: Connection
    
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
    
    func sendAnswer(answer: Bool) {
        
        if server != nil {
            server?.addNewAnswer(id: id?.hashValue ?? -1, answer: answer)
        } else {
            guard let data = try? JSONEncoder().encode(AnswerMessage(answer: answer)) else { return }
            connection?.send(data: data)
        }
    }
    
    // MARK: Gameplay networking
    
    func startGame(time: Double) {
        timerAction()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: time,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true
            )
        }
    }
    
    func cancelTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.currentIndex = 0
    }
    
    @objc func timerAction() {
        guard let model = questions?.questionsModel else { return }
        if model.count - 1 < currentIndex {
            cancelTimer()
            server?.sendToAllResultsData() { data in
                guard let message = try? JSONDecoder().decode(ResultsMessage.self, from: data) else { return }
                var results = [ResultsModel]()
                
                for key in message.results.keys.sorted() {
                    results.append(ResultsModel(playerName: key, playerScore: message.results[key] ?? -1))
                }
                
                self.results = results
                self.showResultsView = true
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
                    self.stopServer()
                }
            }
            return
        }
        
        let question = model[currentIndex]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let model = QuestionMessage(question: question.question,
                                        firstAnswer: question.firstAnswer,
                                        secondAnswer: question.secondAnswer,
                                        thirdAnswer: question.thirdAnswer,
                                        fourthAnswer: question.fourthAnswer,
                                        answer: question.answer,
                                        questionsAmount: [self.currentIndex + 1, self.questions!.questionsModel.count]
            )
            guard let data = try? JSONEncoder().encode(model) else { return }
            self.server?.sendToAll(data: data)
            DispatchQueue.main.async {
                if self.currentQuestion == nil {
                    self.currentQuestion = QuestionModel(question: question.question,
                                                         firstAnswer: question.firstAnswer,
                                                         secondAnswer: question.secondAnswer,
                                                         thirdAnswer: question.thirdAnswer,
                                                         fourthAnswer: question.fourthAnswer,
                                                         answer: question.answer,
                                                         questionsAmount: [self.currentIndex + 1, self.questions!.questionsModel.count]
                    )
                } else {
                    self.currentQuestion?.setup(question: question.question,
                                                firstAnswer: question.firstAnswer,
                                                secondAnswer: question.secondAnswer,
                                                thirdAnswer: question.thirdAnswer,
                                                fourthAnswer: question.fourthAnswer,
                                                answer: question.answer,
                                                questionsAmount: [self.currentIndex + 1, self.questions!.questionsModel.count]
                    )
                }
                self.showQuestionView = true
                self.currentIndex += 1
            }
        }
    }
}

// MARK: - Delegates

extension ViewModel: NetworkConnectionDelegate {
    func connectionOpened(connection: NetworkConnection) {}
    
    func connectionClosed(connection: NetworkConnection) {
        if !showResultsView {
            DispatchQueue.main.async {
                self.showLobbyView = false
                self.showQuestionView = false
            }
        }
    }
    
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
            DispatchQueue.main.async {
                if self.currentQuestion == nil {
                    self.currentQuestion = QuestionModel(question: message.question,
                                                         firstAnswer: message.firstAnswer,
                                                         secondAnswer: message.secondAnswer,
                                                         thirdAnswer: message.thirdAnswer,
                                                         fourthAnswer: message.fourthAnswer,
                                                         answer: message.answer,
                                                         questionsAmount: message.questionsAmount)
                } else {
                    self.currentQuestion?.setup(question: message.question,
                                                firstAnswer: message.firstAnswer,
                                                secondAnswer: message.secondAnswer,
                                                thirdAnswer: message.thirdAnswer,
                                                fourthAnswer: message.fourthAnswer,
                                                answer: message.answer,
                                                questionsAmount: message.questionsAmount)
                }
                self.showQuestionView = true
            }
        case "results":
            guard let message = try? JSONDecoder().decode(ResultsMessage.self, from: data) else { return }
            var results = [ResultsModel]()
            
            for key in message.results.keys.sorted() {
                results.append(ResultsModel(playerName: key, playerScore: message.results[key] ?? -1))
            }
            
            DispatchQueue.main.async {
                self.results = results
                self.showResultsView = true
            }
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
