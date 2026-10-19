# 예제 — event-Click (24건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 btnColumn / Click
- 위치: `features/demand/src/pages/dmf0045/ShipmentRequest.tsx:367-393`

```tsx
      for (let i = 0; i < g.rows.length; i++) {
        if (g.rows[i]?.dataItem !== target) continue;
        g.select(i, Math.max(0, g.selection.col));
        g.scrollIntoView(i, -1);
        break;
      }
    }
    // addRowSet 은 setState 를 호출하지 않으므로 강제 리렌더 — rows(=spRows) 재계산 유도.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — AS-IS DeleteButton 1:1 — Action='I'(신규 삽입행)만 즉시 제거. DB 조회행 무동작(silent).
  //   저장행 삭제는 셀 0 저장(SP 'D' 전환) 경로만 — 여기서는 신규행만.
  const handleDelete = () => {
    if (isPending) return;
    const g = gridRef.current;
    if (!g) return;
    GridAction.removeRow(g as unknown as FlexGridType<WijmoRowItem>, true, true);
    forceGridRerender(v => v + 1);
  };

  // SubTitle 공통버튼 — 미명시(sort/filter/condition/resetCondition/excel)는 DefaultButtonActions 자동.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
```

## SSP0019 · §2 btnItemId / Click
- 위치: `features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx:151-177`
- 비고: onOpenModelPopup → ItemByDivisionModal 오픈(division/scmSite/itemId 사전필터)

```tsx
  // 읽기전용 조회 — SEARCH 만 실동작. Insert/Delete/Edit/Save 는 AS-IS NO-OP(design 01 §2 #3~6, §4d):
  //   admin 버튼메타에 미등록(hasButton=false)이라 미노출. false 사용 근거는 __asis-mapping__.md(화면별 확정 = 읽기전용).
  //   키 생략 금지(공용 addRow/removeRow 되살아남) — 명시적으로 false.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeHistoryForm
          onSearch={handleSearch}
          onOpenModelPopup={() => setModelPopupOpen(true)}
        />
      )}
      <SubTitle
```

## SSP0024 · §2 btnMaterialId / Click
- 위치: `features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx:429-455`

```tsx
          editTrackerRef={editTrackerRef}
          division={confirmedDivision || sc.divisionId}
          isEditMode={isEditMode}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onMaterialCellDblClick={handleMaterialCellDblClick}
          onFocus={() => undefined}
        />
      </div>

      {/* 조회조건 Material 검색 팝업 (SSP0024 전용 — 다중 선택, MaterialId 채움). */}
      <ItemByDivisionModal
        open={openMaterial}
        modalClose={() => setOpenMaterial(false)}
        setSelectedValue={handleMaterialSelected}
        preSearchParams={{
          divisionId: sc.divisionId,
          plantSiteId: sc.scmSiteIds.join(','),
          materialId: sc.materialId,
        }}
        callFromCell={false}
      />

      {/* 조회조건 Model 검색 팝업 (SSP0024 전용 — 다중 선택, ModelId 채움). */}
      <ItemByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={handleModelSelected}
```
