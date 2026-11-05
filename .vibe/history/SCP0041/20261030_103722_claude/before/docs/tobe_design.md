# SCP0041 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | As-is 컨트롤 | 필수 표기 | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| Division* | cboDivision (UsrCombo) | `*` | Division 콤보 | 변경 이벤트 처리 내용 확인 필요 |
| Plant Site | clbPlantSite (UsrCheckedList) | - | 멀티선택 콤보 | CODE 값 전달 |
| Model | txtItemId (UsrMultiLineEditor) + btnItemId | - | 멀티라인 입력 + 검색 팝업 | |
| Period* | dCalendar (UsrDateRangePicker3) | `*` | 기간 컨트롤 | 기본값 = PERIOD_DEFAULT FROM/TO (적용 대상 확인 필요) |
| Inspection (런타임 DefPackLabel.INSEPECTION_ID) | txtInspection (UsrMultiLineEditor) | - | 멀티라인 입력 | |
| Status | cboStatus (UsrCombo) | - | 콤보 | 원천 확인 필요 |
| Cutoff Date | dCalendarCutoff (UsrDateRangePicker3) | - | 기간 컨트롤 | |

- 시트별로 쓰는 조회조건(예: Inspection/Status/Cutoff Date 가 `Pack Hold Stock` 전용인지)은 SetSelectMenu 원문을 보고 **확인해야** 합니다.
- TB_FX_SearchCondition 에 SCP0041 행이 34건 있습니다(내용은 확인 필요).
- 조회영역 버튼: `Upload`(btnExcelUpload), `Excel Form`(formDown).

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러/경로 | API 후보 (SP) |
|---|---|---|
| 화면 진입 | `Form_Load` > InitControls > GetLookupData | SCM0001_GET_LOOKUP_VALUES |
| 화면 진입 / 탭 전환 | setPeriod (Form_Load, `SpdMain_SheetTabClick` > SetSelectMenu) | CommonDataList code=PERIOD_DEFAULT (UP_FX_GetCommonDataList) |
| 조회 (Osp Stock) | FindButton > FindData_Main | SCP0041_GET_STOCK_OSP |
| 조회 (Pack Hold Stock) | FindButton > FindData_Pack | SCP0041_GET_PACK_HOLD_STOCK |
| 저장 (Pack Hold Stock) | SaveButton > SaveDataPacker → FindData_Pack 재조회 | SCP0041_SAVE_PACKER_HOLD_STOCK → SCP0041_GET_PACK_HOLD_STOCK |
| 편집 | EditButton (iFocusTabIndex == 1) | API 없음 (그리드 편집 모드) |
| 모델 검색 | `BtnItemId_Click` | 추출 API 없음 → 팝업 대상 확인 필요 |
| Division 변경 | `CboDivision_SelectedIndexChanged` | 추출 API 없음 → 확인 필요 |
| 엑셀 업로드 | `btnExcelUpload_Click` | 추출 API 없음 → 확인 필요 (SCM_ADM_EXCEL_COLUMNS 1행) |
| 엑셀 양식 다운로드 | `btnExcelFormDownload_Click` | 추출 API 없음 → 확인 필요 |
| 셀 편집 | `SpdMain_EditChange`, `ActiveSheet_CellChanged` | API 없음 (변경 플래그 처리로 보임 — 확인 필요) |
| (미도달) | SaveData | SCP0040_SAVE_CHARACTERISTIC_CAPA — 이관 제외 후보 |

## 3. division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 (14개 division 공통) | 변형 |
|---|---:|---|
| Osp Stock | 14 | 없음 |
| Pack Hold Stock | 15 | 없음 |

- 메타 선택 컬럼 0, 코드 분기 0건 → division 에 따라 컬럼이 바뀌지 않습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 조회(R): FindButton 오버라이드 존재 | flow.csv |
| 수정(U): SaveButton → SaveDataPacker(UPDATE SCM_DNM_STOCK_LOT_CONTROL) | flow.csv, objects |
| 편집 진입: EditButton 오버라이드(`iFocusTabIndex == 1` 조건) | grid_code.csv:268 |
| 생성(C)/삭제(D): 이 화면 SP 에서 INSERT/DELETE 대상 업무 테이블은 추출되지 않음(INSERT 는 SCM_SYS_LOG_BATCH 로그만) | objects |
| 메뉴 권한 메타: TB_FX_GroupMenuAuth 9행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 | dbmeta (내용 확인 필요) |

## 5. 미확정 사항

1. FindButton 의 시트별 분기 방식(활성 시트만 조회하는지, 둘 다 조회하는지).
2. 엑셀 업로드/양식 다운로드의 대상 시트·저장 SP.
3. `CboDivision_SelectedIndexChanged`, `BtnItemId_Click`(팝업 종류)의 처리 내용.
4. cboStatus 데이터 원천(SCM0001_GET_LOOKUP_VALUES 여부).
5. PERIOD_DEFAULT 기본값 적용 대상(dCalendar / dCalendarCutoff).
6. Inspection 라벨의 런타임 문구(DefPackLabel.INSEPECTION_ID).
7. `SaveData`(SCP0040_SAVE_CHARACTERISTIC_CAPA) 이관 제외 여부.
8. `Pack Hold Stock` 편집 가능 컬럼(메타 CELL_CONTROL_OBJECT_TYPE_CODE 등 원문 필요).
9. 시트 탭별 툴바 버튼 노출(Save/Edit 가 `Pack Hold Stock` 전용인지).
10. `usrButton1`(부모 미지정)의 용도.
