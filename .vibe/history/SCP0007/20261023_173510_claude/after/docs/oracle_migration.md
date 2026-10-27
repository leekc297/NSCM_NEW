# SCP0007 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 호출 지점 | 참조 객체(EXEC 전이 포함) | 사실 기반 난이도 |
|---|---|---|---|---|
| `SCP0007_GET_BOD` | SCP.SCP0007_GET_BOD | FindData_Main:553 (조회, 저장 뒤 재조회) | STRING_SPLIT, **DYNAMIC@SCP0007_GET_BOD** | 중~상. 동적 SQL이라 참조 테이블과 결과 컬럼을 정적으로 확정하지 못함 |
| `SCP0007_GET_COUNTRY_CITY` | SCP.SCP0007_GET_COUNTRY_CITY | GetData_Country:626 | SELECT SCM_MST_SITE, STRING_SPLIT | 하. 단일 테이블 + STRING_SPLIT |
| `SCP0007_SAVE_BOD` | SCP.SCP0007_SAVE_BOD | SaveData_Main:794 | 아래 1-1 참조 | 상. 참조 24건, 하위 EXEC 4개, 임시테이블, MERGE/DELETE/INSERT/UPDATE |
| `SCP0007_GET_ROUTE_CNT` | SCP.SCP0007_GET_ROUTE_CNT | SetCityCode:1448 | SELECT SCP_MST_DISTRIBUTION_ROUTE | 하. 단일 테이블 |
| `SCP0005_GET_DISTRIBUTION_ROUTE` | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 팝업 FindDataMain:436 | SELECT SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL, REF FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT | 중. 함수 1개 + STRING_SPLIT. SCP0005 화면과 공유하는 SP |

### 1-1. `SCP0007_SAVE_BOD` EXEC 체인 / 참조 상세
| 구분 | 객체 |
|---|---|
| EXEC(하위 SP) | PR_SCP_MST_BOD_HIST, PR_SCP_MST_BOD_ITEM, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| MERGE | SCP_MST_BOD |
| DELETE | SCP_MST_BOD |
| INSERT | SCP_MST_BOD_ITEM, SCP_MST_BOD_H, SCM_SYS_LOG_BATCH, #TMP_SCM_MST_SITE_ITEM |
| UPDATE | SCP_MST_BOD_ITEM, X(별칭, 실제 대상 **확인 필요**) |
| SELECT | SCP_MST_BOD, SCP_MST_BOD_ITEM, SCP_MST_DISTRIBUTION_ROUTE, SCM_MST_SITE_ITEM, SCP_MST_FINAL_ITEM_V, SCM_MST_SITE, #TMP_SCM_MST_SITE_ITEM |
| REF(함수/객체) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_NEXT_DAY, STRING_SPLIT |

- 화면은 저장 뒤 `dtErr.Rows[0]["ERR_MESSAGE"]`(SaveData_Main:930)를 읽는다. Oracle 전환본도 오류 메시지 결과셋 계약(컬럼명 ERR_MESSAGE)을 유지해야 하는지 **확인 필요**하다.

## 2. 공통코드 분기 (biz:CommonData → UP_FX_GetCommonDataList)

| code | 호출 위치 | 분기 SP | 참조 테이블 |
|---|---|---|---|
| BodType | 팝업 GetBodType:569 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| COUNTRY_MST | 팝업 dtFromCountry:44, dtToCountry:46 | UP_FX_GetCommonDataList | SCM_MST_COUNTRY |
| FromSiteByDivision | 팝업 GetFromSitebyDivision:549 | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, STRING_SPLIT |
| ToSiteByDivision | 팝업 GetToSitebyDivision:557 | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, STRING_SPLIT |
| incotermsEdit | 메인 dtIncotermsEdit:69 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| LookupCommon | 메인 dtIncoterms:65, dtTransMode:66 / 팝업 dtTransMode:49 / EditButton:490 (`"INCOTERMS"`) | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| MyDivision | 팝업 GetDivision:540 | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| TransportMode | 팝업 GetTransMode:579 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| (YesOrNo) | 메인 dtValidYN:68 / 팝업 dtYesOrNo:48 | `Data.CallBizData` (CommonDataList 아님) | DB 보강 없음. 원천 **확인 필요** |

- LookupCommon의 lookup 마스터 코드값은 EditButton:490의 `"INCOTERMS"`만 확인된다. dtIncoterms(65)와 dtTransMode(66, 49)에 넘기는 코드값은 Fact Pack에 없다(**확인 필요**).

## 3. FoxQuery 미등록 / 직접호출 SP
- FoxQuery 엔드포인트 5개(`SCP.SCP0007_GET_BOD`, `SCP.SCP0007_GET_COUNTRY_CITY`, `SCP.SCP0007_SAVE_BOD`, `SCP.SCP0007_GET_ROUTE_CNT`, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`)는 모두 **MATCH**이고, 미등록 건은 0건이다.
- 확인 필요 0건, 주석 처리된 호출 0건.
- 엔드포인트를 특정하지 못한 데이터 로딩:
  - 메인 필드 dtFromSiteAll(55), dtFromSiteOfSpdAll(60), dtToSiteOfSpdAll1(63), dtToSiteOfSpdAll2(64): `NowGroupID`를 읽지만 호출 엔드포인트가 endpoints.csv에 없다.
  - InsertButton:387 `BLUtils.GetDivisionWithoutEE(false, "")`: 원천 SP **확인 필요**.

## 4. Oracle 전환 시 확인 포인트 (Fact Pack 근거)
| # | 대상 | 근거 | 확인 포인트 |
|---|---|---|---|
| 1 | STRING_SPLIT | SCP0007_GET_BOD, GET_COUNTRY_CITY, SAVE_BOD, SCP0005_GET_DISTRIBUTION_ROUTE, UP_FX_GetCommonDataList(_SCP) | MSSQL 전용 함수다. 멀티선택 조회조건(GetCheckedListValue: FindData_Main 517/518/530~534)의 구분자 문자열을 Oracle에서 분해하는 방식으로 대체해야 한다 |
| 2 | 동적 SQL | DYNAMIC@SCP0007_GET_BOD | 동적 문자열 안의 MSSQL 구문(함수·TOP·+연결 등)은 원문을 확인해야 알 수 있다. 결과 컬럼과 BOD 메타 39개 컬럼을 대조해야 한다 |
| 3 | 임시테이블 | #TMP_SCM_MST_SITE_ITEM (SAVE_BOD) | Oracle GTT 등으로 대체 필요. DDL 확보 필요 |
| 4 | MERGE / DELETE | SCP_MST_BOD (SAVE_BOD) | MERGE ON 키와 PK가 일치하는지 실측해야 한다 |
| 5 | UPDATE:X | SAVE_BOD | 별칭 기반 UPDATE(FROM 조인형 가능성)의 실제 대상 테이블과 구문 확인 |
| 6 | 하위 SP 체인 | PR_SCP_MST_BOD_HIST, PR_SCP_MST_BOD_ITEM, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN | 하위 SP 각각의 전환 상태와 트랜잭션(COMMIT) 경계 확인 |
| 7 | 함수 | FN_NEXT_DAY, FN_GET_LOOKUP_CODE_DESC, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | Oracle 대응 함수가 있는지 확인 |
| 8 | 뷰 | SCP_MST_FINAL_ITEM_V | 뷰가 Oracle에 있는지 확인 |
| 9 | 결과 컬럼 대소문자 | SetCityCode:1460 `route_cnt`(소문자) | Oracle은 별칭을 대문자로 반환하므로, 화면이 기대하는 키 이름을 확인해야 한다 |
| 10 | 공유 SP | SCP0005_GET_DISTRIBUTION_ROUTE | SCP0005 화면과 같은 SP를 쓴다. 수정하면 양쪽에 영향이 있다 |
| 11 | 공통코드 SP 2종 | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | FromSite/ToSiteByDivision이 두 SP 중 어느 쪽을 타는지 분기 조건 확인 |

## 5. 메타 데이터 이관 대상 (화면 ID 포함 행)
| 메타 테이블 | 행 수 |
|---|---:|
| dbo.SCM_MST_SHEET_COLUMNS | 39 |
| dbo.TB_FX_SearchCondition | 473 |
| dbo.TB_FX_Favorite | 71 |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 65 |
| dbo.TB_FX_GroupMenuAuth | 13 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 8 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 |
| dbo.TB_FX_MenuItemInfo | 1 |
| dbo.TB_FX_ProgramInfo | 1 |
