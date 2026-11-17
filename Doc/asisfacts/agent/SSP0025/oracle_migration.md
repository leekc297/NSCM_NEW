# SSP0025 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 동작 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 팝업 FindData:296 | 조회 | SELECT: SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL / REF: STRING_SPLIT | 없음 |
| `SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 메인 FindData_Main:274 | 조회 | SELECT: SSP_MST_MODEL_USER_EE, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, TB_FX_USER / REF: STRING_SPLIT | 없음 |
| `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | 메인 SaveData:410 | 저장 | MERGE: SSP_MST_MODEL_USER_EE / INSERT: SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH` |
| `SSP0025_GET_USER_ID_CHECK` | 메인 GetUserIDChk:458 | 검증 조회 | SELECT: TB_FX_USER / REF: STRING_SPLIT | 없음 |
| `SSP0002_GET_USER_INFO_LIST` | 메인 GetSSPUserCheck:511 (EditButton) | 사용자 권한 조회 | SELECT: SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | 없음 |

쓰기 대상 테이블: `SSP_MST_MODEL_USER_EE`(MERGE), `SCM_SYS_LOG_BATCH`(INSERT, PR_SCM_SYS_LOG_BATCH 경유를 포함하는지는 **확인 필요**).

## 2. 공통코드 분기 (UP_FX_GetCommonDataList)

| 호출 | code | 참조 테이블 | 사용처 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` | FromSiteByAssembly | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE | 팝업 InitControls:206, clbDivision_SelectedIndexChanged:357 → From Site 목록 |
| `biz:CommonData.CommonDataList` | MyDivision | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | 메인/팝업 `dtMyDivision` 필드(45/37). 인자 NowGroupID, UserId |
| `biz:CommonData.CommonDataList` | PlantCell | SCM_MST_SITE | 메인 SetChangedControl:140, SpdMain_CellClick:639 → Plant Site 목록·그리드 콤보 |
| `biz:CommonData.YesOrNo` | (code 없음, Data.CallBizData) | DB 보강 없음, **확인 필요** | 메인 `dtYesOrNo`(47) |

## 3. FoxQuery 미등록 / 직접 호출 SP

- 엔드포인트 5개(SSP.*)는 모두 상태 **MATCH**입니다(FoxQuery에 등록돼 있고 SP와 매칭됨).
- 미등록, 직접 SQL, 미매칭 엔드포인트는 **0건**입니다.
- 주석 처리된 호출은 0건입니다.
- `SSP0002_GET_USER_INFO_LIST`는 SSP0002 화면과 공유하는 SP입니다. TO-BE에서 공용 API로 둘지 결정해야 합니다.

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 사실 | 전환 확인 포인트 |
|---|---|---|---|
| 1 | `SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP0025_GET_USER_ID_CHECK` | REF: `STRING_SPLIT` | MSSQL 전용 함수(절대 금지 ⑩)이므로 Oracle 대체 구현이 필요합니다(예: 프로젝트 공용 분할 함수 또는 REGEXP/CONNECT BY). 사용하는 파라미터(멀티라인 Material/Model, 다중선택 Plant Site 추정)는 SP 원문에서 **확인 필요** |
| 2 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | REF: `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | 배열 분할 사용자 함수입니다. Oracle 쪽 동일 객체의 존재와 시노님 여부 **확인 필요** |
| 3 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | MERGE: `SSP_MST_MODEL_USER_EE` | MSSQL MERGE → Oracle MERGE 문법 차이(OUTPUT 절, 세미콜론, WHEN NOT MATCHED BY SOURCE 사용 여부)는 SP 원문 **확인 필요**. MERGE 키 컬럼 **확인 필요** |
| 4 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | EXEC `PR_SCM_SYS_LOG_BATCH`, INSERT `SCM_SYS_LOG_BATCH` | 공통 로그 프로시저입니다. Oracle 전환본 존재 여부와 시그니처 **확인 필요** |
| 5 | `SSP_MST_SITE_ITEM_EE_V` | 뷰 (3개 SP가 참조) | 뷰 정의가 Oracle에 전환됐는지 **확인 필요** |
| 6 | `SSP0025_GET_USER_ID_CHECK` | TB_FX_USER 조회 + STRING_SPLIT | 저장 전 USER_ID 존재 검증으로 보입니다. 반환 형식(오류 메시지/건수)이 FE 판정에 쓰이는지 **확인 필요** |
| 7 | `SSP0002_GET_USER_INFO_LIST` | TB_FX_* 권한 테이블 5종 | TO-BE 권한 체계(TB_FX_* 대응 테이블)와 매핑 **확인 필요** |
| 8 | 저장 화면 공통 | SaveData의 호출 순서 미추출 | GetUserIDChk → SAVE → 재조회 순서는 **확인 필요**. 트랜잭션 경계(SP 단위 COMMIT 여부) **확인 필요** |

## 5. 난이도 판단 근거 (사실 기반)

| 근거 | 값 |
|---|---|
| 호출 SP 수 | 5 (조회 3, 저장 1, 권한 조회 1) |
| MSSQL 전용 함수 참조 | STRING_SPLIT 3개 SP |
| 쓰기 테이블 | 2 (SSP_MST_MODEL_USER_EE MERGE, SCM_SYS_LOG_BATCH INSERT) |
| 하위 EXEC 체인 | 1단계 (PR_SCM_SYS_LOG_BATCH) |
| 미매칭/직접 SQL | 0 |
| division별 분기 | 0 |

SP 본문의 줄 수, 동적 SQL 사용 여부, 임시 테이블 사용 여부는 Fact Pack에 없습니다. 그래서 정량적인 난이도 등급은 매기지 않았습니다(**확인 필요**).
