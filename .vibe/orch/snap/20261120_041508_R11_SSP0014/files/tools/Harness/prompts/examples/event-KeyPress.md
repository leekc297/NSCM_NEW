# 예제 — event-KeyPress (2건 중 2)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0024 · §2 spdMain / KeyPress
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx:81-107`

```tsx
    });
    return m;
  }, [postOperLookup]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 게이트 — 모드×행상태 판정(editLock). MATERIAL_ID 는 팝업 전용이라 인라인 편집 취소(nscm-patterns §5-16).
    //   공용 DataGrid defaultEditHandler(INPUT_TP_CD='S')가 먼저 cancel 하고, 화면이 나중 실행돼 최종 재지정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const editable = isInlineEditable(binding, row, isEditMode);
      // DIVISION_ID 가 비면 그 행의 다른 칸은 편집 불가(AS-IS CellClick cs:541~546 — MSG00093 "Division").
      //   직전 구현은 MATERIAL 팝업 경로에만 이 가드가 있었다(gap-resolve iter-1 G7). 편집 가능했을 셀에서만
      //   알려 잠긴 셀 클릭마다 알림이 뜨지 않게 한다.
      if (editable && binding !== 'DIVISION_ID' && !str(row?.DIVISION_ID)) {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
        });
        return;
```

## SCP0033 · §2 spdMain / KeyPress
- 위치: `features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx:91-117`
- 비고: -

```tsx
    g.formatItem.addHandler(formatItemHandler);

    // 편집 게이트(design 03 §3.1) — 조회직후 전잠금(editMode=false) / Edit=기존행 DEPARTURE_DAY·VALID_YN /
    //   신규행('I')=DIVISION_ID/ITEM_ID/DEPARTURE_DAY/VALID_YN. ITEM_ID 는 팝업 전용이라 인라인 편집 취소.
    //   공용 DataGrid defaultEditHandler(INPUT_TP_CD='S')가 먼저 cancel, 화면이 나중 실행돼 최종 재지정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 신규행 DIVISION 미선택 상태에서 ITEM_ID 편집/팝업 시도 시 차단 + 안내(design 03 §3.4 cs:463 MSG00093).
      if (isDivisionRequired(binding, row)) {
        e.cancel = true;
        onDivisionRequired();
        return;
      }
      e.cancel = !isInlineEditable(binding, row, editModeRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // ITEM_ID 셀 더블클릭 -> SCM0002 Item 팝업(design 03 §3.4). 신규행 + 편집가능 + DIVISION_ID 있을 때만.
    //   직접 키입력은 beginningEdit 이 차단(팝업 전용, cs:440 KeyPress e.Handled).
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
```
