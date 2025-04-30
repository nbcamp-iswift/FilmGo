//
//  SupabaseRepository.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation
import Supabase

final class SupabaseRepository {
    static let shared = SupabaseRepository()

    private let client: SupabaseClient

    private init?() {
        guard let url = URL(string: BundleConfig.get(.supabaseURL)) else { return nil }
        let key = BundleConfig.get(.supabaseKey)
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }

    func fetchTest() async -> String {
        do {
            let todos: [Todo] = try await client.database.from("Todo").select().execute().value
            return todos.map(\.text).reduce("", +)
        } catch {
            fatalError()
        }
    }
}

extension SupabaseRepository {
    struct Todo: Decodable {
        let id: Int
        let text: String
    }
}
