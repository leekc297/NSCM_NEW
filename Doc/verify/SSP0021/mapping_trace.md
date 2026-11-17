# 대조표 ↔ 검증 추적표 v2 — SSP0021 (AS-IS SSP0021) · 2026-11-15T09:00:19

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 183행 (nscm-fe\features\shipping\src\pages\shipment-plan-auto-ess\__asis-mapping__.md) · AS-IS 액션 3125행(진입점 + 전 문장) = **3308행** → 검사 인스턴스 **1200개**
- 행 판정: 미검증 1562 · FAIL 1054 · 해당없음 371 · 검증완료 321
- 인스턴스 결과: ERROR 558 · PASS 257 · NA 239 · REVIEW 75 · FAIL 45 · NOPATH 22 · WARN 3 · NOT_RUN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 15 | 0 | 0 | 0 | 26 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 1 | 15 | 0 | 0 | 0 | 9 | 1 | 6 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 58 | 6 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 6 | 0 | 0 | 1 | 27 | 4 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 33 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 43 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 4 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 8 | 0 | 1 | 0 | 34 | 1 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 12 | 0 | 0 | 0 | 4 | 10 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 94 | 0 | 0 | 10 | 0 | 30 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 4 | 22 | 0 | 3 | 29 | 30 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 5 | 0 | 0 | 0 | 6 | 1 | 0 | 1 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 5 | 0 | 0 | 0 | 6 | 1 | 0 | 1 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 11 | 14 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 16 | 15 | 0 | 1 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | 콤보 후보 | 있음 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | ALL 옵션·다중선택 사양 |
| C1 | Cascade | 있음 | 5 | 1 | 0 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 24 | 0 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 76 | 1 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 2 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 57 | 0 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 28 | 10 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 7 | 0 | 0 | 0 | 34 | 3 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 7 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 13 | 6 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E3 | 편집·검증 | 있음 | 4 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 3 | 0 | 0 | 0 | 25 | 57 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 15 | 12 | 0 | 4 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 10 | 0 | 2 | 0 | 12 | 3 | 0 | 4 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 4 | 1 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 16 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 16 | 0 | 0 | 0 | 0 | 5 | 0 | 2 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 3 | 0 | 0 | 1 | 15 | 4 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 55 | 16 | 0 | 10 | 113 | 24 | 1 | 6 | 0 | 0 |
| 동적 생성·조회 | 122 | 26 | 1 | 56 | 73 | 71 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 16 | 1 | 0 | 0 | 39 | 31 | 0 | 4 | 0 | 0 |
| Cascade | 7 | 1 | 0 | 5 | 159 | 2 | 0 | 0 | 0 | 0 |
| 편집·검증 | 26 | 0 | 0 | 0 | 104 | 86 | 0 | 1 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 11 | 0 | 2 | 3 | 47 | 16 | 0 | 8 | 0 | 0 |
| 공통 기능 | 0 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 19 | 0 | 0 | 1 | 15 | 9 | 0 | 2 | 0 | 0 |

## FAIL 인스턴스

- B6|COND:clbCompany_ID — 원장 V-b9d670a4 SEARCH (대조표 1행)
- G4|COND:txtRequestor — E2E smoke labels — 누락 라벨 (대조표 1행)
- G4|COND:clbResultType — E2E smoke labels — 누락 라벨 (대조표 3행)
- G4|COND:txtBoxID — 원장 V-8b60f9fc SEARCH / E2E smoke labels — 누락 라벨 (대조표 1행)
- K-SA|SCREEN — E2E smoke common Search Area 조회영역 토글 (대조표 3행)
- G4|ROW:D00-1-021 — 행 집계 — 대조표 D00-1-021 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor /  (대조표 1행)
- G4|ROW:D00-1-028 — 행 집계 — 대조표 D00-1-028 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / it (대조표 1행)
- G4|ROW:D00-1-029 — 행 집계 — 대조표 D00-1-029 '§1 usrLayoutControl3 / UsrLayoutControl' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / it (대조표 1행)
- C1|COND:cboPlanDate — 실측[T-4fc30204]: AS-IS 는 하위 txtModel2 값을 비우는데 값 유지 · 'Plan Date*' → '2026-10-10' 변경 · 콤보 재요청 0건 · 하위 drpPeriod '2026.09.19 | 2026.11'→'2026.10.10 | 2026.12', drp (대조표 6행)
- I1|SCREEN — 원장 V-e5a58b4b RULE_SCREEN / 원장 V-e9c92968 RULE_SCREEN / 원장 V-771f3ee6 RULE_SCREEN / 원장 V-1379a334 DEFECT / 원장 V-0533a3cc DEFECT / 원장 V-16f7f379 DEFECT / 원장 V-91 (대조표 51행)
- G4|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requesto (대조표 1행)
- A6|ROW:Find — 행 집계 — 대조표 Find 'FindData_Main' 의 A6 10요소: ERROR:6 · FAIL:3 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP — 원장 V-39e51ab8 SP / 원장 V-c02b0ab3 SP / 원장 V-fc00 (대조표 1행)
- G4|ROW:Division/Company — 행 집계 — 대조표 Division/Company '`SSP0021_GET_SHIPMENT_DIVISION`(2결과셋, VP UNION·NER' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequesto (대조표 1행)
- G4|ROW:From Site — 행 집계 — 대조표 From Site '`Com_FromSite_SCP`' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smoke labels  (대조표 1행)
- G4|ROW:Plan Date — 행 집계 — 대조표 Plan Date '`Plan_Infor_SCP` @companyId' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smok (대조표 1행)
- G4|ROW:Period — 행 집계 — 대조표 Period 'PlanDate 파생 FROM_DATE/TO_DATE1' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smok (대조표 1행)
- G4|ROW:Result Type — 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite —  (대조표 1행)
- G4|ROW:Requestor — 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smoke labe (대조표 1행)
- G4|ROW:Box ID — 행 집계 — 대조표 Box ID '자유입력' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smoke labels — 누락 라벨; clbResul (대조표 1행)
- G4|ROW:Measure — 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / Requestor / ite — E2E smoke l (대조표 1행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.BtnMeasure_Click — 진입점 집계 11검사 — ERROR:6 · NA:2 · PASS:2 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.EditButton — 진입점 집계 48검사 — ERROR:31 · NA:10 · PASS:6 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.FindButton — 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 (대조표 1행)
- A6|SP:P_SSP0021_GET_SHIPMENT_PLAN — 원장 V-39e51ab8 SP / 원장 V-c02b0ab3 SP / 원장 V-fc00902e SP / 원장 V-712b3352 SP / 원장 V-83be8607 SP / 원장 V-7acdd137 SP / 원장 V-45e395ab SP / 원장 V-2a6f6eb4 SP / 원장 V-3e5 (대조표 70행)
- A6|SP:P_SSP0021_GET_SHIPMENT_PLAN_DETAIL — 원장 V-223cf093 SP / 원장 V-af5cf3a1 SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['YYYYMMDD', 'ITEM_ID', 'ERP_SO_ / 정렬대조 PASS 분기 키 순서 동일 (가드 ELSE) / 실측[T-cb8570af]: PKG_SSP002 (대조표 75행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.FindData_Detail — 진입점 집계 17검사 — PASS:9 · ERROR:5 · REVIEW:1 · FAIL:1 · NA:1 (대조표 10행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.FindData_Main — 진입점 집계 19검사 — PASS:10 · NA:4 · ERROR:3 · REVIEW:1 · FAIL:1 (대조표 17행)
- A6|SP:P_SSP0021_GET_SHIPMENT_RESULT — 원장 V-a13540c5 SP / 정렬대조 FAIL 8번째 키부터 다름: AS-IS ['CHILD_QTY DESC'] ↔ TO-BE [] ·  / 실측[T-9f0f7dec]: PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT: 화면 진입·조회 경로에서 이 SP  (대조표 55행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.FindData_Shipment_Result — 진입점 집계 17검사 — PASS:9 · ERROR:4 · NA:2 · REVIEW:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.InitControls — 진입점 집계 11검사 — PASS:5 · NA:4 · FAIL:1 · ERROR:1 (대조표 8행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.InitSpread — 진입점 집계 23검사 — PASS:12 · ERROR:5 · NA:5 · FAIL:1 (대조표 5행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.NonSoNo — 진입점 집계 8검사 — ERROR:4 · PASS:2 · FAIL:1 · NA:1 (대조표 128행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.Plan_Current_Check — 진입점 집계 8검사 — NA:6 · FAIL:2 (대조표 29행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SaveData_Detail — 진입점 집계 31검사 — ERROR:12 · PASS:11 · NA:5 · REVIEW:1 · NOPATH:1 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.Simulation — 진입점 집계 4검사 — ERROR:3 · FAIL:1 (대조표 245행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SoNo — 진입점 집계 8검사 — ERROR:4 · PASS:2 · NA:1 · FAIL:1 (대조표 143행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SpdDetail_ClipboardPasted — 진입점 집계 64검사 — ERROR:58 · NA:5 · FAIL:1 (대조표 21행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SpdDetail_ComboSelChange — 진입점 집계 42검사 — ERROR:41 · FAIL:1 (대조표 11행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SpdDetail_EditChange — 진입점 집계 22검사 — ERROR:21 · FAIL:1 (대조표 42행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.SpdMain_ClipboardPasted — 진입점 집계 7검사 — ERROR:3 · NA:3 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.Validation_Check — 진입점 집계 26검사 — ERROR:19 · NA:6 · FAIL:1 (대조표 114행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.checkValidN — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.chkERPIFBlockYn — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged — 진입점 집계 13검사 — PASS:4 · NOT_RUN:3 · ERROR:2 · NA:2 · NOPATH:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:SSP0021_ShipmentPlan.shtDetail_Change — 진입점 집계 9검사 — ERROR:8 · FAIL:1 (대조표 94행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G4|COND:chkSum — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
