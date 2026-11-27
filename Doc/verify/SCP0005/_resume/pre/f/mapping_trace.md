# 대조표 ↔ 검증 추적표 v2 — SCP0005 (AS-IS SCP0005) · 2026-11-26T02:39:25

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 39행 (nscm-fe\features\shipping\src\pages\distribution-route\__asis-mapping__.md) · AS-IS 액션 675행(진입점 + 전 문장) = **714행** → 검사 인스턴스 **560개**
- 행 판정: FAIL 379 · 검증완료 223 · 미검증 81 · 해당없음 30 · 미구현 1
- 인스턴스 결과: PASS 365 · NA 122 · FAIL 57 · ERROR 13 · WARN 3

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 26 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 11 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 23 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H5 | 정적 디자인 | 있음 | 26 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 14 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 10 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 6 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 32 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 8 | 17 | 2 | 0 | 2 | 8 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 27 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 45 | 0 | 0 | 0 | 0 | 12 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 45 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 9 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 13 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 8 | 4 | 0 | 0 | 0 | 23 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 14 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 3 | 16 | 0 | 0 | 4 | 2 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 15 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 3 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 91 | 18 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
| 동적 생성·조회 | 77 | 17 | 2 | 0 | 2 | 18 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 0 | 0 | 0 |
| Cascade | 93 | 0 | 0 | 0 | 0 | 42 | 0 | 0 | 0 | 0 |
| 편집·검증 | 58 | 4 | 0 | 0 | 0 | 33 | 0 | 0 | 0 | 0 |
| CRUD | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 32 | 17 | 0 | 0 | 7 | 13 | 0 | 0 | 0 | 0 |
| 공통 기능 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 9 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- H6|COND:txtFromCountry — 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN_ORDER (조건 txtFromCountry 을 읽고 채우는 버튼 btnFromSrch 의 팝업) / 원장 EG-5cd10d14 팝업 실측 SCM0002_CitybyCount (대조표 5행)
- H6|BTN:btnFromSrch — 원장 V-718e1a16 ASIS / 원장 V-7cdbda05 ASIS / 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN_ORDER / 원장 EG-5cd10d14 팝업 실측 SCM0002_CitybyCountry BTN: (대조표 2행)
- H6|COND:txtToCountry — 원장 EG-09469e15 팝업 실측 SCM0002_CitybyCountry BTN:btnToSrch BTN_ORDER (조건 txtToCountry 을 읽고 채우는 버튼 btnToSrch 의 팝업) / 원장 EG-841a5b3e 팝업 실측 SCM0002_CitybyCountry BTN (대조표 5행)
- H6|BTN:btnToSrch — 원장 V-616b4d31 ASIS / 원장 V-ac0769f6 ASIS / 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN_ORDER / 원장 EG-5cd10d14 팝업 실측 SCM0002_CitybyCountry BTN: (대조표 2행)
- H2|ROW:DB메타 구동(gridColumns=[]) — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e (대조표 1행)
- H2|COL:PRIORITY — 원장 V-a4b02e55 COLUMN / 원장 V-b4651880 ASIS / 원장 V-fa71e89c ASIS / 실측[T-a86cad2c]: PRIORITY: 신규행 편집=true 표시 일치 (대조표 7행)
- H2|ROW:R9 TRK/AIR→DAYS 7 'Y' — 행 집계 — 대조표 R9 TRK/AIR→DAYS 7 'Y' '`daysAllYes()` cellEditEnded' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLUMN / 원장 V-b465188 (대조표 1행)
- H2|ROW:R10 TRK→港/Forwarder 7 '-' — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLUMN / 원장 V-b465 (대조표 1행)
- H2|ROW:R11/R12 FROM/TO 셀 더블클릭→도시팝업 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4 (대조표 1행)
- H6|ROW:R11/R12 FROM/TO 셀 더블클릭→도시팝업 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H6 22요소: FAIL:13 · ERROR:4 · PASS:3 · NA:2 · FAIL 요소: txtFromCount (대조표 1행)
- H2|ROW:R7 조회 databind — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLUMN / 원장 V-b4651880 ASIS / 원장  (대조표 1행)
- H2|ROW:R16/R17 클라 검증 색칠 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLU (대조표 1행)
- F1|SCREEN — 원장 V-c9c3b04a RULE_SCREEN / 원장 V-4e4af2a4 RULE_SCREEN / 원장 V-ed1875e6 RULE_SCREEN / 원장 V-26d2974c RULE_SCREEN / 원장 V-69056a6e GENERAL / 원장 V-38d117e4 GENERAL /  (대조표 202행)
- H2|ROW:R18 Insert/Delete — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COL (대조표 1행)
- H6|ROW:ProgressForm — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: FAIL:13 · ERROR:4 · PASS:3 · NA:2 · FAIL 요소: txtFromCountry / From Country — 원장 EG-b395018 (대조표 1행)
- H2|ROW:COMMON:UC-07 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLUMN / 원장 (대조표 1행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.CheckValid — 진입점 집계 14검사 — FAIL:7 · PASS:4 · NA:2 · WARN:1 (대조표 41행)
- H2|LEDGER:V-0810a59e — 원장 V-0810a59e (대조표 1행)
- H2|COL:FROM_CITY — 원장 V-a15f8422 COLUMN / 원장 V-0810a59e ASIS / 원장 V-17e451a7 ASIS / 원장 V-06e7dec2 ASIS / 실측[T-44723d88]: FROM_CITY: 신규행 편집=true 표시 일치 (대조표 5행)
- H2|LEDGER:V-c099fa4f — 원장 V-c099fa4f (대조표 1행)
- H2|COL:TO_CITY — 원장 V-2c0c4c1d COLUMN / 원장 V-c099fa4f ASIS / 원장 V-e63ff383 ASIS / 원장 V-bc631885 ASIS / 원장 V-dc54eed4 ASIS / 실측[T-72999610]: TO_CITY: 기존행 편집=true 표시 일치 · 신규행 편집=t (대조표 6행)
- H2|LEDGER:V-b4651880 — 원장 V-b4651880 (대조표 1행)
- H2|LEDGER:V-17e451a7 — 원장 V-17e451a7 (대조표 1행)
- H2|LEDGER:V-e63ff383 — 원장 V-e63ff383 (대조표 1행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.CreateSpread — 진입점 집계 4검사 — PASS:3 · FAIL:1 (대조표 4행)
- H2|ENTRY:SCP0005_DistributionRoute.CreateSpread — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / Priority — 원장 V-a4b02e55 COLUMN / 원장 V-b4651880 ASIS / 원장  (대조표 5행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.InitSpread — 진입점 집계 29검사 — PASS:28 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.SaveData — 진입점 집계 33검사 — PASS:20 · FAIL:6 · NA:6 · WARN:1 (대조표 5행)
- E4|LEDGER:V-3134fc3e — 원장 V-3134fc3e / 실측[T-ece1c98b]: 99010: TO-BE 알림 = 응답 MSG 열 그대로(가짜 응답 표지 실측) · 서버 문구 'DUP DATA.'(PKG_SCP0005 줄 1347~1348) → 화면 'DUP DATA. Confirm' · AS-IS MSG000 (대조표 1행)
- E4|MSG:MSG00043 — 원장 V-3134fc3e ASIS (대조표 1행)
- H2|ENTRY:SCP0005_DistributionRoute.SetImageCell — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 H2 5요소: PASS:3 · FAIL:2 · FAIL 요소: FROM_CITY / City — 원장 V-a15f8422 COLUMN / 원장 V-0810a59e ASIS / 원장 V-17e (대조표 4행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.SetImageCell — 진입점 집계 36검사 — PASS:23 · NA:10 · FAIL:3 (대조표 4행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.btnEaxel_Upload_Click — 진입점 집계 7검사 — PASS:3 · FAIL:2 · ERROR:1 · WARN:1 (대조표 8행)
- E4|LEDGER:V-4a0b6271 — 원장 V-4a0b6271 / 실측[T-2c4e7c8a]: MSG00265→MSG01273 · AS-IS btnEaxel_Upload('Upload') → btnEaxel_Upload_Click · SCP0005_DistributionRoute.cs:379(ExcelUploadForm2. (대조표 1행)
- E4|MSG:MSG00265 — 원장 V-4a0b6271 ASIS (대조표 1행)
- H6|LEDGER:V-718e1a16 — 원장 V-718e1a16 (대조표 1행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.btnFromSrch_Click — 진입점 집계 15검사 — PASS:9 · FAIL:4 · ERROR:1 · NA:1 (대조표 4행)
- H6|LEDGER:V-7cdbda05 — 원장 V-7cdbda05 (대조표 1행)
- H6|LEDGER:V-616b4d31 — 원장 V-616b4d31 (대조표 1행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.btnToSrch_Click — 진입점 집계 15검사 — PASS:9 · FAIL:4 · ERROR:1 · NA:1 (대조표 4행)
- H6|LEDGER:V-ac0769f6 — 원장 V-ac0769f6 (대조표 1행)
- H6|COL:FROM_COUNTRY — 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS / 원장 EG-813457a4 팝업 실측 SCM0002_CitybyCountry CELL:FROM_COUNTRY BTN_ORDER / 원장 EG-545b85e8 팝업 실측 SCM0002_CitybyCountry CE (대조표 35행)
- H6|COL:FROM_CITY — 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS / 원장 EG-e97f075b 팝업 실측 SCM0002_CitybyCountry CELL:FROM_CITY BTN_ORDER / 원장 EG-d6e1b619 팝업 실측 SCM0002_CitybyCountry CELL: (대조표 36행)
- H6|COL:TO_CITY — 원장 EG-7b7aa573 팝업 실측 SCM0002_CitybyCountry CELL:TO_CITY BTN_ORDER / 원장 EG-5f3353a4 팝업 실측 SCM0002_CitybyCountry CELL:TO_CITY NO_COL / 원장 EG-728c8d4c 팝업 실측 SCM000 (대조표 5행)
- H6|ENTRY:SCP0005_DistributionRoute.spdMain_CellDoubleClick — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS / 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS (대조표 3행)
- X-ROW|ENTRY:SCP0005_DistributionRoute.spdMain_CellDoubleClick — 진입점 집계 44검사 — PASS:19 · NA:12 · ERROR:7 · FAIL:6 (대조표 11행)
- H6|LEDGER:V-cca901cb — 원장 V-cca901cb (대조표 1행)
- H6|LEDGER:V-c9dc5aa7 — 원장 V-c9dc5aa7 (대조표 1행)
- M3|POPUP:SCP0005_DistributionRoutePopup — 원장 V-a46588cb ASIS / 실측[T-6d14c72c]: ROUTE_ID 더블클릭(r0) → 10초 동안 대화상자 0 · 서버 호출 0 · 편집기 없음 — 팝업 열리지 않음(AS-IS 더블클릭 팝업 SCP0005_DistributionRoutePopup) (대조표 8행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup..ctor — 진입점 집계 2검사 — NA:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.CreateSpread — 진입점 집계 1검사 — FAIL:1 (대조표 9행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.DefineProperty — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 4행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.Dispose — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.FindButton — 진입점 집계 4검사 — PASS:2 · FAIL:1 · ERROR:1 (대조표 2행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.FindData — 진입점 집계 6검사 — PASS:4 · ERROR:1 · FAIL:1 (대조표 16행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.Form_Load — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 6행)
- X-ROW|ENTRY:SCP0005_DistributionRoutePopup.InitSpread — 진입점 집계 30검사 — PASS:28 · FAIL:2 (대조표 13행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

