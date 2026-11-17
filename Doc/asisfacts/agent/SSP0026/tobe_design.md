# SSP0026 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 메인 조회조건

| 순번 | 라벨(As-is 원문) | As-is 컨트롤 | 형태 | 비고 |
|---:|---|---|---|---|
| 1 | Division | cboDivision | 단일 콤보 | MyDivision(사용자 권한 Division). 바꾸면 Grid 를 다시 구성합니다 |
| 2 | Plant Site | clbPlantSite | 다중 체크 | |
| 3 | Sales Site | clbSalesSite | 다중 체크 | |
| 4 | End Customer | clbCustomer | 다중 체크 | 변경 이벤트 있음(NowGroupID 사용) |
| 5 | Team | clbTeam | 다중 체크 | 변경 이벤트 있음(NowGroupID 사용) |
| 6 | Model | txtItemId + btnItemId | 다중 입력 + 팝업 | |
| 7 | Project | txtProject + btnProject | 다중 입력 + 팝업 | |
| 8 | Bucket | cboBucketType | 콤보 | DM0003_GET_BUCKET_TYPE_CODE, DAILY / WEEKLY / MONTHLY |
| 9 | (Period, 라벨 확인 필요) | drpPeriod | 기간 | |
| 10 | Item Type | 확인 필요 | 확인 필요 | 연결 컨트롤 미확인 |
| 11 | Sum | chkSum | 체크 | 합계 컬럼 표시. 조회 파라미터 여부는 확인 필요 |
| 12 | Including Past Period | chkPastPeriod | 체크 | Designer Visible=false, Checked=true |
| — | (Measure 버튼) | btnMeasure | 버튼 | Grid 재구성 |

조회조건 저장 메타: TB_FX_SearchCondition 48행. 조건별 매핑은 **확인 필요**입니다.

### 1-2. 하단 상세 조회조건 (Panel2)

drpPeriod2, txtRequestor + btnRequestor, txtItemld2 + btnItemID2, txtLotID, textNickName2, btnSearch. 라벨 원문은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러 / 경로 | 호출 SP | TO-BE API 후보(가칭) |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls / CreateSpread | CommonDataList(MyDivision, Measure), DM0003_GET_BUCKET_TYPE_CODE, SSP0026_GET_SPREAD_TITLE | 공통 콤보 API + `ssp0026/spreadTitle` |
| 메인 조회 (Pack Biz) | FindButton > FindData:787 | SSP0026_GET_SHIPMENT_REQUEST_PACK (+GET_SPREAD_TITLE) | `ssp0026/searchPack` |
| 메인 조회 (Cell Biz) | FindButton > FindData:848 | SSP0026_GET_SHIPMENT_REQUEST_CELL | `ssp0026/searchCell` |
| 메인 저장 (Pack) | SaveButton > SaveData:1508 | SSP0026_SAVE_SHIP_REQ_PACK, 이후 재조회 | `ssp0026/savePack` |
| 메인 저장 (Cell) | SaveButton > SaveData:1580 | SSP0026_SAVE_SHIP_REQ_CELL, 이후 재조회 | `ssp0026/saveCell` |
| 상세 저장 | SaveButton > SaveData_Detail:1783 / 1860 | SSP0026_SAVE_SHIP_REQ_DETAIL_PACK / SSP0026_SAVE_SHIP_REQ_DETAIL_CELL(⚠ DB 없음) | `ssp0026/saveDetailPack` (Cell 은 미확정) |
| 메인 행 더블클릭 | SpdMain_CellDoubleClick > FindData_Detail_DblClick | SSP0026_GET_REQUEST_DETAIL_PACK / _CELL(⚠) | `ssp0026/searchRequestDetail` |
| 하단 Search (Request) | BtnSearch_Click > FindData_Detail | SSP0026_GET_REQUEST_DETAIL_PACK / _CELL(⚠) | 위와 같음 |
| 하단 Search (Result) | BtnSearch_Click > FindData_Result_Detail | SSP0026_GET_RESULT_DETAIL | `ssp0026/searchResultDetail` |
| Excel Form | btnExcelFormDownload_Click | SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | `ssp0026/excelForm` |
| Upload | btnExcelUpload_Click (MSG00265 확인) | 업로드 후 FindData / FindData_Detail 재조회 | 화면에서 파싱한 뒤 Request Detail 에 반영. 저장은 상세 저장 API |
| Grid 콤보 / 붙여넣기 (메인) | SpdMain_ComboSelChange / SpdMain_ClipboardPasted > FindData_BOD_Main | SSP0026_GET_BOD_ITEM, CommonDataList(TransMode) | `ssp0026/bodItem` + 공통 TransMode |
| Grid 콤보 / 붙여넣기 (상세) | SpdDetail_ComboSelChange / SpdDetail_ClipboardPasted | CommonDataList(ShipToCodeByDivision), SSP0026_GET_BOD_ITEM, TransMode | 공통 ShipTo + `ssp0026/bodItem` |
| Division / Measure / 시트 전환 | cboDivision_SelectedIndexChanged, btnMeasure_Click, SpdMain_ActiveSheetChanged | SSP0026_GET_SPREAD_TITLE | `ssp0026/spreadTitle` |
| Bucket / Sum / 과거기간 | cboBucketType_SelectedIndexChanged, chkSum_CheckedChanged, chkPastPeriod_CheckedChanged | 없음(SetSpreadColumn 으로 화면 표시만 전환) | FE 컬럼 표시 로직 |
| BOD Item 팝업 | SSP0026_BodItemPopup | SSP0026_GET_BOD_ITEM, SCM0001_GET_DIVISION, SCM0001_GET_SITE_BY_DIVISION | 팝업 API |
| Item by Division 팝업 | SSP0026_ItembyDivisionPopup | SSP0026_GET_ITEM_BY_DIVISION_POPUP, SCM0001_GET_DIVISION | 팝업 API |

진입점이 연결되지 않은 호출(GetBizTypebyDivision, BodValidChk(_Main), spdMain_ComboSelChange 소문자, spdMain_Changed)은 TO-BE 구현 대상에서 빼는 후보입니다. 업무 확인 후 확정합니다.

## 3. Division별 Grid 변형 요약

| 시트 | Division 40 | 그 외 Division |
|---|---|---|
| Pack Biz | 16컬럼 + 버킷 컬럼, Measure 8 | 메타 없음. 코드 표시 2컬럼만 (확인 필요) |
| Cell Biz | 13컬럼 + 버킷 컬럼, Measure 10. `drPgmAuthId != null` 일 때만 시트 생성 | 메타 없음 |
| Shipment Request Detail | 35 | 35 |
| Shipment Result Detail | 12 | 12 |
| Shipment Request Detail Excel | 10 | 10 |
| Shipment Request Detail_BACKUP | 19 (코드 미참조) | 19 |
| Project (팝업) | 14 (하드코딩) | 14 |

공통 코드 규칙:
- Pack Biz 로 전환하면 SHIPTO_CODE 와 ORDER_TYPE_DETAIL 을 표시하고 FCST_TYPE 을 숨깁니다.
- 버킷(D_/W_/M_)과 Sum, 과거기간 표시 규칙을 적용합니다.
- 컬럼명에 `B_` 가 들어간 컬럼은 숨깁니다.
- 토요일은 파랑, 일요일은 빨강 헤더입니다.
- Request Detail 은 MergePolicy.None 입니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth 에 SSP0026 관련 12행 | DB 메타. C/R/U/D 값은 Fact Pack 에 없어 **확인 필요** |
| TB_FX_ProgramInfo 2행, TB_FX_MenuItemInfo 2행, TB_FX_Favorite 9행 | DB 메타 |
| Division 콤보 = MyDivision (TB_FX_USERGROUPAUTHEXTENTION 참조) | InitControls:231 |
| Cell Biz 시트 노출 = `drPgmAuthId != null` (dtPgmAuthId = LookupCommon) | CreateSpread:340, 필드:60 |
| FROM_SITE / TO_SITE 콤보가 사용자 기준으로 필터링됨 (UserPlantSiteByDivisionOspPack, UserSiteByEndCustomerAuth, NowGroupID·UserId 인자) | InsertRow:1965·1966·2049·2050 |
| 다수 이벤트에서 `UserInfoContext.Current["NowGroupID"]` 사용 | meta_reads.csv |
| 편집 모드 플래그 bEdit_Mode_Detail, 시트 잠금 IsLock 확인 | EditButton:675·714, InsertRow:2049, SpdDetail_ClipboardPasted:3466 |
| SHIP_FROZEN / CONFIRM_DAY 를 읽어 셀 처리 | Re_Design:4076·4088, ShowCell:4236 (구체 동작 확인 필요) |

## 5. 미확정 사항

1. Cell 상세 SP 2종(GET_REQUEST_DETAIL_CELL, SAVE_SHIP_REQ_DETAIL_CELL)이 DB에 없습니다. Cell Biz 상세 기능의 범위를 정해야 합니다.
2. Cell Biz 시트 노출 조건(LookupCommon 값)과 권한 그룹의 관계를 확인해야 합니다.
3. 버튼별 팝업 연결을 확인해야 합니다: btnItemId / btnItemID2 / btnProject / btnRequestor 가 각각 어느 팝업을 여는지.
4. 하단 조회조건의 라벨과 SP 파라미터 매핑을 확인해야 합니다.
5. Item Type 라벨에 연결된 컨트롤을 확인해야 합니다.
6. SplitContainer 상/하 비율(SplitterDistance)을 확인해야 합니다.
7. 메타 라벨 오타 유지 여부를 정해야 합니다(Frorm, MEASUR_COLOR, Confrim, MKT_OWMER, MOEL_USER, "DMF0045").
8. Shipment Request Detail_BACKUP 시트를 폐기할지 정해야 합니다.
9. 40 이외 Division 에서 Pack Biz 화면이 실제로 어떻게 보이는지 실행으로 확인해야 합니다.
10. 업로드 검증 로직(BOD 유효성 등)을 확인해야 합니다. BodValidChk 계열은 진입점이 연결되어 있지 않습니다.
11. SaveButton:739 → PersonalSettingPopup.SaveData 매핑이 맞는지 확인해야 합니다.
