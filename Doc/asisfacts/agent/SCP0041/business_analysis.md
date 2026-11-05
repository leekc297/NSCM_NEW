# SCP0041 업무분석서 (As-is: `SCP0041_StockOSP`, 폼 Text `"Plant Qty"`)

> 이 문서는 AsisFacts 정적 추출 Fact Pack과 1차 분석서(analysis / web_components / tobe_design)만 근거로 작성했습니다. Fact Pack에 없는 업무 의미는 지어내지 않고 **확인 필요**로 표기했습니다.
> 함께 보는 문서: 화면설계서(screen_design.md) §5 액션 명세, 단위테스트(unit_test.md) 근거 열. 세 문서는 엔드포인트 이름을 똑같이 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0041 / `SCP0041_StockOSP` | 파일 구성 |
| 폼 표시명 | `"Plant Qty"` | props.csv Designer:765 |
| 도메인 | SCP (`GSCM.SCP.Forms.UIL\Master`) | 파일 경로 |
| 다루는 데이터 | ① OSP 재고(`Osp Stock` 시트, 원천 `SCM_DNM_STOCK_OSP`) ② Pack Hold 재고(`Pack Hold Stock` 시트, 원천 `SCM_DNM_STOCK_LOT_CONTROL`) | endpoints.csv objects |
| 범위(현행 기능) | 조회조건 초기화, 시트별 조회, `Pack Hold Stock` 저장(UPDATE) 후 재조회, 시트 탭 전환, 모델 검색 팝업, 엑셀 업로드·양식 다운로드 버튼 | flow.csv, events.csv |
| 범위 밖(미도달) | `SaveData` → `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`. 어떤 진입점에도 연결되지 않습니다. 현행 기능으로 보지 않으며, TO-BE로 옮길지는 **확인 필요**입니다 | flow.csv unreached |
| 업무상 목적 문구(OSP 의미, Hold 사유 등) | Fact Pack에 없음 → **확인 필요** | - |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` > InitControls > GetLookupData → `SCM.SCM0001_GET_LOOKUP_VALUES` 호출 / InitControls > setPeriod → `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] 호출 / InitSpread에서 시트 0 활성화 | 룩업 값 로드(어느 컨트롤에 바인딩되는지는 **확인 필요**). 기간 기본값은 결과 1행의 `FROM_VALUE`·`TO_VALUE`로 설정. 처음 활성 시트는 `Osp Stock` | flow.csv, meta_reads.csv, grid_code.csv InitSpread:195~196 |
| S2 | 시트 탭 클릭 | `SpdMain_SheetTabClick` > SetSelectMenu > setPeriod → `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | 기간 기본값을 다시 설정. 조회조건 표시가 바뀌는지는 **확인 필요** | flow.csv |
| S3 | 모델 버튼(btnItemId) 클릭 | `BtnItemId_Click` | `txtItemId.Text = sItemId` (팝업 종류는 **확인 필요**) | props.csv :882 |
| S4 | Division 변경 | `CboDivision_SelectedIndexChanged` | 엔드포인트가 추출되지 않음. 처리 내용 **확인 필요** | events.csv |
| S5 | 조회(공통 툴바 Find) | FindButton > FindData_Main → `SCP.SCP0041_GET_STOCK_OSP` / FindButton > FindData_Pack → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 해당 시트 그리드에 결과 표시. 활성 시트에 따라 한쪽만 호출하는지 둘 다 호출하는지는 **확인 필요** | flow.csv |
| S6 | 편집(공통 툴바 Edit) | EditButton: `iFocusTabIndex == 1` ⟫ spdMain·fps 이름 일치일 때만 GetSheetInfo | 편집 모드 진입(Pack Hold Stock 대상으로 추정되나 **확인 필요**) | grid_code.csv EditButton:268 |
| S7 | 셀 수정 | `SpdMain_EditChange`, `ActiveSheet_CellChanged` | 엔드포인트 없음. 변경 표시 등 처리 내용 **확인 필요** | events.csv |
| S8 | 저장(공통 툴바 Save) | SaveButton > SaveDataPacker → `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` → FindData_Pack → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `SCM_DNM_STOCK_LOT_CONTROL` UPDATE, `SCM_SYS_LOG_BATCH` 로그 INSERT 후 `Pack Hold Stock` 재조회 | flow.csv, endpoints.csv |
| S9 | Upload 버튼 클릭 | `btnExcelUpload_Click` | 엔드포인트가 추출되지 않음. 대상 시트·저장 SP **확인 필요** (`SCM_ADM_EXCEL_COLUMNS` 1행 존재) | events.csv, dbmeta |
| S10 | Excel Form 버튼 클릭 | `btnExcelFormDownload_Click` | 엔드포인트가 추출되지 않음. 양식 내용 **확인 필요** | events.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입]
  └─ Form_Load
       ├─ InitControls > GetLookupData ──▶ SCM.SCM0001_GET_LOOKUP_VALUES
       ├─ InitControls > setPeriod ──────▶ biz:CommonData.CommonDataList [PERIOD_DEFAULT] → FROM_VALUE/TO_VALUE
       └─ CreateSpread(AddSheet: Osp Stock, Pack Hold Stock) → InitSpread(활성 시트 0 = Osp Stock)
            └─ SetSpreadInit → SetSheetHeaderColumn(메타 SCM_MST_SHEET_COLUMNS)
[조회조건 입력]  Division* · Plant Site · Model(+btnItemId) · Period* · Inspection · Status · Cutoff Date
  ├─ (탭 전환) SpdMain_SheetTabClick > SetSelectMenu > setPeriod ──▶ biz:CommonData.CommonDataList
  ├─ (모델 검색) BtnItemId_Click → txtItemId.Text
  └─ (Division 변경) CboDivision_SelectedIndexChanged → 처리 확인 필요
[조회] FindButton
  ├─ FindData_Main ──▶ SCP.SCP0041_GET_STOCK_OSP ──▶ Osp Stock 시트
  └─ FindData_Pack ──▶ SCP.SCP0041_GET_PACK_HOLD_STOCK ──▶ Pack Hold Stock 시트
     (둘 중 하나만인지, 둘 다인지는 확인 필요)
[편집] EditButton (iFocusTabIndex == 1) → SpdMain_EditChange / ActiveSheet_CellChanged
[저장] SaveButton > SaveDataPacker ──▶ SCP.SCP0041_SAVE_PACKER_HOLD_STOCK
       └─ FindData_Pack ──▶ SCP.SCP0041_GET_PACK_HOLD_STOCK (재조회)
[미도달] SaveData ──▶ SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA (진입점 없음 → 현행 흐름 아님)
```

## 4. 업무 규칙 (Fact Pack에 있는 사실만)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 필수 조회조건 표기: `Division*`, `Period*` (라벨 끝 `*`) | props.csv :519, :605 | 실제 필수 검증 코드·메시지는 **확인 필요** |
| R2 | Plant Site는 체크 목록 값을 `CODE` 기준으로 모아 전달 (`GetCheckedListValue`) | 메타 소비 메서드: SetChangedControl:520, FindData_Main:639/640, FindData_Pack:712/713/718 | FindData_Pack은 3곳(712/713/718)에서 사용. 718의 대상 컨트롤은 **확인 필요** |
| R3 | 기간 기본값 = `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] 결과 1행의 `FROM_VALUE`·`TO_VALUE` | meta_reads.csv setPeriod:558/559 | 적용 대상(dCalendar / dCalendarCutoff)은 **확인 필요**. 공통 SP `UP_FX_GetCommonDataList`가 `SCM_SYS_CALENDAR_M`, `FN_MULTY_TIME`을 참조 |
| R4 | 기간 기본값은 화면 진입 때와 시트 탭 전환 때 모두 다시 설정 | flow.csv (Form_Load, SpdMain_SheetTabClick 두 경로) | |
| R5 | 시트 초기화 분기: `sheetName.Equals("Osp Stock")`이면 시트 0, 아니면 시트 1을 ChangeSheet/InitSheet 한 뒤 메타로 헤더 생성 | grid_code.csv SetSpreadInit:203~211 | |
| R6 | 처음 활성 시트 = 0 (`Osp Stock`) | grid_code.csv InitSpread:195~196 | |
| R7 | 편집 진입 조건: `iFocusTabIndex == 1` ⟫ `spdMain != null` ⟫ `this.fps != null` ⟫ `fps.Name.Equals(spdMain.Name)` | grid_code.csv EditButton:268 | 인덱스 1의 의미(시트/탭)는 **확인 필요** |
| R8 | 저장 후 `Pack Hold Stock` 재조회 (SaveDataPacker > FindData_Pack) | flow.csv | |
| R9 | 저장 SP는 배열 분해 함수 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL`로 여러 행을 받아 `SCM_DNM_STOCK_LOT_CONTROL`을 UPDATE하고, `PR_SCM_SYS_LOG_BATCH`로 `SCM_SYS_LOG_BATCH`에 로그를 INSERT | endpoints.csv | 갱신 컬럼·키·검증 분기는 SP 원문 **확인 필요** |
| R10 | 조회 SP는 `STRING_SPLIT`로 다중값 조건을 분해하고, 모델 Nick Name은 `FN_GET_ITEM_NICKNAME`으로 구함 (Pack Hold는 사용자명 `FN_GET_USER_NAME`도 사용) | endpoints.csv | 분해 대상 파라미터는 **확인 필요** |
| R11 | 날짜·버킷 규칙(주/월 버킷 등) | Fact Pack에 없음 | **확인 필요** |
| R12 | SP 내부 IF 분기 조건 | Fact Pack에 없음(객체 참조만 추출됨) | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 위치 | 읽기(SELECT/REF) | 쓰기 | 현행 여부 |
|---:|---|---|---|---|---|---|
| D1 | `SCM.SCM0001_GET_LOOKUP_VALUES` | `SCM0001_GET_LOOKUP_VALUES` | GetLookupData:165 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL | - | 현행 |
| D2 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | (Biz 공통) UP_FX_GetCommonDataList 코드분기 | setPeriod:549 (Form_Load, SpdMain_SheetTabClick) | SCM_SYS_CALENDAR_M, FN_MULTY_TIME | - | 현행 |
| D3 | `SCP.SCP0041_GET_STOCK_OSP` | `SCP0041_GET_STOCK_OSP` | FindData_Main:662 (FindButton) | SCM_DNM_STOCK_OSP, SCM_MST_SITE, SCM_MST_ITEM_SN, FN_GET_ITEM_NICKNAME, STRING_SPLIT | - | 현행 |
| D4 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `SCP0041_GET_PACK_HOLD_STOCK` | FindData_Pack:740 (FindButton, SaveButton 후 재조회) | SCM_DNM_STOCK_LOT_CONTROL, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, FN_GET_ITEM_NICKNAME, FN_GET_USER_NAME, STRING_SPLIT | - | 현행 |
| D5 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | `SCP0041_SAVE_PACKER_HOLD_STOCK` | SaveDataPacker:469 (SaveButton) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | UPDATE SCM_DNM_STOCK_LOT_CONTROL / INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH) | 현행 |
| D6 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SaveData:354 (**진입점 미연결**) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | MERGE SCP_MST_CHAR_CAPA / INSERT SCP_MST_CHAR_CAPA_H, SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_CHARACTERISTIC_HIST) | **미도달 — 현행 아님** |

## 6. Division·권한별 변형

| 항목 | 사실 | 근거 |
|---|---|---|
| Grid 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 `Osp Stock` 14컬럼, `Pack Hold Stock` 15컬럼으로 같음. 선택 컬럼 0, 코드 분기 0건 | grid_effective.csv, Fact Pack §10·§12 |
| 코드 내 division 분기 | 추출 0건 | Fact Pack §12 |
| Division 변경 시 처리 | `CboDivision_SelectedIndexChanged` 내용 **확인 필요** | events.csv |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 9행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 (행 내용 **확인 필요**) | dbmeta |
| C/R/U/D | R: FindButton / U: SaveButton(UPDATE SCM_DNM_STOCK_LOT_CONTROL) / 편집 진입: EditButton / C·D: 업무 테이블 INSERT·DELETE 추출 없음(INSERT는 로그 SCM_SYS_LOG_BATCH뿐) | flow.csv, endpoints.csv |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 연계(IF/RFC/파일 전송)는 없습니다.
- 엑셀 업로드·양식 다운로드(`btnExcelUpload_Click`, `btnExcelFormDownload_Click`)는 사용자 파일 입출력이며, 서버 처리 경로는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| U1 | FindButton이 활성 시트에 따라 `SCP.SCP0041_GET_STOCK_OSP`·`SCP.SCP0041_GET_PACK_HOLD_STOCK` 중 하나만 부르는지, 둘 다 부르는지 | flow.csv 두 경로 |
| U2 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`(`SCP0040_SAVE_CHARACTERISTIC_CAPA`, SaveData:354)를 TO-BE로 옮기지 않아도 되는지 | flow.csv unreached |
| U3 | 엑셀 업로드/양식 다운로드의 대상 시트·SP와 `SCM_ADM_EXCEL_COLUMNS` 1행의 관계 | events.csv, dbmeta |
| U4 | `CboDivision_SelectedIndexChanged` 처리(Plant Site 재조회 여부 등) | events.csv |
| U5 | `SCM.SCM0001_GET_LOOKUP_VALUES` 결과를 받는 컨트롤(cboStatus 여부) | GetLookupData:165 |
| U6 | PERIOD_DEFAULT 기본값 적용 대상(dCalendar / dCalendarCutoff) | meta_reads.csv |
| U7 | SetSelectMenu에서 시트별 조회조건 표시를 바꾸는지 | flow.csv |
| U8 | 저장 SP의 갱신 컬럼·키·검증 메시지 | endpoints.csv(객체만) |
| U9 | Inspection 라벨의 런타임 문구(`DefPackLabel.INSEPECTION_ID`) | props.csv InitControls:156 |
| U10 | TB_FX_SearchCondition 34행, TB_FX_GroupMenuAuth 9행의 내용 | dbmeta |
| U11 | TO-BE Oracle 전환 때 `STRING_SPLIT`(MSSQL 함수) 대체 방식 | endpoints.csv REF:STRING_SPLIT |
