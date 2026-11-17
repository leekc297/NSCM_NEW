=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SSP0022 Shipment Request(Electrode) — 화면설계서

> **작성 근거**: Fact Pack SSP0022(controls.csv · events.csv · flow.csv · grid_*)와 1차 분석서(web_components.md의 props.csv 인용분)만 사용했다.
> props.csv 발췌가 잘려 Fact Pack에서 얻지 못한 값은 **확인 필요**로 적었다.
> 연계 문서: 업무분석서 `business_analysis.md` §5 데이터 흐름. 단위테스트 `unit_test.md`는 §3 컨트롤명을 절차 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0022 |
| 화면명 | Shipment Request(Electrode) |
| As-is 클래스 | `SSP0022_ShipmentRequestElectrode` (Designer 2286줄, cs 4792줄) |
| 공유 팝업 | `SSP0022_BodItemPopup`, `SSP0022_ShipmentRequestPopup` (`GSCM.SSP.Plan.UIL\Popup`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행 내용 미수록) |
| 화면 유형 | 상단 조회조건 + 분할(메인 PSI 그리드 / 하단 상세 조건·상세 그리드) |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SSP0022_ShipmentRequestElectrode (this)
├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, Size(1689,75), UsrPanelType=HidePanel
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Top, Size(1689,72)  (layoutControlGroup2 Size(1689,78))
│        ├─ 조회조건: clbCompany_ID, clbDivision_ID, cboPlanDate, drpPeriod, cboBucketType,
│        │            clbPlantSite, txtItemId, btnItemId, txtModelId, btnModelId, textNickName,
│        │            clbCellType, lblUOMType, rdButton1, rdButton2, rdButton3, chkSum,
│        │            chkPastPeriod, btnMeasure, chkDelegateModel, chkTeamLeader, chkPartLeader, chkMyModel
│        └─ 버튼:     formDown("Excel Form"), btnExcelUpload("Upload")
└─ splitContainer1 [SplitContainer]  Orientation=확인 필요 · SplitterDistance=확인 필요 · Size=확인 필요
    ├─ Panel1
    │   └─ spdMain [FpSpread] → spdMain_Sheet1 / AddSheet "Shipment Request(Electrode)"
    └─ Panel2
        ├─ usrLayoutControl3 [UsrLayoutControl] (하단 상세 조회조건)
        │    └─ btnRequestor, drpPeriod2, txtModelId2, txtRequestor, textNickName2,
        │       btnSearch, txtItemld2, btnItemID2, txtLotID
        ├─ spdDetail [FpSpread] → spdDetail_Sheet1 / AddSheet "Stock Detail"(탭0), "Shipment Request Detail"(탭1)
        └─ spdSub [FpSpread] → spdSub_Sheet1 / AddSheet "Shipment Request Detail Excel"
```

- **분할 비율(%)은 계산할 수 없다.** splitContainer1의 Orientation·SplitterDistance·Size가 props.csv 발췌에서 잘렸기 때문이다. 원문은 `SSP0022_ShipmentRequestElectrode.Designer.cs`의 splitContainer1 속성 블록에서 확인해야 한다.
  - Orientation=Horizontal(기본)이면 Panel1이 위, Panel2가 아래다.
  - Vertical이면 Panel1이 왼쪽, Panel2가 오른쪽이다.
  - 비율 = SplitterDistance ÷ (해당 축 Size) × 100.
- Panel2 안에서 usrLayoutControl3 · spdDetail · spdSub의 Dock 배치는 **확인 필요**.
- `SpdDetail_SheetTabClick`은 TabIndex 2를 "Shipment Request Detail Excel"로 다룬다. 그런데 AddSheet 기준으로 이 시트는 spdSub에 붙어 있다. 실제 탭 구성을 확인해야 한다.
- `usrMultiLineEditor1`과 `usrLayoutControl1`(UsrMultiLineEditor / UsrLayoutControl)이 본 화면 소속인지 팝업 소속인지는 controls.csv 발췌가 잘려 **확인 필요**다.

### 2-2. 팝업 레이아웃 (parent 체인은 부분 확인)

```
SSP0022_BodItemPopup
├─ usrConditionPanel1 → usrLayoutControl1/2 (소속 확인 필요)
│    └─ clbDivision, clbFromSite, clbToSite, txtItemID(추정), usrMultiLineEditor1(추정)
├─ btnButtonList [UsrButtonList]
└─ spdMain → spdMain_Sheet1 / 하드코딩 시트 "Project"(추정)

SSP0022_ShipmentRequestPopup
├─ usrConditionPanel1 → usrLayoutControl1/2 (소속 확인 필요)
│    └─ clbDivision
├─ btnButtonList [UsrButtonList]
└─ spdMain → spdMain_Sheet1 / 하드코딩 시트 "Shipment Reqeust(Electrode)"(추정)
```

- clbFromSite / clbToSite를 BodItemPopup 소속으로 본 것은 추정이다. 근거는 BodItemPopup InitControls:173·174가 From/To Site 공통코드를 조회한다는 점이다. **확인 필요**.

### 2-3. 영역 정의
| 영역 | 구성 |
|---|---|
| 조회조건(상단) | usrConditionPanel1 / usrLayoutControl2 |
| 버튼(화면 내) | formDown, btnExcelUpload, btnMeasure, btnItemId, btnModelId |
| 버튼(프레임워크) | FindButton, InsertButton, EditButton, SaveButton |
| 그리드(메인) | spdMain (`Shipment Request(Electrode)`) |
| 조회조건(하단) | usrLayoutControl3 + btnSearch |
| 그리드(상세) | spdDetail (`Stock Detail`, `Shipment Request Detail`), spdSub (`Shipment Request Detail Excel`) |
| 팝업 | SSP0022_BodItemPopup (`Project`), SSP0022_ShipmentRequestPopup (`Shipment Reqeust(Electrode)`) |

---

## 3. 컨트롤 명세

- 라벨 = props.csv Text 원문(1차 web_components 인용).
- 필수 = 라벨의 '*' 표기 기준.
- '—' = 해당 없음. '확인 필요' = Fact Pack에서 값을 얻지 못함.

### 3-1. 본 화면 — 상단 (usrConditionPanel1 / usrLayoutControl2)
| # | 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, Size(1689,75), HidePanel | — | — | 조회조건 패널(접기 가능) |
| 2 | usrLayoutControl2 | UsrLayoutControl | — | Dock=Top, Size(1689,72) | — | — | 조회조건 레이아웃(Grid/Flex) |
| 3 | clbCompany_ID | UsrCombo | Company* | Size(156,20). dtCompany.Rows[0].CODE를 쓰는지 확인 필요 | Y | `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 4 | clbDivision_ID | UsrCombo | Division* | Size(125,20) | Y | `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 5 | cboPlanDate | UsrCombo | Plan-date* | Size(113,20) | Y | `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 6 | drpPeriod | UsrDateRangePicker | Period* | **Enabled=false**, Size(197,20) | Y | — | 날짜범위(읽기 전용) |
| 7 | cboBucketType | UsrCombo | Bucket | Size(70,20). 목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE` | — | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 8 | clbPlantSite | UsrCheckedList | Plant | Size(115,21) | — | — | Wijmo MultiSelect |
| 9 | txtItemId | UsrMultiLineEditor | Material | Size(100,21) | — | — | 멀티라인 입력 |
| 10 | btnItemId | UsrButton | 확인 필요 | Size(39,24) | — | `btnItemId_Click` | 아이콘 버튼(팝업) |
| 11 | txtModelId | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 12 | btnModelId | UsrButton | 확인 필요 | **Visible=false** | — | — | (숨김, 이관 여부 확인 필요) |
| 13 | textNickName | TextBox | 확인 필요 (lblNickname 항목 있음) | Size(104,20) | — | — | Input |
| 14 | clbCellType | UsrCheckedList | 확인 필요 | Size(86,21) | — | — | Wijmo MultiSelect |
| 15 | lblUOMType | UsrLabel | UOM Type | Size(66,25) | — | — | 라벨 |
| 16 | rdButton1 | UsrRadio | UOM | **Checked=true** | — | `rdButton_Changed` | Radio |
| 17 | rdButton2 | UsrRadio | Cell | — | — | `rdButton_Changed` | Radio |
| 18 | rdButton3 | UsrRadio | Pancake m | — | — | `rdButton_Changed` | Radio |
| 19 | chkSum | UsrCheckBox | Sum | 초기 Checked 확인 필요 | — | `chkSum_CheckedChanged` | CheckBox |
| 20 | chkPastPeriod | UsrCheckBox | Including Past Period | **Visible=false** | — | `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1` | CheckBox(숨김) |
| 21 | btnMeasure | UsrButton | 확인 필요 (layoutControlItem10) | Size(39,25) | — | `BtnMeasure_Click` | 버튼 |
| 22 | chkDelegateModel | UsrCheckBox | Delegate Model | — | — | — | CheckBox |
| 23 | chkTeamLeader | UsrCheckBox | Team Leader | — | — | — | CheckBox |
| 24 | chkPartLeader | UsrCheckBox | Part Leader | — | — | — | CheckBox |
| 25 | chkMyModel | UsrCheckBox | My Model | **Visible=false** | — | — | CheckBox(숨김) |
| 26 | formDown | UsrButton | Excel Form | Size(90,25) | — | `btnExcelFormDownload_Click` | 버튼 |
| 27 | btnExcelUpload | UsrButton | Upload | Size(70,25) | — | `btnExcelUpload_Click` | 버튼(파일 업로드) |

### 3-2. 본 화면 — 그리드·하단 (splitContainer1)
| # | 컨트롤명 | 타입 | 라벨 | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 28 | spdMain | FpSpread | — | Panel1. 시트 `Shipment Request(Electrode)`(헤더 3단) | — | `SpdMain_TopChange`, `SpdMain_CellClick`, `spdMain_CellClick_1`, `SpdMain_CellDoubleClick`, `SpdMain_Change` | Wijmo FlexGrid |
| 29 | spdMain_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 단일 뷰) |
| 30 | spdDetail | FpSpread | — | Panel2. 시트 `Stock Detail`, `Shipment Request Detail` | — | `SpdDetail_TopChange`, `SpdDetail_ActiveSheetChanged`(2회 등록), `SpdDetail_SheetTabClick`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_ClipboardPasted`, `SpdDetail_EditChange` | 탭 + Wijmo FlexGrid |
| 31 | spdDetail_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |
| 32 | spdSub | FpSpread | — | Panel2. 시트 `Shipment Request Detail Excel` | — | — | Wijmo FlexGrid(양식) |
| 33 | spdSub_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |
| 34 | usrLayoutControl3 | UsrLayoutControl | — | Panel2 하단 조회조건 | — | — | 상세 조회조건 레이아웃 |
| 35 | drpPeriod2 | UsrDateRangePicker | 확인 필요 | — | 확인 필요 | — | 날짜범위 |
| 36 | txtModelId2 | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 37 | txtRequestor | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 38 | btnRequestor | UsrButton | 확인 필요 | — | — | `BtnRequestor_Click` | 아이콘 버튼(사용자 팝업) |
| 39 | textNickName2 | TextBox | 확인 필요 | — | — | — | Input |
| 40 | txtItemld2 | UsrMultiLineEditor | 확인 필요 (컨트롤명 'ld' 원문 그대로) | — | — | — | 멀티라인 입력 |
| 41 | btnItemID2 | UsrButton | 확인 필요 | — | — | `BtnItemID2_Click` | 아이콘 버튼(팝업) |
| 42 | txtLotID | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 43 | btnSearch | SimpleButton | 확인 필요 | — | — | `BtnSearch_Click` | 상세 조회 버튼 |

### 3-3. 팝업 / 소속 확인 필요 컨트롤
| # | 컨트롤명 | 타입 | 소속 | 라벨 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|
| 44 | usrMultiLineEditor1 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 45 | usrLayoutControl1 | UsrLayoutControl | 확인 필요 (팝업 레이아웃 추정) | — | — | 팝업 조회조건 레이아웃 |
| 46 | txtItemID | UsrMultiLineEditor | 팝업(추정, BodItemPopup) | 확인 필요 | — | 멀티라인 입력 |
| 47 | clbDivision | UsrCheckedList | BodItemPopup · ShipmentRequestPopup (각 1개) | 확인 필요 | `clbDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 48 | clbFromSite | UsrCheckedList | 팝업(추정, BodItemPopup) | 확인 필요 | — | Wijmo MultiSelect |
| 49 | clbToSite | UsrCheckedList | 팝업(추정, BodItemPopup) | 확인 필요 | — | Wijmo MultiSelect |
| 50 | btnButtonList | UsrButtonList | BodItemPopup · ShipmentRequestPopup | 버튼 구성 확인 필요 | `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 바 |

- 팝업 spdMain의 이벤트: BodItemPopup `spdMain_CellDoubleClick`. ShipmentRequestPopup `SpdMain_CellClick`, `SpdMain_EditChange`, `SpdMain_ComboSelChange`, `SpdMain_TextChanged`(Form_Load:160~164에서 연결).
- 두 팝업의 Load: `Form_Load`(BodItemPopup .ctor:137 / ShipmentRequestPopup .ctor:143).

---

## 4. 그리드 명세

- 출처 표기: META = SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE, DB루프 = 3SPAN 결과로 만든 컬럼, HARDCODED = Add*Column.
- division별 표시: 14종 모두 같다(업무분석서 §6-1).
- 편집 가능 여부: 메타 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값을 Fact Pack에서 얻지 못한 컬럼은 **확인 필요**다.

### 4-1. `Shipment Request(Electrode)` (spdMain, META+코드연결, 헤더 3단, 최종 표시 22 (?9))
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 | 비고 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 14종 동일 | 확인 필요 | |
| SCM_SITE_ID | SCM_SITE_ID | 확인 필요 | META | 동일 | 확인 필요 | |
| PLANT_ID | Plant | 확인 필요 | META | 동일 | 확인 필요 | |
| FROM_SITE / TO_SITE | From Site / To Site | 확인 필요 | META | 동일 | 확인 필요 | |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | 확인 필요 | META | 동일 | 확인 필요 | |
| CELL_TYPE / ELECTRODE_TYPE | Cell Type / Elec Type | 확인 필요 | META | 동일 | 확인 필요 | |
| BOD_ID / BOD_LT / OPERATION_LT | Bod ID / BOD L/T / Oper. L/T | 확인 필요 | META | 동일 | 확인 필요 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms / Trans Mode | 확인 필요 | META | 동일 | 확인 필요 | |
| LAST_UPDATED_BY | Requestor | 확인 필요 | META | 동일 | 확인 필요 | |
| PSI_NAME / MEASURE_NAME | PSI / Measure | 확인 필요 | META (+MEASURE 10행) | 동일 | 확인 필요 | |
| TEMPCOLUMN | TEMPCOLUMN | 확인 필요 | META | 동일 | 확인 필요 | |
| TOT_BOH_QTY / JR_BOH_QTY / PC_BOH_QTY | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton1일 때 표시 |
| TOT/JR/PC_BOH_QTY_CELL | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton2일 때 표시 |
| TOT/JR/PC_BOH_QTY_PCM | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton3일 때 표시 |
| BACK_COLOR, CONFIRM_DAY("Confrim Day"), MEASURE, NPC_ITEM_ID("Noteched Pancake"), ORIGIN_DIVISION_ID, TOT_BOH_JR | (원문 오탈자 유지) | — | META 숨김 | 동일 | — | 숨김 |
| (동적) 날짜 컬럼 | COLUMN_LABEL_NAME. 3단 = LARGE / SMALL_CLASS_LABEL_NAME / "SUM" | `B_` 포함 = Text 숨김(폭 0), 그 외 = Num(폭 100, 우측, 소수 3자리, 천단위) | DB루프 (`SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`) | 동일 | 확인 필요 | Tag X_/Y_/Z_ × D_/W_/M_로 표시 토글. SAT=Blue, SUN=Red |

### 4-2. `Stock Detail` (spdDetail 탭0, META+코드연결, 헤더 3단, 최종 표시 31 (?9))
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 동일 | 확인 필요 (조회 결과 시트로 보임 — 추정) |
| PLANT_ID | Plant | META | 동일 | 〃 |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | META | 동일 | 〃 |
| CELL_TYPE / VERSION | Cell Type / Version | META | 동일 | 〃 |
| LOT_ID / PALLET_ID / LANE | Lot ID / Pallet ID / Lane | META | 동일 | 〃 |
| OPERATION_ID / STORAGE_ID | Operation / Storage | META | 동일 | 〃 |
| TOTAL_QTY_UOM / TOTAL_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| GMES_QTY_UOM / GMES_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| IWMS_QTY_UOM / IWMS_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| OWMS_QTY_UOM / OWMS_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| MES_HOLD_YN / QMS_HOLD_YN / IWMS_HOLD_YN / OWMS_HOLD_YN | MES / QMS / iWMS / oWMS Hold YN | META | 동일 | 〃 |
| AVAILABLE_YN / CHANGE_STATUS | Available Stock YN / Change Status | META | 동일 | 〃 |
| EXPIRATION_DATE / PACKAGE_TYPE_CODE | Expiration Date / Package Type (oWMS) | META | 동일 | 〃 |
| FROM_SITE | Site | META 숨김 | 동일 | — |
| BOH 9컬럼(CODE_ONLY_CHANGE ?) | — | 코드(rdButton_Changed) | 동일 | 이 시트에 실제로 적용되는지 **확인 필요** |

### 4-3. `Shipment Request Detail` (spdDetail 탭1, META+코드연결, 헤더 1단, 최종 표시 19 (?9))
| 컬럼 | 헤더 | 출처 | 편집 | 비고 |
|---|---|---|---|---|
| DIVISION_ID / ORIGIN_DIVISION_ID | Div / Org Div | META | 확인 필요 | |
| FROM_SITE / TO_SITE | From Site* / To Site* | META + 셀 콤보(InsertRow:1481~1482) | 입력(콤보, 추정) | PlantByElectordeShipFromSite/ToSite |
| MODEL_ID / ITEM_ID / NICK_NAME | Model* / Material* / Nick Name | META | 확인 필요 | |
| SHIPMENT_DATE | Shipment ETA* | META | 확인 필요 | |
| SHIPMENT_QTY | Qty* | META | 확인 필요 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / Trans Mode* | META | 확인 필요 | |
| BOD_ID / CONFIRM_DAY | (메타 라벨) | META | 확인 필요 | |
| REQUEST_DATE / REQUESTOR / EDIT_FLAG | Request Date / Requestor / EDIT_FLAG | META | 확인 필요 | |
| SCM_SITE_ID, PLANT_ID, LT, ETD, ETA, ROUTE_ID, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID | — | META 숨김 | — | ROUTE_ID~TO_CITY 8종과 BOD_ID·INCOTERMS는 `SpdDetail_ClipboardPasted`가 채운다 |

### 4-4. `Shipment Request Detail Excel` (spdSub, META+코드연결, 헤더 1단, 최종 표시 12 (?9))
| 컬럼 | 헤더 | 출처 | 편집 |
|---|---|---|---|
| COMPANY_ID | Company* | META | 양식 컬럼 |
| DIVISION_ID | Div* | META | 〃 |
| FROM_SITE / TO_SITE | FromSite* / ToSite* | META | 〃 |
| ITEM_ID | Material* | META | 〃 |
| YYYYMMDD | yyyyMMdd* | META | 〃 |
| QTY | Qty* | META | 〃 |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / Trans Mode* | META | 〃 |

### 4-5. `Project` (팝업 추정 — BodItemPopup, HARDCODED InitSpread:208~215, 8컬럼)
| 컬럼 | 헤더 | 타입 | 출처 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Division | Text | HARDCODED | 확인 필요 (`spdMain_CellDoubleClick`로 선택하는 것으로 보임 — 추정) |
| DIVISION_NAME | Division | Text | HARDCODED | 〃 |
| MODEL_ID | Model | Text | HARDCODED | 〃 |
| ITEM_ID | Material | Text | HARDCODED | 〃 |
| INCOTERMS | Incoterms | Text | HARDCODED | 〃 |
| TRANSPORT_MODE | Transport Mode | Text | HARDCODED | 〃 |
| BOD_ID | BOD ID | Text | HARDCODED | 〃 |
| CONFIRM_DAY | Confirm Day | Text | HARDCODED | 〃 |

### 4-6. `Shipment Reqeust(Electrode)` (팝업 추정 — ShipmentRequestPopup, HARDCODED InitSpread:257~285, 26컬럼, 시트명 오탈자 원문 유지)
| 컬럼 | 헤더(원문) | 타입 | 편집 |
|---|---|---|---|
| DIVISION_ID | Div* | Combo | 입력(ComboSelChange 대상) |
| SCM_SITE_ID | SCM Site* | Combo | 입력 |
| PLANT_ID | Plant | Combo | 입력 |
| FROM_SITE / TO_SITE | From Site* / To Site* | Combo | 입력 (PlantByElectorde* 콤보, 943·945) |
| MODEL_ID / ITEM_ID / NICK_NAME | Model* / Material* / Nick Name | Text | 입력(EditChange·TextChanged 대상, 추정) |
| SHIPMENT_DATE | Shipment Date* | Date | 입력 |
| SHIPMENT_QTY | "Qty* " | Num | 입력 |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / "Trans Mode* " | Combo | 입력 |
| LT | L/T(Day) | Num | 확인 필요 |
| ETD / ETA | ETD / ETA | Date | 확인 필요 |
| ROUTE_ID, BOD_ID, CONFIRM_DAY, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID | 필드명과 같음 | Text | 확인 필요 (표시 여부 포함) |

---

## 5. 액션 명세

엔드포인트 표기는 업무분석서 §5와 같다.

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | InitControls > GetBucketType / CreateSpread > InitSpread > GetSpdTitle | `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | cboBucketType 목록, spdMain 날짜 컬럼 |
| A02 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | CODE/FROM_DATE/TO_DATE 읽음 > GetSpdTitle | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 기간·날짜 컬럼 재구성 |
| A03 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 이벤트 해제(3669) → PlantEE 조회 → 재연결(3673) > InitSpread | `biz:CommonData.CommonDataList`[PlantEE], `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | clbPlantSite 목록(추정), 그리드 재구성 |
| A04 | 조회(FindButton) | FindButton(프레임워크) | FindData_Main > InitSpread | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | spdMain `Shipment Request(Electrode)` |
| A05 | UOM 라디오 / Sum / Bucket / Past Period | `rdButton_Changed`, `chkSum_CheckedChanged`, `cboBucketType_SelectedIndexChanged`, `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1` | 컬럼 Visible 토글(SetSpreadColumn / rdButton_Changed:1823~1858) | 없음 | 표시 컬럼 변경(재조회 없음). Bucket·PastPeriod 핸들러 본문은 확인 필요 |
| A06 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | DIVISION_ID 읽음 | 없음(Fact Pack 기준) | 확인 필요 |
| A07 | btnMeasure | `BtnMeasure_Click` | InitSpread > GetSpdTitle | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 그리드 재구성 |
| A08 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | GetCheckedListValue(1405~1407) > FindData_Main | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | spdMain 재조회 |
| A09 | spdMain 클릭·변경·스크롤 | `SpdMain_CellClick`, `spdMain_CellClick_1`, `SpdMain_Change`, `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A10 | 행추가(InsertButton) | InsertButton(프레임워크) | InsertRow. IsLock==false이고 활성 시트 "Shipment Request Detail"이면 셀 콤보 설정 | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite / PlantByElectordeShipToSite] | `Shipment Request Detail` 새 행 |
| A11 | btnSearch | `BtnSearch_Click` | FindData_Request_Detail > InitSpread / FindData_Detail | `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_STOCK_DETAIL` | spdDetail `Shipment Request Detail`, `Stock Detail` |
| A12 | spdDetail 콤보 변경 / 더블클릭 / 붙여넣기 | `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_ClipboardPasted` | FindData_BOD. 붙여넣기는 9개 필드 자동 채움 | `SSP.SSP0022_GET_ITEM_POPUP` | `Shipment Request Detail` 셀 값 |
| A12-2 | spdDetail 기타 | `SpdDetail_TopChange`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_SheetTabClick`, `SpdDetail_CellClick`, `SpdDetail_EditChange` | 탭 전환(TabIndex 2 → Shipment Request Detail Excel), 그 외 확인 필요 | 없음 | 확인 필요 |
| A13 | 수정(EditButton) | EditButton(프레임워크) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부(확인 필요) |
| A14 | 저장(SaveButton) | SaveButton(프레임워크) | SaveData_Detail → FindData_Request_Detail / SaveData → FindData_Main | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 저장 후 재조회 |
| A15 | formDown "Excel Form" | `btnExcelFormDownload_Click` | FindData_Request_Detail_DownLoad | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | `Shipment Request Detail Excel` 양식 |
| A16 | btnExcelUpload "Upload" | `btnExcelUpload_Click` | 업로드 처리(확인 필요) → FindData_Main / FindData_Request_Detail | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_REQUEST_DETAIL` | 재조회 |
| A17 | BodItemPopup Load / 조회 | `Form_Load`, `btnButtonList_UsrButtonList_Click_Detected`, FindButton | InitControls(GetDivision, GetDivisionbyScmSite) / FindData | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite/ToSite], `SCM.SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION`, `SSP.SSP0022_GET_ITEM_POPUP` | 팝업 `Project` 그리드(추정) |
| A18 | BodItemPopup Division 변경 / 더블클릭 | `clbDivision_SelectedIndexChanged`, `spdMain_CellDoubleClick` | 확인 필요 | `SSP.SSP0022_GET_ITEM_POPUP`(BodItemPopup에서 연결되는지 확인 필요) | 선택값 반환(확인 필요) |
| A19 | ShipmentRequestPopup Load / Division 변경 | `Form_Load`, `clbDivision_SelectedIndexChanged` | GetDayRange / 공통코드 4종 + FindData | `SCP.GET_DATE_RANGE_1MONTH`, `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite·ToSite·Incoterms·TransportMode], `SSP.SSP0022_GET_ITEM_POPUP` | 팝업 기간·콤보·그리드 |
| A20 | ShipmentRequestPopup 셀 이벤트 | `SpdMain_ComboSelChange`, `SpdMain_EditChange`, `SpdMain_TextChanged`, `SpdMain_CellClick` | ComboSelChange: From/To 콤보 + FindData | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP` | `Shipment Reqeust(Electrode)` 셀 |
| A21 | ShipmentRequestPopup 저장 | `btnButtonList_UsrButtonList_Click_Detected`, SaveButton | SaveData:539 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` | 저장 |
| A22 | (진입점 미연결) 유효성 검사 | BodItemValidChk_main / BodItemValidChk / BodValidChk | 실행 여부 확인 필요 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK`, `SSP.SSP0002_GET_BOD_VALID_CHECK` | 확인 필요 |
| A23 | 팝업 열기 | `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` | 어떤 팝업을 여는지 확인 필요 | 확인 필요 | txtItemId / txtItemld2 / txtRequestor 값 반영(추정) |

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 필수 표시 | Company*, Division*, Plan-date*, Period* / 상세·Excel·팝업 시트 '*' 컬럼 | 검증 코드와 메시지 문구는 Fact Pack에 없음 → **확인 필요** |
| 행추가 조건 | `siDetail.IsLock(...) == false`이고 활성 시트 "Shipment Request Detail" | 조건 불충족 시 메시지 **확인 필요** |
| 수정 권한 | `SSP.SSP0002_GET_USER_INFO_LIST` 결과로 판정 | 실패 메시지 **확인 필요** |
| BOD 유효성 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` / `SSP.SSP0002_GET_BOD_VALID_CHECK` 메서드 있음(진입점 미연결) | 실행 여부 **확인 필요** |
| 메시지 코드 | Fact Pack에 MessageBox / 메시지 ID 추출 없음 | **확인 필요** |

---

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R (조회) | FindButton 오버라이드. 상세는 btnSearch |
| C (생성) | InsertButton 오버라이드(InsertRow) |
| U (수정) | EditButton 오버라이드 → `SSP.SSP0002_GET_USER_INFO_LIST` 사용자 검사 |
| 저장 | SaveButton 오버라이드 → `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| D (삭제) | DeleteButton 오버라이드가 Fact Pack에 없음. 삭제가 SAVE SP 안의 플래그로 처리되는지 **확인 필요** |
| 그룹 메타 | TB_FX_GroupMenuAuth 13행. 그룹별 값 **확인 필요** |
| 사용자 필터 | SetChangeControl이 GROUP_ID / USER_ID를 NowGroupID로 필터 |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

1. **Spread 다중 시트 → 화면 구성**
   - spdMain은 FlexGrid 1개로 바꾼다.
   - spdDetail(시트 2개)은 탭 + FlexGrid 2개로 바꾼다.
   - spdSub(양식)는 FlexGrid 또는 Excel 내보내기 전용으로 바꾼다.
   - `SpdDetail_SheetTabClick`의 탭 인덱스와 spdSub 시트의 대응을 확정한 뒤 구성한다.
2. **3단 헤더 + 동적 날짜 컬럼**
   - FlexGrid columnHeaders 다단 행 + allowMerging으로 LARGE / SMALL / "SUM"을 재현한다.
   - 컬럼 정의는 `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` 결과로 런타임에 만든다.
   - `B_` 컬럼은 visible=false로 둔다.
   - SAT/SUN 색은 formatItem에서 칠한다.
3. **표시 토글 = 클라이언트 처리**
   - UOM 라디오, Bucket, Sum, Past Period는 As-is에서 재조회 없이 Visible만 바꾼다. To-Be도 컬럼 visible 토글로 구현한다.
   - DAILY일 때 W_ 컬럼의 최종 표시값을 먼저 확정해야 한다(업무분석서 §4-3).
4. **콤보 셀**: FROM_SITE·TO_SITE·INCOTERMS·TRANSPORT_MODE·DIVISION_ID는 DataMap으로 만든다. 소스는 `biz:CommonData.CommonDataList` code별 공통코드 API다.
5. **붙여넣기 BOD 자동 채움**: FlexGrid pasted / cellEditEnded 이벤트에서 BOD 조회 API(`SSP.SSP0022_GET_ITEM_POPUP` 대응)를 호출한다.
6. **Oracle 전환 포인트**
   - `SSP0022_GET_SHIPMENT_PSI`의 #임시테이블 다수, `SSP0022_SAVE_SHIPMENT_REQUEST`의 #TBLDYNAMIC_*는 GTT 또는 WITH절로 바꾼다.
   - STRING_SPLIT / UF_FX_STRING_SPLIT / SCM_ARR_SPL_*은 Oracle 분해 함수로 바꾼다.
   - 동적 SQL(DYNAMIC@)은 EXECUTE IMMEDIATE / SYS_REFCURSOR로 바꾼다.
   - `SCM0001_GET_SITE_BY_DIVISION`의 REF:VALUE / NODES(XML)는 XMLTABLE로 바꾼다.
   - SP를 재작성할 때 GTT를 시작 시 비우고 세션 시나리오로 대조해야 한다.
7. **팝업**: 두 팝업은 모달 컴포넌트로 만든다. 본 화면에서 여는 지점과 반환값은 §9에서 확정한 뒤 설계한다.
8. **숨김 컨트롤**: chkPastPeriod, chkMyModel, btnModelId(Visible=false)는 이관 여부를 따로 판정해야 한다.

---

## 9. 미확정

1. splitContainer1의 Orientation·SplitterDistance·Size, 그리고 분할 비율(%).
2. 라벨이 확인되지 않은 컨트롤: btnItemId, txtModelId, btnModelId, textNickName, clbCellType, btnMeasure, usrLayoutControl3 하위 전부, 팝업 컨트롤.
3. usrMultiLineEditor1, usrLayoutControl1, txtItemID, clbFromSite, clbToSite가 어느 파일·클래스 소속인지.
4. 하드코딩 시트 `Project` / `Shipment Reqeust(Electrode)`가 실제로 어느 팝업에 있는지.
5. 메타 컬럼 셀 타입·편집 가능 여부. SCM_MST_SHEET_COLUMNS 103행 원문으로 확인한다.
6. 엔드포인트가 없는 핸들러의 본문 동작(§5 A05·A06·A09·A12-2·A18·A23).
7. 주석 처리된 호출은 설계에 넣지 않았다: main 4003 SSP.SSP0002_GET_BOD_VALID_CHECK, BodItemPopup 396 DM.Get_Division, ShipmentRequestPopup 1226 SCP.SCM0001_GET_SCP_DAY_PERIOD.

=== FILE: unit_test.md ===
# SSP0022 Shipment Request(Electrode) — 단위테스트

> **작성 근거**: 업무분석서 §5 데이터 흐름, 화면설계서 §3 컨트롤 명세와 §5 액션 명세.
> 절차 열의 컨트롤명은 화면설계서 §3과 같다. 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문 그대로다.
> 기대결과에 Fact Pack으로 확정되지 않은 부분이 있으면 '(확인 필요)'를 붙였다. 실행할 때 As-is 동작과 대조해 값을 확정한다.
> 주석 처리된 호출은 테스트 케이스에 넣지 않았다.

공통 사전조건(별도 표기가 없을 때): ADMIN/PLANNER 계정 1개로 로그인하고 SSP0022 메뉴에 진입한다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0022-001 | 초기화 | 공통 | 화면을 연다 | — | cboBucketType 목록이 채워진다(DAILY/WEEKLY/MONTHLY 포함 여부 확인 필요) | `Form_Load`, GetBucketType, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0022-002 | 초기화 | 공통 | 화면을 연다 → spdMain 헤더를 확인한다 | — | 날짜 컬럼이 3단 헤더(LARGE/SMALL/SUM)로 생긴다. `B_` 컬럼은 숨김. SAT=Blue, SUN=Red | `Form_Load`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, SP `SSP0022_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-003 | 초기화 | 공통 | 화면을 연다 → 컨트롤 상태를 확인한다 | — | rdButton1 선택됨. drpPeriod 비활성. chkPastPeriod·chkMyModel·btnModelId 숨김 | `Form_Load` (props: rdButton1 Checked=true, drpPeriod Enabled=false) |
| TC-SSP0022-004 | 조회 | Company·Division·Plan-date 선택 | clbCompany_ID, clbDivision_ID, cboPlanDate 선택 → FindButton | 데이터가 있는 조건 | spdMain에 PSI 행이 표시된다 | FindButton, `SSP.SSP0022_GET_SHIPMENT_PSI`, SP `SSP0022_GET_SHIPMENT_PSI`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-005 | 조회 | 〃 | FindButton | 데이터가 없는 Plant(clbPlantSite)·Material(txtItemId) | 0행. 오류 없이 헤더만 남는다(빈 결과 메시지 여부 확인 필요) | `SSP.SSP0022_GET_SHIPMENT_PSI` (빈 결과) |
| TC-SSP0022-006 | 조회 | SP 오류를 유발하는 조건(예: 권한 없는 계정·DB 객체 비활성) | FindButton | — | 오류 메시지가 표시되고 그리드는 이전 상태를 유지한다(확인 필요) | `SSP.SSP0022_GET_SHIPMENT_PSI` (오류 응답) |
| TC-SSP0022-007 | 이벤트 | 화면 진입 | clbCompany_ID 값을 바꾼다 | 다른 Company | PlantEE 목록 재조회. 그리드 재구성. 변경 중 cboPlanDate 이벤트가 연쇄 실행되지 않는다(3669 해제 / 3673 재연결) | `clbCompanyID_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantEE], `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-008 | 이벤트 | 화면 진입 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod에 FROM_DATE~TO_DATE가 반영되고(확인 필요) 날짜 컬럼이 다시 만들어진다 | `cboPlanDate_SelectedIndexChanged`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-009 | 이벤트 | 화면 진입 | clbDivision_ID 값을 바꾼다 | 다른 Division | DIVISION_ID를 읽는다. 화면 반영 내용은 확인 필요 | `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0022-010 | 그리드 | TC-004 조회 완료, rdButton1 | cboBucketType=DAILY 선택 | DAILY | X_D_ 표시. X_M_은 chkSum 상태를 따른다. X_W_ 최종값 기록(확인 필요) | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1917·1922, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-011 | 그리드 | 〃 | cboBucketType=WEEKLY 선택 | WEEKLY | X_D_ 숨김, X_W_ 표시, X_M_ = chkSum | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1930~1938 |
| TC-SSP0022-012 | 그리드 | 〃 | cboBucketType=MONTHLY 선택 | MONTHLY | X_D_·X_W_ 숨김, X_M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1946·1950 |
| TC-SSP0022-013 | 그리드 | TC-004 조회 완료 | rdButton2 선택 | Cell | TOT/JR/PC_BOH_QTY_CELL 표시, 나머지 BOH 숨김. Y_ 날짜 컬럼 표시. 재조회 없음 | `rdButton_Changed`:1837~1845, SetSpreadColumn:1961·1965 |
| TC-SSP0022-014 | 그리드 | 〃 | rdButton3 선택 | Pancake m | _PCM 3컬럼 표시. Z_ 표시 | `rdButton_Changed`:1850~1858, SetSpreadColumn:2017·2021 |
| TC-SSP0022-015 | 그리드 | rdButton3 상태 | rdButton1 선택 | UOM | TOT/JR/PC_BOH_QTY 표시. X_ 표시 | `rdButton_Changed`:1823~1831 |
| TC-SSP0022-016 | 그리드 | TC-004 조회 완료, WEEKLY | chkSum 체크 → 해제 | 체크/해제 | ?_M_ 컬럼이 체크 상태를 따라 표시/숨김 | `chkSum_CheckedChanged`, SetSpreadColumn:1938 |
| TC-SSP0022-017 | 그리드 | chkPastPeriod는 Visible=false — 코드로 Checked를 바꿔 검증(TO-BE 이관 시 노출 여부 확인 필요) | chkPastPeriod 미체크 → 체크 | — | 미체크: 헤더 2행이 "SUM"이 아닌 과거 날짜 컬럼 숨김. 체크: 표시. 핸들러 2개가 모두 실행된다 | `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1`, SetSpreadColumn:2081 |
| TC-SSP0022-018 | 이벤트 | 화면 진입 | btnMeasure 클릭 | — | 그리드 재구성(Measure 선택 UI 동작 확인 필요) | `BtnMeasure_Click`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-019 | 이벤트 | 화면 진입 | btnItemId 클릭 | — | 품목 선택 UI가 열리고 선택값이 txtItemId에 들어간다(대상 팝업 확인 필요) | `btnItemId_Click` |
| TC-SSP0022-020 | 이벤트 | 화면 진입 | btnItemID2 클릭 | — | 선택값이 txtItemld2에 들어간다(확인 필요) | `BtnItemID2_Click` |
| TC-SSP0022-021 | 이벤트 | 화면 진입 | btnRequestor 클릭 | — | 요청자 선택값이 txtRequestor에 들어간다(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0022-022 | 이벤트 | TC-004 조회 완료 | spdMain 셀 더블클릭 | 임의 데이터 셀 | 메인 재조회. 더블클릭한 셀 값이 조건에 반영되는지 기록 | `SpdMain_CellDoubleClick`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-023 | 이벤트 | TC-004 조회 완료 | spdMain 셀 클릭 | 임의 셀 | 핸들러 2개가 모두 실행된다. 화면 반영 확인 필요 | `SpdMain_CellClick`, `spdMain_CellClick_1` |
| TC-SSP0022-024 | 이벤트 | TC-004 조회 완료 | spdMain 셀 값을 바꾼다 | 수치 변경 | 변경 행 표시(확인 필요) | `SpdMain_Change` |
| TC-SSP0022-025 | 이벤트 | TC-004 조회 완료, 행 다수 | spdMain을 세로 스크롤한다 | — | 동작 기록(spdDetail 동기화 여부 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0022-026 | 이벤트 | TC-027 조회 완료 | spdDetail을 세로 스크롤한다 | — | 동작 기록(확인 필요) | `SpdDetail_TopChange` |
| TC-SSP0022-027 | 조회 | 상단 조건 선택 | drpPeriod2, txtModelId2, txtRequestor, textNickName2, txtItemld2, txtLotID 입력 → btnSearch | 데이터가 있는 조건 | `Shipment Request Detail` 시트에 요청 상세가 표시된다 | `BtnSearch_Click`, `SSP.SSP0022_GET_REQUEST_DETAIL`, SP `SSP0022_GET_REQUEST_DETAIL`, 시트 `Shipment Request Detail` |
| TC-SSP0022-028 | 조회 | 〃 | btnSearch | 〃 | `Stock Detail` 시트에 재고 상세가 표시된다 | `BtnSearch_Click`, `SSP.SSP0022_GET_STOCK_DETAIL`, SP `SSP0022_GET_STOCK_DETAIL`, 시트 `Stock Detail` |
| TC-SSP0022-029 | 조회 | 〃 | btnSearch | 존재하지 않는 txtLotID | 두 시트 모두 0행. 오류 없음 | `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_STOCK_DETAIL` (빈 결과) |
| TC-SSP0022-030 | 이벤트 | spdDetail 표시 | Stock Detail ↔ Shipment Request Detail 탭 전환 | — | 활성 시트가 바뀐다. 핸들러 등록 2회(831·834)에 따른 중복 실행 여부를 기록 | `SpdDetail_ActiveSheetChanged` |
| TC-SSP0022-031 | 이벤트 | spdDetail 표시 | 시트 탭 클릭(TabIndex 2 포함) | — | TabIndex 2 → `Shipment Request Detail Excel` 처리(실제 탭 구성 확인 필요) | `SpdDetail_SheetTabClick`, 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-032 | 이벤트 | TC-027 완료 | spdDetail 셀 클릭 | — | 동작 기록(확인 필요) | `SpdDetail_CellClick` |
| TC-SSP0022-033 | 이벤트 | Shipment Request Detail 행 존재 | spdDetail 셀 편집 | Qty 변경 | 편집 상태 반영(EDIT_FLAG 변경 여부 확인 필요) | `SpdDetail_EditChange`, 시트 `Shipment Request Detail` |
| TC-SSP0022-034 | 이벤트 | 신규 행 | FROM_SITE / TO_SITE 콤보 선택 | 유효 Site | BOD 정보를 조회한다 | `SpdDetail_ComboSelChange`, FindData_BOD, `SSP.SSP0022_GET_ITEM_POPUP`, SP `SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-035 | 이벤트 | 신규 행 | spdDetail 셀 더블클릭 | — | BOD 정보를 조회한다(팝업 여부 확인 필요) | `SpdDetail_CellDoubleClick`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-036 | 이벤트 | Shipment Request Detail 활성 | Excel에서 복사한 행을 spdDetail에 붙여넣는다 | Site·Material 포함 행 | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY가 자동으로 채워진다 | `SpdDetail_ClipboardPasted`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-037 | 이벤트 | 〃 | 붙여넣기 | BOD가 없는 Site·Material 조합 | 자동 채움 없음(오류 처리 확인 필요) | `SpdDetail_ClipboardPasted`, `SSP.SSP0022_GET_ITEM_POPUP` (빈 결과) |
| TC-SSP0022-038 | 저장 | Shipment Request Detail 활성, IsLock=false | InsertButton | — | 새 행 추가. FROM_SITE·TO_SITE 셀 콤보 설정 | InsertButton, InsertRow, `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite / PlantByElectordeShipToSite], 시트 `Shipment Request Detail` |
| TC-SSP0022-039 | 저장 | Stock Detail 활성 | InsertButton | — | 콤보 설정이 실행되지 않는다(InsertRow:1481 조건 불충족) | InsertRow:1481, 시트 `Stock Detail` |
| TC-SSP0022-040 | 권한 | SSP 사용자로 등록된 계정 | EditButton | — | 편집 가능 상태로 전환(확인 필요) | EditButton, GetSSPUserCheck, `SSP.SSP0002_GET_USER_INFO_LIST`, SP `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0022-041 | 권한 | SSP 사용자 미등록 계정 | EditButton | — | 편집 차단 또는 메시지(확인 필요) | `SSP.SSP0002_GET_USER_INFO_LIST` (빈 결과) |
| TC-SSP0022-042 | 저장 | TC-038에서 필수값 입력 | SaveButton | From Site*, To Site*, Model*, Material*, Shipment ETA*, Qty*, Incoterms*, Trans Mode* | SSP_ANL_SHIP_REQ_EE INSERT, _H 이력 INSERT, SCM_SYS_LOG_BATCH INSERT → 상세 재조회. 시험 후 대상 행 복원 | SaveButton, SaveData_Detail, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, SP `SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_REQUEST_DETAIL` |
| TC-SSP0022-043 | 저장 | 기존 요청 행 Qty 수정 | SaveButton | Qty 변경 | SSP_ANL_SHIP_REQ_EE UPDATE + 이력 INSERT. 시험 후 원복 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` (UPDATE 경로) |
| TC-SSP0022-044 | 저장 | 메인 저장 경로(SaveData 실행 조건 확인 필요) | SaveButton | — | 저장 후 메인 재조회 | SaveData:2863, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_SHIPMENT_PSI` |
| TC-SSP0022-045 | 저장 | 필수값 누락 행 | SaveButton | Qty 공란 | 저장 차단 또는 SP 오류 메시지(확인 필요). DB 변경 없음 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` (오류 응답) |
| TC-SSP0022-046 | 이벤트 | 상단 조건 선택 | formDown 클릭 | — | Excel 양식 데이터 생성(9컬럼 Company*~Trans Mode*) | `btnExcelFormDownload_Click`, `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`, SP `SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`, 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-047 | 이벤트 | 요청 데이터가 없는 조건 | formDown 클릭 | — | 빈 양식(헤더만). 오류 없음 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` (빈 결과) |
| TC-SSP0022-048 | 이벤트 | TC-046 양식 작성 | btnExcelUpload 클릭 → 파일 선택 | 정상 양식 | 업로드 후 메인·상세 재조회(업로드 내용 저장 경로 확인 필요) | `btnExcelUpload_Click`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_REQUEST_DETAIL` |
| TC-SSP0022-049 | 이벤트 | — | btnExcelUpload 클릭 → 양식이 아닌 파일 | 컬럼 불일치 파일 | 오류 메시지(확인 필요). 데이터 변경 없음 | `btnExcelUpload_Click` (오류) |
| TC-SSP0022-050 | 초기화 | BodItemPopup 호출 | 팝업을 연다 | — | clbDivision·Site 목록 채움. 품목 그리드 조회 | `Form_Load`(BodItemPopup), `SCM.SCM0001_GET_DIVISION`, SP `SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION`, SP `SCM0001_GET_SITE_BY_DIVISION`, `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-051 | 그리드 | BodItemPopup 열림 | 그리드 컬럼 확인 | — | Division, Division, Model, Material, Incoterms, Transport Mode, BOD ID, Confirm Day 8컬럼 | 시트 `Project` (InitSpread:208~215, 소속 팝업 확인 필요) |
| TC-SSP0022-052 | 조회 | BodItemPopup 열림 | clbDivision, clbFromSite, clbToSite, txtItemID 입력 → btnButtonList 조회 | 데이터가 있는 조건 | 품목/BOD 목록 표시 | `btnButtonList_UsrButtonList_Click_Detected`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-053 | 조회 | BodItemPopup 열림 | FindButton | 없는 Material | 0행 | FindButton > FindData:258, `SSP.SSP0022_GET_ITEM_POPUP` (빈 결과) |
| TC-SSP0022-054 | 이벤트 | BodItemPopup 열림 | clbDivision 변경 | 다른 Division | 동작 기록(Site 재조회 여부 확인 필요) | `clbDivision_SelectedIndexChanged` (BodItemPopup Designer:189) |
| TC-SSP0022-055 | 이벤트 | TC-052 결과 존재 | 팝업 spdMain 행 더블클릭 | 임의 행 | 선택값 반환 후 팝업 닫힘(확인 필요) | `spdMain_CellDoubleClick` (BodItemPopup Designer:416) |
| TC-SSP0022-056 | 초기화 | ShipmentRequestPopup 호출 | 팝업을 연다 | — | 기간이 1개월 범위로 설정된다(SQL 원문 확인 필요) | `Form_Load`(ShipmentRequestPopup), GetDayRange, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0022-057 | 이벤트 | ShipmentRequestPopup 열림 | clbDivision 변경 | 다른 Division | From/To Site·Incoterms·TransportMode 콤보 재설정. 품목 재조회 | `clbDivision_SelectedIndexChanged` (ShipmentRequestPopup Designer:144), `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite·PlantByElectordeShipToSite·Incoterms·TransportMode], `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-058 | 그리드 | ShipmentRequestPopup 열림 | 그리드 컬럼 확인 | — | 26컬럼(Div*, SCM Site*, Plant, From Site*, To Site*, Model*, Material*, Nick Name, Shipment Date*, "Qty* ", Incoterms*, "Trans Mode* ", L/T(Day), ETD, ETA, ROUTE_ID~ORIGIN_FROM_DIVISION_ID). 타입 Combo/Text/Date/Num 일치 | 시트 `Shipment Reqeust(Electrode)` (InitSpread:257~285) |
| TC-SSP0022-059 | 이벤트 | ShipmentRequestPopup 행 존재 | 팝업 spdMain 콤보 셀 선택 | From/To Site | 셀 콤보 재설정 + 품목 조회 | `SpdMain_ComboSelChange`, `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP`, 시트 `Shipment Reqeust(Electrode)` |
| TC-SSP0022-060 | 이벤트 | 〃 | 팝업 spdMain 셀 편집 | Model 입력 | 동작 기록(확인 필요) | `SpdMain_EditChange` |
| TC-SSP0022-061 | 이벤트 | 〃 | 팝업 spdMain 텍스트 변경 | Material 입력 | 동작 기록(확인 필요) | `SpdMain_TextChanged` |
| TC-SSP0022-062 | 이벤트 | 〃 | 팝업 spdMain 셀 클릭 | — | 동작 기록(확인 필요) | `SpdMain_CellClick` (ShipmentRequestPopup Form_Load:160) |
| TC-SSP0022-063 | 저장 | ShipmentRequestPopup 필수값 입력 | btnButtonList 저장 / SaveButton | 필수 컬럼 전부 | SSP_ANL_SHIP_REQ_EE 저장 + 이력. 시험 후 복원 | `btnButtonList_UsrButtonList_Click_Detected` (ShipmentRequestPopup Designer:192), SaveData:539, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0022-064 | 저장 | 진입점 미연결 — 실행 경로가 확인된 뒤에만 수행 | BOD 품목 유효성 검사 경로 실행(경로 확인 필요) | 유효/무효 BOD | 무효 BOD 차단 여부 기록. 경로가 없으면 '미연결'로 판정 기록 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK`, SP `SSP0022_GET_BOD_ITEM_VALID_CHECK` (BodItemValidChk_main:4094, BodItemValidChk:4143, 팝업 BodItemValidChk:770) |
| TC-SSP0022-065 | 저장 | 진입점 미연결 — 팝업 BodValidChk:663 경로 확인 후 | BOD 유효성 검사 경로 실행 | 유효/무효 BOD | 결과 기록. 경로가 없으면 '미연결' 판정 | `SSP.SSP0002_GET_BOD_VALID_CHECK`, SP `SSP0002_GET_BOD_VALID_CHECK` (ShipmentRequestPopup BodValidChk:663) |
| TC-SSP0022-066 | 그리드 | TC-004 조회 완료 | spdMain 컬럼 확인 | — | 메타 28/0 + MEASURE 10/0 + 날짜 DB루프. 표시 22컬럼(?9 런타임) | 시트 `Shipment Request(Electrode)`, SCM_MST_SHEET_COLUMNS, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-067 | 그리드 | TC-028 조회 완료 | Stock Detail 컬럼 확인 | — | Div~Package Type (oWMS) 표시. FROM_SITE("Site") 숨김. 표시 31(?9) | 시트 `Stock Detail` |
| TC-SSP0022-068 | 그리드 | TC-027 조회 완료 | Shipment Request Detail 컬럼 확인 | — | 표시 19(?9). ROUTE_ID~TO_CITY 등 15컬럼 숨김. 헤더 '*' 원문 일치 | 시트 `Shipment Request Detail` |
| TC-SSP0022-069 | 그리드 | TC-046 완료 | Shipment Request Detail Excel 컬럼 확인 | — | Company*, Div*, FromSite*, ToSite*, Material*, yyyyMMdd*, Qty*, Incoterms*, Trans Mode* | 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-070 | division | Division 40 계정 | clbDivision_ID=40 → FindButton → btnSearch | 40 | 시트별 컬럼 수: Shipment Request(Electrode) 22, Stock Detail 31, Shipment Request Detail 19, Excel 12 | grid_effective(40), `SSP.SSP0022_GET_SHIPMENT_PSI`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-071 | division | Division 81 계정 | clbDivision_ID=81 → 같은 절차 | 81 | TC-070과 같은 컬럼 수 | grid_effective(81) |
| TC-SSP0022-072 | division | Division EE 계정 | clbDivision_ID=EE → 같은 절차 | EE | TC-070과 같은 컬럼 수(14종 동일 규칙 대표 검증). 81_* / EE_* 하위 코드는 같은 결과를 표본으로 확인한다 | grid_effective(EE) |
| TC-SSP0022-073 | 권한 | NowGroupID가 다른 계정 2개 | 화면 진입 → 조회조건 목록 비교 | 그룹 A / B | SetChangeControl 필터(GROUP_ID, USER_ID)에 따라 목록이 달라진다(차이 내용 확인 필요) | SetChangeControl:379~421, `Form_Load` |

## 커버리지 점검표

### 이벤트 핸들러 35종 → TC
| 핸들러 | TC |
|---|---|
| btnExcelFormDownload_Click | 046, 047 |
| btnExcelUpload_Click | 048, 049 |
| chkPastPeriod_CheckedChanged_1 | 017 |
| spdMain_CellClick_1 | 023 |
| Form_Load | 001~003, 050, 056 |
| SpdMain_TopChange | 025 |
| SpdDetail_TopChange | 026 |
| cboBucketType_SelectedIndexChanged | 010~012 |
| rdButton_Changed | 013~015 |
| chkSum_CheckedChanged | 016 |
| chkPastPeriod_CheckedChanged | 017 |
| BtnMeasure_Click | 018 |
| btnItemId_Click | 019 |
| BtnItemID2_Click | 020 |
| BtnSearch_Click | 027, 028 |
| BtnRequestor_Click | 021 |
| SpdMain_CellClick | 023, 062 |
| SpdDetail_ActiveSheetChanged | 030 |
| SpdDetail_SheetTabClick | 031 |
| SpdDetail_CellClick | 032 |
| SpdDetail_ComboSelChange | 034 |
| SpdDetail_CellDoubleClick | 035 |
| SpdDetail_ClipboardPasted | 036, 037 |
| SpdDetail_EditChange | 033 |
| SpdMain_CellDoubleClick | 022 |
| SpdMain_Change | 024 |
| clbDivision_ID_SelectedIndexChanged | 009 |
| clbCompanyID_SelectedIndexChanged | 007 |
| cboPlanDate_SelectedIndexChanged | 008 |
| clbDivision_SelectedIndexChanged | 054, 057 |
| btnButtonList_UsrButtonList_Click_Detected | 052, 063 |
| spdMain_CellDoubleClick | 055 |
| SpdMain_EditChange | 060 |
| SpdMain_ComboSelChange | 059 |
| SpdMain_TextChanged | 061 |

### 엔드포인트 15종 → TC
| 엔드포인트 | TC |
|---|---|
| biz:CommonData.CommonDataList | 007, 038, 050, 057, 059 |
| DM.DM0003_GET_BUCKET_TYPE_CODE | 001 |
| SSP.SSP0022_GET_SHIPMENT_PSI | 004~006, 022, 044, 048, 070 |
| SSP.SSP0022_GET_REQUEST_DETAIL | 027, 029, 042, 048 |
| SSP.SSP0022_GET_STOCK_DETAIL | 028, 029 |
| SSP.SSP0022_SAVE_SHIPMENT_REQUEST | 042~045, 063 |
| SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | 046, 047 |
| SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | 002, 007, 008, 018, 022, 048, 066 |
| SSP.SSP0022_GET_ITEM_POPUP | 034~037, 050, 052, 053, 057, 059 |
| SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | 064 |
| SSP.SSP0002_GET_USER_INFO_LIST | 040, 041 |
| SCM.SCM0001_GET_DIVISION | 050 |
| SCM.SCM0001_GET_SITE_BY_DIVISION | 050 |
| SSP.SSP0002_GET_BOD_VALID_CHECK | 065 |
| SCP.GET_DATE_RANGE_1MONTH | 056 |

### 시트 6종 → TC
| 시트 | TC |
|---|---|
| Project | 051 |
| Shipment Reqeust(Electrode) | 058, 059 |
| Shipment Request Detail | 027, 033, 038, 068 |
| Shipment Request Detail Excel | 031, 046, 069 |
| Shipment Request(Electrode) | 002, 004, 010, 066, 070 |
| Stock Detail | 028, 039, 067 |

### 기타
- 빈 결과 케이스: 005, 029, 037, 041, 047, 053.
- 오류 응답 케이스: 006, 045, 049.
- 실저장 TC(042·043·063)는 저장 직전 대상 행을 기록하고, 시험이 끝나면 DB를 복원한다.
