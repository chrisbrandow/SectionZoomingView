import Foundation
import Combine
import SwiftRedis

class Client {
    enum Error: Swift.Error {
        case badData
    }

    static let shared = Client()

    var cancellables = Set<AnyCancellable>()

    let host: String = "redis-19796.c228.us-central1-1.gce.cloud.redislabs.com"

    let password: String = "U5hXbVyXKdWwaGhmDJyEAoHZ3RqGU3vt"

    let port: Int32 = 19796

    let redis = Redis()

    private static let defaultPollingInterval: TimeInterval = 3

    private var timer: Timer?

    // One shared order per restaurant
    var key: String { GlobalState.shared.selectedExample.rawValue }

    // MARK: Public setup method
    func configure() {
        Task {
            do {
                try await connect()
                try await auth()
                pull()
                subscribe()
                startPolling()
            } catch {
                self.handleError(error)
            }
        }
    }

    // MARK: Private conection helpers
    private func connect() async throws {
        return try await withCheckedThrowingContinuation { done in
            redis.connect(host: self.host, port: self.port) { error in
                if let error = error {
                    done.resume(throwing: error)
                } else {
                    done.resume()
                }
            }
        }
    }

    private func auth() async throws {
        return try await withCheckedThrowingContinuation { done in
            redis.auth(self.password) { error in
                if let error = error {
                    done.resume(throwing: error)
                } else {
                    done.resume()
                }
            }
        }
    }

    private func subscribe() {
        let c = GlobalState.shared.$cart.sink { [weak self] cart in
            do {
                try self?.push(cart: cart)
            } catch {
                self?.handleError(error)
            }
        }
        cancellables.insert(c)
    }

    func startPolling(interval: TimeInterval? = nil) {
        let interval = interval ?? Self.defaultPollingInterval
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval,
                                     repeats: true) { [weak self] timer in
            self?.pull()
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    func cartString(cart: Cart) throws -> String {
        let data = try JSONEncoder().encode(cart)
        guard let result = String(data: data, encoding: .utf8)
        else { throw Error.badData }
        return result
    }

    func currentCart() throws -> String {
        return try cartString(cart: GlobalState.shared.cart)
    }

    func setCurrentCart(string: String) throws {
        guard let data = string.data(using: .utf8)
        else { throw Error.badData }
        let cart = try JSONDecoder().decode(Cart.self, from: data)
        GlobalState.shared.setCart(cart)
    }

    func push(cart: Cart) throws {
        let value = try self.cartString(cart: cart)
        redis.set(self.key, value: value) { [weak self] result, error in
            if let error = error {
                self?.handleError(error)
            }
        }
    }

    func pull() {
        redis.get(self.key) { [weak self] result, error in
            if let error = error {
                self?.handleError(error)
            }

            guard let string = result?.asString else {
                print("got no data from Redis")
                return
            }
            do {
                try self?.setCurrentCart(string: string)
            } catch {
                self?.handleError(error)
            }
        }
    }

    func handleError(_ error: Swift.Error) {
        print("Redis error: \(error)")
    }
}
