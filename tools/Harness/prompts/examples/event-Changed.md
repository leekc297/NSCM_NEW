# 예제 — event-Changed (3건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0007 · §2 dsdm / Changed
- 위치: `features/supply/src/pages/bod/components/BodGrid.tsx:241-267`
- 비고: AS-IS는 데이터모델 레벨 이벤트(`dsdm.Changed`)로 트리거하나 TO-BE는 Wijmo `cellEditEnded`/`pastedCell`로 동일 결과(SetCityCode 동등 로직)를 직접 호출 — 이벤트 소스만 다른 구조적 대체

```tsx
      applyOne(BOD_COLUMN.FROM_SITE_CODE, fromSiteDataMap);
      applyOne(BOD_COLUMN.TO_SITE_CODE, toSiteDataMap);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, fromSiteDataMap, toSiteDataMap, data]);

  // 컬럼별 병합(allowMerging) 적용 — 공용 DataGrid 는 `allowMerging` prop 이 켜지면 화면에 보이는
  // 모든 컬럼에 일괄로 allowMerging=true 를 씌운다(DataGrid.tsx mappedStaticColumns). BOD 는 MERGE_
  // COLUMNS 9개만 병합 대상이라, 위 dataMap 재적용과 동일한 updatedLayout 처방으로 그 외 전 컬럼은
  // false 로 되돌린다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = MERGE_COLUMNS.has(col.binding);
      }
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
```

## SCP0106 · §2 _defaultDataModel / Changed
- 위치: `features/supply/src/pages/capa-loss-plan/components/CapaLossPlanGrid.tsx:223-249`
- 비고: AS-IS 는 `AfterFindData`(cs:2758~2761)에서 `-=` 후 `+=` 동적 배선. TO-BE 는 공용 EditTracker 뒤에 등록되는 정적 핸들러 1개로 대체

```tsx
     * 셀 변경 가드 6종을 **AS-IS 순서 그대로**(03 R-18):
     *   `_si==null` -> `GetMaxRowIndex()==-1` -> `row/col==-1` -> 시트 잠금 -> `!IsEditMode`
     *   -> **`IsLockCell`(잠금 셀은 자동계산 대상이라 재계산 skip — 무한루프 방지)**
     * 순서를 바꾸면 잠금 셀에도 자동계산이 돈다.
     * 공용 EditTracker 가 먼저 변경을 기록하므로 이 핸들러는 그 뒤에 등록된다.
     */
    const cellEditEndedHandler = (sender: FlexGridType, event: { row: number; col: number }) => {
      if (sender.rows.length === 0) return;
      if (event.row === -1 || event.col === -1) return;
      if (!editModeRef.current) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0106Row | undefined;
      if (!canEdit(binding, row)) return;
      editEndedRef.current(event.row, binding);
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    /**
     * (g) `Delete` 키 = 선택 범위에 **`0.0` 일괄 기입**(행 삭제도 DBNull 도 아니다) + `Ctrl+Z` 차단
     * (R-16, V-54). 편집 가능한 셀만 대상이며 변경은 `EditTracker` 에 기록해 `CRUD_TYPE='M'` 을 얻는다.
     * CommonCheckList 의 "Delete 키 행 삭제" 항목은 이 화면에서 **해당 없음**이다.
     */
    const keyDownHandler = (event: KeyboardEvent) => {
      if (event.ctrlKey && (event.key === 'z' || event.key === 'Z')) {
        event.preventDefault();
        return;
      }
```

## SCP0105 · §2 _defaultDataModel / Changed
- 위치: `features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanGrid.tsx:246-272`
- 비고: AS-IS 가드 6건 순서 보존 후 `CheckEltrEquipmentType` -> `RecalcSheet`

```tsx

    /**
     * AS-IS `_defaultDataModel_Changed`(cs:3085~3119) 의 가드 6건을 **그 순서 그대로** 통과한 뒤
     * `CheckEltrEquipmentType` -> `RecalcSheet` 를 부른다. 순서를 바꾸면 잠금 셀에도 자동계산이 돈다.
     * 공용 EditTracker 가 먼저 변경을 기록하므로 이 핸들러는 그 뒤에 등록된다.
     */
    const cellEditEndedHandler = (
      sender: FlexGridType,
      event: { row: number; col: number }
    ) => {
      if (sender.rows.length === 0) return; // GetMaxRowIndex() == -1
      if (event.row === -1 || event.col === -1) return;
      if (!editModeRef.current) return; // IsLock(sheet) / !IsEditMode
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0105Row | undefined;
      // IsLockCell — 잠금 셀은 자동계산 대상이라 재계산하지 않는다.
      if (
        !isCellEditable({
          sheetName: sheetRef.current,
          binding,
          row,
          isEditMode: editModeRef.current,
        })
      ) {
        return;
      }
      editEndedRef.current(event.row, binding);
```
