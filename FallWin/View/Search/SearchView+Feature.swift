import Foundation
import SwiftUI
import CoreData
import ComposableArchitecture

struct SearchFeature: Reducer {
    struct State: Equatable {
        var searchTerm: String = ""
        //검색 텍스트 필드에 적히는 String
        var searchResults: [Journal] = [] // 여기에 사용할 모델 타입을 지정해야 합니다.
        var groupedSearchResults: [YearAndMonth: [Journal]] = [:] // 월별 그룹화된 결과

        @PresentationState var journal: JournalFeature.State?
    }

    enum Action: Equatable {
        case setSearchTerm(String)
        //검색한 것을 저장
        case fetchData
        // 여기에서 검색 결과를 초기화하는 데이터를 가져오는 논리를 추가합니다.
        // 예를 들어, 서버에서 데이터를 가져올 수도 있고, 로컬 데이터를 사용할 수도 있습니다.
        case filterData(String)
        // 검색결과를 보여주는 기능
        
        case showJournalView(Journal)
        
        case journal(PresentationAction<JournalFeature.Action>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSearchTerm(term):
                state.searchTerm = term
                return .none

            case .fetchData:
                // fetchData 함수를 호출하여 검색 결과를 초기화
                let allData = fetchData()
                 state.searchResults = allData
                state.groupedSearchResults = groupDataByMonth(allData)
                return .none

            case let .filterData(query):
                // 검색 결과를 필터링
                state.searchResults = query.isEmpty ? fetchData() : fetchData().filter { journal in
                    if let content = journal.content {
                        return content.lowercased().contains(query.lowercased())
                    }
                    return false
                }
                return .none
                
            case let .showJournalView(journal):
                state.journal = JournalFeature.State(journal: journal)
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$journal, action: /Action.journal) {
            JournalFeature()
        }
    }


    func fetchData() -> [Journal] {
        // Core Data에서 저장된 Journal 엔터티를 가져옵니다.
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Journal.timestamp), ascending: false)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
    
    private func groupDataByMonth(_ data: [Journal]) -> [YearAndMonth: [Journal]] {
        var groupedData: [YearAndMonth: [Journal]] = [:]

        for journal in data {
            if let timestamp = journal.timestamp {
                // Date 확장에서 가져온 monthYearString을 사용
                let key = YearAndMonth(year: timestamp.year, month: timestamp.month)
                if var group = groupedData[key] {
                    group.append(journal)
                    groupedData[key] = group
                } else {
                    groupedData[key] = [journal]
                }
            }
        }
        
        return groupedData
    }
}

struct YearAndMonth: Hashable, Comparable {
    var year: Int
    var month: Int
    
    static func < (lhs: YearAndMonth, rhs: YearAndMonth) -> Bool {
        (lhs.year < rhs.year) || (lhs.year == rhs.year && lhs.month < rhs.month)
    }
    
    var string: String {
        String(format: "%d년 %d월", self.year, self.month)
    }
}

extension Date {
    // ... 기존 Date 확장 코드 ...
    
    var monthYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: self)
    }
    
    // ... 나머지 Date 확장 코드 ...
}
