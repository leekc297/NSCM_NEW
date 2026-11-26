# SSP0014 AI 판정 검토 (2026-11-25 02:17:19)

- 대상 220행: 검토 58 · 검토 제외 162 · 미검토 0
- 인용 확인 58행 · 판정 반영 28행 · 엔진 보완 대상 29행 · 룰 등록 후보 0행
- 호출 4회(캐시 0) · 실패 0회 · 비용 2.7881 USD · 출처 Doc/verify/SSP0014/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-244ceb9e | F6 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | USER_ID 를 luping 으로 바꿔 저장하자 1건이 저장됐고, 재조회에서 수정값이 그대로 보였습니다. USER_NAME 은 USER_ID 로 사용자 정보를 조인해 가져오는 칸이라 AS-IS 에서도 함께 바뀌는데, 검사기가 이 변화 때문에 행을 다시 찾지 못해 원복을 건너뛰었습니다(T39). 'njlilian' 저장 차단은 AS-IS 의 저장 전 사용자 확인(GetUserIDChk)과 같은 동작입니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15387 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/E2E: 행 다시 찾기(findRowNear)에서 USER_ID 를 조인해 가져오는 이름 칸(USER_NAME·PART_LEADER_NAME·TEAM_LEADER_NAME)을 식별 키에서 빼지 않아 원복할 행을 찾지 못했습니다. |
| V-16ab0403 | A2 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 사이트 원장을 VALID_YN 조건 없이 조인합니다. FROM_SITE 콤보 후보 PlantSiteByDivision 은 VALID_YN='Y' 사이트만 내므로 비활성 사이트 행은 AS-IS 에서도 후보에 없습니다. AS-IS 그리드가 CN003256_40-A 처럼 후보에 없는 코드를 코드 그대로 보여 주는지 빈칸으로 보여 주는지는 화면을 띄워야 알 수 있습니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:70 ; Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataLis | tools/E2E 측정이 TO-BE 화면만 보고 AS-IS 사이트 원장의 VALID_YN 과 AS-IS 화면 표시를 대조하지 않아 판정하지 못했습니다. CN003256_40-A 의 AS-IS SCM_MST_SITE VALID_YN 과 AS-IS 화면 표시값을 함께 수집해야 합니다. |
| V-9bcbf1f5 | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-09388b3d | F6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d62e8e18 | H11 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS SaveData 는 저장 시작 때 진행 창(ProgressForm)을 띄우고 끝나면 닫습니다. TO-BE 저장 중 상태(saving)는 그리드 편집 잠금에만 쓰이며, 화면 소스 전체를 Grep 으로 찾아도 로딩 표시를 렌더하는 코드가 없었습니다. 실측에서도 저장 1.5초 지연 동안 로딩 표시가 0회였고 조회 지연 때는 34회였으며, 같은 원인인 SSP0020 이 사용자 판정으로 FAIL 입니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:387 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-504dee98 | F1 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-65af2f69 | F6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-62f2170d | B4 | ERROR | 검사기오판 | PASS | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | AS-IS는 Operation group 콤보에 코드 W를 표시명 'Warrnaty'(오타)로 덧붙이고, TO-BE도 같은 코드 W를 표시명 'Warranty'로 덧붙입니다. 검사기는 표시명이 달라 TO-BE 'Warranty'를 코드 W로 되돌리지 못하고 차이 1건으로 셌습니다. 코드 기준으로 보면 후보 4건이 같습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:184 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify 콤보 대조기가 화면에 하드코딩된 항목을 표시명만으로 짝짓습니다. 하드코딩 항목은 코드로 대조해야 합니다. |
| V-a70af79e | G2 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회조건 User ID(Name)는 입력 문자열 전체를 그대로 LIKE 로 검색하고 콤마로 나누지 않습니다. 콤마로 나누는 조건은 Item ID 쪽에만 있습니다. 'eunjin.choi,njzhoumengwei' 를 넣으면 AS-IS 도 0행이 나오므로 TO-BE 0행은 같은 동작이며, SCP0100·SCP0111 지난 사용자 판정(AS-IS 도 콤마 다중 입력 안 됨)과 같은 원인입니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:315 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:1 | tools/Harness/verify: G2 기대값을 엑셀 조회조건 정리(search_cond.csv)의 '텍스트/다중' 표기만 보고 정해 AS-IS SP 의 LIKE 단일값 조건을 확인하지 않았습니다. |
| V-3809bf77 | G9 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회조건 User ID(Name)는 입력값 하나를 USER_ID·PART_LEADER·TEAM_LEADER 와 그 이름에 LIKE 로 비교할 뿐 콤마로 나누지 않습니다. 따라서 'eunjin.choi,njzhoumengwei' 는 AS-IS 에서도 0행이고, TO-BE 0행은 같은 동작입니다. SCP0100 Cell Group 지난 사용자 판정(AS-IS 도 콤마로 2개 이상 입력 시 조회 안 됨)과 같은 판단입니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:315 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:1 | tools/E2E: G9 콤마 다중 입력 시험이 AS-IS SP 가 콤마로 나누는지(String_Split) 확인하지 않고 LIKE 단일값 조건에도 적용됐습니다. |
| V-ceb0b8e0 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-5b76aa66 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-b877a560 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-853fe327 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-d914f74d | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-bb93253d | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-12db2bb2 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-4aa26436 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-076a035a | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이 허용하지 않습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-44f0058d | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-9fb60038 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-605cd346 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-0d152377 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-d39aabc2 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-e214666a | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-f3bd4268 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 V-076a035a 와 같은 증거] SpdMain_CellDoubleClick 에 있는 UserInfoPopup 호출 8곳(new UserInfoPopup, ShowDialog)은 TO-BE 에서 모두 같은 SsoUserModal 로 열립니다. SsoUserModal 의 버튼이 Close, OK 순서라 CR-005 의 OK → CLOSE 와 반대입니다. No. 컬럼은 있고, 건수 표시가 없는 것은 CR-100 으로 허용되지만 버튼 순서는 CR-100 이  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| V-27dc9413 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-c8cc2ced | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ddcfd35a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3a3d885e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ef01ce6f | G2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e66dace6 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f1b11296 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-51ecd39e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6f218a20 | G2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d1c044ec | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e80b9f38 | N1 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-2a405a48 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-3bb51520 | K4 | ERROR | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| V-808a747c | H6 | FAIL | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| AD-8ab71072 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-b0d16abb | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-02913504 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6ecb42f1 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-a941327e | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1dcb0833 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e6fa68c9 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-33f4bf55 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-5c1b1e33 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-c28d25e0 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-cf851c63 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1c54dac6 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9817fdc1 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-84de4a48 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-8acc9f35 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-885a2b72 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6527bda0 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6fe6b4f5 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-32989d9e | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e71aef68 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-a5f4ccad | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-cd2a3186 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d90ec5be | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-01c50b01 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d509eab4 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f8e5ef43 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-de8df197 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-effc047b | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-61126185 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-de3cb47b | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-49d82fe5 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-798731e5 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9eb7b83f | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f25f3003 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-589f2292 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-a1c0209f | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-174c2ddd | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK는 ORDER BY 없이 SELECT DISTINCT로 등록된 USER_ID만 돌려주며, AS-IS와 TO-BE 모두 결과를 존재 확인에만 쓰고 그리드에 표시하지 않습니다. 공통 2행은 전 컬럼이 일치하고 AS-IS 전용·TO-BE 전용 행은 0행이라 순서 차이는 동작 차이가 아닙니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.sql:22 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify/judge.py 그리드에 표시하지 않는 존재 확인용 SP(USER_CHECK) 결과에도 A6 행 순서 비교를 적용해 순서 DIFF를 판정 행으로 만든다. |
| AD-9121416d | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 3행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-bd7200cb | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 3행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-a7b0a7ab | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1710c6cd | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-40c68570 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-bbb9a397 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-c55e8ba5 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0207067b | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-604a3809 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d98a5b8f | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-3b555fcb | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6dcea621 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-ab66d15b | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2a3611d6 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-92e87cfc | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2dc052ff | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9394466f | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e4fd77c8 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-646a0185 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9970b1d9 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-bfe6d488 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-75def704 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-5fec0e71 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-48f19363 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1b67816c | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-77389ec1 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-279962b4 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK는 ORDER BY 없이 SELECT DISTINCT로 등록된 USER_ID만 돌려주며, AS-IS와 TO-BE 모두 결과를 존재 확인에만 쓰고 그리드에 표시하지 않습니다. 공통 2행은 전 컬럼이 일치하고 AS-IS 전용·TO-BE 전용 행은 0행이라 순서 차이는 동작 차이가 아닙니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.sql:22 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify/judge.py 그리드에 표시하지 않는 존재 확인용 SP(USER_CHECK) 결과에도 A6 행 순서 비교를 적용해 순서 DIFF를 판정 행으로 만든다. |
| AD-a3fc75f7 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 2행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-69aebf72 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 3행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-51993393 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK는 ORDER BY 없이 SELECT DISTINCT로 등록된 USER_ID만 돌려주며, AS-IS와 TO-BE 모두 결과를 존재 확인에만 쓰고 그리드에 표시하지 않습니다. 공통 2행은 전 컬럼이 일치하고 AS-IS 전용·TO-BE 전용 행은 0행이라 순서 차이는 동작 차이가 아닙니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.sql:22 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify/judge.py 그리드에 표시하지 않는 존재 확인용 SP(USER_CHECK) 결과에도 A6 행 순서 비교를 적용해 순서 DIFF를 판정 행으로 만든다. |
| AD-ead84776 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK 결과는 그리드에 표시되지 않고 입력한 사용자가 등록 목록에 있는지 대조하는 데만 쓰입니다. AS-IS SP 에 ORDER BY 가 없고 AS-IS 화면도 USER_ID 로 하나씩 찾으므로 순서가 결과에 영향을 주지 않습니다. 공통 3행이 모두 일치합니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify: A6 행 순서 비교를 그리드에 표시되지 않는 검증용 호출(USER_CHECK 버튼)의 결과셋에도 적용하고 있어 이를 제외해야 합니다. |
| AD-6e79b17e | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-bfadcbd6 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1fcaa759 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-5f7c70da | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-68f1584d | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-1a8b4904 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-82bf5564 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-03813da7 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-8878632d | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 2행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-d88c3c8e | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-981e13f3 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-07e6862e | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-db49eb95 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-00c298eb | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-b784e12c | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-c94e134d | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-abc1ee9e | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0f04adbd | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-dc9300bb | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-8b590fa8 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f1f40f9a | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d5b953c5 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-ae15c161 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-62ca9690 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2fea247f | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-82e4469a | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-628f2c6e | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-4daf7c41 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e290a971 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-2209ed9d | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-92362299 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e4e243e2 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-cbbdf1ce | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-dc5ef9ee | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-73e700aa | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f97db233 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-96ab6b45 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f3260120 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-812bda7a | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e71ffc67 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-9d593d92 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-7306741f | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-d2344784 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-467a8ea9 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-ec30f7b0 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-89dc148f | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-132401f8 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-6fde857b | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-7c842ef2 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-0437c9bc | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK는 ORDER BY 없이 SELECT DISTINCT로 등록된 USER_ID만 돌려주므로 AS-IS 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk와 TO-BE 저장 전 검증은 이 결과를 그리드에 표시하지 않고 입력한 사용자가 목록에 있는지만 확인하므로 순서가 동작에 영향을 주지 않습니다. 공통 2행은 전 컬럼이 일치하고 AS-IS 전용·TO-BE 전용 행은 0행입니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.sql:22 ; Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.s | tools/Harness/verify/judge.py 그리드에 표시하지 않는 존재 확인용 SP(USER_CHECK) 결과에도 A6 행 순서 비교를 적용해 순서 DIFF를 판정 행으로 만든다. |
| AD-c2d21f53 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SSP0014_GET_USER_ID_CHECK 는 SELECT DISTINCT 뒤에 ORDER BY 가 없어서 AS-IS 결과 순서부터 정해져 있지 않습니다. AS-IS GetUserIDChk 와 TO-BE checkUsersRegistered 는 둘 다 이 결과를 그리드에 표시하지 않고, 입력한 사용자 ID 가 결과에 들어 있는지만 확인해 MSG00251 표시 여부를 정합니다. 공통 3행이 전 컬럼에서 일치했고 순서만 달랐으므로 화면 동작은 같습니다 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify 의 A6 차등 정렬 비교가 그리드에 표시되지 않는 저장 전 검증 SP 와 ORDER BY 가 없는 AS-IS SP 에도 공통 행 순서 비교를 적용합니다. |
| AD-c8cb8953 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK 는 저장 전 사용자 등록 여부를 확인하는 SP 로, 결과를 그리드에 표시하지 않고 USER_ID 로 하나씩 찾아 대조만 합니다. AS-IS SP 에도 ORDER BY 가 없고, AS-IS 화면과 TO-BE 화면 모두 결과 순서와 무관하게 판정합니다. 공통 2행의 값이 모두 일치하므로 순서 차이는 동작 차이가 아닙니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15467 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 | tools/Harness/verify: A6 행 순서 비교를 그리드에 표시되지 않는 검증용 호출(USER_CHECK 버튼)의 결과셋에도 적용하고 있어 이를 제외해야 합니다. |
| AD-09b44044 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | SSP0014_GET_USER_ID_CHECK는 ORDER BY 없이 SELECT DISTINCT로 등록된 USER_ID만 돌려주며, AS-IS와 TO-BE 모두 결과를 존재 확인에만 쓰고 그리드에 표시하지 않습니다. 공통 3행은 전 컬럼이 일치하고 AS-IS 전용·TO-BE 전용 행은 0행이라 순서 차이는 동작 차이가 아닙니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_USER_ID_CHECK.sql:22 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c | tools/Harness/verify/judge.py 그리드에 표시하지 않는 존재 확인용 SP(USER_CHECK) 결과에도 A6 행 순서 비교를 적용해 순서 DIFF를 판정 행으로 만든다. |
| AD-1db24f84 | A1 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-f929a7d5 | A7 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-e202d9b9 | A5 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| AD-bdf7f569 | A6 | ERROR | 검토 제외 |  | N | N 재측정 대상(차등짝·엔진) — AI 판정 대상 아님 |  |  |  |
| T-1055a120 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9e13b4a5 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d8a44750 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-287025ff | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2f19f664 | X-REASON | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 조회 직후 전체 컬럼을 잠그고(348행) Edit 버튼의 SwitchLock 으로 잠금을 푼 뒤 DIVISION부터 NICK_NAME까지, USER_NAME, PART_LEADER_NAME, TEAM_LEADER_NAME, CREATED_BY부터 LAST_UPDATE_DATE까지만 다시 잠근다. TO-BE 에서는 CR-093 에 따라 Edit 토글 없이 바로 편집하며, 키·이름·감사 컬럼은 컬럼메타 INPUT_TP_CD='S' 로 계속 잠겨 있어  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:348 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| T-60d21cf6 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8a93b1cd | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d6469639 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-aaaa53b4 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fe7f7f35 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5fd90192 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0413b00a | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-21340deb | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6747828e | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-894a2371 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-75a91fc9 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0e741801 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c0ced903 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-11770b31 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2b875b51 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7b30e883 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b257d015 | A1 | 판정필요 | 확인불가 | 판정필요 | Y | N 판정 같음 | AS-IS 는 Model 돋보기 버튼에서 SCM0002_ItembyDivisionPopup 을 엽니다. TO-BE 는 같은 버튼에 MaterialByDivisionModal(COM0013)을 쓰므로 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 은 이 화면에서 호출되지 않습니다. 이 팝업 교체는 코드 주석의 사용자 지시(2026-10-12)뿐이고 TO-BE 룰 원장에 등록되어 있지 않습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify 대조표(mapping_trace)가 AS-IS 팝업을 TO-BE 의 SCM0002 PROC 에 짝지어 golden 케이스가 없습니다. 실제 호출되는 COM0013 PROC 로 짝을 바꾸고 golden_cases.csv 에 케이스를 추가해야 측정됩니다 |
| T-d1bd8978 | A6 | ERROR | 확인불가 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | AS-IS 화면에 Model 돋보기 버튼의 SCM0002 팝업이 있으므로 정렬 검사 대상이 없다고 할 수 없습니다. TO-BE 는 이 팝업을 MaterialByDivisionModal(COM0013)로 바꿔 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 호출이 0건이라 검사기가 정렬을 재지 못했습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:849 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify sort_check.py 대조표가 AS-IS SCM0002 팝업을 이 화면에서 호출되지 않는 SCM0002 PROC 에 짝지었습니다. 실제 호출되는 COM0013 PROC 와 짝짓고 팝업을 연 상태에서 호출 로그를 수집해야 합니다. |
| T-bab6f023 | F4 | ERROR | 검사기오판 | ERROR | Y | N 미검증 행은 NA(대상 없음 근거)만 반영 | AS-IS Model 돋보기 버튼은 SCM0002 팝업(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)을 엽니다. TO-BE는 사용자 지시(2026-10-12)로 공용 MaterialByDivisionModal(COM0013)로 바꿨기 때문에 SSP0014 화면에서는 이 패키지를 부르지 않습니다. 검사기는 AS-IS 팝업 기준으로 대상을 정해 호출을 잡지 못했고, AS-IS에는 대상이 있으므로 NA로 낮추지 않고 결과를  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S | tools/Harness/verify의 트레이스 대응표가 AS-IS 팝업의 SP를 그대로 대상으로 잡아, TO-BE가 바꾼 팝업(COM0013)의 SP를 재지 못했습니다. FE __asis-mapping__.md에 적힌 교체 결과를 반영해 대상을 다시 정해야 합니다. |
| T-a6a56d4a | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-f5883fbb | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7daf288c | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ee384c11 | A6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-dd415f52 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-36645aa0 | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-acae747f | A1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7e9aebc2 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-3487b794 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a910edb5 | DB-SYN | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-53af8cd8 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-52ac04a0 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-2ed0d75b | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정하고 있어 이 차이를 허용하는 룰이 없습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-c788094d | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | User ID 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아니며, SSP0025 USER_ID 팝업 건수도 같은 사용자 판정을 받았습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:631 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-fc6d04ac | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-1250673f | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-08be1b0d 와 같은 증거] Mail User2·Part Leader·Mail User1 셀의 UserInfoPopup 은 TO-BE 에서 공용 SsoUserModal 로 열리고, 이 모달은 그리드를 건수 표시 영역 없이 그립니다. CR-100 은 UserInfoPopup 의 모든 호출 셀에서 조회 건수가 없는 것을 TO-BE 팝업 룰로 정했고, SSP0025 의 같은 건수 지적도 사용자가 오류 아님으로 판정했습니다. 필터 후 건수도 같은 건수  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-dff23bec | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-79684cf4 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Team Leader 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아니며, SSP0025 TEAM_LEADER 팝업 건수도 같은 사용자 판정을 받았습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:681 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-44a30740 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-4543f990 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | [대표 EG-08be1b0d 와 같은 증거] Mail User2·Part Leader·Mail User1 셀의 UserInfoPopup 은 TO-BE 에서 공용 SsoUserModal 로 열리고, 이 모달은 그리드를 건수 표시 영역 없이 그립니다. CR-100 은 UserInfoPopup 의 모든 호출 셀에서 조회 건수가 없는 것을 TO-BE 팝업 룰로 정했고, SSP0025 의 같은 건수 지적도 사용자가 오류 아님으로 판정했습니다. 필터 후 건수도 같은 건수  | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-4b9ecb8b | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-08be1b0d | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User2·Part Leader·Mail User1 셀의 UserInfoPopup 은 TO-BE 에서 공용 SsoUserModal 로 열리고, 이 모달은 그리드를 건수 표시 영역 없이 그립니다. CR-100 은 UserInfoPopup 의 모든 호출 셀에서 조회 건수가 없는 것을 TO-BE 팝업 룰로 정했고, SSP0025 의 같은 건수 지적도 사용자가 오류 아님으로 판정했습니다. 필터 후 건수도 같은 건수 표시 영역 문제라 같은 룰로 봅니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:733 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-4129ef6d | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-e3289c95 | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User3 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아닙니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:756 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-f7021f11 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | [대표 EG-2ed0d75b 와 같은 증거] AS-IS 에서는 User ID·Part Leader·Team Leader·Mail User1~5 셀을 더블클릭하면 UserInfoPopup 이 열리고, TO-BE 에서는 그 자리에 공용 SsoUserModal 이 열립니다. SsoUserModal 은 Close 버튼을 먼저, OK 버튼을 나중에 그려서 확정 규칙 CR-005 의 OK → CLOSE 순서와 반대입니다. CR-100 도 버튼 순서는 종전대로 검사한다고 정 | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:633 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-ad2cc9ff | K1 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | Mail User5 칸을 더블클릭하면 AS-IS 와 같이 사용자 팝업(UserInfoPopup, TO-BE SsoUserModal)이 열립니다. 필터 동작은 정상이고, 비어 있던 것은 건수 문구뿐입니다. 메타 공통 셀 팝업에 건수 표시가 없는 것은 CR-100 에 따라 결함이 아닙니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:806 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-dc100d71 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | 조회조건 Model 돋보기 버튼은 AS-IS 에서 SCM0002_ItembyDivisionPopup 을 열고, TO-BE 에서는 공용 MaterialByDivisionModal 을 엽니다. MaterialByDivisionModal 은 Close 버튼 다음에 OK 버튼을 그려서 CR-005 의 OK → CLOSE 순서와 반대입니다. 이 팝업은 조회조건 팝업이라 CR-100 대상이 아니고, 버튼 순서를 허용하는 다른 룰도 없습니다. | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:847 ; nscm-fe/features/shipping/src/pages/shipment-model-pic/S |  |
| EG-780f38de | G4 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Model 팝업의 Division·Site·Project 칸은 호출 화면이 넘긴 값을 보여 주기만 하는 비활성 칸이고, Project 에는 늘 빈 값이 넘어간다. TO-BE 는 이 팝업을 공용 MaterialByDivisionModal(COM0013, 조회조건 Div·Operation Group·Material)로 바꿨고, SCM_SITE_ID 필터 같은 AS-IS 호출 인자를 빼는 것은 CR-096 에 등록된 차이다. 사용자가 입력하는 칸은 Mode | GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.cs:844 ; GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0014_ShipmentModelPIC.c |  |
| EG-29c0f2b6 | A1 | ERROR | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 · 대상 없음(미검증 → NA) | AS-IS 조회 SP 의 p_user_id 는 로그인 사용자가 아니라 User ID(Name) 조회조건 입력값을 USER_ID·PART_LEADER·TEAM_LEADER 와 이름에 LIKE 로 비교하는 검색어입니다. 이 화면에는 사용자별 Measure 칸 설정이 없어 같은 사용자 재실행 대상이 아닙니다. 건수 대조는 주 행 EG-9f85ff95 가 맡습니다. | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:23 ; Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_M | tools/Harness/verify/a1_live.py same_user_rows 183줄이 인자 이름에 user_id 가 들어 있으면 사용자 인자로 보아, 검색어 인자 p_user_id 를 로그인 사용자 칸으로 오인했습니다. SP 본문에서 SCM_MST_TITLESET_USER 참조 |
| EG-9f85ff95 | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회 행은 품목-사이트 마스터(SCM_MST_SITE_ITEM)와 담당자 테이블(SSP_MST_MODEL_USER) 데이터로 정해지며, 조회 결과는 AS-IS 7667행, TO-BE 7710행입니다. 키 차이는 AS-IS 전용 23행, TO-BE 전용 66행이고 공통 행 7644칸에서 값이 다른 컬럼은 0개입니다. CR-105에 따라 행·키 집합 차이는 판정에서 빼므로 해당없음으로 둡니다. TO-BE 패키지 원문은 To-be_v2_converted/0 | Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:69 ; Doc/asisfacts/db/modules/dbo.SSP0014_GET_SHIPMENT_M |  |
| EG-942cf54f | N1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP SSP0014_GET_SHIPMENT_MODEL_PIC 은 SCM_MST_SITE_ITEM 을 기준으로 행을 만들기 때문에 이 표의 키가 빠지면 조회 건수가 달라집니다. AS-IS 키 127575건 가운데 161건이 TO-BE 에 없고, 예시 키는 AJ상사_AB_TES, ALTE_AB_TES 처럼 시험용 사이트 이름입니다. 로직 차이가 아니라 이관된 기준 데이터의 차이라서, 161건을 이관 대상에서 일부러 뺐는지 데이터 담당자 확인이 필요합 | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15420 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP9_DDL.sql:15 |  |
