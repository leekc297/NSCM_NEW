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
