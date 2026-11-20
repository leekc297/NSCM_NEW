# SSP0014 미검증 분류 · 2026-11-20 09:53:06 · 라운드 1

- 원장 미검증(ERROR) 42 → 42행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) 11 · 사람 확인 2 · 집계 30
- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).
- 자동 재측정: 없음

| 담당 | 유형 | 행 |
|---|---|---|
| 집계 | 집계 | 30 |
| 엔진 | 검사기공백 | 5 |
| 엔진 | 데이터전제 | 2 |
| 판단 | 판단 | 2 |
| 사람 | 계정 | 1 |
| 사람 | 스냅샷승인 | 1 |
| 엔진 | AI검토:검사기오판 | 1 |
| 엔진 | 미분류 | 1 |

## 담당 엔진 (9행)

### AI검토:검사기오판 · 규칙 G9 · 1행
- 처리: AI 판정 검토: 검사기오판 — tools/Harness/verify 의 G9 판정에서 CR-040 을 적용하기 전에, AS-IS SP 가 그 조건을 String_Split 으로 나누는지 확인하지 않아 LIKE 단일값 조건도 FAIL 로 기록했다. / AS-IS 조회 SP 는 User ID(Name) 입력값을 콤마로 나누지 않고 문자열 전체로 LIKE 검색하므로, 'junha.hwang,njzhoumengwei' 를 넣으면 AS-IS 에서도 0행이 나온다. TO-BE 도 같은 방식(P_USER_ID LIKE)이라 동작이 같다. AS-IS 도 콤마 다중 입력이 안 된다고 본 SCP0100·SCP0111 사용자 판정과 같은 경우다. / 근거 Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15437 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:315 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/useShipmentModelPicStore.ts:117 → 원인(파일:줄) 확인 · 검사기 수정 · 결함 유형(T번호) 기록 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check)
- V-3809bf77 [SEARCH] 조회조건 User ID(Name) | [FAIL] AS-IS 조회 SP 는 User ID(Name) 입력값을 콤마로 나누지 않고 문자열 전체로 LIKE 검색하므로, 'junha.hwang,njzhoumengwei' 를 넣으면 AS-IS 에서도 0행이 나온다. TO-BE 도 같은 방식(P_USER_ID LIKE)이라 동작이 같다. AS-IS 도 콤마 다중 입력이 안 된다고 본 SCP0100·SCP0111 사용자 판정과 같은 경우다

### 검사기공백 · 규칙 A6 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-d1bd8978 [TRACE] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 실측[T-d1bd8978]: [대조표 오기 의심] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 배선 메뉴 SCM0002,SCP0033,SSP0019 · 이 화면 실행 중 호출 0건(Doc/verify/SSP0014/sqllog_calls.json) · 대조표 해당 행의 구현 위치 확인 | [미검증] 검사기(so

### 검사기공백 · 규칙 F1 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/E2E 저장 시험이 행을 고를 때, 그 행의 User ID·Part Leader·Team Leader·Mail User 값이 모두 SSP0014_GET_USER_ID_CHECK를 통과하는 행만 골라야 합니다. 지금은 업무 검증에 막힐 행을 시험 대상으로 썼습니다. / AS-IS와 TO-BE 모두 저장 전에 수정한 행의 User ID·Part Leader·Team Leader 값을 사용자 검사 SP로 확인하고, 통과하지 못하면 저장하지 않습니다. 시험 행에 원래 들어 있던 guoxiaoliang·lgsilee·kwonl이 TO-BE DB에서 SSP Planner 그룹 검사를 통과하지 못해 저장 요청이 나가지 않았습니다. 저장 왕복을 재지 못했으므로 결과를 그대로 둡니다. / 근거 GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:441 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:448 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/ShipmentM
- V-504dee98 [RULE_SCREEN] SSP0014 2행 동시 저장 | [업무 검증 차단] USER_ID 두 행 수정 후 Save — 저장 요청 없음 · 메시지 'SSP Planner 권한이 없는 사용자 입니다 . User ID : guoxiaoliang, lgsilee, kwonl'
- V-5473aa5a [RULE_SCREEN] SSP0014 저장 실패 처리 | USER_ID r20 → luping · [측정 경로 없음] 저장 요청 전에 막힘 · 메시지 'SSP Planner 권한이 없는 사용자 입니다 . User ID : guoxiaoliang'

### 검사기공백 · 규칙 F4 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · AI 판정 검토: 검사기오판 — tools/Harness/verify의 트레이스 대응표가 AS-IS 팝업의 SP를 그대로 대상으로 잡아, TO-BE가 바꾼 팝업(COM0013)의 SP를 재지 못했습니다. FE __asis-mapping__.md에 적힌 교체 결과를 반영해 대상을 다시 정해야 합니다. / AS-IS Model 돋보기 버튼은 SCM0002 팝업(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)을 엽니다. TO-BE는 사용자 지시(2026-10-12)로 공용 MaterialByDivisionModal(COM0013)로 바꿨기 때문에 SSP0014 화면에서는 이 패키지를 부르지 않습니다. 검사기는 AS-IS 팝업 기준으로 대상을 정해 호출을 잡지 못했고, AS-IS에는 대상이 있으므로 NA로 낮추지 않고 결과를 그대로 둡니다. / 근거 GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx:549 ; nscm-fe/fe
- T-bab6f023 [TRACE] PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0019/popup/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 검사기공백 · 규칙 L1 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-9041b5eb [RULE_SCREEN] SSP0014 저장 응답 시간 | [측정 경로 없음] 저장 요청 소요 기록 없음

### 데이터전제 · 규칙 B4 · 2행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회) · AI 판정 검토: 검사기오판 — tools/Harness/verify 콤보 대조기가 이름이 겹치는 후보를 코드로 되돌릴 때 첫 코드만 골라 잘못 짝짓습니다. 응답의 CODE로 대조하고, SP에 하드코딩된 행('-')은 데이터 차이가 아니라 원천 로직으로 분류해야 합니다. / TO-BE From Site 응답에는 AZ00-A 코드가 있습니다. AC00-A·AT00-A·AZ00-A 세 코드가 같은 이름 'AZ Mobile Assy-Cell'을 써서 검사기가 이름을 코드로 되돌릴 때 AZ00-A를 AC00-A로 잘못 짝지었습니다. 남은 차이 가운데 AS-IS SP가 직접 넣는 '-' 항목은 데이터 차이가 아니라 TO-BE에 없는 항목입니다. TO-BE 콤보 SQL 원문을 찾지 못했고 DB_DDL 폴더도 저장소에 없어 '-' 항목만 사용자 판단이 필요하므로 결과를 그대로 둡니다. / 근거 GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:202 ; Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataList_SCP.sql:856 ; Doc/verify/SSP0014/combo_r
- V-0db2d553 [SEARCH] 조회조건 From Site | [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=PLANT) 행이 ['DIVISION_ID'] 같음 — 원천 분기가 보조 테이블 ['STRING_SPLIT'] 도 조건으로 봄(자동 대조 불가)
- V-62f2170d [SEARCH] 조회조건 Operation group | [화면 초기(선택 Div=40)] TO-BE 표시값 1건을 AS-IS 코드로 환산 못 함(표현 NAME) 예: ['?Warranty'] · AS-IS만 ['W'] · AS-IS 화면 하드코딩 항목 ['W:Warrnaty @SSP0014_ShipmentModelPIC.cs:183'] · AS-IS만 1 ['W'] · TO-BE만 1 ['?Warranty'] · 원천 SSP_BIGFILTER O

### 미분류 · 규칙 F1 · 1행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완 · AI 판정 검토: 검사기오판 — tools/E2E 컬럼별 저장 왕복 시험이 User ID가 비어 있는 행이나 사용자 검사를 통과하지 못하는 행을 대상으로 골랐고, 'guoxiaoliangX'·'1'처럼 등록되지 않은 값을 넣었습니다. 대상 행과 넣을 값을 모두 사용자 검사를 통과하는 것으로 골라야 합니다. / 편집 가능 9개 컬럼이 모두 저장 요청 전에 막혔습니다. USER_ID·PART_LEADER·TEAM_LEADER·VALID_YN 시험은 20번 행의 기존 Team Leader 'guoxiaoliang'이 사용자 검사에 걸렸고, MAIL_USER1~5 시험은 User ID가 빈 0번 행을 골라 필수값 검사에 걸렸습니다. AS-IS도 같은 두 검사에서 저장을 중단하므로, 재지 못한 행으로 보고 결과를 그대로 둡니다. / 근거 GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:393 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:444 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/hook
- V-9bcbf1f5 [RULE_SCREEN] SSP0014 컬럼별 저장 왕복 | 편집 가능 9컬럼 중 왕복 9 · 입력 경로 실패 0 · 변경 인식 실패 0 · 업무 검증 차단·사유 불명 9 · 값 불일치 0 — USER_ID r20 'njzhoumengwei'→'luping' 저장 요청 없음(업무 검증 차단) · 화면 메시지 'SSP Planner 권한이 없는 사용자 입니다 . User ID : guoxiaoliang' / PART_LEADER r20 'njzhoume

## 담당 판단 (2행)

### 판단 · 규칙 A2 · 1행
- 처리: TO-BE 룰 원장(Doc/verify/_tobe_rule_registry.md)·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-16ab0403 [RULE_SCREEN] SSP0014 콤보 칸 이름 표시 | [확인 대상] 콤보 칸 3개 중 후보에 없는 코드가 그대로 보이는 칸 1개: FROM_SITE 25행(CN003256_40-A) — 비활성 코드 여부 확인

### 판단 · 규칙 N1 · 1행
- 처리: TO-BE 룰 원장(Doc/verify/_tobe_rule_registry.md)·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- EG-942cf54f [RULE_SCREEN] SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM | [확인 대상] SCM_MST_SITE_ITEM AS-IS 키 127575건 중 24건 TO-BE 에 없음: 82//ST00-P/EP096636PFBAD0D2, 82//ST00-P/EP096636PFBAD0D3, 82//ST00-P/EP096636PFBAD1D2, 82//ST00-P/EP096636PFBAD1D3, 82//ST00-P/EP096636PFBAD2D2

## 담당 사람 (2행)

### 계정 · 규칙 A1 · 1행
- 처리: 시험 계정 지정 필요(tools/E2E/users.json · 비밀번호는 사용자가 입력)
- EG-29c0f2b6 [RULE_SCREEN] SSP0014 실전송 건수 main|같은 사용자 | [측정 경로 없음] AS-IS 0행 · 양쪽 Measure 칸 설정이 있는 사용자 없음

### 스냅샷승인 · 규칙 K4 · 1행
- 처리: snap_validate.py 로 AS-IS 기대 대조 결과를 붙여 사용자 승인(snap_approve.py) 요청
- V-3bb51520 [RULE_SCREEN] SSP0014 스냅샷 버튼 Div 40 | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SSP0014\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(9줄) · 보이는 버튼 KOR,이 이민용,Home,SSP Model PIC,Scroll tabs left,

## 담당 집계 (30행)

### 집계 · 규칙 A6 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-ee384c11 [TRACE] ProgressForm(FindData/SaveData) · 2 | 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 A6 2요소: ERROR:1 · PASS:1

### 집계 · 규칙 B4 · 16행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-16ec539a [GENERAL] [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0db2d553] 조회조건 From Site: [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=
- V-1f760440 [GENERAL] [SCP0007 결함 유형] To Site 조회조건 콤보 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0db2d553] 조회조건 From Site: [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=
- V-2706fcf0 [GENERAL] [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0db2d553] 조회조건 From Site: [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=
- 외 13행(unverified_triage.csv)

### 집계 · 규칙 B5 · 6행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-27adb9e0 [GENERAL] [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 규칙 B5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0db2d553] 조회조건 From Site: [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=
- V-62e28995 [GENERAL] [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-62f2170d] 조회조건 Operation group: [화면 초기(선택 Div=40)] TO-BE 표시값 1건을 AS-IS 코드로 환산 못 함(표현 NAME) 예: ['?Warranty'] · AS-IS만 ['W'] · AS-IS 화면 하드코딩 항목 ['W:Warrnaty @SSP0014_Shipment
- V-81abf761 [GENERAL] [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0db2d553] 조회조건 From Site: [화면 초기(선택 Div=40)] AS-IS 30건 vs TO-BE 32건 · 마스터(SCM_MST_SITE) 행으로 설명 안 되는 차이 1건: AZ00-A: 조건 차이 의심 — 두 DB SCM_MST_SITE(VALID_YN=Y, SITE_TYPE=
- 외 3행(unverified_triage.csv)

### 집계 · 규칙 F4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-f5883fbb [TRACE] ProgressForm(FindData/SaveData) · 2 | 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 F4 4요소: PASS:3 · ERROR:1

### 집계 · 규칙 N1 · 4행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-855bbce3 [GENERAL] [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | 규칙 N1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-942cf54f] SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM: [확인 대상] SCM_MST_SITE_ITEM AS-IS 키 127575건 중 24건 TO-BE 에 없음: 82//ST00-P/EP096636PFBAD0D2, 82//ST00-P/EP096636PFBAD0D3, 82//ST00-P/
- V-9fb98d50 [GENERAL] [DMF0004 결함 유형] Sales Site 조회조건 표시값 | 규칙 N1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-942cf54f] SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM: [확인 대상] SCM_MST_SITE_ITEM AS-IS 키 127575건 중 24건 TO-BE 에 없음: 82//ST00-P/EP096636PFBAD0D2, 82//ST00-P/EP096636PFBAD0D3, 82//ST00-P/
- V-d568b36b [GENERAL] [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | 규칙 N1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-942cf54f] SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM: [확인 대상] SCM_MST_SITE_ITEM AS-IS 키 127575건 중 24건 TO-BE 에 없음: 82//ST00-P/EP096636PFBAD0D2, 82//ST00-P/EP096636PFBAD0D3, 82//ST00-P/
- 외 1행(unverified_triage.csv)

### 집계 · 규칙 X-ROW · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-3487b794 [TRACE] SSP0014_ShipmentModelPIC.SaveData | 진입점 집계 16검사 — PASS:14 · ERROR:1 · NA:1
- T-52ac04a0 [TRACE] SSP0014_ShipmentModelPIC.btnItemId_Click | 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1

