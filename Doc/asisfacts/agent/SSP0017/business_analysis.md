# SSP0017 업무분석서 — Inventory Raw(Small)

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0017), 1차 분석서(analysis.md · web_components.md · tobe_design.md).
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 소스에서 주석 처리된 호출 3건(줄 513·531·532)은 현행 기능이 아니므로 이 문서에서 다루지 않습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0017 / `SSP0017_InventoryRaw` | controls.csv |
| 화면 명칭 | `Inventory Raw(Small)` | props.csv `this.Text` (Designer.cs:589) |
| 도메인 | SSP (`GSCM.SSP.Plan.UIL`) | 파일 구성 |
| 업무 목적 | 조회조건(Plan-date, Division, Plant Site, Inventory Type, Model)으로 재고 Raw 데이터를 조회해 Grid에 표시합니다. SP `SSP0017_GET_INVENTORY_RAW`가 `SSP_ANL_INVENTORY_RAW`를 SELECT합니다. | endpoints.csv |
| 범위 | **조회 전용**입니다. 활성 엔드포인트는 모두 조회(GET / CommonDataList)이고, 저장·삭제 계열 호출은 추출되지 않았습니다. | endpoints.csv |
| 범위 밖 | 주석 처리된 호출 3건(Fact Pack §9) | commented_calls.csv |
| 업무 상세 목적(재고 분석 용도, 사용 부서) | **확인 필요** | Fact Pack에 없음 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` → `InitControls`(:176 `clbDivision.Enabled=false`, :179 `biz:CommonData.CommonDataList` [code=LookupCommon]) → `SetChangedControl`(:365 `biz:CommonData.CommonDataList` [code=PlanDateShip]) | 조회조건 콤보에 공통코드가 채워지고, Division 체크리스트는 비활성 상태가 됩니다. [LookupCommon]이 채우는 컨트롤은 **확인 필요**입니다. | flow.csv, props.csv |
| S2 | Division 선택값이 바뀝니다 | `clbDivision_SelectedIndexChanged` → `SetChangedControl`(:350 `GetCheckedListValue` → :365 `biz:CommonData.CommonDataList` [code=PlanDateShip]) | Plan-date 목록이 다시 조회됩니다(Division 값이 파라미터로 쓰이는지는 **확인 필요**). `clbDivision`이 비활성이므로 이 이벤트가 어떤 경로로 발생하는지도 **확인 필요**입니다. | flow.csv, events.csv |
| S3 | Model 옆 버튼(`btnItemId`)을 누릅니다 | `btnItemId_Click` → :301 `txtItemId.Text = sItemId` | Model 입력란에 값(`sItemId`)이 채워집니다. `sItemId`를 어떻게 얻는지(팝업 여부)는 **확인 필요**입니다. | props.csv |
| S4 | `btnMeasure` 버튼을 누릅니다 | `btnMeasure_Click` (추출된 엔드포인트 없음) | **확인 필요** | events.csv |
| S5 | 조회(Find) 버튼을 누릅니다 | 프레임워크 `FindButton` → `FindData_Main`(:386·387·389·390 `GetCheckedListValue`) → :405 `SSP.SSP0017_GET_INVENTORY_RAW` | Grid 시트 `Inventory Raw(Mobility & IT)`에 결과가 표시되고 컬럼 푸터(합계 행)가 보입니다. | flow.csv, grid_code.csv, props.csv:217 |
| S6 | Grid를 세로로 스크롤합니다 | `SpdMain_TopChange` (추출된 엔드포인트 없음) | **확인 필요** | events.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (this.Load → Form_Load)
     └─ InitControls
          ├─ clbDivision.Enabled = false            (:176)
          ├─ biz:CommonData.CommonDataList [LookupCommon]   (:179)
          └─ SetChangedControl
               └─ biz:CommonData.CommonDataList [PlanDateShip] (:365)
     └─ CreateSpread → AddSheet "Inventory Raw(Mobility & IT)" (:188) → GetSheetInfo(:189) → ChangeSheet(:191)
     └─ InitSpread → InitSheet(:200) → SetSheetHeaderColumn(spdInfo, 1)(:202)  ※ 메타 기반 컬럼 생성
     └─ InitSpreadFooterSum → ColumnFooter.Visible = true (:217)
     └─ InitEvent → 이벤트 배선 (:243~:247)
[2] (선택) Division 변경 → clbDivision_SelectedIndexChanged → SetChangedControl → [PlanDateShip] 재조회
[3] (선택) btnItemId 클릭 → btnItemId_Click → txtItemId.Text = sItemId
[4] (선택) btnMeasure 클릭 → btnMeasure_Click (동작 확인 필요)
[5] 조회 → FindButton → FindData_Main → SSP.SSP0017_GET_INVENTORY_RAW → Grid 표시
[6] (선택) Grid 스크롤 → SpdMain_TopChange (동작 확인 필요)
```

진입점이 연결되지 않은 호출(정적 파서가 호출자를 찾지 못함):
- `GetDivision`(:478) → `SCM.SCM0001_GET_DIVISION`
- `GetDayRange`(:514) → `SCP.SCM0001_GET_SCP_DAY_PERIOD`
- `<field:dtInventoryStatus>`(:49) → `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] (필드 초기화식이므로 클래스 생성 시 실행될 수 있으나 **확인 필요**)

## 4. 업무 규칙

| # | 규칙 | 내용 | 근거 | 확정 여부 |
|---:|---|---|---|---|
| R1 | 필수값 | `Plan-date*` 라벨에 `*`가 있으므로 필수 표시입니다. 미입력 시 검증 메시지 로직은 추출되지 않았습니다. | props.csv:465 | 표시는 확정 / 검증 로직은 **확인 필요** |
| R2 | Division 입력 제한 | `clbDivision.Enabled = false`이므로 사용자가 Division을 직접 바꿀 수 없습니다. | props.csv:176 | 확정 |
| R3 | Division 기본값 | `dtMyDivision` 필드가 `UserInfoContext.Current.NowGroupID`를 읽습니다. 로그인 사용자 그룹 기반으로 Division을 정하는 것으로 보이나 실제 반영 방식은 **확인 필요**입니다. | meta_reads.csv:46 | **확인 필요** |
| R4 | Plan-date 연동 | Plan-date 목록은 `biz:CommonData.CommonDataList` [code=PlanDateShip]로 조회합니다. 화면 진입 시와 Division 변경 시 갱신됩니다. 공통 BIZ `UP_FX_GetCommonDataList`의 해당 코드 분기는 `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V`를 SELECT하고 `STRING_SPLIT`을 참조합니다. | flow.csv, endpoints(DB 보강) | 확정 |
| R5 | 다중 선택 값 전달 | `FindData_Main`에서 `GetCheckedListValue`를 4회(:386·387·389·390) 호출해 체크 리스트의 `CODE` 값을 추출합니다. 어떤 컨트롤 → 어떤 SP 파라미터로 가는지는 **확인 필요**입니다. SP는 `UF_FX_STRING_SPLIT`을 참조하므로 다중 값이 구분자 문자열로 넘어갈 가능성이 있지만, 이 역시 **확인 필요**입니다. | Fact Pack §4-2, endpoints.csv | **확인 필요** |
| R6 | 날짜 변환 | SP `SSP0017_GET_INVENTORY_RAW`는 `FN_CHAR_TO_DATE`를 참조합니다(문자 → 날짜 변환). 어느 파라미터나 컬럼에 적용되는지는 **확인 필요**입니다. | endpoints.csv | **확인 필요** |
| R7 | SP 내부 분기 조건 | SP 본문 분기 조건은 Fact Pack에 없습니다. | — | **확인 필요** |
| R8 | 날짜/버킷 규칙 | `SCM0001_GET_SCP_DAY_PERIOD`는 `SCM_SYS_CALENDAR_M`, `FN_WEEKOFDAY_DATE`, `FN_MULTY_TIME`, `CTE_DATE`를 사용합니다. 다만 이 화면에서는 호출자가 미연결(`GetDayRange`)이라 현행 규칙으로 쓰이는지 **확인 필요**입니다. | flow.csv | **확인 필요** |
| R9 | Grid 컬럼 | `SCM_MST_SHEET_COLUMNS` 메타로 컬럼을 생성합니다(컬럼헤더 1행). 현행 시트 `Inventory Raw(Mobility & IT)`는 메타 31개 중 27개를 표시하고 4개(`LONG_QTY`, `OPERATION_NAME`, `ROUTE_NAME`, `ROUTE_TYPE`)를 숨깁니다. | grid_code.csv:202, grid_effective.csv | 확정 |
| R10 | 합계 행 | 컬럼 푸터를 표시합니다(`ColumnFooter.Visible = true`). 합계 대상 컬럼은 **확인 필요**입니다. | props.csv:217 | 표시는 확정 / 대상은 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 이 표의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 근거 열과 같은 표기를 씁니다.

| # | 엔드포인트 | 호출 메서드(줄) | 진입점 | SP / 처리 | 읽기(SELECT) | 참조 함수 | 쓰기 |
|---:|---|---|---|---|---|---|---|
| D1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | `InitControls`(179) | `Form_Load` | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | — | 없음 |
| D2 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | `SetChangedControl`(365) | `Form_Load`, `clbDivision_SelectedIndexChanged` | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V` | `STRING_SPLIT` | 없음 |
| D3 | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | `<field:dtInventoryStatus>`(49) | 미연결(필드 초기화) | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER_DETAIL` | — | 없음 |
| D4 | `SSP.SSP0017_GET_INVENTORY_RAW` | `FindData_Main`(405) | `FindButton` | SP `SSP0017_GET_INVENTORY_RAW` | `SSP_ANL_INVENTORY_RAW`, `SCM_MST_ITEM_SN`, `SCM_MST_FACTORY_SN`, `SCM_MST_SLOC`, `SCM_MST_SITE` | `FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT` | 없음 |
| D5 | `SCM.SCM0001_GET_DIVISION` | `GetDivision`(478) | 미연결 | SP `SCM0001_GET_DIVISION` | `SCM_MST_DIVISION` | — | 없음 |
| D6 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `GetDayRange`(514) | 미연결 | SP `SCM0001_GET_SCP_DAY_PERIOD` | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE` | `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE` | 없음 |

- 쓰기(INSERT/UPDATE/DELETE/MERGE) 대상 테이블은 6개 엔드포인트 모두에서 추출되지 않았습니다.
- 엔드포인트별 입력 파라미터 목록과 결과셋 컬럼은 Fact Pack에 없습니다(**확인 필요**).

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Grid 컬럼(Division별) | Division 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 14개 모두 표시 27개(필수+기본 27 / 선택 0)로 같습니다. **Division별 변형은 없습니다.** | grid_effective.csv, Fact Pack §10·§12 |
| 시트 | `Inventory Raw(Mobility & IT)` = META+코드연결(현행) / `Inventory Raw(IT & Mobile)` = 메타 정의만, 코드 미참조(미사용 가능) | grid_effective.csv |
| 코드상 Division 분기 | 분기 조건 판단불가 0건이며, 코드에서 Division 비교 분기는 추출되지 않았습니다. | Fact Pack §12 |
| Division 조회조건 | `clbDivision` 비활성(:176), 기본값 출처는 `NowGroupID`로 보임(**확인 필요**) | props.csv, meta_reads.csv |
| 권한 메타 | `TB_FX_GroupMenuAuth` 14행, `TB_FX_MenuItemInfo` 2행, `TB_FX_ProgramInfo` 2행. 그룹별 C/R/U/D 플래그 값은 **확인 필요**(원문 `dbmeta_dbo_TB_FX_GroupMenuAuth.csv`) | Fact Pack §8 |
| 코드상 권한 분기 | 추출되지 않았습니다. | — |

## 7. 외부 인터페이스

- Fact Pack에서 외부 시스템 인터페이스(I/F) 호출은 추출되지 않았습니다.
- 참고: [code=OWMS_STOCK_STATUS] 공통코드 이름에 `OWMS`가 들어 있고, `SSP_ANL_INVENTORY_RAW`의 적재 원천도 있습니다. 하지만 외부 시스템과 어떤 관계인지(적재 배치 등)는 Fact Pack에 없어 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 사유 |
|---:|---|---|
| 1 | `GetDivision` → `SCM.SCM0001_GET_DIVISION`(SP `SCM0001_GET_DIVISION`) 실사용 여부 | 진입점 미연결 |
| 2 | `GetDayRange` → `SCP.SCM0001_GET_SCP_DAY_PERIOD`(SP `SCM0001_GET_SCP_DAY_PERIOD`) 실사용 여부 | 진입점 미연결 |
| 3 | `dtInventoryStatus` [code=OWMS_STOCK_STATUS]의 사용처 | 바인딩 대상 미추출 |
| 4 | [code=LookupCommon]이 채우는 컨트롤 | 대상 미추출 |
| 5 | `clbPlantSite`, `cboInventoryType` 데이터 출처 | 엔드포인트 미추출 |
| 6 | `FindData_Main`의 `GetCheckedListValue` 4회 ↔ SP `SSP0017_GET_INVENTORY_RAW` 파라미터 매핑 | 파라미터 미추출 |
| 7 | SP `SSP0017_GET_INVENTORY_RAW` 내부 분기·필터 조건과 결과셋 컬럼 | SP 본문 미추출, grid 단계 매칭 시트 없음 |
| 8 | `btnItemId_Click`의 `sItemId` 취득 방식, `btnMeasure_Click`·`SpdMain_TopChange`의 동작 | 엔드포인트 호출 미추출 |
| 9 | `clbDivision.Enabled=false` 상태에서 `clbDivision_SelectedIndexChanged`가 발생하는 경로 | 정적 추출 한계 |
| 10 | `Plan-date*` 미입력 시 검증·메시지 | 검증 로직 미추출 |
| 11 | 푸터 합계 대상 컬럼 | `InitSpreadFooterSum` 세부 미추출 |
| 12 | 그룹별 C/R/U/D 플래그 | 행 수만 있음 |
| 13 | `Inventory Raw(IT & Mobile)` 메타 시트를 폐기할지 여부 | 코드 미참조 |
| 14 | `TB_FX_SearchCondition` 8행(조회조건 저장/복원)의 내용 | 행 수만 있음 |
