# 대조표 ↔ 검증 추적표 v2 — SCP0007 (AS-IS SCP0007) · 2026-11-14T09:55:25

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 203행 (nscm-fe\features\supply\src\pages\bod\__asis-mapping__.md) · AS-IS 액션 905행(진입점 + 전 문장) = **1108행** → 검사 인스턴스 **1118개**
- 행 판정: FAIL 350 · 검증완료 348 · 미검증 319 · 해당없음 59 · 미구현 32
- 인스턴스 결과: PASS 714 · NA 190 · ERROR 121 · FAIL 73 · BLOCKED 19 · REVIEW 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 31 | 0 | 0 | 0 | 24 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 21 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 45 | 0 | 0 | 0 | 0 | 23 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 20 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 26 | 0 | 0 | 0 | 24 | 4 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 43 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 14 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 3 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 22 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 12 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 121 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 0 | 32 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 18 | 8 | 0 | 0 | 11 | 5 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 10 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 14 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | 콤보 후보 | 있음 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | ALL 옵션·다중선택 사양 |
| C1 | Cascade | 있음 | 10 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 16 | 0 | 0 | 0 | 10 | 3 | 0 | 0 | 0 | 3 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 39 | 0 | 0 | 0 | 10 | 10 | 0 | 0 | 0 | 6 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 1 | 0 | 2 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 8 | 14 | 0 | 0 | 3 | 4 | 0 | 0 | 0 | 3 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 6 | 4 | 0 | 0 | 15 | 12 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 1 | 9 | 0 | 0 | 13 | 21 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 61 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 20 | 0 | 0 | 0 | 0 | 21 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 3 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 3 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 3 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 18 | 0 | 0 | 0 | 0 | 35 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 4 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 3 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 15 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 17 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 2 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 34 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 187 | 0 | 0 | 0 | 50 | 32 | 0 | 0 | 0 | 0 |
| 동적 생성·조회 | 191 | 43 | 0 | 0 | 11 | 24 | 0 | 0 | 0 | 2 |
| 콤보 후보 | 58 | 0 | 0 | 0 | 3 | 1 | 0 | 0 | 0 | 0 |
| Cascade | 73 | 14 | 0 | 1 | 23 | 19 | 0 | 0 | 0 | 12 |
| 편집·검증 | 117 | 15 | 0 | 0 | 28 | 101 | 0 | 0 | 0 | 3 |
| CRUD | 3 | 1 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 68 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 |
| 공통 기능 | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 14 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |

## FAIL 인스턴스

- C6|COL:TO_SITE_CODE — 원장 V-c667b133 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V-d433bae7 ASIS / 원장 V-f1677353 ASIS / 실측[T-48725bd0]: FROM_SITE_CODE 셀을 열었다가 값을 바꾸지 않고 닫음(더블클 (대조표 18행)
- C6|ROW:D00-2-004 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: TO_SITE_CODE / To Site — 원장 V-c667b133 ASIS / 원장 V-1c (대조표 1행)
- D1|ROW:D00-2-004 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요소: ROUTE_ID / Route Id — 원장 V-dde703c0 COLUMN / 원장 V-8 (대조표 1행)
- D3|ROW:D00-2-004 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소: INCOTERMS_SSP / Incoterms SSP — 원장 V-9a793d94 ASIS  (대조표 1행)
- C6|ROW:D00-2-005 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: TO_SITE_CODE / To Site — 원장 V-c667b133 ASIS / 원장 V-1c7 (대조표 1행)
- D1|ROW:D00-2-005 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요소: ROUTE_ID / Route Id — 원장 V-dde703c0 COLUMN / 원장 V-86 (대조표 1행)
- D3|ROW:D00-2-005 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소: INCOTERMS_SSP / Incoterms SSP — 원장 V-9a793d94 ASIS / (대조표 1행)
- X-NOTIMPL|ROW:D00-2-006 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 상태가 '미구현' — 사유: AS-IS `SpdMain_EditChange`(cs:1328-1353)의 2가지 동작 중 INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현됨 — ROU (대조표 1행)
- D1|COL:ROUTE_ID — 원장 V-dde703c0 COLUMN / 원장 V-86d76779 COLUMN / 실측[T-803c75b2]: 기존행 r0 ROUTE_ID 편집=false (AS-IS 편집 가능) | 신규행 r0 ROUTE_ID 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES: (대조표 6행)
- D3|COL:INCOTERMS_SSP — 원장 V-9a793d94 ASIS / 원장 V-eb4a5d7f ASIS / 원장 V-69447e5a ASIS / 원장 V-3b5c0b42 ASIS / 원장 V-004d10db ASIS / 실측[T-a457e667]: r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO (대조표 23행)
- X-NOTIMPL|ROW:D00-2-007 — 대조표 D00-2-007 '§2 spdMain / KeyPress' 의 상태가 '미구현' — 사유: AS-IS `SpdMain_KeyPress`(cs:1322-1327)가 `ActiveColumnIndex==ROUTE_ID`일 때 `e.Handled=true`로 직접 키보드 입력을 막는 (대조표 1행)
- F2|SCREEN — 원장 V-1c2b5816 RULE_SCREEN / 원장 V-db344fe6 RULE_SCREEN / 원장 V-b34c30a9 RULE_SCREEN / 원장 V-f28f2ce5 GENERAL / 원장 V-f01e464c GENERAL / 원장 V-467e3556 GENERAL / 원장 V (대조표 181행)
- X-NOTIMPL|ROW:D00-3-009 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 상태가 '미구현' — 사유: **신규 발견**: 신규행에서 DIVISION_ID를 "내 division 목록" 콤보로 제한하는 로직이 TO-BE에 없다(`BodGri (대조표 1행)
- E2|COL:FROM_YYYYMMDD — 원장 V-9a934f52 COLUMN (대조표 2행)
- E2|COL:TO_YYYYMMDD — 원장 V-cac6a100 COLUMN (대조표 3행)
- D3|COL:INCOTERMS — 원장 V-b30dd3c6 ASIS / 원장 V-4dfc32a3 ASIS / 실측[T-cd892e67]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false ( (대조표 9행)
- X-NOTIMPL|ROW:D00-3-034 — 대조표 D00-3-034 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncotermsEdit)' 의 상태가 '미구현' — 사유: EditButton 진입 시 전행에 신규행 전용 콤보로 스왑하는 로직이나, TO-BE는 ATTRIBUTE9가 CRUD_TYP (대조표 1행)
- X-NOTIMPL|ROW:D00-3-036 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterms)' 의 상태가 '미구현' — 사유: D00-3-034와 동일 근거(EditButton 진입 시 원래 콤보로 복귀) — TO-BE는 이 스왑 자체가 없음(콤보는 조회조건 (대조표 1행)
- A6|ROW:D00-3-040 — 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — 원장 V-1db4f99c SP / 원장 V-2fdb9660 SP / 정 (대조표 1행)
- D1|ROW:D00-3-040 — 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요소: ROUTE_ID / Route Id — 원장 V-dde703c0 COLUMN / 원장 V-86d76779 (대조표 1행)
- D3|ROW:D00-3-040 — 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소: INCOTERMS_SSP / Incoterms SSP — 원장 V-9a793d94 ASIS / 원장 V- (대조표 1행)
- X-NOTIMPL|ROW:D00-3-043 — 대조표 D00-3-043 '§3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidColor)' 의 상태가 '미구현' — 사유: **신규 발견**: 저장 실패(SP 응답 errCode 99010/99020/99030/99040)시 중복행의 DIVISION_I (대조표 1행)
- X-NOTIMPL|ROW:D00-3-044 — 대조표 D00-3-044 '§3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,InvalidColor)' 의 상태가 '미구현' — 사유: D00-3-043과 동일 결함(errCode 99030/99040 분기) -- 고위험, D00-3-043과 동일 사유 → (대조표 1행)
- X-NOTIMPL|ROW:D00-3-045 — 대조표 D00-3-045 '§3 SetBGColor / (TRANSPORT_MODE,InvalidColor)' 의 상태가 '미구현' — 사유: D00-3-043과 동일 결함(errCode 99010 분기) -- 고위험, D00-3-043과 동일 사유 → AS-IS 의 이 동작이 TO-B (대조표 1행)
- X-NOTIMPL|ROW:D00-3-046 — 대조표 D00-3-046 '§3 SetBGColor / (PRIORITY,InvalidColor)' 의 상태가 '미구현' — 사유: D00-3-043과 동일 결함(errCode 99020 분기) -- 고위험, D00-3-043과 동일 사유 → AS-IS 의 이 동작이 TO-BE 화면에  (대조표 1행)
- X-NOTIMPL|ROW:D00-3-065 — 대조표 D00-3-065 '§3 SetActiveCell / (e.Row,e.Column)' 의 상태가 '미구현' — 사유: Route 팝업 선택 후 커서를 해당 셀로 이동시키는 UX 동작 — `Bod.tsx handleRouteSelect`에 대응 로직 없음(`GridUtils.ref (대조표 1행)
- X-NOTIMPL|ROW:D00-3-066 — 대조표 D00-3-066 '§3 ShowCell / (0,0,e.Row,e.Column,Center,Right)' 의 상태가 '미구현' — 사유: 위와 동일(선택 셀을 화면 중앙으로 스크롤) -- 저위험, D00-3-065와 동일 사유 → AS-IS 의 이 동작이 TO-BE 화면에 없음 (대조표 1행)
- X-NOTIMPL|ROW:D00-3-067 — 대조표 D00-3-067 '§3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: FROM_SITE_CODE 변경 시(`sFromSite=='E'`) TO_SITE 콤보를 `ToSiteBOD1_SCP_ALL (대조표 1행)
- X-NOTIMPL|ROW:D00-3-068 — 대조표 D00-3-068 '§3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: `sFromSite=='A' && OSP_YN=='Y'` 분기(`ToSiteByDivisionPlant1_SCP_ALL`)  (대조표 1행)
- X-NOTIMPL|ROW:D00-3-069 — 대조표 D00-3-069 '§3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: 그 외 분기(`ToSiteByDivision1_SCP_ALL`) — 위와 동일 결함(G16) -- 중위험, G16 → AS- (대조표 1행)
- X-NOTIMPL|ROW:D00-3-074 — 대조표 D00-3-074 '§3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: `SpdMain_ClipboardPasted`(붙여넣기)의 동일 3분기 — D00-3-067과 동일 결함(G16) -- 중위험 (대조표 1행)
- X-NOTIMPL|ROW:D00-3-075 — 대조표 D00-3-075 '§3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: 위와 동일(G16) -- 중위험, G16 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현  (대조표 1행)
- X-NOTIMPL|ROW:D00-3-076 — 대조표 D00-3-076 '§3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd)' 의 상태가 '미구현' — 사유: 위와 동일(G16) -- 중위험, G16 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현  (대조표 1행)
- C6|COL:INCOTERMS — 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (대조표 1행)
- C6|COL:INCOTERMS_SSP — 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (대조표 1행)
- A6|SP:P_SCP0007_GET_BOD — 원장 V-1db4f99c SP / 원장 V-2fdb9660 SP / 정렬대조 PASS 분기 키 순서 동일 (가드 IF( ISNULL(@p_input_status,'') ='R' / 정렬대조 PASS 분기 키 순서 동일 (가드 ELSE IF( ISNULL(@p_input_status,'' (대조표 61행)
- C6|ROW:D00-4b-003 — 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: TO_SITE_CODE / To Site — 원장 V-c667b (대조표 1행)
- C6|ROW:D00-4b-008 — 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: TO_SITE_CODE / To Site — 원장 V- (대조표 1행)
- X-NOTIMPL|ROW:D00-4b-009 — 대조표 D00-4b-009 '§4b SpdMain_EditChange / event / spdMain.EditChange' 의 상태가 '미구현' — 사유: INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현, ROUTE_ID 편집 차단은 미구현(D00-2-0 (대조표 1행)
- X-NOTIMPL|ROW:D00-4b-010 — 대조표 D00-4b-010 '§4b SpdMain_KeyPress / event / spdMain.KeyPress' 의 상태가 '미구현' — 사유: D00-2-007과 동일(신규 발견, ROUTE_ID 직접 편집 차단 없음) -- 중위험 → AS-IS 의 이 동작이 TO-BE 화면에 없 (대조표 1행)
- X-NOTIMPL|ROW:D00-4c-011 — 대조표 D00-4c-011 '§4c (없음) / GMessageBox / errCode in {99010..99040}' 의 상태가 '미구현' — 사유: D00-3-043~046과 동일 결함 — errCode별 구체 메시지(중복기간/중첩기간 등) 없이 서버가 내려준 공용 메시지만 ale (대조표 1행)
- X-NOTIMPL|ROW:D00-4d-005 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 상태가 '미구현' — 사유: **신규 중요 발견**: 그리드 FROM_SITE_CODE 셀 콤보 전용 원천(`dtFromSiteOfSpd`, `SpreadInfo.SetCo (대조표 1행)
- X-NOTIMPL|ROW:D00-4d-006 — 대조표 D00-4d-006 '§4d Data_SCP.CommonAll / ToSiteBOD1' 의 상태가 '미구현' — 사유: 그리드 TO_SITE_CODE 셀 콤보 원천(`dtToSiteOfSpd`) 중 하나(`sFromSite=='E'` 분기) — D00-3-067과 동일 결함(G1 (대조표 1행)
- X-NOTIMPL|ROW:D00-4d-007 — 대조표 D00-4d-007 '§4d Data_SCP.CommonAll / ToSiteByDivisionPlant1' 의 상태가 '미구현' — 사유: 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(`sFromSite=='A'&&OSP` 분기) — G16과 동일 -- 중위험, G16 (대조표 1행)
- X-NOTIMPL|ROW:D00-4d-008 — 대조표 D00-4d-008 '§4d Data_SCP.CommonAll / ToSiteByDivision1' 의 상태가 '미구현' — 사유: 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(그 외 분기) — G16과 동일 -- 중위험, G16 → AS-IS 의 이 동작이 TO-BE  (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-005 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 상태가 '미구현' — 사유: D00-4d-005와 동일(그리드 FROM_SITE 콤보 division 필터) — 콤보 자체가 미배선이라 필터도 미구현(G16) -- G16과 결합 →  (대조표 1행)
- A6|ROW:D00-4e-005 — 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — 원장 V-1db4f99c SP / 원장 (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-006 — 대조표 D00-4e-006 '§4e dtToSiteOfSpdAll / FindData_Main' 의 상태가 '미구현' — 사유: D00-4d-006과 동일(G16) -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-007 — 대조표 D00-4e-007 '§4e dtToSiteOfSpdAll / SpdMain_ComboSelChange' 의 상태가 '미구현' — 사유: G16과 동일 -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-008 — 대조표 D00-4e-008 '§4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange' 의 상태가 '미구현' — 사유: G16과 동일 -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-009 — 대조표 D00-4e-009 '§4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange' 의 상태가 '미구현' — 사유: G16과 동일 -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-010 — 대조표 D00-4e-010 '§4e dtToSiteOfSpdAll / SpdMain_ClipboardPasted' 의 상태가 '미구현' — 사유: G16과 동일(붙여넣기 경로) -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진  (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-011 — 대조표 D00-4e-011 '§4e dtToSiteOfSpdAll1 / SpdMain_ClipboardPasted' 의 상태가 '미구현' — 사유: G16과 동일 -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:D00-4e-012 — 대조표 D00-4e-012 '§4e dtToSiteOfSpdAll2 / SpdMain_ClipboardPasted' 의 상태가 '미구현' — 사유: G16과 동일 -- G16과 결합 → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- C6|COL:FROM_SITE_CODE — 원장 V-c667b133 ASIS / 원장 V-21c28614 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V-54cb4e73 ASIS / 원장 V-d433bae7 ASIS (대조표 41행)
- X-ROW|ENTRY:SCP0007_BOD.FindButton — 진입점 집계 6검사 — PASS:4 · FAIL:1 · NA:1 (대조표 1행)
- X-ROW|ENTRY:SCP0007_BOD.FindData_Main — 진입점 집계 17검사 — PASS:12 · NA:3 · FAIL:1 · ERROR:1 (대조표 15행)
- X-ROW|ENTRY:SCP0007_BOD.SaveData_Main — 진입점 집계 39검사 — PASS:34 · ERROR:3 · FAIL:1 · NA:1 (대조표 6행)
- C6|LEDGER:V-c667b133 — 원장 V-c667b133 (대조표 1행)
- X-ROW|ENTRY:SCP0007_BOD.SetCityCode — 진입점 집계 43검사 — PASS:17 · NA:14 · FAIL:7 · ERROR:5 (대조표 1행)
- D3|LEDGER:V-b30dd3c6 — 원장 V-b30dd3c6 / 실측[T-943eabe5]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false (AS-IS 해제 SetCityCode:1423) (대조표 1행)
- D3|LEDGER:V-3b5c0b42 — 원장 V-3b5c0b42 / 실측[T-aa95f6d2]: r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자열) == PLANT(else) → INCOTERMS_SSP 편집=true (AS-IS 잠금 EditButton:496) NG · (대조표 1행)
- D3|LEDGER:V-4dfc32a3 — 원장 V-4dfc32a3 / 실측[T-f660d450]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false (AS-IS 해제 SetCityCode:1423) (대조표 1행)
- D3|LEDGER:V-004d10db — 원장 V-004d10db / 실측[T-0c3aaaf4]: r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자열) == PLANT(else) → INCOTERMS_SSP 편집=true (AS-IS 잠금 EditButton:496) NG · (대조표 1행)
- C6|ENTRY:SCP0007_BOD.SpdMain_Changed — 진입점 집계 — 대조표 SCP0007_BOD.SpdMain_Changed 의 C6 1요소: FAIL:1 · FAIL 요소: FROM_SITE_CODE / From Site — 원장 V-c667b133 ASIS / 원장 V-21c28614 ASIS / 원장 V-1c76f13c ASIS / (대조표 15행)
- X-ROW|ENTRY:SCP0007_BOD.SpdMain_Changed — 진입점 집계 7검사 — PASS:5 · FAIL:2 (대조표 1행)
- X-ROW|ENTRY:SCP0007_BOD.SpdMain_ClipboardPasted — 진입점 집계 39검사 — PASS:20 · NA:12 · ERROR:6 · FAIL:1 (대조표 3행)
- C6|LEDGER:V-3778a5ce — 원장 V-3778a5ce (대조표 1행)
- C6|COL:VMI_YN — 원장 V-3778a5ce ASIS / 실측[T-d054bd9b]: VMI_YN: 편집 가능한 콤보 후보 2건 — AS-IS 도 이 컬럼을 콤보로 선언(META FPComboBox YesOrNo (META SCM_MST_SHEET_COLUMNS(SCP0007/BOD)))하고 Site 선택 (대조표 3행)
- X-ROW|ENTRY:SCP0007_BOD.SpdMain_ComboSelChange — 진입점 집계 47검사 — PASS:31 · NA:7 · ERROR:6 · FAIL:3 (대조표 2행)
- X-ROW|ENTRY:SCP0007_BOD.SpdMain_EditChange — 진입점 집계 5검사 — PASS:3 · ERROR:1 · FAIL:1 (대조표 12행)
- C6|LEDGER:V-f1677353 — 원장 V-f1677353 (대조표 1행)
- C6|ENTRY:SCP0007_BOD.cboDivision_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: TO_SITE_CODE / To Site — 원장 V-c667b133 ASIS / 원 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

