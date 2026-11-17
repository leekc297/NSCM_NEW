# SSP0024 Oracle 전환 분석

> 출처: Fact Pack의 SP 참조 객체(EXEC 전이 포함)입니다. SP 본문(파라미터·로직)은 Fact Pack에 없으므로 상세 변환 내용은 **확인 필요**입니다.

## 1. 호출 SP 인벤토리
| # | SP | FoxQuery 키 | 호출 위치 | 참조 테이블/객체 | EXEC 체인 | DML |
|---:|---|---|---|---|---|---|
| 1 | `SSP0024_GET_ITEM_BY_DIVISION_POPUP` | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | 팝업 FindData:267 | SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE | (없음) | SELECT |
| 2 | `SCM0001_GET_DIVISION` | SCM.SCM0001_GET_DIVISION | 팝업 GetDivision:405 | SCM_MST_DIVISION | (없음) | SELECT |
| 3 | `SSP0024_GET_SHIP_MASTER` | SSP.SSP0024_GET_SHIP_MASTER | 메인 FindData:316 | SSP_MST_SHIP_MASTER_EE, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE | (없음) | SELECT |
| 4 | `SSP0024_SAVE_SHIP_MASTER` | SSP.SSP0024_SAVE_SHIP_MASTER | 메인 SaveData:467 | SSP_MST_SHIP_MASTER_EE(MERGE), SSP_MST_SHIP_MASTER_EE_H(INSERT), SCM_SYS_LOG_BATCH(INSERT), SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL(REF) | → PR_SCM_SYS_LOG_BATCH | MERGE / INSERT |
| 5 | `SSP0002_GET_USER_INFO_LIST` | SSP.SSP0002_GET_USER_INFO_LIST | 메인 GetSSPUserCheck:883 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | (없음) | SELECT |

SP 내부에서 참조하는 MSSQL 함수:
| SP | REF |
|---|---|
| SSP0024_GET_ITEM_BY_DIVISION_POPUP | STRING_SPLIT |
| SSP0024_GET_SHIP_MASTER | STRING_SPLIT |
| SSP0024_SAVE_SHIP_MASTER | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL (객체 유형 — 함수인지 등 — 확인 필요) |
| SCM0001_GET_DIVISION | (REF 없음) |
| SSP0002_GET_USER_INFO_LIST | (REF 없음) |

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)
| code | 호출 위치 | 처리 프로시저 | 참조 테이블 | MSSQL REF |
|---|---|---|---|---|
| MyDivision | 메인 `<field:dtMyDivision>`:37 (NowGroupID 사용) | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | - |
| PlantSiteByFactoryEEOperation | 메인 `<field:dtPlantSiteByFactoryForSpread>`:41, SetChangedControl:191 | UP_FX_GetCommonDataList | SCM_MST_SITE, SCM_MST_FACTORY_SN | STRING_SPLIT |
| ElectrodePostOperCode | 메인 `<field:dtElectrodePostOperCode>`:49 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | STRING_SPLIT |
| DomExpTypeCode | 메인 `<field:dtDomExpTypeCode>`:51 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| BuildingForShipMasterElec | 메인 `<field:dtBuilding>`:52 | UP_FX_GetCommonDataList | SCM_MST_FACTORY_SN, SCM_MST_SITE | STRING_SPLIT |
| ElectrodePackageType | 메인 `<field:dtElectrodePackageType>`:55 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| PlantSiteByDivision | 팝업 GetDivisionbyPlantSiteCode:415 | UP_FX_GetCommonDataList **및** UP_FX_GetCommonDataList_SCP | SCM_MST_SITE | STRING_SPLIT |

- PlantSiteByDivision 하나만 두 프로시저(UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP)에 코드 분기가 있습니다. 실제로 어느 쪽이 호출되는지는 **확인 필요**입니다.
- 공통코드 분기에 넘기는 인자: InsertRow 원문에 `PlantSiteByFactoryEEOperation, false, "40,81,82,81_UC"`, `ElectrodePostOperCode, false, "", ""`, `BuildingForShipMasterElec, false, "",""`가 나옵니다. 나머지 code의 인자는 **확인 필요**입니다.
- ElectrodePostOperCode / DomExpTypeCode / ElectrodePackageType의 LOOKUP 마스터 키 값은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP
| 구분 | 건수 | 내용 |
|---|---:|---|
| FoxQuery 미등록(MISS) | 0 | 엔드포인트 5개 모두 MATCH |
| 직접 SQL / 직접 SP 호출 | 0 | Fact Pack에 해당 항목 없음 |
| Biz 경유(BIZ_MATCH) | 7 code | `biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList(_SCP) |
| 주석 처리된 호출 | 0 | commented_calls.csv 0행 |

## 4. Oracle 전환 시 확인 포인트
| # | 포인트 | 근거(사실) |
|---:|---|---|
| 1 | **STRING_SPLIT 대체**. 금지 키워드(MSSQL) 목록에 해당하므로 Oracle 구문(분할 함수 또는 계층 쿼리 등)으로 바꿔야 함 | GET_ITEM_BY_DIVISION_POPUP, GET_SHIP_MASTER, UP_FX_GetCommonDataList(_SCP) 코드분기(PlantSiteByFactoryEEOperation, PlantSiteByDivision, ElectrodePostOperCode, BuildingForShipMasterElec) |
| 2 | **SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL** 객체가 Oracle에 있는지와 시그니처 | SAVE_SHIP_MASTER REF |
| 3 | **MERGE SSP_MST_SHIP_MASTER_EE** — 키 컬럼과 MERGE 문법 차이(MSSQL MERGE → Oracle MERGE INTO ... USING ... ON) | SAVE_SHIP_MASTER |
| 4 | **이력 INSERT SSP_MST_SHIP_MASTER_EE_H** — MERGE와 같은 트랜잭션 순서인지 | SAVE_SHIP_MASTER |
| 5 | **PR_SCM_SYS_LOG_BATCH / SCM_SYS_LOG_BATCH** 로그 체인이 Oracle 공용 객체에 있는지 | SAVE_SHIP_MASTER EXEC 체인 |
| 6 | **SSP_MST_SITE_ITEM_EE_V** 뷰 전환 여부 | POPUP·GET_SHIP_MASTER 공통 참조 |
| 7 | 저장 파라미터 형식(구분자 배열 문자열로 여러 행을 넘기는지) | SCM_ARR_SPL_* 참조. 파라미터 정의는 Fact Pack에 없음 → **확인 필요** |
| 8 | 권한 SP **SSP0002_GET_USER_INFO_LIST**는 다른 화면과 공유하는 SP — 시그니처 변경 시 영향 범위 | SP 이름 접두 SSP0002 |
| 9 | **SCM0001_GET_DIVISION** 공용 SP(SCM 도메인) 재사용 | SP 이름 접두 SCM0001 |
| 10 | 공통코드 프로시저 UP_FX_GetCommonDataList / _SCP 분기 7종의 Oracle 측 구현 상태 | 코드분기 표 |

### 4-1. 난이도 (사실 근거만)
| SP | 근거 | 판단 |
|---|---|---|
| SCM0001_GET_DIVISION | 단일 테이블 SELECT, MSSQL REF 없음 | 낮음 |
| SSP0002_GET_USER_INFO_LIST | 5개 테이블 SELECT, MSSQL REF 없음 | 낮음~중간(조인 수) |
| SSP0024_GET_ITEM_BY_DIVISION_POPUP | 뷰 + 1테이블, STRING_SPLIT | 중간(STRING_SPLIT 대체) |
| SSP0024_GET_SHIP_MASTER | 2테이블 + 뷰, STRING_SPLIT | 중간(STRING_SPLIT 대체) |
| SSP0024_SAVE_SHIP_MASTER | MERGE + 이력 INSERT + 로그 SP EXEC + 배열 분할 객체 2종 | 상대적으로 높음(전환 대상 요소 수 최다) |

> 줄 수·커서·동적 SQL·임시테이블 사용 여부 같은 SP 본문 정보는 Fact Pack에 없습니다. 위 판단은 참조 객체 수와 MSSQL REF만 근거로 했습니다.
