# 검사기 회귀 대조 SCP0016 — 기준 2026-11-06 19:43 (2077행) ↔ 현재 2026-11-14 11:10 (2188행)

- 악화(기준 비FAIL → 현재 FAIL): **4** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 27 · 그 외 변경: 310 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 47 · 새 행 158
- 승격 대기(received): Doc\verify\_checker_golden\SCP0016.received.csv — 확인 뒤 `checker_regress.py SCP0016 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-9f68a0da | G8 | 조회조건 PJT | NA | FAIL | 'PJT' 에 'sOLARIS bUS'(기본 결과 값 'Solaris Bus' 대소문자 반전) 입력 조회 → PROJECT_NAME 0행 — 대소문자가 다르면 조회되지 않음(AS- |  |
| V-e3552224 | G9 | 조회조건 PJT | NA | FAIL | 'PJT' 에 'Solaris Bus,C727 BEV' 입력 조회 → PROJECT_NAME 0행 · 'Solaris Bus' 없음 · 'C727 BEV' 없음 |  |
| V-a90ffd2a | G1 | SCP0016 텍스트 부분일치 PJT | NA | FAIL | PJT · 'olaris Bu'(값 'Solaris Bus' 일부) 이 조회 요청 본문에 실렸는데 0행 — 텍스트 조건 부분일치(Like) 안 됨 · 기대 근거 요건 EG245(D |  |
| T-a851e7f6 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SpdMain_TopChange | PASS | FAIL | 진입점 집계 1검사 — FAIL:1 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-7a9d555f | L1 | 조회조건 텍스트 입력 중 그리드 | FAIL | PASS | 조회(Division ALL) 응답 8074ms(요청~응답 8074ms · 벽시계 11925ms) · 990행 — 기준 10초(화면 규칙 L1: 조회·저장·키 이동 응답 기준 이내 |  |
| V-e0565aea | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | FAIL | ERROR | hide PASS: 헤더(D_20260824) 우클릭 → Hide Column → 컬럼 비표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K1 s |  |
| V-eeadaa8c | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | FAIL | ERROR | copy PASS: 선택 0,21,0,21 · 0행 D_20260824 표시값 '0' · Ctrl+C 클립보드 '0'(일치) · 우클릭 Copy '0'(일치) ／ hide PASS |  |
| T-d2929754 | G1 | D00-1-004 · §1 btnProject / UsrButton | FAIL | PASS | 행 집계 — 대조표 D00-1-004 '§1 btnProject / UsrButton' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d8493b15 | G1 | D00-1-007 · §1 btnItem_Id / UsrButton | FAIL | PASS | 행 집계 — 대조표 D00-1-007 '§1 btnItem_Id / UsrButton' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-5623a7a5 | G1 | D00-1-012 · §1 usrConditionPanel1 / UsrConditionPanel | FAIL | PASS | 행 집계 — 대조표 D00-1-012 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-cc1bcbfa | G1 | D00-2-003 · §2 btnProject / Click | FAIL | PASS | 행 집계 — 대조표 D00-2-003 '§2 btnProject / Click' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-12c3e2ad | G1 | D00-2-004 · §2 btnItem_Id / Click | FAIL | PASS | 행 집계 — 대조표 D00-2-004 '§2 btnItem_Id / Click' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-3c89c28a | G1 | D00-4a-001 · §4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL  | FAIL | PASS | 행 집계 — 대조표 D00-4a-001 '§4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL / F' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-5242d23f | G1 | D00-4b-001 · §4b FindButton / toolbarOverride / Search | FAIL | PASS | 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-9e764a2a | G1 | D00-4b-005 · §4b BtnItem_Id_Click / event / btnItem_Id | FAIL | PASS | 행 집계 — 대조표 D00-4b-005 '§4b BtnItem_Id_Click / event / btnItem_Id' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-96f9055e | G1 | D00-4b-006 · §4b BtnProject_Click / event / btnProject | FAIL | PASS | 행 집계 — 대조표 D00-4b-006 '§4b BtnProject_Click / event / btnProject' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d8764c4f | G1 | CRUD:D00-4b-001:SEARCH · [SEARCH] §4b FindButton / toolbarOv | FAIL | PASS | 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 G1 9요소: PAS |  |
| T-62a9e277 | G1 | COMMON:UC-03 · 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Re | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-2adfb86b | G1 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-2383e795 | G1 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebind | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-60260947 | G1 | 1 · MSG00109 EditButton 읽기전용 가드(644) | FAIL | PASS | 행 집계 — 대조표 1 'MSG00109 EditButton 읽기전용 가드(644)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d6f085b3 | G1 | 2 · GMessageBoxForException SetOperationGroupByDivision(908) | FAIL | PASS | 행 집계 — 대조표 2 'GMessageBoxForException SetOperationGroupByDivisio' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d577555d | G1 | FindButton(636) · FindData_Main() 실동작 | FAIL | PASS | 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-8e1e9118 | G1 | SaveButton(648) · NO-OP 빈 `{}` | FAIL | PASS | 행 집계 — 대조표 SaveButton(648) 'NO-OP 빈 `{}`' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-7aab5d54 | G1 | LookupCommon OPERATION_GROUP(203) · lookup(초기 P/A/E) | FAIL | PASS | 행 집계 — 대조표 LookupCommon OPERATION_GROUP(203) 'lookup(초기 P/A/E)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-f9d567dd | G1 | OperationGroup(928) / OperationGroupEE(932) · `OperationGrou | FAIL | PASS | 행 집계 — 대조표 OperationGroup(928) / OperationGroupEE(932) '`OperationGroup_SCP`{P,A} / `OperationGroupE |  |
| T-706d647d | G1 | LookupCommon ELECTRODE_TYPE(206) · lookup `ELECTRODE_TYPE`(다 | FAIL | PASS | 행 집계 — 대조표 LookupCommon ELECTRODE_TYPE(206) 'lookup `ELECTRODE_TYPE`(다중)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-881108c8 | G1 | WaterfallVer_FG2(234) · `WaterfallVer_FG2_SCP`(@divisionId) | FAIL | PASS | 행 집계 — 대조표 WaterfallVer_FG2(234) '`WaterfallVer_FG2_SCP`(@divisionId)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-de4e391a | G1 | BucketISO(221) · `BucketISO_SCP` | FAIL | PASS | 행 집계 — 대조표 BucketISO(221) '`BucketISO_SCP`' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-98493b1c | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindButton | FAIL | ERROR | 진입점 집계 12검사 — PASS:7 · ERROR:3 · REVIEW:2 |  |
| T-7dd78c29 | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindData_Main | FAIL | ERROR | 진입점 집계 29검사 — PASS:16 · ERROR:8 · NA:3 · REVIEW:2 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-23d17549 | G6 | SCP0016 연속 조회 본문 | 판정필요 | ERROR | [확인 대상] 조건 1개 변경에 본문 키 12개 달라짐: divisionId, fromYyyymmdd, toYyyymmdd, bizType, projectCode, itemId |  |
| V-a0617921 | E2 | SCP0016 기간 역전 조회 | ERROR | PASS | 기간 역전 입력을 컨트롤이 거부(From '2026.11.14' · To '2027.11.14') · 정상 범위 날짜 입력은 됨 |  |
| V-f293b53b | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR | AS-IS ORDER BY [SORT_ORDER_NO] ↔ TO-BE  [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검 |  |
| V-98799425 | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR | AS-IS ORDER BY [SORT_ORDER_NO] ↔ TO-BE  [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검 |  |
| V-4d18f292 | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR | AS-IS ORDER BY [PROJECT_VER_SEQ] 가드 IF( @debug_mode ='T') ▸ ELSE ↔ TO-BE  [] — TO-BE 프로시저 배선(PROC_M) |  |
| V-05926782 | A7 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-f9994d1a | A7 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-ae243235 | A7 | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-eb7aad04 | A7 | SCP0009_GET_SHEET_CALENDAR_3SPAN | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-bad19369 | B3 | 조회조건 Div | NA | PASS | [화면 초기(선택 Div=81)] 원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 일치: TO-BE ['81', '40', '82', 'EE', '81_U |  |
| V-e19a4461 | B4 | 조회조건 Ver. | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 0건 vs TO-BE 10건 · 차이 10건 설명 불가: SP_W_20260824: 설명 불가(원천 마스터 테이블 해석 실패); SP_ |  |
| V-72ef7746 | B4 | 조회조건 Operation group | 판정필요 | ERROR | [화면 초기(선택 Div=81)] AS-IS 3건 vs TO-BE 2건 · 마스터(SCM_ADM_LOOKUP_MASTER_DETAIL) 행으로 설명 안 되는 차이 1건: E: 조건 |  |
| V-2ffa024a | G2 | 조회조건 PJT | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-2079185b | G5 | 조회조건 PJT | NA | ERROR |  ／ [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [ |  |
| V-ecd28df5 | G2 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-d35cb779 | G5 | 조회조건 Model/Nickname | NA | ERROR |  ／ [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [ |  |
| V-f1a3d69c | B2 | 조회조건 Electrode | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-2851fa2b | B3 | 조회조건 Electrode | NA | ERROR |  ／ [미검증] 검사기(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-67cf86e1 | B4 | 조회조건 Electrode | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(combo_oracle.py |  |
| V-29192f21 | B6 | 조회조건 Electrode | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_verify.spec( |  |
| V-7414b6e4 | G7 | 조회조건 Electrode | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-51ca7f27 | G4 | 조회조건 Period | PASS | NA | 기준 순서 7번째 'Period' — 화면 8번째 · 순서 차이는 [V-dfe2124a] 1건으로 집계(같은 원인) |  |
| V-1377df4f | G8 | 조회조건 Period | NA | ERROR | 'Period' 과 같은 이름의 결과 컬럼 없음(후보 Period · Period Code · Period Name · Period ID) — 결과 대조 불가(조건 ↔ 컬럼 대응  |  |
| V-761549f4 | G2 | 조회조건 Sum | NA | ERROR | E2E smoke 조회조건 'Sum' [WARN] 체크 OFF→ON → 조회 정상 · 조회 인자 변화 없음(화면 표시용 조건이면 정상 — 배선 확인) — ALL/다중 사양은 @ve |  |
| V-88bda4d9 | G4 | 조회조건 Sum | NA | PASS | 기준 순서 9번째 'Sum' — 화면 9번째 (화면 순서: Div. → Operation group → PJT → Model/Nickname → Electrode → Ver. →  |  |
| V-f516468e | D1 | Waterfall Shipment Plan.DEPT_NAME_KO (Team) | NA | PASS | 기존행 r0 DEPT_NAME_KO 편집=false (AS-IS 잠금) |  |
| V-1663f850 | H2 | Waterfall Shipment Plan.DEPT_NAME_KO (Team) | NA | PASS | DEPT_NAME_KO: 기존행 편집=false 표시 일치 |  |
| V-3ce91429 | D1 | Waterfall Shipment Plan.ORIGIN_FROM_DIVISION_ID (Origin From | PASS | NA | 기존행 r0 ORIGIN_FROM_DIVISION_ID: 현재 그리드에 없음(Division·개인화·다른 시트) — 표시 여부는 A5 행에서 판정 |  |
| V-56f61ad3 | H2 | Waterfall Shipment Plan.ORIGIN_FROM_DIVISION_ID (Origin From | PASS | NA | ORIGIN_FROM_DIVISION_ID 현재 그리드에 없음 |  |
| V-9611434b | D1 | Waterfall Shipment Plan.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-d0b310ea | D1 | Waterfall Shipment Plan.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | NA | ERROR | 기존행 r0 동적 <DYNAMIC:LOOP> → 대표 M_202608(439개 중)  편집=false — 기대: AS-IS 동적 컬럼 잠금 기대 없음(편집 모드 기본 해제 가정)  |  |
| V-3a05113e | H13 | Waterfall Shipment Plan.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | ERROR | PASS | D_20260824 r21 값 '-281' 글자색 rgb(192, 57, 43) (동적 <DYNAMIC:LOOP> → 대표 M_202608(439개 중)) |  |
| V-b07a4472 | H1 | Waterfall Shipment Plan.DEPT_NAME_KO (Team) | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-7305cd8f | H1 | Waterfall Shipment Plan.DIVISION_ID (Division) | NA | PASS | AS-IS center ↔ TO-BE center · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO |  |
| V-43169ed8 | H1 | Waterfall Shipment Plan.ELECTRODE_TYPE (Electrode Type) | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-ef7a3a23 | H1 | Waterfall Shipment Plan.ITEM_TYPE (Item Type) | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-4cfcc1d1 | H1 | Waterfall Shipment Plan.ORIGIN_FROM_DIVISION_ID (Origin From | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-86289e8d | H1 | Waterfall Shipment Plan.ORIGIN_TO_DIVISION_ID (Origin To Div | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-cfff446a | H1 | Waterfall Shipment Plan.PROJECT_NAME (Project) | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-6ceb16da | H1 | Waterfall Shipment Plan.PROJECT_OWNER (Project Owner) | NA | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0016/Waterfall Shipment Plan) · TO-BE  |  |
| V-e2615bd2 | G1 | SCP0016 텍스트 부분일치 Period | NA | ERROR |  ／ [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(smoke 조회조건 동작 |  |
| V-8f5fcd2f | H6 | new SCM0002_TitleSetForm_Popup("SCP0016", SpdSheet.shtMain,  | NA | PASS | AS-IS 팝업 문장 'new SCM0002_TitleSetForm_Popup("SCP0016", SpdSheet' → 팝업 SCM0002_TitleSetForm_Popup 의 규 |  |
| V-c1488596 | H6 | frm.ShowDialog() | NA | PASS | AS-IS 팝업 문장 'frm.ShowDialog()' → 팝업 SCM0002_TitleSetForm_Popup 의 규칙 H6 실측 4행을 이어받음 — [EG-af7c5681] B |  |
| V-b267a880 | H6 | new SCM0002_ItembyDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_ItembyDivisionPopup()' → 팝업 SCM0002_ItembyDivisionPopup 의 규칙 H6 실측 6행을 이어받음 |  |
| V-fcbbec60 | M3 | new SCM0002_ItembyDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_ItembyDivisionPopup()' → 팝업 SCM0002_ItembyDivisionPopup 의 규칙 M3 실측 1행을 이어받음 |  |
| V-b747db29 | H6 | popItem.Form_Load(true, division, sScmSite, sProject, sItemI | NA | PASS | AS-IS 팝업 문장 'popItem.Form_Load(true, division, sScmSite, sProje' → 팝업 SCM0002_ItembyDivisionPopup 의  |  |
| V-b9548002 | H6 | popItem.ShowDialog() | NA | PASS | AS-IS 팝업 문장 'popItem.ShowDialog()' → 팝업 SCM0002_ItembyDivisionPopup 의 규칙 H6 실측 6행을 이어받음 — [EG-63b47d |  |
| V-42f5e7f4 | H6 | new SCM0002_ProjectbyDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_ProjectbyDivisionPopup()' → 팝업 SCM0002_ProjectbyDivisionPopup 의 규칙 H6 실측 6행 |  |
| V-deed0e5b | M3 | new SCM0002_ProjectbyDivisionPopup() | NA | PASS | AS-IS 팝업 문장 'new SCM0002_ProjectbyDivisionPopup()' → 팝업 SCM0002_ProjectbyDivisionPopup 의 규칙 M3 실측 1행 |  |
| V-2b66e82f | H6 | popProject.Form_Load(true, division, sProject) | NA | PASS | AS-IS 팝업 문장 'popProject.Form_Load(true, division, sProject)' → 팝업 SCM0002_ProjectbyDivisionPopup 의 규 |  |
| V-0b5a2b0d | H6 | popProject.ShowDialog() | NA | PASS | AS-IS 팝업 문장 'popProject.ShowDialog()' → 팝업 SCM0002_ProjectbyDivisionPopup 의 규칙 H6 실측 6행을 이어받음 — [EG- |  |
| V-901f4886 | E4 | DateUtil.Check_PeriodDate | NA | ERROR | DateUtil.Check_PeriodDate — FindData_Main 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(FindDat |  |
| V-43e74421 | H6 | new SCM0002_TitleSetForm_Popup("SCP0016", measure, false) | NA | PASS | AS-IS 팝업 문장 'new SCM0002_TitleSetForm_Popup("SCP0016", measure,' → 팝업 SCM0002_TitleSetForm_Popup 의 규 |  |
| V-96409a8a | H6 | frm.ShowDialog() | NA | PASS | AS-IS 팝업 문장 'frm.ShowDialog()' → 팝업 SCM0002_TitleSetForm_Popup 의 규칙 H6 실측 4행을 이어받음 — [EG-af7c5681] B |  |
| V-35c9006d | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-ac4bf26e | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NA | ERROR | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smok |  |
| V-12b1e5ef | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(D_20260824) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함:  |  |
| V-50c8201e | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ecd28df5] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-e62a9bdb | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | PASS | ERROR | 규칙 M4 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-4910041c] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-53aae4fb | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | ERROR | PASS | 규칙 H6 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-1c7ae3e9 | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,21 |  |
| V-715ba147 | G4 | [DMF0020 결함 유형] 조회조건 Project | NA | ERROR | 규칙 G4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-ed4a57f3] btnProject: 실측[T-ed4a57f3]: 검사기(smoke 화면 열림(lab |  |
| V-9667acdb | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Descriptio | NA | PASS | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-8f5fcd2f] new SCM0002_TitleSetForm_Popup("SCP0016", SpdSh |  |
| V-7b089de7 | G5 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-d35cb779] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-a8933526 | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer | NA | ERROR | 규칙 H3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-b74c50af] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-992c947a | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer | NA | ERROR | 규칙 G4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-b9311438] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-4d1782e2 | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | PASS | ERROR | 규칙 C1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c527a1d9] cboBucketType / Bucket / Bucket Type: 'Bucket'  |  |
| V-39bff53e | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | NA | ERROR | 규칙 D2 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-9611434b] Waterfall Shipment Plan.<DYNAMIC:LOOP> (동적 LOOP |  |
| V-a8972a2b | G2 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ecd28df5] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-f1616de4 | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회 | NA | ERROR | 규칙 G5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-971288dd] cboBucketType / Bucket / Bucket Type: 실측[T-9712 |  |
| V-5463a408 | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회 | PASS | NA | 규칙 G4 대상 일치 1행이 모두 NA — [V-51ca7f27] 조회조건 Period: 기준 순서 7번째 'Period' — 화면 8번째 · 순서 차이는 [V-dfe2124a]  |  |
| V-a2a029a5 | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회 | NA | ERROR | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-87b2c40d] cboBucketType / Bucket / Bucket Type: 실측[T-87b2 |  |
| V-29bc0ba5 | D1 | [DMF0042 결함 유형] Team·End Customer·Energy(WH) 컬럼 | NA | PASS | 규칙 D1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-f516468e] Waterfall Shipment Plan.DEPT_NAME_KO (Team): 기존 |  |
| V-e16dca14 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,21 |  |
| V-c1c3e108 | H7 | [DMF0074 결함 유형] Excel Form 양식 헤더 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-908d3949 | G1 | [DMF0053 결함 유형] Project·Owner 조회조건(Model/Nickname 정상) | PASS | ERROR | 규칙 G1 판정 10행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-bfbe66bf] SCP0016 팝업 SCM0002_ProjectbyDivisionPopup CON |  |
| V-5dedc215 | H7 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-464c140e | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | PASS | ERROR | 규칙 G5 판정 16행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-d35cb779] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_c |  |
| V-4af7ab0e | A7 | [DMF0035 결함 유형] 결과 컬럼 값(Plan Type=MKT FCST Version 컬럼 등) | NA | ERROR | 규칙 A7 판정 22행 중 FAIL 0 · 판정필요 0 · 미검증 21 — [V-05926782] SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL:  ／ [미 |  |
| V-f8c11e2e | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | ERROR | PASS | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-e3f78981 | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | NA | PASS | 규칙 M3 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-deed0e5b] new SCM0002_ProjectbyDivisionPopup(): AS-IS 팝업  |  |
| V-4589ec61 | G5 | [DMF0005 결함 유형] Model 팝업 조회 | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-d35cb779] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-d716dfc1 | E3 | [SYS0004 결함 유형] Insert 저장 / Delete CRUD Status | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| V-a22053a0 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-72ef7746] 조회조건 Operation group: [화면 초기(선택 Div=81)] AS-IS  |  |
| V-f777cdeb | C1 | [DMF0035 결함 유형] 조회조건 전체(숫자·ITEM TYPE 포함) | PASS | ERROR | 규칙 C1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-c527a1d9] cboBucketType / Bucket / Bucket Type: 'Bucket'  |  |
| V-0c72efb8 | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | NA | ERROR | 규칙 C1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [T-384b47a7] clbVersion / Version / Ver. / Version.: 'Ver.'  |  |
| V-2f5bbf9d | A5 | [DMF0082 결함 유형] BIZ PLAN 제외 컬럼(Cust Group Dtl 등 7개) | PASS | ERROR | 규칙 A5 판정 52행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-16619dc1] SCP0016 스냅샷 헤더 Waterfall Shipment Plan: [재실측 스 |  |
| V-57b17536 | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | PASS | ERROR | 규칙 G5 판정 6행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-d35cb779] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_ch |  |
| V-d02415fc | G4 | [SCP0007 결함 일반화] 조회조건 명칭·순서 / 대응 컬럼명 | NA | ERROR | 규칙 G4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-b9311438] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-321d1ef1 | H6 | [DMF0005 결함 일반화] Model Code Change 팝업(MODEL_CODE_CHANGE Moda | ERROR | PASS | 규칙 H6 판정 9행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-e5a60e99 | G4 | [DMF0074 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 권한 자동 선택 · Pe | PASS | ERROR | 규칙 G4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [EG-b9311438] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-9e8fa4ba | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME | PASS | ERROR | 규칙 M4 판정 11행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [T-5dff124a] txtProject / Project / PJT: 실측[T-5dff124a]: 검사 |  |
| V-cc16d614 | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 MS1 판정 1행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-f6b56bf4 | MS1 | [DMF0021 결함 일반화] 조회 검사 Division 빈 값 안내 메시지(MSG00667 「권한을 가진  | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 MS1 판정 1행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-7e8e3a13 | H7 | [DMF0049 결함 일반화] Excel Download 월 칸 서식(#,##0.000;[Red]-#,##0 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-6f5f5c1e | G5 | [DMF0074 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(MODE | PASS | ERROR | 규칙 G5 판정 19행 중 FAIL 0 · 판정필요 0 · 미검증 3 — [V-d35cb779] 조회조건 Model/Nickname:  ／ [미검증] 검사기(popup_args_c |  |
| V-ee1b3721 | M4 | [DMF0074 결함 일반화] 조회조건 Model/Nickname(MODEL) 팝업 Close(취소) 시 기 | PASS | ERROR | 규칙 M4 판정 5행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-4910041c] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-446c6143 | MS1 | [DMF0004 결함 일반화] 변경 없이 Save(F7) 시 안내 메시지 코드(MSG_NO_CHANGE 미등 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 MS1 판정 1행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-5df2293a | MS1 | [DMF0014 결함 일반화] 조회 · 저장 안내 문구 코드(MSG00667 · MSG01135 · MSG0 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 MS1 판정 1행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-65dffc63 | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(A | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 MS1 판정 1행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-e5787dfd | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-0c5db0c4 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(D_20260824) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함:  |  |
| V-cf2be221 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 규칙 G2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-ecd28df5] 조회조건 Model/Nickname:  ／ [미검증] 검사기(_verify.spec( |  |
| V-1aec5c36 | H7 | Excel Download(TEAM·FCST Type·Measure·Project) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-69cbaf2b | G4 | 조회조건 명칭·순서 / 대응 컬럼명 | NA | ERROR | 규칙 G4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-b9311438] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-c20e73b7 | H3 | 그리드 셀 세로 병합 대상 컬럼 | NA | ERROR | 규칙 H3 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [EG-b74c50af] SCP0016 팝업 SCM0002_ItembyDivisionPopup COND:Mo |  |
| V-1d6670a6 | E3 | 그리드 필수 컬럼(USER_SELECTABLE_FLAG=N · 라벨 *) 미입력 저장 | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| V-51989246 | E3 | 그리드 필수 컬럼 Setting(Div 별 META) · 컬럼셋팅 필수 표시 · 저장 필수 검증 | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| T-0791b326 | H6 | txtProject / Project / PJT | ERROR | PASS | E2E smoke cond popup |  |
| T-5dff124a | M4 | txtProject / Project / PJT | NA | ERROR | 실측[T-5dff124a]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-870dbc9f | H6 | btnProject | NA | ERROR | 실측[T-870dbc9f]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tra |  |
| T-61c328f3 | G5 | btnProject | NA | ERROR | 실측[T-61c328f3]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진  |  |
| T-12384b2e | M4 | btnProject | NA | ERROR | 실측[T-12384b2e]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-fb8039d6 | H6 | txtItem_Id / Model / Item_Id / Model/Nickname / Nickname | ERROR | PASS | E2E smoke cond popup |  |
| T-4910041c | M4 | txtItem_Id / Model / Item_Id / Model/Nickname / Nickname | NA | ERROR | 실측[T-4910041c]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-1b69f379 | H6 | btnItem | NA | ERROR | 실측[T-1b69f379]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tra |  |
| T-c5aa717a | G5 | btnItem | NA | ERROR | 실측[T-c5aa717a]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진  |  |
| T-8d93d715 | M4 | btnItem | NA | ERROR | 실측[T-8d93d715]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-519950e7 | A5 | D00-1-011 · §1 chkSum / UsrCheckBox | 판정필요 | ERROR | 행 집계 — 대조표 D00-1-011 '§1 chkSum / UsrCheckBox' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-d6813483 | G4 | D00-1-012 · §1 usrConditionPanel1 / UsrConditionPanel | PASS | ERROR | 행 집계 — 대조표 D00-1-012 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 12요소: PASS:8 · ERROR:4 |  |
| T-ec630595 | A5 | D00-1-013 · §1 spdMain / FpSpread | 판정필요 | ERROR | 행 집계 — 대조표 D00-1-013 '§1 spdMain / FpSpread' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-c4e5d535 | H5 | D00-1-013 · §1 spdMain / FpSpread | PASS | ERROR | 행 집계 — 대조표 D00-1-013 '§1 spdMain / FpSpread' 의 H5 4요소: ERROR:2 · NA:2 |  |
| T-c5226947 | A5 | D00-1-016 · §1 spdMain_Sheet1 / SheetView | 판정필요 | ERROR | 행 집계 — 대조표 D00-1-016 '§1 spdMain_Sheet1 / SheetView' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-3dbf1d82 | H5 | D00-1-016 · §1 spdMain_Sheet1 / SheetView | PASS | ERROR | 행 집계 — 대조표 D00-1-016 '§1 spdMain_Sheet1 / SheetView' 의 H5 4요소: ERROR:2 · NA:2 |  |
| T-384b47a7 | C1 | clbVersion / Version / Ver. / Version. | NA | ERROR | 'Ver.' → 'SP_W_20260824 (W35)' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbVersion_SelectedIndexChanged  |  |
| T-c0ffa291 | C4 | clbVersion / Version / Ver. / Version. | NA | ERROR | 상위 'Ver.' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-c527a1d9 | C1 | cboBucketType / Bucket / Bucket Type | NA | ERROR | 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS  |  |
| T-b2c1e1ba | C1 | chkSum / Sum | NA | ERROR | 상위 조건 'Sum' 이 콤보가 아님(checkbox) — 이 유형 변경 프로브 미구현 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-4bbffe60 | G5 | D00-2-010 · §2 spdMain / CellDoubleClick | PASS | ERROR | 행 집계 — 대조표 D00-2-010 '§2 spdMain / CellDoubleClick' 의 G5 17요소: NA:8 · ERROR:6 · PASS:3 |  |
| T-67a402c5 | M4 | D00-2-010 · §2 spdMain / CellDoubleClick | NA | ERROR | 행 집계 — 대조표 D00-2-010 '§2 spdMain / CellDoubleClick' 의 M4 7요소: ERROR:7 |  |
| T-baaf3027 | E3 | D00-2-011 · §2 spdMain / TopChange | NA | ERROR | 행 집계 — 대조표 D00-2-011 '§2 spdMain / TopChange' 의 E3 1요소: ERROR:1 |  |
| T-8333c7ee | A5 | D00-3-020 · §3 Query / (dsBinding) 그리드 바인딩 | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-020 '§3 Query / (dsBinding) 그리드 바인딩' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-d7c4bfa3 | H5 | D00-3-020 · §3 Query / (dsBinding) 그리드 바인딩 | PASS | ERROR | 행 집계 — 대조표 D00-3-020 '§3 Query / (dsBinding) 그리드 바인딩' 의 H5 4요소: ERROR:2 · NA:2 |  |
| T-3c897917 | A5 | D00-3-021 · §3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬 | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-021 '§3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 ' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-fafdfcaa | H5 | D00-3-021 · §3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬 | PASS | ERROR | 행 집계 — 대조표 D00-3-021 '§3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 ' 의 H5 4요소: ERROR:2 · NA:2 |  |
| T-08e22079 | C3 | D00-3-023 · §3 SetValue / (iRow, bef_month_idx, sum_month) 월 | NA | ERROR | 행 집계 — 대조표 D00-3-023 '§3 SetValue / (iRow, bef_month_idx, sum_month) 월합 ' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-bfd3c521 | C3 | D00-3-024 · §3 SetValue / (iRow, bef_month_idx, val) | NA | ERROR | 행 집계 — 대조표 D00-3-024 '§3 SetValue / (iRow, bef_month_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-2062bf35 | C3 | D00-3-025 · §3 SetValue / (iRow, bef_week_idx, sum_week) 주합  | NA | ERROR | 행 집계 — 대조표 D00-3-025 '§3 SetValue / (iRow, bef_week_idx, sum_week) 주합 파생' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-2edfd222 | C3 | D00-3-026 · §3 SetValue / (iRow, bef_week_idx, val) | NA | ERROR | 행 집계 — 대조표 D00-3-026 '§3 SetValue / (iRow, bef_week_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-c107511c | C3 | D00-3-027 · §3 SetValue / (iRow, bef_week_idx, sum_week) | NA | ERROR | 행 집계 — 대조표 D00-3-027 '§3 SetValue / (iRow, bef_week_idx, sum_week)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-de61e8cf | C3 | D00-3-028 · §3 SetValue / (iRow, bef_month_idx, sum_month) | NA | ERROR | 행 집계 — 대조표 D00-3-028 '§3 SetValue / (iRow, bef_month_idx, sum_month)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-67587c35 | C3 | D00-3-029 · §3 SetValue / (iRow, bef_week_idx, val) | NA | ERROR | 행 집계 — 대조표 D00-3-029 '§3 SetValue / (iRow, bef_week_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-8ecc3576 | C3 | D00-3-030 · §3 SetValue / (iRow, bef_month_idx, val) | NA | ERROR | 행 집계 — 대조표 D00-3-030 '§3 SetValue / (iRow, bef_month_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  |
| T-6ddddb2b | A5 | D00-3-033 · §3 Visible= / Daily: isDaily/isWeekly → true | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-033 '§3 Visible= / Daily: isDaily/isWeekly → true' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-e6aec75b | A5 | D00-3-034 · §3 Visible= / Daily: isMonthly/isWeekly → chkSum | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-034 '§3 Visible= / Daily: isMonthly/isWeekly → chkSum.C' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-b0d5c148 | A5 | D00-3-035 · §3 Visible= / Weekly: isDaily → false | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-035 '§3 Visible= / Weekly: isDaily → false' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-f8e013e4 | A5 | D00-3-036 · §3 Visible= / Weekly: isWeekly → true | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-036 '§3 Visible= / Weekly: isWeekly → true' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-e7509ac2 | A5 | D00-3-037 · §3 Visible= / Weekly: isMonthly → chkSum.Checked | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-037 '§3 Visible= / Weekly: isMonthly → chkSum.Checked' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-a19a4a28 | A5 | D00-3-038 · §3 Visible= / WeeklyISO: isWeeklyISO | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-038 '§3 Visible= / WeeklyISO: isWeeklyISO' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-113cc0ec | A5 | D00-3-039 · §3 Visible= / Monthly: isDaily/isWeekly → false | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-039 '§3 Visible= / Monthly: isDaily/isWeekly → false' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-e2762619 | A5 | D00-3-040 · §3 Visible= / Monthly: else → true | 판정필요 | ERROR | 행 집계 — 대조표 D00-3-040 '§3 Visible= / Monthly: else → true' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-1d27dffe | A1 | PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 판정필요 | PASS | golden PASS AS-IS 452행 ↔ TO-BE 452행: Doc/golden/SCP0016/SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL.md ·  |  |
| T-dc867ef6 | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL: 화면 진입·조회 경로에서 이 SP 가 결과를 반환하지 않음(팝업·셀 이벤트 SP) —  |  |
| T-a6641ba3 | DB-SYN | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | NA | ERROR | 실측[T-a6641ba3]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 le |  |
| T-4fe0bd1b | A6 | D00-4a-003 · §4a (localConst, 빈 sp명) / GetSpdTitle(1120) | 판정필요 | ERROR | 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 A6 4요소: PASS:2 · ERROR:2 |  |
| T-723b3061 | F4 | D00-4a-003 · §4a (localConst, 빈 sp명) / GetSpdTitle(1120) | PASS | ERROR | 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 F4 4요소: PASS:3 · ERROR:1 |  |
| T-1f759f2c | DB-SYN | D00-4a-003 · §4a (localConst, 빈 sp명) / GetSpdTitle(1120) | PASS | ERROR | 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 DB-SYN 4요소: PASS:3 · ERROR:1 |  |
| T-6c909b37 | X-REASON | D00-4b-003 · §4b SaveButton / toolbarOverride / Save | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-f5495bd4 | G5 | D00-4b-009 · §4b SpdMain_CellDoubleClick / event / spdMain | PASS | ERROR | 행 집계 — 대조표 D00-4b-009 '§4b SpdMain_CellDoubleClick / event / spdMain' 의 G5 17요소: NA:8 · ERROR:6 · PA |  |
| T-5ab9b088 | M4 | D00-4b-009 · §4b SpdMain_CellDoubleClick / event / spdMain | NA | ERROR | 행 집계 — 대조표 D00-4b-009 '§4b SpdMain_CellDoubleClick / event / spdMain' 의 M4 7요소: ERROR:7 |  |
| T-78a52878 | E3 | D00-4b-010 · §4b SpdMain_TopChange / event / spdMain | NA | ERROR | 행 집계 — 대조표 D00-4b-010 '§4b SpdMain_TopChange / event / spdMain' 의 E3 1요소: ERROR:1 |  |
| T-2a6418fe | G5 | D00-4d-001 · §4d SpdMain_CellDoubleClick / (grid dblclick) | PASS | ERROR | 행 집계 — 대조표 D00-4d-001 '§4d SpdMain_CellDoubleClick / (grid dblclick)' 의 G5 17요소: NA:8 · ERROR:6 · PA |  |
| T-fa92fd7a | M4 | D00-4d-001 · §4d SpdMain_CellDoubleClick / (grid dblclick) | NA | ERROR | 행 집계 — 대조표 D00-4d-001 '§4d SpdMain_CellDoubleClick / (grid dblclick)' 의 M4 7요소: ERROR:7 |  |
| T-73e6ce1d | H6 | btnColumn | NA | ERROR | 실측[T-73e6ce1d]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tra |  |
| T-e9c941da | M4 | btnColumn | NA | ERROR | 실측[T-e9c941da]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-47ea6625 | G5 | btnColumn | NA | ERROR | 실측[T-47ea6625]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진  |  |
| T-315acc5c | M4 | btnMeasure | NA | ERROR | 실측[T-315acc5c]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace ／ [미검증] 검 |  |
| T-986df44f | M3 | D00-4e-003 · §4e SCM0002_ItembyDivisionPopup / ShowDialog(mo | PASS | ERROR | 행 집계 — 대조표 D00-4e-003 '§4e SCM0002_ItembyDivisionPopup / ShowDialog(modal' 의 M3 6요소: ERROR:4 · NA:1  |  |
| T-957d1d84 | M4 | D00-4e-003 · §4e SCM0002_ItembyDivisionPopup / ShowDialog(mo | NA | ERROR | 행 집계 — 대조표 D00-4e-003 '§4e SCM0002_ItembyDivisionPopup / ShowDialog(modal' 의 M4 7요소: ERROR:7 |  |
| T-6d2f943c | G5 | D00-4e-003 · §4e SCM0002_ItembyDivisionPopup / ShowDialog(mo | PASS | ERROR | 행 집계 — 대조표 D00-4e-003 '§4e SCM0002_ItembyDivisionPopup / ShowDialog(modal' 의 G5 17요소: NA:8 · ERROR:6 |  |
| T-c9de0615 | M3 | D00-4e-004 · §4e SCM0002_ProjectbyDivisionPopup / ShowDialog | PASS | ERROR | 행 집계 — 대조표 D00-4e-004 '§4e SCM0002_ProjectbyDivisionPopup / ShowDialog(mo' 의 M3 6요소: ERROR:4 · NA:1  |  |
| T-41bb7ba4 | M4 | D00-4e-004 · §4e SCM0002_ProjectbyDivisionPopup / ShowDialog | NA | ERROR | 행 집계 — 대조표 D00-4e-004 '§4e SCM0002_ProjectbyDivisionPopup / ShowDialog(mo' 의 M4 7요소: ERROR:7 |  |
| T-3103459a | G5 | D00-4e-004 · §4e SCM0002_ProjectbyDivisionPopup / ShowDialog | PASS | ERROR | 행 집계 — 대조표 D00-4e-004 '§4e SCM0002_ProjectbyDivisionPopup / ShowDialog(mo' 의 G5 17요소: NA:8 · ERROR:6 |  |
| T-f611f34e | X-REASON | CRUD:D00-4b-003:SAVE · [SAVE] §4b SaveButton / toolbarOverri | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-b379fd3f | M3 | MODAL:ShowDialog · AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PASS | ERROR | 행 집계 — 대조표 MODAL:ShowDialog 'AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무' 의 M3 6요소: ERROR:4 · NA:1 · PAS |  |
| T-bbcc481e | M4 | MODAL:ShowDialog · AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | NA | ERROR | 행 집계 — 대조표 MODAL:ShowDialog 'AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무' 의 M4 7요소: ERROR:7 |  |
| T-30ec5bc7 | G5 | MODAL:ShowDialog · AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PASS | ERROR | 행 집계 — 대조표 MODAL:ShowDialog 'AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무' 의 G5 17요소: NA:8 · ERROR:6 · PA |  |
| T-b0ff787f | X-REASON | COMMON:UC-05 · Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출 | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e0418a34 | G4 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | PASS | ERROR | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 12요소: PASS:8 · ERROR:4 |  |
| T-a3aecccb | G5 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | PASS | ERROR | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G5 17요소: NA:8 · ERROR:6 · PAS |  |
| T-36275c7b | M4 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | NA | ERROR | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 M4 7요소: ERROR:7 |  |
| T-3a4b4795 | A5 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebind | 판정필요 | ERROR | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 2요소: PASS:1 · ERRO |  |
| T-590edc57 | H5 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebind | PASS | ERROR | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 4요소: ERROR:2 · NA: |  |
| T-3ba7861f | X-LOC | 3 · BtnProject_Click(1304) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-91718e53 | X-LOC | 4 · BtnItem_Id_Click(1283) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e25e9008 | X-LOC | 5 · BtnColumn_Click(580) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e1437495 | X-LOC | 6 · btnMeasure_Click(1324) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-f799fb96 | X-LOC | 7 · cboBucketType_SelectedIndexChanged(1193) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-d99d9999 | A5 | 7 · cboBucketType_SelectedIndexChanged(1193) | 판정필요 | ERROR | 행 집계 — 대조표 7 'cboBucketType_SelectedIndexChanged(1193)' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-a785baec | X-LOC | 8 · chkSum_CheckedChanged(1207) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-187265ef | X-LOC | 9 · dCalendar_ValueChanged(1351) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-23179cae | A5 | 9 · dCalendar_ValueChanged(1351) | 판정필요 | ERROR | 행 집계 — 대조표 9 'dCalendar_ValueChanged(1351)' 의 A5 2요소: PASS:1 · ERROR:1 |  |
| T-a05941f8 | X-LOC | 10 · SpdMain_CellDoubleClick(1051) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-9f8ef5a1 | G5 | 10 · SpdMain_CellDoubleClick(1051) | PASS | ERROR | 행 집계 — 대조표 10 'SpdMain_CellDoubleClick(1051)' 의 G5 17요소: NA:8 · ERROR:6 · PASS:3 |  |
| T-1f78ead4 | M4 | 10 · SpdMain_CellDoubleClick(1051) | NA | ERROR | 행 집계 — 대조표 10 'SpdMain_CellDoubleClick(1051)' 의 M4 7요소: ERROR:7 |  |
| T-511a9c2e | X-LOC | 11 · SpdMain_TopChange(592) | NA | ERROR | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e2512ce2 | E3 | 11 · SpdMain_TopChange(592) | NA | ERROR | 행 집계 — 대조표 11 'SpdMain_TopChange(592)' 의 E3 1요소: ERROR:1 |  |
| T-86ac90c2 | E3 | 1 · MSG00109 EditButton 읽기전용 가드(644) | NA | ERROR | 행 집계 — 대조표 1 'MSG00109 EditButton 읽기전용 가드(644)' 의 E3 1요소: ERROR:1 |  |
| T-79323dd2 | E3 | 2 · GMessageBoxForException SetOperationGroupByDivision(908) | NA | ERROR | 행 집계 — 대조표 2 'GMessageBoxForException SetOperationGroupByDivisio' 의 E3 1요소: ERROR:1 |  |
| T-aa01054e | A6 | FindButton(636) · FindData_Main() 실동작 | 판정필요 | ERROR | 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 A6 4요소: PASS:2 · ERROR:2 |  |
