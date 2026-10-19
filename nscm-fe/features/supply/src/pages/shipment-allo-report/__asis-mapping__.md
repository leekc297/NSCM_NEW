# SCP0055 Shipment(Allo) Report — AS-IS ↔ TO-BE 매핑

정본 소스: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0055_Shipment_Allo_Report/`(.cs 1,486줄 + .Designer.cs).
설계 문서: `.atlas/gscm-design/SCP0055/design/00_checklist.md` ~ `03_grid-columns.md`.

## validations 10건 매핑 (`00_checklist.md §6` 대사)

| # | AS-IS 근거 | 트리거 | TO-BE 구현 |
|---|---|---|---|
| 1 | `FindData_Main` 사전검증 — Period From>To | Search 클릭 | `ShipmentAlloReport.tsx validateBeforeSearch` — MSG00344 alert |
| 2 | `FindData_Main` 사전검증 — PlanDate<GapDate | Search 클릭 | 동 함수 — MSG00345 alert |
| 3 | `FindData_Main` 사전검증 — PlanDate=GapDate | Search 클릭 | 동 함수 — MSG00348 alert |
| 4-8 | `GMessageBoxForException`(공통 예외처리 5건) | SP 호출 실패 시 | `useTabProcQuery`/`useProcMutation` 표준 alert 배선(`setAlert`) — 화면 로컬 구현 불필요, 공용 훅이 처리 |
| 9 | `SaveData_Main` 저장건수 안내 | Save 성공 | `handleSave` onSuccess — MSG00004 toast |
| 10 | `ExcelButton` 확인창 | Excel 클릭 | `handleExcel` — MSG00100 confirm. **확인 필요**: 공용 `setAlert({type:'confirm'})` 는 2-way(예/취소)이나 AS-IS 는 Yes/No/Cancel 3-way(No=저장 없이도 export). No 분기는 이번 회차에서 Yes 분기로 단순화했다 — 04_react-gap.md 정직 보고 대상. |

## 버튼 4종 (`00_checklist.md §4d`)

| AS-IS | TO-BE |
|---|---|
| FindButton(Search) | `hotkeyConfig.search` = `handleSearch` |
| EditButton(Edit) | 커스텀 버튼(`hasButton('EDIT')` 게이팅) = `handleToggleEdit` — `fps != null` 가드는 `hasSearchResult` |
| SaveButton(Save) | `hotkeyConfig.save` = `handleSave` |
| ExcelButton(Excel) | `hotkeyConfig.excel` = `handleExcel` |

## no-op 핸들러 (재현 불필요, `00_checklist.md §5.3`)

- `cboBucketType_SelectedIndexChanged` → 미배선(BucketType 고정 disabled 이라 이벤트 자체 미도달)
- `CboPlanDate_SelectedIndexChanged`(L431) → 미배선(division 조회만 하고 AS-IS 도 미사용)
- `clbTeam_SelectedIndexChanged` → 미배선(division 조회만 하고 AS-IS 도 미사용)
- `SpdMain_CellDoubleClick` → 미배선(본문 공백)
- `usrButton1` → 대응 컴포넌트 생성 안 함(design 01_layout.md §5-6 이식 제외 확정)

## 확인 필요 항목 (04_react-gap.md 로 인계)

domain 확정 근거, `clbTeam`/`cboBucketType` 대응 SQL_ID 미확정, Excel Yes/No/Cancel 3-way 단순화,
`PKG_SCP0055` MISSING(convert-sp 후속), 팀명 공백 행 비고 배경색 의도(잠금 아님 vs 미완성) 등은
`04_react-gap.md`에 상세 기록한다.
