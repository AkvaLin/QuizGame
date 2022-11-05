//
//  Networking.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 04.11.2022.
//

import SwiftUI
import Network

struct Networking: View {
        
    @State var server: NetworkServer?
    @State fileprivate var browser: Browser?
    @State var connection: NetworkConnection?
    @State fileprivate var elements = [listElements]()
    
    var body: some View {
        VStack {
            Button("Group") {
//                group = Server(name: ":D")
                server = NetworkServer(name: "Server")
                try! server?.start(queue: DispatchQueue(label: "Server Queue"))
            }
            Button("Browse") {
                browser = Browser()
            }
            Button("Print results") {
                elements = [listElements]()
                for result in browser!.browser.browseResults {
                    if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                        self.elements.append(listElements(name: name, endPoint: result.endpoint))
                    }
                }
            }
            List {
                ForEach(elements) { element in
                    Text(element.name)
                        .onTapGesture {
//                            client = Client(endPoint: element.endPoint)
                            connection = NetworkConnection(nwConnection: NWConnection(to: element.endPoint, using: .tcp))
                            connection?.start(queue: DispatchQueue(label: "Connection Queue"))
                        }
                }
            }
            Button("Send Message") {
//                group?.sendMessagesToClients(message: "Хеллоуу".data(using: .utf8)!)
//                print(group?.connectedClients)
                server?.sendToAll(data: "Hello".data(using: .utf8)!)
            }
        }
    }
}

fileprivate class listElements: Identifiable {
    let id = UUID()
    var name: String
    var endPoint: NWEndpoint
    
    init(name: String, endPoint: NWEndpoint) {
        self.name = name
        self.endPoint = endPoint
    }
}

fileprivate class Server {
    
    var listener: NWListener
    var connectedClients = [NWConnection]()
    var name: String
    var queue = DispatchQueue(label: "Server Queue")
    
    init(name: String) {
        self.name = name
        self.listener = try! NWListener(using: .tcp)
        
        listener.service = NWListener.Service(name: name, type: "_quiz._tcp")
        
        listener.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Прослушиватель готов искать новых друзей")
            case .failed(let error):
                print("Прослушиватель сегодня не в настроении \(error)")
            default:
                break
            }
        }
        
        listener.newConnectionHandler = { newConnection in
            self.connectedClients.append(newConnection)
            print("Добро пожаловать, \(newConnection)")
        }
        
        listener.serviceRegistrationUpdateHandler = { hasChanged in
            switch hasChanged {
            case .add(let endPoint):
                print("Держи :3 \(endPoint)")
            case .remove(let endPoint):
                print("\(endPoint) ушёл")
            @unknown default:
                break
            }
        }
        
        listener.start(queue: queue)
    }
    
    func sendMessagesToClients(message: Data) {
        connectedClients.forEach { client in
            client.start(queue: .main)
            client.send(content: message, completion: .idempotent)
        }
    }
    
    func sendMessageToClient(message: Data, client: NWConnection) {
        client.send(content: message, completion: .idempotent)
    }
}

fileprivate class Client {
    
    var connection: NWConnection
    var queue = DispatchQueue(label: "Client queue")
    
    init(endPoint: NWEndpoint) {
        self.connection = NWConnection(to: endPoint, using: .tcp)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Клиент готов к подключению :)")
            case .failed(let error):
                print("Что-то пошло не так: \(error)")
            case .cancelled:
                print("Отмена")
            case .waiting(let error):
                print("Ожидание \(error)")
            default:
                break
            }
        }
        
        connection.receiveMessage { data, context, isCompleted, error in
            print("Получено")
            guard let data = data,
                  error == nil
            else {
                return
            }
            
            print(String(data: data, encoding: .utf8))
        }
        
        connection.start(queue: queue)
    }
}

fileprivate class Browser {
    
    var browser: NWBrowser
    
    init() {
        self.browser = NWBrowser(for: .bonjour(type: "_quiz._tcp", domain: nil), using: .tcp)
        
        browser.browseResultsChangedHandler = { result, changed in
            print("Забирай результаты: \(result)")
        }
        
        browser.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Бразуер готов")
            case .failed(let error):
                print("У браузера не получилось(( по этой причине: \(error)")
            default:
                break
            }
        }
        
        browser.start(queue: .main)
    }
}
