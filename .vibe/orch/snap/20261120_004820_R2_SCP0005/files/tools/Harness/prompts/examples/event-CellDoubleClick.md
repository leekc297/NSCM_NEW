# 예제 — event-CellDoubleClick (6건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 spdMain / CellDoubleClick
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:570-596`

```tsx
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    // 붙여넣기 후 처리 — 셀 편집과 동일 후처리.
    const pastedCellHandler = (
      s: FlexGridType<ShipmentRequestRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      cellEditEndedHandler(s, e);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ===== 더블클릭 — 헤더 드릴다운 + 셀 모달 =====
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 헤더 — M_ 헤더: 해당 월 구간 W_ 토글 + 보이는 D_ 접기 / W_ 헤더: 해당 주 D_ 토글.
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = dynKindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const targetCol = g.getColumn(target);
          if (!targetCol) return;
          if (hideOnly && !targetCol.visible) return; // AS-IS: D_ 는 보이는 경우만 접기 (M_ 드릴)
          drillVisRef.current.set(target, hideOnly ? false : !targetCol.visible);
        };
```

## SSP0014 · §2 spdMain / CellDoubleClick(UserInfoPopup)
- 위치: `features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx:106-132`

```tsx
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집 게이트는 화면이 재정의하지 않는다 — 공용 DataGrid 의 setEditableColumns(dataGridUtils)가
    //   컬럼메타 INPUT_TP_CD 로 판정한다(M/O = 편집, S = 잠금). DB 실측 9열 편집(USER_ID='M',
    //   PART_LEADER/TEAM_LEADER/MAIL_USER1~5/VALID_YN='O') + 12열 'S' 잠금 = AS-IS LockColumn
    //   (cs:274~278) 집합과 1:1 일치하므로 메타만으로 파리티가 달성된다(design 03 §1.1, hook #130).
    //   주의: 팝업 8열은 AS-IS 도 TextCellType(cs:162)이라 키인이 가능했고 TO-BE 메타도 FPTextModal
    //   (키인 + 모달 동시 허용)이다 — 화면이 인라인 편집을 취소하면 AS-IS 보다 좁아진다.

    // ID 셀(USER_ID/PART_LEADER/TEAM_LEADER) 편집 시 짝 이름 컬럼 파생은 아래 별도 useEffect
    //   (cellEditEnded/pastedCell → deriveName)에서 처리한다 — 삭제 시 이름 동반 삭제, 키인·붙여넣기
    //   시 이름 자동 채움(사용자 지시 2026-09-29). `USER_ID` 는 여전히 `INPUT_TP_CD='M'`(필수)이라
    //   ID 를 비우면 공용 필수검증이 저장을 막는다(이름만 비고 저장은 차단 — A-5/공용검증).

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, opGroupNameMap]);

  // 이름 짝이 있는 ID 셀(USER_ID/PART_LEADER/TEAM_LEADER) 직접 키인·붙여넣기·삭제 시 짝 이름 컬럼을
  //   팝업 선택과 동일하게 유지한다(사용자 지시 2026-09-29). 팝업(handleUserSelected)은 ID+이름을
```

## SSP0023 · §2 spdMain / CellDoubleClick
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx:327-353`

```tsx
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
        g.cellEditEnded?.removeHandler(onEdited);
        g.pastedCell?.removeHandler(onEdited);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
```
