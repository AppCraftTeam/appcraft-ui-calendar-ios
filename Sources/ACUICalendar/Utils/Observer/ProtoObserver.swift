//
//  ProtoObserver.swift
//
//
//  Created by Damian on 20.05.2024.
//

import Foundation

class ProtoObserver<Listener> {

    private var store: NSHashTable<AnyObject> = .weakObjects()

    private let rwQueue = DispatchQueue(label: "rw.observer.queue")
    
    func getListeners(_ completionHandler: @escaping ([Listener]) -> Void) {
        rwQueue.sync {
            let listeners = Array(store.allObjects.reversed()) as? [Listener] ?? []
            completionHandler(listeners)
        }
    }
    
    func add(_ listener: AnyObject) {
        rwQueue.asyncAndWait {
            self.store.add(listener)
        }
    }

    func remove(_ listener: AnyObject) {
        rwQueue.asyncAndWait {
            self.store.remove(listener)
        }
    }

    func removeAll() {
        rwQueue.asyncAndWait {
            self.store.removeAllObjects()
        }
    }

    func invoke(_ invocation: @escaping (Listener) -> Void) {
        self.getListeners {  listeners in
            for listener in listeners  {
                invocation(listener)
            }
        }
    }

    func invoke(_ invocation: @escaping (Listener) -> Void, queue: DispatchQueue) {
        self.getListeners {  listeners in
            for listener in listeners {
                queue.async { invocation(listener) }
            }
        }
    }
}
