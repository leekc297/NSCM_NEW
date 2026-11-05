# 대조표 ↔ 검증 추적표 v2 — SCP0041 (AS-IS SCP0041) · 2026-10-31T14:24:15

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 104행 (nscm-fe\features\supply\src\pages\stock-osp\__asis-mapping__.md) · AS-IS 액션 425행(진입점 + 전 문장) = **529행** → 검사 인스턴스 **417개**
- 행 판정: 미검증 245 · 검증완료 156 · FAIL 118 · 해당없음 10
- 인스턴스 결과: NA 174 · PASS 112 · ERROR 61 · REVIEW 46 · FAIL 19 · NOPATH 5

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 10 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 10 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 22 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 0 | 15 | 3 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 3 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 59 | 0 | 0 | 12 | 0 | 15 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 3 | 4 | 0 | 1 | 12 | 28 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 5 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | ALL 옵션·다중선택 사양 |
| C1 | Cascade | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 26 | 0 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 22 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 5 | 0 | 0 | 1 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 0 | 5 | 0 | 1 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 3 | 0 | 0 | 0 | 0 | 4 | 0 | 1 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 4 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 13 | 10 | 0 | 8 | 0 | 23 | 0 | 1 | 0 | 0 |
| 동적 생성·조회 | 69 | 8 | 0 | 35 | 27 | 53 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 13 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 |
| Cascade | 4 | 0 | 0 | 0 | 0 | 23 | 0 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 26 | 51 | 0 | 0 | 0 | 0 |
| CRUD | 1 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 2 | 0 | 0 | 3 | 5 | 6 | 0 | 2 | 0 | 0 |
| 공통 기능 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 7 | 0 | 0 | 0 | 0 | 8 | 0 | 1 | 0 | 0 |

## FAIL 인스턴스

- G4|COND:cboDivision — 원장 V-b0a33e60 SEARCH / E2E smoke labels (대조표 6행)
- G4|COND:clbPlantSite — 원장 V-02e5c290 SEARCH / E2E smoke labels (대조표 3행)
- G4|COND:txtItemId — 원장 V-43160969 SEARCH / E2E smoke labels (대조표 2행)
- G4|COND:txtInspection — E2E smoke labels / 실측[T-c3ff004a]: 조회조건 'defpacklabelinsepectionid, inspection' 은 TO-BE 조회조건 기준표(search_cond.csv) 대상이 아님(기준표에 없는 AS-IS 조건) — TO-BE 룰 CR-071(기준표  (대조표 2행)
- G4|COND:cboStatus — 원장 V-efeb3e6d SEARCH / E2E smoke labels (대조표 4행)
- G3|SCREEN — 원장 V-d7866b99 RULE_SCREEN / 원장 V-d7568e89 GENERAL / 원장 V-ab6a10c2 GENERAL / 원장 V-2565a4f7 GENERAL / 원장 V-8b75e740 CONFIRMED / E2E smoke common Condition(F6) 조회조 (대조표 4행)
- G4|ROW:D00-1-024 — 행 집계 — 대조표 D00-1-024 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 6요소: FAIL:5 · NOPATH:1 · FAIL 요소: cboDivision / Division / Div / — 원장 V-b0a33e60 SEARCH /  (대조표 1행)
- G4|ROW:D00-1-025 — 행 집계 — 대조표 D00-1-025 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G4 6요소: FAIL:5 · NOPATH:1 · FAIL 요소: cboDivision / Division / Div / — 원장 V-b0a33e60 SEARCH / E2 (대조표 1행)
- A6|ROW:D00-3-013 — 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — 원장 V-960823ee SP / 정렬대조 FAIL 2번째 키부터  (대조표 1행)
- A6|ROW:D00-3-015 — 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — 원장 V-960823ee SP / 정렬대조 FAIL 2번째 키부터  (대조표 1행)
- G4|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 G4 6요소: FAIL:5 · NOPATH:1 · FAIL 요소: cboDivision / Division / Div / — 원장 V-b0a33e60 SEARCH / E2E s (대조표 1행)
- G4|ROW:dCalendar (필수) — 행 집계 — 대조표 dCalendar (필수) '기간' 의 G4 6요소: FAIL:5 · NOPATH:1 · FAIL 요소: cboDivision / Division / Div / — 원장 V-b0a33e60 SEARCH / E2E smoke labels; clbPlantSite / P (대조표 1행)
- G4|ROW:dCalendarCutoff (Pack) — 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 G4 6요소: FAIL:5 · NOPATH:1 · FAIL 요소: cboDivision / Division / Div / — 원장 V-b0a33e60 SEARCH / E2E smoke labels; clbPlant (대조표 1행)
- X-ROW|ENTRY:SCP0041_StockOSP.FindButton — 진입점 집계 6검사 — REVIEW:2 · FAIL:2 · NA:1 · PASS:1 (대조표 1행)
- A6|SP:P_SCP0041_GET_PACK_HOLD_STOCK — 원장 V-960823ee SP / 정렬대조 FAIL 2번째 키부터 다름: AS-IS ['CUTOFF_DATE', 'DIR', 'PLANT_ID / 실측[T-f527876e]: PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: 화면 진입·조회 경로에서 이 SP  (대조표 52행)
- A6|SP:P_SCP0041_GET_STOCK_OSP — 원장 V-04df217d SP / 정렬대조 FAIL 2번째 키부터 다름: AS-IS ['SCM_SITE_ID', 'ITEM_ID'] ↔ TO- / 실측[T-bc8c4c6d]: PKG_SCP0041.P_SCP0041_GET_STOCK_OSP: 결과 1행이 AS-IS 키 [DIVISION_ (대조표 44행)
- X-ROW|ENTRY:SCP0041_StockOSP.FindData_Main — 진입점 집계 12검사 — PASS:6 · NA:3 · REVIEW:1 · FAIL:1 · ERROR:1 (대조표 13행)
- X-ROW|ENTRY:SCP0041_StockOSP.FindData_Pack — 진입점 집계 14검사 — PASS:5 · NA:4 · ERROR:3 · REVIEW:1 · FAIL:1 (대조표 13행)
- X-ROW|ENTRY:SCP0041_StockOSP.InitControls — 진입점 집계 8검사 — PASS:5 · FAIL:2 · NA:1 (대조표 5행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

