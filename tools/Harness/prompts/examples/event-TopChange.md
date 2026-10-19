# 예제 — event-TopChange (5건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 spdMain / TopChange
- 위치: `features/demand/src/pages/dmf0045/utils/dmf0045.merge.ts:92-118`

```tsx

// 계층 머지 (HierarchicalMergeManager 계보 — 좌측 키컬럼 세로 머지 + viewport sticky).
//   1) Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지(viewport row 제한 = sticky content).
//   2) ColumnHeader: 정적 column verticalSpan + 동적 column 2단(년월/주차) 가로 머지.
//   생성 시 fixedBindings(좌측 고정 컬럼 binding 순서)를 주입 → 컬럼 구성 변경 시 재생성.
//   AS-IS SmartColMerge + TopChange 재적용(§3 gridSignals #1/#9/#21) 대응.
export class HierarchicalMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ===== No. 코너(TopLeft) 가로/세로 단일 머지 (hook ui-grid-corner-no-header) =====
    if (panel.cellType === CellType.TopLeft) {
      return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
    }

    const col = panel.columns[c];
    if (!col) return null;
    const binding = col.binding ?? '';

    // ===== 1) Data Cell — 좌측 fixed cols 계층 머지 (viewport row 제한) =====
    if (panel.cellType === CellType.Cell && this.fixedBindings.includes(binding)) {
      const view = panel.rows;
```

## SSP0019 · §2 spdMain / TopChange
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx:133-143`
- 비고: 공용 DataGrid allowMerging=All(스크롤 시 병합 유지, CustomMergeManager)

```tsx
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

## SCP0033 · §2 spdMain / TopChange
- 위치: `features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx:140-162`
- 비고: -

```tsx
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={false}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};

```
