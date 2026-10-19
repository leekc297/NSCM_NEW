# 예제 — control-SimpleButton (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0023 · §1 btnSearch / SimpleButton
- 위치: `features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx:362-388`

```tsx
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return; // 읽기전용 2-sheet — 신규행 없음
    const g = planDetailGridRef.current;
    if (!g) return;
    const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
      | Record<string, unknown>
      | undefined;
    if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4)
    // 원본 행 STATUS 게이트 — 공백은 'C' 간주 허용(AS-IS InsertRow).
    const status = str(source.SHIPMENT_STATUS).trim() || 'C';
    if (status !== 'C') return;
    // 복사 필드는 AS-IS defaultData 명시 목록만(전 필드 스프레드 복사 금지 — 03 §3.2).
    const copied: Record<string, unknown> = {};
    PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
      copied[col] = source[col];
    });
    copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제
    copied.ERP_STATUS = ''; // 항상 공백 강제
    GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
  };

  // ── Measure (btnMeasure) — spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return; // 경고 없이 조용히 return
    setOpenMeasure(true);
  };

  // ── hotkeyConfig (00 §4d/01 R10 — hasButton 조건부, 재판단 금지) ──
```
