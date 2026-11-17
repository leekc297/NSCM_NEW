# SSP0022 Shipment Request(Electrode) — 업무분석서

> **작성 근거**: AsisFacts Fact Pack SSP0022(endpoints.csv · flow.csv · events.csv · controls.csv · grid_code · grid_rule · grid_effective)와 1차 분석서(analysis.md · web_components.md · tobe_design.md)만 사용했다.
> Fact Pack에 없는 업무 의미·SP 내부 분기 조건은 **확인 필요**로 적었다.
> 주석 처리된 호출 3건은 현행 기능에 넣지 않았다(§8-3).
> 연계 문서: 화면설계서 `screen_design.md` §5 액션 명세, 단위테스트 `unit_test.md` 근거 열. 세 문서는 엔드포인트 이름을 같은 표기로 쓴다.

---

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SSP0022 | Fact Pack §1 |
| 클래스 | `SSP0022_ShipmentRequestElectrode` (current) | Fact Pack §1 |
| 화면명 | Shipment Request(Electrode) (메인 시트명 기준) | grid_code AddSheet |
| 도메인 | SSP (`GSCM.SSP.Forms.UIL\Plan`) | Fact Pack §1 |
| 메뉴 위치·업무 기능 정의 | **확인 필요**. TB_FX_ProgramInfo 2행과 TB_FX_MenuItemInfo 2행이 있다는 것만 확인됐고, 행 내용은 Fact Pack에 없다 | Fact Pack §8 |

### 1-1. 범위에 들어가는 기능 (사실 기준)
1. **출하 PSI 조회 (메인)**: `SSP.SSP0022_GET_SHIPMENT_PSI` 결과를 메인 그리드(spdMain, 시트 `Shipment Request(Electrode)`)에 보여 준다. 날짜 컬럼은 `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`이 동적으로 만든다.
2. **출하요청 상세·재고 상세 조회 (하단)**: btnSearch를 누르면 `SSP.SSP0022_GET_REQUEST_DETAIL`(시트 `Shipment Request Detail`)과 `SSP.SSP0022_GET_STOCK_DETAIL`(시트 `Stock Detail`)을 실행한다.
3. **출하요청 저장**: `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`가 SSP_ANL_SHIP_REQ_EE에 INSERT/UPDATE하고, 이력 SSP_ANL_SHIP_REQ_EE_H와 SCM_SYS_LOG_BATCH에 INSERT한다.
4. **Excel 양식 다운로드 / 업로드 후 재조회**: 양식 다운로드는 `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`(시트 `Shipment Request Detail Excel`)을 쓴다. 업로드 후에는 PSI와 상세를 다시 조회한다.
5. **BOD/품목 정보 조회**: 상세 그리드에서 셀 콤보 변경·더블클릭·붙여넣기를 하면 `SSP.SSP0022_GET_ITEM_POPUP`을 실행한다.
6. **공유 팝업 2종**
   - `SSP0022_BodItemPopup`: Division·Site·BOD 품목을 조회한다.
   - `SSP0022_ShipmentRequestPopup`: 출하요청을 입력하고 저장한다.
   - 본 화면의 어느 핸들러가 팝업을 여는지는 **확인 필요**.
7. **수정 권한 사용자 확인**: EditButton을 누르면 `SSP.SSP0002_GET_USER_INFO_LIST`를 실행한다.

### 1-2. 범위 밖 / 판정 보류
- legacy 사본 `06.UIL\GSCM.SSP.Plan.UIL\SSP0022_ShipmentRequestElectrode.cs`(4463줄)는 분석 대상이 아니다.
- 진입점이 연결되지 않은 유효성 검사 호출은 실제로 실행되는지 **확인 필요**(§8-2).
  - `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` 3건
  - `SSP.SSP0002_GET_BOD_VALID_CHECK` 1건

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드 > 엔드포인트) | 결과 |
|---:|---|---|---|
| S1 | 화면을 연다 | `Form_Load` > InitControls > GetBucketType > `DM.DM0003_GET_BUCKET_TYPE_CODE` / `Form_Load` > CreateSpread > InitSpread > GetSpdTitle > `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | Bucket 콤보가 채워지고, 메인 그리드 날짜 컬럼(3단 헤더)이 만들어진다 |
| S2 | Company를 바꾼다 | `clbCompanyID_SelectedIndexChanged` > `biz:CommonData.CommonDataList`[code=PlantEE]. cboPlanDate 이벤트를 해제(3669)했다가 다시 연결(3673)한다. InitSpread > GetSpdTitle > `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | Plant 목록을 다시 조회하고 그리드를 다시 구성한다 |
| S3 | Plan-date를 바꾼다 | `cboPlanDate_SelectedIndexChanged`가 CODE·FROM_DATE·TO_DATE를 읽는다 > GetSpdTitle > `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 기간을 반영하고 날짜 컬럼을 다시 만든다 |
| S4 | Division을 바꾼다 | `clbDivision_ID_SelectedIndexChanged`가 DIVISION_ID를 읽는다. 엔드포인트 호출은 Fact Pack에 없다 | 화면 반영 내용 **확인 필요** |
| S5 | 조회 버튼(FindButton) | FindButton > FindData_Main > `SSP.SSP0022_GET_SHIPMENT_PSI` (+InitSpread > GetSpdTitle > `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`) | 메인 PSI 그리드가 표시된다 |
| S6 | UOM Type 라디오 / Sum / Bucket을 바꾼다 | `rdButton_Changed`, `chkSum_CheckedChanged`, `cboBucketType_SelectedIndexChanged` → 컬럼 Visible 토글(SetSpreadColumn) | 재조회 없이 표시 컬럼만 바뀐다(§4-3). Bucket 핸들러 본문이 SetSpreadColumn을 호출하는지는 **확인 필요** |
| S7 | Measure 버튼 | `BtnMeasure_Click` > InitSpread > GetSpdTitle > `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 그리드를 다시 구성한다 |
| S8 | 메인 그리드 셀 더블클릭 | `SpdMain_CellDoubleClick`이 GetCheckedListValue(1405~1407)를 호출 > FindData_Main > `SSP.SSP0022_GET_SHIPMENT_PSI` (+3SPAN) | 메인을 다시 조회한다. 더블클릭한 셀 값을 조건으로 쓰는지는 **확인 필요** |
| S9 | 하단 상세 조건 입력 후 btnSearch | `BtnSearch_Click` > FindData_Request_Detail > `SSP.SSP0022_GET_REQUEST_DETAIL` (+3SPAN), FindData_Detail > `SSP.SSP0022_GET_STOCK_DETAIL` | `Shipment Request Detail` / `Stock Detail` 시트가 표시된다 |
| S10 | 행추가(InsertButton) | InsertButton > InsertRow > `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite / PlantByElectordeShipToSite]. 1481~1482 콤보 설정은 `siDetail.IsLock(...) == false`이고 활성 시트가 "Shipment Request Detail"일 때만 한다 | 상세 시트에 새 행이 생기고 FROM_SITE·TO_SITE 셀 콤보가 설정된다 |
| S11 | 상세 셀 콤보 변경 / 더블클릭 / 붙여넣기 | `SpdDetail_ComboSelChange` / `SpdDetail_CellDoubleClick` / `SpdDetail_ClipboardPasted` > FindData_BOD > `SSP.SSP0022_GET_ITEM_POPUP` | 붙여넣기는 조회 결과로 ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY를 채운다(982~992) |
| S12 | 수정(EditButton) | EditButton > GetSSPUserCheck > `SSP.SSP0002_GET_USER_INFO_LIST` | SSP 사용자인지 검사한다. 통과·실패 시 화면 동작은 **확인 필요** |
| S13 | 저장(SaveButton) — 상세 | SaveButton > SaveData_Detail > `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` → FindData_Request_Detail > `SSP.SSP0022_GET_REQUEST_DETAIL` (+3SPAN) | 저장한 뒤 상세를 다시 조회한다 |
| S14 | 저장(SaveButton) — 메인 | SaveButton > SaveData > `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` → FindData_Main > `SSP.SSP0022_GET_SHIPMENT_PSI` | 저장한 뒤 메인을 다시 조회한다. SaveData와 SaveData_Detail 중 어느 쪽을 실행할지 정하는 조건은 **확인 필요** |
| S15 | Excel Form 버튼(formDown) | `btnExcelFormDownload_Click` > FindData_Request_Detail_DownLoad > `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | `Shipment Request Detail Excel` 양식 데이터를 만든다 |
| S16 | Upload 버튼(btnExcelUpload) | `btnExcelUpload_Click` > FindData_Main > `SSP.SSP0022_GET_SHIPMENT_PSI` (+3SPAN), FindData_Request_Detail > `SSP.SSP0022_GET_REQUEST_DETAIL` | 메인과 상세를 다시 조회한다. 업로드 내용을 저장하는 호출은 Fact Pack에 없다 → **확인 필요** |
| S17 | BOD 품목 팝업 사용 | `SSP0022_BodItemPopup`: `Form_Load` > InitControls 순서로 아래를 호출한다<br>· `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite/ToSite]<br>· GetDivision > `SCM.SCM0001_GET_DIVISION`<br>· GetDivisionbyScmSite > `SCM.SCM0001_GET_SITE_BY_DIVISION`<br>· FindData > `SSP.SSP0022_GET_ITEM_POPUP`<br>`btnButtonList_UsrButtonList_Click_Detected` / FindButton을 누르면 `SSP.SSP0022_GET_ITEM_POPUP`을 다시 실행한다 | 팝업 그리드에 품목/BOD가 표시된다. 선택값을 본 화면으로 돌려주는 방식은 **확인 필요** |
| S18 | 출하요청 팝업 사용 | `SSP0022_ShipmentRequestPopup`:<br>· `Form_Load` > InitControls > GetDayRange > `SCP.GET_DATE_RANGE_1MONTH`<br>· `clbDivision_SelectedIndexChanged` > `biz:CommonData.CommonDataList` 4종 + FindData > `SSP.SSP0022_GET_ITEM_POPUP`<br>· `SpdMain_ComboSelChange` > From/To 콤보 + `SSP.SSP0022_GET_ITEM_POPUP`<br>· `btnButtonList_UsrButtonList_Click_Detected` / SaveButton > SaveData > `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` | 팝업 그리드(`Shipment Reqeust(Electrode)` — 추정)에 입력한 내용을 저장한다 |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[진입] Form_Load
  ├─ GetBucketType ─────────────▶ DM.DM0003_GET_BUCKET_TYPE_CODE
  └─ CreateSpread>InitSpread>GetSpdTitle ▶ SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN
        │
[조건 설정] Company(clbCompany_ID) ─▶ biz:CommonData.CommonDataList[PlantEE] + 3SPAN
           Plan-date(cboPlanDate) ─▶ 3SPAN (FROM_DATE/TO_DATE → drpPeriod, Enabled=false)
           Division / Bucket / Plant / Material / UOM Type / Sum / Delegate·Team·Part Leader
        │
[메인 조회] FindButton ─▶ SSP.SSP0022_GET_SHIPMENT_PSI ─▶ spdMain [Shipment Request(Electrode)]
        │      ├─ 표시 토글(재조회 없음): rdButton_Changed / chkSum_CheckedChanged / cboBucketType / chkPastPeriod
        │      └─ SpdMain_CellDoubleClick ─▶ SSP.SSP0022_GET_SHIPMENT_PSI (재조회)
        │
[상세 조회] btnSearch ─▶ SSP.SSP0022_GET_REQUEST_DETAIL ─▶ spdDetail [Shipment Request Detail]
        │             └▶ SSP.SSP0022_GET_STOCK_DETAIL   ─▶ spdDetail [Stock Detail]
        │
[요청 입력] InsertButton ─▶ biz:CommonData.CommonDataList[PlantByElectordeShipFromSite/ToSite]
        │   셀 편집·붙여넣기 ─▶ SSP.SSP0022_GET_ITEM_POPUP (BOD 정보 채움)
        │   (팝업) SSP0022_BodItemPopup / SSP0022_ShipmentRequestPopup — 여는 지점 확인 필요
        │
[수정 권한] EditButton ─▶ SSP.SSP0002_GET_USER_INFO_LIST
        │
[저장] SaveButton ─▶ SSP.SSP0022_SAVE_SHIPMENT_REQUEST
        │   ├─ SaveData_Detail → SSP.SSP0022_GET_REQUEST_DETAIL (재조회)
        │   └─ SaveData        → SSP.SSP0022_GET_SHIPMENT_PSI   (재조회)
        │
[Excel] formDown ─▶ SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN [Shipment Request Detail Excel]
        btnExcelUpload ─▶ SSP.SSP0022_GET_SHIPMENT_PSI + SSP.SSP0022_GET_REQUEST_DETAIL (재조회)
```

---

## 4. 업무 규칙 (사실 근거)

### 4-1. 필수값 (라벨 원문 '*' 기준)
| 영역 | 필수 표시 항목 | 근거 | 비고 |
|---|---|---|---|
| 상단 조회조건 | Company*, Division*, Plan-date*, Period* | props.csv Text (1차 web_components §2-1) | '*'를 검사하는 코드(메시지·차단)는 Fact Pack에 없다 → **확인 필요** |
| `Shipment Request Detail` 시트 | From Site*, To Site*, Model*, Material*, Shipment ETA*, Qty*, Incoterms*, Trans Mode* | 메타 COLUMN_LABEL_NAME | 저장 전 필수 검증 위치 **확인 필요** |
| `Shipment Request Detail Excel` 시트 | Company*, Div*, FromSite*, ToSite*, Material*, yyyyMMdd*, Qty*, Incoterms*, Trans Mode* | 메타 | 업로드 양식 |
| `Shipment Reqeust(Electrode)` 시트(팝업) | Div*, SCM Site*, From Site*, To Site*, Model*, Material*, Shipment Date*, "Qty* ", Incoterms*, "Trans Mode* " | InitSpread:257~285 하드코딩 | 라벨 끝 공백은 원문 그대로 |

### 4-2. 날짜·기간 규칙
1. `cboPlanDate_SelectedIndexChanged`는 선택한 행의 CODE, FROM_DATE, TO_DATE를 읽는다. `Plan_Current_Check`는 Tmp_dtPlanDate.Rows[0]의 CODE, NAME, FROM_DATE, TO_DATE를 읽는다.
2. drpPeriod(Period*)는 **Enabled=false**다. 사용자가 직접 바꿀 수 없다. 값을 Plan-date에서 받는다는 추정은 1차 분석서 기준이며 대입 코드는 **확인 필요**.
3. InitControls:488~491은 `dtShipmentInputPeriod` Rows[0]·[1]의 VALUE, Diff_VALUE를 읽는다. 데이터를 어디서 가져오는지와 업무 의미(입력 가능 기간 등)는 **확인 필요**.
4. 날짜 컬럼은 `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`(SCM_SYS_CALENDAR_M) 결과 행마다 하나씩 만든다(InitSpreadDateColumn:753~799).
   - 컬럼명에 `B_`가 포함되면 숨김 텍스트 컬럼(폭 0)이다.
   - 그 외는 숫자 컬럼이다(폭 100, 우측 정렬, 소수 3자리, 천단위 구분).
   - DAY_CODE가 SAT이면 글자색 Blue, SUN이면 Red다.
5. **Including Past Period**(chkPastPeriod)가 미체크이면, 헤더 2행이 "SUM"이 아니고 날짜가 기준일보다 과거인 컬럼을 숨긴다(SetSpreadColumn:2081). chkPastPeriod는 Visible=false다. 기준일 변수가 무엇인지는 **확인 필요**.
6. 팝업 `SSP0022_ShipmentRequestPopup`은 `SCP.GET_DATE_RANGE_1MONTH`(SCM_SYS_CALENDAR_M)로 기간을 받는다. 반환 범위의 정의는 SQL 원문 **확인 필요**.

### 4-3. 버킷·UOM 표시 규칙 (SetSpreadColumn:1904~2081, rdButton_Changed:1823~1858, InitSpread:628~663)

**UOM Type (라디오 3종)**

| UOM Type | BOH 컬럼 표시 | 날짜 컬럼 Tag 접두어 |
|---|---|---|
| rdButton1 "UOM" (기본 Checked) | TOT/JR/PC_BOH_QTY 표시, _CELL·_PCM 숨김 | X_ 표시, Y_·Z_ 숨김 |
| rdButton2 "Cell" | TOT/JR/PC_BOH_QTY_CELL 표시, 나머지 숨김 | Y_ 표시, X_·Z_ 숨김 |
| rdButton3 "Pancake m" | TOT/JR/PC_BOH_QTY_PCM 표시, 나머지 숨김 | Z_ 표시, X_·Y_ 숨김 |

**Bucket (cboBucketType.ControlValues)**

| Bucket | ?_D_ | ?_W_ | ?_M_ |
|---|---|---|---|
| DAILY | 표시 | 1917에서 표시 → 1922에서 chkSum.Checked로 다시 설정. 최종값 **확인 필요** | chkSum.Checked |
| WEEKLY | 숨김 | 표시 | chkSum.Checked |
| MONTHLY | 숨김 | 숨김 | 표시 |

(`?`는 UOM Type에 따라 X/Y/Z)

### 4-4. 저장·입력 규칙
1. InsertRow:1481 — `siDetail.IsLock(...) == false`이고 활성 시트가 "Shipment Request Detail"일 때만 FROM_SITE·TO_SITE 셀 콤보(PlantByElectordeShipFromSite/ToSite)를 설정한다.
2. 저장 SP `SSP0022_SAVE_SHIPMENT_REQUEST`의 처리 순서(참조 객체 순)는 다음과 같다.
   1. 임시테이블 #TBLDYNAMIC_SSP0022_SHPIMENTREQ에 담는다. SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL로 배열 문자열을 분해한다.
   2. SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL을 참조하고, FN_GET_SSP_ETD_DATE로 ETD를 산출한다.
   3. SSP_ANL_SHIP_REQ_EE를 UPDATE(별칭 A)하거나 INSERT한다.
   4. 이력 SSP_ANL_SHIP_REQ_EE_H에 INSERT한다.
   5. PR_SCM_SYS_LOG_BATCH를 거쳐 SCM_SYS_LOG_BATCH에 INSERT한다.

   UPDATE와 INSERT를 가르는 키·조건은 SP 원문 **확인 필요**.
3. 저장 후 재조회: SaveData_Detail → `SSP.SSP0022_GET_REQUEST_DETAIL`, SaveData → `SSP.SSP0022_GET_SHIPMENT_PSI`.
4. 붙여넣기(`SpdDetail_ClipboardPasted`)는 BOD 조회 결과 9개 필드를 자동으로 채운다(§2 S11).

### 4-5. SP 분기 조건
- `SSP0022_GET_SHIPMENT_PSI`가 쓰는 객체는 아래와 같다.
  - 계획: SSP_ANL_SHIP_PLAN_EE
  - BOH: SSP_ANL_BOH_CUTOFF_EE
  - 요청: SSP_ANL_SHIP_REQ_EE
  - 확정: SSP_ANL_SHIP_CONFIRM, FN_GET_SSP_ANL_SHIP_FROZEN
  - 실적: SSP_DNM_SHIP_RESULT_OWMS_V
  - 운송 중: SSP_DNM_FP_MRP_INTRANSIT_SN
  - 담당 모델: SSP_MST_MODEL_USER_EE, SSP_MST_DELEGATE
  - 임시테이블: #TMP_* 다수와 동적 SQL(DYNAMIC@)
  - 구 로직 임시테이블: _OLD / _0LD 계열
- 위 객체가 어떤 파라미터 조건으로 분기하는지(예: Delegate Model / Team Leader / Part Leader 체크가 SP 인자로 연결되는지)는 Fact Pack에 없다 → **확인 필요**.
- `SSP0022_GET_REQUEST_DETAIL`, `SSP0022_GET_STOCK_DETAIL`은 동적 SQL이라 분기와 참조 테이블이 추출되지 않았다 → **확인 필요**.

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP / SQL | 읽기(SELECT/REF) | 쓰기 | 호출 지점(파일:줄) | 화면설계서 §5 액션 |
|---:|---|---|---|---|---|---|
| 1 | `biz:CommonData.CommonDataList` | 비즈 공통 UP_FX_GetCommonDataList 계열. code: PlantEE · PlantByElectordeShipFromSite · PlantByElectordeShipToSite · Incoterms · TransportMode · LookupCommon | PlantEE→SCM_MST_SITE / PlantByElectorde*·TransportMode→SCM_ADM_LOOKUP_MASTER_DETAIL / Incoterms→SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD_V(_SCP 분기) / LookupCommon→SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | main 1476·1477·3664 / BodItemPopup 173·174 / ShipmentRequestPopup 943·945·1240·1242·1246·1247 (필드 초기화 43·44·46·47·49는 진입점 미연결) | A03, A06, A10, A17, A19, A20 |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | SCM_ADM_LOOKUP_MASTER_DETAIL | — | main GetBucketType:2096 | A01 |
| 3 | `SSP.SSP0022_GET_SHIPMENT_PSI` | `SSP0022_GET_SHIPMENT_PSI` | SSP_ANL_SHIP_PLAN_EE, SSP_ANL_BOH_CUTOFF_EE, SSP_ANL_SHIP_REQ_EE, SSP_ANL_SHIP_CONFIRM, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_DNM_FP_MRP_INTRANSIT_SN, SSP_MST_SHIP_MASTER_EE, SSP_MST_MODEL_USER_EE, SSP_MST_DELEGATE, SSP_MST_SITE_ITEM_EE_V, SCP_MST_FINAL_ITEM, SCP_MST_BOD_N_V, SCM_MST_SHEET_MEASURE, SCM_MST_TITLESET_USER, SCM_SYS_CALENDAR_M, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE / FN_GET_LOOKUP_VALUE, FN_GET_SSP_ANL_SHIP_FROZEN, FN_GET_SSP_SITE_INFO, FN_GET_SSP_ETA_DATE, UF_FX_STRING_SPLIT, STRING_SPLIT | #임시테이블만(#TMP_RESULT_TABLE 등). 영구 테이블 쓰기 없음 | main FindData_Main:2185 | A04, A08, A14, A16 |
| 4 | `SSP.SSP0022_GET_REQUEST_DETAIL` | `SSP0022_GET_REQUEST_DETAIL` | 동적 SQL(DYNAMIC@) — **확인 필요** | 확인 필요 | main FindData_Request_Detail:2339 | A11, A14, A16 |
| 5 | `SSP.SSP0022_GET_STOCK_DETAIL` | `SSP0022_GET_STOCK_DETAIL` | 동적 SQL(DYNAMIC@) — **확인 필요** | 확인 필요 | main FindData_Detail:2484 | A11 |
| 6 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` | `SSP0022_SAVE_SHIPMENT_REQUEST` (+EXEC PR_SCM_SYS_LOG_BATCH) | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_REQ_EE, SCM_SYS_CALENDAR_M / FN_GET_SSP_ETD_DATE, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | **INSERT/UPDATE SSP_ANL_SHIP_REQ_EE**, **INSERT SSP_ANL_SHIP_REQ_EE_H**, **INSERT SCM_SYS_LOG_BATCH** | main SaveData_Detail:2671, SaveData:2863 / ShipmentRequestPopup SaveData:539 | A14, A21 |
| 7 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | `SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_EE, SCP_MST_BOD_N_V, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M / FN_GET_SSP_ETA_DATE, STRING_SPLIT | — | main FindData_Request_Detail_DownLoad:3043 | A15 |
| 8 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | `SSP0022_GET_SHEET_CALENDAR_3SPAN` | SCM_SYS_CALENDAR_M | — | main GetSpdTitle:3869 (진입 경로 9개) | A01, A02, A03, A04, A07, A08, A11, A14, A16 |
| 9 | `SSP.SSP0022_GET_ITEM_POPUP` | `SSP0022_GET_ITEM_POPUP` | SCM_MST_SITE, SCP_MST_BOD_N_V, SCM_SYS_CALENDAR_M, SCP_MST_BOD_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V / STRING_SPLIT | — | main FindData_BOD:3907 / BodItemPopup FindData:258 / ShipmentRequestPopup FindData:362 | A12, A17, A18, A19, A20 |
| 10 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` | `SSP0022_GET_BOD_ITEM_VALID_CHECK` | SCP_MST_BOD_ITEM, SCP_MST_BOD_N_V, SCM_ADM_LOOKUP_MASTER_DETAIL | — | main BodItemValidChk_main:4094, BodItemValidChk:4143 / ShipmentRequestPopup BodItemValidChk:770 — **모두 진입점 미연결** | A22 |
| 11 | `SSP.SSP0002_GET_USER_INFO_LIST` | `SSP0002_GET_USER_INFO_LIST` | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — | main GetSSPUserCheck:4448 | A13 |
| 12 | `SCM.SCM0001_GET_DIVISION` | `SCM0001_GET_DIVISION` | SCM_MST_DIVISION | — | BodItemPopup GetDivision:395 | A17 |
| 13 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | `SCM0001_GET_SITE_BY_DIVISION` | SCM_MST_SITE (REF:VALUE, REF:NODES — XML 파싱 흔적) | — | BodItemPopup GetDivisionbyScmSite:409 | A17 |
| 14 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | `SSP0002_GET_BOD_VALID_CHECK` | SCP_MST_BOD_N_V | — | ShipmentRequestPopup BodValidChk:663 — **진입점 미연결**. main 4003 호출은 주석 처리됨 | A22 |
| 15 | `SCP.GET_DATE_RANGE_1MONTH` | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql (SP 아님) | SCM_SYS_CALENDAR_M | — | ShipmentRequestPopup GetDayRange:1225 | A19 |

- **영구 테이블에 쓰는 엔드포인트는 `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` 하나다.** 나머지 14종은 읽기 전용이다. 단 #4·#5는 동적 SQL이라 쓰기 여부 **확인 필요**.
- SP 13종: `DM0003_GET_BUCKET_TYPE_CODE`, `SSP0022_GET_SHIPMENT_PSI`, `SSP0022_GET_REQUEST_DETAIL`, `SSP0022_GET_STOCK_DETAIL`, `SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`, `SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP0022_GET_ITEM_POPUP`, `SSP0022_GET_BOD_ITEM_VALID_CHECK`, `SSP0002_GET_USER_INFO_LIST`, `SCM0001_GET_DIVISION`, `SCM0001_GET_SITE_BY_DIVISION`, `SSP0002_GET_BOD_VALID_CHECK`.
- SP·SQL 원문에 MSSQL 전용 요소(STRING_SPLIT, #임시테이블)가 있다. Oracle 전환 대상이다(화면설계서 §8).

---

## 6. Division·권한별 변형

### 6-1. Division
- 메타 규칙을 division 14종으로 펼쳤다: 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC.
- **모든 시트의 컬럼 수가 14종 모두 같다.**

| 시트 | 메타 (필수+기본/선택) | 최종 표시 (`?` = 런타임 분기) |
|---|---|---|
| Shipment Request Detail | 16/0 | 19 (?9) |
| Shipment Request Detail Excel | 9/0 | 12 (?9) |
| Shipment Request(Electrode) | 28/0 (+ MEASURE 10/0) | 22 (?9) |
| Stock Detail | 28/0 | 31 (?9) |
| Project | 하드코딩 | 8 |
| Shipment Reqeust(Electrode) | 하드코딩 | 26 |

- division 변수를 비교하는 코드 분기는 검출되지 않았다. 판단불가 1,890건은 모두 런타임 화면 컨트롤 값(라디오·Bucket·체크박스)에 따른 분기다.
- 결론: Grid 변형 축은 division이 아니라 **UOM Type · Bucket · Sum · Including Past Period**다.
- SP 안에서 division에 따라 데이터가 달라지는지는 **확인 필요**.
  - 예: PlantEE 코드와 테이블명 접미사 _EE가 Electrode 전용 데이터를 뜻하는지.

### 6-2. 권한
| 사실 | 근거 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 있음. 그룹별 C/R/U/D 값은 **확인 필요** | Fact Pack §8 |
| 프레임워크 버튼 FindButton / InsertButton / EditButton / SaveButton을 오버라이드한다 | flow.csv |
| EditButton을 누르면 `SSP.SSP0002_GET_USER_INFO_LIST`로 SSP 사용자인지 검사한다. TB_FX_USERGROUPAUTHEXTENTION 등을 참조한다 | GetSSPUserCheck:4448 |
| SetChangeControl이 GROUP_ID, USER_ID를 `UserInfoContext.Current.NowGroupID` 기준으로 필터한다. GetSSPInnerTable 8회가 CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID를 읽는다 | SetChangeControl:379~421 |
| 저장 SP는 SSP_MST_MODEL_USER_EE, SSP_MST_DELEGATE를 읽지 않는다. 담당자 필터는 PSI 조회 SP에만 있다 | 엔드포인트 객체 목록 |
| `FP_Log2`가 InitControls:444·453에서 LOGTYPE, NOTE, USER_ID를 기록한다 | Fact Pack §4-2 |

---

## 7. 외부 인터페이스 (사실에 있는 것만)

| 대상 | 사실 | 비고 |
|---|---|---|
| oWMS 출하 실적 | `SSP.SSP0022_GET_SHIPMENT_PSI`가 SSP_DNM_SHIP_RESULT_OWMS_V를 SELECT한다 | 뷰 원천·동기화 주기 **확인 필요** |
| FP MRP 운송 중(In-transit) | SSP_DNM_FP_MRP_INTRANSIT_SN을 SELECT한다 | **확인 필요** |
| GMES / iWMS / oWMS / QMS 재고·Hold | `Stock Detail` 시트 컬럼 GMES_QTY_*, IWMS_QTY_*, OWMS_QTY_*, MES/QMS/IWMS/OWMS_HOLD_YN, PACKAGE_TYPE_CODE("Package Type (oWMS)") | `SSP0022_GET_STOCK_DETAIL`이 동적 SQL이라 원천 테이블 **확인 필요** |
| 배치 로그 | 저장할 때 PR_SCM_SYS_LOG_BATCH → SCM_SYS_LOG_BATCH | 내부 로그 |

---

## 8. 미확정·확인 필요

### 8-1. 기능·흐름
1. 본 화면의 어느 핸들러가 두 팝업을 여는지. 후보는 btnItemId_Click / BtnItemID2_Click / BtnRequestor_Click / SpdDetail_CellDoubleClick이지만 호출 사실은 없다.
2. SaveButton이 SaveData와 SaveData_Detail 중 무엇을 실행할지 정하는 조건.
3. Upload(btnExcelUpload) 시 파일 내용을 저장하는 경로. Fact Pack에는 재조회 호출만 있다.
4. `clbDivision_ID_SelectedIndexChanged`, `cboBucketType_SelectedIndexChanged`, `chkPastPeriod_CheckedChanged`/`_1`, `SpdMain_Change`, `SpdDetail_EditChange` 등 엔드포인트가 없는 핸들러의 본문 동작.
5. `SpdDetail_ActiveSheetChanged`가 같은 이벤트에 2번 등록(831, 834)되어 있다. 1회 이벤트에 2번 실행되는지 확인해야 한다.
6. `chkPastPeriod`와 `spdMain` CellClick에 핸들러가 각각 2개씩 등록되어 있다. 두 핸들러의 실행 순서와 중복 동작을 확인해야 한다.
7. dtShipmentInputPeriod의 출처와 VALUE / Diff_VALUE의 업무 의미.
8. Delegate Model / Team Leader / Part Leader / My Model 체크가 SP 인자와 어떻게 연결되는지.

### 8-2. 진입점 미연결 호출
아래 호출은 현행으로 실행되는지 확인해야 한다.
- `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK`: main 4094·4143, 팝업 770
- `SSP.SSP0002_GET_BOD_VALID_CHECK`: 팝업 663
- ShipmentRequestPopup 필드 초기화 `biz:CommonData.CommonDataList` 5건: dtFcstType, dtOperationGroup, dtIncoterms, dtTransMode, dtBaseDay

### 8-3. 주석 처리됨 (현행 기능 아님, 집계 제외)
| 파일 | 줄 | 값 |
|---|---:|---|
| main cs | 4003 | SSP.SSP0002_GET_BOD_VALID_CHECK (같은 엔드포인트의 팝업 663 호출만 활성) |
| BodItemPopup.cs | 396 | DM.Get_Division |
| ShipmentRequestPopup.cs | 1226 | SCP.SCM0001_GET_SCP_DAY_PERIOD |

### 8-4. DB·메타
1. `SSP0022_GET_REQUEST_DETAIL` / `SSP0022_GET_STOCK_DETAIL`의 동적 SQL 원문과 참조 테이블.
2. TB_FX_SearchCondition 141행, SCM_MST_TITLESET_USER 4행, SCM_ADM_EXCEL_COLUMNS 1행, SCM_ADM_LOOKUP_MASTER_DETAIL 3행, TB_FX_GroupMenuAuth 13행의 내용.
3. 프레임워크 메타 소비 표에서 `SaveData`가 PersonalSettingPopup.SaveData로 매칭되었다. 이름 충돌로 생긴 오매칭인지 확인해야 한다.
