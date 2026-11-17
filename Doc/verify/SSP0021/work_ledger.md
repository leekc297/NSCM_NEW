# 작업 원장 — SSP0021 · 2026-11-15 04:00

> 검사 인스턴스 1200건 중 PASS·NA 496건 외 **704건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 62 | 재판정 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 79 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 540 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 540 · 사람 판정 / AS-IS 원문 확인 → 재판정 70 · 화면 FE 35 · 하네스 22 · FE 21 · 대조표 9 · 사람판정 4 · 공통 컴포넌트 1 · DB 메타 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| C3 | CASCADE |  |  |  |  |  |  |  |  | 76 | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 58 | 배경·글자색 규칙 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 57 | 무변경 편집 종료 시 연쇄 미발동 |
| X-ROW | GEN |  |  | 24 |  |  |  | 3 |  | 27 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 43 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  | 1 |  | 34 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 34 | 행 값 기반 조건부 잠금 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 27 | 라벨 명칭 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 28 | 컬럼 편집 가능 여부(신규행·기존행) |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 26 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 25 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 24 | 그리드 셀 cascade 후보 |
| G4 | DESIGN |  |  | 15 |  | 6 | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| M4 | POPUP |  |  | 15 |  |  |  | 4 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 4 |  |  |  | 15 | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 |  | 2 |  | 12 | 팝업 표준·열림 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  | 16 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F4 | DB |  |  |  |  |  |  | 1 |  | 15 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E1 | EDIT |  |  |  |  |  |  |  |  | 13 | 숫자 소수자리·정수·부호·범위 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 11 | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  | 4 |  |  |  |  |  | 6 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-LOC | GEN |  |  |  |  |  |  | 10 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REASON | DESIGN |  |  |  |  |  |  | 9 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B1 | COMBO |  |  |  |  | 1 |  |  |  | 6 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  | 6 | 콤보 후보 중복 없음 |
| C4 | CASCADE |  |  |  |  |  |  | 5 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G6 | GEN |  |  |  |  |  |  |  |  | 4 | 조회조건 초기 기본값 = AS-IS Form_Load |
| M3 | POPUP |  |  |  |  |  |  |  |  | 4 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| C1 | CASCADE |  |  | 1 |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 3 | 신규행 기본값·자동세팅·Insert 전제 |
| B6 | COMBO |  |  | 1 |  | 1 |  |  |  |  | ALL 옵션·다중선택 사양 |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| K-SA | COMMON |  |  | 1 |  |  |  |  |  |  | 조회영역 토글 |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  |  |  |  | 1 | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |

## W3 동작 수정 (62)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0001 | C1 | cboPlanDate / Plan-date / Plan Date | 화면 FE(범위 밖(가이드만)) | C1 FAIL 수정 — cboPlanDate / Plan-date / Plan Date: 실측[T-4fc30204]: AS-IS 는 하위 txtModel2 값을 비우는데 값 유지 · 'Plan Date*' → '2026-10-10'  |  | 6 (D00-2-008 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0002 | B6 | clbCompany_ID / Company / Company_ID | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | B6 FAIL 수정 — clbCompany_ID / Company / Company_ID: 원장 V-b9d670a4 SEARCH (FX-SSP0021-015) |  | 1 (D00-1-010) |
| WK-SSP0021-0003 | K-SA | SSP0021 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K-SA FAIL 수정 — SSP0021 화면: E2E smoke common Search Area 조회영역 토글 |  | 3 (D00-1-021 D00-1-028 D00-1-030) |
| WK-SSP0021-0004 | G4 | Box ID | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Box ID: 행 집계 — 대조표 Box ID '자유입력' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: txtRequestor / R |  | 1 (Box ID) |
| WK-SSP0021-0005 | G4 | COMMON:UC-06 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL: |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0006 | G4 | D00-1-021 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-021: 행 집계 — 대조표 D00-1-021 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PAS |  | 1 (D00-1-021) |
| WK-SSP0021-0007 | G4 | D00-1-028 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-028: 행 집계 — 대조표 D00-1-028 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS: |  | 1 (D00-1-028) |
| WK-SSP0021-0008 | G4 | D00-1-029 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-029: 행 집계 — 대조표 D00-1-029 '§1 usrLayoutControl3 / UsrLayoutControl' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS: |  | 1 (D00-1-029) |
| WK-SSP0021-0009 | G4 | Division/Company | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Division/Company: 행 집계 — 대조표 Division/Company '`SSP0021_GET_SHIPMENT_DIVISION`(2결과셋, VP UNION·NER' 의 G4 20요소: NA:9 ·  |  | 1 (Division/Company) |
| WK-SSP0021-0010 | G4 | From Site | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — From Site: 행 집계 — 대조표 From Site '`Com_FromSite_SCP`' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL  |  | 1 (From Site) |
| WK-SSP0021-0011 | G4 | Measure | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Measure: 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · F |  | 1 (Measure) |
| WK-SSP0021-0012 | G4 | Period | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Period: 행 집계 — 대조표 Period 'PlanDate 파생 FROM_DATE/TO_DATE1' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · |  | 1 (Period) |
| WK-SSP0021-0013 | G4 | Plan Date | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Plan Date: 행 집계 — 대조표 Plan Date '`Plan_Infor_SCP` @companyId' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN: |  | 1 (Plan Date) |
| WK-SSP0021-0014 | G4 | Requestor | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Requestor: 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FA |  | 1 (Requestor) |
| WK-SSP0021-0015 | G4 | Result Type | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Result Type: 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 G4 20요소: NA:9 · NOPATH:6 · FAIL:3 · PASS:1  |  | 1 (Result Type) |
| WK-SSP0021-0016 | G4 | clbResultType / Result Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbResultType / Result Type: E2E smoke labels — 누락 라벨 |  | 3 (D00-1-016 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0017 | G4 | txtBoxID / Box ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — txtBoxID / Box ID: 원장 V-8b60f9fc SEARCH / E2E smoke labels — 누락 라벨 |  | 1 (D00-1-017) |
| WK-SSP0021-0018 | G4 | txtRequestor / Requestor / item.UserName | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — txtRequestor / Requestor / item.UserName: E2E smoke labels — 누락 라벨 |  | 1 (D00-1-014) |
| WK-SSP0021-0019 | I1 | SSP0021 화면 | DB 메타(적용 예정) | I1 FAIL 수정 — SSP0021 화면: 원장 V-e5a58b4b RULE_SCREEN / 원장 V-e9c92968 RULE_SCREEN / 원장 V-771f3ee6 RULE_SCREEN / 원장 V-1379a334 DEFECT  |  | 51 (D00-4d-004 D00-4d-013 D00-4d-025 COMMON:) |
| WK-SSP0021-0020 | A6 | Find | 사람판정(사람판정 대기) | A6 FAIL 수정 — Find: 행 집계 — 대조표 Find 'FindData_Main' 의 A6 10요소: ERROR:6 · FAIL:3 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP  |  | 1 (Find) |
| WK-SSP0021-0021 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN: 원장 V-39e51ab8 SP / 원장 V-c02b0ab3 SP / 원장 V-fc00902e SP / 원장 V-712b3352 SP /  |  | 70 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0022 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL: 원장 V-223cf093 SP / 원장 V-af5cf3a1 SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['Y |  | 74 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0023 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT: 원장 V-a13540c5 SP / 정렬대조 FAIL 8번째 키부터 다름: AS-IS ['CHILD_QTY DESC'] ↔ TO-BE  |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0024 | X-ROW | SSP0021_ShipmentPlan.BtnMeasure_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.BtnMeasure_Click: 진입점 집계 11검사 — ERROR:6 · NA:2 · PASS:2 · FAIL:1 (FX-SSP0021-092) |  | 5 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0025 | X-ROW | SSP0021_ShipmentPlan.EditButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.EditButton: 진입점 집계 48검사 — ERROR:31 · NA:10 · PASS:6 · FAIL:1 (FX-SSP0021-095) |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2435) |
| WK-SSP0021-0026 | X-ROW | SSP0021_ShipmentPlan.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.FindButton: 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 (FX-SSP0021-096) |  | 1 (ACT:SSP0021_ShipmentPlan.FindButton) |
| WK-SSP0021-0027 | X-ROW | SSP0021_ShipmentPlan.FindData_Detail | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.FindData_Detail: 진입점 집계 17검사 — PASS:9 · ERROR:5 · REVIEW:1 · FAIL:1 · NA:1 (FX-SSP0021-099) |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0028 | X-ROW | SSP0021_ShipmentPlan.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.FindData_Main: 진입점 집계 19검사 — PASS:10 · NA:4 · ERROR:3 · REVIEW:1 · FAIL:1 (FX-SSP0021-102) |  | 9 (ACT:SSP0021_ShipmentPlan.FindData_Main:4) |
| WK-SSP0021-0029 | X-ROW | SSP0021_ShipmentPlan.FindData_Shipment_R | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.FindData_Shipment_Result: 진입점 집계 17검사 — PASS:9 · ERROR:4 · NA:2 · REVIEW:1 · FAIL:1 (FX-SSP00 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0030 | X-ROW | SSP0021_ShipmentPlan.InitControls | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.InitControls: 진입점 집계 11검사 — PASS:5 · NA:4 · ERROR:1 · FAIL:1 (FX-SSP0021-110) |  | 7 (ACT:SSP0021_ShipmentPlan.InitControls:44) |
| WK-SSP0021-0031 | X-ROW | SSP0021_ShipmentPlan.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.InitSpread: 진입점 집계 23검사 — PASS:12 · ERROR:5 · NA:5 · FAIL:1 (FX-SSP0021-111) |  | 5 (ACT:SSP0021_ShipmentPlan.InitSpread:609:) |
| WK-SSP0021-0032 | X-ROW | SSP0021_ShipmentPlan.NonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.NonSoNo: 진입점 집계 8검사 — ERROR:4 · PASS:2 · NA:1 · FAIL:1 (FX-SSP0021-113) |  | 126 (ACT:SSP0021_ShipmentPlan.NonSoNo ACT:SSP) |
| WK-SSP0021-0033 | X-ROW | SSP0021_ShipmentPlan.Plan_Current_Check | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.Plan_Current_Check: 진입점 집계 8검사 — NA:6 · FAIL:2 (FX-SSP0021-114) |  | 21 (ACT:SSP0021_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0021-0034 | X-ROW | SSP0021_ShipmentPlan.SaveData_Detail | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SaveData_Detail: 진입점 집계 31검사 — ERROR:12 · PASS:11 · NA:5 · REVIEW:1 · FAIL:1 · NOPATH:1 (FX-S |  | 4 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0035 | X-ROW | SSP0021_ShipmentPlan.Simulation | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.Simulation: 진입점 집계 4검사 — ERROR:3 · FAIL:1 (FX-SSP0021-117) |  | 194 (ACT:SSP0021_ShipmentPlan.Simulation ACT:) |
| WK-SSP0021-0036 | X-ROW | SSP0021_ShipmentPlan.SoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SoNo: 진입점 집계 8검사 — ERROR:4 · PASS:2 · NA:1 · FAIL:1 (FX-SSP0021-118) |  | 141 (ACT:SSP0021_ShipmentPlan.SoNo ACT:SSP002) |
| WK-SSP0021-0037 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_CellDoubl | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdDetail_CellDoubleClick: 진입점 집계 20검사 — ERROR:8 · FAIL:5 · NOPATH:4 · NOT_RUN:1 · PASS:1 · N |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0038 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_Clipboard | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdDetail_ClipboardPasted: 진입점 집계 64검사 — ERROR:58 · NA:5 · FAIL:1 (FX-SSP0021-119) |  | 21 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0039 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_ComboSelC | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdDetail_ComboSelChange: 진입점 집계 42검사 — ERROR:41 · FAIL:1 (FX-SSP0021-120) |  | 11 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0040 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_EditChang | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdDetail_EditChange: 진입점 집계 22검사 — ERROR:21 · FAIL:1 (FX-SSP0021-121) |  | 36 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0041 | X-ROW | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 9검사 — PASS:3 · FAIL:2 · NOPATH:2 · NA:1 · NOT_RUN:1 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0042 | X-ROW | SSP0021_ShipmentPlan.SpdMain_ClipboardPa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.SpdMain_ClipboardPasted: 진입점 집계 7검사 — ERROR:3 · NA:3 · FAIL:1 (FX-SSP0021-122) |  | 3 (ACT:SSP0021_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0021-0043 | X-ROW | SSP0021_ShipmentPlan.Validation_Check | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.Validation_Check: 진입점 집계 26검사 — ERROR:19 · NA:6 · FAIL:1 (FX-SSP0021-123) |  | 106 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0044 | X-ROW | SSP0021_ShipmentPlan.checkValidN | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.checkValidN: 진입점 집계 3검사 — NA:2 · FAIL:1 (FX-SSP0021-125) |  | 17 (ACT:SSP0021_ShipmentPlan.checkValidN ACT) |
| WK-SSP0021-0045 | X-ROW | SSP0021_ShipmentPlan.chkERPIFBlockYn | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.chkERPIFBlockYn: 진입점 집계 3검사 — NA:2 · FAIL:1 (FX-SSP0021-126) |  | 13 (ACT:SSP0021_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0021-0046 | X-ROW | SSP0021_ShipmentPlan.clbCompanyID_Select | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged: 진입점 집계 13검사 — PASS:4 · NOT_RUN:3 · NA:2 · ERROR:2 · NOPATH |  | 6 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0047 | X-ROW | SSP0021_ShipmentPlan.shtDetail_Change | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0021_ShipmentPlan.shtDetail_Change: 진입점 집계 9검사 — ERROR:8 · FAIL:1 (FX-SSP0021-128) |  | 71 (ACT:SSP0021_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0021-0048 | M4 | BOH_QTY | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — BOH_QTY: 실측[T-4f61c06e]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 20 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0049 | M4 | CONFIRM_ID / Confirm/Plan ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_ID / Confirm/Plan ID: 실측[T-1eacfd50]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영 |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0050 | M4 | D00-2-022 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-2-022: 행 집계 — 대조표 D00-2-022 '§2 spdMain / CellDoubleClick' 의 M4 11요소: FAIL:7 · NOT_RUN:3 · REVIEW:1 · FAIL 요소: PR |  | 1 (D00-2-022) |
| WK-SSP0021-0051 | M4 | D00-4d-023 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4d-023: 행 집계 — 대조표 D00-4d-023 '§4d BtnMeasure_Click / `fps != null`' 의 M4 11요소: FAIL:7 · NOT_RUN:3 · REVIEW:1 · F |  | 1 (D00-4d-023) |
| WK-SSP0021-0052 | M4 | DIVISION_ID / Div | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — DIVISION_ID / Div: 실측[T-f77657eb]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0053 | M4 | ERP_SO_NO / SO No | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ERP_SO_NO / SO No: 실측[T-2bdfa178]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0054 | M4 | MEASURE / Measure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — MEASURE / Measure: 실측[T-b7afeaa2]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 25 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0055 | M4 | MODAL:RequestorModal | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — MODAL:RequestorModal: 행 집계 — 대조표 MODAL:RequestorModal 'FE 실존 모달 (components/modals/RequestorModal.tsx) — ' 의 M4 11요소: |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0056 | M4 | Measure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — Measure: 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 M4 11요소: FAIL:7 · NOT_RUN:3 · REVIEW:1 · FAIL 요소: PROJECT_ |  | 1 (Measure) |
| WK-SSP0021-0057 | M4 | OrderDetail 팝업(SSP0300) | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — OrderDetail 팝업(SSP0300): 행 집계 — 대조표 OrderDetail 팝업(SSP0300) 'L1603 `new SSP0300_OrderDetailPopup()` **활성**' 의 M4 11요소 |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0058 | M4 | REMARKS2 / Building | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — REMARKS2 / Building: 실측[T-a6b72e08]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0059 | M4 | Requestor | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — Requestor: 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 M4 11요소: FAIL:7 · NOT_RUN:3 · REVIEW:1 · FAIL 요소: PROJECT_C |  | 1 (Requestor) |
| WK-SSP0021-0060 | M4 | SHIPMENT_DATE / Shipment Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPMENT_DATE / Shipment Date: 실측[T-0b96ede9]: ERP_SO_NO 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반 |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0061 | M4 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdMain_CellDoubleClick 의 M4 2요소: FAI |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0062 | M4 | drill-down | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — drill-down: 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 M4 11요소: FAIL:7 · NOT_RUN:3 · REVIEW:1 · FAIL 요소: PROJE |  | 1 (drill-down) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0063 | B1 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0064 | B2 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0065 | B4 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0066 | B6 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0067 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0068 | DB-SYN | SSP0021_SAVE_HOLD_STOCK_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_SAVE_HOLD_STOCK_DATA | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0069 | G4 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemID2 | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0070 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0071 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0072 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0073 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0074 | G4 | btnSimulation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSimulation | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0075 | E5 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0076 | G03-WIRE | SSP0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0021 화면 | 판단불가(대상 단위 SCREEN) | 32 (ACT:SSP0021_ShipmentPlan..ctor ACT:SSP00) |
| WK-SSP0021-0077 | G5 | ITEM_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_ID / Model | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0078 | G5 | PROJECT_CODE / Prj Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PROJECT_CODE / Prj Code | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0079 | G5 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0080 | G5 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0081 | H6 | ITEM_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID / Model | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0082 | H6 | PROJECT_CODE / Prj Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE / Prj Code | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0083 | H6 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0084 | H6 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0085 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-004 ACT:SSP0021_ShipmentPlan.InitE) |

## W7 기대값 확정 (79)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0086 | C4 | cboPlanDate / Plan-date / Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — cboPlanDate / Plan-date / Plan Date: 실측[T-099657c3]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] 조회 2 |  | 1 (D00-2-008) |
| WK-SSP0021-0087 | C4 | clbCompany_ID / Company / Company_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — clbCompany_ID / Company / Company_ID: 검증 엔진이 실행됐으나 이 대상(COND clbCompany_ID)을 판정하지 못함 — 조회조건 변경 시 그리드 상태(초기화·유지) = AS-I |  | 1 (D00-2-010) |
| WK-SSP0021-0088 | C4 | clbDivision_ID / Division / Division_ID  | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — clbDivision_ID / Division / Division_ID / Div / Di: 검증 엔진이 실행됐으나 이 대상(COND clbDivision_ID)을 판정하지 못함 — 조회조건 변경 시 그리드 상태 |  | 1 (D00-2-011) |
| WK-SSP0021-0089 | C4 | drpPeriod / Period / From / To / 기간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — drpPeriod / Period / From / To / 기간: 검증 엔진이 실행됐으나 이 대상(COND drpPeriod)을 판정하지 못함 — 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS 시나리 |  | 1 (D00-4d-025) |
| WK-SSP0021-0090 | C4 | drpPeriod2 / Shipment Date / Period2 / P | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — drpPeriod2 / Shipment Date / Period2 / Period / Fr: 검증 엔진이 실행됐으나 이 대상(COND drpPeriod2)을 판정하지 못함 — 조회조건 변경 시 그리드 상태(초기화 |  | 1 (D00-2-012) |
| WK-SSP0021-0091 | F4 | SSP0021_SAVE_HOLD_STOCK_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0021_SAVE_HOLD_STOCK_DATA: 실측[T-d1e0375e]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=co |  | 196 (ACT:SSP0021_ShipmentPlan.SaveButton ACT:) |
| WK-SSP0021-0092 | H5 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 4 (bucket 토글 × chkSum ACT:SSP0021_ShipmentP) |
| WK-SSP0021-0093 | X-REASON | D00-1-053 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-053 §1 emptySpaceItem2 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-053) |
| WK-SSP0021-0094 | X-REASON | D00-1-054 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-054 §1 emptySpaceItem3 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-054) |
| WK-SSP0021-0095 | X-REASON | D00-1-055 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-055 §1 emptySpaceItem5 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-055) |
| WK-SSP0021-0096 | X-REASON | D00-2-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-021 §2 spdDetail / TopChange — FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 제외 |  | 1 (D00-2-021) |
| WK-SSP0021-0097 | X-REASON | D00-2-025 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-025 §2 spdMain / TopChange — FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 제외 |  | 1 (D00-2-025) |
| WK-SSP0021-0098 | X-REASON | D00-4b-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-001 §4b Data_SCP.Common / SSPBlockCheckIF / dtERPBlockYnIF — ERP IF 블록 여부 사전체크 — Drafting/ERP IF 하위 SP 체 |  | 1 (D00-4b-001) |
| WK-SSP0021-0099 | X-REASON | D00-4d-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-021 §4d SpdDetail_CellClick / `e.Column == CHANGE_REQ_NO` — CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanReque |  | 1 (D00-4d-021) |
| WK-SSP0021-0100 | X-REASON | D00-4d-022 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-022 §4d SpdDetail_CellClick / `IsNullOrWhiteSpace(sRequestNo)` — CHANGE_REQ_NO 공백 시 팝업 미진입 가드 — 상위 팝업(D0 |  | 1 (D00-4d-022) |
| WK-SSP0021-0101 | X-REASON | Edit | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Edit 권한+모드토글 미이식(R6) 미이식(근거) |  | 1 (Edit) |
| WK-SSP0021-0102 | A1 | Box ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Box ID: 행 집계 — 대조표 Box ID '자유입력' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP — golden DIFF  |  | 1 (Box ID) |
| WK-SSP0021-0103 | A1 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Bucket: 행 집계 — 대조표 Bucket '`BucketType` lookup(기본 DAILY)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP002 |  | 1 (Bucket) |
| WK-SSP0021-0104 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 10요소: REVIEW:9 · PASS: |  | 1 (COMMON:UC-02) |
| WK-SSP0021-0105 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 10요소: REVIEW:9 · PASS: |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0106 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0107 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 10요소: REVIEW:9 · PASS: |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0108 | A1 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-009: 행 집계 — 대조표 D00-1-009 '§1 btnItemId / UsrButton' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP00 |  | 1 (D00-1-009) |
| WK-SSP0021-0109 | A1 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-012: 행 집계 — 대조표 D00-1-012 '§1 btnItemID2 / UsrButton' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0 |  | 1 (D00-1-012) |
| WK-SSP0021-0110 | A1 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-013: 행 집계 — 대조표 D00-1-013 '§1 btnRequestor / UsrButton' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SS |  | 1 (D00-1-013) |
| WK-SSP0021-0111 | A1 | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-015: 행 집계 — 대조표 D00-1-015 '§1 btnSearch / SimpleButton' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SS |  | 1 (D00-1-015) |
| WK-SSP0021-0112 | A1 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-021: 행 집계 — 대조표 D00-1-021 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PK |  | 1 (D00-1-021) |
| WK-SSP0021-0113 | A1 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-028: 행 집계 — 대조표 D00-1-028 '§1 usrLayoutControl2 / UsrLayoutControl' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_ |  | 1 (D00-1-028) |
| WK-SSP0021-0114 | A1 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-029: 행 집계 — 대조표 D00-1-029 '§1 usrLayoutControl3 / UsrLayoutControl' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_ |  | 1 (D00-1-029) |
| WK-SSP0021-0115 | A1 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 btnSearch / Click' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_G |  | 1 (D00-2-005) |
| WK-SSP0021-0116 | A1 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-007: 행 집계 — 대조표 D00-2-007 '§2 cboBucketType / SelectedIndexChanged' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_ |  | 1 (D00-2-007) |
| WK-SSP0021-0117 | A1 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find: 행 집계 — 대조표 Find 'FindData_Main' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP — golden  |  | 1 (Find) |
| WK-SSP0021-0118 | A1 | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — From Site: 행 집계 — 대조표 From Site '`Com_FromSite_SCP`' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET |  | 1 (From Site) |
| WK-SSP0021-0119 | A1 | MEASURE 세로축 표시/개인화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MEASURE 세로축 표시/개인화: 행 집계 — 대조표 MEASURE 세로축 표시/개인화 'SCM_MST_SHEET_MEASURE(9행)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소:  |  | 1 (MEASURE 세로축 표시/개인화) |
| WK-SSP0021-0120 | A1 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Measure: 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021 |  | 1 (Measure) |
| WK-SSP0021-0121 | A1 | Model×2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model×2: 행 집계 — 대조표 Model×2 'ItembyDivisionPopup(txtItemId/txtModel2)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP |  | 1 (Model×2) |
| WK-SSP0021-0122 | A1 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_HOLD_STOCK.md  |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0123 | A1 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_MES_STOCK.md —  |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0124 | A1 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_MES_STOC |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0125 | A1 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_OWMS_DETAIL.m |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0126 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION: golden DIFF AS-IS 0행 ↔ TO-BE 6행: Doc/golden/SSP0021/SSP0021_GET_SHIPMENT_ |  | 1 (Division/Company) |
| WK-SSP0021-0127 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_SHIPMENT_PL |  | 70 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0128 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_SHIP |  | 74 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0129 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_SHIPMENT_ |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0130 | A1 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0021/SSP0021_GET_STO |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0131 | A1 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Period: 행 집계 — 대조표 Period 'PlanDate 파생 FROM_DATE/TO_DATE1' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP00 |  | 1 (Period) |
| WK-SSP0021-0132 | A1 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plan Date: 행 집계 — 대조표 Plan Date '`Plan_Infor_SCP` @companyId' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SS |  | 1 (Plan Date) |
| WK-SSP0021-0133 | A1 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R3: 행 집계 — 대조표 R3 '활성 detail시트별 조회바 show/hide 매트릭스' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_ |  | 1 (R3) |
| WK-SSP0021-0134 | A1 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R4: 행 집계 — 대조표 R4 '탭클릭/더블클릭 시트전환 + 재조회' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP — golde |  | 1 (R4) |
| WK-SSP0021-0135 | A1 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Requestor: 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_ |  | 1 (Requestor) |
| WK-SSP0021-0136 | A1 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Result Type: 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SS |  | 1 (Result Type) |
| WK-SSP0021-0137 | A1 | Shipment Date(period2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Shipment Date(period2): 행 집계 — 대조표 Shipment Date(period2) 'drpPeriod2, 범위 clamp' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요 |  | 1 (Shipment Date(period2)) |
| WK-SSP0021-0138 | A1 | Shipment Date(period3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Shipment Date(period3): 행 집계 — 대조표 Shipment Date(period3) 'drpPeriod3, 기본 오늘-9~-1' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL |  | 1 (Shipment Date(period3)) |
| WK-SSP0021-0139 | A1 | TransMode 행단위 cascade 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — TransMode 행단위 cascade 재조회: 행 집계 — 대조표 TransMode 행단위 cascade 재조회 'L1789 `//siDetail.SetCellTypeCombo(... TRANSPORT_M' 의 |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0140 | A1 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 이벤트: 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP |  | 1 (이벤트) |
| WK-SSP0021-0141 | A1 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회: 행 집계 — 대조표 조회 'Measure 타이틀셋 개인화(`visibleMeasures`)' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_ |  | 1 (조회) |
| WK-SSP0021-0142 | A1 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 합계: 행 집계 — 대조표 합계 '`useAggregationRow` prop' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP —  |  | 1 (합계) |
| WK-SSP0021-0143 | A1 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 헤더: 행 집계 — 대조표 헤더 '그리드 `allowMerging`' 의 A1 10요소: REVIEW:9 · PASS:1 · FAIL 요소: PKG_SSP0021.P_SSP0021_GET_SHIP — golden |  | 1 (헤더) |
| WK-SSP0021-0144 | A1 | 확정구간(CONFIRM_DAY) 조회전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 확정구간(CONFIRM_DAY) 조회전용: 행 집계 — 대조표 확정구간(CONFIRM_DAY) 조회전용 'AS-IS·design 이탈 **정책 결정**' 의 A1 10요소: REVIEW:9 · PASS:1 · F |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0145 | G1 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — chkSum / Sum: E2E smoke cond checkbox / 실측[T-614923c0]: Sum 콤보 아님(checkbox) — 멀티선택 검사 대상 아님 |  | 1 (D00-1-004) |
| WK-SSP0021-0146 | X-LOC | OrderDetail 팝업(SSP0300) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OrderDetail 팝업(SSP0300): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0147 | X-LOC | R7a USER_CHECK 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R7a USER_CHECK 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R7a USER_CHECK 가드) |
| WK-SSP0021-0148 | X-LOC | TransMode 행단위 cascade 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TransMode 행단위 cascade 재조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0149 | X-LOC | 같은 셀 더블클릭 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 같은 셀 더블클릭 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (같은 셀 더블클릭 가드) |
| WK-SSP0021-0150 | X-LOC | 음수 검증 셀 색(시안 #5CD1E5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 음수 검증 셀 색(시안 #5CD1E5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |
| WK-SSP0021-0151 | X-LOC | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 이벤트: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (이벤트) |
| WK-SSP0021-0152 | X-LOC | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회) |
| WK-SSP0021-0153 | X-LOC | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 합계: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (합계) |
| WK-SSP0021-0154 | X-LOC | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 헤더: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (헤더) |
| WK-SSP0021-0155 | X-LOC | 확정구간(CONFIRM_DAY) 조회전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 확정구간(CONFIRM_DAY) 조회전용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0156 | X-ROW | SSP0021_ShipmentPlan.Measure_SearchIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Measure_SearchIdx: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:SSP0021_ShipmentPlan.Measure_SearchI) |
| WK-SSP0021-0157 | X-ROW | SSP0021_ShipmentPlan.ShipmentResult_GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.ShipmentResult_GetDayRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0021_ShipmentPlan.ShipmentResult_) |
| WK-SSP0021-0158 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_SheetTabC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된 요소 검사  |  | 15 (ACT:SSP0021_ShipmentPlan.SpdDetail_Sheet) |
| WK-SSP0021-0159 | H6 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname / Nic: E2E smoke cond popup |  | 1 (Model×2) |
| WK-SSP0021-0160 | H6 | txtModel2 / Model / Model2 / Model/Nickn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtModel2 / Model / Model2 / Model/Nickname / Nick: E2E smoke cond popup |  | 1 (Model×2) |
| WK-SSP0021-0161 | M4 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID / Model: 검증 엔진이 실행됐으나 이 대상(COL ITEM_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (D00-2-016 ACT:SSP0021_ShipmentPlan.SpdDe) |
| WK-SSP0021-0162 | M4 | PROJECT_CODE / Prj Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PROJECT_CODE / Prj Code: 실측[T-82350dfd]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] ERP_SO_NO 트리거 그리 |  | 1 (D00-2-016) |
| WK-SSP0021-0163 | M4 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname / Nic: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 1 (Model×2) |
| WK-SSP0021-0164 | M4 | txtModel2 / Model / Model2 / Model/Nickn | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtModel2 / Model / Model2 / Model/Nickname / Nick: 검증 엔진이 실행됐으나 이 대상(COND txtModel2)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 1 (Model×2) |

## W9 도구 오류 (540)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0165 | J2 | SSP0021 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-6afd3c5b RULE_SCREEN / 원장 V-955113c0 DEFECT / 원장 V-6bbf7c8c GENERAL / 원장 V-afd49f57 GENERAL / 원장 V-8c4d1f47 GENERA |  | 147 (D00-1-009 D00-1-012 D00-1-013 D00-1-015 ) |
| WK-SSP0021-0166 | C1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | C1 도구 오류 — 실측[T-6c0df427]: 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS 하위  |  | 2 (D00-2-007 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0167 | C1 | drpPeriod2 / Shipment Date / Period2 / P | 하네스·환경 | C1 도구 오류 — 실측[T-e187ea3d]: 상위 조건 'Shipment Date' 이 콤보가 아님(period) — 이 유형 변경 프로브 미구현 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-2-012) |
| WK-SSP0021-0168 | C2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C2 도구 오류 — 실측[T-999acaf9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 27 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0169 | C2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C2 도구 오류 — 실측[T-6f089cf5]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 6 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0170 | C2 | D00-2-013 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-013 '§2 dsdm / Changed' 의 C2 8요소: ERROR:8 |  | 1 (D00-2-013) |
| WK-SSP0021-0171 | C2 | D00-2-017 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-017 '§2 spdDetail / ClipboardPasted' 의 C2 8요소: ERROR:8 |  | 1 (D00-2-017) |
| WK-SSP0021-0172 | C2 | D00-2-019 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-019 '§2 spdDetail / EditChange' 의 C2 8요소: ERROR:8 |  | 1 (D00-2-019) |
| WK-SSP0021-0173 | C2 | D00-4d-001 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d shtDetail_Change / `CanModelChange != true \\' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-001) |
| WK-SSP0021-0174 | C2 | D00-4d-002 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-002 '§4d shtDetail_Change / `siDetail.ActiveSheet.RowCo' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-002) |
| WK-SSP0021-0175 | C2 | D00-4d-008 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-008 '§4d shtDetail_Change / `sNewChangeReasonCode=="-" ' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-008) |
| WK-SSP0021-0176 | C2 | D00-4d-013 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-013 '§4d SpdDetail_EditChange / `strReasonCode=="-" \\' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-013) |
| WK-SSP0021-0177 | C2 | D00-4d-016 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-016 '§4d SpdDetail_ClipboardPasted / `cell.Text != ""`' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-016) |
| WK-SSP0021-0178 | C2 | D00-4d-018 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-018 '§4d SpdDetail_ClipboardPasted / `dr == null`' 의 C2 8요소: ERROR:8 |  | 1 (D00-4d-018) |
| WK-SSP0021-0179 | C2 | DIVISION_ID / Div | 하네스·환경 | C2 도구 오류 — 실측[T-4f09b048]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0180 | C2 | EDIT_MAIN | 하네스·환경 | C2 도구 오류 — 실측[T-e834f517]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 9 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0181 | C2 | ERP_SO_NO / SO No | 하네스·환경 | C2 도구 오류 — 실측[T-f79d1d3b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 8 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0182 | C2 | MEASURE / Measure | 하네스·환경 | C2 도구 오류 — 실측[T-c18f7063]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0183 | C2 | NEW_ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-3421f22b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0184 | C2 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged 의 C2 8요소: ERROR:8 |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0185 | C2 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C2 8요소: ERROR:8 |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0186 | C2 | SSP0021_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C2 8요소: ERROR:8 |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0187 | C2 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0188 | C2 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.chkSum_CheckedChanged 의 C2 8요소: ERROR:8 |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0189 | C2 | SSP0021_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C2 8요소: ERROR:8 |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0190 | C2 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0191 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 실측[T-7e4a55c3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 38 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0192 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-10673f54 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0193 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-001b5986 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0194 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-47549f74 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0195 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 원장 V-10673f54 ASIS / 원장 V-0a5db0b2 ASIS / 원장 V-bb8c66c5 ASIS / 원장 V-001b5986 ASIS / 원장 V-c4050771 ASIS / 원장 V-47549f74  |  | 36 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0196 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-554b689e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0197 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-8154b20c |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0198 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-4f275ffa |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0199 | C3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C3 도구 오류 — 원장 V-554b689e ASIS / 원장 V-8154b20c ASIS / 원장 V-76701670 ASIS / 원장 V-4f275ffa ASIS / 원장 V-a9a9ac34 ASIS / 실측[T-c3cb2bad] |  | 15 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0200 | C3 | CHILD_QTY / Shipment Pack Qty | 하네스·환경 | C3 도구 오류 — 실측[T-32da8ad1]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InitSpread:727:) |
| WK-SSP0021-0201 | C3 | D00-2-013 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-013 '§2 dsdm / Changed' 의 C3 53요소: ERROR:53 |  | 1 (D00-2-013) |
| WK-SSP0021-0202 | C3 | D00-2-017 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-017 '§2 spdDetail / ClipboardPasted' 의 C3 53요소: ERROR:53 |  | 1 (D00-2-017) |
| WK-SSP0021-0203 | C3 | D00-2-019 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-019 '§2 spdDetail / EditChange' 의 C3 53요소: ERROR:53 |  | 1 (D00-2-019) |
| WK-SSP0021-0204 | C3 | D00-2-024 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-024 '§2 spdMain / ClipboardPasted' 의 C3 53요소: ERROR:53 |  | 1 (D00-2-024) |
| WK-SSP0021-0205 | C3 | D00-4d-001 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d shtDetail_Change / `CanModelChange != true \\' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-001) |
| WK-SSP0021-0206 | C3 | D00-4d-002 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-002 '§4d shtDetail_Change / `siDetail.ActiveSheet.RowCo' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-002) |
| WK-SSP0021-0207 | C3 | D00-4d-008 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-008 '§4d shtDetail_Change / `sNewChangeReasonCode=="-" ' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-008) |
| WK-SSP0021-0208 | C3 | D00-4d-013 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-013 '§4d SpdDetail_EditChange / `strReasonCode=="-" \\' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-013) |
| WK-SSP0021-0209 | C3 | D00-4d-014 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-014 '§4d SpdDetail_ClipboardPasted / `siDetail.IsLock =' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-014) |
| WK-SSP0021-0210 | C3 | D00-4d-015 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-015 '§4d SpdDetail_ClipboardPasted / `SheetName == shtP' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-015) |
| WK-SSP0021-0211 | C3 | D00-4d-016 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-016 '§4d SpdDetail_ClipboardPasted / `cell.Text != ""`' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-016) |
| WK-SSP0021-0212 | C3 | D00-4d-018 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-018 '§4d SpdDetail_ClipboardPasted / `dr == null`' 의 C3 53요소: ERROR:53 |  | 1 (D00-4d-018) |
| WK-SSP0021-0213 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 실측[T-a9fe8b07]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 5 (ACT:SSP0021_ShipmentPlan.InsertRow:2198:) |
| WK-SSP0021-0214 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-23e634c8 ASIS / 원장 V-3b96ef89 ASIS / 원장 V-10da5613 ASIS / 원장 V-f87ce5f3 ASIS / 원장 V-c161d6a7 ASIS / 원장 V-77b79a46  |  | 34 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0215 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-23e634c8 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0216 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-3b96ef89 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0217 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-10da5613 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0218 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f87ce5f3 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0219 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c161d6a7 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0220 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-77b79a46 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0221 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-242cf80a |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0222 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c0a670e5 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0223 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-48a76fef |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0224 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-372ea94c |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0225 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-21d2ed89 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0226 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-1ca9812e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0227 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-0a5db0b2 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0228 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-bb8c66c5 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0229 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c4050771 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0230 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-72e3b8eb |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0231 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-eff0f124 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0232 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-870b54cd |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0233 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-76701670 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0234 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-a9a9ac34 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0235 | C3 | ERP_SO_NO / SO No | 하네스·환경 | C3 도구 오류 — 실측[T-8f9fceec]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 21 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0236 | C3 | FROM_SITE / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-1a0ec5dd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2199:) |
| WK-SSP0021-0237 | C3 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-87c7a70e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2200:) |
| WK-SSP0021-0238 | C3 | FROM_SITE_NM / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-03444c4c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2200:) |
| WK-SSP0021-0239 | C3 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | C3 도구 오류 — 실측[T-1a1d7640]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2207:) |
| WK-SSP0021-0240 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-11f62d45]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2201:) |
| WK-SSP0021-0241 | C3 | LOT_YN / Lot_YN | 하네스·환경 | C3 도구 오류 — 실측[T-140b4e2d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.Re_Design:4777:) |
| WK-SSP0021-0242 | C3 | MEASURE / Measure | 하네스·환경 | C3 도구 오류 — 실측[T-298fea47]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 14 (ACT:SSP0021_ShipmentPlan.EditButton:2443) |
| WK-SSP0021-0243 | C3 | NEW_ETD / ETD | 하네스·환경 | C3 도구 오류 — 실측[T-ffadabe3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0244 | C3 | NEW_LT_DAY / L/T(Day | 하네스·환경 | C3 도구 오류 — 실측[T-6fb00ff7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0245 | C3 | NEW_ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-c21318c7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0246 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-965aff21 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0247 | C3 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-965aff21 ASIS / 실측[T-a4e9014f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail  |  | 3 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0248 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-a85c9c30]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2202:) |
| WK-SSP0021-0249 | C3 | PSI | 하네스·환경 | C3 도구 오류 — 실측[T-7fdb2844]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.InitSpread:627:) |
| WK-SSP0021-0250 | C3 | REMARKS / Remarks | 하네스·환경 | C3 도구 오류 — 원장 V-77b79a46 ASIS / 원장 V-242cf80a ASIS / 원장 V-10673f54 ASIS / 원장 V-c0a670e5 ASIS / 원장 V-48a76fef ASIS / 원장 V-554b689e  |  | 7 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0251 | C3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | C3 도구 오류 — 원장 V-c161d6a7 ASIS / 원장 V-77b79a46 ASIS / 원장 V-242cf80a ASIS / 원장 V-10673f54 ASIS / 원장 V-c0a670e5 ASIS / 원장 V-48a76fef  |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0252 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-38cfbbd5 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0253 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-c6cb0f00 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0254 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-897e19d4 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0255 | C3 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-38cfbbd5 ASIS / 원장 V-965aff21 ASIS / 원장 V-10da5613 ASIS / 원장 V-c6cb0f00 ASIS / 원장 V-f87ce5f3 ASIS / 원장 V-c161d6a7  |  | 15 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0256 | C3 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged 의 C3 53요소: ERROR:53 |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0257 | C3 | SSP0021_ShipmentPlan.SetChangeControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SetChangeControl 의 C3 53요소: ERROR:53 |  | 12 (ACT:SSP0021_ShipmentPlan.SetChangeContro) |
| WK-SSP0021-0258 | C3 | SSP0021_ShipmentPlan.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SetChangedControl 의 C3 1요소: ERROR:1 |  | 10 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0259 | C3 | SSP0021_ShipmentPlan.SetSpreadColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0260 | C3 | SSP0021_ShipmentPlan.Set_SumValues | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.Set_SumValues 의 C3 53요소: ERROR:53 |  | 25 (ACT:SSP0021_ShipmentPlan.Set_SumValues:4) |
| WK-SSP0021-0261 | C3 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C3 53요소: ERROR:53 |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0262 | C3 | SSP0021_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C3 53요소: ERROR:53 |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0263 | C3 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C3 1요소: ERROR:1 |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0264 | C3 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.chkSum_CheckedChanged 의 C3 53요소: ERROR:53 |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0265 | C3 | SSP0021_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C3 53요소: ERROR:53 |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0266 | C3 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C3 1요소: ERROR:1 |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0267 | C3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C3 도구 오류 — 원장 V-23e634c8 ASIS / 원장 V-3b96ef89 ASIS / 원장 V-38cfbbd5 ASIS / 원장 V-965aff21 ASIS / 원장 V-10da5613 ASIS / 원장 V-c6cb0f00  |  | 44 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0268 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-84bc05e0 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0269 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-7bdb0e75 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0270 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-417baf3e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0271 | C6 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C6 도구 오류 — 원장 V-84bc05e0 ASIS / 원장 V-3102eb8a ASIS / 원장 V-b1036dbc ASIS / 원장 V-d2ae45f5 ASIS / 원장 V-7bdb0e75 ASIS / 원장 V-2c311bf9  |  | 27 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0272 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-7e065138 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0273 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-b1036dbc |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0274 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-2c311bf9 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0275 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-07e58c3a |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0276 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-02205d0e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0277 | C6 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C6 도구 오류 — 원장 V-7e065138 ASIS / 원장 V-b1036dbc ASIS / 원장 V-2c311bf9 ASIS / 원장 V-07e58c3a ASIS / 원장 V-9af90e10 ASIS / 원장 V-02205d0e  |  | 6 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0278 | C6 | D00-2-013 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-013 '§2 dsdm / Changed' 의 C6 41요소: ERROR:41 |  | 1 (D00-2-013) |
| WK-SSP0021-0279 | C6 | D00-2-017 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-017 '§2 spdDetail / ClipboardPasted' 의 C6 41요소: ERROR:41 |  | 1 (D00-2-017) |
| WK-SSP0021-0280 | C6 | D00-2-019 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-019 '§2 spdDetail / EditChange' 의 C6 41요소: ERROR:41 |  | 1 (D00-2-019) |
| WK-SSP0021-0281 | C6 | D00-4d-001 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d shtDetail_Change / `CanModelChange != true \\' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-001) |
| WK-SSP0021-0282 | C6 | D00-4d-002 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-002 '§4d shtDetail_Change / `siDetail.ActiveSheet.RowCo' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-002) |
| WK-SSP0021-0283 | C6 | D00-4d-008 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-008 '§4d shtDetail_Change / `sNewChangeReasonCode=="-" ' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-008) |
| WK-SSP0021-0284 | C6 | D00-4d-013 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-013 '§4d SpdDetail_EditChange / `strReasonCode=="-" \\' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-013) |
| WK-SSP0021-0285 | C6 | D00-4d-016 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-016 '§4d SpdDetail_ClipboardPasted / `cell.Text != ""`' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-016) |
| WK-SSP0021-0286 | C6 | D00-4d-018 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-018 '§4d SpdDetail_ClipboardPasted / `dr == null`' 의 C6 41요소: ERROR:41 |  | 1 (D00-4d-018) |
| WK-SSP0021-0287 | C6 | DIVISION_ID / Div | 하네스·환경 | C6 도구 오류 — 실측[T-957f12c8]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0288 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8a0eaea6 ASIS / 원장 V-b146ccdc ASIS / 원장 V-765191b8 ASIS / 원장 V-4dd26f0b ASIS / 원장 V-ae566406 ASIS / 원장 V-0e30f522  |  | 9 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0289 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8a0eaea6 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0290 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-b146ccdc |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0291 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-765191b8 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0292 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-4dd26f0b |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0293 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ae566406 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0294 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-0e30f522 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0295 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-c755f891 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0296 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-5bca3104 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0297 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-166ced5e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0298 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8faa9c6e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0299 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-81c4d571 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0300 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-a1a10133 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0301 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-3102eb8a |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0302 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d2ae45f5 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0303 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-521dbf12 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0304 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-52a98242 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0305 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-c07e4606 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0306 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-77f59b10 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0307 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-9af90e10 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0308 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-e87436dc |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0309 | C6 | ERP_SO_NO / SO No | 하네스·환경 | C6 도구 오류 — 실측[T-b0bf85d6]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 8 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0310 | C6 | MEASURE / Measure | 하네스·환경 | C6 도구 오류 — 실측[T-3bfec152]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0311 | C6 | NEW_ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-e5444a37]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0312 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-8e883de8 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0313 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-6fb5af34 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0314 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-b0b8487b |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0315 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-fa9a513b |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0316 | C6 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged 의 C6 41요소: ERROR:41 |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0317 | C6 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C6 41요소: ERROR:41 |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0318 | C6 | SSP0021_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C6 41요소: ERROR:41 |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0319 | C6 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0320 | C6 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.chkSum_CheckedChanged 의 C6 41요소: ERROR:41 |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0321 | C6 | SSP0021_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C6 41요소: ERROR:41 |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0322 | C6 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0323 | C6 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C6 도구 오류 — 원장 V-8a0eaea6 ASIS / 원장 V-b146ccdc ASIS / 원장 V-1f7c58ff ASIS / 원장 V-6fb5af34 ASIS / 원장 V-8e883de8 ASIS / 원장 V-765191b8  |  | 38 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0324 | C6 | siDetail.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-1f7c58ff |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0325 | B1 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | B1 도구 오류 — 원장 V-9609bac2 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0326 | B1 | COMMON:UC-05 | 하네스·환경 | B1 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B1 12요소: PASS:5 · ERROR:5 · NOPATH:1 · N |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0327 | B1 | DIVISION_ID / Div | 하네스·환경 | B1 도구 오류 — 원장 V-e597a2d3 COLUMN / 원장 V-5d2da627 COLUMN / 원장 V-fbe85be6 COLUMN |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0328 | B1 | FCST_TYPE / FCST Type | 하네스·환경 | B1 도구 오류 — 원장 V-bb90ddd7 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0329 | B1 | SHIPMENT_STATUS / Status | 하네스·환경 | B1 도구 오류 — 원장 V-e7e60433 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0330 | B1 | STOCK_STATUS / Inventory Status | 하네스·환경 | B1 도구 오류 — 원장 V-aea5bd06 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0331 | B2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | B2 도구 오류 — 원장 V-23ea706f COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0332 | B2 | COMMON:UC-05 | 하네스·환경 | B2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B2 12요소: PASS:5 · ERROR:5 · NOPATH:1 · N |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0333 | B2 | DIVISION_ID / Div | 하네스·환경 | B2 도구 오류 — 원장 V-fa487c17 COLUMN / 원장 V-e70b1805 COLUMN / 원장 V-666e1086 COLUMN |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0334 | B2 | FCST_TYPE / FCST Type | 하네스·환경 | B2 도구 오류 — 원장 V-00c12ea6 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0335 | B2 | SHIPMENT_STATUS / Status | 하네스·환경 | B2 도구 오류 — 원장 V-ab1ee6c0 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0336 | B2 | STOCK_STATUS / Inventory Status | 하네스·환경 | B2 도구 오류 — 원장 V-8deb6be5 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0337 | B3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | B3 도구 오류 — 원장 V-914dd77e COLUMN |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0338 | B3 | DIVISION_ID / Div | 하네스·환경 | B3 도구 오류 — 원장 V-9d6f6b95 COLUMN / 원장 V-9058424b COLUMN / 원장 V-af317497 COLUMN |  | 9 (셀콤보 DIVISION_ID(Hold/Result) ACT:SSP0021) |
| WK-SSP0021-0339 | B3 | FCST_TYPE / FCST Type | 하네스·환경 | B3 도구 오류 — 원장 V-85bea613 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0340 | B3 | Result Type | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 B3 15요소: NA:9 · ERROR:5 · PASS:1 |  | 1 (Result Type) |
| WK-SSP0021-0341 | B3 | SHIPMENT_STATUS / Status | 하네스·환경 | B3 도구 오류 — 원장 V-450b01cd COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0342 | B3 | SSP0021_ShipmentPlan.GetBucketType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetBucketType 의 B3 15요소: NA:9 · ERROR:5 · PASS:1 |  | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0343 | B3 | SSP0021_ShipmentPlan.GetERPInterface | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetERPInterface 의 B3 6요소: NA:5 · ERROR:1 |  | 85 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0344 | B3 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetErpIFCheckNew 의 B3 15요소: NA:9 · ERROR:5 · PASS:1 |  | 43 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0345 | B3 | SSP0021_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetErpSoNoCnt 의 B3 15요소: NA:9 · ERROR:5 · PASS:1 |  | 9 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt:3) |
| WK-SSP0021-0346 | B3 | SSP0021_ShipmentPlan.GetSSPUserCheck | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetSSPUserCheck 의 B3 15요소: NA:9 · ERROR:5 · PASS:1 |  | 9 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0347 | B3 | STOCK_STATUS / Inventory Status | 하네스·환경 | B3 도구 오류 — 원장 V-f8df542b COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0348 | B4 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | B4 도구 오류 — 원장 V-dc4d2d24 COLUMN |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0349 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPA |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0350 | B4 | DIVISION_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-7de26df7 COLUMN / 원장 V-282c4b1b COLUMN / 원장 V-7bcd14f5 COLUMN |  | 9 (셀콤보 DIVISION_ID(Hold/Result) ACT:SSP0021) |
| WK-SSP0021-0351 | B4 | FCST_TYPE / FCST Type | 하네스·환경 | B4 도구 오류 — 원장 V-4771d552 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0352 | B4 | Result Type | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPATH:1 |  | 1 (Result Type) |
| WK-SSP0021-0353 | B4 | SHIPMENT_STATUS / Status | 하네스·환경 | B4 도구 오류 — 원장 V-3e8aacfe COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0354 | B4 | SSP0021_ShipmentPlan.GetBucketType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetBucketType 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPATH:1 |  | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0355 | B4 | SSP0021_ShipmentPlan.GetERPInterface | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetERPInterface 의 B4 6요소: NA:5 · ERROR:1 |  | 85 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0356 | B4 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetErpIFCheckNew 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPATH:1 |  | 43 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0357 | B4 | SSP0021_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetErpSoNoCnt 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPATH:1 |  | 9 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt:3) |
| WK-SSP0021-0358 | B4 | SSP0021_ShipmentPlan.GetSSPUserCheck | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetSSPUserCheck 의 B4 21요소: NA:10 · ERROR:9 · PASS:1 · NOPATH:1 |  | 9 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0359 | B4 | STOCK_STATUS / Inventory Status | 하네스·환경 | B4 도구 오류 — 원장 V-a729a089 COLUMN |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0360 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스·환경 | B4 도구 오류 — 원장 V-4f933db4 SEARCH |  | 1 (D00-1-006) |
| WK-SSP0021-0361 | B4 | clbCompany_ID / Company / Company_ID | 하네스·환경 | B4 도구 오류 — 원장 V-da157832 SEARCH |  | 1 (D00-1-010) |
| WK-SSP0021-0362 | B4 | clbDivision_ID / Division / Division_ID  | 하네스·환경 | B4 도구 오류 — 원장 V-43d4bfe9 SEARCH |  | 1 (D00-1-001) |
| WK-SSP0021-0363 | B4 | clbPlantSite / From Site / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-17d5558d SEARCH |  | 1 (D00-1-002) |
| WK-SSP0021-0364 | G3 | SSP0021 화면 | 하네스·환경 | G3 도구 오류 — 원장 V-785b03ce RULE_SCREEN / 원장 V-bf11754d GENERAL / 원장 V-f822388b GENERAL / 원장 V-d298b747 GENERAL / 원장 V-5146020f CONFI |  | 10 (D00-1-021 D00-1-028 D00-1-030 COMMON:UC-) |
| WK-SSP0021-0365 | K4 | SSP0021 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-9a92461b GENERAL / 원장 V-44f3038e GENERAL / 원장 V-1f5fe935 GENERAL / 원장 V-a8d4d2e0 GENERAL / 원장 V-e2a09868 GENERAL / |  | 99 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0021-0366 | F1 | SSP0021 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-76f93c5e RULE_SCREEN / 원장 V-d4db39cd RULE_SCREEN / 원장 V-5d28c85f RULE_SCREEN / 원장 V-a8a4e7fc RULE_SCREEN / 원장 V-e2 |  | 204 (D00-4d-005 D00-4d-006 D00-4d-020 COMMON:) |
| WK-SSP0021-0367 | F2 | SSP0021 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-ebd7ef87 RULE_SCREEN / 원장 V-fa15b9c5 RULE_SCREEN / 원장 V-eba5ec93 GENERAL / 원장 V-b318cb48 GENERAL / 원장 V-1afcb715 G |  | 203 (D00-4d-005 D00-4d-006 D00-4d-020 COMMON:) |
| WK-SSP0021-0368 | F3 | SSP0021 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-bc5d4758 RULE_SCREEN / 원장 V-ae0c4955 RULE_SCREEN / 원장 V-3d815d46 GENERAL / 원장 V-4dea97f2 GENERAL / 원장 V-a16ae938 G |  | 105 (D00-2-017 D00-2-024 D00-4d-014 D00-4d-01) |
| WK-SSP0021-0369 | F5 | SSP0021 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-3788ec55 RULE_SCREEN / 원장 V-c00e13c3 RULE_SCREEN / 원장 V-1c7168e3 RULE_SCREEN / 원장 V-3861da2e DEFECT / 원장 V-e5c71d2 |  | 1 (Delete) |
| WK-SSP0021-0370 | F6 | SSP0021 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-60ca3425 RULE_SCREEN / 원장 V-c5962c8b RULE_SCREEN / 원장 V-18b3e28a RULE_SCREEN / 원장 V-67e3e0f7 RULE_SCREEN / 원장 V-ee |  | 198 (Save ACT:SSP0021_ShipmentPlan.SaveButton) |
| WK-SSP0021-0371 | F4 | Find | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Find 'FindData_Main' 의 F4 19요소: ERROR:11 · NA:4 · PASS:3 · REVIEW:1 · FAIL 요소: SSP0021_SAVE_HOLD_STOCK_DATA  |  | 1 (Find) |
| WK-SSP0021-0372 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | F4 도구 오류 — E2E smoke call-proc / 실측[T-c7c5585a]: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: SCP0009/calendar/SEARCH, SCP0010/ |  | 662 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0373 | F4 | PKG_SSP0021.P_SSP0021_GET_ERP_SO_NO_CNT | 하네스·환경 | F4 도구 오류 — 실측[T-88ebbcdc]: PKG_SSP0021.P_SSP0021_GET_ERP_SO_NO_CNT: SSP0021/main/GET_ERP_SO_NO_CNT — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 201 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0374 | F4 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-21e9fb2b]: PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK: SSP0021/holdStock/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0375 | F4 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-3ee6f1f7]: PKG_SSP0021.P_SSP0021_GET_MES_STOCK: SSP0021/mesStock/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리 |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0376 | F4 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | 하네스·환경 | F4 도구 오류 — 실측[T-3b5b9e22]: PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL: SSP0021/mesStockDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조 |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0377 | F4 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-cf65b621]: PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL: SSP0021/owmsDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0378 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_FROM_ | 하네스·환경 | F4 도구 오류 — 실측[T-48a630b5]: PKG_SSP0021.P_SSP0021_GET_SHIPMENT_FROM_SITE: SSP0021/fromSite/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 |  | 2 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0379 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-0dd84b8e]: PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL: SSP0021/planDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조 |  | 269 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0380 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | 하네스·환경 | F4 도구 오류 — 실측[T-86437ba9]: PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT: SSP0021/shipmentResult/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0381 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-ab71c8f8]: PKG_SSP0021.P_SSP0021_GET_SHIPMENT_STATUS: SSP0021/main/GET_SHIPMENT_STATUS — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 201 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0382 | F4 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | 하네스·환경 | F4 도구 오류 — 실측[T-db6e1210]: PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL: SSP0021/stockDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0383 | F4 | SSP0021_ShipmentPlan.ChkConfirmChangeTim | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.ChkConfirmChangeTime 의 F4 19요소: ERROR:11 · NA:4 · PASS:3 · REVIEW:1 · FAIL 요소: SSP002 |  | 2 (ACT:SSP0021_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0021-0384 | F4 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.GetErpIFCheckNew 의 F4 19요소: ERROR:11 · NA:4 · PASS:3 · REVIEW:1 · FAIL 요소: SSP0021_SA |  | 6 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0385 | F4 | Save | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Save 'SaveData_Detail' 의 F4 19요소: ERROR:11 · NA:4 · PASS:3 · REVIEW:1 · FAIL 요소: SSP0021_SAVE_HOLD_STOCK_DAT |  | 1 (Save) |
| WK-SSP0021-0386 | A5 | CHILD_QTY / Shipment Pack Qty | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-8ae14d65]: CHILD_QTY: [측정 경로 없음] AS-IS 시트 Shipment Result 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정( |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0387 | A5 | COMMON:UC-01 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0388 | A5 | COMMON:UC-05 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0389 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0390 | A5 | D00-1-024 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-024 '§1 spdMain_Sheet1 / SheetView' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (D00-1-024) |
| WK-SSP0021-0391 | A5 | D00-1-025 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-025 '§1 spdDetail / FpSpread' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (D00-1-025) |
| WK-SSP0021-0392 | A5 | D00-1-026 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-026 '§1 spdDetail_Sheet1 / SheetView' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (D00-1-026) |
| WK-SSP0021-0393 | A5 | D00-2-011 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-2-011 '§2 clbDivision_ID / SelectedIndexChanged' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (D00-2-011) |
| WK-SSP0021-0394 | A5 | D00-2-014 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-2-014 '§2 spdDetail / ActiveSheetChanged' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (D00-2-014) |
| WK-SSP0021-0395 | A5 | DAY_CODE | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-6dca96ff]: DAY_CODE: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0396 | A5 | R10 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R10 '시트탭 상시노출' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (R10) |
| WK-SSP0021-0397 | A5 | R2 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R2 '초기 hidden 3필드(ResultType/ShipmentDate/BoxID)' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (R2) |
| WK-SSP0021-0398 | A5 | R3 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R3 '활성 detail시트별 조회바 show/hide 매트릭스' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (R3) |
| WK-SSP0021-0399 | A5 | R4 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R4 '탭클릭/더블클릭 시트전환 + 재조회' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (R4) |
| WK-SSP0021-0400 | A5 | SHIP_PLAN 편집 + Simulation | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 SHIP_PLAN 편집 + Simulation 'Simulation() 5산식' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0401 | A5 | SSP0021_ShipmentPlan.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-8c88adb4]: AS-IS 기본 표시 컬럼 4 ⊆ TO-BE 그리드 79: 누락 ATTRIBUTE10, A_COUNTRY, A_PORT_CODE, A_PORT_NAME (AS-IS 숨김·코드추가 hel |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0402 | A5 | SSP0021_ShipmentPlan.SetSpreadColumn | 하네스·환경 | A5 도구 오류 — 실측[T-e37bc749]: AS-IS 기본 표시 컬럼 4 ⊆ TO-BE 그리드 79: 누락 ATTRIBUTE10, A_COUNTRY, A_PORT_CODE, A_PORT_NAME (AS-IS 숨김·코드추가 hel |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0403 | A5 | STOCK_STATUS / Inventory Status | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-6911628f]: STOCK_STATUS: [측정 경로 없음] AS-IS 시트 oWMS Detail 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0404 | A5 | bucket 토글 × chkSum | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 bucket 토글 × chkSum 'SetSpreadColumn' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (bucket 토글 × chkSum) |
| WK-SSP0021-0405 | A5 | drill-down | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (drill-down) |
| WK-SSP0021-0406 | A5 | white-list 편집 5+2열 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 white-list 편집 5+2열 'LockRange/IsLock + 가드' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0407 | A5 | 동적 pivot D_/W_/M_ | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 동적 pivot D_/W_/M_ 'SCP0009 calendar 3span + InitSpreadDateColumn' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0408 | A5 | 이벤트 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (이벤트) |
| WK-SSP0021-0409 | A5 | 조회 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 조회 'Measure 타이틀셋 개인화(`visibleMeasures`)' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (조회) |
| WK-SSP0021-0410 | A5 | 합계 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 합계 '`useAggregationRow` prop' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (합계) |
| WK-SSP0021-0411 | A5 | 헤더 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 헤더 '그리드 `allowMerging`' 의 A5 18요소: PASS:15 · ERROR:3 |  | 1 (헤더) |
| WK-SSP0021-0412 | H10 | SSP0021 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 11 (D00-4d-004 D00-4d-013 D00-4d-025 COMMON:) |
| WK-SSP0021-0413 | H2 | BOH_TYPE | 하네스·환경 | H2 도구 오류 — 원장 V-d6be6e2e COLUMN / 실측[T-db4e0412]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0414 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-d42802ff |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0415 | H2 | CHANGE_REASON_CODE | 하네스·환경 | H2 도구 오류 — 원장 V-569f06ab |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0416 | H2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | H2 도구 오류 — 원장 V-a3a88865 COLUMN / 원장 V-d42802ff ASIS / 원장 V-569f06ab ASIS / 원장 V-21369e5c ASIS / 원장 V-9e9e1d1b ASIS / 원장 V-5d5b528 |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0417 | H2 | COMMON:UC-01 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0418 | H2 | COMMON:UC-05 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0419 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0420 | H2 | D00-1-024 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-024 '§1 spdMain_Sheet1 / SheetView' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (D00-1-024) |
| WK-SSP0021-0421 | H2 | D00-1-025 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-025 '§1 spdDetail / FpSpread' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (D00-1-025) |
| WK-SSP0021-0422 | H2 | D00-1-026 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-026 '§1 spdDetail_Sheet1 / SheetView' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (D00-1-026) |
| WK-SSP0021-0423 | H2 | D00-2-011 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2-011 '§2 clbDivision_ID / SelectedIndexChanged' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (D00-2-011) |
| WK-SSP0021-0424 | H2 | D00-2-014 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2-014 '§2 spdDetail / ActiveSheetChanged' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (D00-2-014) |
| WK-SSP0021-0425 | H2 | DAY_CODE | 하네스·환경 | H2 도구 오류 — 실측[T-61d66e46]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0426 | H2 | DIVISION_ID / Div | 하네스·환경 | H2 도구 오류 — 원장 V-fea5c5c9 COLUMN / 원장 V-18ca5bbd COLUMN / 원장 V-48b44813 COLUMN / 원장 V-a27ba12a COLUMN / 원장 V-a7ac39e1 COLUMN / 원장 V |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0427 | H2 | ERP_SO_NO | 하네스·환경 | H2 도구 오류 — 원장 V-65bc719b |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0428 | H2 | ERP_SO_NO / SO No | 하네스·환경 | H2 도구 오류 — 원장 V-c2d11729 COLUMN / 원장 V-eaf9f62d COLUMN / 원장 V-65bc719b ASIS / 실측[T-be891208]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 —  |  | 2 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0429 | H2 | FCST_TYPE / FCST Type | 하네스·환경 | H2 도구 오류 — 원장 V-b89468eb COLUMN / 실측[T-d7026f7b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0430 | H2 | PSI | 하네스·환경 | H2 도구 오류 — 원장 V-97c084e1 COLUMN / 실측[T-3fa66d12]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 3 (D00-1-023 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0431 | H2 | R10 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R10 '시트탭 상시노출' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (R10) |
| WK-SSP0021-0432 | H2 | R3 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R3 '활성 detail시트별 조회바 show/hide 매트릭스' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (R3) |
| WK-SSP0021-0433 | H2 | R4 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R4 '탭클릭/더블클릭 시트전환 + 재조회' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (R4) |
| WK-SSP0021-0434 | H2 | REMARKS / Remarks | 하네스·환경 | H2 도구 오류 — 원장 V-365fa7a4 COLUMN / 원장 V-424670fb COLUMN / 원장 V-21cbfd2e COLUMN / 원장 V-d42802ff ASIS / 원장 V-569f06ab ASIS / 원장 V-36a |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0435 | H2 | REMARKS2 / Building | 하네스·환경 | H2 도구 오류 — 원장 V-c31b97cc COLUMN / 원장 V-a4da8ca3 ASIS / 원장 V-b6d2314d ASIS / 실측[T-45c729cd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0436 | H2 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | H2 도구 오류 — 원장 V-90528bed COLUMN / 원장 V-19557d39 ASIS / 원장 V-5576a1aa ASIS / 원장 V-d42802ff ASIS / 원장 V-569f06ab ASIS / 원장 V-21369e5 |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0437 | H2 | SHIPMENT_DATE | 하네스·환경 | H2 도구 오류 — 원장 V-46ccdaa2 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0438 | H2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H2 도구 오류 — 원장 V-295017c4 COLUMN / 원장 V-19557d39 ASIS / 원장 V-5576a1aa ASIS / 원장 V-46ccdaa2 ASIS / 원장 V-d42802ff ASIS / 원장 V-569f06a |  | 3 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0439 | H2 | SHIPMENT_STATUS / Status | 하네스·환경 | H2 도구 오류 — 원장 V-f6a2f73f COLUMN / 실측[T-c9631828]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0440 | H2 | SHIP_PLAN 편집 + Simulation | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SHIP_PLAN 편집 + Simulation 'Simulation() 5산식' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0441 | H2 | SSP0021_ShipmentPlan.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.CreateSpread 의 H2 41요소: ERROR:36 · NA:5 |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0442 | H2 | STOCK_STATUS / Inventory Status | 하네스·환경 | H2 도구 오류 — 원장 V-347b2d83 COLUMN / 실측[T-75034acf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0443 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-c8686ca2 COLUMN / 원장 V-6af510fb COLUMN / 원장 V-19557d39 ASIS / 원장 V-5576a1aa ASIS / 원장 V-46ccdaa2 ASIS / 원장 V-d4280 |  | 3 (TRANSPORT_MODE 콤보 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0444 | H2 | bucket 토글 × chkSum | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 bucket 토글 × chkSum 'SetSpreadColumn' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (bucket 토글 × chkSum) |
| WK-SSP0021-0445 | H2 | drill-down | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (drill-down) |
| WK-SSP0021-0446 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-21369e5c |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0447 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-9e9e1d1b |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0448 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-5e8ae23d |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0449 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-58f672d8 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0450 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-36a81a23 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0451 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-aa505c53 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0452 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-a4da8ca3 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0453 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-b6d2314d |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0454 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-5d5b5287 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0455 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-6736c7d7 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0456 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-0533cf74 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0457 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-8e5579bd |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0458 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-776aa943 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0459 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-10a5f255 |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0460 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-19557d39 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0461 | H2 | siDetail.ActiveSheet.Cells[iRow, siDetai | 하네스·환경 | H2 도구 오류 — 원장 V-5576a1aa |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0462 | H2 | siMain.ActiveSheet.Cells[iRow, iCol].For | 하네스·환경 | H2 도구 오류 — 원장 V-83c10f95 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0021-0463 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-c076198d |  | 1 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0464 | H2 | white-list 편집 5+2열 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 white-list 편집 5+2열 'LockRange/IsLock + 가드' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0465 | H2 | 동적 pivot D_/W_/M_ | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 동적 pivot D_/W_/M_ 'SCP0009 calendar 3span + InitSpreadDateColumn' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0466 | H2 | 음수 검증 셀 색(시안 #5CD1E5) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 음수 검증 셀 색(시안 #5CD1E5) 'L2904 `//siMain.SetBGColor(..., ControlColor.Inval' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |
| WK-SSP0021-0467 | H2 | 이벤트 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (이벤트) |
| WK-SSP0021-0468 | H2 | 조회 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 조회 'Measure 타이틀셋 개인화(`visibleMeasures`)' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (조회) |
| WK-SSP0021-0469 | H2 | 합계 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 합계 '`useAggregationRow` prop' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (합계) |
| WK-SSP0021-0470 | H2 | 헤더 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 헤더 '그리드 `allowMerging`' 의 H2 41요소: ERROR:36 · NA:5 |  | 1 (헤더) |
| WK-SSP0021-0471 | H4 | SSP0021 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-6a578595 RULE_SCREEN / 원장 V-a056b39f RULE_SCREEN / 원장 V-cc62bf71 RULE_SCREEN / 원장 V-508778f3 RULE_SCREEN / 원장 V-7e |  | 7 (ACT:SSP0021_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0021-0472 | H5 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | H5 도구 오류 — 실측[T-493c2d37]: CHANGE_REASON_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0473 | H5 | COMMON:UC-01 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_R |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0474 | H5 | COMMON:UC-05 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_R |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0475 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_R |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0476 | H5 | D00-1-024 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-024 '§1 spdMain_Sheet1 / SheetView' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (D00-1-024) |
| WK-SSP0021-0477 | H5 | D00-1-025 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-025 '§1 spdDetail / FpSpread' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (D00-1-025) |
| WK-SSP0021-0478 | H5 | D00-1-026 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-026 '§1 spdDetail_Sheet1 / SheetView' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (D00-1-026) |
| WK-SSP0021-0479 | H5 | D00-2-014 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-2-014 '§2 spdDetail / ActiveSheetChanged' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (D00-2-014) |
| WK-SSP0021-0480 | H5 | DAY_CODE | 하네스·환경 | H5 도구 오류 — 실측[T-48ab9190]: DAY_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0481 | H5 | ERP_SO_NO / SO No | 하네스·환경 | H5 도구 오류 — 실측[T-50b9ba32]: ERP_SO_NO 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ERP_SO_NO 그룹 동기화) |
| WK-SSP0021-0482 | H5 | FCST_TYPE / FCST Type | 하네스·환경 | H5 도구 오류 — 실측[T-68dcd9ae]: FCST_TYPE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0483 | H5 | R10 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R10 '시트탭 상시노출' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (R10) |
| WK-SSP0021-0484 | H5 | R3 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R3 '활성 detail시트별 조회바 show/hide 매트릭스' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (R3) |
| WK-SSP0021-0485 | H5 | R4 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R4 '탭클릭/더블클릭 시트전환 + 재조회' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (R4) |
| WK-SSP0021-0486 | H5 | SHIPMENT_STATUS / Status | 하네스·환경 | H5 도구 오류 — 실측[T-fd298332]: SHIPMENT_STATUS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0487 | H5 | SHIP_PLAN 편집 + Simulation | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 SHIP_PLAN 편집 + Simulation 'Simulation() 5산식' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0488 | H5 | SSP0021_ShipmentPlan.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.CreateSpread 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0489 | H5 | SSP0021_ShipmentPlan.SetSpreadColumn | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SetSpreadColumn 의 H5 3요소: NOT_RUN:1 · NA:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0490 | H5 | STOCK_STATUS / Inventory Status | 하네스·환경 | H5 도구 오류 — 실측[T-e20f1ab5]: STOCK_STATUS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0491 | H5 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H5 도구 오류 — 실측[T-34d8aaf2]: TRANSPORT_MODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (TRANSPORT_MODE 콤보) |
| WK-SSP0021-0492 | H5 | drill-down | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (drill-down) |
| WK-SSP0021-0493 | H5 | white-list 편집 5+2열 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 white-list 편집 5+2열 'LockRange/IsLock + 가드' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0494 | H5 | 동적 pivot D_/W_/M_ | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 동적 pivot D_/W_/M_ 'SCP0009 calendar 3span + InitSpreadDateColumn' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_R |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0495 | H5 | 이벤트 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (이벤트) |
| WK-SSP0021-0496 | H5 | 조회 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 조회 'Measure 타이틀셋 개인화(`visibleMeasures`)' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (조회) |
| WK-SSP0021-0497 | H5 | 합계 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 합계 '`useAggregationRow` prop' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (합계) |
| WK-SSP0021-0498 | H5 | 헤더 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 헤더 '그리드 `allowMerging`' 의 H5 18요소: ERROR:7 · PASS:6 · NA:4 · NOT_RUN:1 |  | 1 (헤더) |
| WK-SSP0021-0499 | D1 | BACK_COLOR / Back Color | 하네스·환경 | D1 도구 오류 — 실측[T-0b9a4dc4]: BACK_COLOR AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0500 | D1 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | D1 도구 오류 — 원장 V-826495ea COLUMN / 원장 V-0ad20db0 COLUMN / 실측[T-a7d849a7]: 기존행 r0 CHANGE_REASON_DETAIL: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2476) |
| WK-SSP0021-0501 | D1 | CONFIRM_DAY / Confrim Day | 하네스·환경 | D1 도구 오류 — 실측[T-920a85c4]: CONFIRM_DAY AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0502 | D1 | D00-2-013 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-013 '§2 dsdm / Changed' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-2-013) |
| WK-SSP0021-0503 | D1 | D00-2-019 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-019 '§2 spdDetail / EditChange' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-2-019) |
| WK-SSP0021-0504 | D1 | D00-2-023 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-023 '§2 spdMain / Change' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-2-023) |
| WK-SSP0021-0505 | D1 | D00-2-024 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-024 '§2 spdMain / ClipboardPasted' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-2-024) |
| WK-SSP0021-0506 | D1 | D00-4d-001 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d shtDetail_Change / `CanModelChange != true \\' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-4d-001) |
| WK-SSP0021-0507 | D1 | D00-4d-003 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-003 '§4d shtDetail_Change / `siDetail.IsLock == false`' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-4d-003) |
| WK-SSP0021-0508 | D1 | D00-4d-011 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / `SheetName == shtPlanDe' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-4d-011) |
| WK-SSP0021-0509 | D1 | D00-4d-015 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-015 '§4d SpdDetail_ClipboardPasted / `SheetName == shtP' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (D00-4d-015) |
| WK-SSP0021-0510 | D1 | DIVISION_ID / Div | 하네스·환경 | D1 도구 오류 — 원장 V-d9932af6 COLUMN / 원장 V-3467241d COLUMN / 원장 V-bc12cce7 COLUMN / 원장 V-3b9db472 COLUMN / 원장 V-86cad1c6 COLUMN / 원장 V |  | 7 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0511 | D1 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | D1 도구 오류 — 원장 V-581af969 COLUMN / 원장 V-dd1fe450 COLUMN / 원장 V-25ac1559 COLUMN / 원장 V-64fecc77 COLUMN / 실측[T-9e0ff084]: 기존행 r0 HOLD |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton:2485) |
| WK-SSP0021-0512 | D1 | LAST_UPDATED_BY / Last Updated By | 하네스·환경 | D1 도구 오류 — 원장 V-e5d682da COLUMN / 원장 V-ea608c24 COLUMN / 원장 V-07193db9 COLUMN / 원장 V-b18a6735 COLUMN / 실측[T-d400b95f]: 기존행 r0 LAST |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0513 | D1 | LAST_UPDATE_DATE / Last Updated Date | 하네스·환경 | D1 도구 오류 — 원장 V-74c658f6 COLUMN / 원장 V-efbe71a1 COLUMN / 원장 V-b627faa7 COLUMN / 원장 V-4bf9297a COLUMN / 실측[T-1f59a4a3]: 기존행 r0 LAST |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2488) |
| WK-SSP0021-0514 | D1 | MEASURE / Measure | 하네스·환경 | D1 도구 오류 — 실측[T-cf8ac889]: 기존행 r0 MEASURE 편집=false — AS-IS 기대 미식별(edit_expect 'UNKNOWN') → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 10 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0515 | D1 | MODEL_USER / Model PIC | 하네스·환경 | D1 도구 오류 — 원장 V-05f3d3e6 COLUMN / 원장 V-f537102b COLUMN / 실측[T-21c19c02]: 기존행 r0 MODEL_USER: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2474) |
| WK-SSP0021-0516 | D1 | R7 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R7 '마스터 항상 읽기전용' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (R7) |
| WK-SSP0021-0517 | D1 | R8 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R8 '편집권한 = SSP 등록사용자(GetSSPUserCheck/PKG_SSP0002)' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (R8) |
| WK-SSP0021-0518 | D1 | R9 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R9 'CutOff(bRealFlag=false) 편집차단' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (R9) |
| WK-SSP0021-0519 | D1 | REMARKS3 / Customer Requirement | 하네스·환경 | D1 도구 오류 — 원장 V-dca270ef COLUMN / 원장 V-a20f6dc4 COLUMN / 실측[T-1d5f8733]: 기존행 r0 REMARKS3: 현재 그리드에 없음 — 표시 여부는 A5 |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0520 | D1 | REQUESTOR / Shipment Requestor | 하네스·환경 | D1 도구 오류 — 원장 V-f5b965d4 COLUMN / 원장 V-66c43b50 COLUMN / 실측[T-76de9610]: 기존행 r0 REQUESTOR: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2473) |
| WK-SSP0021-0521 | D1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D1 도구 오류 — 원장 V-fa249e1b COLUMN / 원장 V-57cab73d COLUMN / 실측[T-624a722a]: 기존행 r0 SHIPMENT_CONFIRM_QTY: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0522 | D1 | SHIPMENT_STATUS / Status | 하네스·환경 | D1 도구 오류 — 원장 V-49038a2f COLUMN / 원장 V-c5698004 COLUMN / 실측[T-7b020396]: 기존행 r0 SHIPMENT_STATUS: 현재 그리드에 없음 — 표시 여부는 A5 |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0523 | D1 | SHIP_PLAN 편집 + Simulation | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 SHIP_PLAN 편집 + Simulation 'Simulation() 5산식' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0524 | D1 | SSP0021_ShipmentPlan.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.EditButton 의 D1 14요소: ERROR:13 · NA:1 |  | 25 (ACT:SSP0021_ShipmentPlan.EditButton:2363) |
| WK-SSP0021-0525 | D1 | white-list 편집 5+2열 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 white-list 편집 5+2열 'LockRange/IsLock + 가드' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0526 | D1 | 이벤트 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 D1 23요소: ERROR:13 · NA:10 |  | 1 (이벤트) |
| WK-SSP0021-0527 | D3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | D3 도구 오류 — 원장 V-88687ee8 ASIS / 실측[T-303be51d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (sStatus == Shipment_Status.S_Stat |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2476) |
| WK-SSP0021-0528 | D3 | D00-2-013 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-013 '§2 dsdm / Changed' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-2-013) |
| WK-SSP0021-0529 | D3 | D00-2-019 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-019 '§2 spdDetail / EditChange' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-2-019) |
| WK-SSP0021-0530 | D3 | D00-2-023 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-023 '§2 spdMain / Change' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-2-023) |
| WK-SSP0021-0531 | D3 | D00-2-024 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-024 '§2 spdMain / ClipboardPasted' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-2-024) |
| WK-SSP0021-0532 | D3 | D00-4d-001 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d shtDetail_Change / `CanModelChange != true \\' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-4d-001) |
| WK-SSP0021-0533 | D3 | D00-4d-003 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-003 '§4d shtDetail_Change / `siDetail.IsLock == false`' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-4d-003) |
| WK-SSP0021-0534 | D3 | D00-4d-011 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-011 '§4d SpdDetail_EditChange / `SheetName == shtPlanDe' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-4d-011) |
| WK-SSP0021-0535 | D3 | D00-4d-015 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-015 '§4d SpdDetail_ClipboardPasted / `SheetName == shtP' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (D00-4d-015) |
| WK-SSP0021-0536 | D3 | DIVISION_ID / Div | 하네스·환경 | D3 도구 오류 — 원장 V-931654bc ASIS / 원장 V-4cd941e6 ASIS / 원장 V-446833fd ASIS / 원장 V-b491c8f0 ASIS / 실측[T-39f73147]: 조건 계산 불가(검사기가 AS-IS |  | 7 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0537 | D3 | DIVISION_ID,HOLD_YYYYMMDD | 하네스·환경 | D3 도구 오류 — 원장 V-446833fd / 실측[T-2fd39e91]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Stat |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2204:) |
| WK-SSP0021-0538 | D3 | DIVISION_ID,REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-931654bc |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2473) |
| WK-SSP0021-0539 | D3 | DIVISION_ID,REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-b491c8f0 / 실측[T-e7a46a2f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Stat |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2344:) |
| WK-SSP0021-0540 | D3 | EDIT_MAIN | 하네스·환경 | D3 도구 오류 — 실측[T-2b1549d7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Status_C && sErpStat |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0541 | D3 | ERP_STATUS / erp_status | 하네스·환경 | D3 도구 오류 — 실측[T-818ce651]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Status_C && sErpStat |  | 3 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0542 | D3 | MEASURE / Measure | 하네스·환경 | D3 도구 오류 — 원장 V-4fc7d445 ASIS / 실측[T-6fb0bcd6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Auth == true) / else of (bE |  | 10 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0543 | D3 | MODEL_USER / Model PIC | 하네스·환경 | D3 도구 오류 — 원장 V-1cee13bb ASIS / 원장 V-ad3f31d4 ASIS / 실측[T-5302a35f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2474) |
| WK-SSP0021-0544 | D3 | R7 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R7 '마스터 항상 읽기전용' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (R7) |
| WK-SSP0021-0545 | D3 | R8 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R8 '편집권한 = SSP 등록사용자(GetSSPUserCheck/PKG_SSP0002)' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (R8) |
| WK-SSP0021-0546 | D3 | R9 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R9 'CutOff(bRealFlag=false) 편집차단' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (R9) |
| WK-SSP0021-0547 | D3 | REMARKS3 / Customer Requirement | 하네스·환경 | D3 도구 오류 — 원장 V-1cee13bb ASIS / 원장 V-ad3f31d4 ASIS / 실측[T-4dc35883]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0548 | D3 | REMARKS3,MODEL_USER | 하네스·환경 | D3 도구 오류 — 원장 V-1cee13bb |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2474) |
| WK-SSP0021-0549 | D3 | REMARKS3,MODEL_USER | 하네스·환경 | D3 도구 오류 — 원장 V-ad3f31d4 / 실측[T-5c528284]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Stat |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2346:) |
| WK-SSP0021-0550 | D3 | REQUESTOR / Shipment Requestor | 하네스·환경 | D3 도구 오류 — 원장 V-931654bc ASIS / 원장 V-b491c8f0 ASIS / 실측[T-1438d8a4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2473) |
| WK-SSP0021-0551 | D3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D3 도구 오류 — 원장 V-88687ee8 ASIS / 실측[T-0c52a985]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (sStatus == Shipment_Status.S_Stat |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0552 | D3 | SHIPMENT_CONFIRM_QTY,CHANGE_REASON_DETAI | 하네스·환경 | D3 도구 오류 — 원장 V-88687ee8 |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2476) |
| WK-SSP0021-0553 | D3 | SHIPMENT_STATUS / Status | 하네스·환경 | D3 도구 오류 — 실측[T-10bdc4e4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): else of (sStatus == Shipment_Status.S_Status_C && sErpStat |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0554 | D3 | SHIP_PLAN 편집 + Simulation | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 SHIP_PLAN 편집 + Simulation 'Simulation() 5산식' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0555 | D3 | SSP0021_ShipmentPlan.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-340f88c0 ASIS / 원장 V-46a8c4f9 ASIS / 원장 V-4fc7d445 ASIS / 원장 V-0bdc4bc4 ASIS / 원장 V-931654bc ASIS / 원장 V-1cee13bb  |  | 25 (ACT:SSP0021_ShipmentPlan.EditButton:2363) |
| WK-SSP0021-0556 | D3 | siDetail.LockRange2 | 하네스·환경 | D3 도구 오류 — 원장 V-d64cba68 |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2481) |
| WK-SSP0021-0557 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-340f88c0 |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2399) |
| WK-SSP0021-0558 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-46a8c4f9 |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2404) |
| WK-SSP0021-0559 | D3 | white-list 편집 5+2열 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 white-list 편집 5+2열 'LockRange/IsLock + 가드' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0560 | D3 | 이벤트 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 D3 29요소: ERROR:19 · PASS:7 · NA:3 |  | 1 (이벤트) |
| WK-SSP0021-0561 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 1요소: ERROR:1 |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0562 | D4 | COMMON:UC-03 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 D4 1요소: ERROR:1 |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0563 | D4 | SHIPMENT_STATUS / Status | 하네스·환경 | D4 도구 오류 — 실측[T-56472c45]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (Insert) |
| WK-SSP0021-0564 | D6 | SSP0021 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-618b1f08 RULE_SCREEN / 원장 V-4cf59d00 RULE_SCREEN / 원장 V-4d496457 RULE_SCREEN / 원장 V-4a15f213 GENERAL / 원장 V-23edc2 |  | 5 (COMMON:UC-01 COMMON:UC-03 Insert ACT:SSP) |
| WK-SSP0021-0565 | E1 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | E1 도구 오류 — 실측[T-836de388]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 9 (D00-4d-017 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0566 | E1 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | E1 도구 오류 — 실측[T-736281bf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0567 | E1 | D00-2-017 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-2-017 '§2 spdDetail / ClipboardPasted' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-2-017) |
| WK-SSP0021-0568 | E1 | D00-2-024 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-2-024 '§2 spdMain / ClipboardPasted' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-2-024) |
| WK-SSP0021-0569 | E1 | D00-4d-014 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-014 '§4d SpdDetail_ClipboardPasted / `siDetail.IsLock =' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-4d-014) |
| WK-SSP0021-0570 | E1 | D00-4d-015 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-015 '§4d SpdDetail_ClipboardPasted / `SheetName == shtP' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-4d-015) |
| WK-SSP0021-0571 | E1 | D00-4d-016 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-016 '§4d SpdDetail_ClipboardPasted / `cell.Text != ""`' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-4d-016) |
| WK-SSP0021-0572 | E1 | D00-4d-018 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 D00-4d-018 '§4d SpdDetail_ClipboardPasted / `dr == null`' 의 E1 13요소: ERROR:7 · NA:6 |  | 1 (D00-4d-018) |
| WK-SSP0021-0573 | E1 | ERP_SO_NO / SO No | 하네스·환경 | E1 도구 오류 — 실측[T-cdf84e5c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0574 | E1 | REMARKS / Remarks | 하네스·환경 | E1 도구 오류 — 실측[T-60e28aa7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0575 | E1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | E1 도구 오류 — 원장 V-5089c5ce COLUMN / 실측[T-df4c7064]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetai |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0576 | E1 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E1 도구 오류 — 실측[T-9b116223]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 9 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0577 | E1 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E1 도구 오류 — 실측[T-f4340852]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2193 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0578 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-4aa77fa5 / 실측[T-e0deba3c]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0579 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-4aa77fa5 ASIS / 원장 V-6d8a9a30 ASIS / 실측[T-ac1fe91f]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 2 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0580 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-6d8a9a30 / 실측[T-6254b813]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0581 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-529d6c06 / 실측[T-eb894007]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0582 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-529d6c06 ASIS / 실측[T-f72d63a3]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0583 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-5bbae1fe ASIS / 원장 V-365feee3 ASIS / 실측[T-bea7cba0]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 3 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0584 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-365feee3 / 실측[T-16584ae4]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (ds.Tables[2].Rows.C |  | 1 (ACT:SSP0021_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0021-0585 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-d8bb3a06 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0586 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-d8bb3a06 ASIS / 원장 V-1086d939 ASIS / 실측[T-7346bd10]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save  |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0587 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-1086d939 / 실측[T-107c229d]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SSP0021_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0021-0588 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-dd19ed1a ASIS / 원장 V-73cfd45b ASIS / 원장 V-778bead3 ASIS / 원장 V-9d883545 ASIS / 실측[T-9b782e6d]: MSG00284 — NewNonSo |  | 5 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4381) |
| WK-SSP0021-0589 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-dd19ed1a / 실측[T-02019064]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.NonSoNo:3608:12) |
| WK-SSP0021-0590 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-73cfd45b / 실측[T-1b0ff90a]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0591 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-778bead3 / 실측[T-9a2df583]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0592 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-9d883545 / 실측[T-3fc86921]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.SoNo:3827:138) |
| WK-SSP0021-0593 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-d89b7096 / 실측[T-62201dbd]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdD |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0594 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-d89b7096 ASIS / 실측[T-6a4ac729]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0595 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-f152b063 / 실측[T-82e0ab05]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulation)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.Simulation:6096) |
| WK-SSP0021-0596 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-f152b063 ASIS / 실측[T-05385ee1]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulatio |  | 1 (ACT:SSP0021_ShipmentPlan.Simulation:6096) |
| WK-SSP0021-0597 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-7d29b9ab ASIS / 원장 V-5ef46846 ASIS / 원장 V-9a039de3 ASIS / 실측[T-bcf82dff]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님  |  | 4 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4358) |
| WK-SSP0021-0598 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-7d29b9ab / 실측[T-f8877b3a]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.NonSoNo:3584:12) |
| WK-SSP0021-0599 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-5ef46846 / 실측[T-960856df]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0600 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-9a039de3 / 실측[T-56c72e20]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0021_ShipmentPlan.SoNo:3804:135) |
| WK-SSP0021-0601 | E4 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E4 도구 오류 — 원장 V-d8e8a51c ASIS / 원장 V-529d6c06 ASIS / 원장 V-d89b7096 ASIS / 실측[T-3ae0de94]: MSG00049: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 2 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0602 | E4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E4 도구 오류 — 원장 V-529d6c06 ASIS / 원장 V-d8bb3a06 ASIS / 원장 V-1086d939 ASIS / 실측[T-353a7ec2]: MSG00047 — SpdDetail_ClipboardPasted 경로  |  | 3 (D00-4d-005 D00-4d-020 ACT:SSP0021_Shipme) |
| WK-SSP0021-0603 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | A6 도구 오류 — 원장 V-e0e7315d SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 PASS 공통 70행(Doc/golden/SSP0021/SCP0009_GET_SHEET_CALENDAR_3SPAN.order |  | 464 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0604 | A6 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-2f3420ed SP / 정렬대조 PASS AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰  / 실측[T-e7631132]: PKG_SSP0021.P_SSP0021 |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0605 | A6 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-96482684 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-3868dc9b]: PKG_SSP0021.P_SSP0021_G |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0606 | A6 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | 하네스·환경 | A6 도구 오류 — 원장 V-28ab19c9 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-3c68d405]: PKG_SSP0021.P_SSP0021_G |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0607 | A6 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | 하네스·환경 | A6 도구 오류 — 원장 V-114bec6d SP / 원장 V-91a8cd78 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-eefe54d0]: PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL: 화면  |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0608 | A6 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | 하네스·환경 | A6 도구 오류 — 원장 V-6efe2cd9 SP / 원장 V-14502646 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-5894c7b6]: PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_D |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0609 | G1 | Box ID | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Box ID '자유입력' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Box ID) |
| WK-SSP0021-0610 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA: |  | 1 (COMMON:UC-02) |
| WK-SSP0021-0611 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA: |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0612 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0613 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA: |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0614 | G1 | D00-1-009 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-009 '§1 btnItemId / UsrButton' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-009) |
| WK-SSP0021-0615 | G1 | D00-1-012 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-012 '§1 btnItemID2 / UsrButton' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-012) |
| WK-SSP0021-0616 | G1 | D00-1-013 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-013 '§1 btnRequestor / UsrButton' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-013) |
| WK-SSP0021-0617 | G1 | D00-1-015 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-015 '§1 btnSearch / SimpleButton' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-015) |
| WK-SSP0021-0618 | G1 | D00-1-021 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-021) |
| WK-SSP0021-0619 | G1 | D00-1-028 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-028 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-028) |
| WK-SSP0021-0620 | G1 | D00-1-029 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-029 '§1 usrLayoutControl3 / UsrLayoutControl' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-1-029) |
| WK-SSP0021-0621 | G1 | D00-2-005 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-005 '§2 btnSearch / Click' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (D00-2-005) |
| WK-SSP0021-0622 | G1 | Division/Company | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Division/Company '`SSP0021_GET_SHIPMENT_DIVISION`(2결과셋, VP UNION·NER' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · |  | 1 (Division/Company) |
| WK-SSP0021-0623 | G1 | Find | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Find 'FindData_Main' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Find) |
| WK-SSP0021-0624 | G1 | From Site | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 From Site '`Com_FromSite_SCP`' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (From Site) |
| WK-SSP0021-0625 | G1 | MEASURE 세로축 표시/개인화 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 MEASURE 세로축 표시/개인화 'SCM_MST_SHEET_MEASURE(9행)' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (MEASURE 세로축 표시/개인화) |
| WK-SSP0021-0626 | G1 | Measure | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Measure) |
| WK-SSP0021-0627 | G1 | Period | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Period 'PlanDate 파생 FROM_DATE/TO_DATE1' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Period) |
| WK-SSP0021-0628 | G1 | Plan Date | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Plan Date '`Plan_Infor_SCP` @companyId' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Plan Date) |
| WK-SSP0021-0629 | G1 | R3 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R3 '활성 detail시트별 조회바 show/hide 매트릭스' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (R3) |
| WK-SSP0021-0630 | G1 | R4 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R4 '탭클릭/더블클릭 시트전환 + 재조회' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (R4) |
| WK-SSP0021-0631 | G1 | Requestor | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Requestor) |
| WK-SSP0021-0632 | G1 | Result Type | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Result Type 'lookup `SSP_SHIPMENT_RESULT_TYPE`' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (Result Type) |
| WK-SSP0021-0633 | G1 | TransMode 행단위 cascade 재조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 TransMode 행단위 cascade 재조회 'L1789 `//siDetail.SetCellTypeCombo(... TRANSPORT_M' 의 G1 14요소: PASS:8 · ERROR:4 · |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0634 | G1 | txtBoxID / Box ID | 하네스·환경 | G1 도구 오류 — 원장 V-f43ac491 SEARCH / E2E smoke cond InputField |  | 3 (D00-1-017 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0635 | G1 | txtItemId / Model / Item Id / Model/Nick | 하네스·환경 | G1 도구 오류 — 원장 V-118ecc88 SEARCH / 원장 V-974bc655 SEARCH / 원장 V-77a69933 SEARCH / 원장 V-ae29b568 SEARCH / 원장 V-6bde90bd SEARCH / 원장 V |  | 4 (D00-1-008 Model×2 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0636 | G1 | txtModel2 / Model / Model2 / Model/Nickn | 하네스·환경 | G1 도구 오류 — 원장 V-118ecc88 SEARCH / 원장 V-974bc655 SEARCH / 원장 V-77a69933 SEARCH / 원장 V-ae29b568 SEARCH / 원장 V-6bde90bd SEARCH / 원장 V |  | 16 (D00-1-018 Model×2 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0637 | G1 | txtRequestor / Requestor / item.UserName | 하네스·환경 | G1 도구 오류 — E2E smoke cond InputField / 실측[T-94c4aeea]: Requestor 콤보 아님(popup) — 멀티선택 검사 대상 아님 |  | 3 (D00-1-014 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0638 | G1 | 이벤트 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 이벤트 '편집 즉시 재계산(`onCellEdited`)' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (이벤트) |
| WK-SSP0021-0639 | G1 | 조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회 'Measure 타이틀셋 개인화(`visibleMeasures`)' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (조회) |
| WK-SSP0021-0640 | G1 | 합계 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 합계 '`useAggregationRow` prop' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (합계) |
| WK-SSP0021-0641 | G1 | 헤더 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 헤더 '그리드 `allowMerging`' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (헤더) |
| WK-SSP0021-0642 | G1 | 확정구간(CONFIRM_DAY) 조회전용 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 확정구간(CONFIRM_DAY) 조회전용 'AS-IS·design 이탈 **정책 결정**' 의 G1 14요소: PASS:8 · ERROR:4 · WARN:1 · NA:1 |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0643 | G6 | From Site | 하네스·환경 | G6 도구 오류 — 실측[T-ceb3a028]: 조회조건 대상 아님 또는 화면 라벨 미식별(ROW From Site) — 진입점 단위 초기화는 시나리오 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (From Site) |
| WK-SSP0021-0644 | G6 | Period | 하네스·환경 | G6 도구 오류 — 실측[T-353a2d82]: 조회조건 대상 아님 또는 화면 라벨 미식별(ROW Period) — 진입점 단위 초기화는 시나리오 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (Period) |
| WK-SSP0021-0645 | G6 | Plan Date | 하네스·환경 | G6 도구 오류 — 실측[T-9495372e]: 조회조건 대상 아님 또는 화면 라벨 미식별(ROW Plan Date) — 진입점 단위 초기화는 시나리오 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (Plan Date) |
| WK-SSP0021-0646 | G6 | Requestor | 하네스·환경 | G6 도구 오류 — 실측[T-3bb8eaf7]: 조회조건 대상 아님 또는 화면 라벨 미식별(ROW Requestor) — 진입점 단위 초기화는 시나리오 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (Requestor) |
| WK-SSP0021-0647 | X-ROW | SSP0021_ShipmentPlan.BtnItemID2_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:3 · NA:3 · PASS:3 |  | 5 (ACT:SSP0021_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0021-0648 | X-ROW | SSP0021_ShipmentPlan.BtnRequestor_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:4 · PASS:3 |  | 10 (ACT:SSP0021_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0021-0649 | X-ROW | SSP0021_ShipmentPlan.BtnSearch_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 12 (ACT:SSP0021_ShipmentPlan.BtnSearch_Click) |
| WK-SSP0021-0650 | X-ROW | SSP0021_ShipmentPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SSP0021_ShipmentPlan.CreateSpread) |
| WK-SSP0021-0651 | X-ROW | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · NA:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0652 | X-ROW | SSP0021_ShipmentPlan.FindData_MES_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:8 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0653 | X-ROW | SSP0021_ShipmentPlan.FindData_MES_stock_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:8 · ERROR:6 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0654 | X-ROW | SSP0021_ShipmentPlan.FindData_Stock_Deta | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:8 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0655 | X-ROW | SSP0021_ShipmentPlan.FindData_hold_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:7 · ERROR:6 · REVIEW:1 · NA:1 |  | 10 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0656 | X-ROW | SSP0021_ShipmentPlan.FindData_oWMS_Detai | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:8 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0657 | X-ROW | SSP0021_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:2 · NOPATH:2 · ERROR:1 |  | 1 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt) |
| WK-SSP0021-0658 | X-ROW | SSP0021_ShipmentPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0021_ShipmentPlan.InsertButton) |
| WK-SSP0021-0659 | X-ROW | SSP0021_ShipmentPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:21 · PASS:4 |  | 121 (ACT:SSP0021_ShipmentPlan.InsertRow ACT:S) |
| WK-SSP0021-0660 | X-ROW | SSP0021_ShipmentPlan.Re_Design | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 27 (ACT:SSP0021_ShipmentPlan.Re_Design ACT:S) |
| WK-SSP0021-0661 | X-ROW | SSP0021_ShipmentPlan.SetChangeControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0021_ShipmentPlan.SetChangeContro) |
| WK-SSP0021-0662 | X-ROW | SSP0021_ShipmentPlan.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:6 · NA:4 · ERROR:2 |  | 3 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0663 | X-ROW | SSP0021_ShipmentPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — NA:7 · PASS:4 · ERROR:4 · NOT_RUN:1 |  | 7 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0664 | X-ROW | SSP0021_ShipmentPlan.Set_SumValues | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.Set_SumValues A) |
| WK-SSP0021-0665 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 55 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0666 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — NA:7 · PASS:2 · ERROR:1 |  | 49 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0667 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0021-0668 | X-ROW | SSP0021_ShipmentPlan.SpdMain_Change | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:SSP0021_ShipmentPlan.SpdMain_Change ) |
| WK-SSP0021-0669 | X-ROW | SSP0021_ShipmentPlan.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0021_ShipmentPlan.SpdMain_TopChan) |
| WK-SSP0021-0670 | X-ROW | SSP0021_ShipmentPlan.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:3 · NA:3 · PASS:3 |  | 5 (ACT:SSP0021_ShipmentPlan.btnItemId_Click) |
| WK-SSP0021-0671 | X-ROW | SSP0021_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0672 | X-ROW | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:3 |  | 4 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0673 | X-ROW | SSP0021_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0674 | G5 | D00-2-022 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2-022 '§2 spdMain / CellDoubleClick' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (D00-2-022) |
| WK-SSP0021-0675 | G5 | D00-4d-023 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4d-023 '§4d BtnMeasure_Click / `fps != null`' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (D00-4d-023) |
| WK-SSP0021-0676 | G5 | ERP_SO_NO / SO No | 하네스·환경 | G5 도구 오류 — 원장 V-1f01af33 ASIS / 원장 V-f368de36 ASIS / 원장 V-4ce38b5f ASIS |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0677 | G5 | MODAL:RequestorModal | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:RequestorModal 'FE 실존 모달 (components/modals/RequestorModal.tsx) — ' 의 G5 23요소: NA:12 · ERROR:7 · NOPAT |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0678 | G5 | Measure | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (Measure) |
| WK-SSP0021-0679 | G5 | OrderDetail 팝업(SSP0300) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 OrderDetail 팝업(SSP0300) 'L1603 `new SSP0300_OrderDetailPopup()` **활성**' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH: |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0680 | G5 | Requestor | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (Requestor) |
| WK-SSP0021-0681 | G5 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 하네스·환경 | G5 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdMain_CellDoubleClick 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0682 | G5 | drill-down | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 G5 23요소: NA:12 · ERROR:7 · NOPATH:4 |  | 1 (drill-down) |
| WK-SSP0021-0683 | G5 | new SSP0300_OrderDetailPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-1f01af33 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0684 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-c6a4eecd |  | 1 (ACT:SSP0021_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0021-0685 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-4ce38b5f |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0686 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-593e519a |  | 1 (ACT:SSP0021_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0021-0687 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스·환경 | G5 도구 오류 — 원장 V-0c64e96e SEARCH / 원장 V-b28e5815 SEARCH / 원장 V-939b0121 SEARCH / 원장 V-62ec54ab SEARCH / 원장 V-8a90b539 SEARCH / 원장 V |  | 1 (Model×2) |
| WK-SSP0021-0688 | G5 | txtModel2 / Model / Model2 / Model/Nickn | 하네스·환경 | G5 도구 오류 — 원장 V-0c64e96e SEARCH / 원장 V-b28e5815 SEARCH / 원장 V-939b0121 SEARCH / 원장 V-62ec54ab SEARCH / 원장 V-8a90b539 SEARCH / 원장 V |  | 1 (Model×2) |
| WK-SSP0021-0689 | H6 | D00-2-022 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2-022 '§2 spdMain / CellDoubleClick' 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (D00-2-022) |
| WK-SSP0021-0690 | H6 | D00-4d-023 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4d-023 '§4d BtnMeasure_Click / `fps != null`' 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (D00-4d-023) |
| WK-SSP0021-0691 | H6 | ERP_SO_NO / SO No | 하네스·환경 | H6 도구 오류 — 원장 V-fd705e0e ASIS / 원장 V-ccb45c71 ASIS / 원장 V-5a04db16 ASIS |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0692 | H6 | MODAL:RequestorModal | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 MODAL:RequestorModal 'FE 실존 모달 (components/modals/RequestorModal.tsx) — ' 의 H6 23요소: PASS:10 · NOPATH:4 · ER |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0693 | H6 | Measure | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 Measure 'SCM0002_TitleSetForm_Popup' 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (Measure) |
| WK-SSP0021-0694 | H6 | OrderDetail 팝업(SSP0300) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 OrderDetail 팝업(SSP0300) 'L1603 `new SSP0300_OrderDetailPopup()` **활성**' 의 H6 23요소: PASS:10 · NOPATH:4 · ERRO |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0695 | H6 | Requestor | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 Requestor 'UserInfoPopup(single)' 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (Requestor) |
| WK-SSP0021-0696 | H6 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 하네스·환경 | H6 도구 오류 — 진입점 집계 — 대조표 SSP0021_ShipmentPlan.SpdMain_CellDoubleClick 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0697 | H6 | drill-down | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 drill-down 'SpdMain_CellDoubleClick' 의 H6 23요소: PASS:10 · NOPATH:4 · ERROR:4 · NA:3 · WARN:2 |  | 1 (drill-down) |
| WK-SSP0021-0698 | H6 | new SSP0300_OrderDetailPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-fd705e0e |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0699 | H6 | pop.Form_Load(_DivisionID, _ErpSoNo, _Co | 하네스·환경 | H6 도구 오류 — 원장 V-ccb45c71 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0700 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5a04db16 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0701 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-cc9ed94f |  | 1 (ACT:SSP0021_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0021-0702 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-f4a98c84 |  | 1 (ACT:SSP0021_ShipmentPlan.btnItemId_Click) |
| WK-SSP0021-0703 | M3 | new SCM0002_TitleSetForm_Popup("SSP0021" | 하네스·환경 | M3 도구 오류 — 원장 V-9de79496 |  | 1 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0704 | M3 | new SSP0300_OrderDetailPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-afd76ed0 |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
