# 예제 — event-CheckedChanged (10건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 chkSum / CheckedChanged
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx:698-724`

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
```

## SSP0019 · §2 chkCurrent / CheckedChanged
- 위치: `features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx:61-87`
- 비고: displayRows 필터(체크=LAST_SEQ='C' 만) + Grid formatItem 강조

```tsx
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<MainRow[]>(() => (data?.o_rc1 ?? []) as unknown as MainRow[], [data]);

  // chkCurrent 토글(design 03 §3 SetCheckRow) — 체크 시 LAST_SEQ='C'(현재값) 행만 표시, 해제 시 전행.
  //   강조(LightSkyBlue)는 두 상태 공통으로 그리드 formatItem 이 'C' 행에 적용. 서버 재조회 없는 클라 토글.
  const displayRows = useMemo<MainRow[]>(
    () =>
      sc.chkCurrent
        ? rows.filter(r => str((r as Record<string, unknown>)[LAST_SEQ_COLUMN]) === LAST_SEQ_CURRENT)
        : rows,
    [rows, sc.chkCurrent]
  );

  // 진입 — 개인화 조회조건 복원(SubTitle F6 저장분, 1회). GET /admin/menu/SSP0019/search-conditions
  //   → searchCondition 패치. 저장(searchParam prop)만 배선돼 있고 복원이 누락돼 재진입/새로고침 시
  //   저장조건이 소실되던 것을 해소(basic-check #3, 자매 shipment-plan-mobility-it 파리티).
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(admin 동적 속성관리).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
```

## SSP0023 · §2 chkPastPeriod / CheckedChanged
- 위치: `features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx:428-454`

```tsx
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
