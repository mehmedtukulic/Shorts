import Foundation

// MARK: - Protocol

protocol MyListRepositoryProtocol: AnyObject, Observable {
    func contains(_ id: String) -> Bool
    func toggle(_ id: String)
    func set(_ id: String, listed: Bool)
    func remove(_ id: String)
    func series(from allSeries: [Series]) -> [Series]
}

// MARK: - Concrete Implementation

@Observable
final class MyListRepository: MyListRepositoryProtocol {
    private var seriesIDs: [String] = []
    private var idSet: Set<String> = []

    private let key = "myListSeriesIDs"

    init() {
        let stored = UserDefaults.standard.stringArray(forKey: key) ?? []
        seriesIDs = stored
        idSet = Set(stored)
    }

    func contains(_ id: String) -> Bool {
        idSet.contains(id)
    }

    func toggle(_ id: String) {
        if idSet.contains(id) {
            remove(id)
        } else {
            seriesIDs.insert(id, at: 0)
            idSet.insert(id)
            save()
        }
    }

    func set(_ id: String, listed: Bool) {
        let current = idSet.contains(id)
        guard listed != current else { return }
        toggle(id)
    }

    func remove(_ id: String) {
        guard idSet.contains(id) else { return }
        seriesIDs.removeAll { $0 == id }
        idSet.remove(id)
        save()
    }

    func series(from allSeries: [Series]) -> [Series] {
        let lookup = Dictionary(allSeries.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return seriesIDs.compactMap { lookup[$0] }
    }

    private func save() {
        UserDefaults.standard.set(seriesIDs, forKey: key)
    }
}
