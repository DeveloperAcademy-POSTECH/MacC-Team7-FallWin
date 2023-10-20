import Foundation
import SwiftUI
import CoreData
import ComposableArchitecture

struct SearchFeature: Reducer {
    struct State: Equatable {
        var searchTerm: String = ""
        //검색 텍스트 필드에 적히는 String
        var searchResults: [String] = [] // 여기에 사용할 모델 타입을 지정해야 합니다.
        //우리가 받아야하는 일기는 어떤 데이터지..?
    }

    enum Action: Equatable {
        case setSearchTerm(String)
        //검색한 것을 저장
        case fetchData
        // 여기에서 검색 결과를 초기화하는 데이터를 가져오는 논리를 추가합니다.
        // 예를 들어, 서버에서 데이터를 가져올 수도 있고, 로컬 데이터를 사용할 수도 있습니다.
        case filterData(String)
        // 검색결과를 보여주는 기능
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setSearchTerm(term):
            state.searchTerm = term
            return .none

        case .fetchData:
            // fetchData 함수를 호출하여 검색 결과를 초기화
            state.searchResults = fetchData()
            return .none

        case let .filterData(query):
            // 검색 결과를 필터링
            state.searchResults = query.isEmpty ? fetchData() : fetchData().filter { $0.lowercased().contains(query.lowercased()) }
            return .none
        }
    }

    // fetchData 함수는 실제로 데이터를 가져오는 로직을 구현해야 합니다.
    private func fetchData() -> [String] {
        // 여기에서 검색 결과를 초기화하는 데이터를 가져오는 논리를 추가합니다.
        // 예를 들어, 서버에서 데이터를 가져올 수도 있고, 로컬 데이터를 사용할 수도 있습니다.
        return ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    }
    
    
}
