# DMF0045 TO-BE 설계 입력 정리

## 1. 조회조건 (컨트롤 기준)

| 조건 | AS-IS 컨트롤 | 라벨 원문 | 데이터 소스(사실) | 비고 |
|---|---|---|---|---|
| Division | cboDivision (UsrCombo) | Division | `biz:CommonData.CommonDataList` [code=MyDivision] (InitControls:200) | 변경 시 InitSpread > `DM.DMF0045_GET_SPREAD_TITLE` 재호출 |
| Bucket | cboBucketType (UsrCombo) | Bucket | `DM.DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:2266) | 값 DAILY/WEEKLY/MONTHLY(SetSpreadColumn 분기). 변경 시 SetSpreadColumn |
| 기간 | drpPeriod (UsrDateRangePicker) | 확인 필요 (항목명 `Period`) | 확인 필요 | Enabled=false |
| Plant Site | clbPlantSite (UsrCheckedList) | Plant Site | 확인 필요 | 다중 선택 |
| Sales Site | clbSalesSite (UsrCheckedList) | Sales Site | 확인 필요 | 다중 선택 |
| End Customer | clbCustomer (UsrCheckedList) | End Customer | 확인 필요 | 다중 선택. SelectedIndexChanged 연쇄 동작은 확인 필요 |
| Team | clbTeam (UsrCheckedList) | Team | 확인 필요 | 다중 선택. SelectedIndexChanged 연쇄 동작은 확인 필요 |
| Project | txtProject + btnProject | Project | btnProject_Click → `txtProject.Text = sProjectCode` | 멀티라인 |
| Model | txtItemId + btnItemId | Model | btnItemId_Click → `txtItemId.Text = sItemId` | 멀티라인 |
| Sum | chkSum (UsrCheckBox) | Sum | — | 합계(M_/W_) 컬럼 표시 토글 |
| Item Type | (연결 컨트롤 확인 필요) | Item Type | 확인 필요 | lblItemType |
| Measure 설정 | btnMeasure | 확인 필요 | InitSpread 재호출 | |
| Column 설정 | btnColumn | 확인 필요 | InitSpread 재호출 | AS-IS Visible=false |

- 필수 조회조건(필수 표시, 검증)은 Fact Pack에 없음 → **확인 필요**. validation 원문이 필요합니다.
- 조회조건 저장 메타 `TB_FX_SearchCondition`에 615행이 있습니다(dbmeta). 기본값과 개인화 내용은 **확인 필요**.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load > InitControls / CreateSpread | `biz:CommonData.CommonDataList`(MyDivision, Measure), `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM.DMF0045_GET_SPREAD_TITLE` |
| 조회 | FindButton > FindData | `biz:CommonData.CommonDataList`(Measure), `DM.DMF0045_GET_SHIPMENT_REQUEST`, `DM.DMF0045_GET_SPREAD_TITLE` → SetSpreadColumn |
| 저장 | SaveButton > SaveData | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → 재조회(FindData 흐름 전체) |
| 행추가 | InsertButton > InsertRow | `biz:CommonData.CommonDataList`(FCST_TYPE, Measure) → FCST_TYPE·MEASURE 셀 콤보 |
| 편집 | EditButton | GetSheetInfo(활성 시트)만 확인됨. API 없음 |
| Division 변경 | cboDivision_SelectedIndexChanged | `DM.DMF0045_GET_SPREAD_TITLE` |
| Bucket 변경 / Sum 체크 | cboBucketType_SelectedIndexChanged / chkSum_CheckedChanged | API 없음. 클라이언트에서 컬럼 표시만 전환 |
| Measure / Column 버튼 | btnMeasure_Click / btnColumn_Click | `DM.DMF0045_GET_SPREAD_TITLE` |
| Grid END_CUSTOMER 변경 | spdMain_ComboSelChange | Data.UserSiteByEndCustomer / UserSiteByEndCustomerAuth (API 확인 필요) → FROM_SITE 콤보 |
| Grid FROM_SITE 변경 | spdMain_ComboSelChange | `biz:CommonData.CommonDataList`(MktFcstEditMeasure) → MEASURE 콤보 |
| Grid 셀 값 변경 | spdMain_Changed | `biz:CommonData.CommonDataList`(DefaultBucketDay) |
| 헤더 더블클릭 | spdMain_CellDoubleClick | API 없음. M_/W_/D_ 컬럼 접기·펼치기 |
| (미연결) | GetBizTypebyDivision | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`. TO-BE 필요 여부는 확인 필요 |

## 3. Division별 Grid 변형 요약

| 시트 | 81 | 81_UC | 82 | 40 / EE / 81 하위(HD·HG·HM·ST) |
|---|---|---|---|---|
| Cell Biz 고정 컬럼(표시) | 13 | 13 | 13 | 메타 없음 |
| Cell Biz Measure 메타 수 | 11 | 11 | 10 | 메타 없음 |
| Pack Biz 고정 컬럼(표시) | 13 | 13 | 13 | 메타 없음 |
| Pack Biz Measure 메타 수 | 9 | 9 | 8 | 메타 없음 |

- 고정 컬럼은 Division 사이에 차이가 없습니다. Division 간 차이는 Measure 행 수에만 있습니다.
- 날짜 버킷 컬럼(D_/W_/M_)은 SP가 생성하며, 표시는 Bucket과 Sum 상태에 따라 클라이언트가 바꿉니다.
- 메타와 SP 결과 차이 1054건(grid_diff.csv)을 대조한 뒤 컬럼을 확정해야 합니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth`에 DMF0045 관련 13행 존재 | dbmeta 8장. 행 내용은 **확인 필요** |
| `TB_FX_ProgramInfo` 1행, `TB_FX_MenuItemInfo` 1행 존재 | dbmeta |
| 프레임워크 버튼 Find/Insert/Save/Edit 진입점 존재 | flow.csv, grid_code 443 |
| Division 목록이 사용자 그룹 권한 테이블 `TB_FX_USERGROUPAUTHEXTENTION`을 참조 | [code=MyDivision] 분기 |
| FROM_SITE 콤보에 권한 버전 함수(`UserSiteByEndCustomerAuth`) 분기 존재 | spdMain_ComboSelChange:1158 |
| `InsertRow`는 `siMain.IsLock(...) == false`일 때만 동작 | grid_code 1003/1005 조건 |
| `UserInfoContext.Current["NowGroupID"]`를 여러 지점에서 참조 | meta_reads.csv |

- Delete 버튼과 삭제 API는 Fact Pack에 없습니다. TO-BE에서 삭제 기능이 필요한지는 **확인 필요**.

## 5. 미확정 사항

1. 기간(drpPeriod) 라벨, 기본값 설정 로직, Enabled=false의 이유
2. Item Type 라벨과 연결 컨트롤, layoutControlItem6/7의 연결 컨트롤
3. Plant Site / Sales Site / End Customer / Team 콤보의 데이터 소스와 연쇄 갱신 규칙
4. Project / Model 찾기 팝업 화면 ID
5. MEASURE 콤보 소스 3가지 후보 중 실제 분기, FROM_SITE 콤보 API
6. `spdMain_TopChange`, `spdMain_KeyUp` 동작
7. `GetBizTypebyDivision`(SCM0001) 미연결 메서드를 TO-BE에 반영할지 여부
8. 시트(Cell Biz / Pack Biz) 선택 규칙(Division의 Biz Type과의 관계)
9. DAILY 버킷에서 W_ 컬럼의 최종 표시 상태(2152·2157 조건 중복)
10. 조회 SP 안의 `SCM_MST_TITLESET_USER` INSERT를 TO-BE에서 어떻게 처리할지
11. 저장 SP의 기존 행 처리 방식(UPDATE A 대상)과 필수 검증(validation) 원문
12. `TB_FX_GroupMenuAuth` 13행의 권한 값
