# 예제 — event-KeyDown (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0106 · §2 spdMain / KeyDown
- 위치: `features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx:239-265`
- 비고: 행 삭제도 DBNull 도 아니라 **0.0 기입**이다(03 R-16, V-54). 변경은 EditTracker 에 기록해 `CRUD_TYPE='M'` 을 얻는다

```tsx

    /**
     * (g) `Delete` 키 = 선택 범위에 **`0.0` 일괄 기입**(행 삭제도 DBNull 도 아니다) + `Ctrl+Z` 차단
     * (R-16, V-54). 편집 가능한 셀만 대상이며 변경은 `EditTracker` 에 기록해 `CRUD_TYPE='M'` 을 얻는다.
     * CommonCheckList 의 "Delete 키 행 삭제" 항목은 이 화면에서 **해당 없음**이다.
     */
    const keyDownHandler = (event: KeyboardEvent) => {
      if (event.ctrlKey && (event.key === 'z' || event.key === 'Z')) {
        event.preventDefault();
        return;
      }
      if (event.key !== 'Delete') return;
      if (!editModeRef.current) return;
      const sender = grid;
      const selection = sender.selection;
      if (!selection) return;
      event.preventDefault();
      const tracker = editTrackerRef.current;
      for (let rowIndex = selection.topRow; rowIndex <= selection.bottomRow; rowIndex += 1) {
        const row = sender.rows[rowIndex]?.dataItem as Scp0106Row | undefined;
        if (!row) continue;
        for (let colIndex = selection.leftCol; colIndex <= selection.rightCol; colIndex += 1) {
          const binding = sender.columns[colIndex]?.binding ?? '';
          if (!binding || !canEdit(binding, row)) continue;
          const previousValue = row[binding];
          if (previousValue === 0) continue;
          row[binding] = 0;
```
