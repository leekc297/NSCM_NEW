=== FILE: business_analysis.md ===
# SCP0007 업무분석서 (AS-IS 사실 기반)

> 근거는 AsisFacts Fact Pack(SCP0007)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)뿐이다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> 주석 처리된 호출(commented_calls)은 0건이다. 이 문서의 모든 호출은 현행(활성) 코드 기준이다.
> 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같은 표기를 쓴다.

---

## 1. 업무 목적·범위

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0007 |
| 메인 폼 | `SCP0007_BOD` (폼 Text `"SCP0007_BOD"`) — 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD` |
| 연동 팝업 | `SCP0007_DistributionRoutePopup` (폼 Text `"Distribution Route Popup"`) — 공용 프로젝트 `GSCM.SCM.Popup.UIL` |
| 업무 대상 | BOD 마스터. 저장 SP가 `SCP_MST_BOD`(MERGE/DELETE), `SCP_MST_BOD_ITEM`(INSERT/UPDATE), `SCP_MST_BOD_H`(INSERT)에 쓴다. "BOD"의 업무 정식 명칭은 Fact Pack에 없다 (**확인 필요**) |
| 업무 범위(사실로 확인됨) | ① BOD 조회 ② 행 추가(InsertButton) ③ 수정(EditButton) ④ 저장(SaveButton) ⑤ From/To Site 변경 시 Route 건수 조회 ⑥ Distribution Route 팝업 조회(경로 정보 참조) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행이 있지만 값은 Fact Pack에 없음) |
| 범위 밖 | 삭제 전용 버튼 핸들러(DeleteButton 등)는 Fact Pack에 없다. 다만 저장 SP 안에 `DELETE:SCP_MST_BOD`가 있다 (§4 R12) |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 연다 | 메인 `Form_Load` 실행. CreateSpread에서 시트 `BOD`를 만들고(AddSheet, 2단 헤더), InitSpread에서 `SetSheetHeaderColumn(siMain, 2)`로 메타 컬럼을 구성한다. `SAFETY_STOCK`은 Visible=false. 공통코드 필드(dtIncoterms·dtTransMode·dtValidYN·dtIncotermsEdit)가 `biz:CommonData.CommonDataList`, `biz:CommonData.YesOrNo`를 호출한다. 파서는 이 호출을 '진입점 미연결'로 분류했다 | 조회조건과 빈 BOD 그리드가 표시된다. 콤보 바인딩 대상과 시점은 **확인 필요** |
| S2 | 조회조건(Div, From Site, To Site, Incoterms, Trans Mode, SSP Incoterms, Valid, Input Status)을 고르고 조회한다 | FindButton → `GetData_Country` → `SCP.SCP0007_GET_COUNTRY_CITY`(SP `SCP0007_GET_COUNTRY_CITY`), FindButton → `FindData_Main` → `SCP.SCP0007_GET_BOD`(SP `SCP0007_GET_BOD`). 멀티선택 값은 `GetCheckedListValue`(CODE)로 넘긴다 | BOD 시트에 결과가 표시된다. 두 호출의 순서와 GET_COUNTRY_CITY 결과의 용도는 **확인 필요** |
| S3 | 행을 추가한다(InsertButton) | 조건 `strSel_InputStatus == "C"`, `fps.Name == "spdMain"`, 시트 잠금 아님, `siMain.SheetName == "BOD"`일 때 활성 행에 셀 콤보를 설정한다: DIVISION_ID ← dtMyDivision(`BLUtils.GetDivisionWithoutEE`), INCOTERMS·INCOTERMS_SSP ← dtIncotermsEdit(`biz:CommonData.CommonDataList` [code=incotermsEdit]) | 새 행에 Division·Incoterms·Incoterms SSP 콤보가 생긴다 |
| S4 | 수정 모드로 전환한다(EditButton) | 전체 행을 돌며 To Site의 `SITE_TYPE == "PLANT"`인 행의 INCOTERMS_SSP 셀 콤보를 설정한다. `boolEditChange == true`면 dtIncotermsEdit, 아니면 LookupCommon `"INCOTERMS"` | PLANT 행의 Incoterms SSP 콤보 후보가 바뀐다 |
| S5 | 그리드에서 From Site 콤보를 고른다 | `SpdMain_ComboSelChange`: 시트 잠금이 아니고 변경 컬럼이 `FROM_SITE_CODE`면, `sFromSite == "E"` 또는 `sFromSite == "A" && sOspYn == "Y"` 분기에서 TO_SITE_CODE 셀 콤보를 필터한 목록으로 다시 바인딩한다 | To Site 콤보 후보가 좁혀진다. 필터식(filterExpression) 내용은 **확인 필요** |
| S6 | From/To Site 셀 값을 바꾼다 | `SpdMain_Changed` → `SetCityCode`: From의 COUNTRY·CITY, To의 COUNTRY·CITY·VMI_YN·SITE_TYPE을 읽은 뒤 `SCP.SCP0007_GET_ROUTE_CNT`(SP `SCP0007_GET_ROUTE_CNT`)를 호출하고 결과 `route_cnt`를 읽는다 | 행의 국가·도시·VMI 관련 값과 Route 건수가 반영된다. 반영 대상 컬럼(ROUTE_CNT 등)은 **확인 필요** |
| S7 | 셀을 붙여넣는다 / 편집한다 | `SpdMain_ClipboardPasted`(OSP_YN, CITY 참조), `SpdMain_EditChange`(To SITE_TYPE 참조) | 세부 동작은 **확인 필요** |
| S8 | BOD 셀을 더블클릭한다 | 메인 `spdMain_CellDoubleClick`: 실행 중 `SpdMain_Changed`를 해제(1073)했다가 다시 등록(1104)한다. 그 사이에 `dr`에서 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~DAYS_SUN, VALID_YN, LT_SUM, LT_TYPE를 읽는다 | Route 관련 값이 BOD 행에 반영되는 것으로 보인다. 팝업 호출문과 대상 컬럼 매핑은 **확인 필요** |
| S9 | Distribution Route 팝업이 열린다 / 팝업에서 조회한다 | 팝업 `Form_Load`, FindButton, `btnButtonList_UsrButtonList_Click_Detected` → `FindDataMain` → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`(SP `SCP0005_GET_DISTRIBUTION_ROUTE`). txtFromCountry/txtFromCity/txtToCountry/txtToCity에 생성자 값(sFromCountry 등)을 넣고 Enabled=false로 둔다 | 시트 `Distribution Route`에 경로 목록이 표시된다 |
| S10 | 저장한다(SaveButton) | `SaveData_Main` → `SCP.SCP0007_SAVE_BOD`(SP `SCP0007_SAVE_BOD`). 결과 `dtErr.Rows[0]["ERR_MESSAGE"]`를 읽고, `FindData_Main` → `SCP.SCP0007_GET_BOD`로 다시 조회한다 | BOD·BOD_ITEM·이력·로그 테이블이 반영되고 그리드가 새로 고쳐진다. 오류일 때 재조회하는지는 **확인 필요** |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (메인 Form_Load)
     ├─ 시트 BOD 생성 (AddSheet "BOD", 헤더 2단) → SetSheetHeaderColumn(메타 SCM_MST_SHEET_COLUMNS 39행)
     ├─ SAFETY_STOCK 숨김 (InitSpread:338)
     └─ 공통코드 필드 초기화: biz:CommonData.CommonDataList [LookupCommon / incotermsEdit], biz:CommonData.YesOrNo
            (파서 분류 '진입점 미연결' — 실행 시점 확인 필요)
[2] 조회 (FindButton)
     ├─ GetData_Country  → SCP.SCP0007_GET_COUNTRY_CITY → SP SCP0007_GET_COUNTRY_CITY (SCM_MST_SITE)
     └─ FindData_Main    → SCP.SCP0007_GET_BOD          → SP SCP0007_GET_BOD (동적 SQL)
            ※ [2]의 두 호출 순서 확인 필요
[3] 편집
     ├─ InsertButton (Input Status = "C", 시트 BOD, 잠금 아님) → DIVISION_ID / INCOTERMS / INCOTERMS_SSP 셀 콤보
     ├─ EditButton  (To SITE_TYPE = "PLANT") → INCOTERMS_SSP 콤보 (boolEditChange 분기)
     ├─ SpdMain_ComboSelChange (FROM_SITE_CODE 변경) → TO_SITE_CODE 콤보 필터 재바인딩
     ├─ SpdMain_Changed > SetCityCode → SCP.SCP0007_GET_ROUTE_CNT → SP SCP0007_GET_ROUTE_CNT → route_cnt
     ├─ SpdMain_ClipboardPasted / SpdMain_EditChange / SpdMain_KeyPress / SpdMain_TopChange
     └─ spdMain_CellDoubleClick (SpdMain_Changed 해제 → Route 컬럼 반영 → 재등록)
            └─(호출 방식 확인 필요)→ [4]
[4] Distribution Route 팝업
     ├─ Form_Load / FindButton / btnButtonList_UsrButtonList_Click_Detected
     │     → FindDataMain → SCP.SCP0005_GET_DISTRIBUTION_ROUTE → SP SCP0005_GET_DISTRIBUTION_ROUTE
     ├─ btnFromSrch_Click / btnToSrch_Click → popCity.Country·City → txtFrom*/txtTo* (버튼 초기 Enabled=false)
     └─ spdMain_CellDoubleClick / spdMainDataModel_Changed (동작 확인 필요)
[5] 저장 (SaveButton)
     └─ SaveData_Main → SCP.SCP0007_SAVE_BOD → SP SCP0007_SAVE_BOD
            → ERR_MESSAGE 확인 → FindData_Main → SCP.SCP0007_GET_BOD (재조회)
```

---

## 4. 업무 규칙 (사실 근거)

| ID | 규칙 | 근거(코드 위치) | 비고 |
|---|---|---|---|
| R01 | 행 추가 시 셀 콤보 설정은 **Input Status = "C"**일 때만 한다 (`else!(strSel_InputStatus == "R")` → `if(strSel_InputStatus == "C")`) | InsertButton:387/424/425 | "R"일 때의 동작은 **확인 필요** |
| R02 | 행 추가 셀 콤보는 `fps.Name == "spdMain"`, `siMain.IsLock(siMain.SheetName) == false`, `siMain.SheetName == "BOD"`를 모두 만족해야 설정한다 | InsertButton 분기 체인 | 시트 잠금 조건의 원천은 **확인 필요** |
| R03 | 새 행의 DIVISION_ID 후보 = `BLUtils.GetDivisionWithoutEE(false, "")` 결과(dtMyDivision) | InsertButton:387 | 함수명으로 보면 EE 계열을 빼는 것으로 보이나 원천 엔드포인트는 **확인 필요** |
| R04 | 새 행의 INCOTERMS, INCOTERMS_SSP 후보 = `biz:CommonData.CommonDataList` [code=incotermsEdit] | InsertButton:424/425 | |
| R05 | 수정 시 To Site의 `SITE_TYPE == "PLANT"`인 행만 INCOTERMS_SSP 콤보를 다시 설정한다. `boolEditChange == true`면 incotermsEdit, 아니면 LookupCommon `"INCOTERMS"` | EditButton:476/484/490 | `boolEditChange`가 설정되는 위치는 **확인 필요** |
| R06 | From Site 콤보를 바꾸면(시트 잠금 아님, 컬럼 = `FROM_SITE_CODE`) `sFromSite == "E"`이거나 `sFromSite == "A" && sOspYn == "Y"`(그리고 `dr != null`)일 때 TO_SITE_CODE 콤보를 dtToSiteOfSpdAll/1/2를 필터한 결과로 다시 바인딩한다 | SpdMain_ComboSelChange:1140~1176 | `sFromSite` 값의 의미와 filterExpression은 **확인 필요** |
| R07 | From/To Site 변경 시 From(COUNTRY, CITY)와 To(COUNTRY, CITY, VMI_YN, SITE_TYPE)를 읽은 뒤 `SCP.SCP0007_GET_ROUTE_CNT`로 Route 건수(`route_cnt`)를 조회한다 | SetCityCode:1368~1460 | SP 파라미터와 0건일 때의 처리는 **확인 필요** |
| R08 | `SpdMain_Changed`는 자기 안에서(1284 해제 / 1315 재등록), 그리고 `spdMain_CellDoubleClick` 안에서(1073 해제 / 1104 재등록) 이벤트를 잠시 해제한다. 프로그램이 값을 넣는 동안 Route 건수 재조회가 연쇄로 일어나지 않게 막는 구조다 | events.csv | |
| R09 | 저장 결과는 `ERR_MESSAGE`(결과셋 첫 행)로 판정하고 표시한다. 저장 뒤 `FindData_Main`으로 다시 조회한다 | SaveData_Main:794/930 | 성공/실패 판정 값, 메시지 ID, 오류 시 재조회 여부는 **확인 필요** |
| R10 | BOD 그리드의 SAFETY_STOCK은 코드에서 숨긴다(Visible=false). 메타에서도 숨김이다 | InitSpread:338, grid_effective | |
| R11 | BOD 그리드는 메타 39개 컬럼 가운데 34개를 표시하고 5개(BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY)를 숨긴다. 메타 라벨에 `*`가 붙은 컬럼은 10개다: BOD Valid\*, Division\*, From Site\*, FROM\*, Incoterms\*, Incoterms SSP\*, Priority\*, Route Id\*, To Site\*, TO\* | grid_effective.csv | `*`가 필수 입력을 뜻하는지(검증 로직이 있는지)는 **확인 필요** |
| R12 | 저장 SP는 `SCP_MST_BOD`에 MERGE와 DELETE를 함께 실행한다. 한 번의 저장으로 신규/수정/삭제가 함께 처리될 수 있다 | `SCP0007_SAVE_BOD` 참조 객체 | 행 상태별 분기 조건은 **확인 필요** |
| R13 | 저장 SP는 `SCM_MST_SITE_ITEM`, `SCP_MST_FINAL_ITEM_V`, `SCM_MST_SITE`를 읽고 `#TMP_SCM_MST_SITE_ITEM`을 거쳐 `SCP_MST_BOD_ITEM`을 INSERT/UPDATE한다. `PR_SCP_MST_BOD_ITEM`, `PR_SCP_MST_BOD_HIST`를 EXEC한다 | `SCP0007_SAVE_BOD` 참조 객체 | BOD↔품목 전개 규칙은 **확인 필요** |
| R14 | 날짜 규칙: BOD에 `FROM_YYYYMMDD`(FROM\*), `TO_YYYYMMDD`(TO\*) 컬럼이 있고, 저장 SP가 `FN_NEXT_DAY`를 참조한다 | grid_effective, SAVE_BOD 참조 | 기간 중복·연속성 검증 여부, FN_NEXT_DAY 적용 대상은 **확인 필요**. 버킷(주/월) 규칙은 Fact Pack에 없다 |
| R15 | 요일 규칙: BOD에 `DAYS_MON`~`DAYS_SUN`이 있고, Distribution Route에도 같은 컬럼(YesOrNo 콤보)이 있다. 더블클릭 시 Route의 DAYS_*를 읽는다 | meta_reads, grid_code | 요일 값이 BOD에 복사되는지는 **확인 필요** |
| R16 | 팝업의 From/To 국가·도시 텍스트와 검색 버튼, Trans Mode는 초기에 Enabled=false다 | 팝업 InitControls:214~222 | 활성화 조건은 **확인 필요** |
| R17 | SP 내부 분기 조건(파라미터 값에 따른 IF 분기 등)은 Fact Pack에 SP 원문이 없어 추출하지 못했다 | – | **확인 필요** |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | code | SP | 읽기 | 쓰기 | 호출 위치 |
|---|---|---|---|---|---|
| `SCP.SCP0007_GET_BOD` | – | `SCP0007_GET_BOD` | 동적 SQL(DYNAMIC@SCP0007_GET_BOD)이라 정적으로 확정하지 못함. REF STRING_SPLIT | – | FindData_Main:553 (FindButton, SaveButton 뒤 재조회) |
| `SCP.SCP0007_GET_COUNTRY_CITY` | – | `SCP0007_GET_COUNTRY_CITY` | SCM_MST_SITE, REF STRING_SPLIT | – | GetData_Country:626 (FindButton) |
| `SCP.SCP0007_GET_ROUTE_CNT` | – | `SCP0007_GET_ROUTE_CNT` | SCP_MST_DISTRIBUTION_ROUTE | – | SetCityCode:1448 (dsdm.Changed → SpdMain_Changed) |
| `SCP.SCP0007_SAVE_BOD` | – | `SCP0007_SAVE_BOD` | SCP_MST_DISTRIBUTION_ROUTE, SCP_MST_BOD, SCM_MST_SITE_ITEM, SCP_MST_FINAL_ITEM_V, SCM_MST_SITE, SCP_MST_BOD_ITEM, #TMP_SCM_MST_SITE_ITEM. REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_NEXT_DAY, STRING_SPLIT | MERGE/DELETE SCP_MST_BOD, INSERT/UPDATE SCP_MST_BOD_ITEM, INSERT SCP_MST_BOD_H, INSERT SCM_SYS_LOG_BATCH, INSERT #TMP_SCM_MST_SITE_ITEM, UPDATE X(별칭, 대상 **확인 필요**). EXEC PR_SCP_MST_BOD_HIST, PR_SCP_MST_BOD_ITEM, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SaveData_Main:794 (SaveButton) |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | – | `SCP0005_GET_DISTRIBUTION_ROUTE` | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL. REF FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT | – | 팝업 FindDataMain:436 (Form_Load, FindButton, btnButtonList_UsrButtonList_Click_Detected) |
| `biz:CommonData.CommonDataList` | LookupCommon | (UP_FX_GetCommonDataList 코드분기) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | – | 메인 dtIncoterms:65, dtTransMode:66 / 팝업 dtTransMode:49. EditButton:490 `"INCOTERMS"` |
| `biz:CommonData.CommonDataList` | incotermsEdit | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER_DETAIL | – | 메인 dtIncotermsEdit:69 (InsertButton, EditButton) |
| `biz:CommonData.CommonDataList` | COUNTRY_MST | (UP_FX_GetCommonDataList) | SCM_MST_COUNTRY | – | 팝업 dtFromCountry:44, dtToCountry:46 |
| `biz:CommonData.CommonDataList` | MyDivision | (UP_FX_GetCommonDataList) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | – | 팝업 GetDivision:540 (진입점 미연결) |
| `biz:CommonData.CommonDataList` | FromSiteByDivision | (UP_FX_GetCommonDataList / _SCP) | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT | – | 팝업 GetFromSitebyDivision:549 (진입점 미연결) |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | (UP_FX_GetCommonDataList / _SCP) | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT | – | 팝업 GetToSitebyDivision:557 (진입점 미연결) |
| `biz:CommonData.CommonDataList` | BodType | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER_DETAIL | – | 팝업 GetBodType:569 (진입점 미연결) |
| `biz:CommonData.CommonDataList` | TransportMode | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER_DETAIL | – | 팝업 GetTransMode:579 (진입점 미연결) |
| `biz:CommonData.YesOrNo` | – | 없음(DB 보강 없음) | 원천 **확인 필요** | – | 메인 dtValidYN:68 / 팝업 dtYesOrNo:48 (Distribution Route의 VALID_YN, DAYS_MON~SUN 콤보) |

- SP 5종 요약: `SCP0007_GET_BOD`, `SCP0007_GET_COUNTRY_CITY`, `SCP0007_SAVE_BOD`, `SCP0007_GET_ROUTE_CNT`, `SCP0005_GET_DISTRIBUTION_ROUTE`.
- 호출 경로: `biz:CommonData.CommonDataList` = `Data.Common[case Type.*] > Data.CallBizCommonData` / `biz:CommonData.YesOrNo` = `Data.Common[case Type.YesOrNo] > Data.CallBizData`.
- dtFromSiteAll(55), dtFromSiteOfSpdAll(60), dtToSiteOfSpdAll1(63), dtToSiteOfSpdAll2(64)는 `NowGroupID`를 쓰지만, 이 필드들이 부르는 엔드포인트는 endpoints.csv에 없다 (**확인 필요**).

---

## 6. division·권한별 변형

| 구분 | 사실 | 비고 |
|---|---|---|
| Grid 표시(division) | `BOD`: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 표시 34 / 숨김 5로 같다. `Distribution Route`: 모두 33(코드추가)으로 같다 | 코드에서 division 비교 분기는 0건 |
| 행 추가 Division 후보 | `BLUtils.GetDivisionWithoutEE(false, "")` | EE 제외 여부는 함수명에서 짐작한 것이다 (**확인 필요**) |
| 사용자 그룹 데이터 범위 | `UserInfoContext.Current.NowGroupID`를 메인 필드 55/60/63/64와 팝업 UserGroup:58에서 읽는다. 공통코드 MyDivision, FromSiteByDivision, ToSiteByDivision이 TB_FX_USERGROUPAUTHEXTENTION을 참조한다 | 그룹에 따라 Site·Division 후보가 달라지는 구조 |
| 메뉴 권한(C/R/U/D) | TB_FX_GroupMenuAuth 13행, TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행이 있다 | 그룹별 C/R/U/D 값은 **확인 필요** |
| 시트 잠금 | `siMain.IsLock(siMain.SheetName)`이 InsertButton과 ComboSelChange를 막는다 | 잠금 설정 조건은 **확인 필요** |
| 조회조건 저장 | TB_FX_SearchCondition 473행 | 구조와 용도는 **확인 필요** |

---

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없다.
- 저장 SP가 `INSERT:SCM_SYS_LOG_BATCH`, `EXEC:PR_SCM_SYS_LOG_BATCH`, `EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 실행한다. 이것이 내부 실행 로그인지 다른 배치·외부 호출로 이어지는지는 **확인 필요**다.

---

## 8. 미확정·확인 필요

| # | 항목 | 확인 방법(제안) |
|---|---|---|
| Q01 | `SCP0007_GET_BOD` 동적 SQL의 참조 테이블과 결과 컬럼. 결과 시트 매칭이 없어 BOD 메타 39컬럼과 맞는지 모른다 | SP 원문 확인과 실행 결과 컬럼 대조 |
| Q02 | FindButton 안에서 GetData_Country와 FindData_Main의 호출 순서, `SCP0007_GET_COUNTRY_CITY` 결과의 용도 | SCP0007_BOD.cs FindButton 원문 |
| Q03 | 조회조건 컨트롤과 SP 파라미터 매핑(GetCheckedListValue 517/518/530~534), 각 조회조건의 데이터 원천 | FindData_Main 원문 |
| Q04 | Input Status `"R"` 분기 동작 | InsertButton 원문 |
| Q05 | 메인 더블클릭에서 팝업을 여는 방식, 생성자 인자(sFromCountry/sFromCity/sToCountry/sToCity), 반환 컬럼 매핑 | spdMain_CellDoubleClick 1068~1104 원문 |
| Q06 | `ERR_MESSAGE` 판정 규칙, 메시지 ID, 오류 시 재조회 여부 | SaveData_Main 794~930 원문 |
| Q07 | SAVE_BOD의 `UPDATE:X` 대상, 행 상태(신규/수정/삭제) 분기, BOD_ITEM 전개 규칙 | SP 원문 |
| Q08 | `biz:CommonData.YesOrNo` 원천, `BLUtils.GetDivisionWithoutEE` 원천 | 프레임워크 원문 |
| Q09 | 팝업 메서드 GetDivision/GetFromSitebyDivision/GetToSitebyDivision/GetBodType/GetTransMode의 호출 경로('진입점 미연결') | 팝업 원문 |
| Q10 | `cboDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdMain_KeyPress`, 팝업 `spdMain_CellDoubleClick`, `spdMainDataModel_Changed`의 내부 동작 | 원문 |
| Q11 | TB_FX_GroupMenuAuth 13행의 C/R/U/D 값, 메뉴 위치 | 메타 CSV |
| Q12 | 라벨 `*` 컬럼에 대한 필수 검증이 FE/SP에 있는지 | SaveData_Main, SAVE_BOD 원문 |

=== FILE: screen_design.md ===
# SCP0007 화면설계서 (AS-IS 사실 → TO-BE)

> 근거는 Fact Pack(controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv)과 1차 분석서뿐이다. 없는 사실은 **확인 필요**로 적었다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 메인 | 팝업 |
|---|---|---|
| 화면 ID | SCP0007 | SCP0007 연동 팝업 |
| 클래스 | `SCP0007_BOD` | `SCP0007_DistributionRoutePopup` |
| 폼 Text(원문) | `"SCP0007_BOD"` (Designer:626) | `"Distribution Route Popup"` (Designer:640) |
| 소속 | current (`GSCM.SCP.Forms.UIL\Master\SCP0007_BOD`) | shared (`GSCM.SCM.Popup.UIL`) |
| 시트 | `BOD` (META+코드연결) | `Distribution Route` (코드 하드코딩 전용, 메타 없음) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) | 〃 |
| 메뉴 위치 | **확인 필요** | – |

---

## 2. 화면 레이아웃

### 2-0. 분할 방식
- props.csv에 **SplitContainer(Orientation·SplitterDistance)가 없다(0건)**. 화면은 `Dock`(Top/Fill)으로만 나뉜다. 아래 트리는 controls.csv의 parent 체인과 props.csv의 Dock·Size로 그렸다.
- 비율 % = 높이 기준(Top 높이 ÷ (Top + Fill 높이)).
- LayoutControlItem의 Location 값은 Fact Pack에 없다. 행 안의 배치는 **크기(Size) 일치로 추정**했으며, 좌우 순서와 상하 행은 **확인 필요**다.

### 2-1. 메인 `SCP0007_BOD`

```
this (SCP0007_BOD, 1168 × 592 추정 = 69 + 523)
│
├─ usrConditionPanel1   Dock=Top  1168×69  UsrPanelType=HidePanel        ◀ 상 11.7%  [조회조건 영역]
│   └─ usrLayoutControl2   Dock=Fill 1168×69  (Text "usrLayoutControl2")
│        └─ layoutControlGroup2  1168×69
│             ┌──────────────────┬─────────────────┬─────────────────┬────────────────────┬──────────┐
│   행A(h25) │ Input Status 263 │ Valid 249       │ Trans Mode 248  │ SSP Incoterms 212  │ (빈칸)176 │
│             │ cboInputStatus   │ cboValidYN      │ clbTransMode    │ clbIncotermsSSP    │ emptySp1 │
│             ├──────────────────┼─────────────────┼─────────────────┼────────────────────┼──────────┤
│   행B(h24) │ From Site 263    │ To Site 249     │ Div 248         │ Incoterms 212      │ (빈칸)176 │
│             │ clbFromSite      │ clbToSite       │ clbDivision     │ clbIncoterms       │ emptySp3 │
│             └──────────────────┴─────────────────┴─────────────────┴────────────────────┴──────────┘
│             열 폭 비율(합 1148): 22.9% │ 21.7% │ 21.6% │ 18.5% │ 15.3%   ※ 열 정렬은 Size 일치로 추정
│
├─ spdMain   Dock=Fill  1168×523   Sheet "BOD" (spdMain_Sheet1)              ◀ 하 88.3%  [그리드 영역]
│
└─ (usrLayoutControl1  Dock=Fill 657×184, layoutControlGroup1 657×184 — parent 미기록. 배치 위치 확인 필요)

[버튼 영역] 메인 Designer에 버튼 컨트롤이 없다. FindButton / SaveButton / InsertButton / EditButton은
            프레임워크 공통 툴바의 진입점(override 메서드)으로 보인다 → 위치 확인 필요
[팝업 영역] Distribution Route Popup (§2-2). 메인에서 여는 방식은 확인 필요
```

### 2-2. 팝업 `SCP0007_DistributionRoutePopup`

```
this ("Distribution Route Popup", 1084 × 413 추정 = 78 + 335)
│
├─ usrConditionPanel1   Dock=Top  1084×78  UsrPanelType=HidePanel        ◀ 상 18.9%  [조회조건·버튼 영역]
│   └─ usrLayoutControl2   Dock=Fill 1084×78  (Text "usrLayoutControl2")
│        └─ layoutControlGroup2  1084×78   (항목 높이 모두 29 → 2행으로 추정)
│             행1 추정(합 1064): [From Country 268 txtFromCountry][From City 246 txtFromCity][btnFromSrch 43]
│                                [emptySpaceItem5 317][emptySpaceItem7 190]
│             행2 추정(합 1064): [ To Country 268 txtToCountry][ To City 246 txtToCity][btnToSrch 43]
│                                [Trans Mode 243 clbTransMode][emptySpaceItem1 10][emptySpaceItem6 35][btnButtonList 219]
│             ※ 행 구성은 폭 합(1064)이 맞는 조합으로 추정한 것이다. 실제 Location 확인 필요
│
├─ spdMain   Dock=Fill  1084×335   Sheet "Distribution Route" (spdMain_Sheet1)   ◀ 하 81.1%  [그리드 영역]
│
└─ (usrLayoutControl1  Dock=Fill 657×184 — parent 미기록. 확인 필요)
```

---

## 3. 컨트롤 명세

> 라벨 = props.csv에서 해당 컨트롤을 담는 LayoutControlItem의 `Text` 원문(따옴표 안 공백 포함). 라벨 항목이 없으면 "–".
> 필수 여부: Fact Pack에 조회조건 필수 검증 사실이 없다. 모두 **확인 필요**.

| # | 컨트롤명 | 소속 | 타입 | 라벨(props Text 원문) | 초기값 / 크기 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrLayoutControl1 | 메인·팝업 | UsrLayoutControl | – | Dock=Fill, 657×184 (parent 미기록) | – | – | 미사용 여부 **확인 필요** (레이아웃 컨테이너) |
| 2 | usrConditionPanel1 | 메인·팝업 | UsrConditionPanel | – | Dock=Top, HidePanel. 메인 1168×69 / 팝업 1084×78 | – | – | 공통 조회조건 패널(접기 가능) |
| 3 | usrLayoutControl2 | 메인·팝업 | UsrLayoutControl | `"usrLayoutControl2"` (컨트롤 자체 Text) | Dock=Fill. 메인 1168×69 / 팝업 1084×78 | – | – | 조회조건 Grid 레이아웃 |
| 4 | clbDivision | 메인 | UsrCheckedList2 | `"Div"` (layoutDivision) | 223×21. 초기값 **확인 필요** | 확인 필요 | SelectedIndexChanged → `cboDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 5 | clbFromSite | 메인 | UsrCheckedList2 | `"From Site"` (layoutFrom) | 202×21 | 확인 필요 | – | Wijmo MultiSelect |
| 6 | clbToSite | 메인 | UsrCheckedList2 | `"To Site"` (layoutToSite) | 200×21 | 확인 필요 | – | Wijmo MultiSelect |
| 7 | clbIncoterms | 메인 | UsrCheckedList2 | `"Incoterms"` (layoutIncoterms) | 148×21 | 확인 필요 | – | Wijmo MultiSelect |
| 8 | clbTransMode | 메인 | UsrCheckedList2 | `"Trans Mode"` (layoutTransMode) | 175×21 | 확인 필요 | – | Wijmo MultiSelect |
| 9 | clbIncotermsSSP | 메인 | UsrCheckedList2 | `"SSP Incoterms"` (layoutSSPIncoterms) | 123×21 | 확인 필요 | – | Wijmo MultiSelect |
| 10 | cboValidYN | 메인 | UsrCombo | `"Valid"` (layoutControlItem3) | 215×20. 원천 후보 dtValidYN(`biz:CommonData.YesOrNo`) **확인 필요** | 확인 필요 | – | Wijmo ComboBox |
| 11 | cboInputStatus | 메인 | UsrCombo | `"Input Status"` (layoutControlItem1) | 185×20. 값 `"C"`/`"R"` 분기 존재 | 확인 필요 | – (InsertButton에서 값 참조) | Wijmo ComboBox |
| 12 | spdMain | 메인 | FpSpread | – | Dock=Fill 1168×523, 시트 `BOD` | – | CellDoubleClick → `spdMain_CellDoubleClick` / TopChange → `SpdMain_TopChange` / ComboSelChange → `SpdMain_ComboSelChange` / ClipboardPasted → `SpdMain_ClipboardPasted` / KeyPress → `SpdMain_KeyPress` / EditChange → `SpdMain_EditChange` / dsdm.Changed → `SpdMain_Changed` | Wijmo FlexGrid (2단 헤더) |
| 13 | spdMain_Sheet1 | 메인 | SheetView | – | Designer 시트. 런타임에 AddSheet `BOD` | – | – | FlexGrid 시트 1개 |
| 14 | txtFromCountry | 팝업 | UsrMultiLineEditor | `"From Country"` (layoutControlItem7) | 185×21, Enabled=false, Text=sFromCountry | – | – (btnFromSrch_Click가 값 갱신) | 읽기전용 InputText |
| 15 | txtFromCity | 팝업 | UsrMultiLineEditor | `"From City"` (layoutControlItem8) | 186×21, Enabled=false, Text=sFromCity | – | – | 읽기전용 InputText |
| 16 | btnFromSrch | 팝업 | UsrButton | – (layoutControlItem9, Text 없음) | 39×25, Enabled=false | – | Click → `btnFromSrch_Click` | 검색 아이콘 버튼(초기 비활성) |
| 17 | txtToCountry | 팝업 | UsrMultiLineEditor | `" To Country"` (layoutControlItem1, 앞 공백 원문) | 187×21, Enabled=false, Text=sToCountry | – | – (btnToSrch_Click가 값 갱신) | 읽기전용 InputText |
| 18 | txtToCity | 팝업 | UsrMultiLineEditor | `" To City"` (layoutControlItem2, 앞 공백 원문) | 186×21, Enabled=false, Text=sToCity | – | – | 읽기전용 InputText |
| 19 | btnToSrch | 팝업 | UsrButton | – (layoutControlItem10, Text 없음) | 39×25, Enabled=false | – | Click → `btnToSrch_Click` | 검색 아이콘 버튼(초기 비활성) |
| 20 | clbTransMode | 팝업 | UsrCheckedList | `"Trans Mode"` (layoutControlItem5) | 170×21, Enabled=false | – | – | 읽기전용 MultiSelect |
| 21 | btnButtonList | 팝업 | UsrButtonList | – (layoutControlItem6, Text 없음) | 215×25 | – | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 바 |
| 22 | spdMain | 팝업 | FpSpread | – | Dock=Fill 1084×335, 시트 `Distribution Route` | – | CellDoubleClick → `spdMain_CellDoubleClick` / dsdm.Changed → `spdMainDataModel_Changed` | Wijmo FlexGrid (2단 헤더) |
| 23 | spdMain_Sheet1 | 팝업 | SheetView | – | Designer 시트. 런타임에 AddSheet `Distribution Route` | – | – | FlexGrid 시트 1개 |

- 폼 이벤트: 메인 `this.Load` → `Form_Load`(.ctor:157), 팝업 `this.Load` → `Form_Load`(.ctor:149).
- 기타 컨트롤(ImageList imageList1, LayoutControlGroup, EmptySpaceItem)은 레이아웃·아이콘 보조용이다.

---

## 4. 그리드 명세

### 4-1. 시트 `BOD` (메인, META+코드연결)
- 구성: `CreateSpread:262 AddSheet("BOD", 헤더 2, …)` → `InitSpread:275 SetSheetHeaderColumn(siMain, 2)`. 메타 원천은 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SCP0007) 39행이다.
- 타입·폭·정렬·대문자·FIXED는 메타(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, FIXED_FLAG 등)가 정한다. 행별 값은 Fact Pack에 없어 '메타값(확인 필요)'으로 적었다.
- division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같다. 아래 '표시' 열은 전 division 공통값이다.
- 표시 순서: 아래는 알파벳순이다. 실제 순서(메타 정렬)는 **확인 필요**.
- InitSpread:277 `CellType = cellTypeImage`가 적용되는 컬럼은 **확인 필요**.

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | 표시(전 division) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | AFTER_LEAD_TIME | Additional Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 2 | BEFORE_LEAD_TIME | Before | 메타값 | META | 숨김 | – |
| 3 | BOD_ID | BOD_ID | 메타값 | META | 기본 | 확인 필요 |
| 4 | BOD_VALID | BOD Valid* | 메타값 | META | 기본 | 확인 필요 |
| 5 | CREATED_BY | Created By | 메타값 | META | 기본 | 확인 필요 |
| 6 | CREATION_DATE | Creation Date | 메타값 | META | 기본 | 확인 필요 |
| 7 | CUSTOMER | Customer | 메타값 | META | 기본 | 확인 필요 |
| 8 | DAYS_FRI | Fri | 메타값 | META | 기본 | 확인 필요 |
| 9 | DAYS_MON | Mon | 메타값 | META | 기본 | 확인 필요 |
| 10 | DAYS_SAT | Sat | 메타값 | META | 기본 | 확인 필요 |
| 11 | DAYS_SUN | Sun | 메타값 | META | 기본 | 확인 필요 |
| 12 | DAYS_THU | Thu | 메타값 | META | 기본 | 확인 필요 |
| 13 | DAYS_TUE | Tue | 메타값 | META | 기본 | 확인 필요 |
| 14 | DAYS_WED | Wed | 메타값 | META | 기본 | 확인 필요 |
| 15 | DIS_TOTAL_LEAD_TIME | Distribution Total Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 16 | DIVISION_ID | Division* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:387) | 기본 | 행 추가 시 콤보(dtMyDivision) |
| 17 | FROM_CITY | From City | 메타값 | META | 기본 | 확인 필요(SetCityCode가 값 설정으로 보임) |
| 18 | FROM_COUNTRY | FROM_COUNTRY | 메타값 | META | 숨김 | – |
| 19 | FROM_SITE_CODE | From Site* | 메타값(콤보 추정) | META | 기본 | 편집 → `SpdMain_ComboSelChange` 기준 컬럼 |
| 20 | FROM_YYYYMMDD | FROM* | 메타값 | META | 기본 | 확인 필요 |
| 21 | INCOTERMS | Incoterms* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:424) | 기본 | 행 추가 시 콤보(incotermsEdit) |
| 22 | INCOTERMS_SSP | Incoterms SSP* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:425, EditButton:484/490) | 기본 | 행 추가 시 콤보. 수정 시 To SITE_TYPE=PLANT 행만 콤보 |
| 23 | LAST_UPDATE_DATE | Last Update Date | 메타값 | META | 기본 | 확인 필요 |
| 24 | LAST_UPDATED_BY | Last Updated By | 메타값 | META | 기본 | 확인 필요 |
| 25 | LEAD_TIME | Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 26 | LT_TYPE | L/T Type | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 27 | PRIORITY | Priority* | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 28 | REMARKS | Remarks | 메타값 | META | 기본 | 확인 필요 |
| 29 | ROUTE_CHK | ROUTE_CHK | 메타값 | META | 숨김 | – |
| 30 | ROUTE_CNT | Route Count | 메타값 | META | 기본 | 확인 필요(`route_cnt` 반영 후보) |
| 31 | ROUTE_ID | Route Id* | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 32 | ROUTE_VALID | Route Valid | 메타값 | META | 기본 | 확인 필요 |
| 33 | SAFETY_STOCK | Safety Stock | 메타값 | META + HARDCODED(InitSpread:338 Visible=false) | 숨김 →숨김 | – |
| 34 | TO_CITY | To City | 메타값 | META | 기본 | 확인 필요 |
| 35 | TO_COUNTRY | TO_COUNTRY | 메타값 | META | 숨김 | – |
| 36 | TO_SITE_CODE | To Site* | 셀 콤보(코드 재설정) | META + HARDCODED(ComboSelChange:1146/1154) | 기본 | 편집(필터된 To Site 콤보) |
| 37 | TO_YYYYMMDD | TO* | 메타값 | META | 기본 | 확인 필요 |
| 38 | TRANSPORT_MODE | Trans Mode | 메타값 | META | 기본 | 확인 필요 |
| 39 | VMI_YN | To Site VMI | 메타값 | META | 기본 | 확인 필요(SetCityCode가 To VMI_YN 읽음) |

집계: 표시 34 / 숨김 5 (BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY).

### 4-2. 시트 `Distribution Route` (팝업, 코드 하드코딩 전용)
- 구성: `CreateSpread:247 AddSheet("Distribution Route", 헤더 2, …)` → `InitSpread:264~297` Add*Column 33개 → `301~335` ColumnHeaderSpan(2단 헤더). 메타는 없다.
- division별 표시: 14개 division 모두 33(코드추가)으로 같다. 다만 DAYS_MON~DAYS_SUN 7개는 코드 인자가 `bVisible=false`다. 실제 보이는 컬럼은 26개일 수 있다 (**확인 필요**).
- 편집 가능 여부: Fact Pack에 잠금/편집 설정이 없다 (**확인 필요**).
- 헤더 span: "0행 2칸" = 0행부터 2행 병합. "1행" = 하단 행 1칸. "0행 1칸" = 상단 1칸만 지정(하단 문구 미추출). 302, 311~317줄(상단 그룹 헤더로 보임)은 Fact Pack에 없다 (**확인 필요**).
- 301줄: `CAppSetting.StringAction` 컬럼에 헤더 `"A"`(0행 2칸).

| # | 컬럼 | 헤더 | 타입(API) | 폭 | bVisible | 정렬 | 헤더 span | 출처 |
|---:|---|---|---|---:|---|---|---|---|
| 1 | ROUTE_ID | Route Id | Text(AddTextColumn) | 60 | true | Right | 0행 2칸 | HARDCODED |
| 2 | LT_TYPE | L/T Type | Text | 80 | true | Center | 0행 2칸 | HARDCODED |
| 3 | VALID_YN | Valid | Combo(dtYesOrNo) | 50 | true | Center | 0행 2칸 | HARDCODED |
| 4 | FROM_CITY_NAME | City Name | Text | 130 | true | Left | 1행 | HARDCODED |
| 5 | FROM_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 6 | FROM_CITY | City | ExText(max 3) | 50 | true | Center | 1행 | HARDCODED |
| 7 | TRANSPORT_MODE_NAME | Trans Mode | Text | 60 | true | Center | 0행 2칸 | HARDCODED (원문 인자 `DefColumns.TRANSPORT_MODE`) |
| 8 | PRIORITY | Priority | NumText | 60 | true | Right | 0행 2칸 | HARDCODED |
| 9 | DAYS_MON | Mon | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 10 | DAYS_TUE | Tue | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 11 | DAYS_WED | Wed | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 12 | DAYS_THU | Thu | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 13 | DAYS_FRI | Fri | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 14 | DAYS_SAT | Sat | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 15 | DAYS_SUN | Sun | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 16 | DAYS | Departure Days | Text | 140 | true | Left | 0행 2칸 | HARDCODED |
| 17 | D_PORT_NAME | Port | Text | 80 | true | Left | 0행 1칸 "Port" | HARDCODED |
| 18 | D_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 19 | D_PORT_CODE | Port Code | ExText(max 3) | 70 | true | Center | 1행 | HARDCODED |
| 20 | A_PORT_NAME | Port | Text | 80 | true | Left | 1행 | HARDCODED |
| 21 | A_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 22 | A_PORT_CODE | Port Code | ExText(max 3) | 70 | true | Center | 1행 | HARDCODED |
| 23 | SHIPPING_COMPANY | Shipping Company | ExText(max 3) | 80 | true | Center | 0행 2칸 | HARDCODED |
| 24 | TO_CITY_NAME | City Name | Text | 130 | true | Left | 1행 | HARDCODED |
| 25 | TO_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 26 | TO_CITY | City | ExText(max 3) | 50 | true | Center | 1행 | HARDCODED |
| 27 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Data | Date | 120 | true | Center | 0행 2칸 | HARDCODED |
| 28 | LT_DEPARTURE_INLAND | Departure Inland | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 29 | LT_WAIT_SHIPPING | Waiting For Shipping | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 30 | LT_VOYAGE | Sea/Air Ferry | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 31 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 32 | LT_ARRIVAL_INLAND | Arrival Inland | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 33 | LT_SUM | Sum | NumText | 100 | true | Right | 0행 2칸 | HARDCODED |

- 헤더 기본 스타일(Designer 586~589, 600~603): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`, VerticalAlignment=General.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 메인 화면 로드(this.Load) | `Form_Load` (메인 .ctor:157) | 시트 `BOD` 생성, SetSheetHeaderColumn(2단), SAFETY_STOCK 숨김. 공통코드 필드 초기화 | `biz:CommonData.CommonDataList` [LookupCommon, incotermsEdit], `biz:CommonData.YesOrNo` (파서 분류 '진입점 미연결' — 실행 시점 확인 필요) | 빈 BOD 그리드, 콤보 데이터 |
| A02 | 조회(FindButton) | FindButton → GetData_Country | 국가/도시 조회 | `SCP.SCP0007_GET_COUNTRY_CITY` (SP `SCP0007_GET_COUNTRY_CITY`) | 결과 사용처 확인 필요 |
| A03 | 조회(FindButton) | FindButton → FindData_Main | 조회조건 GetCheckedListValue(CODE) 전달 | `SCP.SCP0007_GET_BOD` (SP `SCP0007_GET_BOD`) | spdMain 시트 `BOD` 바인딩 |
| A04 | 행 추가(InsertButton) | InsertButton | Input Status="C", 시트 BOD, 잠금 아님 → 활성 행 DIVISION_ID·INCOTERMS·INCOTERMS_SSP 셀 콤보 | `biz:CommonData.CommonDataList` [code=incotermsEdit] (+ `BLUtils.GetDivisionWithoutEE`) | 새 행 콤보 설정 |
| A05 | 수정(EditButton) | EditButton | 각 행 To SITE_TYPE="PLANT" → INCOTERMS_SSP 콤보(boolEditChange 분기) | `biz:CommonData.CommonDataList` [incotermsEdit / LookupCommon "INCOTERMS"] | PLANT 행 콤보 교체 |
| A06 | 저장(SaveButton) | SaveButton → SaveData_Main | 변경분 저장 → `ERR_MESSAGE` 판정 → 재조회 | `SCP.SCP0007_SAVE_BOD` (SP `SCP0007_SAVE_BOD`) → `SCP.SCP0007_GET_BOD` | 메시지 표시, BOD 재바인딩 |
| A07 | Div 변경(clbDivision.SelectedIndexChanged) | `cboDivision_SelectedIndexChanged` | 내부 동작 확인 필요 | 없음(Fact Pack 기준) | 확인 필요 |
| A08 | From Site 콤보 선택(spdMain.ComboSelChange) | `SpdMain_ComboSelChange` | FROM_SITE_CODE 변경 시 `sFromSite=="E"` 또는 `"A" && OSP_YN=="Y"` → TO_SITE_CODE 콤보 필터 재바인딩 | 없음 | TO_SITE_CODE 콤보 후보 변경 |
| A09 | 셀 값 변경(dsdm.Changed) | `SpdMain_Changed` → SetCityCode | 실행 중 자기 이벤트 해제(1284)/재등록(1315). From/To COUNTRY·CITY·VMI_YN·SITE_TYPE 조회 | `SCP.SCP0007_GET_ROUTE_CNT` (SP `SCP0007_GET_ROUTE_CNT`) | `route_cnt` 반영(대상 컬럼 확인 필요) |
| A10 | 붙여넣기(spdMain.ClipboardPasted) | `SpdMain_ClipboardPasted` | OSP_YN, CITY 참조 | 없음 | 확인 필요 |
| A11 | 셀 편집 중(spdMain.EditChange) | `SpdMain_EditChange` | To SITE_TYPE 참조 | 없음 | 확인 필요 |
| A12 | 키 입력(spdMain.KeyPress) | `SpdMain_KeyPress` | 내부 동작 확인 필요 | 없음 | 확인 필요 |
| A13 | 스크롤 상단 변경(spdMain.TopChange) | `SpdMain_TopChange` | 내부 동작 확인 필요 | 없음 | 확인 필요 |
| A14 | BOD 셀 더블클릭(spdMain.CellDoubleClick) | `spdMain_CellDoubleClick` (메인) | SpdMain_Changed 해제(1073) → dr의 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~SUN, VALID_YN, LT_SUM, LT_TYPE 읽기 → 재등록(1104) | 팝업 경유 `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`로 보임(호출문 확인 필요) | Route 값 반영(매핑 확인 필요) |
| A15 | 팝업 로드(this.Load) | `Form_Load` (팝업 .ctor:149) | txtFrom*/txtTo*에 생성자 값, 컨트롤 Enabled=false, 시트 `Distribution Route` 생성 → FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` (SP `SCP0005_GET_DISTRIBUTION_ROUTE`) | 시트 `Distribution Route` 바인딩 |
| A16 | 팝업 버튼 바(btnButtonList) | `btnButtonList_UsrButtonList_Click_Detected` | FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 〃 |
| A17 | 팝업 조회(FindButton) | FindButton → FindDataMain | 재조회 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 〃 |
| A18 | From 도시 검색(btnFromSrch.Click) | `btnFromSrch_Click` | popCity 선택 결과 | 없음(popCity 내부 확인 필요) | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City |
| A19 | To 도시 검색(btnToSrch.Click) | `btnToSrch_Click` | popCity 선택 결과 | 없음 | txtToCountry ← popCity.Country, txtToCity ← popCity.City |
| A20 | 팝업 셀 더블클릭 | `spdMain_CellDoubleClick` (팝업 InitEvent:201) | 내부 동작 확인 필요(선택 행 반환으로 보임) | 없음 | 확인 필요 |
| A21 | 팝업 셀 값 변경(dsdm.Changed) | `spdMainDataModel_Changed` | 자기 해제(489)/재등록(521) | 없음 | 확인 필요 |
| A22 | 팝업 공통코드 | 필드·메서드 초기화 | 국가, Yes/No, Trans Mode, Division, From/To Site, BOD Type, Transport Mode | `biz:CommonData.CommonDataList` [COUNTRY_MST, LookupCommon, MyDivision, FromSiteByDivision, ToSiteByDivision, BodType, TransportMode], `biz:CommonData.YesOrNo` | VALID_YN, DAYS_* 콤보 등. GetDivision 등 5개 메서드는 '진입점 미연결' |

---

## 6. 검증·메시지

| # | 항목 | 사실 | 비고 |
|---|---|---|---|
| V01 | 저장 결과 메시지 | `dtErr.Rows[0]["ERR_MESSAGE"]` (SaveData_Main:930) | 메시지 ID, 성공 판정 값 확인 필요 |
| V02 | 행 추가 가능 조건 | Input Status="C", 시트 `BOD`, 시트 잠금 아님 | 조건 불충족 시 알림이 있는지 확인 필요 |
| V03 | To Site 후보 제한 | ComboSelChange의 sFromSite/OSP_YN 분기 | filterExpression 확인 필요 |
| V04 | 필수 표기 | BOD 메타 라벨 `*` 10개 | 실제 필수 검증이 FE/SP에 있는지 확인 필요 |
| V05 | 입력 길이 | Distribution Route ExText maxLength: Country 2, City/Port Code/Shipping Company 3 | |
| V06 | 팝업 입력 잠금 | txtFrom*/txtTo*/btn*Srch/clbTransMode Enabled=false | |
| V07 | 조회조건 필수·조회 0건 메시지 | Fact Pack에 없음 | 확인 필요 |

---

## 7. 권한 (C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행. C/R/U/D 값은 **확인 필요** |
| 버튼 진입점 | FindButton(R), InsertButton(C), EditButton(U), SaveButton(저장 SP가 MERGE·DELETE 수행 → C/U/D 함께 처리 가능). 별도 DeleteButton은 Fact Pack에 없다 |
| 데이터 범위 | `UserInfoContext.Current.NowGroupID`(메인 55/60/63/64, 팝업 58). MyDivision/FromSiteByDivision/ToSiteByDivision → TB_FX_USERGROUPAUTHEXTENTION |
| 시트 잠금 | `siMain.IsLock(siMain.SheetName)` (InsertButton, ComboSelChange) |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle 관점)

| # | AS-IS | To-Be에서 바뀌는 점 |
|---|---|---|
| T01 | FpSpread + SetSheetHeaderColumn(메타 2단 헤더) | Wijmo FlexGrid + 메타 기반 컬럼 생성. 2단 헤더는 columnHeaders 행 추가와 병합으로 구현한다. SAFETY_STOCK 숨김은 메타·코드 이중 정의이므로 한 곳으로 정리해야 한다 |
| T02 | Distribution Route 코드 하드코딩 33컬럼 | 메타가 없다. FE 컬럼 정의로 옮기거나 메타 등록 여부를 결정해야 한다. DAYS_* 7개 bVisible=false 처리와 상단 그룹 헤더(302, 311~317줄) 원문 확인이 먼저다 |
| T03 | SetCellTypeCombo(행 단위 콤보 교체: DIVISION_ID, INCOTERMS, INCOTERMS_SSP, TO_SITE_CODE) | FlexGrid는 행마다 다른 dataMap이 필요하다(beginningEdit 또는 cellEditEnding에서 후보 전환). TO_SITE_CODE의 sFromSite/OSP_YN 필터 로직을 FE로 옮긴다 |
| T04 | dsdm.Changed 이벤트 해제/재등록으로 재진입 방지 | FlexGrid cellEditEnded 처리에서 프로그램 설정값과 사용자 입력을 구분하는 플래그가 필요하다 |
| T05 | UsrCheckedList2 → GetCheckedListValue(CODE) | MultiSelect 선택값을 구분자 문자열 또는 배열로 넘긴다. 파라미터 매핑 확인 필요 |
| T06 | MSSQL `STRING_SPLIT` (GET_BOD, GET_COUNTRY_CITY, SAVE_BOD, SCP0005_GET_DISTRIBUTION_ROUTE) | Oracle에는 STRING_SPLIT이 없어 대체 구현(분해 함수, JSON_TABLE 등)이 필요하다 |
| T07 | `SCP0007_GET_BOD` 동적 SQL | Oracle 동적 SQL(EXECUTE IMMEDIATE / OPEN REF CURSOR FOR)로 전환한다. 결과 컬럼과 BOD 메타 39컬럼 대조가 필요하다 |
| T08 | `#TMP_SCM_MST_SITE_ITEM` | Oracle GTT 등 임시 저장 구조로 바꾼다 |
| T09 | EXEC PR_SCP_MST_BOD_HIST / PR_SCP_MST_BOD_ITEM / PR_SCM_SYS_LOG_BATCH / PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF FN_NEXT_DAY / SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 하위 객체의 Oracle 전환 상태를 확인해야 한다 |
| T10 | `UPDATE:X`(별칭) | 실제 대상 테이블을 확정한 뒤 Oracle UPDATE/MERGE 구문으로 옮긴다 |
| T11 | ERR_MESSAGE 결과 테이블로 판정 | TO-BE 저장 결과 커서(코드·메시지) 계약으로 바꾼다 |
| T12 | popCity 도시 검색 팝업 | 공통 도시 선택 팝업으로 연결할지 확인 필요 |

---

## 9. 미확정

1. 조회조건 실제 배치(Location)와 행 순서. §2는 Size 일치로 추정한 것이다.
2. usrLayoutControl1(657×184, parent 미기록)의 용도.
3. FindButton 내부 호출 순서와 `SCP.SCP0007_GET_COUNTRY_CITY` 결과의 용도.
4. 메인 `spdMain_CellDoubleClick` → 팝업 호출 방식, 생성자 인자, 반환 매핑.
5. `cboDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdMain_KeyPress`, `SpdMain_ClipboardPasted`, `SpdMain_EditChange`, 팝업 `spdMain_CellDoubleClick`, `spdMainDataModel_Changed`의 세부 동작.
6. BOD 메타 컬럼 타입·폭·정렬·편집 여부·표시 순서. InitSpread:277 cellTypeImage 대상 컬럼.
7. Distribution Route DAYS_* 표시 여부, 상단 그룹 헤더 문구, `DefColumns.TRANSPORT_MODE` 상수값.
8. 조회조건 콤보 원천(Div, From/To Site, Incoterms, SSP Incoterms, Trans Mode, Input Status)과 초기값.
9. 메시지 ID, 필수 검증, 권한 C/R/U/D 값.

=== FILE: unit_test.md ===
# SCP0007 단위테스트 케이스

> 근거 열의 엔드포인트, SP, 핸들러, 시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 표기다. 절차 열의 컨트롤명은 화면설계서 §3의 컨트롤명이다.
> 기대결과 중 AS-IS 원문으로 확정하지 못한 부분은 **(확인 필요)**로 적었다. 이런 케이스는 AS-IS 실행 화면과 대조해서 판정한다.
> 주석 처리된 호출은 0건이며 테스트 대상에 넣지 않았다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0007-001 | 초기화 | 메뉴 권한(R)이 있는 사용자 | SCP0007 화면을 연다 | – | usrConditionPanel1(상단, HidePanel)과 spdMain(하단 Fill)이 표시된다. spdMain에 시트 `BOD`가 2단 헤더로 생성된다. 데이터 0행 | `Form_Load`(메인), 시트 `BOD`, CreateSpread:262, InitSpread:275 |
| TC-SCP0007-002 | 초기화 | TC-001 | 조회조건 컨트롤의 라벨을 확인한다 | – | clbDivision="Div", clbFromSite="From Site", clbToSite="To Site", clbIncoterms="Incoterms", clbTransMode="Trans Mode", clbIncotermsSSP="SSP Incoterms", cboValidYN="Valid", cboInputStatus="Input Status" | props.csv layout*.Text, usrLayoutControl2 |
| TC-SCP0007-003 | 초기화 | TC-001 | Incoterms·Trans Mode 공통코드가 로드됐는지 확인한다 | – | LookupCommon 코드 목록이 로드된다. 바인딩 대상 컨트롤(clbIncoterms, clbTransMode 후보)은 (확인 필요) | `biz:CommonData.CommonDataList` [code=LookupCommon], dtIncoterms:65, dtTransMode:66 |
| TC-SCP0007-004 | 초기화 | TC-001 | cboValidYN 목록을 연다 | – | Yes/No 목록이 표시된다(원천 확인 필요) | `biz:CommonData.YesOrNo`, dtValidYN:68 |
| TC-SCP0007-005 | 초기화 | TC-001 | incotermsEdit 공통코드가 로드됐는지 확인한다 | – | incotermsEdit 목록이 dtIncotermsEdit에 로드된다 | `biz:CommonData.CommonDataList` [code=incotermsEdit], dtIncotermsEdit:69 |
| TC-SCP0007-006 | 조회 | 조회 대상 BOD 데이터가 있음 | clbDivision, clbFromSite, clbToSite, clbIncoterms, clbTransMode, clbIncotermsSSP, cboValidYN, cboInputStatus를 고른 뒤 조회(FindButton) | 각 조건 1개 이상 선택 | spdMain 시트 `BOD`에 결과가 표시된다. 행 수는 SP 직접 실행 결과와 같다 | FindButton → FindData_Main, `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD` |
| TC-SCP0007-007 | 조회 | TC-006 | 조회 시 국가·도시 조회가 호출되는지 확인한다(네트워크/로그) | TC-006과 같음 | `SCP.SCP0007_GET_COUNTRY_CITY`가 1회 호출되고 오류가 없다. GET_BOD와의 호출 순서와 결과 용도는 (확인 필요) | FindButton → GetData_Country, `SCP.SCP0007_GET_COUNTRY_CITY`, SP `SCP0007_GET_COUNTRY_CITY` |
| TC-SCP0007-008 | 조회 | 조건에 맞는 데이터 없음 | 데이터가 없는 조건 조합으로 조회(FindButton) | 존재하지 않는 clbFromSite·clbToSite 조합 | 시트 `BOD`가 0행으로 표시되고 오류가 나지 않는다. 0건 안내 메시지는 (확인 필요) | `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD`, 시트 `BOD` |
| TC-SCP0007-009 | 조회 | SP 오류를 유도할 수 있는 환경(예: SP 권한 회수) | 조회(FindButton) | – | 오류 메시지가 표시되고 그리드 기존 데이터가 깨지지 않는다. 메시지 문구는 (확인 필요) | `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD` |
| TC-SCP0007-010 | 조회 | TC-001 | clbDivision, clbFromSite, clbToSite, clbIncoterms, clbTransMode, clbIncotermsSSP에서 다중 선택 후 조회 | 각 2개 이상 선택 | 선택한 CODE 값이 모두 SP 파라미터로 전달된다(GetCheckedListValue). 파라미터 매핑은 (확인 필요) | FindData_Main:517/518/530~534, `SCP.SCP0007_GET_BOD` |
| TC-SCP0007-011 | 그리드 | TC-006 | 시트 `BOD`의 표시 컬럼을 센다 | – | 표시 34개. BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY 5개는 보이지 않는다. 헤더 라벨이 메타 라벨(예: "Route Id*", "To Site VMI")과 같다 | 시트 `BOD`, grid_effective.csv, SCM_MST_SHEET_COLUMNS |
| TC-SCP0007-012 | 그리드 | TC-006 | SAFETY_STOCK 컬럼 표시 여부를 확인한다 | – | SAFETY_STOCK(Safety Stock)이 숨겨져 있다 | 시트 `BOD`, InitSpread:338 Visible=false |
| TC-SCP0007-013 | 그리드 | 팝업 열림(TC-040) | 시트 `Distribution Route`의 컬럼과 헤더를 확인한다 | – | 코드 정의 33컬럼이 정의돼 있고 헤더 문구가 원문(예: "Shipping Document Preparation Data", "Sea/Air Ferry")과 같다. DAYS_MON~DAYS_SUN 7개는 bVisible=false로 정의돼 있으며, 실제로 보이는지는 (확인 필요) | 시트 `Distribution Route`, InitSpread:264~297 |
| TC-SCP0007-014 | 그리드 | TC-013 | `Distribution Route` 2단 헤더 병합을 확인한다 | – | Route Id, L/T Type, Valid, Trans Mode, Priority, Departure Days, Shipping Company, Shipping Document Preparation Data, Sum이 0행부터 2행 병합. FROM/TO/D_/A_ 계열 Country·City·Port Code는 1행. 상단 그룹 헤더 문구는 (확인 필요) | 시트 `Distribution Route`, ColumnHeaderSpan:301~335 |
| TC-SCP0007-015 | division | division 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 각각의 사용자 | division별 사용자로 로그인해 조회(FindButton)하고 시트 `BOD`의 컬럼을 센다(파라미터화 14회) | division 14종 | 모든 division에서 표시 34 / 숨김 5로 같다 | 시트 `BOD`, grid_effective.csv division 열 |
| TC-SCP0007-016 | division | TC-015 사용자 | division별로 팝업을 열고 시트 `Distribution Route`의 컬럼을 센다 | division 14종 | 모든 division에서 같은 33컬럼 정의(코드추가) | 시트 `Distribution Route`, grid_effective.csv |
| TC-SCP0007-017 | division | cboInputStatus="C" | 행 추가 후 DIVISION_ID 콤보 후보를 확인한다 | – | 후보가 `BLUtils.GetDivisionWithoutEE(false,"")` 결과와 같다. EE 계열 제외 여부는 (확인 필요) | InsertButton:387, 시트 `BOD` |
| TC-SCP0007-018 | 이벤트 | TC-001 | clbDivision 선택을 바꾼다 | Div 값 변경 | `cboDivision_SelectedIndexChanged`가 실행된다. 연동 결과(예: Site 목록 갱신)는 AS-IS 실행 결과와 대조 (확인 필요) | `cboDivision_SelectedIndexChanged` (InitEvent:176) |
| TC-SCP0007-019 | 이벤트 | 시트 `BOD` 편집 가능(잠금 아님) | spdMain에서 FROM_SITE_CODE 콤보로 sFromSite가 "E"인 Site를 고른다 | FROM_SITE_CODE = (sFromSite="E" Site) | TO_SITE_CODE 셀 콤보가 필터된 To Site 목록으로 다시 바인딩된다 | `SpdMain_ComboSelChange`:1146 |
| TC-SCP0007-020 | 이벤트 | 시트 `BOD` 편집 가능 | spdMain에서 sFromSite가 "A"이고 OSP_YN="Y"인 Site를 FROM_SITE_CODE로 고른다 | FROM_SITE_CODE = (sFromSite="A", OSP_YN="Y") | TO_SITE_CODE 셀 콤보가 필터 목록으로 다시 바인딩된다. 위 두 조건 밖의 값일 때의 동작은 (확인 필요) | `SpdMain_ComboSelChange`:1154 |
| TC-SCP0007-021 | 이벤트 | 시트 `BOD` 잠금 상태 | spdMain에서 FROM_SITE_CODE 콤보를 고른다 | – | TO_SITE_CODE 콤보가 다시 바인딩되지 않는다 | `SpdMain_ComboSelChange` (`!siMain.IsLock` 조건) |
| TC-SCP0007-022 | 이벤트 | 조회된 BOD 행 | spdMain에서 FROM_SITE_CODE 또는 TO_SITE_CODE 값을 바꾼다 | 유효한 From/To Site | `SCP.SCP0007_GET_ROUTE_CNT`가 호출되고 결과 `route_cnt`가 행에 반영된다(대상 컬럼 ROUTE_CNT 후보, 확인 필요). From/To 국가·도시, To VMI_YN·SITE_TYPE 관련 값이 채워진다 | `SpdMain_Changed` → SetCityCode:1448, `SCP.SCP0007_GET_ROUTE_CNT`, SP `SCP0007_GET_ROUTE_CNT` |
| TC-SCP0007-023 | 이벤트 | 조회된 BOD 행 | Route가 없는 From/To 조합으로 바꾼다 | SCP_MST_DISTRIBUTION_ROUTE에 없는 조합 | Route 건수 0이 반영되고 오류가 없다. 후속 처리는 (확인 필요) | `SpdMain_Changed`, `SCP.SCP0007_GET_ROUTE_CNT`, SP `SCP0007_GET_ROUTE_CNT` |
| TC-SCP0007-024 | 이벤트 | TC-022 | `SpdMain_Changed` 실행 중 이벤트 재진입 여부를 확인한다(호출 로그) | Site 1회 변경 | 셀 1회 변경에 `SCP.SCP0007_GET_ROUTE_CNT` 연쇄 재호출이 생기지 않는다(1284 해제 / 1315 재등록) | `SpdMain_Changed`:1284/1315 |
| TC-SCP0007-025 | 이벤트 | 시트 `BOD` 편집 가능 | 외부 데이터(From/To Site 포함 여러 행)를 spdMain에 붙여넣는다 | 클립보드 2행 | `SpdMain_ClipboardPasted`가 실행되고 OSP_YN, CITY를 참조해 처리한다. 결과는 AS-IS와 대조 (확인 필요) | `SpdMain_ClipboardPasted`:1218~1255 |
| TC-SCP0007-026 | 이벤트 | 시트 `BOD` 편집 가능 | spdMain 셀을 편집 중 값을 입력한다 | To Site가 PLANT인 행 | `SpdMain_EditChange`가 실행되고 To SITE_TYPE을 참조한다. 결과는 (확인 필요) | `SpdMain_EditChange`:1344 |
| TC-SCP0007-027 | 이벤트 | 조회된 BOD 행 | spdMain 셀에서 키를 입력한다 | 임의 문자 | `SpdMain_KeyPress`가 실행된다. 동작은 AS-IS와 대조 (확인 필요) | `SpdMain_KeyPress` (InitEvent:182) |
| TC-SCP0007-028 | 이벤트 | 화면 높이를 넘는 BOD 행 | spdMain을 세로로 스크롤한다 | – | `SpdMain_TopChange`가 실행된다. 동작은 AS-IS와 대조 (확인 필요) | `SpdMain_TopChange` (InitEvent:179) |
| TC-SCP0007-029 | 이벤트 | 조회된 BOD 행 | spdMain의 Route 관련 셀을 더블클릭하고 팝업에서 경로를 고른다 | – | 선택한 경로의 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~DAYS_SUN, VALID_YN, LT_SUM, LT_TYPE 값이 BOD 행에 반영된다(대상 컬럼 매핑 확인 필요). 반영 중 `SCP.SCP0007_GET_ROUTE_CNT`는 호출되지 않는다(1073 해제 / 1104 재등록) | `spdMain_CellDoubleClick`(메인):1068~1104, 시트 `BOD`, 시트 `Distribution Route` |
| TC-SCP0007-030 | 그리드 | cboInputStatus="C", 시트 `BOD` 잠금 아님 | 행 추가(InsertButton) | – | 새 행의 DIVISION_ID(dtMyDivision), INCOTERMS, INCOTERMS_SSP(dtIncotermsEdit)에 셀 콤보가 설정된다 | InsertButton:387/424/425, `biz:CommonData.CommonDataList` [code=incotermsEdit], 시트 `BOD` |
| TC-SCP0007-031 | 그리드 | cboInputStatus="R" | 행 추가(InsertButton) | – | TC-030의 셀 콤보 설정 분기로 들어가지 않는다. "R" 분기의 동작은 (확인 필요) | InsertButton (`else!(strSel_InputStatus == "R")` 분기) |
| TC-SCP0007-032 | 권한 | cboInputStatus="C", 시트 `BOD` 잠금 상태 | 행 추가(InsertButton) | – | 셀 콤보가 설정되지 않는다 | InsertButton (`siMain.IsLock(...) == false` 조건) |
| TC-SCP0007-033 | 그리드 | To Site SITE_TYPE="PLANT" 행이 있는 조회 결과, boolEditChange=true 상태 | 수정(EditButton) | – | PLANT 행의 INCOTERMS_SSP 콤보가 incotermsEdit 목록이다 | EditButton:476/484, `biz:CommonData.CommonDataList` [code=incotermsEdit] |
| TC-SCP0007-034 | 그리드 | TC-033과 같고 boolEditChange=false | 수정(EditButton) | – | PLANT 행의 INCOTERMS_SSP 콤보가 LookupCommon "INCOTERMS" 목록이다. PLANT가 아닌 행은 바뀌지 않는다 | EditButton:490, `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0007-035 | 저장 | 신규 행(TC-030) 입력 완료, 원장에 없는 키 | 저장(SaveButton) | Division, From Site, To Site, FROM/TO 일자, Incoterms, Incoterms SSP, Priority, Route Id 입력 | `SCP.SCP0007_SAVE_BOD` 호출이 성공한다. SCP_MST_BOD에 행이 생기고, SCP_MST_BOD_H와 SCM_SYS_LOG_BATCH에 기록된다. 이어서 `SCP.SCP0007_GET_BOD` 재조회로 시트 `BOD`에 반영된다 | SaveData_Main:794, `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD`, `SCP.SCP0007_GET_BOD` |
| TC-SCP0007-036 | 저장 | 조회된 기존 행 수정 | 저장(SaveButton) | Remarks 등 수정 | SCP_MST_BOD가 MERGE로 갱신되고, SCP_MST_BOD_ITEM INSERT/UPDATE 전개 결과가 SP 기대와 같다(전개 규칙 확인 필요). 재조회 후 수정값이 표시된다 | `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD` |
| TC-SCP0007-037 | 저장 | SP 검증에 걸리는 데이터(예: 필수값 누락) | 저장(SaveButton) | 라벨 `*` 컬럼 1개를 비움 | `ERR_MESSAGE`의 오류 문구가 표시되고 원장에 반영되지 않는다. 검증 위치(FE/SP)와 오류 시 재조회 여부는 (확인 필요) | SaveData_Main:930 `ERR_MESSAGE`, `SCP.SCP0007_SAVE_BOD` |
| TC-SCP0007-038 | 저장 | 변경 행 없음 | 저장(SaveButton) | – | 저장 SP 호출 여부와 안내 메시지는 (확인 필요). 데이터 변경은 없다 | SaveButton, `SCP.SCP0007_SAVE_BOD` |
| TC-SCP0007-039 | 저장 | 삭제 대상 행이 있는 상태(삭제 표시 방식 확인 필요) | 저장(SaveButton) | – | SCP_MST_BOD에서 해당 행이 DELETE된다(SP 참조 DELETE:SCP_MST_BOD). 이력 기록 여부는 (확인 필요) | `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD` |
| TC-SCP0007-040 | 초기화 | 메인 BOD 행 더블클릭으로 팝업 호출 | Distribution Route Popup이 열리는 것을 확인한다 | From/To 국가·도시 값이 있는 행 | txtFromCountry, txtFromCity, txtToCountry, txtToCity에 생성자 값이 표시되고 Enabled=false다. btnFromSrch, btnToSrch, clbTransMode도 Enabled=false. `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` 결과가 시트 `Distribution Route`에 표시된다 | `Form_Load`(팝업 .ctor:149) → FindDataMain:436, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`, SP `SCP0005_GET_DISTRIBUTION_ROUTE`, InitControls:214~229 |
| TC-SCP0007-041 | 조회 | TC-040 | btnButtonList의 조회 버튼을 누른다 | – | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`가 다시 호출되고 시트 `Distribution Route`가 갱신된다 | `btnButtonList_UsrButtonList_Click_Detected` → FindDataMain, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-042 | 조회 | TC-040 | 팝업 조회(FindButton) | – | TC-041과 같다 | 팝업 FindButton → FindDataMain, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-043 | 조회 | From/To 조합에 경로 없음 | 경로가 없는 행에서 팝업을 연다 | SCP_MST_DISTRIBUTION_ROUTE에 없는 From/To | 시트 `Distribution Route`가 0행이고 오류가 없다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`, SP `SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-044 | 조회 | SP 오류 유도 환경 | 팝업을 연다 | – | 오류 메시지가 표시되고 팝업이 비정상 종료되지 않는다. 문구는 (확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-045 | 이벤트 | btnFromSrch가 활성화된 상태(활성 조건 확인 필요) | btnFromSrch를 눌러 도시를 고른다 | 임의 국가/도시 | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City | `btnFromSrch_Click`:689~690 |
| TC-SCP0007-046 | 이벤트 | btnToSrch가 활성화된 상태 | btnToSrch를 눌러 도시를 고른다 | 임의 국가/도시 | txtToCountry ← popCity.Country, txtToCity ← popCity.City | `btnToSrch_Click`:707~708 |
| TC-SCP0007-047 | 이벤트 | 기본 상태(InitControls) | btnFromSrch, btnToSrch를 누른다 | – | 버튼이 Enabled=false라 반응하지 않는다 | `btnFromSrch_Click`, `btnToSrch_Click`, InitControls:216/220 |
| TC-SCP0007-048 | 이벤트 | TC-040 | 팝업 spdMain 행을 더블클릭한다 | 경로 1행 | 팝업 `spdMain_CellDoubleClick`가 실행된다. 선택 행 반환 후 팝업 닫힘 여부는 (확인 필요) | `spdMain_CellDoubleClick`(팝업 InitEvent:201), 시트 `Distribution Route` |
| TC-SCP0007-049 | 이벤트 | TC-040, 셀 편집 가능 여부 확인 필요 | 팝업 spdMain 셀 값을 바꾼다 | – | `spdMainDataModel_Changed`가 실행되고 실행 중 자기 이벤트 해제(489)/재등록(521)으로 재진입이 생기지 않는다 | `spdMainDataModel_Changed`:489/521 |
| TC-SCP0007-050 | 그리드 | TC-040 | 시트 `Distribution Route`의 Valid와 요일 콤보 후보를 확인한다 | – | VALID_YN(및 DAYS_* 정의)이 Yes/No 목록이다 | `biz:CommonData.YesOrNo`, dtYesOrNo:48, 시트 `Distribution Route` |
| TC-SCP0007-051 | 초기화 | TC-040 | 팝업 국가 공통코드가 로드됐는지 확인한다 | – | COUNTRY_MST 목록이 dtFromCountry/dtToCountry에 로드된다. 사용처는 (확인 필요) | `biz:CommonData.CommonDataList` [code=COUNTRY_MST], dtFromCountry:44, dtToCountry:46 |
| TC-SCP0007-052 | 초기화 | TC-040 | 팝업 clbTransMode 목록을 확인한다 | – | LookupCommon 기반 Trans Mode 목록(Enabled=false 상태로 표시) | `biz:CommonData.CommonDataList` [code=LookupCommon], 팝업 dtTransMode:49 |
| TC-SCP0007-053 | 권한 | 그룹이 다른 사용자 A, B(TB_FX_USERGROUPAUTHEXTENTION 범위가 다름) | 각 사용자로 화면과 팝업을 열어 Division·From Site·To Site 후보를 비교한다 | NowGroupID A/B | 그룹 권한 범위에 따라 후보가 다르다. 팝업 GetDivision/GetFromSitebyDivision/GetToSitebyDivision 실제 호출 여부는 (확인 필요) | `biz:CommonData.CommonDataList` [code=MyDivision / FromSiteByDivision / ToSiteByDivision], NowGroupID(메인 55/60/63/64, 팝업 58) |
| TC-SCP0007-054 | 초기화 | TC-040 | BOD Type·Transport Mode 공통코드 호출 여부를 확인한다 | – | 파서 분류는 '진입점 미연결'이다. 실제 호출과 사용처를 AS-IS 실행으로 확인한다 (확인 필요) | `biz:CommonData.CommonDataList` [code=BodType / TransportMode], GetBodType:569, GetTransMode:579 |
| TC-SCP0007-055 | 권한 | TB_FX_GroupMenuAuth에 SCP0007 조회 전용 그룹 사용자 | 화면을 열어 조회·행 추가·수정·저장 버튼 사용 가능 여부를 확인한다 | – | 그룹 C/R/U/D 설정대로 버튼이 활성/비활성된다. 권한 값은 (확인 필요) | TB_FX_GroupMenuAuth 13행, FindButton / InsertButton / EditButton / SaveButton |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 040 |
| | `cboDivision_SelectedIndexChanged` | 018 |
| | `SpdMain_ComboSelChange` | 019, 020, 021 |
| | `SpdMain_Changed` | 022, 023, 024 |
| | `SpdMain_ClipboardPasted` | 025 |
| | `SpdMain_EditChange` | 026 |
| | `SpdMain_KeyPress` | 027 |
| | `SpdMain_TopChange` | 028 |
| | `spdMain_CellDoubleClick` | 029(메인), 048(팝업) |
| | `btnButtonList_UsrButtonList_Click_Detected` | 041 |
| | `btnFromSrch_Click` | 045, 047 |
| | `btnToSrch_Click` | 046, 047 |
| | `spdMainDataModel_Changed` | 049 |
| 엔드포인트 | `SCP.SCP0007_GET_BOD` | 006, 008, 009, 010, 035 |
| | `SCP.SCP0007_GET_COUNTRY_CITY` | 007 |
| | `SCP.SCP0007_GET_ROUTE_CNT` | 022, 023, 024 |
| | `SCP.SCP0007_SAVE_BOD` | 035~039 |
| | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 040~044 |
| | `biz:CommonData.CommonDataList` | 003, 005, 030, 033, 034, 051~054 |
| | `biz:CommonData.YesOrNo` | 004, 050 |
| 시트 | `BOD` | 001, 008, 011, 012, 015, 017, 029, 030 |
| | `Distribution Route` | 013, 014, 016, 029, 048, 050 |
| division | 14종(division별 차이 없음 → 파라미터화) | 015, 016, 017 |
| 빈 결과 / 오류 | 조회·Route 건수·팝업·저장 | 008, 009, 023, 037, 043, 044 |

---

세 문서 모두 대화로 받은 Fact Pack과 1차 분석서만으로 작성했고, 저장소 파일이나 DB는 확인하지 않았습니다. 기계 검사 7개 조건의 이름(엔드포인트 7, SP 5, 컨트롤 20, 시트 2, 핸들러 13)은 해당 문서에 원문 그대로 넣었습니다. 다만 실제 검사기는 돌려 보지 않았습니다.

- **레이아웃은 추정입니다:** props.csv에 SplitContainer가 0건이라 Dock(Top/Fill)과 parent 체인으로 분할 트리를 그렸습니다. 조회조건 행 배치는 컨트롤 크기가 맞는 조합으로 추정했고, 문서에도 **확인 필요**로 표시했습니다.
- **확인 필요가 남은 곳:** AS-IS 원문(SP 내부, `FindButton`·`SaveData_Main`·더블클릭 팝업 호출, 메시지 ID, 권한 C/R/U/D 값)이 Fact Pack에 없어 그대로 **확인 필요**로 남겼습니다. 이와 연결된 테스트 케이스는 AS-IS 실행 결과와 대조해서 판정하도록 적었습니다.
