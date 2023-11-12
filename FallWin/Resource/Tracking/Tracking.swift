//
//  Tracking.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import Foundation
import FirebaseAnalytics



struct Tracking {
    // 인스턴스화 방지
    private init() { }
    
    enum Screen: String {
        case V1__메인뷰 //
        
        case V2_1__일기작성_감정선택뷰//
        case V2_2__일기작성_글작성뷰//
        case V2_3__일기작성_화풍선택뷰//
        case V2_4__일기작성_대기뷰 //
        case V2_5__일기작성_결과선택뷰 //
        case V2_6__일기작성_그림확대뷰
        
        case V3__상세페이지뷰
        
        case V4__검색뷰
        
        case V5__설정뷰
        
    }
    
    enum Event: String {
        case A1_1__메인_날짜선택
        case A1_2__메인_일기아이템
        case A1_3__메인_새일기쓰기
        
        case A2_1_1__일기작성_감정선택_뒤로가기
        case A2_1_2__일기작성_감정선택_닫기
        case A2_1_3__일기작성_감정선택_건너뛰기
        case A2_1_4__일기작성_감정선택_다음
        case A2_1_5__일기작성_감정선택_감정
        //감정별로 라벨링을 할 수 있을지 잘 몰라서 일단 다 써놓을게요
        case A2_1_5_1__일기작성_감정선택_행복한
        case A2_1_5_2__일기작성_감정선택_뿌듯한
        case A2_1_5_3__일기작성_감정선택_감동받은
        case A2_1_5_4__일기작성_감정선택_짜증나는
        case A2_1_5_5__일기작성_감정선택_슬픈
        case A2_1_5_6__일기작성_감정선택_답답한
        case A2_1_5_7__일기작성_감정선택_귀찮은
        case A2_1_5_8__일기작성_감정선택_감사한
        case A2_1_5_9__일기작성_감정선택_신나는
        case A2_1_5_10__일기작성_감정선택_기대되는
        case A2_1_5_11__일기작성_감정선택_불안한
        case A2_1_5_12__일기작성_감정선택_외로운
        case A2_1_5_13__일기작성_감정선택_부끄러운
        case A2_1_5_14__일기작성_감정선택_당황한
        case A2_1_5_15__일기작성_감정선택_힘든
        case A2_1_5_16__일기작성_감정선택_평온한
        case A2_1_5_17__일기작성_감정선택_놀란
        case A2_1_5_18__일기작성_감정선택_안심되는
        
        case A2_2_1__일기작성_글작성_뒤로가기
        case A2_2_2__일기작성_글작성_닫기
        case A2_2_3__일기작성_글작성_다음버튼
        case A2_2_4__일기작성_글작성_글작성
        
        case A2_3_1__일기작성_화풍선택_뒤로가기
        case A2_3_2__일기작성_화풍선택_닫기
        case A2_3_3__일기작성_화풍선택_그림그리러가기
        case A2_3_4__일기작성_화풍선택_화풍
        //화풍별로 라벨링을 할 수 있을지 잘 몰라서 일단 다 써놓을게요
        
        case A2_5_1__일기작성_그림선택_뒤로가기
        case A2_5_2__일기작성_그림선택_닫기
        case A2_5_3__일기작성_그림선택_그림확대
        case A2_5_4__일기작성_그림선택_일기마무리버튼
        
        case A2_6_1__일기작성_그림확대_닫기
        case A2_6_2__일기작성_그림확대_그림선택
        
        case A3_1__상세페이지_공유하기
        case A3_2__상세페이지_수정하기
        case A3_3__상세페이지_일기삭제
        
        case A4_1__검색뷰_피드검색
        case A4_2__검색뷰_새일기쓰기
        
        case A5_1_1_설정뷰_화면잠금_비밀번호설정과해제
        case A5_1_2_설정뷰_화면잠금_생체인증
        case A5_2_1_설정뷰_iCloud백업_백업
        case A5_2_2_설정뷰_iCloud백업_복원
        case A5_3_1_설정뷰_소통창구
        case A5_4_1_설정뷰_피드백남기기

    }

    // 이벤트 로깅을 위한 일반적인 메소드
    static func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }

    static func logScreenView(screenName: String, className: String? = nil) {
        logEvent(AnalyticsEventScreenView,
                 parameters: [AnalyticsParameterScreenName: screenName,
                              AnalyticsParameterScreenClass: className ?? screenName])
    }
    
    /*
     사용 예시
      - Screen의 경우
            - view의 body에             
                 .onAppear {
                 Tracking.logScreenView(screenName: Tracking.Screen.wrtingSelectEmotionView.rawValue)
                print("@Log : wrtingSelectEmotionView")
                    }
     를 달아주세요
     - Event의 경우
        - 버튼이나 컴포넌트 등에
                 .onTapGesture {
                     Tracking.logEvent(Tracking.Event.touchOnboardingStart)
                    print("@Log : wrtingSelectEmotionView")
                    }
     */
}
