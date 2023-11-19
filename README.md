# FallWin

## 앱 소개
<img width="855" alt="스크린샷 2023-11-20 오전 12 19 51" src="https://github.com/DeveloperAcademy-POSTECH/MacC-Team7-FallWin/assets/79218038/70c9d8b5-2194-4a92-be2c-68e87a596b95">



## Architecture
### 주요 항목 소개
- View
  - Main
    - Writing: 본문 작성, 화풍 선택 등 일기 작성과 관련된 기능을 담당하는 View입니다.
    - Search: 저장된 일기 컨텐츠를 그리드 내부 피드 형태로 탐색할 수 있는 View입니다. 검색 기능을 제공합니다.
    - Settings: 닉네임 변경, 화면 잠금 설정 등 프로필 관련 각종 설정 기능을 담고 있는 View입니다.
- Data: 작성된 일기(Journal) 저장을 위한 CoreData 활용, iCloud 연동 등을 처리합니다.
- Util
  - ChatGPTApiManager: 그림 생성을 위해 사용자가 입력한 일기 본문에서 적절한 명사구를 일정 개수 뽑아내기 위해 ChatGPT를 활용합니다.
  - KarloApiManager: 작성된 프롬프트를 이용하여 Karlo를 통해 이미지를 생성합니다.


## Design Pattern
- The Composable Architecture
  - ![TCA Github](https://github.com/pointfreeco/swift-composable-architecture)
  - SwiftUI 중심의 코드를 작성하되, 확장성과 유지보수성을 높이기 위해 채택하였습니다. 
  단방향의 동작 방식을 갖추었다는 점, 작은 구성의 유기적인 연결로 동작한다는 점에서 사람이 이해하기 쉽고 테스트 및 수정하기 편하다는 점에 주목했습니다.


## Members
|                      Jay(조한동)                     |                Shannon(이세민)                |                Darlic(권다현)               |                Grace(최고은)               |                Benny(한기백)              | Elcap(최명근)  | Hayo(김동혁)
| :---------------------------------------------: | :----------------------------------: | :------------------------------: | :------------------------------------: | :------------------------------------: |  :------------------------------------: |  :------------------------------------: | 
| PM | PM | 디자인 | 디자인 | 개발 | 개발 | 개발