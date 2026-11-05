# SCP0111 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 유형 | 참조 객체 (EXEC 체인 포함) |
|---|---|---|---|
| `SCP0111_GET_ESS_PACK_LINE` | GetEssPackLineAll:490 (Form_Load) | 조회 | SELECT: SCM_MST_LINE_OSP, SCM_MST_SITE |
| `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:1095 (Form_Load > InitControls) | 조회(공용 DM) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP0111_GET_INTEGRATION_PSI` | FindData_Main:874 (Find / Save 후 재조회) | 조회 | SELECT: SCP_ANL_PSI_INTEGRATION, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN · INSERT: #SCP_ANL_PSI_INTEGRATION_ITEM · REF: STRING_SPLIT · **동적 SQL**(DYNAMIC@SCP0111_GET_INTEGRATION_PSI) |
| `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | SaveData:1379 | 저장 | EXEC: PR_SCM_SYS_LOG_BATCH · REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL · SCP_ANL_PSI_INTEGRATION(SELECT/UPDATE/INSERT) · INSERT: SCM_SYS_LOG_BATCH |
| `SCP0111_SAVE_INTEGRATION_PSI` | SaveData:1637 | 저장 | 아래 상세 |

### 1-1. `SCP0111_SAVE_INTEGRATION_PSI` 참조 객체 상세
- **EXEC**: PR_SCM_SYS_LOG_BATCH
- **함수/REF**: FN_GET_LOOKUP_VALUE, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL
- **영구 테이블·뷰 쓰기**: INSERT/UPDATE SCP_ANL_PSI_INTEGRATION, INSERT SCM_SYS_LOG_BATCH, `UPDATE:X`(별칭 X — 실제 대상 확인 필요)
- **영구 테이블·뷰 읽기**: SCM_MST_SITE, SCP_ANL_PSI_INTEGRATION, SCP_MST_BOM_ELEC, SCM_MST_YIELD_VER_H_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_CELL_PROD_ASSY_MAP, SCP_MST_FINAL_ITEM, SCP_MST_FORMATION, SCM_ADM_LOOKUP_MASTER, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCM_MST_BOM_EFFECTIVE_SN_V, SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCP_MST_FORMATION_V, SCM_CODE_LOOKUP_VALUE
- **임시 테이블(#) 20종**: #ELEC_PLANT, #CELL_ELEC_PLANT_MAPPING, #TMP_SCP_ANL_PSI_INTEGRATION_230, #TMP_PSI_INTEGRATION_YIELD_VER_H_V_230, #TMP_SCP_ANL_PSI_INTEGRATION_CELL, #TMP_PSI_INTEGRATION_YIELD_VER_H_V, #TMP_YIELD_VER_H_V_A, #TMP_SCP_ANL_PSI_INTEGRATION_530, #TMP_TCO_NO_CA2_ITEM_PROD, #TMP_PSI_INTEGRATION_750_SMALL, #TMP_PSI_INTEGRATION_350_SMALL, #TEM_SCP_ANL_PSI_INTEGRATION_350, #TMP_PSI_INTEGRATION_230_ITEM_SMALL(CREATE 명시), #TMP_PSI_INTEGRATION_SMALL_230, #TMP_PSI_INTEGRATION_SMALL_330 (+ GET SP의 #SCP_ANL_PSI_INTEGRATION_ITEM)
  - 위에 이름이 나열된 #테이블은 SAVE SP 15종 + GET SP 1종입니다. "20종" 표기는 정정합니다. 정확한 개수는 SP 원문으로 재확인하세요.

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)

| code | 참조 테이블 | 호출 수 | 호출 위치 |
|---|---|---:|---|
| CalendarMonth | SCM_SYS_CALENDAR_M | 8 | SetChangedPeriod:287·288, SetCalendar:345, EditButton:554, SaveData:1154·1242·1511, _defaultDataModel_Changed:1980 |
| LookupCommon | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | `<field:dtPeriod>`:66(진입점 미연결), EditButton:622, SaveData:1205 |

- LookupCommon 호출의 LOOKUP_TYPE 인자 값은 Fact Pack에 없어 확인 필요입니다.

## 3. FoxQuery 미등록·직접 호출 SP
- 엔드포인트 5개는 모두 **MATCH**(FoxQuery 등록 확인)입니다. 미등록이나 직접 SQL 호출은 Fact Pack에 없습니다.
- RefreshPlanDate / RefreshPlanType / RefreshPlanSeq가 쓰는 데이터(dtPlanTypeFN 등)의 원천 엔드포인트는 추출되지 않았습니다. 확인 필요입니다.

## 4. Oracle 전환 시 확인 포인트 (사실 기반)

| # | 대상 | 사실 | 전환 포인트 |
|---|---|---|---|
| 1 | SCP0111_GET_INTEGRATION_PSI | REF: STRING_SPLIT | MSSQL 전용 함수이므로 Oracle 대체(분할 함수 또는 JSON_TABLE 등)가 필요합니다 |
| 2 | SCP0111_GET_INTEGRATION_PSI | DYNAMIC SQL | 동적 SQL 원문(월 컬럼 PIVOT 여부 등)을 확인한 뒤 EXECUTE IMMEDIATE / SYS_REFCURSOR로 전환합니다 |
| 3 | GET·SAVE SP | #임시 테이블 다수 | GTT로 바꾸고, 저장 SP 시작 시 초기화를 확인합니다 |
| 4 | SAVE 2종 | SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 배열 문자열 분할 함수의 Oracle 대응 객체가 있는지 확인합니다 |
| 5 | SAVE 2종 | EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH | 공용 로그 프로시저의 Oracle 버전이 있는지 확인합니다 |
| 6 | SCP0111_SAVE_INTEGRATION_PSI | REF: FN_GET_LOOKUP_VALUE | 공용 함수의 Oracle 버전이 있는지 확인합니다 |
| 7 | SCP0111_SAVE_INTEGRATION_PSI | `UPDATE:X` | 별칭 기반 UPDATE…FROM 구문입니다. Oracle MERGE 또는 상관 UPDATE로 바꿔야 합니다(원문 확인 필요) |
| 8 | SCP0111_SAVE_INTEGRATION_PSI | #TMP_PSI_INTEGRATION_230_ITEM_SMALL CREATE 명시 | 런타임 CREATE TABLE이므로 GTT 사전 DDL이 필요합니다 |
| 9 | DM0003_GET_BUCKET_TYPE_CODE | DM 공용 SP | 다른 화면에서도 쓰는 공용 SP입니다. Oracle 전환 여부를 확인하고, SCP0111 전용 수정은 금지합니다 |
| 10 | 저장 분기 | ADMIN / 일반 2종 | 분기 조건을 C#에서 확인한 뒤 TO-BE 저장 API 분기를 설계합니다 |

### 난이도 근거
- `SCP0111_SAVE_INTEGRATION_PSI`: 참조 객체가 60개를 넘고, #임시 테이블이 15종 이상이며, 뷰 5종(SCM_MST_YIELD_VER_H_V, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCM_MST_BOM_EFFECTIVE_SN_V, SCP_MST_FORMATION_V 등)과 함수·로그 EXEC를 포함합니다. **상** (추출 사실의 규모 기준)
- `SCP0111_GET_INTEGRATION_PSI`: STRING_SPLIT과 동적 SQL을 포함합니다. **중** (동적 SQL 원문은 미확인)
- `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`: 단일 테이블 SELECT/UPDATE/INSERT에 배열 분할과 로그를 더한 구조입니다. **중**
- `SCP0111_GET_ESS_PACK_LINE`, `DM0003_GET_BUCKET_TYPE_CODE`: 단순 SELECT입니다. **하**
