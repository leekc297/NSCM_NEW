# 예제 — event-ClipboardPasted (4건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0024 · §2 spdMain / ClipboardPasted
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx:115-141`

```tsx
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

    // 편집 가능 셀 배경 강조 — 공용 formatEditableColumns 의 'wj-cell-editable' 은 INPUT_TP_CD 기준이라
    //   전건 'S' 인 이 화면에서는 항상 꺼진다(dataGridUtils.ts:303). AS-IS FpSpread 의 잠금/해제 색 대비를
    //   editLock 기준으로 재현한다(자매 shipment-requestor-pic 동일 패턴).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cell.style.backgroundColor =
```

## SSP0023 · §2 spdDetail / ClipboardPasted
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx:98-124`

```tsx
        });
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 — 클릭 편집과 동일 판정 전체대입
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집가능 셀 시각 계층 (INPUT_TP_CD 전건 'S' 화면 4계층 세트 — 클릭/paste/저장검증/시각).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current)
```

## SCP0007 · §2 spdMain / ClipboardPasted
- 위치: `features/supply/src/pages/bod/components/BodGrid.tsx:301-327`

```tsx
   *      'DAP'(+ 이 경우 INCOTERMS_SSP 도 동일값 동기화). PLANT 가 아니면 INCOTERMS 를 비운다.
   *      이 판정 결과로 INCOTERMS_SSP 행단위 편집 잠금 여부가 갈린다(④ #3 — isIncotermsSspLocked).
   *   3) From/To City 가 모두 있으면 SCP.SCP0007_GET_ROUTE_CNT 를 조회해 ROUTE_CNT 갱신(④ #5).
   * 확인필요(DB 접속 불가): countryCity/routeCnt 버튼 배선(05_register.sql)이 이번 세션 DB 미적용 —
   * 적용 전에는 아래 apiClient.callProc 호출이 -9997 No Permission 으로 실패한다.
   */
  const applyCityCode = async (grid: FlexGrid<BodRow>, row: number): Promise<void> => {
    const dataItem = GridUtils.getRow(grid, row) as WijmoRowItem | undefined;
    if (!dataItem) return;
    const fromSiteCode = String(dataItem[BOD_COLUMN.FROM_SITE_CODE] ?? '');
    const toSiteCode = String(dataItem[BOD_COLUMN.TO_SITE_CODE] ?? '');
    if (!fromSiteCode && !toSiteCode) return;

    const fromMatch = findCountryCity(fromSiteCode);
    dataItem[BOD_COLUMN.FROM_COUNTRY] = fromMatch?.COUNTRY ?? '';
    dataItem[BOD_COLUMN.FROM_CITY] = fromMatch?.CITY ?? '';

    const toMatch = findCountryCity(toSiteCode);
    dataItem[BOD_COLUMN.TO_COUNTRY] = toMatch?.COUNTRY ?? '';
    dataItem[BOD_COLUMN.TO_CITY] = toMatch?.CITY ?? '';
    dataItem[BOD_COLUMN.VMI_YN] = toMatch?.VMI_YN ?? '';
    const toSiteType = toMatch?.SITE_TYPE ?? '';

    if (toSiteType === 'PLANT') {
      dataItem[BOD_COLUMN.INCOTERMS] =
        fromSiteCode.split('-')[0] === toSiteCode.split('-')[0] ? 'EXW' : 'DAP';
      if (dataItem[BOD_COLUMN.INCOTERMS] === 'DAP') {
```
