# 예제 — event-CellChanged (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0041 · §2 ActiveSheet / CellChanged
- 위치: `features/supply/src/pages/stock-osp/components/PackHoldStockGrid.tsx:68-111`

```tsx
    g.beginningEdit.addHandler(handler);
    return () => g.beginningEdit?.removeHandler(handler);
  }, [gridRef, rows]);

  // R3 — 날짜역전 검증+원복. 예측 시작/종료 편집 종료 시 start>finish 면 편집 전 값으로 되돌리고 alert.
  //   cellEditEnded 시점엔 이미 새 값이 반영되므로, 편집 진입값을 cellEditEnding 에서 보관해 원복한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    let prevValue: unknown;
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
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
```
