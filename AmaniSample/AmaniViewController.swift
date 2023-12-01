//
//  AmaniViewController.swift
//  AmaniSample
//
//  Created by Huseyin Vural on 24.11.2023.
//

import UIKit
import AmaniVideoSDK

class AmaniViewController: UIViewController {

    @IBOutlet weak var videoContainer: UIView!
    var amaniVideo: AmaniVideo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAmaniVideoConnection()
    }
    
    public func startAmaniVideoConnection() {
        
        do {
            let token = "eyJ0eXasdasdasdasdE"
            let providerParameters = ProviderParameters()
            self.amaniVideo = try AmaniVideoBuilder()
                .setServerURL(url: URL(string: providerParameters.socketServerUrl!)!)
                .setName(name: "User", surname: "Tester")
                .setToken(token: token)
                .setRemoteViewMode(viewMode: .portrait)
                .setRTCConfig(
                    stunServerURL: providerParameters.stunUrl!,
                    turnServerURL: providerParameters.turnUrl!,
                    turnUsername: providerParameters.userName!,
                    turnPassword: providerParameters.credential!)
                .setBackgroundViewColor(color: .black)
                .setDelegate(delegate: self)
                .build()
            
            DispatchQueue.main.async {
                let amaniVideoView = self.amaniVideo!.start(on: self.videoContainer)
                self.videoContainer = amaniVideoView
                
                print("Socket Connect")
            }
        } catch {
            print(error)
        }
    }
}

extension AmaniViewController: AmaniVideoDelegate {
    func onConnectionState(newState: AmaniVideoSDK.AmaniVideo.ConnectionState) {
        print("Socket onConnectionState -> \(newState.hashValue) - \(newState)")
    }
    
    func onUIEvent(event: AmaniVideoSDK.AmaniVideo.UIEvent) {
        print("Socket onUIEvent -> \(event.hashValue) - \(event)")
    }
    
    func onRemoteEvent(event: AmaniVideoSDK.AmaniVideo.RemoteEvent) {
        print("Socket onRemoteEvent -> \(event.hashValue) - \(event)")

    }
    
    func onException(error: [String]) {
        print("Socket error -> \(error)")
    }
}

public struct ProviderParameters: Codable {
    public let socketServerUrl: String? = "https://tr.amani.ai:8090"
    public let stunUrl: String? = "stun:tr.amani.ai:3478"
    public let turnUrl: String? = "turn:tr.amani.ai:3478"
    public let userName: String? = "adssdasd"
    public let credential: String? = "asdasd!ec%asdasdas%5xsgB"
}
