# 대조표 ↔ 검증 추적표 v2 — SSP0003 (AS-IS SSP0003) · 2026-11-14T20:11:17

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 32행 (nscm-fe\features\shipping\src\pages\shipment-change-request-confirm-ssp0003\__asis-mapping__.md) · AS-IS 액션 910행(진입점 + 전 문장) = **942행** → 검사 인스턴스 **371개**
- 행 판정: 미검증 533 · 검증완료 227 · FAIL 175 · 해당없음 7
- 인스턴스 결과: NA 130 · ERROR 113 · PASS 58 · REVIEW 42 · FAIL 19 · NOPATH 9

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 19 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 3 | 0 | 0 | 0 | 0 | 2 | 0 | 5 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 19 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 1 | 15 | 1 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 4 | 0 | 1 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 4 | 4 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 3 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 20 | 0 | 12 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 1 | 8 | 0 | 1 | 13 | 17 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | 콤보 후보 | 있음 | 1 | 3 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 2 | 5 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 11 | 2 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 5 | 7 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 6 | 0 | 0 | 0 | 0 | 10 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| E3 | 편집·검증 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 36 | 27 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 5 | 2 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 6 | 3 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 10 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 10 | 3 | 0 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 22 | 1 | 0 | 1 | 17 | 23 | 0 | 5 | 0 | 0 |
| 동적 생성·조회 | 10 | 13 | 0 | 25 | 16 | 32 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 3 | 3 | 0 | 0 | 2 | 10 | 0 | 0 | 0 | 0 |
| Cascade | 4 | 0 | 0 | 0 | 11 | 4 | 0 | 0 | 0 | 0 |
| 편집·검증 | 6 | 1 | 0 | 0 | 41 | 59 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 1 | 0 | 0 | 6 | 18 | 2 | 0 | 0 | 0 | 0 |
| 공통 기능 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 10 | 0 | 0 | 10 | 3 | 0 | 0 | 3 | 0 | 0 |

## FAIL 인스턴스

- K-SA|SCREEN — E2E smoke common Search Area 조회영역 토글 (대조표 2행)
- G1|ROW:usrConditionPanel1(조회조건 7종) — 행 집계 — 대조표 usrConditionPanel1(조회조건 7종) '`ShipmentChangeRequestConfirmSsp0003Form`(SearchAr' 의 G1 7요소: PASS:4 · ERROR:1 · FAIL:1 · NA:1 · FAIL 요소: txtRequest / s (대조표 1행)
- B3|COND:cboStatus — 원장 V-5f6e4f5f SEARCH (대조표 1행)
- B3|COND:cboChangeType — 원장 V-7bc634c0 SEARCH (대조표 1행)
- G1|ROW:btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨김) — 행 집계 — 대조표 btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨김) '**의도적 드리프트(사용자 지시 2026-09-30)** — 조회영역 `SearchArea' 의 G1 7요소: PASS:4 · ERROR:1 · FAIL:1 · NA:1 (대조표 1행)
- G1|ROW:G2 — 행 집계 — 대조표 G2 'CellDoubleClick' 의 G1 7요소: PASS:4 · ERROR:1 · FAIL:1 · NA:1 · FAIL 요소: txtRequest / strRequest.Substr — 원장 V-0d9d367c SEARCH / 원장 V-8a809465 SEAR (대조표 1행)
- I1|SCREEN — 원장 V-9a5892b7 RULE_SCREEN / 원장 V-671736f1 RULE_SCREEN / 원장 V-9752f0ea RULE_SCREEN / 원장 V-41190682 DEFECT / 원장 V-e426c6cd DEFECT / 원장 V-71dbb295 DEFECT / 원장 V-3e (대조표 31행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.ChkDraftingData — 진입점 집계 10검사 — ERROR:9 · FAIL:1 (대조표 27행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.EngProcessingChk — 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 (대조표 15행)
- G1|COND:txtRequest — 원장 V-0d9d367c SEARCH / 원장 V-8a809465 SEARCH (대조표 2행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.FindData_Main — 진입점 집계 14검사 — PASS:6 · REVIEW:2 · ERROR:2 · NA:2 · FAIL:2 (대조표 8행)
- E3|LEDGER:V-0768539f — 원장 V-0768539f (대조표 2행)
- B3|ENTRY:SSP0003_ShipmentChangeRequestConfirm.GetDayRange — 진입점 집계 — 대조표 SSP0003_ShipmentChangeRequestConfirm.GetDayRange 의 B3 5요소: FAIL:2 · NA:2 · PASS:1 · FAIL 요소: cboStatus / Status — 원장 V-5f6e4f5f SEARCH; cboChangeTy (대조표 6행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheckNew — 진입점 집계 12검사 — ERROR:4 · NA:4 · PASS:2 · FAIL:1 · REVIEW:1 (대조표 2행)
- G6|COND:cboStatus — 실측[T-089b59ce]: AS-IS SelectedIndex = 2(ALL 포함 목록) → 기대 항목 'Requested'(TO-BE 목록 9건 · ALL 포함) ↔ TO-BE 초기 'Drafting' 불일치 (대조표 3행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.InitControls — 진입점 집계 22검사 — PASS:13 · REVIEW:3 · NOPATH:3 · FAIL:1 · NA:1 · ERROR:1 (대조표 7행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.SaveData — 진입점 집계 15검사 — ERROR:7 · PASS:4 · REVIEW:3 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.SaveDraftingData — 진입점 집계 10검사 — ERROR:4 · PASS:3 · REVIEW:2 · FAIL:1 (대조표 72행)
- X-ROW|ENTRY:SSP0003_ShipmentChangeRequestConfirm.chkERPIFBlockYn — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 17행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

