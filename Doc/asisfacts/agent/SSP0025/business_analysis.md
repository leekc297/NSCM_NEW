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
