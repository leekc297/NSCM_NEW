# 예제 — event-KeyUp (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 spdMain / KeyUp
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:495-521`
- 비고: AS-IS KeyUp Ctrl+C/V = TO-BE Wijmo autoClipboard + pastingCell/pastedCell 훅으로 흡수

```tsx
      if (dynKindOf(binding)) {
        const state = evalShipmentDynCell({
          binding,
          row,
          bucketType,
          dOrderedDayBindings: dOrderedDayBindingsRef.current,
        });
        e.cancel = !state.editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기 게이트 — 편집 가드와 동일 판정.
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ===== 편집 종료 — 동적 셀 정수 절삭 + EditTracker 재판정 =====
    const cellEditEndedHandler = (
      s: FlexGridType<ShipmentRequestRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as ShipmentRequestRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;

      // 동적 셀 — 값 정규화(정수 절삭 — 저장은 D_ 정수. design 03 §2.4) + EditTracker 재판정.
      const editedKind = dynKindOf(binding);
```
