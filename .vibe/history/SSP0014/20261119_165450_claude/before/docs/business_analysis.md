# SSP0014 Shipment Model PIC — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0014)과 1차 분석서(analysis.md, web_components.md, tobe_design.md).
> Fact Pack에 없는 내용은 **확인 필요**로 적었습니다. 업무 규칙을 추측해서 만들지 않았습니다.
> 주석 처리된 호출(commented_calls)은 0건이므로, 이 문서의 기능은 모두 현재 동작하는 호출입니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0014 / `SSP0014_ShipmentModelPIC` | Designer.cs:546 `this.Text` |
| 도메인 / 프로젝트 | SSP / `GSCM.SSP.Plan.UIL` | Fact Pack §1 |
| 업무 대상 데이터 | Model(ITEM_ID) 단위 담당자 정보. 그리드 컬럼에 USER_ID, PART_LEADER, TEAM_LEADER, MAIL_USER1~5, VALID_YN이 있음 | grid_effective.csv |
| 저장 대상 테이블 | `SSP_MST_MODEL_USER`(MERGE) | endpoints.csv `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| 범위 | 조회, 저장(사용자 ID 검사 포함), 저장 후 재조회 | flow.csv |
| 범위 밖 / 확인 필요 | 행 삭제(D) 기능. SAVE SP는 MERGE만 참조하고 DELETE를 참조하지 않으므로 삭제 지원 여부는 **확인 필요** | endpoints.csv |
| 업무 목적 서술 | 화면 명칭(Shipment Model PIC)과 컬럼 구성만 있고, 업무 목적 원문은 Fact Pack에 없음 → **확인 필요** | – |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` 실행(.ctor:110에서 배선). InitControls에서 `DataService.FP_Log2` 호출(170·173), SetChangeControl에서 `DataService.GetSSPInnerTable` 호출(144·149) | 조회조건 콤보 초기화(어느 콤보인지는 확인 필요). 그리드 시트 `Shipment Model PIC` 생성(CreateSpread:208) | events.csv, Fact Pack §4-2, grid_code.csv |
| S2 | Division 변경 | `CboDivision_SelectedIndexChanged` 실행 | 본문이 Fact Pack에 없음 → **확인 필요** | events.csv |
| S3 | Model 버튼(btnItemId) 클릭 | `btnItemId_Click` 실행 | `txtItemId.Text = sItemId`(857). sItemId를 어디서 얻는지는 **확인 필요** | props.csv:857 |
| S4 | 조회(FindButton) | FindButton > FindData_Main. 조회조건 값을 `CString.GetCheckedListValue`(310~313)로 만든 뒤 `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 호출(329) | 그리드에 결과 표시 | flow.csv |
| S5 | 그리드 편집 후 저장(SaveButton) | SaveButton > SaveData. 안에서 `SSP.SSP0014_GET_USER_ID_CHECK`(GetUserIDChk:562), `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`(497), `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`(재조회, 329) 호출 | `SSP_MST_MODEL_USER`에 MERGE 반영, `SCM_SYS_LOG_BATCH`에 INSERT, 그리드 재조회. 실행 순서와 조건은 **확인 필요** | flow.csv, endpoints.csv |
| S6 | 그리드 셀 더블클릭 | `SpdMain_CellDoubleClick` 실행 | 본문 **확인 필요** | events.csv |
| S7 | 그리드 스크롤 | `SpdMain_TopChange` 실행 | 본문 **확인 필요** | events.csv |
| S8 | 편집(EditButton) | `if(fps.Name == "spdMain")`이면 GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)(271) | 활성 시트 정보 사용. 이후 처리는 **확인 필요** | grid_code.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  └─ Form_Load
       ├─ InitControls : FP_Log2(로그) · insertRow["CODE"/"NAME"] 행 추가(대상 콤보 확인 필요)
       ├─ SetChangeControl : Filter GROUP_ID/USER_ID · UserInfoContext.Current.NowGroupID · GetSSPInnerTable
       └─ CreateSpread → AddSheet("Shipment Model PIC") → InitSpread → SetSheetHeaderColumn(메타 21컬럼) → 이미지 CellType 8건
[조건 입력]
  ├─ cboDivision 변경 → CboDivision_SelectedIndexChanged (본문 확인 필요)
  └─ btnItemId 클릭 → btnItemId_Click → txtItemId.Text = sItemId
[조회] FindButton → FindData_Main → SSP.SSP0014_GET_SHIPMENT_MODEL_PIC → SP SSP0014_GET_SHIPMENT_MODEL_PIC → spdMain
[저장] SaveButton → SaveData
        ├─ GetUserIDChk → SSP.SSP0014_GET_USER_ID_CHECK → SP SSP0014_GET_USER_ID_CHECK
        ├─ SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC → SP SSP0014_SAVE_SHIPMENT_MODEL_PIC (→ EXEC PR_SCM_SYS_LOG_BATCH)
        └─ FindData_Main → SSP.SSP0014_GET_SHIPMENT_MODEL_PIC (재조회)
        ※ 세 호출의 순서와 분기 조건은 확인 필요. 위 나열은 flow.csv 행을 옮긴 것이고 실행 순서를 확인한 것이 아닙니다.
[미연결] <field:dtYesOrNo>(54) → biz:CommonData.YesOrNo (진입점 미연결, 사용 컨트롤 확인 필요)
```

## 4. 업무 규칙

| # | 규칙 | 사실 근거 | 상태 |
|---|---|---|---|
| R1 | 조회조건 Division은 필수 | 라벨 원문 `Division*`(props.csv:325) | 라벨 `*` 기준. 코드에서 검증하는지는 **확인 필요** |
| R2 | 그리드 USER_ID, VALID_YN은 필수 입력 컬럼 | 메타 라벨 `User ID*`, `Valid*` | 라벨 기준. 저장 전 검증 로직은 **확인 필요** |
| R3 | 저장할 때 사용자 ID를 검사함 | SaveData > GetUserIDChk가 `SSP0014_GET_USER_ID_CHECK` 호출. SP가 TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION 조회 | 검사 기준(존재·권한 그룹 등)과 실패 시 처리는 **확인 필요** |
| R4 | 저장은 MERGE(있으면 갱신, 없으면 추가) | `SSP0014_SAVE_SHIPMENT_MODEL_PIC`: MERGE SSP_MST_MODEL_USER | MERGE 키 컬럼은 **확인 필요** |
| R5 | 저장하면 배치 로그를 남김 | SAVE SP: INSERT SCM_SYS_LOG_BATCH, EXEC PR_SCM_SYS_LOG_BATCH | 로그 내용은 **확인 필요** |
| R6 | 다건 값은 구분자 문자열로 전달하고 SP에서 분해함 | GET·USER_ID_CHECK SP의 REF STRING_SPLIT, SAVE SP의 REF SCM_ARR_SPL_CNT/SCM_ARR_SPL_VAL, FindData_Main의 GetCheckedListValue 4회(310~313) | 구분자와 파라미터 매핑은 **확인 필요** |
| R7 | Model 닉네임은 함수로 구함 | GET SP REF FN_GET_ITEM_NICKNAME, 그리드 NICK_NAME 컬럼 | 컬럼과 함수의 연결은 **확인 필요** |
| R8 | 날짜/버킷 규칙 | Fact Pack에 날짜 조회조건이나 버킷 로직이 없음 | 해당 없음(사실 없음) |
| R9 | SP 분기 조건 | Fact Pack에 SP 내부 분기 조건이 없음 | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기(SELECT/REF) | 쓰기 | 화면설계서 §5 |
|---|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`:54 (진입점 미연결) | 없음(Data.Common[Type.YesOrNo] > Data.CallBizData) | 확인 필요 | 없음 | A-07 |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | FindData_Main:329 | `SSP0014_GET_SHIPMENT_MODEL_PIC` | SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF FN_GET_ITEM_NICKNAME, STRING_SPLIT | 없음 | A-01, A-02 |
| `SSP.SSP0014_GET_USER_ID_CHECK` | GetUserIDChk:562 | `SSP0014_GET_USER_ID_CHECK` | TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF STRING_SPLIT | 없음 | A-02 |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | SaveData:497 | `SSP0014_SAVE_SHIPMENT_MODEL_PIC` (+EXEC PR_SCM_SYS_LOG_BATCH) | REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | MERGE SSP_MST_MODEL_USER, INSERT SCM_SYS_LOG_BATCH | A-02 |

프레임워크 호출(엔드포인트 아님): `DataService.GetSSPInnerTable`(SetChangeControl:144·149), `DataService.FP_Log2`(InitControls:170·173), `SpreadInfo.SetSheetHeaderColumn`(InitSpread:222, SCM_MST_SHEET_COLUMNS 메타).

## 6. Division·권한별 변형

**Division**
- 시트 `Shipment Model PIC`는 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 21컬럼이 모두 '기본' 표시입니다. 필수+기본은 21, 선택은 0입니다. **division별 차이는 없습니다.**
- 코드 분기 중 division을 판단하지 못한 건: 0건.
- 실제 SP 실행 결과와 시트를 대조하는 단계는 실행하지 않았습니다 → **확인 필요**.

**권한**
- SetChangeControl:137~138에서 Filter `GROUP_ID`, `USER_ID`와 `UserInfoContext.Current.NowGroupID`를 사용합니다. 그룹·사용자에 따라 조회조건이 달라지는지는 **확인 필요**입니다.
- 메뉴 권한 메타 TB_FX_GroupMenuAuth에 13행이 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없음 → **확인 필요**.
- 저장 시 `SSP0014_GET_USER_ID_CHECK`가 TB_FX_USERGROUPAUTHEXTENTION을 조회합니다. 권한 그룹과 관련한 검사로 보이지만 내용은 **확인 필요**입니다.

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스 사실이 없습니다 → 해당 없음.
- (참고) 배치 로그 테이블 SCM_SYS_LOG_BATCH에 INSERT하는 것은 내부 로그이며 외부 인터페이스로 확인된 사실은 아닙니다.

## 8. 미확정·확인 필요

1. SaveData 안에서 GetUserIDChk → SAVE → 재조회가 실행되는 순서, 조건, 실패 시 처리
2. SaveButton:285의 `SaveData` 해석. 추출기가 `PersonalSettingPopup.SaveData`로 해석했지만, 화면 자체 SaveData(497)일 수 있음
3. `biz:CommonData.YesOrNo`(dtYesOrNo:54)를 쓰는 컨트롤. cboValidYN과 연결된다는 것은 추정임
4. FindData_Main 310~313의 GetCheckedListValue 4회가 각각 어느 컨트롤 값인지
5. 각 조회조건의 값 원천과 필수 여부(Division 외)
6. GET_USER_ID_CHECK의 검사 기준과 메시지
7. MERGE 키와 삭제 지원 여부
8. 이벤트 핸들러 본문(Form_Load, SpdMain_TopChange, SpdMain_CellDoubleClick, CboDivision_SelectedIndexChanged)
9. Oracle 대응 객체: STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, FN_GET_ITEM_NICKNAME, PR_SCM_SYS_LOG_BATCH
10. 업무 목적 원문과 메뉴 위치(TB_FX_MenuItemInfo 1행 원문 대조)
