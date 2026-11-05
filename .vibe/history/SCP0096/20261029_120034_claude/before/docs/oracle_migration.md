# SCP0096 — Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 엔드포인트 | 호출 경로 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | Form_Load > InitControls > GetBucketType (394) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL | EXEC:DM0003_GET_BUCKET_TYPE_CODE (자기 자신, 하위 EXEC 없음) |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | InitSpread > GetSpdTitle (831) — Load / Find / Save 후 재조회 | SELECT: SCM_SYS_CALENDAR_M | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN (하위 EXEC 없음) |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main (457) — Find / Save 후 재조회 | INSERT: #TBLDYNAMICPIVOT_SCP0096 / SELECT: SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT / REF: STRING_SPLIT / DYNAMIC SQL | EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |

### 1-1. 참조 테이블 집계

| 테이블 | 사용 SP |
|---|---|
| SCM_ADM_LOOKUP_MASTER_DETAIL | DM0003_GET_BUCKET_TYPE_CODE, UP_FX_GetCommonDataList |
| SCM_ADM_LOOKUP_MASTER | UP_FX_GetCommonDataList |
| SCM_SYS_CALENDAR_M | SCP0009_GET_SHEET_CALENDAR_3SPAN, SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCP_MST_SHIPMENT_WORKING_DAY_OSP | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCM_MST_SITE | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCM_MST_LINE_OSP | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| #TBLDYNAMICPIVOT_SCP0096 (임시 테이블) | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |

## 2. 공통코드 분기

| 엔드포인트 | 코드 분기 | 경로 | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | code=LookupCommon | `Data.Common[case Type.LookupCommon] > Data.CallBizCommonData` → UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | code=YesOrNo | `Data.Common[case Type.YesOrNo] > Data.CallBizData` | 참조 테이블 없음(DB 미조회로 추출됨) — 값 목록 확인 필요 |

- LookupCommon 호출에 넘기는 Lookup 그룹 키(어떤 MASTER 코드인지)는 Fact Pack에 없습니다 → 확인 필요.
- YesOrNo 목록은 날짜 Combo 셀의 데이터(`dtValidYN`, grid_code 203)로 쓰입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| 구분 | 내용 |
|---|---|
| FoxQuery 미등록 | 없음 — fox 엔드포인트 3건이 모두 MATCH |
| 직접 SQL / 직접 호출 | 추출되지 않음 |
| **저장 SP** | **미검출.** SaveData_Main(558~609)이 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default`를 구성하지만 호출 SP는 추출되지 않음 → 확인 필요 |
| 주석 처리됨 | SCP.SCP0019_GET_WORKING_TIME (456) — 주석 처리됨, 전환 대상 아님 |

## 4. Oracle 전환 확인 포인트

| SP | 확인 포인트 (Fact 근거) | 난이도 |
|---|---|---|
| SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | ① `REF:STRING_SPLIT` — MSSQL 전용 함수라 Oracle 대체 구현 필요 ② `INSERT:#TBLDYNAMICPIVOT_SCP0096` — 로컬 임시 테이블이라 GTT 등 대체 필요 ③ `DYNAMIC@` — 동적 SQL(테이블명으로 보아 동적 PIVOT)이라 실행 문자열 전체를 변환 대상으로 다뤄야 함 ④ 참조 테이블 5개 + 캘린더 조인 | **높음** (MSSQL 전용 함수 + 임시 테이블 + 동적 SQL 3요소가 Fact로 확인됨) |
| SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M 단일 SELECT. 결과 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME)이 Grid 헤더 계약이므로 컬럼명과 순서를 유지해야 함 | 낮음 (참조 객체 기준. SP 본문은 Fact Pack에 없음) |
| DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL 단일 SELECT | 낮음 (참조 객체 기준) |
| 저장 SP (미검출) | 대상 테이블이 SCP_MST_SHIPMENT_WORKING_DAY_OSP / _DEFAULT인지 확인 필요(`p_is_save_defalut`, `p_working_time_default` 파라미터 존재) | 판단 불가 |

### 4-1. 공통 주의
- SP 본문은 Fact Pack에 없습니다. 위 내용은 참조 객체 추출 결과만 근거로 합니다. 전환 작업 전에 원문 SP를 최신으로 다시 조회해야 합니다.
- 날짜 컬럼 COLUMN_NAME 접두어(`D_`, `W_`, `M_`) 및 `B_` 포함 규칙이 FE 표시 로직과 맞물려 있으므로, SCP0096 GET SP의 동적 PIVOT 결과 컬럼명 규칙을 Oracle에서도 그대로 유지해야 합니다.
