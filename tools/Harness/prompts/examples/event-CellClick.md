# 예제 — event-CellClick (5건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0019 · §2 spdMain / CellClick
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx:98-124`
- 비고: REQUEST_NO 셀 클릭 가드(값 존재) → onRequestNoClick 드릴다운

```tsx
        row && str(row[LAST_SEQ_COLUMN]) === LAST_SEQ_CURRENT ? CURRENT_ROW_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // REQUEST_NO 이미지셀 클릭 드릴다운(design 03 §3-4, AS-IS SpdMain_CellClick) — 가드 2건:
    //   e.Column==REQUEST_NO && !IsNullOrWhiteSpace(sRequestNo). 값 있는 셀만 SCM0002 요청 상세 팝업.
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== REQUEST_NO_COLUMN) return;
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      const requestNo = str(row?.[REQUEST_NO_COLUMN]);
      if (!requestNo.trim()) return; // 빈 값 클릭 무동작(가드)
      onRequestNoClick(requestNo);
    };
    g.hostElement.addEventListener('click', clickHandler);

    g.invalidate();

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
```

## SSP0024 · §2 spdMain / CellClick
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx:153-179`

```tsx
      if (!row) return;
      const setCell = (key: string, value: string): void => {
        const prev = row[key];
        if (str(prev) === value) return;
        editTrackerRef.current?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      if (binding === 'DIVISION_ID' && isInsertRow(row)) {
        // 신규행 DIVISION 변경 -> 종속 7칸 클리어(cs:630~636).
        DIVISION_CASCADE_CLEAR.forEach(k => setCell(k, ''));
      } else if (binding === 'PLANT_SITE_ID') {
        // PLANT_SITE_ID -> PLANT_SITE_CODE 동기(cs:640).
        setCell('PLANT_SITE_CODE', str(row.PLANT_SITE_ID));
      } else if (binding === 'POST_OPER') {
        // POST_OPER -> POST_OPER_LT (lookup SEGMENT5, division별 cs:615~623).
        const lt = postOperLtMap.get(`${str(row.DIVISION_ID)}|${str(row.POST_OPER)}`) ?? '';
        setCell('POST_OPER_LT', lt);
      } else if (binding === 'BUILDING') {
        // BUILDING -> BUILDING_DESC (FACTORY_NAME, 선택 코드의 콤보 표시값 cs:605 / 07_human-doc §2).
        const col = sender.columns.getColumn('BUILDING');
        const name = col?.dataMap ? str(col.dataMap.getDisplayValue(row.BUILDING)) : '';
        setCell('BUILDING_DESC', name || str(row.BUILDING));
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(applyDerivations);
```

## SSP0023 · §2 spdDetail / CellClick
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx:239-256`

```tsx
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? []}
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져 정적 컬럼의 단일 라벨이 그룹 헤더행+leaf
            //   행에 각각 찍혀 "같은 텍스트가 여러 줄"로 보인다(2단 헤더 StockDetail 신고 2026-10-11,
            //   memory datagrid-allowmerging-cells-breaks-header-merge). .All 이어야 헤더 병합(정적 컬럼
            //   세로 span)과 데이터 셀 병합(SO 그룹)이 둘 다 동작 — 메인 그리드와 동일.
            allowMerging={AllowMerging.All}
            gotFocus={() => setActiveGrid('detail')}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};

```
