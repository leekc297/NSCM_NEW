# 예제 — control-UsrLayoutControl (7건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0024 · §1 usrLayoutControl2 / UsrLayoutControl
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

## SSP0014 · §1 usrLayoutControl2 / UsrLayoutControl
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

## SSP0023 · §1 usrLayoutControl3 / UsrLayoutControl
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx:43-88`

```tsx
//     5필드가 한 줄에 들어오게 한다(필드 입력폭은 유지, 사용자 지시 2026-10-11).
export const ShipmentPlanElectrodeDetailBar = ({
  onDetailSearch,
  onItemSearch2,
  onRequestorSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const set = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const fieldSet = useShipmentPlanElectrodeStore(s => s.detailFieldSet);
  const activeSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE, 02 §5-1). FE 후필터 R 제외(설계 02 §5-1).
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.RESULT_TYPE] });
  const resultTypeOptions = toOptions((resultTypes ?? []).filter(r => str(r.CODE) !== 'R'));

  // Shipment Date 는 활성 sheet 에 따라 다른 독립축(drpPeriod2 vs drpPeriod3)을 바인딩한다.
  const isResult = activeSheet === SHEETS.SHIPMENT_RESULT;
  const shipFrom = isResult ? sc.shipResultShipFrom : sc.planDetailShipFrom;
  const shipTo = isResult ? sc.shipResultShipTo : sc.planDetailShipTo;
  const onShipChange = (start: string, end: string) =>
    set(isResult ? { shipResultShipFrom: start, shipResultShipTo: end } : { planDetailShipFrom: start, planDetailShipTo: end });

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      {/* 필드 좌→우 순서는 AS-IS usrLayoutControl3 컨트롤 Location.X 순서를 따른다(사용자 지시 2026-10-11):
          Shipment Date(94) → Model(620) → Material(789) → Nick Name(1014) → Requestor(1167)
          → Lot ID(1348) → Result Type(1537). 시트별 show/hide 후에도 이 축이 유지되도록 블록 순서 고정. */}
      <div className={styles.detailBarFields}>
        {/* Shipment Date — drpPeriod2(PlanDetail) / drpPeriod3(ShipmentResult) 독립축. 분리형 날짜 range.
            PeriodField 는 자체 Grid·label 포함 — flex 행에 맞추려 detailBarField 로 감싸고 라벨칸만 좁힌다. */}
        {fieldSet.shipmentDate && (
          <div className={`${styles.detailBarField} ${styles.detailBarDateField}`}>
            <PeriodField
              gridSize={12}
              label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
              start={shipFrom}
              end={shipTo}
              onChange={onShipChange}
            />
          </div>
        )}

        {/* Model — txtModel2 (PlanDetail 전용). P_MODEL_ID(저장 시 store 에서 ToUpper). */}
        {fieldSet.model && (
```
