//
//  ReachabilityMonitor.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 14/11/2019.
//

import Network

protocol ReachabilityMonitoring: class {
    
    var networkReachabilityChanged: ((Bool) -> ())? { get set }
    
    func startObserving()
    
}

class ReachabilityMonitor: ReachabilityMonitoring {

    var networkReachabilityChanged: ((Bool) -> ())?
    
    private let monitor = NWPathMonitor()
    
    func startObserving() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.notify(path: path)
        }
        
        monitor.start(queue: .main)
        notify(path: monitor.currentPath)
    }
    
    private func notify(path: NWPath) {
        let reachable = path.status != .unsatisfied
        networkReachabilityChanged?(reachable)
    }
    
}
