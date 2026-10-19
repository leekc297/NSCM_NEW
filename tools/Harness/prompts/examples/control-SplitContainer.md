# 예제 — control-SplitContainer (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §1 splitContainer1 / SplitContainer
- 위치: `features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx:405-450`

```tsx
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanElectrodeForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanElectrode'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (01 §1, 비율 6:4) */}
      <div className={styles.gridArea}>
        <div className={styles.mainGrid}>
          {/* 단일 master 그리드 — 시트가 1개뿐이라 시트명 탭을 두지 않고 그리드를 직접 렌더한다(사용자 결정 2026-10-11).
              BOH 3-radio(UOM Type) / Sum / Past Period 토글은 조회조건 영역(Form extraConditions)으로
              이전 — AS-IS usrConditionPanel1 영역2 복원(01 §1). 재조회 없이 컬럼 표시규칙만 전환(03 §2.2). */}
          <ShipmentPlanElectrodeMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[SHEETS.MAIN]}
            bucketType={sc.bucketType}
            bohRadio={sc.bohRadio}
            chkSum={sc.chkSum}
            chkPastPeriod={sc.chkPastPeriod}
            editable={mainEditable}
```
