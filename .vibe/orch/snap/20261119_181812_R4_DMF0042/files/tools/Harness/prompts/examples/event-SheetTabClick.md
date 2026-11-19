# 예제 — event-SheetTabClick (2건 중 2)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §2 spdDetail / SheetTabClick
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

## SCP0041 · §2 spdMain / SheetTabClick
- 위치: `features/supply/src/pages/stock-osp/StockOspPage.tsx:98-124`

```tsx
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    // 활성 탭 시트만 조회(hook #97 — 공통 버튼 활성 탭 라우팅).
    setFilter(activeSheet);
    void fetchStaticColumns([activeSheet]);
  };

  // 탭 전환 — 활성 탭 라우팅. 편집 pending 은 보존(파기 아님). 자동 재조회 없음(Search 버튼만).
  const handleTabChange = (index: number) => {
    setActiveTab(index as TAB_INDEX);
  };

  // R3 역전 원복 후 별도 저장검증 필요 없음(그리드가 값 원복). onReversed 는 alert 만 담당.
  const onReversed = useCallback(() => {
    void setAlert({ type: 'alert', content: t(MSG.DATE_REVERSAL, '_시작일이 종료일보다 클 수 없습니다.') });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const doSave = async (dirty: Record<string, unknown>[]) => {
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const payload = buildSavePayload(dirty, userId);
      if (!payload) return;
      const result = await callSavePack(payload);
      if (result.ok) {
```
