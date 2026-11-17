# SSP0012 업무분석서 — Shipment Plan Confirm Detail

> **작성 근거**: AsisFacts 정적 추출 Fact Pack(SSP0012)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)
> **작성 원칙**: Fact Pack에 있는 사실만 썼습니다. 추출되지 않은 내용은 **확인 필요**로 표기했습니다.
> **관련 문서**: 화면설계서 `screen_design.md` §5 액션 명세, 단위테스트 `unit_test.md` 근거 열. 세 문서의 엔드포인트 이름은 같습니다.

---

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SSP0012 | Fact Pack §1 |
| 클래스 | `SSP0012_ShipmentPlanConfirmDetail` | controls.csv |
| 폼 Text | `Shipment Plan Confirm` | props.csv Designer.cs:545 |
| 도메인 / 프로젝트 | SSP / `GSCM.SSP.Plan.UIL` | Fact Pack §1 |
| 업무 목적 | 선적계획 확정(Shipment Plan Confirm) 상세 데이터를 조건별로 조회합니다. | 엔드포인트명 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트명 `Shipment Plan Confirm Detail` |
| 업무 범위 | **조회 전용**입니다. 저장·삭제·업로드 엔드포인트는 추출되지 않았습니다. | Fact Pack §3 (활성 엔드포인트 3종이 모두 조회/코드 조회) |
| 업무 목적의 상세 정의 | 확정 데이터의 생성 주체, 확정 시점, 후속 업무 연계는 **확인 필요**입니다. | Fact Pack에 없음 |

**현행 엔드포인트 3종**

| # | 엔드포인트 | 구분 | SP |
|---:|---|---|---|
| 1 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 메인 조회 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| 2 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값 조회 | `SCM0001_GET_SCP_DAY_PERIOD` |
| 3 | `biz:CommonData.CommonDataList` | 공통코드 조회. 코드는 `LookupCommon`, `PERIOD_{p:value} \|\| PERIOD_DEFAULT` | (프레임워크 BIZ. 코드 분기는 `UP_FX_GetCommonDataList`) |

- 주석 처리된 호출 1건(595행)이 있습니다. 현행 기능이 아니므로 이 문서의 업무 범위·흐름·규칙에서 모두 뺐습니다.

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 메뉴에서 화면을 엽니다. | `Form_Load` > `InitControls` > `GetDayRange` 순으로 `SCP.SCM0001_GET_SCP_DAY_PERIOD`(SP `SCM0001_GET_SCP_DAY_PERIOD`)를 호출합니다. 그리드는 `CreateSpread`/`InitSpread` 에서 시트 `Shipment Plan Confirm Detail` 로 만들어집니다. | 기간(drpPeriod) 기본값이 들어갑니다(반영 방식은 **확인 필요**). 그리드 헤더는 2행이고 표시 컬럼은 44개입니다. | flow.csv, events.csv(.ctor:186), grid_code.csv |
| S2 | Division(clbDivision) 선택을 바꿉니다. | `clbDivision_SelectedIndexChanged` > `SetChangedControl` > `GetDayRange` 순으로 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 를 다시 호출합니다. `SetChangedControl:366` 에서 `GetCheckedListValue`(CODE)를 읽습니다. | 기간이 다시 계산됩니다(반영 값은 **확인 필요**). | flow.csv, events.csv(InitEvent:282), Fact Pack §4-2 |
| S3 | Model 검색 버튼(btnItemId)을 누릅니다. | `btnItemId_Click` 이 실행되고 341행에서 `txtItemId.Text = sItemId` 를 대입합니다. | Model 입력란에 값이 채워집니다. `sItemId` 를 얻는 방식(팝업 여부)은 **확인 필요**입니다. | events.csv(InitEvent:278), props.csv(:341) |
| S4 | 조회 조건을 넣고 조회(FindButton)를 누릅니다. | `FindButton` > `FindData_Main` 순으로 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`(SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`)를 호출합니다(418행). 398·399행에서 `GetCheckedListValue`(CODE)를 읽습니다. | 시트 `Shipment Plan Confirm Detail` 에 결과가 표시됩니다(바인딩 방식은 **확인 필요**). | flow.csv, endpoints.csv |
| S5 | 컬럼 버튼(btnColumn)을 누릅니다. | `BtnColumn_Click` 이 실행됩니다. | **확인 필요** (핸들러 본문 미추출) | events.csv(InitEvent:284) |
| S6 | 그리드 셀을 클릭합니다. | `SpdMain_CellClick` 이 실행됩니다. | **확인 필요**. 이미지 셀 `INCOTERMS`/`CHANGE_REQ_NO` 와의 관계도 **확인 필요**입니다. | events.csv(InitEvent:280), grid_code.csv(270·271) |
| S7 | 그리드를 스크롤합니다(상단 행이 바뀜). | `SpdMain_TopChange` 가 실행됩니다. | **확인 필요** | events.csv(InitEvent:277) |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  └─(1) Form_Load
        └─ InitControls ──(InitControls:237 c["CODE"] 사용)
              └─ GetDayRange ──▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
                                   └─ SP SCM0001_GET_SCP_DAY_PERIOD
                                        (SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL 조회)
        └─ CreateSpread → AddSheet("Shipment Plan Confirm Detail") → GetSheetInfo → ChangeSheet
        └─ InitSpread → InitSheet → SetSheetHeaderColumn(spdInfo, 2)  ※ 메타 SCM_MST_SHEET_COLUMNS
                      → INCOTERMS / CHANGE_REQ_NO CellType = cellTypeImage
        ※ CreateSpread/InitSpread 가 Form_Load 경로 안에서 호출되는지는 확인 필요

[조회조건 입력]
  ├─(2) Division 변경 → clbDivision_SelectedIndexChanged → SetChangedControl
  │        └─ GetCheckedListValue(CODE) → GetDayRange ──▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
  └─(3) Model 버튼 → btnItemId_Click → txtItemId.Text = sItemId

[조회]
  └─(4) FindButton → FindData_Main
        └─ GetCheckedListValue(CODE) ×2 (398, 399행)
        └─ ──▶ SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
                 └─ SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
                      (#TBLDYNAMICPIVOT_SSP0012 생성·조회, 동적 SQL, FN_GET_IN_STR, FN_SCM_SPLIT)
        └─ 시트 "Shipment Plan Confirm Detail" 표시

[그리드 조작]
  ├─(5) SpdMain_CellClick   — 동작 확인 필요
  ├─(6) SpdMain_TopChange   — 동작 확인 필요
  └─(7) BtnColumn_Click     — 동작 확인 필요

[진입점 미연결 (정적 분석상 호출자 없음)]
  ├─ <field:dtFcstType> (56행) ──▶ biz:CommonData.CommonDataList [code=LookupCommon]
  ├─ <field:dtBaseDay>  (57행) ──▶ biz:CommonData.CommonDataList [code=LookupCommon]
  └─ SetChangedPeriod  (542행) ──▶ biz:CommonData.CommonDataList [code=PERIOD_{p:value} || PERIOD_DEFAULT]
                                    → dt.Rows[0]["FROM_VALUE"], ["TO_VALUE"] (549·550행)
```

---

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 내용 | 근거 | 상태 |
|---:|---|---|---|---|
| R1 | 기간 기본값 | 화면을 열 때 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과로 기간을 정합니다. | flow.csv(Form_Load > InitControls > GetDayRange, 596행) | 사실 |
| R2 | Division 연동 기간 재계산 | Division 선택이 바뀌면 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 를 다시 호출합니다. 이때 CheckedList 선택값(CODE)을 읽습니다(366행). | flow.csv, Fact Pack §4-2 | 사실. 파라미터로 넘기는 값은 **확인 필요** |
| R3 | 기간 계산 기준 | SP `SCM0001_GET_SCP_DAY_PERIOD` 는 `SCM_SYS_CALENDAR_M`(달력), `SCM_ADM_LOOKUP_MASTER_DETAIL`(Lookup), `FN_WEEKOFDAY_DATE`, `FN_MULTY_TIME`, CTE `CTE_DATE` 를 참조합니다. | endpoints.csv objects | 참조 사실만 있음. 계산식(주차·버킷 규칙)은 **확인 필요** |
| R4 | 기간 필수 표시 | 기간 라벨이 `Period*` 입니다. 라벨에 `*` 필수 표시가 있습니다. | props.csv:453 | 표시 사실. 조회 전 필수값 검증 로직·메시지는 **확인 필요** |
| R5 | 다중 선택 조건 | 조회할 때 CheckedList 선택값(CODE)을 2곳(398·399행)에서 읽습니다. 대상 컨트롤(clbPlantSite / clbDivision 대응)은 **확인 필요**입니다. | Fact Pack §4-2 | 사실 + 확인 필요 |
| R6 | 다중값 분해 | 메인 SP가 `FN_GET_IN_STR`, `FN_SCM_SPLIT` 을 참조합니다. | endpoints.csv | 참조 사실. 어느 파라미터를 분해하는지는 **확인 필요** |
| R7 | 결과 동적 피벗 | 메인 SP가 `#TBLDYNAMICPIVOT_SSP0012` 를 만들고 조회하며 동적 SQL(`DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`)을 씁니다. | endpoints.csv | 사실. 피벗 축과 결과 컬럼은 **확인 필요** |
| R8 | 요일 버킷 컬럼 | 그리드 메타에 요일 컬럼 `DAYS_MON`~`DAYS_SUN`(7개)이 있습니다. | grid_effective.csv | 사실. 요일별 값의 의미(수량/여부)는 **확인 필요** |
| R9 | 기간 공통코드 분기 | `SetChangedPeriod` 는 `PERIOD_{값}` 코드를 쓰고, 없으면 `PERIOD_DEFAULT` 를 써서 `FROM_VALUE`/`TO_VALUE` 를 읽습니다. | endpoints.csv(542), meta_reads.csv(549·550) | 정적 분석상 호출자가 없습니다. 현행 동작인지 **확인 필요** |
| R10 | 그리드 표시 컬럼 | 메타 47개 중 44개를 표시합니다. 숨김 3개는 `BOD_ID`, `ORIGIN_FROM_DIVISION_ID`, `PLAN_QTY` 입니다. | grid_effective.csv | 사실 |
| R11 | 이미지 셀 | `INCOTERMS`, `CHANGE_REQ_NO` 의 CellType 은 `cellTypeImage` 입니다. | grid_code.csv(270·271) | 사실. 이미지 의미는 **확인 필요** |
| R12 | Model 입력 | Model 버튼 결과를 `txtItemId.Text` 에 넣습니다. | props.csv(:341) | 사실 |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기 (SELECT/REF) | 쓰기 | 비고 |
|---|---|---|---|---|---|
| `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | FindData_Main:418 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `#TBLDYNAMICPIVOT_SSP0012`(임시), FN `FN_GET_IN_STR`, FN `FN_SCM_SPLIT`, 동적 SQL | 영구 테이블 쓰기 없음. 임시 테이블 `#TBLDYNAMICPIVOT_SSP0012` 만 CREATE | 동적 SQL 안의 원천 테이블은 **확인 필요** |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:596 (Form_Load, clbDivision_SelectedIndexChanged 두 경로) | `SCM0001_GET_SCP_DAY_PERIOD` | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, CTE `CTE_DATE`, FN `FN_MULTY_TIME`, FN `FN_WEEKOFDAY_DATE` | 없음 | 공용 SP(SCP 영역) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtFcstType>`:56, `<field:dtBaseDay>`:57 | (BIZ) 코드 분기 `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | 없음 | 진입점 미연결. 사용처 **확인 필요** |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | SetChangedPeriod:542 | (BIZ) | 분기 테이블 **확인 필요** | 없음 | 진입점 미연결. 결과 컬럼 `FROM_VALUE`, `TO_VALUE` |

**메타 테이블(화면 ID가 값으로 들어 있는 행)**

| 메타 테이블 | 행 수 | 용도 |
|---|---:|---|
| `dbo.SCM_MST_SHEET_COLUMNS` | 47 | 그리드 컬럼 정의(`SetSheetHeaderColumn`) |
| `dbo.TB_FX_SearchCondition` | 46 | 조회조건 저장으로 보이나 내용은 **확인 필요** |
| `dbo.SCM_MST_TITLESET_USER` | 90 | **확인 필요** |
| `dbo.TB_FX_GroupMenuAuth` | 16 | 메뉴 권한 |
| `dbo.TB_FX_Favorite` | 12 | 즐겨찾기 |
| `dbo.TB_FX_MenuItemInfo` | 4 | 메뉴 정보 |
| `dbo.TB_FX_ProgramInfo` | 4 | 프로그램 정보 |
| `dbo.SCM_ADM_DB_SCRIPT_BACKUP` | 7 | DB 스크립트 백업 이력 |

---

## 6. Division·권한별 변형

| 항목 | 사실 | 근거 |
|---|---|---|
| 그리드 표시 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 **44개로 같습니다**. 필수+기본/선택 = 44/0 입니다. | Fact Pack §10·§12 |
| 코드 분기 | 코드 분기는 시트명 비교(`spdInfo.SheetName == "Shipment Plan Confirm Detail"`) 하나뿐입니다. division 변수를 비교하는 분기는 없습니다(판단불가 0건). | grid_code.csv |
| 사용자 division | `<field:dtMyDivision>`(48행)에서 `UserInfoContext.Current.NowGroupID` 를 읽습니다. | meta_reads.csv |
| Division 조건 | clbDivision 을 바꾸면 기간을 다시 계산합니다(R2). 기본 선택값이 사용자 division 인지는 **확인 필요**입니다. | flow.csv |
| 권한 C/R/U/D | `TB_FX_GroupMenuAuth` 에 16행이 있습니다. 그룹별 값은 미추출이므로 **확인 필요**입니다. 기능상 조회(R) 엔드포인트만 있습니다. | Fact Pack §8 |

---

## 7. 외부 인터페이스

- Fact Pack에서 외부 시스템(ERP·I/F 테이블·파일 연계) 호출은 추출되지 않았습니다.
- 그리드 컬럼 `ERP_SO_NO`(라벨 `SO No`)가 있습니다. 다만 ERP 연계 방식은 화면 기능 범위 밖이며 **확인 필요**입니다.

---

## 8. 미확정·확인 필요

| # | 항목 | 이유 |
|---:|---|---|
| 1 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 의 입력 파라미터, 동적 SQL 원천 테이블, 피벗 결과 컬럼이 메타 47컬럼과 맞는지 | SP 본문·파라미터 미추출 |
| 2 | `SCM0001_GET_SCP_DAY_PERIOD` 입력 파라미터(Division 등)와 반환 기간 규칙 | SP 본문 미추출 |
| 3 | `SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click` 동작 | 핸들러 본문 미추출 |
| 4 | `btnItemId_Click` 의 `sItemId` 출처(팝업 여부와 팝업 ID) | 341행 대입만 추출 |
| 5 | `dtFcstType`·`dtBaseDay`(LookupCommon) 코드값과 사용처 | 진입점 미연결 |
| 6 | `SetChangedPeriod` 의 현행 호출 여부와 `PERIOD_*` 분기 테이블 | 진입점 미연결, DB 보강 없음 |
| 7 | `GetCheckedListValue` 3곳(366/398/399)의 대상 컨트롤 | 줄 번호만 추출 |
| 8 | Period 필수 검증 메시지, 조회 0건 메시지 | 검증·메시지 코드 미추출 |
| 9 | 권한 메타 16행 내용 | 행 수만 추출 |
| 10 | 폼 Text `Shipment Plan Confirm` 과 클래스·시트명 `…Detail` 이 다른 데 따른 메뉴 표시명 | 메뉴 메타(`TB_FX_MenuItemInfo`) 내용 미추출 |
