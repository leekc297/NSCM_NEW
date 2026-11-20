# 예제 — event-Change (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §2 spdMain / Change
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx:320-346`

```tsx
        editableRef.current,
        activeSpanRef.current,
        curPlanDateRef.current
      );
    };
    g.pastingCell.addHandler(pastingCellHandler);

    const onEdited = () => {
      onCellEditedRef.current?.();
    };
    g.cellEditEnded.addHandler(onEdited);
    g.pastedCell.addHandler(onEdited);

    // 활성 그리드 전환 — 프레임워크 parity(BaseForm.FpSpread_CellClick 무조건 전환)
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
```
