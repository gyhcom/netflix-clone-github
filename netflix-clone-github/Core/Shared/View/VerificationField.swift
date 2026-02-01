//
//  VerificationField.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI // SwiftUI 기본 UI 프레임워크


struct VerificationField: View {
    var type: CodeType // 코드 자리수(4자리/6자리)
    var style: TextFieldStyle = .rounderBorder // 입력 UI 스타일(테두리/밑줄)
    @Binding var isInValid: Bool // 외부에서 전달되는 유효성 상태
    var isLoading: Bool = false // 로딩 여부(입력 비활성화 등)
    var onChange: (_ value: String) -> Void // 입력 중 변경 콜백
    var onComplete: (_ value: String) async -> Void // 입력 완료 시 비동기 콜백
    var configuration: VerificationFieldConfiguration = .default // 스타일/색상/사이즈 설정
    
    @State private var value: String = "" // 실제 입력값
    @State private var state: TypingState = .typing // 현재 입력 상태
    @State private var invalidTrigger: Bool = false // 흔들림 애니메이션 트리거
    @FocusState private var isActive: Bool // 키보드 포커스 상태
    @State private var hasCompleted: Bool = false // 완료 콜백 중복 호출 방지
    
    var body: some View {
        HStack( // 입력 칸들을 가로로 배치
            spacing: style == .rounderBorder ? configuration.sizes.spacing : configuration.sizes.underlineSpacing // 스타일별 간격
        ) {
            ForEach(0..<type.rawValue, id: \.self) { i in // 자리수만큼 칸 생성
                CharacterView(i) // 각 자리 UI
            }
        }
        .animation(.easeInOut(duration: 0.2), value: value) // 입력값 변화 애니메이션
        .animation(.easeInOut(duration: 0.2), value: isActive) // 포커스 변화 애니메이션
        .compositingGroup() // 효과 합성 안정화
        // Invalid Phase Animator
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger, content: { content, offset in // 흔들림 애니메이션
            content.offset(x: offset) // 좌우 흔들림 적용
        }, animation: { _ in
                .linear(duration: 0.06) // 빠른 선형 애니메이션
        })
        .background { // 실제 입력을 받는 숨은 TextField
            TextField("", text: $value) // 화면에는 보이지 않지만 입력을 수집
                .focused($isActive) // 포커스 바인딩
                .keyboardType(.numberPad) // 숫자 키보드
                .foregroundStyle(isLoading ? .gray.opacity(0.5) : .black) // 로딩 상태 색상
                .mask(alignment: .trailing) { // 입력 필드가 보이지 않도록 마스크
                    Rectangle()
                        .frame(width: 1, height: 1) // 1x1 영역만 표시
                        .opacity(0.01) // 거의 투명
                }
                .allowsHitTesting(false) // 직접 터치 방지(상위 뷰가 탭 처리)
                .disabled(isLoading) // 로딩 중 입력 비활성
        }
        .contentShape(.rect) // 전체 영역 탭 가능하게 설정
        .onTapGesture { // 탭 시 키보드 활성화
            isActive = true
        }
        .onChange(of: isInValid, { oldValue, newValue in // 외부에서 invalid 신호가 오면
            if newValue {
                state = .invalid // 상태를 invalid로 전환
                hasCompleted = false // 완료 상태 초기화
                if state == .invalid {
                    invalidTrigger.toggle() // 흔들림 애니메이션 트리거
                }
            }
        })
        .onChange(of: value) { oldValue, newValue in // 입력값 변경 감지
            let trimmedValue = String(newValue.prefix(type.rawValue)) // 최대 자리수만 유지
            
            if value != trimmedValue { // 초과 입력 제거
                value = trimmedValue
            }
            
            Task { @MainActor in // UI 업데이트는 메인 스레드에서
                if trimmedValue.count < type.rawValue { // 입력 중
                    onChange(trimmedValue) // 변경 콜백 호출
                    state = .typing // 상태 갱신
                    hasCompleted = false // 완료 플래그 리셋
                } else if value.count == type.rawValue { // 입력 완료
                    if !hasCompleted { // 중복 호출 방지
                        hasCompleted = true // 완료 플래그
                        state = .valid // 유효 상태
                        onChange(trimmedValue) // 최종 값 전달
                        await onComplete(trimmedValue) // 완료 콜백 호출
                    }
                } else {
                    state = .invalid // 예외 상황 처리
                }
            }
        }
        
    }
    
    // MARK: - Computed Properties
       private var spacing: CGFloat { // 스타일별 간격 계산
           style == .rounderBorder
               ? configuration.sizes.spacing // 테두리 스타일 간격
               : configuration.sizes.underlineSpacing // 밑줄 스타일 간격
       }
       
       private var textColor: Color { // 현재 입력 텍스트 색상
           isLoading
               ? configuration.colors.loadingText // 로딩 중 색상
               : configuration.colors.text // 기본 텍스트 색상
       }
       
       private var fieldWidth: CGFloat { // 입력 칸 너비
           style == .rounderBorder
               ? configuration.sizes.fieldWidth // 테두리 스타일 너비
               : configuration.sizes.fieldWidth - 10 // 밑줄 스타일은 약간 축소
       }
    
    @ViewBuilder
    func CharacterView(_ index: Int) -> some View { // 각 자리 입력 UI
        Group {
            if style == .rounderBorder { // 테두리 스타일
                RoundedRectangle(cornerRadius: configuration.borders.cornerRadius)
                    .stroke(
                        borderColor(index), // 상태별 테두리 색상
                        lineWidth: configuration.borders.width // 테두리 두께
                    )
            } else { // 밑줄 스타일
                Rectangle()
                    .fill(borderColor(index)) // 상태별 밑줄 색상
                    .frame(height: configuration.borders.underlineHeight) // 밑줄 높이
                    .frame(maxHeight: .infinity, alignment: .bottom) // 아래쪽 정렬
            }
        }
        .frame(width: fieldWidth, height: configuration.sizes.fieldHeight) // 칸 크기
        .overlay { // 실제 입력된 문자 표시
            let stringValue = string(index) // 해당 인덱스 문자 가져오기
            
            if stringValue != "" { // 값이 있으면 표시
                Text(stringValue)
                    .font(configuration.typography.font) // 폰트
                    .fontWeight(configuration.typography.fontWeight) // 굵기
                    .transition(.blurReplace) // 변경 애니메이션
                    .foregroundStyle(textColor) // 텍스트 색상
                    .transition(.blurReplace) // 전환 효과
                    .disabled(isLoading) // 로딩 중 비활성
            }
        }
    }
    
    func string(_ index: Int) -> String { // 특정 인덱스의 문자 추출
        if value.count > index { // 인덱스가 유효한지 확인
            let startIndex = value.startIndex
            let stringIndex = value.index(startIndex, offsetBy: index)
            
            return String(value[stringIndex]) // 해당 문자 반환
        }
        
        return "" // 값이 없으면 빈 문자열
    }
    
    func borderColor(_ index: Int) -> Color { // 상태별 테두리/밑줄 색상
        let loadingOpacity = isLoading ? 0.5 : 1.0 // 로딩 중이면 투명도 낮춤
        switch state {
        case .typing: // 입력 중
            return value.count == index && isActive
            ? configuration.colors.active.opacity(loadingOpacity) // 현재 입력 칸 강조
            : configuration.colors.typing.opacity(loadingOpacity) // 기본 입력 색
        case .valid: // 유효한 입력 완료
            return configuration.colors.valid.opacity(loadingOpacity)
        case .invalid: // 오류 상태
            return configuration.colors.invalid
        }
    }
}

//#Preview {
//    VerificationField()
//}


enum CodeType: Int, CaseIterable {
    case four = 4 // 4자리 코드
    case six = 6 // 6자리 코드
    
    var stringValue: String { // 표시용 문자열
        "\(rawValue) Digit"
    }
}

enum TypingState {
    case typing // 입력 중
    case valid // 입력 완료(유효)
    case invalid // 입력 오류
}

enum TextFieldStyle: String, CaseIterable {
    case rounderBorder = "Rounded Border" // 둥근 테두리
    case underline = "Underline" // 밑줄
}

struct VerificationFieldConfiguration {
    struct ColorConfig {
        var typing: Color // 입력 중 테두리 색
        var active: Color // 활성(현재 입력 칸) 색
        var valid: Color // 유효 상태 색
        var invalid: Color // 오류 상태 색
        var text: Color // 입력 문자 색
        var loadingText: Color // 로딩 중 문자 색
        
        init( // 기본 색상 설정
            typing: Color = .gray,
            active: Color = .primary,
            valid: Color = .green,
            invalid: Color = .red,
            text: Color = .primary,
            loadingText: Color = Color.gray.opacity(0.5)
        ) {
            self.typing = typing // 입력 중 색
            self.active = active // 활성 색
            self.valid = valid // 유효 색
            self.invalid = invalid // 오류 색
            self.text = text // 문자 색
            self.loadingText = loadingText // 로딩 문자 색
        }
        
        static let `default` = ColorConfig() // 기본 색 구성
    }
    
    struct SizeConfig {
        var fieldWidth: CGFloat // 각 칸 너비
        var fieldHeight: CGFloat // 각 칸 높이
        var spacing: CGFloat // 테두리 스타일 간격
        var underlineSpacing: CGFloat // 밑줄 스타일 간격
        
        init( // 기본 크기 설정
            fieldWidth: CGFloat = 50,
            fieldHeight: CGFloat = 55,
            spacing: CGFloat = 8,
            underlineSpacing: CGFloat = 12
        ) {
            self.fieldWidth = fieldWidth // 너비
            self.fieldHeight = fieldHeight // 높이
            self.spacing = spacing // 간격
            self.underlineSpacing = underlineSpacing // 밑줄 간격
        }
        
        static let `default` = SizeConfig() // 기본 크기 구성
    }
    
    struct BorderConfig {
        var width: CGFloat // 테두리 두께
        var cornerRadius: CGFloat // 둥근 모서리 반경
        var underlineHeight: CGFloat // 밑줄 높이
        
        init( // 기본 테두리 설정
            width: CGFloat = 1,
            cornerRadius: CGFloat = 8,
            underlineHeight: CGFloat = 1
        ) {
            self.width = width // 두께
            self.cornerRadius = cornerRadius // 반경
            self.underlineHeight = underlineHeight // 밑줄 높이
        }
        
        static let `default` = BorderConfig() // 기본 테두리 구성
    }
    
    struct TypographyConfig {
        var font: Font // 글꼴
        var fontWeight: Font.Weight // 글꼴 두께
        
        init( // 기본 타이포 설정
            font: Font = .title2,
            fontWeight: Font.Weight = .semibold
        ) {
            self.font = font // 글꼴
            self.fontWeight = fontWeight // 굵기
        }
        
        static let `default` = TypographyConfig() // 기본 타이포 구성
    }
    
    var colors: ColorConfig // 색상 설정
    var sizes: SizeConfig // 크기 설정
    var borders: BorderConfig // 테두리 설정
    var typography: TypographyConfig // 타이포그래피 설정
    
    init( // 전체 설정 초기화
        colors: ColorConfig = .default,
        sizes: SizeConfig = .default,
        borders: BorderConfig = .default,
        typography: TypographyConfig = .default
    ) {
        self.colors = colors // 색상 적용
        self.sizes = sizes // 크기 적용
        self.borders = borders // 테두리 적용
        self.typography = typography // 타이포 적용
    }
    
    static let `default` = VerificationFieldConfiguration() // 기본 설정
    
    // Builder methods remain the same
    func withColors(_ colors: ColorConfig) -> VerificationFieldConfiguration {
        var config = self // 기존 설정 복사
        config.colors = colors // 새 색상 적용
        return config // 변경된 설정 반환
    }
    
    func withSizes(_ sizes: SizeConfig) -> VerificationFieldConfiguration {
        var config = self // 기존 설정 복사
        config.sizes = sizes // 새 크기 적용
        return config // 변경된 설정 반환
    }
    
    func withBorders(_ borders: BorderConfig) -> VerificationFieldConfiguration {
        var config = self // 기존 설정 복사
        config.borders = borders // 새 테두리 적용
        return config // 변경된 설정 반환
    }
    
    func withTypography(_ typography: TypographyConfig) -> VerificationFieldConfiguration {
        var config = self // 기존 설정 복사
        config.typography = typography // 새 타이포 적용
        return config // 변경된 설정 반환
    }
}
