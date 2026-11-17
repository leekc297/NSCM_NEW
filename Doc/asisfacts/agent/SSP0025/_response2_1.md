=== FILE: business_analysis.md ===
# SSP0025 업무분석서 — Shipment Requestor PIC

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0025)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)
> Fact Pack에 없는 내용은 모두 **확인 필요**로 표기했습니다. 주석 처리된 호출(commented_calls)은 0건입니다. 이 문서의 기능은 모두 활성 코드 기준입니다.
> 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같은 표기를 씁니다.

## 1. 업무 목적·범위

### 1-1. 목적
- 화면 클래스명은 `SSP0025_ShipmentRequestorPIC`, 메인 시트명은 `Shipment Requestor PIC`입니다.
- 저장 SP `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`는 `SSP_MST_MODEL_USER_EE` 테이블에 MERGE합니다. 메인 그리드에는 Material(`ITEM_ID`)·Model(`MODEL_ID`)·Plant Site(`SITE_DESCRIPTION`/`TO_SITE`) 컬럼과 담당자 컬럼(`USER_ID`, `USER_NAME`, `PART_LEADER`, `TEAM_LEADER` 등)이 함께 있습니다.
- 위 사실을 보면 이 화면은 **Plant Site·Material·Model 단위로 Shipment Requestor 담당자(PIC)를 조회하고 등록·수정하는 마스터 관리 화면**입니다. 업무 용어의 정식 정의(예: "Shipment Requestor"의 업무상 역할)는 Fact Pack에 없어 **확인 필요**입니다.

### 1-2. 범위
| 구분 | 범위 | 근거 |
|---|---|---|
| 메인 화면 | 조회(FindButton), 편집 진입(EditButton), 행 추가(InsertRow), 저장(SaveButton) | flow.csv, grid_code.csv |
| 팝업 | `SSP0025_ItembyDivisionPopup`(제목 `"Item by DivisionPopup"`)에서 Material/Model 조회·선택 | flow.csv, props.csv:456 |
| 대상 테이블(쓰기) | `SSP_MST_MODEL_USER_EE`(MERGE), `SCM_SYS_LOG_BATCH`(INSERT) | endpoints.csv |
| 범위 밖 | 외부 시스템 연계. Fact Pack에 없음 | - |

### 1-3. 파일 구성
| 파일 | 줄수 |
|---|---:|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0025_ShipmentRequestorPIC.cs` | 742 |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0025_ShipmentRequestorPIC.Designer.cs` | 587 |
| `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0025_ItembyDivisionPopup.cs` | 447 |
| `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0025_ItembyDivisionPopup.Designer.cs` | 502 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 연다 | `Form_Load` > InitControls > SetChangedControl(140)이 `biz:CommonData.CommonDataList` [code=PlantCell]을 호출한다. 클래스 필드 초기화 시점에 `dtMyDivision`(45, `biz:CommonData.CommonDataList` [code=MyDivision])과 `dtYesOrNo`(47, `biz:CommonData.YesOrNo`)를 준비한다 | Plant Site 체크리스트(clbFromSite)를 채운다. `dtYesOrNo`의 사용처는 **확인 필요** |
| S2 | Division(`Div*`)을 바꾼다 | `CboDivision_SelectedIndexChanged` > SetChangedControl(140)이 `biz:CommonData.CommonDataList` [code=PlantCell]을 호출한다(GetCheckedListValue:139) | 고른 Division 기준으로 Plant Site 목록을 다시 채운다 |
| S3 | Material 또는 Model의 팝업 버튼을 누른다 | `btnItemId_Click` / `btnModelId_Click` → 팝업 `Form_Load`가 `biz:CommonData.CommonDataList` [code=FromSiteByAssembly](206)와 `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`(296)을 호출한다 | 팝업 시트 `Project`에 품목 목록이 나온다. 선택 결과는 `txtItemId.Text = popItem.ItemId`(718) 또는 `txtModelId.Text = popItem.ModelId`(736)로 반영된다 |
| S4 | 팝업 안에서 다시 조회한다 | `btnButtonList_UsrButtonList_Click_Detected` 또는 FindButton > FindData(296)가 `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`을 호출한다 | `Project` 시트를 다시 조회한다 |
| S5 | 조회조건을 입력하고 조회(FindButton)한다 | FindData_Main(274)이 `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`을 호출한다. 체크리스트 값은 GetCheckedListValue(258·259)의 CODE를 쓴다 | `Shipment Requestor PIC` 시트에 결과가 나온다 |
| S6 | 편집(EditButton)을 누른다 | GetSSPUserCheck(511)가 `SSP.SSP0002_GET_USER_INFO_LIST`를 호출한다 | 사용자 정보와 권한을 확인한다. 편집 허용 조건은 **확인 필요** |
| S7 | 행을 추가한다(InsertRow) | 시트가 잠겨 있지 않으면(`siMain.IsLock(...) == false`) DIVISION_ID 셀을 `dtMyDivision` 콤보로, SITE_DESCRIPTION 셀을 `dtToSite`(`biz:CommonData.CommonDataList` [code=PlantCell]) 콤보로 바꾼다(318·320) | 신규 행에서 Division과 Plant Site를 콤보로 고를 수 있다. InsertRow를 호출하는 버튼은 **확인 필요** |
| S8 | 신규 행의 Plant Site 셀을 클릭한다 | `SpdMain_CellClick`(639·640): 시트 잠금 해제 상태, 행 Action=`"I"`, 클릭 컬럼=`SITE_DESCRIPTION`이면 `biz:CommonData.CommonDataList` [code=PlantCell]로 콤보를 다시 설정한다 | Plant Site 콤보 목록을 갱신한다 |
| S9 | 저장(SaveButton)을 누른다 | SaveData가 `SSP.SSP0025_GET_USER_ID_CHECK`(GetUserIDChk:458), `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`(410), `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`(FindData_Main:274)을 호출한다 | `SSP_MST_MODEL_USER_EE`에 MERGE하고 `SCM_SYS_LOG_BATCH`에 로그를 남긴 뒤 재조회한다. 세 호출의 순서와 분기는 **확인 필요** |

## 3. 업무 흐름도 (텍스트 단계)

```
[메인 SSP0025_ShipmentRequestorPIC]
 1. 화면 열기 ── Form_Load ─▶ InitControls ─▶ SetChangedControl
                 └▶ biz:CommonData.CommonDataList [code=PlantCell] → clbFromSite
    (필드 초기화) dtMyDivision → biz:CommonData.CommonDataList [code=MyDivision]
                 dtYesOrNo    → biz:CommonData.YesOrNo   (사용처 확인 필요)
 2. Division 변경 ── CboDivision_SelectedIndexChanged ─▶ SetChangedControl
                 └▶ biz:CommonData.CommonDataList [code=PlantCell]
 3. (선택) Material/Model 팝업
       btnItemId_Click / btnModelId_Click
         └▶ [팝업 SSP0025_ItembyDivisionPopup]
              Form_Load ─▶ InitControls ─▶ biz:CommonData.CommonDataList [code=FromSiteByAssembly]
                        └▶ FindData ─▶ SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP
              clbDivision_SelectedIndexChanged ─▶ biz:CommonData.CommonDataList [code=FromSiteByAssembly]
              btnButtonList_UsrButtonList_Click_Detected / FindButton ─▶ FindData ─▶ SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP
              spdMain_CellDoubleClick (동작 확인 필요)
         ◀── popItem.ItemId → txtItemId / popItem.ModelId → txtModelId
 4. 조회 ── FindButton ─▶ FindData_Main ─▶ SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC → 시트 "Shipment Requestor PIC"
 5. 편집 ── EditButton ─▶ GetSSPUserCheck ─▶ SSP.SSP0002_GET_USER_INFO_LIST
 6. 행 추가 ── InsertRow (진입 버튼 확인 필요) ─▶ DIVISION_ID 콤보(MyDivision), SITE_DESCRIPTION 콤보(PlantCell)
       SpdMain_CellClick (신규 행 SITE_DESCRIPTION) ─▶ biz:CommonData.CommonDataList [code=PlantCell]
 7. 저장 ── SaveButton ─▶ SaveData
              ├▶ GetUserIDChk ─▶ SSP.SSP0025_GET_USER_ID_CHECK
              ├▶ SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC
              └▶ FindData_Main ─▶ SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC
              (세 호출의 순서·분기 확인 필요)
 기타 그리드 이벤트: SpdMain_TopChange / SpdMain_CellDoubleClick / SpdMain_ComboSelChange (엔드포인트 없음, 동작 확인 필요)
```

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 근거 | 비고 |
|---|---|---|---|
| R1 | 조회조건 Division 라벨은 `Div*`입니다. 필수 표시 `*`가 붙어 있습니다 | props.csv:392 | 미선택 시 검증 메시지·차단 로직은 **확인 필요** |
| R2 | Plant Site(clbFromSite) 목록은 Division에 따라 달라집니다. Division을 바꾸면 PlantCell 공통코드를 다시 조회합니다 | flow.csv(CboDivision_SelectedIndexChanged > SetChangedControl:140), GetCheckedListValue:139 | - |
| R3 | 조회 파라미터 가운데 체크리스트 값은 `GetCheckedListValue`가 돌려주는 CODE 값을 씁니다 | Fact Pack §4-2 (FindData_Main:258·259) | SP 파라미터 전체 목록은 **확인 필요** |
| R4 | 행 추가 시 콤보 설정은 시트가 잠겨 있지 않고(`siMain.IsLock(siMain.SheetName) == false`) 시트명이 `Shipment Requestor PIC`일 때만 합니다 | grid_code.csv InsertRow:318·320 | - |
| R5 | 신규 행의 DIVISION_ID 콤보는 `MyDivision` 공통코드입니다. 인자는 `UserInfoContext.Current["NowGroupID"]`와 `UserInfoContext.Current.UserId`입니다 | grid_code.csv InsertRow:318, meta_reads.csv:45 | 사용자 그룹에 따라 목록이 달라짐(§6) |
| R6 | 신규 행의 SITE_DESCRIPTION 콤보는 `PlantCell` 공통코드입니다. 인자는 `pDivisionID` 또는 `sDivisionId`입니다 | grid_code.csv InsertRow:320 | 두 인자 중 어느 것을 쓰는지의 분기는 **확인 필요** |
| R7 | 그리드 셀 클릭 시 Plant Site 콤보를 다시 설정하는 조건: 시트 잠금 해제, 행 Action=`"I"`, 클릭 컬럼=`SITE_DESCRIPTION` | grid_code.csv SpdMain_CellClick:640 | 기존 행(Action≠I)에는 적용하지 않음 |
| R8 | 저장 처리에서 사용자 ID 확인 SP(`SSP0025_GET_USER_ID_CHECK`, `TB_FX_USER` 조회)를 호출합니다 | flow.csv(SaveData > GetUserIDChk:458) | 검증 실패 시 처리(메시지·중단)는 **확인 필요** |
| R9 | 저장은 `SSP_MST_MODEL_USER_EE` MERGE(신규·수정 일괄)이고 `PR_SCM_SYS_LOG_BATCH`로 `SCM_SYS_LOG_BATCH`에 로그를 남깁니다 | endpoints.csv SaveData:410 | 삭제 지원 여부는 **확인 필요** |
| R10 | 저장 SP는 `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL`을 참조하고, 조회 SP는 `STRING_SPLIT`을 참조합니다. 여러 값을 구분자 문자열로 넘기는 방식으로 보입니다 | endpoints.csv | 구분자와 형식은 **확인 필요** |
| R11 | 그리드 라벨에 `*`가 붙은 컬럼: `Material*`(ITEM_ID), `Plant Site*`(SITE_DESCRIPTION), `User ID*`(USER_ID), `Valid*`(VALID_YN) | grid_effective.csv(메타 COLUMN_LABEL_NAME) | 저장 시 필수값 검증을 실제로 하는지는 **확인 필요** |
| R12 | 팝업의 Division(clbDivisionId)은 비활성(`Enabled=false`)이고 From Site(clbFromSiteId)만 활성입니다. 팝업의 Material/Model 초기값은 메인에서 받은 `sItemId`/`sModelId`입니다 | props.csv InitControls:201·202·204·205 | 메인→팝업 Division 전달 방식은 **확인 필요** |
| R13 | 날짜·버킷 규칙 | Fact Pack에 없음 | 그리드의 `CREATION_DATE`/`LAST_UPDATE_DATE`는 이력 컬럼. 채번·기록 주체는 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | 호출 위치(메서드:줄) | SP | 읽기 테이블 | 쓰기 테이블 | 기타 참조 |
|---|---|---|---|---|---|---|
| D1 | `biz:CommonData.CommonDataList` [code=PlantCell] | SetChangedControl:140, SpdMain_CellClick:639 (InsertRow:320 dtToSite) | (Biz) UP_FX_GetCommonDataList | SCM_MST_SITE | - | - |
| D2 | `biz:CommonData.CommonDataList` [code=MyDivision] | `<field:dtMyDivision>`:45(메인), :37(팝업) | (Biz) UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | - | NowGroupID |
| D3 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | 팝업 InitControls:206, clbDivision_SelectedIndexChanged:357 | (Biz) UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE | - | DIVISION_ID(358) |
| D4 | `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`:47 | 없음(Data.CallBizData) | **확인 필요** | - | 사용처 **확인 필요** |
| D5 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 팝업 FindData:296 | `SSP0025_GET_ITEM_BY_DIVISION_POPUP` | SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL | - | STRING_SPLIT |
| D6 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | FindData_Main:274 | `SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | SSP_MST_MODEL_USER_EE, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, TB_FX_USER | - | STRING_SPLIT |
| D7 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | SaveData:410 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | - | SSP_MST_MODEL_USER_EE(MERGE), SCM_SYS_LOG_BATCH(INSERT) | EXEC PR_SCM_SYS_LOG_BATCH, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| D8 | `SSP.SSP0025_GET_USER_ID_CHECK` | GetUserIDChk:458 | `SSP0025_GET_USER_ID_CHECK` | TB_FX_USER | - | STRING_SPLIT |
| D9 | `SSP.SSP0002_GET_USER_INFO_LIST` | GetSSPUserCheck:511 | `SSP0002_GET_USER_INFO_LIST` | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | - | SSP0002 화면의 SP를 재사용 |

- 엔드포인트 7종: `biz:CommonData.CommonDataList`(code 3종: PlantCell / MyDivision / FromSiteByAssembly), `biz:CommonData.YesOrNo`, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0002_GET_USER_INFO_LIST`.
- SP 5종: `SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP0025_GET_USER_ID_CHECK`, `SSP0002_GET_USER_INFO_LIST`.
- 미매칭(NOT FOUND) 엔드포인트는 0건입니다.

## 6. Division·권한별 변형

### 6-1. Division
| 항목 | 사실 | 근거 |
|---|---|---|
| 메인 시트 `Shipment Requestor PIC` 컬럼 수 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 19개(필수+기본 19 / 선택 0) | Fact Pack §10·§12 |
| 팝업 시트 `Project` 컬럼 수 | 14개 division 모두 11개(코드추가). 그중 DIVISION_NAME은 숨김이라 표시는 10개 | grid_effective.csv, grid_code.csv:244 |
| 코드 내 division 분기 | 0건 | Fact Pack §12 "분기 조건 판단불가 적용 0건" |
| 결론 | **division별 화면 변형 없음** | - |

### 6-2. 권한
| 항목 | 사실 | 근거 |
|---|---|---|
| 신규 행 Division 콤보 | `MyDivision`: 로그인 사용자의 `NowGroupID`·UserId 기준이고 TB_FX_USERGROUPAUTHEXTENTION을 조회하므로 사용자 그룹마다 고를 수 있는 Division이 다릅니다 | grid_code.csv:318, endpoints.csv |
| 편집 진입 | EditButton > GetSSPUserCheck가 `SSP.SSP0002_GET_USER_INFO_LIST`로 사용자·그룹·권한 확장 정보를 조회합니다 | flow.csv |
| 시트 잠금 | `siMain.IsLock(SheetName)`가 true이면 행 추가 콤보와 셀 클릭 콤보 설정을 하지 않습니다 | grid_code.csv:318·320·640 |
| 메뉴 권한 | TB_FX_GroupMenuAuth에 SSP0025 행 12건이 있습니다 | Fact Pack §8 |
| C/R/U/D 플래그 값 | 12행의 그룹별 값은 Fact Pack에 없습니다 | **확인 필요** |

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템(I/F) 호출 사실은 없습니다.
- 저장 SP가 `PR_SCM_SYS_LOG_BATCH`로 `SCM_SYS_LOG_BATCH`에 기록하는 것은 내부 로그 처리입니다. 외부 I/F가 아닙니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| Q1 | 메인 Form Text가 `"SSP0014_ShipmentModelPIC"`(Designer:539)로 화면 ID와 다름. 실행 시 표시되는 제목 | props.csv |
| Q2 | SaveData 안의 GetUserIDChk(458) / SAVE(410) / FindData_Main(274) 호출 순서, 검증 실패 시 중단 여부, 메시지 | flow.csv(순서 정보 없음) |
| Q3 | Fact Pack §4-2의 `SaveData`(SaveButton:234)가 `PersonalSettingPopup.SaveData`로 해석된 것이 파서 오해석인지 | Fact Pack §4-2 |
| Q4 | EditButton(GetSSPUserCheck) 결과로 편집을 허용하는 조건 | flow.csv |
| Q5 | InsertRow 진입 버튼과 신규 행 기본값 | grid_code.csv:318·320 |
| Q6 | `dtYesOrNo`(`biz:CommonData.YesOrNo`)의 사용처(VALID_YN 콤보인지)와 데이터 원천 | endpoints.csv:47 |
| Q7 | cboDivision(`Div*`) 콤보의 데이터 원천 | Fact Pack 미추출 |
| Q8 | `cellTypeImage`를 적용하는 3개 컬럼(InitSpread:162~164)의 대상과 의미 | grid_code.csv |
| Q9 | 삭제 기능의 존재 여부(SAVE SP가 MERGE만 하는 것으로 추출됨) | endpoints.csv |
| Q10 | SP 파라미터 목록과 다중값 구분자(STRING_SPLIT / SCM_ARR_SPL_*) 형식 | endpoints.csv |
| Q11 | 메뉴 위치(TB_FX_MenuItemInfo 1건의 내용)와 TB_FX_GroupMenuAuth 12건의 C/R/U/D 값 | Fact Pack §8 |
| Q12 | 업무 용어 "Shipment Requestor PIC"의 정식 업무 정의 | Fact Pack 없음 |

=== FILE: screen_design.md ===
# SSP0025 화면설계서 — Shipment Requestor PIC

> 근거: AsisFacts Fact Pack(SSP0025) controls.csv / props.csv / events.csv / flow.csv / grid_code.csv / grid_effective.csv
> 엔드포인트 이름은 업무분석서 §5, 단위테스트 '근거' 열과 같고, 컨트롤명은 단위테스트 '절차' 열과 같습니다. 주석 처리된 호출은 0건입니다.

## 1. 화면 개요

| 항목 | 메인 | 팝업 |
|---|---|---|
| 화면 ID | SSP0025 | (SSP0025 소속 팝업) |
| 클래스 | `SSP0025_ShipmentRequestorPIC` | `SSP0025_ItembyDivisionPopup` |
| 명칭 | Shipment Requestor PIC (시트명 기준) | Item by DivisionPopup |
| Form Text(원문) | `"SSP0014_ShipmentModelPIC"` (Designer:539, 화면 ID와 다름, **확인 필요**) | `"Item by DivisionPopup"` (Designer:456) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1건, 내용 미추출) | 메인에서 btnItemId / btnModelId로 호출 |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 같음 |

## 2. 화면 레이아웃

### 2-1. 분할 구조 근거
- props.csv에 **SplitContainer(Orientation·SplitterDistance)가 없습니다**. 좌/우 분할은 없습니다.
- 분할은 Dock Top(조회조건 패널) + Dock Fill(그리드)의 **상/하 2단**입니다. 비율은 Size 높이로 계산했습니다.

### 2-2. 메인 `SSP0025_ShipmentRequestorPIC` — parent 체인 트리
```
this (Form, Text="SSP0014_ShipmentModelPIC")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192x41, HidePanel]        ← 상단 6.3% (41/649)
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1192x41, Text="usrLayoutControl2"]
│        (layoutControlGroup2 1192x48)
│        ├─ cboDivision   [UsrCombo 128x20]          ← LayoutItem Division      "Div*"
│        ├─ clbFromSite   [UsrCheckedList 140x21]    ← LayoutItem layoutToSite  "Plant Site"
│        ├─ txtItemId     [UsrMultiLineEditor 151x21]← LayoutItem lblItemId     "Material"
│        ├─ btnItemId     [UsrButton 39x24]          ← LayoutItem layoutControlItem4 "layoutControlItem2"
│        ├─ txtModelId    [UsrMultiLineEditor 162x21]← LayoutItem lblModelId    "Model"
│        ├─ btnModelId    [UsrButton 39x24]          ← LayoutItem layoutControlItem1 "layoutControlItem2"
│        ├─ txtNickName   [TextBox 135x24]           ← LayoutItem layoutNickName "Nick Name"
│        └─ (emptySpaceItem2 122x28)
└─ spdMain              [FpSpread, Dock=Fill, 1192x608]                           ← 하단 93.7% (608/649)
     └─ spdMain_Sheet1  [SheetView] → 시트 "Shipment Requestor PIC"
(parent 없음) usrButton1 [UsrButton 75x23] — 배치·사용 여부 확인 필요
(parent 없음) imageList1 [ImageList]
```

와이어프레임(메인):
```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [공통 버튼 바: 조회(FindButton) / 편집(EditButton) / 저장(SaveButton) …]       │ ← 프레임워크 영역
├──────────────────────────────────────────────────────────────────────────────┤
│ 조회조건 usrConditionPanel1 (6.3%)                                            │
│ Div*[cboDivision▼] Plant Site[clbFromSite☑▼] Material[txtItemId][btnItemId]   │
│ Model[txtModelId][btnModelId] Nick Name[txtNickName]                          │
├──────────────────────────────────────────────────────────────────────────────┤
│ 그리드 spdMain / spdMain_Sheet1 — 시트 "Shipment Requestor PIC" (93.7%)        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```
- LayoutControl 안의 컨트롤 좌표(Location)는 Fact Pack에 없습니다. 위 배치 순서는 LayoutItem 선언 순서를 따른 것이고, 실제 좌표 순서는 **확인 필요**입니다.

### 2-3. 팝업 `SSP0025_ItembyDivisionPopup` — parent 체인 트리
```
this (Form, Text="Item by DivisionPopup")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 985x50, HidePanel]          ← 상단 8.7% (50/574)
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 985x50, Text="usrLayoutControl2"]
│        (layoutControlGroup2 985x50)
│        ├─ clbDivisionId [UsrCheckedList 141x21]    ← LayoutItem lblDivision "Division"
│        ├─ clbFromSiteId [UsrCheckedList 147x21]    ← LayoutItem lblFromSite "From Site"
│        ├─ txtItemId     [UsrMultiLineEditor 150x21]← LayoutItem lbItemId    "Material"
│        ├─ txtModelId    [UsrMultiLineEditor 169x21]← LayoutItem lbModelId   "Model"
│        ├─ btnButtonList [UsrButtonList 105x26]     ← LayoutItem layoutControlItem1 (Text 없음)
│        └─ (emptySpaceItem1 35x30)
└─ spdMain              [FpSpread, Dock=Fill, 985x524]                            ← 하단 91.3% (524/574)
     └─ spdMain_Sheet1  [SheetView] → 시트 "Project"
(parent 없음) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657x184] / layoutControlGroup1 657x184 — 용도 확인 필요
```

와이어프레임(팝업):
```
┌─────────────────────────────────────────────────────────────────┐
│ 조회조건 (8.7%)                                                 │
│ Division[clbDivisionId(비활성)] From Site[clbFromSiteId]         │
│ Material[txtItemId] Model[txtModelId] [btnButtonList]            │
├─────────────────────────────────────────────────────────────────┤
│ 그리드 spdMain / spdMain_Sheet1 — 시트 "Project" (91.3%)         │
└─────────────────────────────────────────────────────────────────┘
```

## 3. 컨트롤 명세

### 3-1. 메인
| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 레이아웃 |
| cboDivision | UsrCombo | `Div*` | **확인 필요** | 예(`*` 표시) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 단일선택 ComboBox |
| clbFromSite | UsrCheckedList | `Plant Site` | `biz:CommonData.CommonDataList` [code=PlantCell] 결과 | 아니오(표시 없음) | - | MultiSelect(체크리스트) |
| txtItemId | UsrMultiLineEditor | `Material` | 빈값(**확인 필요**) | 아니오 | - | 멀티라인 입력 |
| btnItemId | UsrButton | `layoutControlItem2` (LayoutItem 기본 Text, 표시 여부 **확인 필요**) | - | - | Click → `btnItemId_Click` | 팝업 호출 버튼 |
| txtModelId | UsrMultiLineEditor | `Model` | 빈값(**확인 필요**) | 아니오 | - | 멀티라인 입력 |
| btnModelId | UsrButton | `layoutControlItem2` (위와 같음) | - | - | Click → `btnModelId_Click` | 팝업 호출 버튼 |
| txtNickName | TextBox | `Nick Name` | 빈값(**확인 필요**) | 아니오 | - | 텍스트 입력 |
| spdMain | FpSpread | - | Dock=Fill | - | TopChange / CellDoubleClick / CellClick / ComboSelChange | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Shipment Requestor PIC` | - | - | - | FlexGrid 시트 |
| usrButton1 | UsrButton | - | 75x23, parent 없음 | - | 없음 | 사용 여부 **확인 필요** |

### 3-2. 팝업
| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | - | Dock=Fill, 657x184 | - | - | 용도 **확인 필요** |
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 레이아웃 |
| clbDivisionId | UsrCheckedList | `Division` | `Enabled=false` (InitControls:204) | - | SelectedIndexChanged → `clbDivision_SelectedIndexChanged` | 읽기전용 MultiSelect |
| clbFromSiteId | UsrCheckedList | `From Site` | `Enabled=true` (205), `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | - | - | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Material` | `sItemId` (201) | - | - | 멀티라인 입력 |
| txtModelId | UsrMultiLineEditor | `Model` | `sModelId` (202) | - | - | 멀티라인 입력 |
| btnButtonList | UsrButtonList | (Text 없음) | - | - | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 조회 버튼 |
| spdMain | FpSpread | - | Dock=Fill | - | CellDoubleClick → `spdMain_CellDoubleClick` | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Project` | - | - | - | FlexGrid 시트 |

## 4. 그리드 명세

### 4-1. 시트 `Shipment Requestor PIC` (메인, 연결 규칙 META+코드연결)
- 생성: CreateSpread:146 `AddSheet` → InitSpread:157 `InitSheet` → InitSpread:159 `SetSheetHeaderColumn(spdInfo, 1)` (메타 SCM_MST_SHEET_COLUMNS).
- 컬럼 순서·폭·정렬은 메타 값(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE 등)을 따릅니다. grid_effective에는 해당 값이 없어 아래는 grid_effective의 행 순서입니다(**메타 순번 확인 필요**).

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | CELL_TYPE | Cell Type | 메타 정의(**확인 필요**) | META | 14개 전부 기본 | **확인 필요** |
| 2 | CREATED_BY | Created By | 〃 | META | 〃 | **확인 필요** |
| 3 | CREATION_DATE | Creation Date | 〃 | META | 〃 | **확인 필요** |
| 4 | DIVISION_ID | Division | 신규 행 콤보(MyDivision, InsertRow:318) | META+코드 | 〃 | 신규 행: 콤보 선택 / 기존 행 **확인 필요** |
| 5 | ELECTRODE_TYPE | Electrode Type | 메타 | META | 〃 | **확인 필요** |
| 6 | ITEM_ID | Material* | 메타 | META | 〃 | **확인 필요** |
| 7 | LAST_UPDATE_DATE | Last Update Date | 메타 | META | 〃 | **확인 필요** |
| 8 | LAST_UPDATED_BY | Last Updated By | 메타 | META | 〃 | **확인 필요** |
| 9 | MODEL_ID | Model | 메타 | META | 〃 | **확인 필요** |
| 10 | NICK_NAME | Nick Name | 메타 | META | 〃 | **확인 필요** |
| 11 | PART_LEADER | Part Leader | 메타 | META | 〃 | **확인 필요** |
| 12 | PART_LEADER_NAME | Part Leader Name | 메타 | META | 〃 | **확인 필요** |
| 13 | SITE_DESCRIPTION | Plant Site* | 신규 행 콤보(PlantCell, InsertRow:320 / SpdMain_CellClick:640) | META+코드 | 〃 | 신규 행(Action=I): 콤보 선택 |
| 14 | TEAM_LEADER | Team Leader | 메타 | META | 〃 | **확인 필요** |
| 15 | TEAM_LEADER_NAME | Team Leader Name | 메타 | META | 〃 | **확인 필요** |
| 16 | TO_SITE | Plant Site Code | 메타 | META | 〃 | **확인 필요** |
| 17 | USER_ID | User ID* | 메타 | META | 〃 | **확인 필요** |
| 18 | USER_NAME | User Name | 메타 | META | 〃 | **확인 필요** |
| 19 | VALID_YN | Valid* | 메타(콤보 원천 `biz:CommonData.YesOrNo` 여부 **확인 필요**) | META | 〃 | **확인 필요** |

- InitSpread:162~164: `if(spdInfo.SheetName == "Shipment Requestor PIC")` 안에서 `CellType = cellTypeImage`를 3회 설정합니다. 대상 컬럼은 **확인 필요**입니다.
- 컬럼 헤더 스타일(Designer:499~502): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`, VerticalAlignment=General.
- division 차이: 14개 division 모두 19컬럼(선택 0)입니다.

### 4-2. 시트 `Project` (팝업, 코드 하드코딩 전용 — 메타 없음)
생성: CreateSpread:231 `AddSheet` → InitSpread:240 `InitSheet` → InitSpread:243~253 `Add*Column`.

| # | 컬럼 | 헤더 | 타입 | 폭 | 표시 | 가로 정렬 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---:|---|---|---|---|---|
| 1 | DIVISION_ID | division | Text | 60 | true | Center | HARDCODED(243) | 14개 동일 | **확인 필요** |
| 2 | DIVISION_NAME | division | Text | 80 | **false(숨김)** | 미지정 | HARDCODED(244) | 14개 동일 | - |
| 3 | FROM_SITE_CODE | From Site Code | Text | 70 | true | 미지정 | HARDCODED(245) | 〃 | **확인 필요** |
| 4 | FROM_SITE | From Site | Text | 150 | true | Left | HARDCODED(246) | 〃 | **확인 필요** |
| 5 | ITEM_ID | Material | Text | 100 | true | Center | HARDCODED(247) | 〃 | **확인 필요** |
| 6 | MODEL_ID | Model | Text | 100 | true | Center | HARDCODED(248) | 〃 | **확인 필요** |
| 7 | CELL_TYPE | Cell Type | Text | 80 | true | Center | HARDCODED(249) | 〃 | **확인 필요** |
| 8 | NICK_NAME | Nick Name | Text | 100 | true | Left | HARDCODED(250) | 〃 | **확인 필요** |
| 9 | ELECTRODE_TYPE | Electrode Type | Text | 80 | true | Center | HARDCODED(251) | 〃 | **확인 필요** |
| 10 | ITEM_UOM | UOM | Text | 60 | true | Center | HARDCODED(252) | 〃 | **확인 필요** |
| 11 | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | Num(FixedPoint, 소수 5자리) | 120 | true | 미지정 | HARDCODED(253) | 〃 | **확인 필요** |

- Merge는 모두 None이고, 세로 정렬이 지정된 컬럼은 Center입니다. 표시 컬럼은 10개입니다(DIVISION_NAME 숨김).
- 헤더 스타일(Designer:378~381): General / NoteIndicatorColor=Red / Parent=`ColumnHeaderDefaultEnhanced`.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 메인 this.Load | `Form_Load` (.ctor:102) | InitControls > SetChangedControl(140) | `biz:CommonData.CommonDataList` [code=PlantCell] | clbFromSite 목록 |
| A2 | 메인 필드 초기화 | `<field:dtMyDivision>`:45, `<field:dtYesOrNo>`:47 | 공통코드 준비 | `biz:CommonData.CommonDataList` [code=MyDivision], `biz:CommonData.YesOrNo` | dtMyDivision → 신규 행 DIVISION_ID 콤보, dtYesOrNo 사용처 **확인 필요** |
| A3 | cboDivision.SelectedIndexChanged | `CboDivision_SelectedIndexChanged` (InitEvent:175) | SetChangedControl(140), GetCheckedListValue(139) | `biz:CommonData.CommonDataList` [code=PlantCell] | clbFromSite 목록 재설정 |
| A4 | 조회(FindButton) | FindButton > FindData_Main (274) | GetCheckedListValue(258·259)로 조건 구성 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 시트 `Shipment Requestor PIC` 바인딩 |
| A5 | 편집(EditButton) | EditButton > GetSSPUserCheck (511) | 사용자 정보·권한 확인 | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부(**확인 필요**) |
| A6 | 행 추가(InsertRow, 진입 버튼 **확인 필요**) | InsertRow (318·320) | 시트 잠금 해제 + 시트명 일치 시 셀 콤보 설정 | `biz:CommonData.CommonDataList` [code=MyDivision], [code=PlantCell] | 신규 행 DIVISION_ID·SITE_DESCRIPTION 콤보 |
| A7 | spdMain.CellClick | `SpdMain_CellClick` (InitEvent:172) | 잠금 해제 + Action=`"I"` + 컬럼=`SITE_DESCRIPTION`이면 콤보 재설정(640) | `biz:CommonData.CommonDataList` [code=PlantCell] | SITE_DESCRIPTION 콤보 갱신 |
| A8 | spdMain.TopChange | `SpdMain_TopChange` (InitEvent:170) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A9 | spdMain.CellDoubleClick | `SpdMain_CellDoubleClick` (InitEvent:171) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A10 | spdMain.ComboSelChange | `SpdMain_ComboSelChange` (InitEvent:173) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A11 | 저장(SaveButton) | SaveButton > SaveData (410) > GetUserIDChk (458) > FindData_Main (274) | 사용자 ID 확인, 저장, 재조회(순서 **확인 필요**) | `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | SSP_MST_MODEL_USER_EE MERGE, 그리드 재조회 |
| A12 | btnItemId.Click | `btnItemId_Click` (InitEvent:177) | 팝업 호출 후 결과 반영 | (팝업 경유) `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | `txtItemId.Text = popItem.ItemId` (718) |
| A13 | btnModelId.Click | `btnModelId_Click` (InitEvent:178) | 팝업 호출 후 결과 반영 | (팝업 경유) `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | `txtModelId.Text = popItem.ModelId` (736) |
| A14 | 팝업 this.Load | `Form_Load` (.ctor:172) | InitControls(201~206) > FindData(296) | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly], `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 조건 초기값 설정, 시트 `Project` 바인딩 |
| A15 | 팝업 clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` (InitializeComponent:188) | `c["DIVISION_ID"]`(358) 기준 From Site 재조회 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | clbFromSiteId 목록 |
| A16 | 팝업 btnButtonList | `btnButtonList_UsrButtonList_Click_Detected` (InitializeComponent:281) | FindData(296) | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` 재조회 |
| A17 | 팝업 조회(FindButton) | FindButton > FindData (296) | FindData | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` 재조회 |
| A18 | 팝업 spdMain.CellDoubleClick | `spdMain_CellDoubleClick` (InitializeComponent:362) | 본문 **확인 필요**(선택값 반환으로 보이나 미확인) | 없음 | **확인 필요** |

엔드포인트 전체 목록(업무분석서 §5와 같음): `biz:CommonData.CommonDataList`, `biz:CommonData.YesOrNo`, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0002_GET_USER_INFO_LIST`.

## 6. 검증·메시지

| # | 검증 | 근거 | 메시지 |
|---|---|---|---|
| V1 | Division 필수 표시(`Div*`) | props.csv:392 | 메시지 원문 **확인 필요** |
| V2 | 저장 시 사용자 ID 존재 확인(`SSP.SSP0025_GET_USER_ID_CHECK`, TB_FX_USER) | flow.csv GetUserIDChk:458 | 메시지 원문 **확인 필요** |
| V3 | 시트 잠금(`IsLock`)이면 행 추가 콤보·셀 콤보 설정 생략 | grid_code.csv:318·320·640 | 메시지 없음(Fact Pack 기준) |
| V4 | 그리드 라벨 `*` 컬럼(ITEM_ID, SITE_DESCRIPTION, USER_ID, VALID_YN)의 필수 검증 | grid_effective.csv | 검증 수행 여부·메시지 **확인 필요** |
| V5 | Fact Pack §7 "확인 필요(메시지 하드코딩 등)" | 0건 | - |

## 7. 권한(C/R/U/D) 사실

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SSP0025 행 12건. C/R/U/D 플래그 값은 **확인 필요** |
| TB_FX_ProgramInfo / TB_FX_MenuItemInfo | 각 1건 |
| TB_FX_SearchCondition | 4건(저장된 조회조건) |
| TB_FX_Favorite | 5건 |
| 편집 진입 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_USERGROUPAUTHEXTENTION 등 조회) |
| 신규 행 Division | MyDivision(NowGroupID·UserId) → 사용자 권한 Division만 표시 |
| 시트 잠금 | `siMain.IsLock(SheetName)` |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | As-Is | To-Be 관점 |
|---|---|---|
| M1 | FarPoint Spread 시트 `Shipment Requestor PIC`(메타 SCM_MST_SHEET_COLUMNS 19행) | Wijmo FlexGrid. 컬럼은 같은 메타(PROGRAM_ID=SSP0025, SHEET_NAME=`Shipment Requestor PIC`)에서 생성 |
| M2 | 팝업 시트 `Project`(하드코딩 11컬럼, 메타 없음) | 메타 신규 등록 또는 코드 정의 중 결정 필요(미확정) |
| M3 | `SetCellTypeCombo`로 신규 행에서만 DIVISION_ID / SITE_DESCRIPTION 콤보 | FlexGrid 행 상태(신규) 기반 셀 에디터(DataMap) 전환. PlantCell은 행의 Division에 종속 |
| M4 | `cellTypeImage` 3컬럼 | 대상 컬럼 확인 후 아이콘 셀 템플릿으로 표현(미확정) |
| M5 | UsrCheckedList(clbFromSite, clbFromSiteId, clbDivisionId) | MultiSelect. 값은 CODE(GetCheckedListValue) |
| M6 | UsrMultiLineEditor(txtItemId, txtModelId) | 다중값 입력. SP의 STRING_SPLIT / SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL은 Oracle 대응 함수·객체로 변환 필요(존재 여부 미확인) |
| M7 | MSSQL SP 5종 | Oracle 19c 변환 대상: `SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`(MERGE, PR_SCM_SYS_LOG_BATCH), `SSP0025_GET_USER_ID_CHECK`, `SSP0002_GET_USER_INFO_LIST`(SSP0002와 공용) |
| M8 | Form Text `"SSP0014_ShipmentModelPIC"` | To-Be 화면 제목 기준 확정 필요 |
| M9 | usrButton1, usrLayoutControl1(팝업), imageList1 | 사용 여부 확인 후 To-Be 반영 여부 결정 |

## 9. 미확정

1. 메인 Form Text와 메뉴 위치.
2. SaveData 내부 호출 순서(GetUserIDChk / SAVE / FindData_Main)와 오류 처리.
3. EditButton(GetSSPUserCheck)의 편집 허용 조건.
4. InsertRow 진입 버튼.
5. `cellTypeImage` 적용 컬럼 3개.
6. `dtYesOrNo` 사용처(VALID_YN 콤보 여부), cboDivision 콤보 원천.
7. `SpdMain_TopChange` / `SpdMain_CellDoubleClick` / `SpdMain_ComboSelChange` / 팝업 `spdMain_CellDoubleClick`의 본문 동작.
8. `popItem`의 타입과 생성 위치, 메인→팝업 Division 전달 방식.
9. 메인 시트 컬럼의 메타 순번·폭·편집 가능 여부.
10. usrButton1 / usrLayoutControl1 / imageList1 사용 여부.

=== FILE: unit_test.md ===
# SSP0025 단위테스트 — Shipment Requestor PIC

> 근거: Fact Pack(SSP0025). 절차의 컨트롤명은 화면설계서 §3, 근거의 엔드포인트명은 업무분석서 §5 / 화면설계서 §5와 같습니다.
> 주석 처리된 호출은 0건이라 제외 대상이 없습니다. Fact Pack에서 동작이 확인되지 않은 항목은 기대결과에 **확인 필요**로 적었습니다. As-Is 원문으로 기대값을 확정한 뒤 실행합니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0025-001 | 초기화 | 로그인(SSP 권한 사용자) | 메뉴에서 SSP0025 화면을 연다 | - | `Form_Load` 실행. clbFromSite에 PlantCell 공통코드 목록이 채워진다. usrConditionPanel1(상단)과 spdMain(하단)이 표시된다 | `Form_Load`(.ctor:102) > InitControls > SetChangedControl:140, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-002 | 초기화 | TC-001 | 화면 열림 시 필드 초기화 호출을 로그/트레이스로 확인한다 | - | `biz:CommonData.CommonDataList` [code=MyDivision], `biz:CommonData.YesOrNo`가 각 1회 호출된다. `dtYesOrNo` 사용처는 **확인 필요** | `<field:dtMyDivision>`:45, `<field:dtYesOrNo>`:47, `biz:CommonData.YesOrNo` |
| TC-SSP0025-003 | 그리드 | TC-001 | spdMain / spdMain_Sheet1의 컬럼 헤더를 확인한다 | - | 시트 `Shipment Requestor PIC`에 메타 19컬럼(Cell Type, Created By, Creation Date, Division, Electrode Type, Material*, Last Update Date, Last Updated By, Model, Nick Name, Part Leader, Part Leader Name, Plant Site*, Team Leader, Team Leader Name, Plant Site Code, User ID*, User Name, Valid*)이 표시된다. 순서·폭은 SCM_MST_SHEET_COLUMNS 값과 일치 | 시트 `Shipment Requestor PIC`, InitSpread:159 SetSheetHeaderColumn, grid_effective.csv |
| TC-SSP0025-004 | 그리드 | TC-003 | 이미지 셀 유형이 적용된 컬럼을 확인한다 | - | 3개 컬럼에 `cellTypeImage` 적용. 대상 컬럼은 **확인 필요** | 시트 `Shipment Requestor PIC`, InitSpread:162~164 |
| TC-SSP0025-005 | 이벤트 | TC-001 | cboDivision에서 다른 Division을 고른다 | Division 값 A → B | `CboDivision_SelectedIndexChanged` 실행. clbFromSite 목록이 Division B 기준 PlantCell 목록으로 바뀐다 | `CboDivision_SelectedIndexChanged`(InitEvent:175) > SetChangedControl:140, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-006 | 조회 | 해당 조건 데이터가 SSP_MST_MODEL_USER_EE에 있음 | cboDivision, clbFromSite 선택, txtItemId·txtModelId·txtNickName 입력 후 조회(FindButton) | Division, Plant Site(복수), Material, Model, Nick Name | 시트 `Shipment Requestor PIC`에 조건에 맞는 행이 표시된다 | FindButton > FindData_Main:274, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, SP `SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-007 | 조회 | TC-001 | clbFromSite에서 Plant Site를 2개 이상 체크하고 조회한다 | Plant Site 2개 이상 | 체크한 CODE 값이 모두 조건으로 넘어가고 해당 Site 행만 조회된다(GetCheckedListValue CODE) | FindData_Main:258·259, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-008 | 조회(빈 결과) | 조건에 맞는 데이터 없음 | 존재하지 않는 Material을 txtItemId에 넣고 조회한다 | 미존재 Material | 그리드 0행. 안내 메시지 표시 여부는 **확인 필요** | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-009 | 조회(검증) | TC-001 | cboDivision을 비우고 조회한다(가능한 경우) | Division 빈값 | `Div*` 필수 표시 항목. 차단 여부·메시지는 **확인 필요** | props.csv:392 `Div*`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-010 | 권한 | 조회 완료 | 편집(EditButton)을 누른다 | - | 사용자 정보·권한 조회가 수행되고 결과에 따라 편집 가능 여부가 정해진다. 허용 조건은 **확인 필요** | EditButton > GetSSPUserCheck:511, `SSP.SSP0002_GET_USER_INFO_LIST`, SP `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0025-011 | 그리드 | 편집 가능 상태(시트 잠금 해제) | 행을 추가한다(InsertRow, 진입 버튼 **확인 필요**) | - | 신규 행 DIVISION_ID 셀이 MyDivision 콤보로, SITE_DESCRIPTION 셀이 PlantCell 콤보로 바뀐다 | InsertRow:318·320, 시트 `Shipment Requestor PIC`, `biz:CommonData.CommonDataList` [code=MyDivision]/[code=PlantCell] |
| TC-SSP0025-012 | 권한 | 시트 잠금 상태(`IsLock`=true) | 행 추가를 시도한다 | - | DIVISION_ID / SITE_DESCRIPTION 콤보가 설정되지 않는다 | InsertRow:318·320 조건 `siMain.IsLock(siMain.SheetName) == false` |
| TC-SSP0025-013 | 이벤트 | TC-011로 신규 행 생성 | 신규 행의 SITE_DESCRIPTION 셀을 클릭한다 | - | `SpdMain_CellClick` 실행. PlantCell 콤보가 다시 설정된다 | `SpdMain_CellClick`(InitEvent:172) :639·640, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-014 | 이벤트 | 조회된 기존 행(Action≠"I") | 기존 행의 SITE_DESCRIPTION 셀을 클릭한다 | - | 콤보 재설정이 일어나지 않는다 | `SpdMain_CellClick`:640 조건 Action=`"I"` |
| TC-SSP0025-015 | 이벤트 | 조회 결과가 여러 화면 분량 | spdMain을 세로 스크롤한다 | - | `SpdMain_TopChange` 실행. 동작은 **확인 필요** | `SpdMain_TopChange`(InitEvent:170) |
| TC-SSP0025-016 | 이벤트 | 조회 완료 | spdMain 셀을 더블클릭한다 | - | `SpdMain_CellDoubleClick` 실행. 동작은 **확인 필요** | `SpdMain_CellDoubleClick`(InitEvent:171) |
| TC-SSP0025-017 | 이벤트 | TC-011 신규 행 | 콤보 셀(DIVISION_ID 또는 SITE_DESCRIPTION)에서 값을 고른다 | 콤보 값 | `SpdMain_ComboSelChange` 실행. 연쇄 동작은 **확인 필요** | `SpdMain_ComboSelChange`(InitEvent:173) |
| TC-SSP0025-018 | 저장 | TC-011 신규 행 입력 완료(USER_ID는 TB_FX_USER에 있는 ID) | 저장(SaveButton)을 누른다 | Division, Plant Site, Material, User ID, Valid | 사용자 ID 확인 → SSP_MST_MODEL_USER_EE MERGE → SCM_SYS_LOG_BATCH 로그 → 재조회로 그리드에 저장 행이 표시된다(호출 순서는 원문으로 확정) | SaveButton > SaveData:410, GetUserIDChk:458, FindData_Main:274, `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-019 | 저장 | 조회된 기존 행 | 기존 행의 값을 수정하고 저장한다 | 수정값 | 같은 키 행이 MERGE로 갱신되고 재조회 결과에 반영된다 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, SP `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`(MERGE SSP_MST_MODEL_USER_EE) |
| TC-SSP0025-020 | 저장(오류) | 신규 행 | TB_FX_USER에 없는 USER_ID로 저장한다 | 미존재 User ID | 사용자 ID 확인 SP가 호출된다. 저장 중단 여부와 메시지는 **확인 필요** | GetUserIDChk:458, `SSP.SSP0025_GET_USER_ID_CHECK`, SP `SSP0025_GET_USER_ID_CHECK` |
| TC-SSP0025-021 | 저장(오류) | 신규 행 | `*` 라벨 컬럼(Material*, Plant Site*, User ID*, Valid*) 중 하나를 비우고 저장한다 | 필수 표시 컬럼 빈값 | 필수 검증 수행 여부·메시지는 **확인 필요**. SP 오류 응답 시 표시 방식도 원문으로 확정 | 시트 `Shipment Requestor PIC` 메타 라벨, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-022 | 저장 | TC-018 완료 | DB에서 로그 테이블을 조회한다 | - | SCM_SYS_LOG_BATCH에 저장 건 로그가 남아 있다 | SP `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` (EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH) |
| TC-SSP0025-023 | 이벤트 | TC-001 | txtItemId에 값을 넣고 btnItemId를 누른 뒤 팝업에서 행을 골라 닫는다 | Material 일부 값 | `btnItemId_Click` 실행. 팝업이 열리고 선택 결과가 `txtItemId.Text = popItem.ItemId`로 반영된다 | `btnItemId_Click`(InitEvent:177) :718 |
| TC-SSP0025-024 | 이벤트 | TC-001 | txtModelId에 값을 넣고 btnModelId를 누른 뒤 팝업에서 행을 골라 닫는다 | Model 일부 값 | `btnModelId_Click` 실행. 선택 결과가 `txtModelId.Text = popItem.ModelId`로 반영된다 | `btnModelId_Click`(InitEvent:178) :736 |
| TC-SSP0025-025 | 초기화(팝업) | TC-023에서 팝업 열림 | 팝업의 초기 상태를 확인한다 | 메인 txtItemId/txtModelId 값 | 팝업 `Form_Load` 실행. 팝업 txtItemId=sItemId, txtModelId=sModelId, clbDivisionId 비활성, clbFromSiteId 활성. clbFromSiteId에 FromSiteByAssembly 목록. 시트 `Project` 자동 조회 | 팝업 `Form_Load`(.ctor:172) > InitControls:201~206 > FindData:296, `biz:CommonData.CommonDataList` [code=FromSiteByAssembly], `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-026 | 그리드(팝업) | TC-025 | 팝업 spdMain / spdMain_Sheet1의 컬럼을 확인한다 | - | 시트 `Project` 표시 컬럼 10개(division, From Site Code, From Site, Material, Model, Cell Type, Nick Name, Electrode Type, UOM, Pancake (m/cell)). DIVISION_NAME은 숨김. Pancake (m/cell)은 소수 5자리 | 시트 `Project`, InitSpread:243~253 |
| TC-SSP0025-027 | 이벤트(팝업) | TC-025 | clbDivisionId 선택 변경을 일으킨다(초기 설정 포함, 사용자 조작은 Enabled=false라 불가) | DIVISION_ID | `clbDivision_SelectedIndexChanged` 실행. `c["DIVISION_ID"]` 기준으로 clbFromSiteId 목록을 다시 채운다 | `clbDivision_SelectedIndexChanged`(InitializeComponent:188) :357·358, `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| TC-SSP0025-028 | 조회(팝업) | TC-025 | clbFromSiteId, txtItemId, txtModelId를 바꾸고 btnButtonList를 누른다 | From Site, Material, Model | `btnButtonList_UsrButtonList_Click_Detected` 실행. 시트 `Project`를 다시 조회한다 | `btnButtonList_UsrButtonList_Click_Detected`(InitializeComponent:281) > FindData:296, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`, SP `SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-029 | 조회(팝업) | TC-025 | 팝업 조회(FindButton)를 실행한다 | - | 시트 `Project`를 다시 조회한다 | 팝업 FindButton > FindData:296, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-030 | 조회(팝업 빈 결과) | TC-025 | 존재하지 않는 Material로 btnButtonList 조회 | 미존재 Material | 시트 `Project` 0행. 메시지 여부는 **확인 필요** | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-031 | 이벤트(팝업) | TC-028 결과 있음 | 팝업 spdMain 행을 더블클릭한다 | - | `spdMain_CellDoubleClick` 실행. 선택값 반환·팝업 닫힘 여부는 **확인 필요** | `spdMain_CellDoubleClick`(InitializeComponent:362), 시트 `Project` |
| TC-SSP0025-032 | division | 사용자 권한 Division이 40, 81, 82, EE인 계정(각각) | Division별로 화면을 열어 조회한다 | Division 40 / 81 / 82 / EE | 모든 Division에서 시트 `Shipment Requestor PIC` 19컬럼, 팝업 시트 `Project` 11컬럼(표시 10)이 같게 나온다(division별 변형 없음, 14개 division 동일) | Fact Pack §10·§12, 시트 `Shipment Requestor PIC`, 시트 `Project` |
| TC-SSP0025-033 | division/권한 | 권한 Division이 다른 두 계정 | 각 계정으로 행 추가 후 DIVISION_ID 콤보 목록을 비교한다 | NowGroupID 서로 다름 | 각 계정의 권한(TB_FX_USERGROUPAUTHEXTENTION) Division만 콤보에 나온다 | InsertRow:318, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-SSP0025-034 | 권한 | TB_FX_GroupMenuAuth 12건 중 서로 다른 그룹 계정 | 그룹별로 조회·편집·저장 버튼의 사용 가능 여부를 확인한다 | 그룹별 계정 | 그룹별 C/R/U/D 값과 일치. 기대값(12행 내용)은 **확인 필요** | Fact Pack §8 TB_FX_GroupMenuAuth, `SSP.SSP0002_GET_USER_INFO_LIST` |

## 2. 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load`(메인/팝업) | 001, 025 |
| | `CboDivision_SelectedIndexChanged` | 005 |
| | `SpdMain_CellClick` | 013, 014 |
| | `SpdMain_TopChange` | 015 |
| | `SpdMain_CellDoubleClick` | 016 |
| | `SpdMain_ComboSelChange` | 017 |
| | `btnItemId_Click` | 023 |
| | `btnModelId_Click` | 024 |
| | `clbDivision_SelectedIndexChanged` | 027 |
| | `btnButtonList_UsrButtonList_Click_Detected` | 028 |
| | `spdMain_CellDoubleClick` | 031 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 001, 002, 005, 011, 013, 025, 027, 033 |
| | `biz:CommonData.YesOrNo` | 002 |
| | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 006, 007, 008, 009, 018 |
| | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | 018, 019, 021, 022 |
| | `SSP.SSP0025_GET_USER_ID_CHECK` | 018, 020 |
| | `SSP.SSP0002_GET_USER_INFO_LIST` | 010, 034 |
| | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 025, 028, 029, 030 |
| 시트 | `Shipment Requestor PIC` | 003, 004, 011, 021, 032 |
| | `Project` | 026, 031, 032 |
| 빈 결과 / 오류 | - | 008, 009, 020, 021, 030 |
| division | 변형 없음 확인 + 권한 Division | 032, 033 |
| 주석 처리 호출 | 0건(테스트 제외 대상 없음) | - |
