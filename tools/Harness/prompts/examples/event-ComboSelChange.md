# 예제 — event-ComboSelChange (4건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 spdMain / ComboSelChange
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:498-524`
- 비고: AS-IS 인셀 콤보 선택변경 = TO-BE cellEditEnded(편집확정)로 흡수

```tsx
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
      if (editedKind) {
        const measure = toCellStr(row.MEASURE);
        // MEASURE 빈 행 숫자 입력 롤백 (measure 없는 행은 값 셀이 무의미).
```

## SSP0024 · §2 spdMain / ComboSelChange
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx:104-130`

```tsx
          type: 'alert',
          content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
        });
        return;
      }
      e.cancel = !editable;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 — 공용 DataGrid 는 pastingCell 에도 defaultEditHandler(INPUT_TP_CD 기준)를 건다
    //   (packages/shared/.../dataGridUtils.ts:372). 이 화면은 INPUT_TP_CD 가 전건 'S'(SEARCH_ONLY)라
    //   그대로 두면 **모든 붙여넣기가 취소**되고, 그 결과 아래 pastedCell 파생·클리어가 영영 실행되지
    //   않는다(AS-IS ClipboardPasted cs:659~727 미구현). beginningEdit 과 같은 방식으로 editLock 이
    //   최종 판정하도록 재지정한다.
    //   인라인 편집과 달리 MATERIAL_ID 도 붙여넣기 대상이다 — AS-IS 는 KeyPress(cs:646~657)로 키입력만
    //   막고 신규행 LockRange(cs:385~389)에 MATERIAL_ID 를 넣지 않는다. 그래서 isInlineEditable 이 아니라
    //   isCellEditable 을 쓴다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !isCellEditable(binding, row, isEditMode);
    };
    g.pastingCell.addHandler(pastingCellHandler);

```

## SSP0023 · §2 spdDetail / ComboSelChange
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
