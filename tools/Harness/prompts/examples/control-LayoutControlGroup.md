# 예제 — control-LayoutControlGroup (5건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0024 · §1 layoutControlGroup2 / LayoutControlGroup
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:72-98`

```tsx
  //   동시에 후보 첫 행을 선택한다. store 초기값은 `session.div`(useShipmentMasterElectrodeStore.ts:37)라
  //   그 값이 MyDivision 후보(권한 + ATTRIBUTE3<>'EE') 밖이면 (a) 드롭다운이 빈 칸으로 보이고
  //   (b) 권한 없는 division 으로 조회가 나간다. EE 계열 division 은 실재한다(ora.py 실측).
  //   후보에 없으면 첫 후보로 보정하고 후보가 0건이면 비운다(그때는 noDivisionAuth 가 조회영역을 막는다).
  //   deps 에 divisionOptions(매 렌더 새 배열)를 넣으면 무한 재실행이라 divisions 참조만 본다.
  //   자매 shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx 동일 패턴.
  useEffect(() => {
    if (!divisions) return;
    const codes = divisionOptions.map(o => o.value);
    if (sc.divisionId && codes.includes(sc.divisionId)) return;
    const next = codes[0] ?? '';
    if (next === sc.divisionId) return;
    set({ divisionId: next, scmSiteIds: [], materialId: '', modelId: '' });
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, sc.divisionId]);

  const authAlertShownRef = useRef(false);
  useEffect(() => {
    if (!noDivisionAuth || authAlertShownRef.current) return;
    authAlertShownRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
    });
  }, [noDivisionAuth, setAlert, t]);

```

## SSP0014 · §1 layoutControlGroup2 / LayoutControlGroup
- 위치: `features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx:244-270`

```tsx
    // A-2/B-2 — 팝업이 열려 있는 동안 권한이 회수되거나 저장이 시작됐을 수 있다. 반영 직전 재검사.
    if (!canEdit || savingRef.current || staticColumnsError) {
      popupTargetRef.current = null;
      return;
    }
    const prev = target.row[target.binding];
    if (prev !== userId) {
      editTrackerRef.current?.storeChange(target.row as never, target.binding, prev as never, userId as never);
      target.row[target.binding] = userId;
      const nameCol = USER_POPUP_NAME_COLUMN[target.binding];
      if (nameCol) target.row[nameCol] = (langCd === 'KO' ? userNm : userEngNm) ?? '';
      grid?.invalidate();
    }
    popupTargetRef.current = null;
  };

  // 변경행만 ^-delim CLOB 조립 -> SAVE SP (design 03 §4, DMF0020 handleSave 경로).
  const runSave = async (
    originalRows: Record<string, unknown>[],
    dirty: Record<string, unknown>[]
  ): Promise<void> => {
    {
      // 저장 전 그룹권한 검증(GET_USER_ID_CHECK) — 미통과 시 MSG01261 중단(design 03 §4).
      const check = await checkUsersRegistered(dirty);
      if (!check.ok) {
        if (check.invalidUser) {
          void setAlert({
```

## SCP0106 · §1 layoutControlGroup2 / LayoutControlGroup
- 위치: `features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx:93-119`
- 비고: —

```tsx
      { label: SHEET_TYPE.MODEL, value: SHEET_TYPE.MODEL },
      { label: SHEET_TYPE.LINE, value: SHEET_TYPE.LINE },
    ],
    []
  );

  // 1행 합 12 유지 — SheetType 이 뜨면 Version 칸을 1 줄여 자리를 만든다(DivisionType 은 항상 우측 3).
  const versionSize = showSheetType ? 1 : 2;

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1행 — Div / Plan Month / Version / PlanType / Status / [SheetType] / DivisionType */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={combos.divisionOptions}
```
