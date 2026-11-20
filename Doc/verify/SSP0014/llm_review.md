# SSP0014 AI 판정 검토 (2026-11-20 09:47:43)

- 대상 84행: 검토 26 · 검토 제외 58 · 미검토 0
- 인용 확인 26행 · 판정 반영 11행 · 엔진 보완 대상 16행 · 룰 등록 후보 0행
- 호출 5회(캐시 0) · 실패 0회 · 비용 4.9494 USD · 출처 Doc/verify/SSP0014/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-16ab0403 | A2 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS 조회 SP 는 사이트 원장을 VALID_YN 조건 없이 조인합니다. FROM_SITE 콤보 후보 PlantSiteByDivision 은 VALID_YN='Y' 사이트만 내므로 비활성 사이트 행은 AS-IS 에서도 후보에 없습니다. AS-IS 그리드가 CN003256_40-A 처럼 후보에 없는 코드를 코드 그대로 보여 주는지 빈칸으로 보여 주는지는 화면을 띄워야 알 수 있습니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:70 ; Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataLis | tools/E2E 측정이 TO-BE 화면만 보고 AS-IS 사이트 원장의 VALID_YN 과 AS-IS 화면 표시를 대조하지 않아 판정하지 못했습니다. CN003256_40-A 의 AS-IS SCM_MST_SITE VALID_YN 과 AS-IS 화면 표시값을 함께 수집해야 합니다. |
| V-9bcbf1f5 | F1 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | 편집 가능 9개 컬럼이 모두 저장 요청 전에 막혔습니다. USER_ID·PART_LEADER·TEAM_LEADER·VALID_YN 시험은 20번 행의 기존 Team Leader 'guoxiaoliang'이 사용자 검사에 걸렸고, MAIL_USER1~5 시험은 User ID가 빈 0번 행을 골라 필수값 검사에 걸렸습니다. AS-IS도 같은 두 검사에서 저장을 중단하므로, 재지 못한 행으로 보고 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:393 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/E2E 컬럼별 저장 왕복 시험이 User ID가 비어 있는 행이나 사용자 검사를 통과하지 못하는 행을 대상으로 골랐고, 'guoxiaoliangX'·'1'처럼 등록되지 않은 값을 넣었습니다. 대상 행과 넣을 값을 모두 사용자 검사를 통과하는 것으로 골라야 합니다. |
| V-5473aa5a | F1 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | 20번 행의 기존 Team Leader 'guoxiaoliang'이 저장 전 사용자 검사에 걸려 저장 요청이 서버로 나가지 않았습니다. 그래서 서버 실패 응답을 강제할 지점까지 가지 못했습니다. AS-IS도 같은 검사에서 저장을 중단하므로 화면 결함이 아니고, 재지 못한 행이라 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:448 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/E2E 저장 실패 시험이 사용자 검사를 통과하는 행과 값을 고르지 않아 실패 응답을 강제하기 전에 막혔습니다. 시험 행 선택 조건에 사용자 검사 통과를 넣어야 합니다. |
| V-d62e8e18 | H11 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS SaveData 는 저장 시작 때 진행 창(ProgressForm)을 띄우고 끝나면 닫는다. TO-BE 는 저장 중 saving 상태로 그리드만 잠그고, ShipmentModelPic.tsx 를 Loading·Spinner·ProgressIndicator 로 찾아도 로딩 표시가 없었다. 저장 응답을 1.5초 늦춘 실측에서도 로딩 표시가 0회였으며, AS-IS 진행 창이 같은 구조인 SSP0020 을 사용자가 오류로 판정한 것과 같은 경우다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:391 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-9041b5eb | L1 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS 에 Save 버튼 저장 기능이 있으므로 대상이 없다는 근거는 없습니다. 저장 세부 시험에서 저장 요청 소요가 하나도 기록되지 않아 3초 기준을 재지 못했습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:283 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/E2E/lib/saveprobe.ts 저장 소요 기록이 0건이라 tools/E2E/lib/savecheck.ts judgeSaveTime 이 ERROR 를 냈습니다. 미검증 계획은 이 행을 사용자 ID 확인(USER_CHECK) 차단 묶음으로 분류했지만, 저장 요청이 실제로  |
| V-504dee98 | F1 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS와 TO-BE 모두 저장 전에 수정한 행의 User ID·Part Leader·Team Leader 값을 사용자 검사 SP로 확인하고, 통과하지 못하면 저장하지 않습니다. 시험 행에 원래 들어 있던 guoxiaoliang·lgsilee·kwonl이 TO-BE DB에서 SSP Planner 그룹 검사를 통과하지 못해 저장 요청이 나가지 않았습니다. 저장 왕복을 재지 못했으므로 결과를 그대로 둡니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:441 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/E2E 저장 시험이 행을 고를 때, 그 행의 User ID·Part Leader·Team Leader·Mail User 값이 모두 SSP0014_GET_USER_ID_CHECK를 통과하는 행만 골라야 합니다. 지금은 업무 검증에 막힐 행을 시험 대상으로 썼습니다. |
| V-62f2170d | B4 | ERROR | 검사기오판 | PASS | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS는 Operation group 콤보에 코드 W를 표시명 'Warrnaty'(오타)로 덧붙이고, TO-BE도 같은 코드 W를 표시명 'Warranty'로 덧붙입니다. 검사기는 표시명이 달라 TO-BE 'Warranty'를 코드 W로 되돌리지 못하고 차이 1건으로 셌습니다. 코드 기준으로 보면 후보 4건이 같습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:184 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify 콤보 대조기가 화면에 하드코딩된 항목을 표시명만으로 짝짓습니다. 하드코딩 항목은 코드로 대조해야 합니다. |
| V-c951c278 | B2 | FAIL | 데이터차이 | 판정필요 | Y | Y 데이터 차이 — 판정필요(CR-101) | AS-IS 와 TO-BE 모두 From Site 후보를 사이트 원장의 PLANT·유효 행을 Division 으로 걸러 만들며 조회 로직은 같습니다. Div 40 에서 AS-IS 는 'AZ Mobile Assy-Cell' 1건, TO-BE 는 AC00-A·AT00-A·AZ00-A 3건으로, TO-BE 사이트 원장에 같은 이름의 유효 행이 더 있어 생긴 차이입니다. SSP0025 에서 같은 원인(AC00-A TEST 생성 행)으로 사용자가 직접 NA 판정한 선례가  | Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataList_SCP.sql:858 ; Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataList_ |  |
| V-0db2d553 | B4 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | TO-BE From Site 응답에는 AZ00-A 코드가 있습니다. AC00-A·AT00-A·AZ00-A 세 코드가 같은 이름 'AZ Mobile Assy-Cell'을 써서 검사기가 이름을 코드로 되돌릴 때 AZ00-A를 AC00-A로 잘못 짝지었습니다. 남은 차이 가운데 AS-IS SP가 직접 넣는 '-' 항목은 데이터 차이가 아니라 TO-BE에 없는 항목입니다. TO-BE 콤보 SQL 원문을 찾지 못했고 DB_DDL 폴더도 저장소에 없어 '-' 항목만 사용자 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:202 ; Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataList_SCP | tools/Harness/verify 콤보 대조기가 이름이 겹치는 후보를 코드로 되돌릴 때 첫 코드만 골라 잘못 짝짓습니다. 응답의 CODE로 대조하고, SP에 하드코딩된 행('-')은 데이터 차이가 아니라 원천 로직으로 분류해야 합니다. |
| V-a70af79e | G2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3809bf77 | G9 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회 SP 는 User ID(Name) 입력값을 콤마로 나누지 않고 문자열 전체로 LIKE 검색하므로, 'junha.hwang,njzhoumengwei' 를 넣으면 AS-IS 에서도 0행이 나온다. TO-BE 도 같은 방식(P_USER_ID LIKE)이라 동작이 같다. AS-IS 도 콤마 다중 입력이 안 된다고 본 SCP0100·SCP0111 사용자 판정과 같은 경우다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15437 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs | tools/Harness/verify 의 G9 판정에서 CR-040 을 적용하기 전에, AS-IS SP 가 그 조건을 String_Split 으로 나누는지 확인하지 않아 LIKE 단일값 조건도 FAIL 로 기록했다. |
| V-effdd7ff | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-788e51ee | B2 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-cc87e246 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a597cfb4 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-4357d45f | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-648cd5dc | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-830447ce | B2 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2706fcf0 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-225a8aab | B2 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c5df375e | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-81abf761 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-855bbce3 | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-9fb98d50 | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-748c1535 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ef01ce6f | G2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-a188b35d | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-fb724ddb | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-5c379423 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d568b36b | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-27adb9e0 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d5f17c5c | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ab4a5428 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6f218a20 | G2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-62e28995 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-1f760440 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-710f745f | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-16ec539a | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-98497859 | B5 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e80b9f38 | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-31bac514 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0a7c8441 | B2 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f4554768 | B4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3bb51520 | K4 | ERROR | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| T-1055a120 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9e13b4a5 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d8a44750 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2f19f664 | X-REASON | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 조회 직후 전체 컬럼을 잠그고(348행) Edit 버튼의 SwitchLock 으로 잠금을 푼 뒤 DIVISION부터 NICK_NAME까지, USER_NAME, PART_LEADER_NAME, TEAM_LEADER_NAME, CREATED_BY부터 LAST_UPDATE_DATE까지만 다시 잠근다. TO-BE 에서는 CR-093 에 따라 Edit 토글 없이 바로 편집하며, 키·이름·감사 컬럼은 컬럼메타 INPUT_TP_CD='S' 로 계속 잠겨 있어  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:348 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| T-60d21cf6 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-aaaa53b4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fe7f7f35 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5fd90192 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0413b00a | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-21340deb | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-894a2371 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-75a91fc9 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0e741801 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c0ced903 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-11770b31 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2b875b51 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7b30e883 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b257d015 | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Model 돋보기 버튼에서 SCM0002_ItembyDivisionPopup 을 엽니다. TO-BE 는 같은 버튼에 MaterialByDivisionModal(COM0013)을 쓰므로 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 은 이 화면에서 호출되지 않습니다. 이 팝업 교체는 코드 주석의 사용자 지시(2026-10-12)뿐이고 TO-BE 룰 원장에 등록되어 있지 않습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify 대조표(mapping_trace)가 AS-IS 팝업을 TO-BE 의 SCM0002 PROC 에 짝지어 golden 케이스가 없습니다. 실제 호출되는 COM0013 PROC 로 짝을 바꾸고 golden_cases.csv 에 케이스를 추가해야 측정됩니다 |
| T-d1bd8978 | A6 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS 화면에 Model 돋보기 버튼의 SCM0002 팝업이 있으므로 정렬 검사 대상이 없다고 할 수 없습니다. TO-BE 는 이 팝업을 MaterialByDivisionModal(COM0013)로 바꿔 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 호출이 0건이라 검사기가 정렬을 재지 못했습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:849 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify sort_check.py 대조표가 AS-IS SCM0002 팝업을 이 화면에서 호출되지 않는 SCM0002 PROC 에 짝지었습니다. 실제 호출되는 COM0013 PROC 와 짝짓고 팝업을 연 상태에서 호출 로그를 수집해야 합니다. |
| T-bab6f023 | F4 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS Model 돋보기 버튼은 SCM0002 팝업(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)을 엽니다. TO-BE는 사용자 지시(2026-10-12)로 공용 MaterialByDivisionModal(COM0013)로 바꿨기 때문에 SSP0014 화면에서는 이 패키지를 부르지 않습니다. 검사기는 AS-IS 팝업 기준으로 대상을 정해 호출을 잡지 못했고, AS-IS에는 대상이 있으므로 NA로 낮추지 않고 결과를  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify의 트레이스 대응표가 AS-IS 팝업의 SP를 그대로 대상으로 잡아, TO-BE가 바꾼 팝업(COM0013)의 SP를 재지 못했습니다. FE __asis-mapping__.md에 적힌 교체 결과를 반영해 대상을 다시 정해야 합니다. |
| T-f5883fbb | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7daf288c | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ee384c11 | A6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dd415f52 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-36645aa0 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-acae747f | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3487b794 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-52ac04a0 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-c788094d | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | User ID 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아니며, SSP0025 USER_ID 팝업 건수도 같은 사용자 판정을 받았습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:631 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-1250673f | K1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | PART_LEADER 셀이 여는 사용자 팝업(공용 SsoUserModal)은 DataGrid 만 있고 건수 문구를 표시하는 요소가 없다. 실측에서 필터로 8612행이 1행으로 줄었다가 복원됐지만 건수 문구는 빈 값이었다. CR-007 이 요구하는 팝업 그리드 필터 건수 표시가 빠졌고, MAIL_USER2 행과 같은 원인이다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:658 ; nscm-fe/packages/shared/src/components/templates/modals/ |  |
| EG-79684cf4 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Team Leader 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아니며, SSP0025 TEAM_LEADER 팝업 건수도 같은 사용자 판정을 받았습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:681 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-4543f990 | K1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | MAIL_USER1 셀이 여는 사용자 팝업(공용 SsoUserModal)은 DataGrid 만 있고 건수 문구를 표시하는 요소가 없다. 실측에서 필터를 적용한 뒤 건수 문구가 빈 값이었다. CR-007 이 요구하는 팝업 그리드 필터 건수 표시가 빠졌고, MAIL_USER2 행과 같은 원인이다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:708 ; nscm-fe/packages/shared/src/components/templates/modals/ |  |
| EG-08be1b0d | K1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | MAIL_USER2 셀이 여는 사용자 팝업(공용 SsoUserModal)은 DataGrid 만 있고 건수 문구를 표시하는 요소가 없다. 실측에서 필터를 적용해 8612행이 1행으로 줄었다가 복원됐지만 건수 문구는 빈 값이었다. CR-007 은 모든 팝업 그리드에 조회·필터 건수를 표시하라고 정하고 있으며, 공용 팝업 하나의 문제라 USER_ID·PART_LEADER·TEAM_LEADER·MAIL_USER1~5 행이 같은 원인이다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; nscm-fe/packages/shared/src/components/templates/modals/ |  |
| EG-e3289c95 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User3 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아닙니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:756 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-7787b986 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User4 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터는 8612행에서 1행으로 줄었다가 해제하면 8612행으로 돌아왔고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아닙니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:781 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-ad2cc9ff | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User5 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아닙니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:806 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-780f38de | G4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Model 팝업의 Division·Site·Project 칸은 호출 화면이 넘긴 값을 보여 주기만 하는 비활성 칸이고, Project 에는 늘 빈 값이 넘어간다. TO-BE 는 이 팝업을 공용 MaterialByDivisionModal(COM0013, 조회조건 Div·Operation Group·Material)로 바꿨고, SCM_SITE_ID 필터 같은 AS-IS 호출 인자를 빼는 것은 CR-096 에 등록된 차이다. 사용자가 입력하는 칸은 Mode | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:844 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-29c0f2b6 | A1 | ERROR | 검사기오판 | NA | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS 조회 SP 의 p_user_id 는 로그인 사용자가 아니라 User ID(Name) 조회조건 입력값을 USER_ID·PART_LEADER·TEAM_LEADER 와 이름에 LIKE 로 비교하는 검색어입니다. 이 화면에는 사용자별 Measure 칸 설정이 없어 같은 사용자 재실행 대상이 아닙니다. 건수 대조는 주 행 EG-9f85ff95 가 맡습니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:23 ; Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_M | tools/Harness/verify/a1_live.py same_user_rows 183줄이 인자 이름에 user_id 가 들어 있으면 사용자 인자로 보아, 검색어 인자 p_user_id 를 로그인 사용자 칸으로 오인했습니다. SP 본문에서 SCM_MST_TITLESET_USER 참조 |
| EG-9f85ff95 | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | Div 40 전체 조회에서 AS-IS 7667행, TO-BE 7671행이고 TO-BE 에만 있는 4행(NJ01-A 등 사용자 미지정 행)은 행·키 집합 차이입니다. CR-105 에 따라 행·키 집합 차이는 판정에서 빼고, 공통 행 상대 순서는 일치합니다. TO-BE 조회는 정상 실행되었습니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:81 ; Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_M |  |
| EG-942cf54f | N1 | ERROR | 데이터차이 | 판정필요 | Y | N 미검증 행은 의견만(판정 반영 안 함) | AS-IS 조회 SP SSP0014_GET_SHIPMENT_MODEL_PIC 는 SCM_MST_SITE_ITEM 을 기준으로 행을 만들기 때문에 이 표의 키가 빠지면 조회 행도 빠진다. AS-IS 키 127,575건 가운데 24건이 TO-BE 에 없으며, 모두 사업부 82 사이트 ST00-P 의 품목(EP096636PFBAD0D2 등)이다. 화면 로직 차이가 아니라 이관 데이터의 차이이므로 이관 담당이 사이트 코드 변경이나 누락 여부를 확인해야 한다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15420 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 |  |
