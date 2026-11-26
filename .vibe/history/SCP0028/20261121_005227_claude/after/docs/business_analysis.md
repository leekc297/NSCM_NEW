# SCP0028 Shipment Lot Size — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0028)과 1차 분석서(analysis.md, web_components.md, tobe_design.md). Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls.csv)은 0건입니다. 이 문서의 기능은 모두 활성 호출만 근거로 합니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0028 / `SCP0028_Shipment_Lot_Size` | Designer.cs:724 `this.Text` |
| 소속 | SCP 도메인, `Master` 폴더에 있는 화면 | 프로젝트 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\…` |
| 관리 대상 | 출하 Lot Size 마스터 `SCP_MST_SHIPMENT_LOT_SIZE`. 저장 SP가 이 테이블을 MERGE하고 DELETE함 | endpoints.csv 511·659 objects |
| 관리 항목(그리드 메타 라벨) | Division, Operation Group, From Site, To Site, Trans Mode, Model, Nick Name, Lot Size*, Increment*, Container Split*, Valid*, Created By, Creation Date, Last Updated By, Last Update Date | grid_effective.csv |
| 업무 범위 | ① 조회 ② Input(입력 대상 후보 조회) ③ 저장 ④ 삭제 ⑤ Division에 따른 Site 목록 재구성 ⑥ Model 지정 | flow.csv |
| 업무 목적 서술 | Fact Pack에는 업무 목적 문장이 없습니다. "출하 Lot Size 기준정보 관리"는 테이블과 컬럼 이름에서 읽은 범위입니다. 실제 업무 정의는 **확인 필요**입니다 | – |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` > `InitControls`가 `biz:CommonData.YesOrNo`(135)와 `biz:CommonData.CommonDataList` [code=LookupCommon](137)를 호출합니다. 이어서 `SetChangedControl`이 `biz:CommonData.CommonDataList` [code=FromSiteByDivision](166)와 [code=ToSiteByDivision](169)를 호출합니다 | Valid 콤보는 YesOrNo 목록으로 채워집니다(DataBind 135). LookupCommon, FromSite, ToSite 결과가 바인딩되는 컨트롤은 **확인 필요**입니다 |
| S2 | Division 변경 | `ClbDivision_SelectedIndexChanged` > `SetChangedControl`이 FromSiteByDivision(166)과 ToSiteByDivision(169)를 다시 호출합니다. 이때 `UserInfoContext.Current.NowGroupID`를 읽습니다 | Division과 사용자 그룹 기준으로 Site 목록이 다시 구성됩니다(바인딩 대상은 **확인 필요**) |
| S3 | Model 버튼 클릭 | `btnItemId_Click` 실행 | `txtItemId.Text = sItemId`가 설정됩니다(256). 팝업 호출 여부는 **확인 필요**입니다 |
| S4 | 조회(프레임워크 FindButton) | `FindButton` > `FindData`(349)가 `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE`를 호출합니다. 조회조건은 `GetCheckedListValue`를 5회 호출해 구성합니다(332~336) | 시트 `Shipment Lot Size`에 결과가 표시됩니다 |
| S5 | Input 버튼 클릭 | `btnInput_Click`(`GetCheckedListValue` 265) > `FindInput`(417)이 `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT`을 호출합니다 | 입력 후보 데이터가 조회됩니다. 그리드에 반영하는 방식(행 추가 또는 대체)은 **확인 필요**입니다 |
| S6 | 저장(프레임워크 SaveButton) | `SaveButton` > `SaveData`(659)가 `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출한 뒤 `FindData`(349)로 다시 조회합니다 | `SCP_MST_SHIPMENT_LOT_SIZE`가 MERGE되고 이력과 로그가 기록됩니다. 화면은 다시 조회됩니다 |
| S7 | Delete 버튼 클릭 | `btnDelete_Click`(`GetCheckedListValue` 293) > `FindDelete`(511)가 `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출한 뒤 `FindData`(349)로 다시 조회합니다 | 저장 SP가 DELETE 경로로 처리되는 것으로 보입니다. 넘기는 삭제 구분값은 **확인 필요**입니다 |
| S8 | 그리드 셀 편집 | `dsdm.Changed` → `spdMain_Change` | 본문 동작은 **확인 필요**입니다. 엔드포인트 호출은 없습니다 |
| S9 | 그리드 스크롤 | `spdMain.TopChange` → `SpdMain_TopChange` | 본문 동작은 **확인 필요**입니다. 엔드포인트 호출은 없습니다 |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
     ├─ InitControls:135  biz:CommonData.YesOrNo                      → cboValid DataBind
     ├─ InitControls:137  biz:CommonData.CommonDataList [LookupCommon] → 바인딩 대상 확인 필요
     └─ InitControls > SetChangedControl
           ├─ :166 biz:CommonData.CommonDataList [FromSiteByDivision] (NowGroupID)
           └─ :169 biz:CommonData.CommonDataList [ToSiteByDivision]   (NowGroupID)
[2] 조회조건 설정
     ├─ Division 변경 → ClbDivision_SelectedIndexChanged → SetChangedControl(:166, :169) 재호출
     └─ Model 버튼   → btnItemId_Click → txtItemId.Text 설정(:256)
[3] 조회   FindButton > FindData:349 → SCP.SCP0028_GET_SHIPMENT_LOT_SIZE → 시트 "Shipment Lot Size"
[4] 입력   btnInput_Click > FindInput:417 → SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT → 그리드 반영(방식 확인 필요)
[5] 편집   그리드 편집 (spdMain_Change — 본문 확인 필요)
[6] 저장   SaveButton > SaveData:659 → SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE → FindData:349 재조회
[7] 삭제   btnDelete_Click > FindDelete:511 → SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE → FindData:349 재조회
```

## 4. 업무 규칙

### 4-1. SP 처리 규칙 (참조 객체로 확인되는 사실)

| SP | 확인된 처리 | 분기 조건 |
|---|---|---|
| `SCP0028_GET_SHIPMENT_LOT_SIZE` | `SCP_MST_SHIPMENT_LOT_SIZE`, `SCM_MST_FINAL_ITEM_V`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SCM_MST_SITE`를 SELECT합니다. `FN_GET_SCM_SITE_DESCRIPTION`과 `STRING_SPLIT`을 참조합니다 | Fact Pack에 SP 본문 분기가 없어 **확인 필요**입니다 |
| `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | 임시테이블 `#TBLDYNAMIC_SCP0028IN_DIV`, `_OPER`, `_FROM`, `_TO`, `_ITEM`, `_INPUT`에 INSERT하고 SELECT합니다. `UF_FX_STRING_SPLIT`, `FN_GET_LOOKUP_CODE_DESC`, `FN_GET_SCM_SITE_DESCRIPTION`을 참조합니다. `SCM_MST_FINAL_ITEM_V`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SCP_MST_BOD`, `SCM_MST_SITE`를 SELECT합니다. `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 실행하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다 | 임시테이블 이름(DIV, OPER, FROM, TO, ITEM)으로 보아 조건 5종을 분해하는 것으로 보입니다. 정확한 조건과 `SCP_MST_BOD` 결합 규칙은 **확인 필요**입니다 |
| `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `SCM_ARR_SPL_CNT`와 `SCM_ARR_SPL_VAL`을 참조합니다(배열 분해). `SCP_MST_SHIPMENT_LOT_SIZE`를 MERGE하고 DELETE합니다. `PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST`를 실행하고 `SCP_MST_SHIPMENT_LOT_SIZE_H`에 INSERT합니다. `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 실행하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다 | MERGE와 DELETE가 갈리는 조건, 그리고 `FindDelete`(511)와 `SaveData`(659)가 넘기는 구분값은 **확인 필요**입니다 |

### 4-2. 필수값·검증

| 대상 | 사실 | 판단 |
|---|---|---|
| 조회조건 Division | LayoutControlItem `Division`.Text = `Division*` (Designer:472) | 화면에 필수 표시(`*`)가 있습니다. 검증 코드가 실제로 있는지는 **확인 필요**입니다 |
| 그리드 `Lot Size*`, `Increment*`, `Container Split*`, `Valid*` | 메타 COLUMN_LABEL_NAME 원문에 `*`가 있습니다 | 필수 입력을 검증하는 로직은 Fact Pack에 없어 **확인 필요**입니다 |
| 저장 전 검증 / 메시지 | Fact Pack에 없음 | **확인 필요** |

### 4-3. 날짜·버킷 규칙
- Fact Pack에 날짜나 버킷 관련 조건, 파라미터, 함수가 없습니다. 이 화면에 적용되는 날짜·버킷 규칙은 **없음(사실 미발견)**입니다.
- 그리드의 `Creation Date`와 `Last Update Date`는 감사 컬럼 라벨입니다.

### 4-4. 조회조건 구성 규칙
- `FindData`는 332, 333, 334, 335, 336줄에서 `CString.GetCheckedListValue`(CODE)를 5회 호출합니다. 각 호출이 어느 컨트롤의 값을 꺼내는지는 **확인 필요**입니다.
- `btnInput_Click`(265), `btnDelete_Click`(293), `SetChangedControl`(160)도 `GetCheckedListValue`를 호출합니다.

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기 | 쓰기 |
|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | InitControls:135 (`<field:dtYesOrNo>`:46 미연결) | – (DB 보강 없음) | – | – |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | InitControls:137 (`<field:dtTransMode>`:44 미연결) | 코드분기 UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | – |
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | SetChangedControl:166 | 코드분기 UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | – |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | SetChangedControl:169 | 코드분기 UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | FindData:349 | `SCP0028_GET_SHIPMENT_LOT_SIZE` | SCP_MST_SHIPMENT_LOT_SIZE, SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE (REF FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | FindInput:417 | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD, SCM_MST_SITE, #TBLDYNAMIC_SCP0028IN_* (REF UF_FX_STRING_SPLIT, FN_GET_LOOKUP_CODE_DESC, FN_GET_SCM_SITE_DESCRIPTION) | #TBLDYNAMIC_SCP0028IN_DIV/OPER/FROM/TO/ITEM/INPUT, SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN) |
| `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | SaveData:659, FindDelete:511 | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | (REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL) | MERGE·DELETE SCP_MST_SHIPMENT_LOT_SIZE, INSERT SCP_MST_SHIPMENT_LOT_SIZE_H (EXEC PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST), INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN) |

- `UP_FX_GetCommonDataList`와 `UP_FX_GetCommonDataList_SCP` 중 어느 분기가 실행되는지는 **확인 필요**입니다.

## 6. Division·권한별 변형

| 구분 | 사실 |
|---|---|
| 그리드 Division 변형 | 시트 `Shipment Lot Size`는 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 표시 15개(15/0)로 같습니다. 코드의 division 분기는 0건입니다 |
| 조회조건 Division 변형 | Division을 바꾸면 FromSiteByDivision과 ToSiteByDivision이 다시 호출되어 Site 목록이 Division에 종속됩니다 |
| 사용자 그룹 제한 | Site 목록은 `UserInfoContext.Current.NowGroupID`(meta_reads 166/169)와 `TB_FX_USERGROUPAUTHEXTENTION`(코드분기 SP SELECT)으로 제한됩니다 |
| 메뉴 권한 | `TB_FX_GroupMenuAuth` 13행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행이 있습니다. 그룹별 C/R/U/D 플래그 값은 **확인 필요**입니다 |

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템(I/F) 호출 사실이 없습니다.
- 내부 로그로 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`에서 `SCM_SYS_LOG_BATCH`에 기록합니다(Input SP, 저장 SP). 이는 외부 인터페이스가 아닌 내부 실행 로그입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| 1 | `FindDelete`(511)가 `SCP0028_SAVE_SHIPMENT_LOT_SIZE`에 넘기는 삭제 구분값과, SP 안의 MERGE/DELETE 분기 조건 | endpoints.csv 511 |
| 2 | Input 결과를 그리드에 반영하는 방식 | flow.csv 417 |
| 3 | `FindData` 332~336의 `GetCheckedListValue` 5회가 각각 꺼내는 컨트롤 | Fact Pack §4-2 |
| 4 | LookupCommon(137), FromSite(166), ToSite(169) 결과의 바인딩 대상 컨트롤, 그리고 `cboDivision`과 `cboOperationGroup`의 데이터 소스 | endpoints.csv |
| 5 | `<field:dtTransMode>`(44)와 `<field:dtYesOrNo>`(46)가 진입점 미연결로 분류된 이유 | flow.csv unreached |
| 6 | `SaveButton:207`을 `PersonalSettingPopup.SaveData`로 해석한 정적 분석이 화면 `SaveData`(659)와 섞였을 가능성 | Fact Pack §4-2 |
| 7 | 필수(`*`) 검증 로직, 저장 전 검증, 메시지 문구 | 사실 없음 |
| 8 | `spdMain_Change`, `SpdMain_TopChange`, `EditButton`(231)의 동작 | events.csv, grid_code.csv |
| 9 | 업무 목적 정의, 메뉴 위치 | 사실 없음 |
| 10 | `UP_FX_GetCommonDataList`와 `_SCP` 중 실행되는 분기 | Fact Pack §3 DB 보강 |
