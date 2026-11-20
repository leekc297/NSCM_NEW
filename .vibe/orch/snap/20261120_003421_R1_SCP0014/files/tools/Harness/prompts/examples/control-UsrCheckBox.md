# 예제 — control-UsrCheckBox (9건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 chkSum / UsrCheckBox
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:698-743`

```tsx

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef]);

  // Sum 체크박스 + 헤더 드릴다운 — 동적 컬럼 visible 통합 적용 (AS-IS SetSpreadColumn + 더블클릭 1:1).
  //   규칙: 활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 — 드릴 오버라이드 우선.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g) return;
    // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다).
      const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        if (userHiddenColumns?.has(b)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
```

## SSP0019 · §1 chkCurrent / UsrCheckBox
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:350-370`
- 비고: Current 체크박스 → sc.chkCurrent 토글

```tsx
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CURRENT, '_Current')}
              labelAlign='right'
              render={() => (
                <input
                  type='checkbox'
                  disabled={noDivisionAuth}
                  checked={sc.chkCurrent}
                  onChange={e => set({ chkCurrent: e.target.checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};

```

## SSP0023 · §1 chkPastPeriod / UsrCheckBox
- 위치: `features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx:427-453`

```tsx
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (01 §1, 비율 6:4) */}
      <div className={styles.gridArea}>
        <div className={styles.mainGrid}>
          {/* 단일 master 그리드 — 시트가 1개뿐이라 시트명 탭을 두지 않고 그리드를 직접 렌더한다(사용자 결정 2026-10-11).
              BOH 3-radio(UOM Type) / Sum / Past Period 토글은 조회조건 영역(Form extraConditions)으로
              이전 — AS-IS usrConditionPanel1 영역2 복원(01 §1). 재조회 없이 컬럼 표시규칙만 전환(03 §2.2). */}
          <ShipmentPlanElectrodeMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[SHEETS.MAIN]}
            bucketType={sc.bucketType}
            bohRadio={sc.bohRadio}
            chkSum={sc.chkSum}
            chkPastPeriod={sc.chkPastPeriod}
            editable={mainEditable}
            curPlanDate={sc.planDateYyyymmdd}
          />
        </div>
```
