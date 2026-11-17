# 룰과 다른 코드, 데이터 보완 후보 (2026-11-14)

- 측정: FE 소스 2,181개 파일(features 1,991개) 정규식 전수 측정 02:11~02:15. 사내 DB(ZIOUI1) 읽기 전용 조회 02:15.
- 건별 목록: `2026-11-14_RULE_VS_CODE_보완후보.csv` (category, file, line, detail).
- 코드와 DB 는 고치지 않음. 정규식 일치 수이며 건마다 문맥 확인이 남아 있음.
- FE, BE 직접 수정 여부는 작업 모드(`tools/Harness/harness.json` repairScope)를 따름. 공통 컴포넌트는 변경 전 사용자 확인.

## 1. 요약

| # | 후보 | 건수 | 어긋난 룰 | 성격 |
|---|---|---:|---|---|
| 1 | 공용 SubTitle 의 Insert, Delete, Save 기본 동작 | 3줄, 1개 파일 | CR-070, `subtitle-button-actions-mandatory.md` §1 | 공통 컴포넌트 |
| 1-b | hotkeyConfig 에 insert 또는 delete 키가 없는 화면 | 6곳, 4개 파일 | 위와 같음 | 1번을 고치면 영향 받는 화면 |
| 2 | 메타 미응답 때 대체 컬럼 사용 | 10곳, 10개 파일 | `ui-category-setup-column-meta.md` §5.5, §11 | 화면 코드 |
| 2-x | 상수 컬럼 반환, 대체값인지 문맥 확인 필요 | 4곳 | 같은 문서 | 확인 대상 |
| 2-y | 컬럼 설정 팝업에 `fallbackColumns` 전달 | 8곳, 7개 파일 | `grid-column-setting-popup-pattern.md` 는 전달을 요구 | 룰 사이 확인 대상 |
| 2-b | 메타 미응답 때 대체 measure 사용 | 2곳, 2개 파일 | 같은 문서 §11 | 화면 코드 |
| 3 | measure 호출에 divisionId 없음 | 15곳, 15개 파일 | 같은 문서 §8 | 화면 코드 |
| 4 | 진입 페이지 400줄 초과 | 60개 | `01_file_structure.md` §1.5.1 | 화면 코드 |
| 5 | 모달 키를 `attribute1` 로 읽는 그리드 | 3곳, 3개 파일 | `ui-category-setup-column-meta.md` §11 | 화면 코드 |
| 6 | 편집 진입 처리 안에서 `dataMap` 교체 | 37곳, 22개 파일 | `cascade-combo-filter.md` 5-G | 화면 코드 |
| 7 | 화면 밖 상대경로 import(`../` 3단 이상) | 82곳, 55개 파일 | `CLAUDE.md §4-①` | 화면 코드 |
| 7-b | master 공용 index 에 `MODAL_OWNER` export 없음 | 1개 파일 | 7번의 선행 조건 | 공용 폴더 |
| 8 | `as unknown as` 사용 | 618곳, 281개 파일 | `post-write.md`, `pre-write.md` | 화면 코드 |
| 9 | `alternatingRowStep=0` 인데 병합을 쓰지 않는 그리드 | 1곳 | `grid-cell-backcolor-standard.md` 금지 5 | 화면 코드 |
| 10 | KO 와 EN 이 다른 라벨 | 193개 | `i18n-ko-en-alignment.md` | locale 데이터 |
| 11 | 모달 키가 `ATTRIBUTE1` 에 있는 컬럼 메타 | 15행 | `column-lookup-meta-standard.md` §1 | DB 메타 |
| 12 | 대소문자만 다른 중복 시트 | 5쌍, 10개 시트 | `sheet-name-asis-preserve-mandatory.md` §1 | DB 메타 |
| 13 | SCM_MGR 의 INVALID 객체 | 12개 | `CLAUDE.md §1-4` | DB 객체, 참고 |

## 2. 후보별 내용

### 1. 공용 SubTitle 기본 동작
- 위치: `nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx` 의 F7, F8, F9 기본 핸들러 3줄.
- 현재: F8 은 `addRow`, F9 는 `removeRow`, F7 은 빈 동작. 화면이 키를 주지 않아도 버튼이 보임.
- 룰: 화면이 핸들러를 줄 때만 노출.
- 보완 방향: 기본값을 숨김으로 변경.
- 화면 쪽 현황(02:18 재측정): `<SubTitle` 사용 145곳, 141개 파일. `const hotkeyConfig` 객체 정의 140개 중 insert 와 delete 를 둘 다 준 것 75개, 둘 다 `false` 로 끈 것 59개, 한쪽만 준 것 4개, 키가 없는 것 2개.
- 기본값을 바꾸면 영향 받는 곳 6곳, 4개 파일: `UICategorySetup.tsx:84`(insert 없음), `ForecastPrice.tsx:789`(insert, delete, save 없음), `Dmf0052.tsx:171, 181, 186`(hotkeyConfig 속성 없음), `ProductionPlan.tsx:415`(hotkeyConfig 속성 없음).
- 이 4개 파일에 행추가, 행삭제 기능이 필요한지 가려 핸들러를 넣거나 `false` 를 준 뒤 공용 기본값을 바꾼다.
- 정정: 02:15 측정은 JSX 속성 전달(`hotkeyConfig={hotkeyConfig}`)을 객체 정의로 잘못 세어 141개 파일로 적었다. 객체 정의만 세도록 고쳐 다시 쟀다.

### 2. 메타 미응답 때 대체 컬럼, measure
- 컬럼 10곳: `BatchHistGrid.tsx:37`, `BatchLogGrid.tsx:56`, `BatchStepGrid.tsx:36`, `CustPsiUploadGrid.tsx:83`, `MetalLinkPriceGrid.tsx:47`, `MktFcstGrid.tsx:316`, `MktFcst01Grid.tsx:337`, `SalesFuturePrice01Grid.tsx:248`, `SalesMonitoringGrid.tsx:124`, `SalesFuturePriceGrid.tsx:214`.
- 문맥 확인 대상 4곳: `ShipmentPlanFgGrid.tsx:81`, `ShipmentPlanSemiGrid.tsx:86`(Division 으로 상수 컬럼을 고름), `PrModal.tsx:113`, `forecast-price.excelForm.ts:58`(Excel 양식용 대체 컬럼).
- 컬럼 설정 팝업의 `fallbackColumns` 전달 8곳은 `grid-column-setting-popup-pattern.md` 가 전달을 요구하는 자리다. 대체값 금지와 함께 둘지 룰 쪽 확인이 필요하다.
- measure 2곳: `SalesFuturePrice.tsx:426`, `SalesFuturePrice01.tsx:584`.
- 보완 방향: 대체값 분기 삭제. 메타가 비는 화면은 deploy SQL 로 메타를 채움.
- 주의: 대체값을 지우기 전에 각 화면의 메타가 사내, 클라우드에 등록돼 있는지 확인. 없으면 빈 그리드가 됨.

### 3. measure 호출에 divisionId 없음
- 15개 파일. 화면 폴더: capa-loss-plan, capa-mobility-it, capa-speed-plan, capa-teep-report, production-plan-fix, production-plan-waterfall, sales-future-price, sales-price-model-group, shipment-plan 외. 전체는 CSV.
- divisionId 를 보내는 호출은 22개 파일.
- 보완 방향: 요청 본문에 조회조건 Division 추가.
- 주의: Division 이 없는 화면(관리 화면 등)은 대상에서 제외.

### 4. 진입 페이지 400줄 초과
- 142개 중 60개. 401~600줄 34개, 601~1,000줄 15개, 1,001줄 이상 11개.
- 상위: `ShipmentPlanMobilityIt.tsx` 1,849줄, `ShipmentPlan.tsx` 1,376줄, `SalesFuturePrice01.tsx` 1,347줄.
- reference DMF0004 `SalesSite.tsx` 도 412줄.
- 보완 방향: 화면 안 Form, Grid, 핸들러를 하위 파일로 분리.
- 주의: 동작 변경 없는 구조 변경이라 회귀 확인이 필요. 화면 수정 요청이 있을 때 함께 하는 편이 낫다.

### 5. 모달 키를 attribute1 로 읽는 그리드
- `MktFcstGrid.tsx:354`, `SalesFuturePrice01Grid.tsx:280`, `SalesFuturePriceGrid.tsx:245`.
- 보완 방향: `cellCboDataTp` 를 먼저 읽고 `attribute1` 은 마지막 순위로.
- 선행: 11번 메타 이관.

### 6. 편집 진입 처리 안에서 dataMap 교체
- 37곳, 22개 파일. project-list, project-master, project-reg, shipment-plan, business-plan, mkt-fcst, forecast-price, opt-capa, capa-line-assign, operation-lt 외.
- 편집 진입 처리 밖의 `dataMap` 대입 60곳은 초기 설정으로 보고 후보에서 뺌.
- 보완 방향: 공용 DataGrid 의 컬럼 메타(PARAM2, PARAM10) 처리로 전환.
- 주의: 구분은 `beginningEdit` 문자열이 앞 45줄 안에 있는지로 함. 건마다 확인 필요. 화면마다 후보 산출 방식이 달라 일괄 전환은 어렵다.

### 7. 화면 밖 상대경로 import
- 82곳, 55개 파일. 대상: components 계열 34, call-proc 15, grid 13, usePinDashDateFormat 9, date 6, comboCascadeAutoFill 3 외.
- 보완 방향: `'features/<도메인>/src/...'` 비상대 경로로 변경.
- 선행: 7-b. `features/master/src/components/index.ts` 가 `MODAL_OWNER` 를 export 해야 해당 import 를 옮길 수 있음.

### 8. as unknown as
- 618곳, 281개 파일. demand 185, supply 178, shipping 85, spms-demand 55, sdm 54, master 52 외.
- 보완 방향: `procedures.d.ts` 타입을 맞춰 단언 제거.
- 주의: 건수가 많고 타입 정의가 SP 마다 필요. 화면 수정 때 해당 파일만 정리하는 방식이 현실에 맞다.

### 9. alternatingRowStep=0
- 10곳 중 9곳은 병합을 쓰는 그리드라 예외 허용.
- 병합을 쓰지 않는 곳: `supply/.../plant-site/components/PlantSiteGrid.tsx:345` 1곳.

### 10. KO 와 EN 이 다른 라벨
- 라벨 656개 중 193개. 키와 두 값은 CSV.
- 보완 방향: KO 값을 EN 값으로 맞춤. `SCM_ADM_MSG_M` 과 locale JSON 을 함께.
- 주의: 화면 문구가 바뀜. 사용자 확인 후 진행.

### 11. 모달 키가 ATTRIBUTE1 에 있는 컬럼 메타
- 15행. DMF0020 2, DMF0020_01 2, DMF0083 2, SDM1020 1, SDM5010 2, SYS0002 2, SYS0003 3, SYS0014 1.
- 15행 모두 `CELL_COMBO_DATA_TYPE` 이 비어 있음.
- 보완 방향: 값을 `CELL_COMBO_DATA_TYPE` 으로 옮김. 사내 적용 SQL, 원복 SQL, 클라우드 이관 패키지.
- 주의: SYS, SDM 화면이 모달 키를 어디서 읽는지 확인한 뒤 옮김. 5번과 같은 묶음으로 진행.

### 12. 대소문자만 다른 중복 시트
| 화면 | 시트 | 컬럼 행 | 최초 등록 | 마지막 수정 | FE 사용 |
|---|---|---:|---|---|---|
| DMF0004 | CountryPopup | 6 | 2018-07-31 | 2026-08-27 | 0개 파일 |
| DMF0004 | countryPopup | 6 | 2018-07-31 | 2026-04-13 | 0개 파일 |
| DMF0005 | Production | 85 | 2018-07-17 | 2026-09-03 | 0개 파일 |
| DMF0005 | production | 83 | 2018-07-17 | 2026-09-17 | 4개 파일 |
| DMF0005 | Purchase | 32 | 2018-07-17 | 2026-09-02 | 2개 파일 |
| DMF0005 | purchase | 32 | 2018-07-17 | 2026-09-02 | 4개 파일 |
| DMF0005_01 | Production | 85 | 2026-11-03 | 2026-11-03 | 위와 같은 폴더 측정 |
| DMF0005_01 | production | 83 | 2026-11-03 | 2026-11-03 | 〃 |
| DMF0005_01 | Purchase | 32 | 2026-11-03 | 2026-11-03 | 〃 |
| DMF0005_01 | purchase | 32 | 2026-11-03 | 2026-11-03 | 〃 |
- FE 사용 수는 sales-site 계열 폴더에서 따옴표 안 문자열로 센 값. DMF0004 의 두 시트는 0개라 사용처 미확인.
- 보완 방향: FE 가 쓰는 이름을 등록명으로 남기고 다른 쪽 삭제.
- 주의: Production 85행과 production 83행은 행 수가 다름. 삭제 전에 컬럼 차이 2행을 확인. 삭제는 원복 SQL 을 먼저 만든 뒤 진행.

### 13. SCM_MGR 의 INVALID 객체 (참고)
- 12개. 마지막 DDL 2026-11-13 21:21~21:22.
- PACKAGE BODY 3개: `PKG_SDM2010`, `PKG_SDM2020`, `PKG_SDM2030`.
- PROCEDURE 9개: `PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL`, `PR_SCP_XLS_USER_LOGIN_LOG`, `PR_SNAPSHOT_BATCH_TARGET_TABLES`, `PR_DM_DNM_SALES_RESULT`, `PR_DM_DNM_EDI_CALL_OFF_HEAD`, `PR_DM_PLN_CUST_PSI_TO_MKT_FCST`, `PR_NERP_XLS_TOBE_CONVERTER`, `PR_GSCM_XIF_DM_GSD0003_R`, `PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS`.
- INVALID 가 된 원인과 시점은 미확인. 같은 날 21시대에 다른 세션이 빈 문자열 비교 구문을 사내에 적용했고, 그 세션이 `PKG_SDM2010`, `PKG_SDM2020` 의 `ORA-00904 'BIZ_TYPE'` 를 미조치로 보고함. 나머지 10개가 그 전부터 INVALID 였는지는 조회하지 않음.
- 확인 방법: 객체별 `ALL_ERRORS` 조회, 적용 전 백업과 대조.

## 3. 진행 순서 제안

| 순서 | 묶음 | 이유 |
|---|---|---|
| 1 | 13번 INVALID 객체 원인 확인 | 화면이 호출하면 실행 오류. `PKG_SDM2010`, `2020`, `2030` 은 SDM 화면의 패키지 |
| 2 | 12번 중복 시트, 11번과 5번 모달 키 | DB 메타 작업. 작업 모드와 무관하게 진행할 수 있음. 5번은 FE 3곳 |
| 3 | 2번 대체값, 3번 divisionId | 12곳, 15개 파일. 관리자 설정이 화면에 반영되지 않는 문제와 직결 |
| 4 | 1번 공용 SubTitle | 공통 컴포넌트. 영향 받는 4개 파일 확인이 선행 |
| 5 | 9번, 7번, 10번 | 건수가 적거나 기계적 치환 |
| 6 | 4번, 6번, 8번 | 건수가 많음. 화면 수정 요청이 있을 때 해당 화면만 정리 |

## 4. 측정 한계
- 정규식 측정이라 놓친 형태가 있을 수 있는 항목: 1-b(hotkeyConfig 를 변수로 조립하는 화면), 2번(대체값을 다른 이름으로 둔 화면), 6번(편집 진입 처리 판별).
- 2번은 처음 정규식이 여러 줄 삼항 연산을 놓쳐 1회 보정함. 02:18 에 다른 검색으로 교차 확인해 `BatchHistGrid.tsx` 1곳을 더했고 오검출 2곳(`LineMasterMainGrid.tsx`, `TactTimeMainGrid.tsx`)을 뺐다.
- 1-b 는 02:15 측정이 틀려 02:18 에 다시 쟀다. CSV 는 02:18 기준 1,319행.
- BE 코드와 SP 본문은 이번 측정 대상이 아님.
- 사내 PKG 의 빈 문자열 비교 구문은 다른 세션이 조사함. `2026-11-13_EMPTY_STRING_COMPARE_조사.md`.


## 13-1. INVALID 객체 12개 원인 확인 (사내 DB 읽기 전용, 2026-11-14 11:06~11:11)

조회는 SELECT 만 실행했고 끝에 ROLLBACK 함. 스크립트 `inv_cause.py`, `inv_cause2.py`, `inv_local.py`(scratchpad).

### 확인한 것

- 12개는 2026-11-13 21:21 이전부터 INVALID 임. `_artifacts/_diagnostics/TOBE_NEW_TABLES_20261111/ui_used/dict/objects.csv`(11-11 16:30 추출)에 12개가 INVALID 로 있음. 그때 마지막 DDL 은 10-15 ~ 11-03.
- 같은 추출본의 SCM_MGR INVALID 는 82개(PACKAGE, PACKAGE BODY, PROCEDURE, FUNCTION, VIEW, TRIGGER). 11-14 11:06 에는 12개.
- 11-13 21:21:32 에 표 17개(`DM_PLN_MKT_FCST` 계열 7개, `DM_PLN_SALES_PLAN` 계열 10개)의 마지막 DDL 시각이 바뀜. 이어서 21:21~21:22 에 PACKAGE BODY 51개, PROCEDURE 131개, FUNCTION 3개, VIEW 1개의 마지막 DDL 시각이 바뀜. 그중 12개가 INVALID 로 남음.
- 12개의 마지막 DDL 시각이 21:21:55~21:22:17 로 바뀐 것은 그때 컴파일을 다시 시도했다가 실패한 흔적임. `PKG_SDM2010`, `PKG_SDM2020` 은 TIMESTAMP 가 19:08:51, 19:08:52 로 남아 있고, 이 시각은 `EMPTYCMP_B_20261113/APPLIED_OPERATIONS.md` 의 적용 시각과 같음. 같은 문서에 "수정 전 LAST_DDL 2026-10-15 10:47:59. 오류 4건씩, 수정 전후 같음" 이라고 적혀 있음.

### 객체별 컴파일 오류 (ALL_ERRORS 98행, 오류 본문 49행)

| 객체 | 오류 | 걸린 대상 |
|---|---|---|
| `PKG_SDM2010` BODY | ORA-00904, 562줄과 788줄 | `BLD.BIZ_TYPE`, INSERT 컬럼 `BIZ_TYPE` 없음 |
| `PKG_SDM2020` BODY | ORA-00904, 526줄과 752줄 | 위와 같음 |
| `PKG_SDM2030` BODY | ORA-00904 114줄, ORA-00942 217줄 | `BLD.BIZ_TYPE`, 표 `SCM_MGR.SPMS_GRID_SHEET` 없음 |
| `PR_DM_DNM_EDI_CALL_OFF_HEAD` | ORA-00980 4곳 | 시노님 `XIF_ERP_EDI_CALL_OFF_HEAD_R_SN` 의 대상 없음 |
| `PR_GSCM_XIF_DM_GSD0003_R` | ORA-00980 45줄 | 위 시노님 |
| `PR_DM_DNM_SALES_RESULT` | ORA-00942 976줄 | 표 `DM_DNM_SALES_RESULT_H` 없음 |
| `PR_DM_PLN_CUST_PSI_TO_MKT_FCST` | ORA-00942 10곳 | 임시 표 `GT_DPCP_PSI`, `GT_DPCP_PSI_GROUP_COUNT`, `GT_DPCP_MKT_FCST`, `GT_DPCP_T2`, `GT_DPCP_T3`, `GT_DPCP_CALENDAR` 없음 |
| `PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS` | ORA-00942 10곳 | 임시 표 `GT_DPCP_MKT_FCST` 없음 |
| `PR_NERP_XLS_TOBE_CONVERTER` | PLS-00201 10곳 | 프로시저 `PR_NERP_XLS_TOBE_CONVERTER_SUB` 없음 |
| `PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL` | ORA-00932 1591줄 | `SA.UNHOLD_EXP_DATE`(DATE)를 문자 변수와 CASE 로 섞음 |
| `PR_SCP_XLS_USER_LOGIN_LOG` | ORA-00904 67줄, 116줄 | MSSQL 함수 `DECRYPTBYKEY`, `ENCRYPTBYKEY` 가 남음 |
| `PR_SNAPSHOT_BATCH_TARGET_TABLES` | ORA-00913 4곳 | `DM_PLN_MKT_FCST_SNAPSHOT`, `DM_PLN_SALES_PLAN_SNAPSHOT`, `DM_PLN_MKT_FCST_RESULT_SNAPSHOT`, `DM_PLN_SALES_PLAN_RESULT_SNAPSHOT` 에 넣는 값 수가 컬럼 수보다 많음 |

원인은 3종임. 없는 표·컬럼·시노님 대상·프로시저를 참조하는 것 9개, MSSQL 구문이 남은 것 1개, 자료형이나 컬럼 수가 맞지 않는 것 2개.

### 미확인

- 21:21:32 에 표 17개에 실행된 DDL 의 종류와 실행자. `audit_trail` 값이 NONE 이고 통합 감사 기록 0행, 스케줄러 실행 기록 0행임. 이 PC 의 `_artifacts/_apply_corporate` 에는 그 시각의 적용 폴더가 없음.
- `BLD` 별칭이 가리키는 표 이름. 해당 SQL 의 FROM 줄을 읽지 않음.
- `XIF_ERP_EDI_CALL_OFF_HEAD_R_SN` 시노님의 소유자와 대상. SCM_MGR 소유 시노님 중 대상 없는 것은 0행이었음.
- 12개 중 화면이나 배치가 호출하는 것이 어느 것인지. `Doc/asisfacts/ref_ssp/batch_list.csv` 에 `PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL`, `PR_SCP_XLS_USER_LOGIN_LOG` 가 "전환X" 로 적힌 것만 확인함.


## 13-2. INVALID 객체 12개 호출처 확인 (2026-11-14 11:18~11:24)

사내 DB 는 SELECT 만 실행했고 끝에 ROLLBACK 함. 스크립트 `inv_callers_db.py`, `inv_callers_db2.py`, `inv_callers_db3.py`, `inv_callers_local.py`(scratchpad).

조회 범위: `ALL_DEPENDENCIES`, `ALL_SYNONYMS`, `ALL_TAB_PRIVS`, `ALL_SOURCE` 본문, 스케줄러 작업 301개, `DBA_JOBS`, SCM_MGR 표의 SP 이름 컬럼 후보 139개, `SCM_ADM_MNU_M`, `SCM_ADM_API_M`, `SCM_ADM_PROC_M`, `SCM_SYS_LOG_BATCH`, `nscm-be` 174개 파일, `nscm-fe/features` 2,011개 파일, AS-IS 소스 `GSCM` 6,362개 파일, `Doc/asisfacts` 15,608개 파일.

| 객체 | TO-BE 호출처 | AS-IS 호출처 | 구분 |
|---|---|---|---|
| `PKG_SDM2010` 본문 | 메뉴 SDM2010 USE_YN=Y, `SCM_ADM_API_M` 11행, FE `spms-demand/production-request`, SCMP_APP 시노님 | 없음(신규 화면) | 사용 중인 화면이 호출함 |
| `PKG_SDM2020` 본문 | 메뉴 SDM2020 USE_YN=Y, `SCM_ADM_API_M` 10행, FE `spms-demand/plan-yield`, SCMP_APP 시노님 | 없음(신규 화면) | 사용 중인 화면이 호출함 |
| `PKG_SDM2030` 본문 | 메뉴 없음, API 등록 0행, FE 0줄, 참조 객체 0개 | 없음 | 호출처 없음 |
| `PR_DM_PLN_CUST_PSI_TO_MKT_FCST` | 메뉴 DMF0013 USE_YN=N, API 등록 0행 | 화면 DMF0013 SaveData(`action_links.csv:166`) | 사용 안 하는 메뉴의 화면 |
| `PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS` | 위 프로시저 1705줄에서만 호출 | 위 프로시저에서 호출 | 위와 같음 |
| `PR_SNAPSHOT_BATCH_TARGET_TABLES` | 스케줄러 `JOB_SNAPSHOT_BATCH_TARGET_TABLES` DISABLED, 실행 274회, 마지막 10-29 09:54 | 에이전트 작업 30분 주기 | 꺼진 배치 |
| `PR_DM_DNM_SALES_RESULT` | 직접 호출 0곳. 스케줄러 `JOB_PR_DM_DNM_SALES_RESULT` 는 DISABLED 이고 동작이 `PR_DM_DNM_SALES_RESULT_IF` 호출임 | 에이전트 작업도 `PR_DM_DNM_SALES_RESULT_IF` 실행 | 호출처 없음 |
| `PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL` | `PR_SCP_XLS_CREATE_DATA` 245줄 호출이 주석 처리됨(10-23) | `PR_SCP_XLS_CREATE_DATA` 가 호출 | 호출 끊김, `batch_list.csv` 전환X |
| `PR_SCP_XLS_USER_LOGIN_LOG` | 0곳 | 사실 파일에 호출 기록 없음 | 호출처 없음, `batch_list.csv` 전환X |
| `PR_DM_DNM_EDI_CALL_OFF_HEAD` | 0곳 | 사실 파일에 호출 기록 없음 | 호출처 없음 |
| `PR_NERP_XLS_TOBE_CONVERTER` | 0곳 | 에이전트 작업 `0_NERP_RFC_TOBE_CODE_AND_NERP_CONV_MASTER` 2단계 | TO-BE 호출처 없음 |
| `PR_GSCM_XIF_DM_GSD0003_R` | 0곳, BE 0줄 | 웹서비스 `GSD0003.asmx.cs:62` | TO-BE 호출처 없음 |

### 함께 나온 것

- `SCM_ADM_API_M` 의 SDM2020 등록 7행이 `PKG_SDM2020` 명세에 없는 프로시저를 가리킴: `P_SDM2020_GET_PJT_YIELD` 4행, `P_SDM2020_GET_PJT_YIELD_PLANT`, `P_SDM2020_SAVE_PJT_YIELD_PLANT`, `P_SDM2020_CONFIRM_PJT_YIELD`.
- `SCM_ADM_PROC_M` 은 그 4개 프로시저를 `PKG_SDM2020_YIELD` 이름으로 등록함. `PKG_SDM2020_YIELD` 는 사내 DB 에 없음.
- `PKG_SDM2010`, `PKG_SDM2020` 본문 오류는 `BIZ_TYPE` 컬럼 2곳씩이라 화면 SDM2010, SDM2020 의 조회와 저장이 실패하는 상태임. 화면을 띄워 확인하지는 않음.

### 미확인

- `TH_UIS_SQL_LOG.QUERY_VALUE` 는 180초 시간 초과, `ZNERP_XLS_CHANGE_MASTER_CODE_DM` 의 2개 컬럼은 ORA-12733 으로 조회 실패.
- `SCM_SYS_LOG_BATCH` 에 12개 이름과 일치하는 PROGRAM_NAME 이 0행임. 화면 SDM2010, SDM2020 의 실행 이력은 이 표로 확인하지 못함.
- 인터페이스 서버나 다른 스키마에서 사내 DB 를 부르는 외부 호출. 저장소와 SCM_MGR 밖은 조회하지 않음.
- (11:27 추가 확인) FE 에 DMF0013 화면이 있음: `nscm-fe/features/demand/src/pages/cust-psi-upload/`. 주석에 적힌 저장 SP 는 `DM.DMF0013_SAVE_CUST_PSI_UPLOAD_DATA` 이고 `PR_DM_PLN_CUST_PSI_TO_MKT_FCST` 는 이 폴더에 0줄임. 사내 DB 는 메뉴 DMF0013 USE_YN=N, `SCM_ADM_API_M` 의 `DMF0013%` 0행임.
- `DMF0013_SAVE_CUST_PSI_UPLOAD_DATA` 가 사내 DB 에 있는지, 그 안에서 `PR_DM_PLN_CUST_PSI_TO_MKT_FCST` 를 부르는지. `ALL_SOURCE` 본문 검색에서 이 이름을 부르는 다른 객체는 0줄이었음.
