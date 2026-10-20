# SCP0096 — Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 엔드포인트 | 호출 위치 | 참조 테이블 | EXEC 체인 / 특이 구문 |
|---|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:394 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | 단독 |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:831 (Load / 조회 / 저장 후 재조회) | SCM_SYS_CALENDAR_M (SELECT) | 단독 |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main:457 (조회 / 저장 후 재조회) | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT (SELECT) | INSERT `#TBLDYNAMICPIVOT_SCP0096`(임시테이블), `STRING_SPLIT`, 동적 SQL(DYNAMIC) |

주석 처리됨: `SCP0019_GET_WORKING_TIME`(:456) — 전환 대상이 아닙니다.

## 2. 공통코드 분기

| 엔드포인트 | code | 처리 | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | — | Data.CallBizData | 참조 테이블 없음 (고정값 여부 확인 필요) |

- LookupCommon 의 실제 LOOKUP 코드값은 확인 필요합니다.

## 3. FoxQuery 미등록 / 직접호출 SP

- 조회 계열 3개 SP는 모두 FoxQuery 상태가 **MATCH**입니다.
- 미등록·직접호출 SP는 Fact Pack에 없습니다.
- **저장 SP는 추출되지 않았습니다** — SaveData_Main 이 만드는 파라미터 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default` 를 받는 SP를 AS-IS 원문에서 확인해야 합니다(확인 필요).

## 4. Oracle 전환 확인 포인트

| # | 대상 | 포인트 | 근거 |
|---|---|---|---|
| 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `STRING_SPLIT`(MSSQL 전용) → Oracle 대체 필요(멀티선택 Plant Site 등 분해) | REF:STRING_SPLIT |
| 2 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `#TBLDYNAMICPIVOT_SCP0096` 로컬 임시테이블 → GTT 또는 대체 구조 | INSERT:#TBLDYNAMICPIVOT_SCP0096 |
| 3 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 동적 SQL(PIVOT 추정) → EXECUTE IMMEDIATE / OPEN FOR, 결과 컬럼명이 SCP0009 COLUMN_NAME(D_/W_/M_/B_ 접두어)과 일치해야 함 | DYNAMIC@, 코드 태그 비교 :350/:355/:196 |
| 4 | SCP0009_GET_SHEET_CALENDAR_3SPAN | 결과 컬럼 COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME 계약 유지. 코드가 `Rows[0][2]` 처럼 위치 인덱스로도 접근함 → 컬럼 순서 유지 필요 | InitSpreadDateColumn, grid_code :215 |
| 5 | DM0003_GET_BUCKET_TYPE_CODE | 단순 SELECT | — |
| 6 | 저장 SP | 미추출 — 원문 확보 후 변환 | 확인 필요 |

난이도 (사실 기준):
- **DM0003 / SCP0009: 낮음** — 단일 테이블 SELECT.
- **SCP0096: 높음** — 임시테이블, STRING_SPLIT, 동적 SQL, 5개 테이블 참조가 함께 있음.
- **저장 SP: 판단 불가** — 미추출.
