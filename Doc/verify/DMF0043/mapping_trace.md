# 대조표 ↔ 검증 추적표 v2 — DMF0043 (AS-IS DMF0043) · 2026-11-04T07:03:42

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 55행 (nscm-fe\features\master\src\pages\contribute-main\__asis-mapping__.md) · AS-IS 액션 902행(진입점 + 전 문장) = **957행** → 검사 인스턴스 **462개**
- 행 판정: 미검증 941 · 검증완료 16
- 인스턴스 결과: NOT_RUN 210 · ERROR 146 · REVIEW 56 · NA 26 · PASS 12 · NOPATH 6 · WARN 6

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 7 | 0 | 9 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 10 | 0 | 3 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 11 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 13 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 20 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 27 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 5 | 11 | 57 | 21 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 4 | 0 | 1 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 4 | 0 | 1 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 2 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 7 | 0 | 4 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 2 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 7 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 10 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 1 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 28 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 12 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 12 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 10 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 3 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 11 | 0 | 0 | 0 | 0 | 4 | 0 | 6 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 17 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 1 | 0 | 0 | 0 | 22 | 1 | 33 | 0 | 0 | 0 |
| 동적 생성·조회 | 0 | 0 | 6 | 56 | 63 | 21 | 43 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 8 | 0 | 2 | 0 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 17 | 0 | 21 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 27 | 0 | 49 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 3 | 0 | 37 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 11 | 0 | 0 | 0 | 6 | 4 | 17 | 6 | 0 | 0 |

## FAIL 인스턴스


## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- D4|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: 원장 행 실행(@verify)
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: 원장 행 실행(@verify)
- E3|COL:C — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: trace
- E4|COL:C — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:C — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: 원장 행 실행(@verify)
- F2|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: 원장 행 실행(@verify)
- A6|SP:P_DMF0043_GET_MAIN_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_GET_CONTRIBUTE_MAIN_DATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0043_GET_MAIN_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_GET_CONTRIBUTE_MAIN_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F6|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- F4|SP:P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- C2|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C3|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C6|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:EDIT_FLAG — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H6|BTN:btnCutOff — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- H6|POPUP:DMF0043_ContributeRatePopup — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|BTN:btnCutOff — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- M3|POPUP:DMF0043_ContributeRatePopup — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- M4|BTN:btnCutOff — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|POPUP:DMF0043_ContributeRatePopup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- G5|BTN:btnCutOff — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|POPUP:DMF0043_ContributeRatePopup — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- C1|COND:usrYear — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C4|COND:usrYear — 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace
- H5|COND:chkYear — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: 원장 행 실행(@verify)
- C1|COND:chkYear — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C4|COND:chkYear — 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace
- C1|COND:usrHis — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:usrDiscard — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C4|COND:usrHis — 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace
- C4|COND:usrDiscard — 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace
- G1|COND:usrHis — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:usrDiscard — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- A5|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H5|COL:EDIT_FLAG — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H2|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- A6|SP:P_DMF0043_GET_MAIN_VARSION_DATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_VERSION_GET — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0043_GET_MAIN_VARSION_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_VERSION_GET — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0043_MAIN_GET — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0043_MAIN_GET — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_MAIN_SAVE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_GET_CONTRIBUTE_RATE_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_VERSION_SAVE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0043_GET_CONTRIBUTE_RATE_POPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_VERSION_SAVE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- E4|MSG:MSG00303 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG01306 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00308 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG01310 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|COND:chkYear — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00266 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:S — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:S — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:S — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- K-SA|SCREEN — 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: 원장 행 실행(@verify)
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: 원장 행 실행(@verify)
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- D1|COL:VER_SEQ — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:VER_SEQ — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-b1f16d1e — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-09e6199a — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- A6|SP:P_DMF0000_GET_COMMON_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0000_GET_COMMON_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:clbYear — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|LEDGER:V-27a8f3fb — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- E4|COND:clbYear — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00019 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- D1|LEDGER:V-881158bc — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- G1|LEDGER:V-531e01fd — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-b8224403 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbYear — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbYear — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:clbYear — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- D3|LEDGER:V-05b9d42b — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-d4317569 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-f202c365 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- K4|SCREEN — 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: 원장 행 실행(@verify)
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:usrYear — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:usrYear — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- D3|LEDGER:V-64b8218f — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-a42b1ebe — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-52878f81 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:usrYear — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- D1|LEDGER:V-cc47f6c3 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- G1|LEDGER:V-34f867c1 — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- F4|SP:SCM0001_GET_LOOKUP_VALUES — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- H5|COND:usrYear — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: 원장 행 실행(@verify)
- C2|LEDGER:V-b3a13fe8 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-1c4c7b57 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-9484c962 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-0b242fae — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-b58fa4d0 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-da9233fa — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- E4|COL:EDIT_FLAG — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G5|LEDGER:V-019f6e4a — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-162a0f73 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-7e0bcea7 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-33492a5e — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-9e387a56 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-09d43c4b — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- C3|LEDGER:V-9e9f4813 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|LEDGER:V-7f6a90d6 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- M3|POPUP:DMF0043_Contribute_View — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G6|COND:usrType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:usrType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- A6|SP:P_DMF0043_GET_CONTRIBUTION_SALES_LIST — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0043_GET_SALES_LIST_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0043_GET_CONTRIBUTION_SALES_LIST — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0043_GET_SALES_LIST_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:txtVersion — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:usrCust — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:usrType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:usrBiz — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:chkM — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:usrChk — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|LEDGER:V-9b1be645 — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- E4|COND:txtVersion — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00283 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G1|LEDGER:V-fac50064 — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00307 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- D1|LEDGER:V-9641edd6 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- G1|LEDGER:V-400d6c56 — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:usrBiz — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:usrBiz — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:usrType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- B4|COL:DM_BIZ_TYPE — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B3|COL:DM_BIZ_TYPE — 검사기 있음(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정렬·고정 목록 순서 대조(변이 B3_MUTATE)) — 실행 필요: 원장 행 실행(@verify
- C1|COND:usrBiz — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- M3|BTN:btnColumn — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-423dd2d8 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-644c113b — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-c401e71c — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-005d4cef — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-fa0ce8dc — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-d1bf9f26 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-0ca5db1e — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-c004b580 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-7587099c — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-dfc620dd — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|BTN:btnSPVer — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- M3|POPUP:DMF0043_VersionPopup — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-f3d7368e — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-123b4a5d — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-ac61d5a3 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- H6|POPUP:DMF0043_VersionPopup — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|POPUP:DMF0043_VersionPopup — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-baf3fb4c — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-8761dfa0 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-0eb88ec5 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-2f6ac6e3 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:drpPeriod — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbDivision — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtDes — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- D1|LEDGER:V-41f93d68 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- F4|SP:DM0000_GET_COMMON_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G6|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- G6|COND:txtDes — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtDes — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- A5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H5|COL:DIVISION_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:VERSION_NO — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:VERSION_NO — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:VERSION_DESCRIPTION — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:VERSION_DESCRIPTION — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:VERSION_TYPE — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:VERSION_TYPE — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:VER_CRE_SEQ — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:VER_CRE_SEQ — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:YYYYMMDD — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:YYYYMMDD — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A5|PCOL:CREATED_BY — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H5|PCOL:CREATED_BY — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
