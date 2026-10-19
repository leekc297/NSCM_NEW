# 예제 — event-EditChange (2건 중 2)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §2 spdDetail / EditChange
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx:127-172`

```tsx
    g.formatItem.addHandler(formatItemHandler);

    // 파생/전파 (03 §3.2):
    //   - CHANGE_REASON_DETAIL: CODE 가 '-'/공백이면 입력 되돌림 + MSG01291
    //   - CHANGE_REASON_CODE: '-'/공백이면 DETAIL 클리어(SO 공백이면 EDIT_MAIN 세팅 없이 종료)
    //   - SO그룹 전파: ERP_SO_NO 비공백 시 동일 SO 全행 전파 + EDIT_MAIN='Y'
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!propagateSet.has(binding) && binding !== 'CHANGE_REASON_CODE' && binding !== 'CHANGE_REASON_DETAIL')
        return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const value = row[binding];
      const soNo = str(row.ERP_SO_NO).trim();

      if (binding === 'CHANGE_REASON_DETAIL') {
        const code = str(row.CHANGE_REASON_CODE).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          void setAlert({
            type: 'alert',
            content: t(MSG.REASON_CODE_FIRST, '__Please enter Reason Code.'),
          });
          sender.collectionView?.refresh();
          return;
        }
      }

      if (binding === 'CHANGE_REASON_CODE') {
        const code = str(value).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          if (soNo === '') {
            sender.collectionView?.refresh();
            return;
          }
        }
      }

      // SO 그룹 전파 대상 컬럼(TRANSPORT_MODE/DOM_EXP/FACTORY_ID/PACKAGE_TYPE) 또는 CHANGE_REASON.
      if (!propagateSet.has(binding) && binding !== 'CHANGE_REASON_CODE') {
        sender.collectionView?.refresh();
        return;
      }

      row.EDIT_MAIN = 'Y';
```

## SCP0041 · §2 spdMain / EditChange
- 위치: `features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx:78-110`

```tsx
    const onEnding = (sender: FlexGrid, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!DATE_COLS.includes(binding)) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      prevValue = row ? row[binding] : undefined;
    };
    const onEnded = (sender: FlexGrid, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!DATE_COLS.includes(binding)) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (isReversed(row)) {
        row[binding] = prevValue; // 편집 전 값으로 원복
        sender.invalidate();
        onReversed(row);
      }
    };
    g.cellEditEnding.addHandler(onEnding);
    g.cellEditEnded.addHandler(onEnded);
    return () => {
      g.cellEditEnding?.removeHandler(onEnding);
      g.cellEditEnded?.removeHandler(onEnded);
    };
  }, [gridRef, rows, isReversed, onReversed]);

  // R4 표기 보조 — 저장 재검증 실패행 LightPink. AS-IS BackColor(cs BackColor=LightPink).
  //   DataGrid 는 formatItem prop 미노출이라 셀 DOM 에 직접 세팅(scp-bom/long-term-stock 선례).
  //   판정은 현재 행 데이터의 역전 여부로 재계산 — 저장 실패 후에도 사용자가 고치면 자동 해제.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
```
