# 대조표 ↔ 검증 추적표 v2 — SSP0005 (AS-IS SSP0005) · 2026-11-19T13:54:03

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 118행 (nscm-fe\features\shipping\src\pages\shipment-working-day\__asis-mapping__.md) · AS-IS 액션 359행(진입점 + 전 문장) = **477행** → 검사 인스턴스 **429개**
- 행 판정: 미검증 287 · 검증완료 155 · FAIL 20 · 해당없음 15
- 인스턴스 결과: PASS 122 · NA 101 · ERROR 85 · NOT_RUN 63 · REVIEW 20 · FAIL 20 · WARN 16 · NOPATH 2

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 11 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 3 | 0 | 0 | 0 | 0 | 5 | 0 | 1 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 10 | 0 | 4 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 1 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 6 | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 0 | 2 | 0 | 2 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 2 | 0 | 14 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 4 | 2 | 3 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 79 | 0 | 0 | 2 | 0 | 11 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 1 | 0 | 1 | 0 | 11 | 30 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 2 | 1 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 4 | 6 | 2 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 2 | 2 | 2 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 3 | 1 | 5 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 7 | 0 | 3 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 2 | 2 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 10 | 0 | 1 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 2 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 4 | 2 | 20 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 2 | 0 | 0 | 0 | 3 | 0 | 3 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 21 | 20 | 1 | 0 | 16 | 11 | 7 | 1 | 0 | 0 |
| 동적 생성·조회 | 86 | 0 | 15 | 20 | 17 | 44 | 7 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 4 | 18 | 4 | 1 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 5 | 9 | 7 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 40 | 10 | 30 | 0 | 0 | 0 |
| CRUD | 1 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 |
| 공통 기능 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 10 | 0 | 0 | 0 | 3 | 0 | 3 | 0 | 0 | 0 |

## FAIL 인스턴스

- X-REASON|ROW:C10 — [대조표 근거 없음] 요소 '`emptySpaceItem1`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:C11 — [대조표 근거 없음] 요소 '`emptySpaceItem2`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:C20 — [대조표 근거 없음] 요소 '`components`(Container)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:E04 — [대조표 근거 없음] 요소 '`SpdMain_Changed`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:V07 — [대조표 근거 없음] 요소 '`MSG00050` 숫자 형식' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:D08 — [대조표 근거 없음] 요소 '`ds == null`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:D09 — [대조표 근거 없음] 요소 '`!CanModelChange`(Changed)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:D10 — [대조표 근거 없음] 요소 '`ds == null`(Changed)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G09 — [대조표 근거 없음] 요소 '`SwitchLock`(EditButton)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G12 — [대조표 근거 없음] 요소 '`LockColumn(0, max, true)`(조회 직후 전열 잠금)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G15 — [대조표 근거 없음] 요소 '`GetModelColumnFromViewColumn`(cRow)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G16 — [대조표 근거 없음] 요소 '`GetModelColumnFromViewColumn`(cCol)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G22 — [대조표 근거 없음] 요소 '`Visible=`(`M_` → `W_` 토글)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G23 — [대조표 근거 없음] 요소 '`Visible=`(`M_` → `D_` 숨김)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:G24 — [대조표 근거 없음] 요소 '`Visible=`(`W_` → `D_` 토글)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:P08 — [대조표 근거 없음] 요소 '`SpdMain_CellDoubleClick` cs:834' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:P09 — [대조표 근거 없음] 요소 '`SpdMain_Changed` cs:872' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:A06 — [대조표 근거 없음] 요소 '저장 대상 = action AND 글자색 Red cs:491-492' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:A07 — [대조표 근거 없음] 요소 '`iCount==0` 시 첫/끝 행 플래그 cs:514-515' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)
- X-REASON|ROW:A09 — [대조표 근거 없음] 요소 '`DefineProperty()` 빈 본문 cs:142-144' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에 근거 보강 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: 원장 행 실행(@verify)
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: 원장 행 실행(@verify)
- F2|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00672 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00618 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00135 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00719 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00093 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG01122 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00134 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG01153 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- A6|SP:P_SSP0005_GET — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SSP0005_GET — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_SCM0001_GET_SCP_PERIOD — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SCM0001_GET_SCP_PERIOD — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- B4|COND:clbDivision — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B3|COND:clbDivision — 검사기 있음(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정렬·고정 목록 순서 대조(변이 B3_MUTATE)) — 실행 필요: 원장 행 실행(@verify
- B4|COL:COMPANY_ID — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B3|COL:COMPANY_ID — 검사기 있음(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정렬·고정 목록 순서 대조(변이 B3_MUTATE)) — 실행 필요: 원장 행 실행(@verify
- E4|COND:cboInputValue — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H2|COL:DAY_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:SAT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:SUN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:COMPANY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:DIVISION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:COMPANY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:DIVISION — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D4|COL:DAY_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: 원장 행 실행(@verify)
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: 원장 행 실행(@verify)
- F6|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00667 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- C3|COL:DAY_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- E4|MSG:MSG00614 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- F3|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-6f1aea63 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-23e055de — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-21c0cf89 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-c3498440 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00050 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- E3|LEDGER:V-a97f26ef — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: 원장 행 실행(@verify)
- D1|LEDGER:V-37b5c1f4 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:cboCompany — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- J1|LEDGER:V-1a5e296e — 검사기 있음(_trace.spec(@trace) W4b Division 후보 실측 ↔ 계정 권한 Division(user_group) — 기대 미확정 시 판정필요) — 실행 필요: 원장 행 실행(@verify)
- C1|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: 원장 행 실행(@verify)
- C1|COND:cboCompany — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- H2|COL:DIVISION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:DIVISION — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:DIVISION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C3|COL:SAT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:SUN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- F4|SP:SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E3|LEDGER:V-054016a3 — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:P_FIRST_ROW — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:P_LAST_ROW — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- E4|LEDGER:V-8c0b1fa7 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-7f38f4c1 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-f55f813e — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
