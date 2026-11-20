# 예제 — control-LayoutControlItem (67건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 Period / LayoutControlItem
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx:274-290`
- 비고: AS-IS drpPeriod readOnly 는 shared PeriodField 개변 필요(Hard Boundary)로 미이식, 편집가능 대체(DMF0040 표준). 컨트롤 자체는 구현

```tsx
              )}
            />
          </Grid>
          {/* Row 3 — Period* (오늘~오늘+55일, store init 고정. AS-IS drpPeriod readOnly 미이식 —
              헤더 주석·__asis-mapping__ 참조). 자매화면(DMF0040) 정본과 동일 편집 가능 PeriodField. */}
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
        </>
      }
    />
  );
};

```

## SSP0024 · §1 Division / LayoutControlItem
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:82-108`

```tsx
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

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수, 기본포커스 — design 02 §2.1). 변경 시 Plant Site cascade + Material/Model clear(§3). */}
          <Grid size={3}>
            <FormItem
```

## SSP0014 · §1 Division / LayoutControlItem(라벨)
- 위치: `features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx:71-97`

```tsx

  // From Site = PlantSiteByDivision @divisionId. 선택 division 을 넘겨 서버 cascade(design 02 §3
  //   재조회 방식). division 변경 시 param 이 바뀌어 자동 재조회. 값 raw, 인용은 getCombo funnel.
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };

  const [fromSites, validYnRows] = useTabComboQueries({
    filters: [fromSiteFilter, COMBO.VALID],
  });
  // Operation Group = LookupCommon lookupType='OPERATION_GROUP'(P/A/E). W 는 lookup 에 없어 클라 추가.
  const [operationGroupData] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.OPERATION_GROUP }],
  });

  const fromSiteOptions = toOptions(fromSites);
  const validOptions = toOptions(validYnRows);
  // P/A/E(lookup NAME) + 클라 W=Warranty (design 02 §2.2 — 코드/표시 그리드와 일치).
  //   정렬: AS-IS 는 lookup 결과를 `.OrderBy(CODE)` 로 재정렬한 뒤 W 를 append 한다
  //   (DataService.cs:5210 + cs:183~187) → 최종 A,E,P,W. TO-BE lookup 은 DISPLAY_SEQ 순(P,A,E)
  //   이라 그대로 두면 순서가 다르다(design 02 §6 F-2). `LookupCommon` 은 전 도메인 공용이라
  //   lookup DISPLAY_SEQ·CMBO 본문을 고치지 않고 화면에서 재현한다(convert-core §2.6 ②, hook #117).
  const operationGroupOptions: Option[] = [
    ...(operationGroupData ?? [])
      .map(r => ({ label: str(r.NAME), value: str(r.CODE) }))
      .sort((a, b) => a.value.localeCompare(b.value)),
    { label: OPERATION_GROUP_WARRANTY_NAME, value: OPERATION_GROUP_WARRANTY_CODE },
  ];

```
