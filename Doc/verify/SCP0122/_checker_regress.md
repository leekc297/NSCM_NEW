# 검사기 회귀 대조 SCP0122 — 기준 2026-11-07 15:25 (1548행) ↔ 현재 2026-11-14 18:23 (1548행)

- 악화(기준 비FAIL → 현재 FAIL): **2** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 0 · 그 외 변경: 92 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 15 · 새 행 15
- 승격 대기(received): Doc\verify\_checker_golden\SCP0122.received.csv — 확인 뒤 `checker_regress.py SCP0122 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-b2ab9f0a | F5 | SCP0122 화면 | PASS | FAIL | Insert → 신규행 CRUD_TYPE='I' · 기존행 OPMZ_ACTV_SEQ 편집 → CRUD_TYPE='' · 신규행 Delete → 신규행 1→0 · 기존행 Delete |  |
| T-21988288 | F5 | SCP0122 화면 | PASS | FAIL | Insert → 신규행 CRUD_TYPE='I' · 기존행 OPMZ_ACTV_SEQ 편집 → CRUD_TYPE='' · 신규행 Delete → 신규행 1→0 · 기존행 Delete |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-6ec80739 | J2 | SCP0122 화면 | ERROR | PASS | E2E auth authorized=true notFound=false menuAccess=Y tobeGroups=ADMIN／GUEST／SSP Planner roster=40:AD |  |
| V-e811f497 | F8 | SCP0122 저장 감사 필드 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-db47106c | F7 | SCP0122 저장 연계 테이블 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-eae7d9ad | F5 | SCP0122 원값 복원 상태 해제 | PASS | ERROR | [측정 경로 없음] OPMZ_ACTV_SEQ 값 변경이 안 됨('1') |  |
| V-9646c6fd | F3 | SCP0122 시나리오 [자동] OPMZ_ACTV_NAME 신규 행 콤보 붙여넣기 — 후보 값 반영 | 판정필요 | PASS | [자동] OPMZ_ACTV_NAME 신규 행 콤보 붙여넣기 — 후보 값 반영: 기대대로 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출0·요청6 → inse |  |
| V-642f2141 | H11 | SCP0122 화면 | PASS | 판정필요 | [시험 검사 CM-003 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T98 — 병렬 call-proc |  |
| V-1934eacc | A7 | SCP0122_GET_PLAN_ACTIVITY_MGMT | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-8b968083 | B7 | 조회조건 Div | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-37a5b07b | C1 | 조회조건 Div | NA | ERROR | 상속(TRACE T-3bfb2186): 행 `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi() = 조회조건 C1 실측  |  |
| V-2c7cccf5 | B3 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)]  · 원천 - · 표현 - → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-5ef93420 | B4 | 조회조건 Plan Group | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 원천 실행 불가 — 'dtPlanGroup 원천 대입 미발견(필드 초기화·외부 주입 확인)' · 원천 - · 표현 - → 기계 판정 불 |  |
| V-4464ebfb | B7 | 조회조건 Plan Group | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-f2873f89 | G7 | 조회조건 Plan Group | NA | ERROR |  ／ [미검증] 검사기(combo_oracle.py(W1) G7 — AS-IS 컨트롤 표시 열(CControl.setListBox·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-ba79c933 | B7 | 조회조건 Process | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-44f2c0a1 | G7 | 조회조건 Process | NA | ERROR | [화면 초기(선택 Div=81)] AS-IS 표시 열 해석 불가(cboProcess: 컨트롤 유형 UsrComboBox · 바인딩 있음) · 원천 UP_FX_GetCommonDat |  |
| V-75eb4f08 | A5 | Plan Activity Mgmt.OPMZ_PRS_CD (Process CD) | NA | ERROR | OPMZ_PRS_CD 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N')) → TO-BE 메타(SHEET_COLUMNS VISIBLE |  |
| V-c9aa3b5b | A5 | Plan Activity Mgmt.OPMZ_PLAN_GR_ID (Plan Group ID) | NA | ERROR | OPMZ_PLAN_GR_ID 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N')) → TO-BE 메타(SHEET_COLUMNS VIS |  |
| V-08ffb8da | B3 | Plan Activity Mgmt.OPMZ_ACTV_NAME (Activity Name) | NA | ERROR | [신규행(DIVISION_ID=81)] 정렬 컬럼 ['CODE'] 이 사내 SCM_ADM_LOOKUP_MASTER_DETAIL 에 없음 · 원천 UP_FX_GetCommonData |  |
| V-0d2d9b14 | A5 | Plan Activity Mgmt.PRE_OPMZ_ACTV_CD (PRE_OPMZ_ACTV_CD) | NA | ERROR | PRE_OPMZ_ACTV_CD 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N')) → TO-BE 메타(SHEET_COLUMNS VI |  |
| V-88826131 | A5 | Plan Activity Mgmt.PRE_OPMZ_ACTV_SEQ (PRE_OPMZ_ACTV_SEQ) | NA | ERROR | PRE_OPMZ_ACTV_SEQ 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N')) → TO-BE 메타(SHEET_COLUMNS V |  |
| V-e96482ff | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NA | ERROR | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smok |  |
| V-f1f17265 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-cd7ad36b | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-0049f42d | E6 | 텍스트 입력 컨트롤(TEXT BOX · FPText) 마우스 드래그 선택 후 Delete/Backspace | PASS | NA | 직접 실측 없음 — 같은 규칙 E6 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-e41495e0] SCP0122 화면 ／ [V-bb368bbd] SCP01 |  |
| V-480a997c | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-2f46deed | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-37c5cef2 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-5b273657 | G2 | [DMF0004 결함 유형] 조회조건 Active | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-dfa93a03 | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-eaeb7278 | A5 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | NA | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9efda9ee] OPMZ_ACTV_CD / Activity Code: OPMZ_ACTV_CD: AS- |  |
| V-75f2ab0f | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST A | PASS | ERROR | 규칙 A5 판정 21행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-23483d12] SCP0122 스냅샷 헤더 Plan Activity Mgmt: [재실측 스냅샷 헤더 |  |
| V-8a1c0681 | G2 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-e6008e5f | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NA | ERROR | hide PASS: 헤더(DIVISION_ID) 우클릭 → Hide Column → 컬럼 비표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K1  |  |
| V-e517e5fd | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | NA | ERROR | copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ hide PA |  |
| V-5a2d42aa | G2 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-e9e1dae9 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,0, |  |
| V-b8a00261 | E6 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | ime NA: 신규행에 직접 입력하는 문자 컬럼 없음 ／ auto PASS: 신규행 OPMZ_ACTV_NAME 에 'Ma' 입력 → 편집기 'Master Validation' ·  |  |
| V-7d226c1e | G2 | [DMF0040 결함 유형] End Customer 다중 선택 조회조건 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-befc38a4 | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | ERROR | NA | 규칙 F2 요소 판정에 FAIL 0 · 판정필요 0 · 미검증 1 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-d67f7473 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | NA | ERROR | 판정필요: (a) 저장 SP SCP0122_SAVE_PLAN_ACTIVITY_MGMT 대상 SCP_OPMZ_PLAN_GR_ACTV_M 와 콤보 원천 5종이 읽는 테이블이 겹치지 않 |  |
| V-cfe5831b | A7 | [DMF0035 결함 유형] 결과 컬럼 값(Plan Type=MKT FCST Version 컬럼 등) | PASS | ERROR | 규칙 A7 판정 12행 중 FAIL 0 · 판정필요 0 · 미검증 4 — [V-1934eacc] SCP0122_GET_PLAN_ACTIVITY_MGMT:  ／ [미검증] 검사기(t |  |
| V-1b1fd8ac | G2 | [SYS0005 결함 유형] Schema 조회조건 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-c98cfe86 | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-5ab22d67 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-5ef93420] 조회조건 Plan Group: [화면 초기(선택 Div=81)] AS-IS 원천 실행 |  |
| V-e9f851d3 | A5 | [DMF0082 결함 유형] BIZ PLAN 제외 컬럼(Cust Group Dtl 등 7개) | PASS | ERROR | 규칙 A5 판정 19행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-23483d12] SCP0122 스냅샷 헤더 Plan Activity Mgmt: [재실측 스냅샷 헤더 |  |
| V-260f693b | G2 | [SCP0028 결함 유형] From Site 조회조건 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-b59dd103 | G2 | [SCP0007 결함 일반화] 멀티선택 조회조건 Select ALL | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-056760af | A5 | 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | NA | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9efda9ee] OPMZ_ACTV_CD / Activity Code: OPMZ_ACTV_CD: AS- |  |
| V-178f7430 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함: |  |
| V-ecc2c9c3 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-af69fc63 | G2 | 멀티선택 조회조건 Select ALL | NA | ERROR | 자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 G2 판정 5행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음 |  |
| V-15eaf209 | C1 | 조회조건 Division 콤보(DIVISION_ID 단일 선택 화면) · 하위 조회조건 · 전 그리드 | NA | ERROR | 규칙 C1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-3c596e73] cboDivision / Division / Div / Div.: 'Div' → '4 |  |
| V-54fe902e | G4 | SCP0122 스냅샷 조회조건 Div 40 | NA | ERROR | [재실측 스냅샷 조회조건] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0122\snap\received\조회조건_Div_40.aria.yml 를 sna |  |
| V-f6745e80 | K4 | SCP0122 스냅샷 버튼 Div 40 | NA | ERROR | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0122\snap\received\버튼_Div_40.aria.yml 를 snap_va |  |
| V-23483d12 | A5 | SCP0122 스냅샷 헤더 Plan Activity Mgmt | NA | ERROR | [재실측 스냅샷 헤더] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0122\snap\received\헤더_Plan_Activity_Mgmt.txt 를  |  |
| V-41234786 | H4 | SCP0122 스냅샷 화면샷 1920 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| V-bd1416c6 | H4 | SCP0122 스냅샷 화면샷 1366 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| AD-018dbf01 | A7 | SCP0122 SCP0122_GET_PLAN_ACTIVITY_MGMT 공통행 컬럼 값(공통 0행 · 불일치  | NA | ERROR | [VALUES] [차등 검증 #9] main/SEARCH AS-IS SCP0122_GET_PLAN_ACTIVITY_MGMT ↔ TO-BE PKG_SCP0122.P_SCP0122_G |  |
| AD-c73c3f92 | A7 | SCP0122 SCP0122_GET_PLAN_ACTIVITY_MGMT 공통행 컬럼 값(공통 0행 · 불일치  | NA | ERROR | [VALUES] [차등 검증 #10] main/SEARCH AS-IS SCP0122_GET_PLAN_ACTIVITY_MGMT ↔ TO-BE PKG_SCP0122.P_SCP0122_ |  |
| AD-0c83cc1b | A7 | SCP0122 SCP0122_GET_PLAN_ACTIVITY_MGMT 공통행 컬럼 값(공통 0행 · 불일치  | NA | ERROR | [VALUES] [차등 검증 #11] main/SEARCH AS-IS SCP0122_GET_PLAN_ACTIVITY_MGMT ↔ TO-BE PKG_SCP0122.P_SCP0122_ |  |
| T-3bfb2186 | C1 | `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi | NA | ERROR | 행 `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi() = 조회조건 C1 실측 상속: 'Div' → '40 Mobili |  |
| T-f2ceeba6 | C2 | OPMZ_ACTV_CD / Activity Code | NA | ERROR | OPMZ_ACTV_CD 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-63d7d4bf | D1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 · cs:342 | PASS | ERROR | 행 집계 — 대조표 `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 'cs:342' 의 D1 8요소: PASS:7 · ERROR:1 |  |
| T-f93057ee | E3 | 필수검증(actv_cd/actv_seq 공백 MSG00001) · cs | NA | ERROR | 행 집계 — 대조표 필수검증(actv_cd/actv_seq 공백 MSG00001) 'cs' 의 E3 1요소: ERROR:1 |  |
| T-593d35c3 | X-REASON | `prsCd`(GET) = `CString.GetCheckedListValue(dtPlanGroup, cbo | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-981f9803 | E3 | MSG00001 · 필수 공백 | NA | ERROR | 행 집계 — 대조표 MSG00001 '필수 공백' 의 E3 1요소: ERROR:1 |  |
| T-9dc93c04 | X-REASON | COMMON:UC-03 · 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-0badea0e | X-REASON | COMMON:UC-06 · Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | NA | ERROR | 제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-e96ecc7b | C2 | SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged | NA | ERROR | 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged 의 C2 7요소: ERROR:7 |  |
| T-fdf5d8c2 | C6 | SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged | PASS | ERROR | 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged 의 C6 13요소: ERROR:7 · PASS:6 |  |
| T-39d1db98 | X-ROW | SCP0122_PlanActivityMgmt.FindData_Main | PASS | ERROR | 진입점 집계 10검사 — PASS:8 · ERROR:2 |  |
| T-f943bb02 | X-ROW | SCP0122_PlanActivityMgmt.GetPlanGroupByUserID | NA | ERROR | 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  |
| T-d57b7cbe | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | NA | ERROR | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO: SCP0121/searchInfo/SEARCH, SCP0123/searchInfo/SEARCH, SCP0124 |  |
| T-4f0f2872 | X-ROW | SCP0122_PlanActivityMgmt.InitControls | PASS | ERROR | 진입점 집계 8검사 — PASS:7 · ERROR:1 |  |
| T-3c596e73 | C1 | cboDivision / Division / Div / Div. | NA | ERROR | 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDivision_SelectedIndexCha |  |
| T-c914ea21 | X-ROW | SCP0122_PlanActivityMgmt.RefreshPlanGroupByDivision | NA | ERROR | 진입점 집계 1검사 — ERROR:1 |  |
| T-ee24f291 | C1 | cboPlanGroup / Plan Group | NA | ERROR | 'Plan Group' → 'E72B' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 CboPlanGroup_SelectedIndexChanged · AS-IS |  |
| T-4cf07a64 | E4 | MSG00004 | NA | PASS | MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 PASS: [자동] 기존 행 Delete → D 저장 요청: 기대대로 · 저장 요청 1 · |  |
| T-a21662da | C2 | LINK_UI_TYPE / Link UI Type | NA | ERROR | LINK_UI_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-591ee6b6 | C2 | OPTION_YN / Option Flag | NA | ERROR | OPTION_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-32156746 | C2 | OPMZ_ACTV_NAME / Activity Name | NA | ERROR | OPMZ_ACTV_NAME 연쇄 원천 해석 불가 — AS-IS SpdMain_ComboSelChange:229 siMain.GetColumnIndex(DefColumns.OPMZ_ |  |
| T-05c8a62c | C2 | PROGRAM_NAME / Program Name | NA | ERROR | PROGRAM_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-58cf3c02 | C2 | CONFIRM_YN / Confirm Flag | NA | ERROR | CONFIRM_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-3d19f6a9 | C2 | AUTO_YN / Auto Flag | NA | ERROR | AUTO_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-94d5a25e | C2 | SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange | NA | ERROR | 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange 의 C2 7요소: ERROR:7 |  |
| T-cf26c2d7 | X-ROW | SCP0122_PlanActivityMgmt.spdMain_CellClick | NA | ERROR | 실측[T-cf26c2d7]: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| EG-bb8f2e5d | J4 | SCP0122 EG382 직접 접근 SCP/40/SCP Planner | NA | ERROR | 기대 메뉴 권한 없는 계정의 URL 직접 접근 차단(문서 GAPSELF-22·DM-65) · 실제 authorized=true notFound=false · AS-IS SCM_AD |  |
| EG-1f766c9c | J4 | SCP0122 EG382 직접 접근 SCP/40/SCP Tester | NA | ERROR | 기대 메뉴 권한 없는 계정의 URL 직접 접근 차단(문서 GAPSELF-22·DM-65) · 실제 authorized=true notFound=false · AS-IS SCM_AD |  |
| EG-02c1c8d3 | J4 | SCP0122 EG382 직접 접근 SCP/40/SCM Viewer | NA | ERROR | 기대 메뉴 권한 없는 계정의 URL 직접 접근 차단(문서 GAPSELF-22·DM-65) · 실제 authorized=true notFound=false · AS-IS SCM_AD |  |
| EG-0a84b03c | J4 | SCP0122 EG382 직접 접근 SCP/81/SCP Planner | NA | ERROR | 기대 메뉴 권한 없는 계정의 URL 직접 접근 차단(문서 GAPSELF-22·DM-65) · 실제 authorized=true notFound=false · AS-IS SCM_AD |  |
| EG-55cc999e | I2 | SCP0122 언어 전환 KO | PASS | ERROR | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0108) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200) |  |
| EG-743687ee | I2 | SCP0122 언어 전환 EN | PASS | ERROR | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0108) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200) |  |
