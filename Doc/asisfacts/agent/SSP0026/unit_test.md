# SSP0026 Shipment Request Pack — 단위테스트

> 근거 열의 이름은 업무분석서 §5 엔드포인트, 화면설계서 §5 핸들러, §4 시트 이름 원문과 같습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 테스트 대상이 아닙니다. 기대결과 중 Fact Pack으로 확정할 수 없는 부분은 '확인 필요'로 적었습니다. 이런 항목은 AS-IS를 실행해 기대값을 확정한 뒤 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0026-001 | 초기화 | Division 권한이 있는 사용자로 로그인 | 화면을 연다 | — | cboDivision에 MyDivision 목록이 채워진다 | `Form_Load` > InitControls:231 / `biz:CommonData.CommonDataList`[MyDivision] |
| TC-SSP0026-002 | 초기화 | 001과 같음 | 화면을 연다 | — | Measure 목록을 조회한다(InitControls:306) | `Form_Load` / `biz:CommonData.CommonDataList`[Measure] |
| TC-SSP0026-003 | 초기화 | 001과 같음 | 화면을 열고 cboBucketType 목록을 확인한다 | — | DAILY, WEEKLY, MONTHLY 코드가 표시된다(값과 기본 선택은 SCM_ADM_LOOKUP_MASTER_DETAIL 기준으로 확인) | `Form_Load` > GetBucketType / `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0026-004 | 초기화 | 001과 같음 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Pack Biz` 시트가 생성되고 헤더 3행이 구성된다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-005 | 권한 | LookupCommon 값으로 drPgmAuthId가 존재하는 사용자 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Cell Biz` 시트가 생성된다 | CreateSpread:340 / `biz:CommonData.CommonDataList`[LookupCommon] / `Cell Biz` |
| TC-SSP0026-006 | 권한 | drPgmAuthId가 null인 사용자 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Cell Biz` 시트가 생성되지 않는다 | CreateSpread:340 / `Cell Biz` |
| TC-SSP0026-007 | 초기화 | 001과 같음 | spdDetail 시트 탭을 확인한다 | — | `Shipment Request Detail` 시트와 `Shipment Result Detail` 시트가 있다 | CreateSpread:351/358 / `Shipment Request Detail` / `Shipment Result Detail` |
| TC-SSP0026-008 | 조회 | spdMain 활성 시트 = Pack Biz | cboDivision=40, 조회조건을 입력하고 조회(FindButton)를 누른다 | Division 40, cboBucketType=DAILY | spdMain에 Measure별 행과 날짜 컬럼이 표시된다 | FindButton > FindData:787 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_SPREAD_TITLE` / `biz:CommonData.CommonDataList`[Measure] |
| TC-SSP0026-009 | 조회 | spdMain 활성 시트 = Cell Biz (005 조건) | 조회(FindButton)를 누른다 | Division 40 | Cell SP로 조회되어 Cell Biz에 표시된다 | FindData:848 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` / `Cell Biz` |
| TC-SSP0026-010 | 조회 | Pack Biz | 데이터가 없는 조건으로 조회한다 | clbPlantSite에 데이터 없는 Site만 선택 | 0행이 표시된다. 헤더는 유지되고 오류는 없다(안내 메시지 여부는 확인 필요) | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-011 | 조회 | Pack Biz, SP 오류가 나도록 만든 환경 | 조회한다 | — | 오류 메시지를 표시하고 그리드는 갱신하지 않는다(메시지 원문 확인 필요) | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-012 | 저장 | Pack Biz 조회 후 행 수정 | 저장(SaveButton)을 누른다 | 수량 셀 변경 | SSP_ANL_SHIP_PLAN_PACK_REQ, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH에 반영되고 재조회된다 | SaveButton > SaveData:1508 / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |
| TC-SSP0026-013 | 저장 | Cell Biz 조회 후 행 수정 | 저장(SaveButton)을 누른다 | 수량 셀 변경 | DM_PLN_SHIPMENT_REQ와 DM_PLN_SHIPMENT_REQ_H에 반영되고 재조회된다 | SaveData:1580 / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` |
| TC-SSP0026-014 | 저장 | 상세 편집 모드(bEdit_Mode_Detail), Shipment Request Detail 행 수정 | 저장(SaveButton)을 누른다 | Qty, Shipment Date 변경 | SSP_ANL_SHIP_REQ_P, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN에 반영되고 상세가 재조회된다 | SaveData_Detail:1783 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-015 | 저장 | Cell 상세 저장 경로 | 저장(SaveButton)을 누른다 | — | DB에 SP가 없으므로 오류 응답 처리를 확인한다(AS-IS 실행 결과 확인 필요) | SaveData_Detail:1860 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` |
| TC-SSP0026-016 | 저장 | 필수 컬럼(`*`)을 비운 행 | 저장(SaveButton)을 누른다 | Model* 빈값 | 검증 메시지가 나오거나 SP 오류가 난다(어느 쪽인지 확인 필요). 데이터는 반영되지 않는다 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` / `Pack Biz` |
| TC-SSP0026-017 | 이벤트 | spdDetail 활성 시트 = Shipment Request Detail (Pack) | 하단 조건을 입력하고 btnSearch를 누른다 | drpPeriod2 기간, txtItemld2 | Request Detail이 조회된다 | `BtnSearch_Click` > FindData_Detail:1071 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `Shipment Request Detail` |
| TC-SSP0026-018 | 이벤트 | Cell 상세 조회 경로 | btnSearch를 누른다 | — | DB에 SP가 없으므로 오류 응답 처리를 확인한다(확인 필요) | `BtnSearch_Click` > FindData_Detail:1115 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` |
| TC-SSP0026-019 | 이벤트 | spdDetail 활성 시트 = Shipment Result Detail | btnSearch를 누른다 | drpPeriod2 기간 | Result Detail 12컬럼으로 조회된다 | `BtnSearch_Click` > FindData_Result_Detail:969 / `SSP.SSP0026_GET_RESULT_DETAIL` / `SSP.SSP0026_GET_SPREAD_TITLE` / `Shipment Result Detail` |
| TC-SSP0026-020 | 조회 | 017과 같음 | 데이터가 없는 조건으로 btnSearch를 누른다 | 데이터 없는 txtLotID | 0행이 표시되고 오류는 없다 | `BtnSearch_Click` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-021 | 이벤트 | Pack Biz 조회 결과 있음 | spdMain 행을 더블클릭한다 | 1행 | 해당 행 기준으로 Shipment Request Detail이 조회된다 | `SpdMain_CellDoubleClick` > FindData_Detail_DblClick:1232 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-022 | 이벤트 | Cell Biz 조회 결과 있음 | spdMain 행을 더블클릭한다 | 1행 | Cell 상세 조회를 시도한다(SP 미존재에 따른 결과는 확인 필요) | `SpdMain_CellDoubleClick` > 1274 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` |
| TC-SSP0026-023 | 이벤트 | 001과 같음 | formDown(Excel Form)을 누른다 | — | Shipment Request Detail Excel 10컬럼 양식 파일을 내려받는다 | `btnExcelFormDownload_Click` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` / `Shipment Request Detail Excel` |
| TC-SSP0026-024 | 이벤트 | 양식에 맞게 작성한 Excel 파일 | btnExcelUpload(Upload)를 누르고 MSG00265에서 확인을 누른다 | 양식 파일 | 업로드 후 메인과 상세가 재조회된다 | `btnExcelUpload_Click` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-025 | 이벤트 | 024와 같음 | btnExcelUpload를 누르고 MSG00265에서 취소를 누른다 | — | 업로드하지 않는다(확인 필요) | `btnExcelUpload_Click` |
| TC-SSP0026-026 | 이벤트 | 조회 완료 | btnMeasure를 누른다 | — | 그리드 헤더를 다시 구성한다 | `btnMeasure_Click` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-027 | 이벤트 | 001과 같음 | 화면에서 btnColumn이 보이는지 확인한다 | — | Visible=false라 화면에 노출되지 않는다. 핸들러는 배선되어 있다 | `btnColumn_Click` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-028 | division | 2개 이상 Division 권한 | cboDivision을 40에서 81로 바꾼다 | 40 → 81 | 헤더를 다시 구성한다. Pack Biz의 메타 컬럼이 사라진다(→TC-058) | `cboDivision_SelectedIndexChanged` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-029 | 이벤트 | DAILY 조회 완료 | chkSum을 체크하고 해제한다 | Checked true/false | M_·W_ 컬럼 Visible이 chkSum.Checked를 따른다 | `chkSum_CheckedChanged` > SetSpreadColumn 2914 |
| TC-SSP0026-030 | 이벤트 | 조회 완료 | cboBucketType을 DAILY로 바꾼다 | DAILY | D_·W_ 컬럼 표시, M_은 chkSum을 따른다 | `cboBucketType_SelectedIndexChanged` > 2909/2914 |
| TC-SSP0026-031 | 이벤트 | 조회 완료 | cboBucketType을 WEEKLY로 바꾼다 | WEEKLY | D_ 숨김, W_ 표시, M_은 chkSum을 따른다 | `cboBucketType_SelectedIndexChanged` > 2921/2925/2930 |
| TC-SSP0026-032 | 이벤트 | 조회 완료 | cboBucketType을 MONTHLY로 바꾼다 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged` > 2937/2941 |
| TC-SSP0026-033 | 이벤트 | chkPastPeriod를 노출한 시험 환경(Designer Visible=false) | chkPastPeriod를 해제한다 | false | SUM이 아닌 과거 날짜(date > colDate) 컬럼이 숨겨진다 | `chkPastPeriod_CheckedChanged` > SetSpreadColumn 2960 |
| TC-SSP0026-034 | 이벤트 | 001과 같음 | btnProject를 누른다 | — | 동작(팝업 종류, txtProject 반영)은 확인 필요. 오류 없이 반응하는지 확인한다 | `btnProject_Click` |
| TC-SSP0026-035 | 이벤트 | 001과 같음 | btnItemId를 누른다 | — | 동작은 확인 필요(txtItemId 반영 여부) | `BtnItemID_Click` |
| TC-SSP0026-036 | 이벤트 | 001과 같음 | btnItemID2를 누른다 | — | 동작은 확인 필요(txtItemld2 반영 여부) | `BtnItemID2_Click` |
| TC-SSP0026-037 | 이벤트 | 001과 같음 | btnRequestor를 누른다 | — | 동작은 확인 필요(txtRequestor 반영 여부) | `BtnRequestor_Click` |
| TC-SSP0026-038 | 이벤트 | 001과 같음 | clbCustomer 선택을 바꾼다 | End Customer 1건 | NowGroupID를 사용하는 후속 처리가 있다. 연동되는 컨트롤은 확인 필요 | `clbCustomer_SelectedIndexChanged` |
| TC-SSP0026-039 | 이벤트 | 001과 같음 | clbTeam 선택을 바꾼다 | Team 1건 | 후속 처리는 확인 필요 | `clbTeam_SelectedIndexChanged` |
| TC-SSP0026-040 | 그리드 | 조회 결과 다건 | spdMain을 세로 스크롤한다 | — | 동작(spdDetail 동기화 여부)은 확인 필요. 오류가 없어야 한다 | `SpdMain_TopChange` |
| TC-SSP0026-041 | 그리드 | 상세 결과 다건 | spdDetail을 세로 스크롤한다 | — | 동작은 확인 필요. 오류가 없어야 한다 | `SpdDetail_TopChange` |
| TC-SSP0026-042 | 그리드 | Pack Biz 편집 가능 행 | spdMain의 콤보 셀을 선택해 바꾼다 | FROM_SITE/TO_SITE 값 | BOD Item과 Trans Mode가 재조회되어 반영된다 | `SpdMain_ComboSelChange` > FindData_BOD_Main / `SSP.SSP0026_GET_BOD_ITEM` / `biz:CommonData.CommonDataList`[TransMode] |
| TC-SSP0026-043 | 그리드 | 042와 같음 | spdMain에 여러 행을 붙여넣는다 | 3행 | 붙여넣은 행마다 BOD와 TransMode가 반영된다 | `SpdMain_ClipboardPasted` / `SSP.SSP0026_GET_BOD_ITEM` / `biz:CommonData.CommonDataList`[TransMode] |
| TC-SSP0026-044 | 그리드 | Shipment Request Detail 편집 모드 | spdDetail의 TO_SITE 콤보를 바꾼다 | TO_SITE 변경 | SHIPTO_CODE 콤보가 ShipToCodeByDivision으로 다시 채워지고 BOD와 TransMode가 재조회된다 | `SpdDetail_ComboSelChange` / `biz:CommonData.CommonDataList`[ShipToCodeByDivision] / `SSP.SSP0026_GET_BOD_ITEM` / `Shipment Request Detail` |
| TC-SSP0026-045 | 그리드 | 044와 같음, 시트 잠금 아님 | spdDetail에 붙여넣는다 | 2행 | ShipTo, BOD, TransMode가 반영된다 | `SpdDetail_ClipboardPasted` 3464/3482 / `biz:CommonData.CommonDataList`[ShipToCodeByDivision] / `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-046 | 그리드 | 시트 IsLock 상태 | spdDetail에 붙여넣는다 | 1행 | 잠금 상태에서의 처리(차단 여부)는 확인 필요 | `SpdDetail_ClipboardPasted`:3466 |
| TC-SSP0026-047 | 그리드 | 상세 결과 있음 | spdDetail 행을 더블클릭한다 | 1행 | 동작은 확인 필요 | `SpdDetail_CellDoubleClick` |
| TC-SSP0026-048 | 그리드 | 001과 같음 | spdDetail 시트를 Request에서 Result로 전환한다 | — | 동작은 확인 필요. 이후 btnSearch를 누르면 Result Detail 조회로 분기하는지 확인한다(TC-019) | `SpdDetail_ActiveSheetChanged` / `Shipment Result Detail` |
| TC-SSP0026-049 | 그리드 | Cell Biz 존재(005) | spdMain 시트를 Cell Biz에서 Pack Biz로 전환한다 | — | SHIPTO_CODE·ORDER_TYPE_DETAIL 표시, FCST_TYPE 숨김. Result Detail 시트가 없으면 추가된다 | `SpdMain_ActiveSheetChanged` 3592~3595/3604 / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-050 | 그리드 | Cell Biz 존재 | spdMain 시트를 Pack Biz에서 Cell Biz로 전환한다 | — | spdDetail은 ChangeSheet만 한다(3629) | `SpdMain_ActiveSheetChanged` / `Cell Biz` |
| TC-SSP0026-051 | 초기화 | BodItemPopup을 연다(여는 버튼은 확인 필요) | 팝업이 열리면 목록과 조건을 확인한다 | — | clbDivision 목록, Site 목록, BOD Item 목록이 표시된다 | 팝업 `Form_Load` / `SSP.SSP0026_GET_BOD_ITEM` / `SCM.SCM0001_GET_DIVISION` / `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| TC-SSP0026-052 | 초기화 | ItembyDivisionPopup을 연다 | 팝업이 열리면 목록을 확인한다 | — | clbDivision 목록과 Project 시트 목록이 표시된다 | 팝업 `Form_Load` / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` / `SCM.SCM0001_GET_DIVISION` / `Project` |
| TC-SSP0026-053 | 조회 | BodItemPopup | clbDivision, clbFromSite, clbToSite, txtItemID를 입력하고 btnButtonList 조회를 누른다 | Division 40 | 조건에 맞는 BOD Item이 조회된다 | `btnButtonList_UsrButtonList_Click_Detected` / `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-054 | 조회 | ItembyDivisionPopup | clbDivision, clbScmSite, txtItemID, txtProject를 입력하고 btnButtonList 조회를 누른다 | Division 40 | Item 목록이 조회된다 | `btnButtonList_UsrButtonList_Click_Detected` / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0026-055 | 조회 | 053과 같음 | 데이터가 없는 조건으로 조회한다 | 없는 txtItemID | 0행, 오류 없음 | `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-056 | 이벤트 | 두 팝업 | clbDivision 선택을 바꾼다 | Division 변경 | NowGroupID를 사용하는 후속 처리가 있다. 하위 Site 목록 갱신 여부는 확인 필요 | `clbDivision_SelectedIndexChanged` |
| TC-SSP0026-057 | 이벤트 | 팝업 조회 결과 있음 | 팝업 spdMain 행을 더블클릭한다 | 1행 | 선택값을 호출 화면에 반환하고 팝업을 닫는다(반환 필드는 확인 필요) | `spdMain_CellDoubleClick` / `Project` |
| TC-SSP0026-058 | division | Division 81 | 조회한 뒤 Pack Biz 컬럼을 확인한다 | Division 81 | 메타 컬럼 없이 SHIPTO_CODE와 ORDER_TYPE_DETAIL 2컬럼만 남는다(실제 화면 확인 필요) | `Pack Biz` / grid_effective |
| TC-SSP0026-059 | division | Division 40 | 조회한 뒤 Pack Biz 컬럼을 확인한다 | Division 40 | 16컬럼(DIVISION_ID~MEASURE, SHIPTO_CODE, ORDER_TYPE_DETAIL)이 표시되고 FCST_TYPE은 숨겨진다. Measure 8건 | `Pack Biz` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-060 | division | Division 40, Cell Biz 존재 | 조회한 뒤 Cell Biz 컬럼을 확인한다 | Division 40 | 13컬럼, Measure 10건. BOD_ID, MEASURE_COLOR, SHIP_FROZEN, SITE_DESCRIPTION은 숨겨진다 | `Cell Biz` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` |
| TC-SSP0026-061 | division | Division 81, Cell Biz 존재 | Cell Biz 컬럼을 확인한다 | Division 81 | 메타가 없어 기본 컬럼이 없다(실제 화면 확인 필요) | `Cell Biz` |
| TC-SSP0026-062 | 그리드 | 상세 조회 완료 | Shipment Request Detail 컬럼을 확인한다 | 임의 Division | 35컬럼이 표시되고 MODEL_PIC, MOEL_USER는 숨겨진다. 병합하지 않는다(MergePolicy.None) | `Shipment Request Detail` / InitSpread:386/392 |
| TC-SSP0026-063 | 그리드 | Result 조회 완료 | Shipment Result Detail 컬럼을 확인한다 | — | 12컬럼이 표시되고 SCM_SITE_ID는 숨겨진다 | `Shipment Result Detail` |
| TC-SSP0026-064 | 그리드 | Excel Form 다운로드 완료(TC-023) | 내려받은 양식의 컬럼을 확인한다 | — | DIVISION_ID~FCST_TYPE 10컬럼(Div*, FromSite*, ToSite*, ShipTo*, Model*, Qty*, yyyyMMdd*, Incoterms*, Trans Mode*, FCST Type*) | `Shipment Request Detail Excel` |
| TC-SSP0026-065 | 그리드 | 팝업 조회 완료 | Project 시트 헤더를 확인한다 | — | 하드코딩 헤더 14종(Division, Project Code, Project, SCM Site, Site, Model Code/Material, Model, Type, Nick Name, Class Name, Incoterms, Transport Mode, BOD ID)이 팝업별 정의대로 나온다 | `Project` / InitSpread 189~210 |
| TC-SSP0026-066 | 그리드 | 001과 같음 | spdMain, spdDetail, spdSub의 모든 시트 탭을 확인한다 | — | `Shipment Request Detail_BACKUP` 시트가 생성되지 않는다(메타만 있고 코드 미참조) | `Shipment Request Detail_BACKUP` |
| TC-SSP0026-067 | 그리드 | DAILY 조회 완료 | 헤더를 확인한다 | 토요일·일요일이 포함된 기간 | SAT 헤더는 파랑, SUN 헤더는 빨강이다. COLUMN_NAME에 `B_`가 있는 컬럼은 숨겨지고 SUM 헤더가 있다 | SetSpreadHeaderSpan 531/542 / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-068 | 권한 | 권한 그룹별 사용자 | 저장 버튼 활성 여부를 확인한다 | — | TB_FX_GroupMenuAuth(12행) 값에 따른다(C/R/U/D 값 확인 필요) | TB_FX_GroupMenuAuth / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |
| TC-SSP0026-069 | 권한 | Division 권한이 제한된 사용자 | cboDivision 목록을 확인한다 | — | 권한이 있는 Division만 표시된다(TB_FX_USERGROUPAUTHEXTENTION) | `Form_Load` / `biz:CommonData.CommonDataList`[MyDivision] |
| TC-SSP0026-070 | 초기화 | 정적 분석 확인 | 모든 버튼과 이벤트를 실행하면서 SQL 추적을 켠다 | — | 현행 화면 동작 중에 이 엔드포인트가 호출되지 않는다(진입점 미연결 GetBizTypebyDivision) | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` |
| TC-SSP0026-071 | 초기화 | 070과 같음 | 저장과 업로드를 포함해 모든 동작을 실행하면서 SQL 추적을 켠다 | — | 이 엔드포인트가 호출되지 않는다(BodValidChk_Main/BodValidChk 미연결). 호출되면 분석서를 정정한다 | `SSP.SSP0002_GET_BOD_VALID_CHECK` |
| TC-SSP0026-072 | 저장 | Pack 저장 중 SP 오류(예: BOD 미존재 데이터) | 저장(SaveButton)을 누른다 | 존재하지 않는 BOD 조합 | 오류 메시지를 표시하고 롤백한다. 그리드는 변경 전 상태를 유지한다(메시지 원문 확인 필요) | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |

### 커버리지 점검

| 대상 | 전체 | TC 존재 |
|---|---:|---:|
| 이벤트 핸들러 | 29 | 29 (Form_Load 001·051·052 / btnExcelFormDownload_Click 023 / btnExcelUpload_Click 024·025 / btnMeasure_Click 026 / cboDivision_SelectedIndexChanged 028 / btnColumn_Click 027 / chkSum_CheckedChanged 029 / btnProject_Click 034 / cboBucketType_SelectedIndexChanged 030~032 / clbCustomer_SelectedIndexChanged 038 / clbTeam_SelectedIndexChanged 039 / SpdMain_TopChange 040 / SpdMain_CellDoubleClick 021·022 / SpdDetail_TopChange 041 / BtnSearch_Click 017~020 / SpdMain_ComboSelChange 042 / SpdDetail_ComboSelChange 044 / SpdDetail_CellDoubleClick 047 / SpdDetail_ClipboardPasted 045·046 / SpdMain_ClipboardPasted 043 / BtnItemID_Click 035 / BtnItemID2_Click 036 / BtnRequestor_Click 037 / chkPastPeriod_CheckedChanged 033 / SpdDetail_ActiveSheetChanged 048 / SpdMain_ActiveSheetChanged 049·050 / clbDivision_SelectedIndexChanged 056 / btnButtonList_UsrButtonList_Click_Detected 053·054 / spdMain_CellDoubleClick 057) |
| 엔드포인트 | 19 | 19 (`biz:CommonData.CommonDataList` 001·002·005·042·044·069 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` 008·010·011 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` 009 / `SSP.SSP0026_GET_RESULT_DETAIL` 019 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` 017·021 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` 018·022 / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` 012·072 / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` 013 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` 014 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` 015 / `SSP.SSP0026_GET_SPREAD_TITLE` 004·026 / `DM.DM0003_GET_BUCKET_TYPE_CODE` 003 / `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` 070 / `SSP.SSP0002_GET_BOD_VALID_CHECK` 071 / `SSP.SSP0026_GET_BOD_ITEM` 042·053 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` 023 / `SCM.SCM0001_GET_DIVISION` 051·052 / `SCM.SCM0001_GET_SITE_BY_DIVISION` 051 / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` 052·054) |
| 시트 | 7 | 7 (`Pack Biz` 059 / `Cell Biz` 060 / `Shipment Request Detail` 062 / `Shipment Result Detail` 063 / `Shipment Request Detail Excel` 064 / `Project` 065 / `Shipment Request Detail_BACKUP` 066) |
| Division 변형 | 40 / 그 외 | 058·059·060·061·028 |
| 빈 결과 / 오류 응답 | — | 010·020·055 / 011·015·016·018·072 |
