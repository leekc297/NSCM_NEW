=== FILE: business_analysis.md ===
# SCP0005 Distribution Route — 업무분석서

> 근거: AsisFacts Fact Pack(정적 추출)과 1차 분석서(analysis.md·web_components.md·tobe_design.md)에 있는 사실만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건이며, 현행 기능에 넣지 않았습니다.

## 1. 업무 목적·범위

### 1-1. 목적
- 화면 ID는 `SCP0005`, 폼 Text는 `"Distribution Route"`(Designer.cs:555)이고, 파일 경로상 `Master` 하위의 마스터 화면입니다.
- 이 화면은 물류 경로(Distribution Route) 마스터 테이블 `SCP_MST_DISTRIBUTION_ROUTE` 를 조회하고 저장(INSERT/UPDATE/DELETE)합니다. 근거는 SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` 의 참조 객체입니다.
- 변경 이력 테이블 `SCP_MST_DISTRIBUTION_ROUTE_H` 를 이력 팝업(`SCP0005_DistributionRoutePopup`, Text `"DistributionRoute History"`)에서 조회합니다.
- 업무상 목적(어느 부서가 어떤 계획에 이 경로를 쓰는지)은 Fact Pack에 없어 **확인 필요**입니다.

### 1-2. 범위
| 구분 | 대상 |
|---|---|
| 메인 화면 | `SCP0005_DistributionRoute` (current, 1389줄 + Designer 619줄) |
| 공유 팝업 | `SCP0005_DistributionRoutePopup` (shared, GSCM.SCM.Popup.UIL, 192줄 + Designer 115줄) |
| 그리드 시트 | 메인 `Distribution Route`(39컬럼), 팝업 `POPUP`(16컬럼) |
| 엔드포인트 | 7종(아래 §5) |
| SP | 5종: `SCP0005_GET_DISTRIBUTION_ROUTE`, `SCP0005_GET_DISTRIBUTION_ROUTEID`, `SCP0005_SAVE_DISTRIBUTION_ROUTE`, `SCP0005_GET_COUNTRY_CITY`, `SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` |
| legacy 사본 | 없음 |

### 1-3. 그리드 컬럼으로 본 관리 항목 (메타 라벨 원문)
그리드 컬럼 이름으로 묶어 보면 아래 항목을 관리합니다. 그룹 이름은 컬럼명 접두어로 묶은 것이고, 실제 2단 헤더 그룹명은 **확인 필요**입니다.
- 경로 키: `ROUTE_ID`(Route Id)
- 출발/도착 도시: FROM_COUNTRY / FROM_CITY / FROM_CITY_NAME, TO_COUNTRY / TO_CITY / TO_CITY_NAME
- 출항/도착 항구: D_COUNTRY / D_PORT_CODE / D_PORT_NAME, A_COUNTRY / A_PORT_CODE / A_PORT_NAME
- 운송 속성: TRANSPORT_MODE(Trans Mode*), SHIPPING_COMPANY(Forwarder*), PRIORITY(Priority*), LT_TYPE(L/T Type*), VALID_YN(Valid*)
- 리드타임: LT_DEPARTURE_INLAND, LT_WAIT_SHIPPING, LT_VOYAGE, LT_LAY_OFF_CLEARANCE, LT_ARRIVAL_INLAND, LT_SUM(Total L/T), SHIP_DOC_PREPARATION_DATE
- 비용: One_SEGMENT_COST(Pick Up Cost), Two_SEGMENT_COST(Freight Cost), Three_SEGMENT_COST(Delivery Cost)
- 요일: DAYS_MON ~ DAYS_SUN
- 감사 컬럼: CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load`(.ctor:144 배선). 필드 초기화 biz 호출 5건(`biz:CommonData.CommonDataList` [COUNTRY_MST ×2, LookupCommon], `biz:CommonData.YesOrNo` ×2)이 있지만 진입점은 연결되지 않았습니다(**실행 시점 확인 필요**). `InitControls` 가 ManualSearchCondition 의 ControlName/ControlValue 로 조회조건을 복원합니다. | 조회조건과 그리드(`Distribution Route`) 초기화 | events.csv, meta_reads.csv:208/210 |
| S2 | From 검색 버튼(btnFromSrch)을 누릅니다 | `btnFromSrch_Click` → `popCity` 결과를 반영합니다 | txtFromCountry = popCity.Country, txtFromCity = popCity.City | props.csv:350/351 |
| S3 | To 검색 버튼(btnToSrch)을 누릅니다 | `btnToSrch_Click` → `popCity` 결과를 반영합니다 | txtToCountry = popCity.Country, txtToCity = popCity.City | props.csv:368/369 |
| S4 | 툴바 조회(FindButton)를 누릅니다 | FindDataMain → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / FindDataReceive → `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` / GetData_Country → `SCP.SCP0005_GET_COUNTRY_CITY`. 세 경로의 분기 조건은 **확인 필요**입니다. | 결과가 1행 이상이면 `SetSpreadColumn(siMain)` 을 호출합니다(FindDataMain:452, FindDataReceive:521) | flow.csv, grid_code.csv |
| S5 | 그리드 셀을 편집합니다 | `spdMainDataModel_Changed`. 970에서 핸들러를 해제하고 1082에서 다시 등록합니다. | 변경 셀과 계산 내용은 **확인 필요** | events.csv |
| S6 | 그리드 셀을 더블클릭합니다 | `spdMain_CellDoubleClick`. 1135에서 Changed 핸들러를 해제하고 1164에서 다시 등록합니다. | 이력 팝업 호출 여부는 **확인 필요** | events.csv |
| S7 | 툴바 저장(SaveButton)을 누릅니다 | SaveData → `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` 를 실행한 뒤 FindDataMain → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` 로 다시 조회합니다 | 저장 후 재조회. 오류가 나면 `dtErr.Rows[0]["ERR_MESSAGE"]` 를 읽습니다(871) | flow.csv, meta_reads.csv |
| S8 | Upload 버튼(btnEaxel_Upload)을 누릅니다 | `btnEaxel_Upload_Click` → FindDataMain → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 재조회. 업로드 데이터를 저장하는 경로는 **확인 필요** | flow.csv |
| S9 | Excel Form 버튼(btnExcel_Form)을 누릅니다 | `btnExcel_Form_Click`(연결된 엔드포인트 없음) | 양식 생성 방식은 **확인 필요**. 메타 SCM_ADM_EXCEL_COLUMNS 1행이 있습니다. | events.csv:327 |
| S10 | 이력 팝업이 열리거나 팝업에서 조회합니다 | 팝업 `Form_Load`(.ctor:98) / FindButton → FindData → `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 시트 `POPUP` 에 이력 16컬럼을 표시합니다 | flow.csv |

## 3. 업무 흐름도 (텍스트)

```
[메인 SCP0005_DistributionRoute]
 1. 화면 열기 ─ Form_Load
      ├─ (필드 초기화, 시점 확인 필요) biz:CommonData.CommonDataList [COUNTRY_MST/LookupCommon], biz:CommonData.YesOrNo
      └─ InitControls : 저장된 조회조건 복원 (TB_FX_SearchCondition)
 2. 조회조건 입력
      ├─ Valid(cboValidYN) / Trans Mode(clbTransMode)
      ├─ btnFromSrch_Click → popCity → txtFromCountry, txtFromCity
      └─ btnToSrch_Click   → popCity → txtToCountry, txtToCity
 3. 조회(FindButton) ─ 분기 조건 확인 필요
      ├─ FindDataMain    → SCP.SCP0005_GET_DISTRIBUTION_ROUTE   → SP SCP0005_GET_DISTRIBUTION_ROUTE
      ├─ FindDataReceive → SCP.SCP0005_GET_DISTRIBUTION_ROUTEID → SP SCP0005_GET_DISTRIBUTION_ROUTEID
      ├─ GetData_Country → SCP.SCP0005_GET_COUNTRY_CITY         → SP SCP0005_GET_COUNTRY_CITY
      └─ 결과 Rows.Count > 0 → SetSpreadColumn(siMain)
 4. 편집 ─ spdMainDataModel_Changed / spdMain_CellDoubleClick (Changed 핸들러 해제·재등록)
 5. 저장(SaveButton) → SaveData → SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE → SP SCP0005_SAVE_DISTRIBUTION_ROUTE
      │   (INSERT/UPDATE/DELETE SCP_MST_DISTRIBUTION_ROUTE, EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST,
      │    INSERT SCP_MST_DISTRIBUTION_ROUTE_H, EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT SCM_SYS_LOG_BATCH)
      ├─ 오류: dtErr.Rows[0]["ERR_MESSAGE"]
      └─ 재조회: FindDataMain → SCP.SCP0005_GET_DISTRIBUTION_ROUTE
 6. Excel ─ btnExcel_Form_Click (양식) / btnEaxel_Upload_Click → FindDataMain 재조회

[팝업 SCP0005_DistributionRoutePopup]
 7. Form_Load / FindButton → FindData → SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID
      → SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID (SELECT SCP_MST_DISTRIBUTION_ROUTE_H) → 시트 POPUP
```

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 조회 결과가 1행 이상일 때만 `SetSpreadColumn(siMain)` 을 호출합니다 | grid_code.csv FindDataMain:452 / FindDataReceive:521 조건 `if(ds != null && ds.Tables[0].Rows.Count > 0)` | SetSpreadColumn 내부 처리는 확인 필요 |
| R2 | 저장 SP 하나가 INSERT, UPDATE, DELETE를 모두 처리합니다 | SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` 참조 객체 | 행 상태별 분기 조건은 확인 필요 |
| R3 | 저장할 때 이력을 기록합니다(PR_SCP_MST_DISTRIBUTION_ROUTE_HIST, INSERT SCP_MST_DISTRIBUTION_ROUTE_H) | 동일 | 이력을 남기는 조건은 확인 필요 |
| R4 | 저장할 때 배치 로그를 남깁니다(PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT SCM_SYS_LOG_BATCH) | 동일 | |
| R5 | 저장 파라미터는 배열 분해 함수(SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL)로 풀어 씁니다 | 동일 REF | 구분자·파라미터 목록은 확인 필요 |
| R6 | 저장이 실패하면 결과 테이블에서 `ERR_MESSAGE` 를 읽습니다 | meta_reads.csv SaveData:871 | 메시지 표시 방식은 확인 필요 |
| R7 | 저장에 성공하면 메인 목록을 다시 조회합니다(FindDataMain) | flow.csv `SaveButton > SaveData > FindDataMain` | |
| R8 | 그리드 필수 컬럼(USER_SELECTABLE_FLAG='N')은 `ROUTE_ID` 하나입니다. 두 시트 모두 같습니다. | grid_effective.csv | 이 '필수'는 사용자 표시 선택에서 숨길 수 없다는 뜻이고, 입력 필수와는 다릅니다 |
| R9 | 메타 라벨 15개에 `*` 가 붙어 있습니다(Country*, City*, Port Code*, Port*, Trans Mode*, Forwarder*, Priority*, L/T Type*, Valid*) | grid_effective.csv label | 입력 필수인지 여부와 검증 위치(FE/SP)는 **확인 필요** |
| R10 | 메인 조회 SP는 다중값 분해(STRING_SPLIT)를 참조합니다 | SP `SCP0005_GET_DISTRIBUTION_ROUTE` REF:STRING_SPLIT | 다중 선택 조건(clbTransMode의 GetCheckedListValue(CODE)@FindDataMain:404) 연계 여부는 확인 필요 |
| R11 | 코드값은 FN_GET_LOOKUP_CODE_DESC 와 SCM_ADM_LOOKUP_MASTER_DETAIL 로 설명값으로 바꿉니다 | 조회 SP 3종(ROUTE, ROUTEID, HISTORY_ROUTEID) 참조 객체 | 변환 대상 컬럼은 확인 필요 |
| R12 | 셀 값이 바뀔 때 재귀 실행을 막으려고 Changed 핸들러를 잠시 해제합니다 | events.csv 970/1082, 1135/1164 | 셀 계산 규칙(예: LT_SUM 합산 여부)은 **확인 필요** |
| R13 | 날짜·버킷 규칙 | Fact Pack에 근거 없음 | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 메서드(줄) | SP | 읽기 | 쓰기 | 화면설계서 §5 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | `<field:dtFromCountry>`(44), `<field:dtToCountry>`(46) | (UP_FX_GetCommonDataList 코드분기) | SCM_MST_COUNTRY | — | A1 화면 로드(시점 확인 필요) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtTransMode>`(49) | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A1 |
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | GetFromSitebyDivision(1187) | (UP_FX_GetCommonDataList / _SCP) | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION | — | 호출자 없음(확인 필요) |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | GetToSitebyDivision(1195) | (UP_FX_GetCommonDataList / _SCP) | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION | — | 호출자 없음(확인 필요) |
| `biz:CommonData.CommonDataList` [code=BodType] | GetBodType(1207) | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER_DETAIL | — | 호출자 없음(확인 필요) |
| `biz:CommonData.CommonDataList` [code=TransportMode] | GetTransMode(1217) | (UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER_DETAIL | — | 호출자 없음(확인 필요) |
| `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`(48), `<field:dtValidYN>`(51) | — (Data.CallBizData) | 확인 필요 | — | A1 |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | FindDataMain(424) | `SCP0005_GET_DISTRIBUTION_ROUTE` | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (REF FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT) | — | A4 조회, A6 저장 후 재조회, A8 Upload |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` | FindDataReceive(499) | `SCP0005_GET_DISTRIBUTION_ROUTEID` | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (REF FN_GET_LOOKUP_CODE_DESC) | — | A4 조회(분기) |
| `SCP.SCP0005_GET_COUNTRY_CITY` | GetData_Country(916) | `SCP0005_GET_COUNTRY_CITY` | SCM_MST_CITY | — | A4 조회(분기) |
| `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` | SaveData(752) | `SCP0005_SAVE_DISTRIBUTION_ROUTE` | SCP_MST_DISTRIBUTION_ROUTE | SCP_MST_DISTRIBUTION_ROUTE(I/U/D), SCP_MST_DISTRIBUTION_ROUTE_H(I), SCM_SYS_LOG_BATCH(I) / EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST, PR_SCM_SYS_LOG_BATCH_CALL_TRAN | A6 저장 |
| `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 팝업 FindData(171) | `SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE_H, SCM_ADM_LOOKUP_MASTER_DETAIL (REF FN_GET_LOOKUP_CODE_DESC) | — | A10 이력 팝업 |

## 6. division·권한별 변형

### 6-1. division
- 그리드 표시 컬럼 수는 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. `Distribution Route` 는 39, `POPUP` 은 16입니다.
- 코드에서 division에 따라 갈라지는 곳은 0건이고, 판단불가 분기도 0건입니다.
- `FromSiteByDivision`/`ToSiteByDivision` 공통코드 메서드는 있지만 호출자가 없습니다. 이 화면에서 division별 사이트 필터를 쓰는지는 **확인 필요**입니다.

### 6-2. 권한
| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행. 그룹별 플래그 값은 **확인 필요** |
| 사용자 그룹 | `<field:UserGroup>` 가 UserInfoContext.Current["NowGroupID"] 를 읽음(60행). 사용처는 확인 필요 |
| R | 조회 SP 4종 |
| C/U/D | 저장 SP 1종(`SCP0005_SAVE_DISTRIBUTION_ROUTE`) |
| 사이트 권한 | TB_FX_USERGROUPAUTHEXTENTION 참조(Site 공통코드, 호출자 없음) |

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템 인터페이스가 없습니다. 내부 배치 로그(SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN)는 있지만, 이것이 외부 연계인지는 **확인 필요**입니다.
- Excel 업로드와 양식 파일은 사용자 파일 입출력이며, 형식은 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 사유 |
|---:|---|---|
| 1 | FindButton에서 FindDataMain / FindDataReceive / GetData_Country 로 갈라지는 조건 | 조건식이 Fact Pack에 없음 |
| 2 | 필드 초기화 biz 5건(44·46·48·49·51행)의 실행 시점 | 진입점이 연결되지 않음 |
| 3 | GetFromSitebyDivision / GetToSitebyDivision / GetBodType / GetTransMode 사용 여부 | 호출자 없음 |
| 4 | `popCity` 의 클래스와 엔드포인트 | Fact Pack에 없음 |
| 5 | `spdMain_CellDoubleClick` → 이력 팝업 호출 여부와 넘기는 키(ROUTE_ID 여부) | 직접 근거 없음 |
| 6 | `spdMainDataModel_Changed` 가 바꾸는 셀과 계산식 | 본문 없음 |
| 7 | `btnEaxel_Upload_Click` 의 업로드 저장 경로 | 흐름상 조회 SP만 연결됨 |
| 8 | `btnExcel_Form_Click` 양식 생성 방식 | 엔드포인트 없음 |
| 9 | SaveButton:333 SaveData 매핑 충돌 | 4-2 표는 PersonalSettingPopup.SaveData, flow.csv는 화면 SaveData(752)로 연결 |
| 10 | 각 SP의 파라미터와 출력 컬럼(메타 39/16컬럼과 일치하는지) | SP 실행 결과 매칭 없음 |
| 11 | `biz:CommonData.YesOrNo` 데이터 출처 | DB 보강 없음 |
| 12 | 라벨 `*` 컬럼의 입력 필수 검증 | 근거 없음 |
| 13 | EditButton(318) 동작 | GetSheetInfo 호출만 확인됨 |
| 14 | 메뉴 위치 | Fact Pack에 없음 |

=== FILE: screen_design.md ===
# SCP0005 Distribution Route — 화면설계서

> 근거: Fact Pack(controls.csv·props.csv·events.csv·flow.csv·grid_effective.csv·grid_code.csv)에 있는 사실만 사용했습니다. 없는 값은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0005 | Fact Pack |
| 화면 명칭 | Distribution Route | props.csv this.Text (Designer.cs:555) |
| 메인 폼 클래스 | `SCP0005_DistributionRoute` | controls.csv |
| 공유 팝업 | `SCP0005_DistributionRoutePopup` — Text "DistributionRoute History" | props.csv Popup.Designer.cs:99 |
| 도메인 | SCP | 프로젝트 GSCM.SCP.Forms.UIL |
| 메뉴 위치 | **확인 필요** (메타 TB_FX_MenuItemInfo 1행이 있지만 본문 값은 없음) | |
| 시트 | `Distribution Route`(메인), `POPUP`(팝업) | grid_code.csv |

## 2. 화면 레이아웃

### 2-1. 분할 구조 판정
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 그래서 분할 트리가 아니라 **Dock 기반 상/하 2단** 구조입니다. 좌/우 분할은 없습니다.
- controls.csv의 parent 체인:
```
this (SCP0005_DistributionRoute)
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1227×65, UsrPanelType=HidePanel]
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Fill, 1227×65, Text="usrLayoutControl2"]
│        ├─ cboValidYN       [UsrCombo 168×20]        (layoutControlItem3 "Valid")
│        ├─ clbTransMode     [UsrCheckedList 149×21]  (layoutControlItem4 "Trans Mode")
│        ├─ txtFromCountry   [TextBox 139×25]         (layoutControlItem5 "From Country")
│        ├─ txtFromCity      [TextBox 142×25]         (layoutControlItem2 "From City")
│        ├─ btnFromSrch      [UsrButton 39×25]        (layoutControlItem7 Text="layoutControlItem6")
│        ├─ txtToCountry     [TextBox 169×25]         (layoutControlItem1 "To Country")
│        ├─ txtToCity        [TextBox 177×25]         (layoutControlItem8 "To City")
│        ├─ btnToSrch        [UsrButton 39×25]        (layoutControlItem6, Text 없음)
│        ├─ btnEaxel_Upload  [SimpleButton 76×22, "Upload"]     (layoutControlItem9)
│        └─ btnExcel_Form    [SimpleButton 87×22, "Excel Form"] (layoutControlItem10)
├─ spdMain  [FpSpread, Dock=Fill, 1227×492]
│   └─ spdMain_Sheet1 → 시트 "Distribution Route" (AddSheet@CreateSpread:233)
└─ (parent 미지정) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657×184] / layoutControlGroup1 657×184 — 실사용 여부 확인 필요
   imageList1 [ImageList] — 용도 확인 필요

SCP0005_DistributionRoutePopup ("DistributionRoute History")
└─ spdMain [FpSpread, Dock=Fill, 1387×589]
    └─ spdMain_Sheet1 → 시트 "POPUP" (AddSheet@CreateSpread:122)
```

### 2-2. 텍스트 와이어프레임 (메인)
높이 비율은 Designer Size로 계산했습니다. 조회 영역 65 ÷ 전체 557 ≈ **11.7%**, 그리드 492 ÷ 557 ≈ **88.3%**입니다. 실행 중 창 크기에 따라 달라집니다.
```
┌──────────────────────────────── Distribution Route (1227) ───────────────────────────────┐
│ [조회조건] usrConditionPanel1 (Top, 접기 가능 HidePanel)                    ≈11.7%      │
│  행1(h25): Valid [cboValidYN▼] | Trans Mode [clbTransMode☑▼] | (emptySpaceItem4 783)     │
│  행2(h29): From Country [txtFromCountry] From City [txtFromCity][btnFromSrch]            │
│            To Country [txtToCountry] To City [txtToCity][btnToSrch]                      │
│            [btnEaxel_Upload "Upload"] [btnExcel_Form "Excel Form"] (emptySpaceItem1 61)  │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ [그리드] spdMain — 시트 "Distribution Route" (Fill, 헤더 2행, 39컬럼)       ≈88.3%      │
│                                                                                          │
└──────────────────────────────────────────────────────────────────────────────────────────┘
 툴바(프레임워크): FindButton(조회) · SaveButton(저장) · EditButton(318)
```
- 행 배치는 LayoutControlItem 높이(25/29)와 폭의 합으로 추정했습니다. layoutControlGroup2는 1227×74입니다. 행1 폭 합은 202+222+783=1207, 행2 폭 합은 222+202+43+240+225+43+80+91+61=1207입니다. 실제 좌표는 Fact Pack에 없어 **확인 필요**입니다.

### 2-3. 팝업 와이어프레임
```
┌─────────── DistributionRoute History (1387) ───────────┐
│ spdMain — 시트 "POPUP" (Fill 100%, 헤더 2행, 16컬럼)   │
└─────────────────────────────────────────────────────────┘
```

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | UsrPanelType=HidePanel, Dock Top | — | — | 조회조건 패널(접기/펼치기) |
| usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | Dock Fill | — | — | 조회조건 레이아웃 그리드 |
| usrLayoutControl1 | UsrLayoutControl | — | Dock Fill, 657×184, parent 미지정 | — | — | 해당 없음(실사용 확인 필요) |
| cboValidYN | UsrCombo | "Valid" | 확인 필요(후보 dtValidYN = `biz:CommonData.YesOrNo`) | 확인 필요 | — | Wijmo ComboBox(단일) |
| clbTransMode | UsrCheckedList | "Trans Mode" | 확인 필요(후보 dtTransMode = `biz:CommonData.CommonDataList` [LookupCommon]) | 확인 필요 | — | Wijmo MultiSelect |
| txtFromCountry | TextBox | "From Country" | 빈값(확인 필요) | 확인 필요 | btnFromSrch_Click 이 값을 채움 | InputText |
| txtFromCity | TextBox | "From City" | 빈값(확인 필요) | 확인 필요 | btnFromSrch_Click 이 값을 채움 | InputText |
| btnFromSrch | UsrButton | 아이템 Text "layoutControlItem6"(원문), 버튼 Text 없음 | — | — | Click → `btnFromSrch_Click` | 검색 아이콘 버튼 → City 팝업 |
| txtToCountry | TextBox | "To Country" | 빈값(확인 필요) | 확인 필요 | btnToSrch_Click 이 값을 채움 | InputText |
| txtToCity | TextBox | "To City" | 빈값(확인 필요) | 확인 필요 | btnToSrch_Click 이 값을 채움 | InputText |
| btnToSrch | UsrButton | 없음 | — | — | Click → `btnToSrch_Click` | 검색 아이콘 버튼 → City 팝업 |
| btnEaxel_Upload | SimpleButton | "Upload" | — | — | Click → `btnEaxel_Upload_Click` (InitEvent:189) | Excel 업로드 버튼 |
| btnExcel_Form | SimpleButton | "Excel Form" | — | — | Click → `btnExcel_Form_Click` (Designer:327) | Excel 양식 버튼 |
| spdMain (메인) | FpSpread | — | Dock Fill 1227×492 | — | CellDoubleClick → `spdMain_CellDoubleClick`; 데이터모델(dsdm) Changed → `spdMainDataModel_Changed` | Wijmo FlexGrid |
| spdMain_Sheet1 (메인) | SheetView | 시트 "Distribution Route" | 헤더 2행 | — | — | FlexGrid 컬럼 정의(메타) |
| spdMain (팝업) | FpSpread | — | Dock Fill 1387×589 | — | — | 팝업 내 Wijmo FlexGrid |
| spdMain_Sheet1 (팝업) | SheetView | 시트 "POPUP" | 헤더 2행 | — | — | 팝업 FlexGrid 컬럼 정의 |
| 폼(this, 메인) | Form | "Distribution Route" | — | — | Load → `Form_Load` (.ctor:144) | 페이지 |
| 폼(this, 팝업) | Form | "DistributionRoute History" | — | — | Load → `Form_Load` (.ctor:98) | 모달 팝업 |

부속 레이아웃(To-Be 대상 아님): layoutControlGroup1/2, layoutControlItem1~10, emptySpaceItem1(61×29), emptySpaceItem4(783×25), imageList1.

## 4. 그리드 명세

공통 사항
- 출처: 모든 컬럼이 META(SCM_MST_SHEET_COLUMNS)입니다. 하드코딩 컬럼은 0개입니다.
- 헤더: 2행(SetSheetHeaderColumn iColumnHeaderRowCount=2)입니다. 그룹 헤더명은 ATTRIBUTE1~5에 들어 있다고 보이지만 값은 **확인 필요**입니다.
- 타입·편집 가능 여부: 메타 CELL_CONTROL_OBJECT_TYPE_CODE와 FIXED_FLAG 값이 Fact Pack 본문에 없어 **확인 필요**입니다.
- division별 표시: 14개 division 모두 같습니다(필수=표시, 기본=표시).
- 아래 순서는 의미 단위로 묶은 순서이고 **실제 화면 컬럼 순서가 아닙니다**(확인 필요).
- 코드 쪽 표시 변경: ColumnHeader 기본 스타일(HorizontalAlignment/VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced). 메인은 Designer 515~518행, 팝업은 65~68행입니다. 조회 결과가 1행 이상일 때 `SetSpreadColumn(siMain)` 을 호출합니다.

### 4-1. 시트 `Distribution Route` (39컬럼)

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | ROUTE_ID | Route Id | 확인 필요 | META | 14개 전부 필수 | 확인 필요 |
| 2 | FROM_COUNTRY | Country* | 확인 필요 | META | 14개 전부 기본 | 확인 필요 |
| 3 | FROM_CITY | City* | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | FROM_CITY_NAME | City Name | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | TO_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | TO_CITY | City* | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_CITY_NAME | City Name | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | D_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | D_PORT_CODE | Port Code* | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | D_PORT_NAME | Port* | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | A_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | A_PORT_CODE | Port Code* | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | A_PORT_NAME | Port* | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | TRANSPORT_MODE | Trans Mode* | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | SHIPPING_COMPANY | Forwarder* | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | LT_TYPE | L/T Type* | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | VALID_YN | Valid* | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 기본 | 확인 필요 |
| 21 | LT_VOYAGE | Voyage | 확인 필요 | META | 기본 | 확인 필요 |
| 22 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | LT_SUM | Total L/T | 확인 필요 | META | 기본 | 확인 필요 |
| 25 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Date | 확인 필요 | META | 기본 | 확인 필요 |
| 26 | One_SEGMENT_COST | Pick Up Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 27 | Two_SEGMENT_COST | Freight Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 28 | Three_SEGMENT_COST | Delivery Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 29 | DAYS_MON | Mon | 확인 필요 | META | 기본 | 확인 필요 |
| 30 | DAYS_TUE | Tue | 확인 필요 | META | 기본 | 확인 필요 |
| 31 | DAYS_WED | Wed | 확인 필요 | META | 기본 | 확인 필요 |
| 32 | DAYS_THU | Thu | 확인 필요 | META | 기본 | 확인 필요 |
| 33 | DAYS_FRI | Fri | 확인 필요 | META | 기본 | 확인 필요 |
| 34 | DAYS_SAT | Sat | 확인 필요 | META | 기본 | 확인 필요 |
| 35 | DAYS_SUN | Sun | 확인 필요 | META | 기본 | 확인 필요 |
| 36 | CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| 37 | CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| 38 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| 39 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |

### 4-2. 시트 `POPUP` (16컬럼, 이력 팝업)

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | ROUTE_ID | Route Id | 확인 필요 | META | 14개 전부 필수 | 확인 필요 |
| 2 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | LT_VOYAGE | Voyage | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | LT_SUM | Total L/T | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | DAYS_MON | Mon | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | DAYS_TUE | Tue | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | DAYS_WED | Wed | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | DAYS_THU | Thu | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | DAYS_FRI | Fri | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | DAYS_SAT | Sat | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | DAYS_SUN | Sun | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 메인 화면 로드 | `Form_Load` (.ctor:144) | InitControls(조회조건 복원). 필드 초기화 공통코드는 진입점 미연결(시점 확인 필요) | `biz:CommonData.CommonDataList` [COUNTRY_MST, LookupCommon], `biz:CommonData.YesOrNo` | cboValidYN·clbTransMode 데이터 후보(확인 필요), 조회조건 복원 |
| A2 | btnFromSrch 클릭 | `btnFromSrch_Click` | popCity 결과 반영 | popCity 엔드포인트는 확인 필요 | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City |
| A3 | btnToSrch 클릭 | `btnToSrch_Click` | popCity 결과 반영 | popCity 엔드포인트는 확인 필요 | txtToCountry ← popCity.Country, txtToCity ← popCity.City |
| A4 | 툴바 FindButton | (프레임워크 오버라이드) FindDataMain / FindDataReceive / GetData_Country | 분기 조건 확인 필요 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` / `SCP.SCP0005_GET_COUNTRY_CITY` | 시트 `Distribution Route` 바인딩. Rows>0이면 SetSpreadColumn. GET_COUNTRY_CITY 결과 반영 위치(SetCityCode 여부)는 확인 필요 |
| A5 | 그리드 셀 값 변경 | `spdMainDataModel_Changed` | 핸들러 해제(970) → 처리 → 재등록(1082) | 없음 | 변경 셀·계산 확인 필요 |
| A6 | 툴바 SaveButton | SaveData(752) | 저장 → 오류 확인 → 재조회 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 오류: ERR_MESSAGE(871). 성공: 목록 재조회 |
| A7 | 그리드 셀 더블클릭 | `spdMain_CellDoubleClick` | Changed 핸들러 해제(1135) → 처리 → 재등록(1164) | 없음(팝업 호출 여부 확인 필요) | 확인 필요 |
| A8 | btnEaxel_Upload 클릭 | `btnEaxel_Upload_Click` | 업로드(방식 확인 필요) → FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 목록 재조회 |
| A9 | btnExcel_Form 클릭 | `btnExcel_Form_Click` | 양식 생성(확인 필요) | 없음 | 확인 필요(메타 SCM_ADM_EXCEL_COLUMNS 1행) |
| A10 | 팝업 로드 / 팝업 FindButton | `Form_Load` (.ctor:98) → FindData(171) | 이력 조회 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 시트 `POPUP` 바인딩 |
| A11 | 툴바 EditButton | EditButton(318) | `if(fps.Name == "spdMain")` 조건에서 GetSheetInfo | 없음 | 확인 필요 |
| (참고) | 호출자 없음 | GetFromSitebyDivision / GetToSitebyDivision / GetBodType / GetTransMode | — | `biz:CommonData.CommonDataList` [FromSiteByDivision / ToSiteByDivision / BodType / TransportMode] | 사용 여부 확인 필요 |

## 6. 검증·메시지

| 항목 | 사실 | 비고 |
|---|---|---|
| 저장 오류 | SaveData가 `dtErr.Rows[0]["ERR_MESSAGE"]` 를 읽음(871) | 메시지 표시 방식(MessageBox 등)은 확인 필요 |
| 빈 조회 결과 | Rows.Count = 0이면 SetSpreadColumn을 호출하지 않음 | 빈 결과 안내 메시지가 있는지는 확인 필요 |
| 필수 입력 | 메타 라벨에 `*` 표시가 15개 | 검증 로직 위치는 확인 필요 |
| 메시지 코드 | Fact Pack에 없음 | 확인 필요 |
| 헤더 Note 표시 | ColumnHeader NoteIndicatorColor=Red | 용도는 확인 필요 |

## 7. 권한 (C/R/U/D)

| 권한 | 사실 |
|---|---|
| R | 조회 엔드포인트 4종(ROUTE, ROUTEID, COUNTRY_CITY, HISTORY_ROUTEID) |
| C/U/D | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` 1종(INSERT/UPDATE/DELETE) |
| 메뉴 권한 | TB_FX_GroupMenuAuth 13행. 그룹별 플래그 값과 버튼 활성/비활성 연동은 **확인 필요** |
| 그룹 | UserInfoContext.Current["NowGroupID"](60행) |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 항목 | AS-IS | To-Be 고려 |
|---|---|---|
| 레이아웃 | Dock Top 조회패널 + Fill 그리드 | 조회조건 영역 + FlexGrid 2단. 비율 11.7/88.3은 Designer 값 기준 |
| 그리드 | FarPoint FpSpread, 메타 SetSheetHeaderColumn, 헤더 2행 | Wijmo FlexGrid + 메타 컬럼(SCM_MST_SHEET_COLUMNS) 2단 헤더(columnHeaders 행 추가/병합) |
| 셀 변경 이벤트 | dsdm.Changed 핸들러를 해제하고 재등록 | FlexGrid cellEditEnded. 재귀를 막는 플래그로 대체 |
| 셀 더블클릭 | spdMain.CellDoubleClick | FlexGrid hostElement dblclick / hitTest |
| City 검색 | popCity 팝업 | 공통 City 검색 팝업(엔드포인트 확인 후 결정) |
| 다중 선택 | UsrCheckedList + GetCheckedListValue(CODE) | Wijmo MultiSelect. SP 쪽 STRING_SPLIT → Oracle 문자열 분해 방식으로 변환 필요 |
| SP | MSSQL SP 5종 | Oracle PKG/SP로 변환. STRING_SPLIT 등 MSSQL 전용 구문 제거 |
| 저장 | 배열 파라미터 + SCM_ARR_SPL_CNT/VAL | 행 단위 JSON/리스트 바인딩 검토 |
| 버튼 철자 | btnEaxel_Upload | AS-IS 이름은 대조용으로만 쓰고, To-Be 이름은 명명 규약을 따름 |
| 이력 팝업 | 공유 팝업(GSCM.SCM.Popup.UIL) | 공용 팝업 컴포넌트 위치 검토 |

## 9. 미확정

1. 메뉴 위치
2. FindButton 3경로의 분기 조건
3. popCity의 정체와 엔드포인트
4. spdMain_CellDoubleClick → 이력 팝업 호출 여부, 넘기는 키
5. spdMainDataModel_Changed 셀 계산
6. Excel Upload 저장 경로, Excel Form 양식 생성 방식
7. 그리드 컬럼 실제 순서, 2단 헤더 그룹명, 셀 타입, 편집 가능 여부
8. cboValidYN·clbTransMode의 초기값과 데이터 바인딩
9. usrLayoutControl1, imageList1 용도
10. SaveButton:333 SaveData 매핑 충돌
11. TB_FX_GroupMenuAuth 권한 값

=== FILE: unit_test.md ===
# SCP0005 Distribution Route — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 0건이라 테스트 대상이 없습니다. 기대결과 가운데 Fact Pack으로 확정하지 못한 부분은 '확인 필요'로 적었습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0005-001 | 초기화 | 메뉴 권한이 있는 사용자로 로그인 | SCP0005 화면을 엽니다 | — | 화면 Text "Distribution Route"가 보이고, usrConditionPanel1(HidePanel)과 spdMain이 표시됩니다 | `Form_Load`(.ctor:144), 시트 `Distribution Route` |
| TC-SCP0005-002 | 초기화 | 이전에 저장한 조회조건이 있음(TB_FX_SearchCondition) | 화면을 엽니다 | — | 조회조건 컨트롤(cboValidYN, clbTransMode, txtFromCountry 등)에 저장값이 복원됩니다(ControlName/ControlValue) | `Form_Load` → InitControls:208/210 |
| TC-SCP0005-003 | 초기화 | 화면 열림 | cboValidYN 목록을 펼칩니다 | — | YesOrNo 목록이 표시됩니다(바인딩·호출 시점 확인 필요) | `biz:CommonData.YesOrNo` (dtValidYN:51, dtYesOrNo:48) |
| TC-SCP0005-004 | 초기화 | 화면 열림 | clbTransMode 목록을 펼칩니다 | — | LookupCommon 코드 목록이 표시됩니다(바인딩 확인 필요) | `biz:CommonData.CommonDataList` [code=LookupCommon] (dtTransMode:49) |
| TC-SCP0005-005 | 초기화 | 화면 열림 | 국가 공통코드 로딩을 확인합니다(필드 dtFromCountry/dtToCountry) | — | SCM_MST_COUNTRY 기준 국가 목록이 로딩됩니다(사용 위치 확인 필요) | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] (44/46) |
| TC-SCP0005-006 | 조회 | 화면 열림, SCP_MST_DISTRIBUTION_ROUTE에 데이터 있음 | 조회조건(cboValidYN, clbTransMode)을 입력하고 툴바 조회(FindButton)를 누릅니다 | Valid=Y, Trans Mode=1개 이상 체크 | spdMain 시트 `Distribution Route` 에 결과가 바인딩되고 SetSpreadColumn(siMain)이 실행됩니다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` (FindDataMain:424, 452) |
| TC-SCP0005-007 | 조회 | 화면 열림 | 결과가 없는 조건으로 FindButton을 누릅니다 | 존재하지 않는 txtFromCity 값 | 그리드가 0행이고 SetSpreadColumn은 호출되지 않습니다(Rows.Count>0 조건). 안내 메시지 여부는 확인 필요 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` (452 조건) |
| TC-SCP0005-008 | 조회 | FindDataReceive 분기 조건 충족(조건 확인 필요) | FindButton을 누릅니다 | ROUTE_ID 관련 조건(확인 필요) | 시트 `Distribution Route` 에 ROUTE_ID 기준 결과가 표시되고, Rows>0이면 SetSpreadColumn이 실행됩니다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` / SP `SCP0005_GET_DISTRIBUTION_ROUTEID` (FindDataReceive:499, 521) |
| TC-SCP0005-009 | 조회 | GetData_Country 분기 조건 충족(확인 필요) | FindButton을 누릅니다 | txtFromCountry/txtToCountry 값 | SCM_MST_CITY 기준 국가·도시 데이터가 조회됩니다. SetCityCode(COUNTRY, CITY, CITY_NAME) 반영 여부는 확인 필요 | `SCP.SCP0005_GET_COUNTRY_CITY` / SP `SCP0005_GET_COUNTRY_CITY` (GetData_Country:916) |
| TC-SCP0005-010 | 조회 | 조회 SP 오류 상황(DB 연결 실패 등) | FindButton을 누릅니다 | — | 오류를 처리하고 그리드는 갱신되지 않습니다(오류 표시 방식 확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-011 | 이벤트 | 화면 열림 | btnFromSrch를 누르고 City 팝업(popCity)에서 한 행을 선택합니다 | Country/City 선택 | txtFromCountry = popCity.Country, txtFromCity = popCity.City | `btnFromSrch_Click` (350/351) |
| TC-SCP0005-012 | 이벤트 | 화면 열림 | btnToSrch를 누르고 City 팝업(popCity)에서 한 행을 선택합니다 | Country/City 선택 | txtToCountry = popCity.Country, txtToCity = popCity.City | `btnToSrch_Click` (368/369) |
| TC-SCP0005-013 | 이벤트 | 조회 결과 있음 | spdMain 셀 하나를 편집합니다 | 임의 셀 값 변경 | 핸들러가 해제(970)·재등록(1082)되어 재귀 실행이 일어나지 않습니다. 연쇄 셀 변경 내용은 확인 필요 | `spdMainDataModel_Changed` |
| TC-SCP0005-014 | 이벤트 | 조회 결과 있음 | spdMain 셀을 더블클릭합니다 | 데이터 행 셀 | Changed 핸들러가 해제(1135)·재등록(1164)됩니다. 팝업 호출과 값 설정 여부는 확인 필요 | `spdMain_CellDoubleClick` |
| TC-SCP0005-015 | 이벤트 | 화면 열림 | btnExcel_Form을 누릅니다 | — | Excel 양식이 제공됩니다(생성 방식·컬럼은 확인 필요. 메타 SCM_ADM_EXCEL_COLUMNS 1행) | `btnExcel_Form_Click` (Designer:327) |
| TC-SCP0005-016 | 이벤트 | 업로드할 Excel 파일 준비 | btnEaxel_Upload를 누르고 파일을 선택합니다 | 양식에 맞는 Excel | 업로드 처리 후 FindDataMain으로 재조회되어 시트 `Distribution Route` 가 갱신됩니다(업로드 저장 경로 확인 필요) | `btnEaxel_Upload_Click` → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-017 | 저장 | 조회 결과 있음 | 행을 추가하고 값을 입력한 뒤 툴바 저장(SaveButton)을 누릅니다 | 신규 경로 1행 | SCP_MST_DISTRIBUTION_ROUTE에 INSERT되고 이력(SCP_MST_DISTRIBUTION_ROUTE_H)과 배치 로그(SCM_SYS_LOG_BATCH)가 기록된 뒤 목록이 재조회됩니다 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` (SaveData:752) → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-018 | 저장 | 조회 결과 있음 | 기존 행 값을 바꾸고 SaveButton을 누릅니다 | 리드타임 값 변경 | UPDATE와 이력 기록 후 재조회 결과에 변경값이 반영됩니다 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-019 | 저장 | 조회 결과 있음 | 행을 삭제 표시하고 SaveButton을 누릅니다 | 삭제 대상 1행 | DELETE 후 재조회 결과에서 해당 행이 사라집니다(삭제 UI 방식 확인 필요) | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-020 | 저장 | SP가 오류를 반환하는 데이터 | SaveButton을 누릅니다 | SP 오류 유발 값(조건 확인 필요) | `dtErr.Rows[0]["ERR_MESSAGE"]` 값을 사용자에게 알립니다(표시 방식 확인 필요). 재조회 여부는 확인 필요 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SaveData:871 |
| TC-SCP0005-021 | 그리드 | 조회 완료 | 시트 `Distribution Route` 컬럼을 확인합니다 | — | 메타 39컬럼(ROUTE_ID ~ LAST_UPDATE_DATE)이 헤더 2행으로 표시되고, 헤더 라벨이 메타 원문(Route Id, Country*, …)과 같습니다 | 시트 `Distribution Route`, SetSheetHeaderColumn@InitSpread:246 |
| TC-SCP0005-022 | 그리드 | 조회 완료 | 사용자 컬럼 표시 설정에서 ROUTE_ID를 숨겨 봅니다 | — | ROUTE_ID는 필수(USER_SELECTABLE_FLAG='N')라 숨길 수 없습니다 | 시트 `Distribution Route` (grid_effective ROUTE_ID=필수) |
| TC-SCP0005-023 | 그리드 | 이력 팝업 열림 | 시트 `POPUP` 컬럼을 확인합니다 | — | 메타 16컬럼(ROUTE_ID, LT_*, DAYS_*, LAST_UPDATED_BY, LAST_UPDATE_DATE)이 헤더 2행으로 표시됩니다 | 시트 `POPUP`, SetSheetHeaderColumn@InitSpread:136 |
| TC-SCP0005-024 | 조회 | 이력 데이터가 있는 ROUTE_ID | 이력 팝업(SCP0005_DistributionRoutePopup)을 엽니다 | ROUTE_ID(전달 방식 확인 필요) | 팝업 `Form_Load` 에서 FindData가 실행되어 시트 `POPUP` 에 이력 행이 표시됩니다 | `Form_Load`(팝업 .ctor:98) → `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` / SP `SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` |
| TC-SCP0005-025 | 조회 | 이력 팝업 열림 | 팝업 툴바 FindButton을 누릅니다 | — | 이력을 다시 조회합니다 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` (FindData:171) |
| TC-SCP0005-026 | 조회 | 이력이 없는 ROUTE_ID | 이력 팝업을 엽니다 | 이력 없는 ROUTE_ID | 시트 `POPUP` 이 0행입니다(안내 메시지 여부 확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` |
| TC-SCP0005-027 | division | division 40, 81, 82, EE(및 하위 HD/HG/HM/ST/UC) 사용자 각각 | 화면을 열고 조회합니다 | — | 모든 division에서 `Distribution Route` 39컬럼, `POPUP` 16컬럼이 똑같이 표시됩니다(division 변형 없음) | 시트 `Distribution Route`, 시트 `POPUP` (grid_rule 14 division 동일) |
| TC-SCP0005-028 | 권한 | 조회 권한만 있는 그룹(TB_FX_GroupMenuAuth 값 확인 필요) | 화면을 열고 SaveButton 상태를 확인합니다 | — | 권한 값에 따라 저장이 제한됩니다(구체 동작 확인 필요) | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-029 | 초기화 | 화면 열림 | 사이트·BOD·운송모드 공통코드 사용처를 확인합니다 | — | GetFromSitebyDivision/GetToSitebyDivision/GetBodType/GetTransMode는 호출자가 없습니다. 실사용 여부를 확인하고, 미사용이면 NA로 판정합니다 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision/ToSiteByDivision/BodType/TransportMode] |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 002, 024 |
| 핸들러 | `btnToSrch_Click` | 012 |
| 핸들러 | `btnFromSrch_Click` | 011 |
| 핸들러 | `btnExcel_Form_Click` | 015 |
| 핸들러 | `spdMain_CellDoubleClick` | 014 |
| 핸들러 | `btnEaxel_Upload_Click` | 016 |
| 핸들러 | `spdMainDataModel_Changed` | 013 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 004, 005, 029 |
| 엔드포인트 | `biz:CommonData.YesOrNo` | 003 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 006, 007, 010, 016, 017 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` | 008 |
| 엔드포인트 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` | 017~020, 028 |
| 엔드포인트 | `SCP.SCP0005_GET_COUNTRY_CITY` | 009 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 024~026 |
| 시트 | `Distribution Route` | 001, 021, 022, 027 |
| 시트 | `POPUP` | 023, 024, 027 |
| 빈 결과 | — | 007, 026 |
| 오류 응답 | — | 010, 020 |
