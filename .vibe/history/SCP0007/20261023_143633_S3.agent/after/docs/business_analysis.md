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
