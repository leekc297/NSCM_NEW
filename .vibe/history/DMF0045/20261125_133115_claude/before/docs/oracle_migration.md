# DMF0045 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery ID | 호출 지점 | 참조 객체(SELECT/INSERT/UPDATE/DELETE/EXEC/REF) |
|---|---|---|---|
| `DMF0045_GET_SHIPMENT_REQUEST` | DM.DMF0045_GET_SHIPMENT_REQUEST | FindData:609 | 아래 1-1 참조 |
| `DMF0045_SAVE_SHIPMENT_REQUEST` | DM.DMF0045_SAVE_SHIPMENT_REQUEST | SaveData:896 | 아래 1-2 참조 |
| `DMF0045_GET_SPREAD_TITLE` | DM.DMF0045_GET_SPREAD_TITLE | GetSpdTitle:2249 | SELECT SCM_MST_SHEET_COLUMNS, SELECT SCM_SYS_CALENDAR_M, REF STRING_SPLIT |
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:2266 | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | GetBizTypebyDivision:2278 (**진입점 미연결**) | SELECT SCM_MST_PROJECT, REF VALUE, REF NODES |

### 1-1. `DMF0045_GET_SHIPMENT_REQUEST`

| 구분 | 객체 |
|---|---|
| 실 테이블/뷰 SELECT | TB_FX_USER, SCM_MST_TITLESET_USER, SCM_MST_SHEET_MEASURE, DM_PLN_SHIPMENT_REQ, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_DEPT_INFO, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_MST_BOD_N_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCM_SYS_CALENDAR_M, SCP_MST_BOD_V, DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SCM_DNM_CELL_INHOUSE_PLAN_SN, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V |
| 실 테이블 쓰기 | **INSERT SCM_MST_TITLESET_USER** (조회 SP 안에서 사용자 타이틀셋을 기록함) |
| 별칭 대상 DML | UPDATE A, DELETE A, UPDATE TOT (실제 대상 테이블은 **확인 필요**) |
| 임시 테이블 | #TBL_LOC, #TBLDYNAMIC_MEASURE, #TBLDYNAMIC_SHIP_REQ, #TBLDYNAMIC_PLAN, #TBLDYNAMIC_SHIP_ROW, #TBLDYNAMIC_CAL_QTY, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_REQUESTOR, #TBLDYNAMIC_SHIP_PIVOT |
| 함수 | FN_GET_SSP_ETD_DATE, FN_NEXT_DAY, STRING_SPLIT |
| 동적 SQL | DYNAMIC@DMF0045_GET_SHIPMENT_REQUEST |

### 1-2. `DMF0045_SAVE_SHIPMENT_REQUEST`

| 구분 | 객체 |
|---|---|
| SELECT | SCP_MST_BOD, SCP_MST_DISTRIBUTION_ROUTE, DM_PLN_SHIPMENT_REQ |
| INSERT | DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH |
| 별칭 DML | UPDATE A (대상은 **확인 필요**) |
| 임시 테이블 | #TBLDYNAMIC_DMF0045_SHPIMENTREQ (원문 철자 'SHPIMENTREQ') |
| EXEC 체인 | PR_SCM_SYS_LOG_BATCH |
| 함수 | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL (구분자 문자열 분해) |

- DM_PLN_SHIPMENT_REQ에 대해 UPDATE·DELETE는 추출되지 않았고 INSERT와 _H(이력) INSERT만 있습니다. 기존 행을 처리하는 방식(별칭 A의 UPDATE 대상 여부 포함)은 **확인 필요**.

### 1-3. EXEC 체인 요약

```
DMF0045_SAVE_SHIPMENT_REQUEST ──EXEC──▶ PR_SCM_SYS_LOG_BATCH
DMF0045_GET_SHIPMENT_REQUEST  ──(EXEC 체인 없음, 함수 FN_GET_SSP_ETD_DATE / FN_NEXT_DAY 참조)
```

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList`)

| code | 호출 지점 | 분기 SP | 참조 테이블 |
|---|---|---|---|
| MyDivision | InitControls:200 | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| Measure | InitControls:231, FindData:579, InsertRow:1004 | UP_FX_GetCommonDataList | SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST |
| FCST_TYPE | InsertRow:1001 | UP_FX_GetCommonDataList, UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL |
| MktFcstEditMeasure | spdMain_ComboSelChange:1194 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST |
| DefaultBucketDay | spdMain_Changed:1749, 1811 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |

- FCST_TYPE은 분기 SP 후보가 2개(UP_FX_GetCommonDataList / UP_FX_GETCOMMONDATALIST_DM)로 추출되었습니다. 실제 경로는 **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 이 화면의 FoxQuery 엔드포인트 5건은 모두 상태가 `MATCH`이고, 미등록 건은 0건입니다.
- 엔드포인트로 추출되지 않은 데이터 호출(**확인 필요**):
  - `Data.UserSiteByEndCustomer(...)`, `Data.UserSiteByEndCustomerAuth(...)` (spdMain_ComboSelChange:1158)
- 프레임워크 메타 조회 `SpreadInfo.GetSpdTitle`(InitSpread:271)이 화면 엔드포인트 `DM.DMF0045_GET_SPREAD_TITLE`과 같은 호출인지는 **확인 필요**.
- 주석 처리된 호출: 0건.

## 4. Oracle 전환 시 확인 포인트 (추출 사실 기반)

| # | 대상 SP | 사실 | 전환 시 확인 사항 |
|---|---|---|---|
| 1 | DMF0045_GET_SHIPMENT_REQUEST, DMF0045_GET_SPREAD_TITLE | `STRING_SPLIT` 참조 | MSSQL 전용 함수. Oracle 대체 구현 필요(프로젝트 금지 키워드 ⑩) |
| 2 | DMF0045_GET_SHIPMENT_REQUEST | 임시 테이블 9종(#...) | Oracle GTT 또는 WITH 절로 전환. GTT를 쓰면 세션 내 재조회 시 비우기 처리 확인 |
| 3 | DMF0045_GET_SHIPMENT_REQUEST | `DYNAMIC@` 동적 SQL, `#TBLDYNAMIC_SHIP_PIVOT` | 날짜 버킷 피벗 동적 컬럼. Oracle 동적 SQL/SYS_REFCURSOR 결과 컬럼명이 Grid 태그(D_/W_/M_)와 일치하는지 확인 |
| 4 | DMF0045_GET_SHIPMENT_REQUEST | 조회 SP 안의 `INSERT SCM_MST_TITLESET_USER` | 조회 중 쓰기 발생. 트랜잭션/커밋 경계 확인 |
| 5 | DMF0045_GET_SHIPMENT_REQUEST | FN_GET_SSP_ETD_DATE, FN_NEXT_DAY | Oracle에 동명 함수가 있는지 확인 |
| 6 | DMF0045_SAVE_SHIPMENT_REQUEST | SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 구분자 배열 파라미터 처리 함수의 Oracle 대응 객체 확인 |
| 7 | DMF0045_SAVE_SHIPMENT_REQUEST | EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH | 로그 프로시저의 Oracle 대응 객체 확인 |
| 8 | DMF0045_SAVE_SHIPMENT_REQUEST | INSERT DM_PLN_SHIPMENT_REQ / DM_PLN_SHIPMENT_REQ_H | NOT NULL 컬럼과 이력 키 확인 |
| 9 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | REF VALUE, REF NODES | XML 타입 메서드(.nodes/.value)일 가능성. 원문 확인 후 Oracle XMLTABLE 등으로 대체. 다만 화면에서 미연결이므로 전환 필요 여부부터 확인 |
| 10 | DM0003_GET_BUCKET_TYPE_CODE | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL 단일 | 다른 객체 참조 없음 |

### 난이도 (추출된 사실 개수만으로 분류)

| SP | 근거 | 분류 |
|---|---|---|
| DMF0045_GET_SHIPMENT_REQUEST | 실 객체 23종 이상 + 임시 테이블 9 + 동적 SQL + STRING_SPLIT + 사용자 함수 2 | 상 |
| DMF0045_SAVE_SHIPMENT_REQUEST | EXEC 체인 1 + 배열 분해 함수 2 + 임시 테이블 1 + INSERT 3 | 중 |
| DMF0045_GET_SPREAD_TITLE | 테이블 2 + STRING_SPLIT | 중하 |
| DM0003_GET_BUCKET_TYPE_CODE | 테이블 1 | 하 |
| SCM0001_GET_BIZ_TYPE_BY_DIVISION | 테이블 1 + XML 메서드 참조 추정 | 하~중 (미연결) |
