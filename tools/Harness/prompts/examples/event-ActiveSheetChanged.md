# 예제 — event-ActiveSheetChanged (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §2 spdDetail / ActiveSheetChanged
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx:224-250`

```tsx

  // PlanDetail 외 2-sheet 는 read-only — 어떤 액션으로도 편집 UI 미노출 (03 §1)
  const isReadOnlySheet = (sheet: DetailSheet): boolean => sheet !== SHEETS.PLAN_DETAIL;

  return (
    <TabWrapper
      persist
      activeTabIndex={activeIndex}
      setActiveTabIndex={index => setActiveDetailSheet(DETAIL_SHEETS[index])}
    >
      {DETAIL_SHEETS.map(sheet => (
        <TabItem key={sheet} label={ADMIN_SHEET_NAME[sheet] ?? sheet}>
          <DataGrid
            gridRef={gridRefs[sheet]}
            gridFilterRef={gridFilterRefs[sheet]}
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? []}
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져 정적 컬럼의 단일 라벨이 그룹 헤더행+leaf
            //   행에 각각 찍혀 "같은 텍스트가 여러 줄"로 보인다(2단 헤더 StockDetail 신고 2026-10-11,
            //   memory datagrid-allowmerging-cells-breaks-header-merge). .All 이어야 헤더 병합(정적 컬럼
            //   세로 span)과 데이터 셀 병합(SO 그룹)이 둘 다 동작 — 메인 그리드와 동일.
            allowMerging={AllowMerging.All}
            gotFocus={() => setActiveGrid('detail')}
          />
```
