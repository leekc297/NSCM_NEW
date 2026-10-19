# 예제 — control-FpSpread (12건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 spdMain / FpSpread
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:790-822`

```tsx
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      window.cancelAnimationFrame(raf);
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, gridRef, gridFilterRef, reapplyInsertRowVisibility]);

  return (
    <DataGrid
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      staticColumns={mainStaticColumns}
      dynamicColumns={mainDynamicColumns}
      // 셀 콤보 SQL 이 요구하는 화면 단위 파라미터 — divisionId(스코프) / mnuId('Measure' @mnuId 비관대형).
      comboParams={{ divisionId: `'${division || 'ALL'}'`, mnuId: `'${MENU_ID}'` }}
      // 셀 콤보에 시트 스코프 sheetName 을 함께 실어 @sheetName 을 해소한다(mnuId 와 짝).
      sheetName={activeSheet}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowMerging={AllowMerging.All}
      useAggregationRow={false}
    />
  );
};

```

## SSP0019 · §1 spdMain / FpSpread
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx:124-143`
- 비고: 공용 DataGrid(spdMain 단일 그리드)

```tsx
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, fcstTypeMap, changeReasonMap]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // SmartColMerge 세로병합(design 03 §3 #5/#11) — CustomMergeManager 좌측누적 키(알려진 제약: 좌측 동일값
      //   전제, grid-behavior-parity §1.3). 읽기전용이라 신규행 제외 이슈 없음.
      allowMerging={AllowMerging.All}
    />
  );
};

```

## SSP0024 · §1 spdMain / FpSpread
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx:180-206`

```tsx
    g.pastedCell.addHandler(applyDerivations);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(applyDerivations);
        g.pastedCell?.removeHandler(applyDerivations);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, isEditMode, postOperLtMap]);

  // MATERIAL_ID 셀 더블클릭 -> 팝업. 신규행 + PLANT_SITE_CODE 있을 때만(design 03 §3.4 cs:553~558).
  //   Division 미선택 시 다른 칸 편집 차단 가드(MSG00097). 팝업 전용(키입력은 beginningEdit 이 차단).
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!isMaterialPopupColumn(binding)) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row || !isInsertRow(row)) return;
```
