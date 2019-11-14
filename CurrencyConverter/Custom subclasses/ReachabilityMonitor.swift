//
//  ReachabilityMonitor.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 14/11/2019.
//

import Network

protocol ReachabilityMonitoring {
    var networkReachabilityChanged: ((Bool) -> ())? { get set }
}

class ReachabilityMonitor: ReachabilityMonitoring {
    
    private let observationQueue = DispatchQueue.init(label: "com.vaziuojam.ltu.CurrencyConverter.observer",
                                                      qos: .background)
    
    var networkReachabilityChanged: ((Bool) -> ())?
    
    private let monitor = NWPathMonitor()
    
    func startObserving() {
        monitor.pathUpdateHandler = { [weak self] path in
            let reachable = path.status != .unsatisfied
            self?.networkReachabilityChanged?(reachable)
        }
        
        monitor.start(queue: observationQueue)
    }
    
}
