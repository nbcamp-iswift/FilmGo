//
//  SupabaseService.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation
import RxSwift
import RxRelay
import Supabase
import os

final class SupabaseService {
    static let shared = SupabaseService()
    var selectedSeats = BehaviorRelay<[SeatItem]>(value: [])

    private var client: SupabaseClient?
    private var channel: RealtimeChannelV2?

    private let diseposeBag = DisposeBag()

    private init() {
        if let url = URL(string: BundleConfig.get(.supabaseURL)) {
            let key = BundleConfig.get(.supabaseKey)
            client = SupabaseClient(supabaseURL: url, supabaseKey: key)
        }
    }

    func startListening(for movieID: Int) {
        guard let client else { return }

        fetchSelectedSeats(for: movieID)

        Task {
            channel = await client.realtimeV2.channel("filmgo")
            guard let stream = await channel?.postgresChange(
                AnyAction.self,
                table: "SelectedSeat"
            ) else { return }

            await client.realtimeV2.connect()
            await channel?.subscribe()

            for await action in stream {
                switch action {
                case .insert(let action):
                    os_log("Supabase Row Inserted: \(action.record)")
                    fetchSelectedSeats(for: movieID)
                case .delete(let action):
                    os_log("Supabase Row Deleted: \(action.oldRecord)")
                    fetchSelectedSeats(for: movieID)
                default:
                    break
                }
            }
        }
    }

    func endListening() {
        Task {
            await channel?.unsubscribe()
            await client?.realtimeV2.disconnect()
        }
    }

    func toggleSelectedSeat(movieID: Int, seatNumber: Int) {
        guard let client else { return }

        Task {
            let response: [SelectedSeatDTO] = try await client.database
                .from("SelectedSeat")
                .select()
                .eq("movieID", value: movieID)
                .eq("seatNumber", value: seatNumber)
                .execute()
                .value
            if response.first?.state != nil {
                deleteSelectedSeat(movieID: movieID, seatNumber: seatNumber)
            } else {
                insertSelectedSeat(movieID: movieID, seatNumber: seatNumber)
            }
        }
    }

    private func fetchSelectedSeats(for movieID: Int) {
        guard let client else { return }

        Task {
            let response: [SelectedSeatDTO] = try await client.database
                .from("SelectedSeat")
                .select()
                .eq("movieID", value: movieID)
                .execute()
                .value
            let seatItems = response.map {
                guard let state = SeatItem.State(rawValue: $0.state) else { fatalError() }
                return SeatItem(seatNumber: $0.seatNumber, userID: $0.userID, state: state)
            }
            selectedSeats.accept(seatItems)
        }
    }

    private func insertSelectedSeat(movieID: Int, seatNumber: Int) {
        guard let client else { return }
        let requestDTO = SelectedSeatRequestDTO(
            movieID: movieID,
            seatNumber: seatNumber,
            userID: CoreDataStorage.shared.fetchLoggedInUser()?.id.uuidString ?? "",
            state: SeatItem.State.selecting.rawValue
        )

        Task {
            try await client.database
                .from("SelectedSeat")
                .insert(requestDTO)
                .execute()
            fetchSelectedSeats(for: movieID)
        }
    }

    private func deleteSelectedSeat(movieID: Int, seatNumber: Int) {
        guard let client else { return }

        Task {
            try await client.database
                .from("SelectedSeat")
                .delete()
                .eq("movieID", value: movieID)
                .eq("seatNumber", value: seatNumber)
                .execute()
            fetchSelectedSeats(for: movieID)
        }
    }
}
