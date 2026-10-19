# 예제 — event-SelectedIndexChanged (41건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §2 cboBucketType / SelectedIndexChanged
- 위치: `features/demand/src/pages/dmf0045/ShipmentRequest.tsx:210-236`

```tsx
    void fetchStaticMeasures();
  };

  // F5 Search — AS-IS FindData 1:1. Division 미선택 가드(MSG00097) 후 조회.
  //   UI 공통 UC-02: 미저장 변경 중 재조회 시 MSG00703 confirm 후에만 편집 폐기·조회
  //   (AS-IS 는 confirm 없이 재조회하나 전 화면 공통 요구로 신설 — shipment-plan-electrode 정본).
  const handleSearch = () => {
    if (blockIfWorking()) return;
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Division is required.') });
      return;
    }
    if (hasPendingChanges()) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_RESEARCH_UNSAVED, '_There are unsaved changes. Do you want to search again?'),
        onConfirm: runSearch,
      });
      return;
    }
    runSearch();
  };

  // Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory: division 변경 grid 초기화 —
  //   재조회는 Search 버튼). filters 도 무효화해 stale payload 재사용 차단 + division 종속 메타 재fetch.
  const handleDivisionChange = () => {
    editTrackerRef.current?.clearChanges();
```

## SSP0019 · §2 clbDivision / SelectedIndexChanged
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:103-129`
- 비고: handleDivisionChange(하위 4콤보 초기화) + EE 분기 comboId + divisionCsv 재조회

```tsx
      return;
    }
    setDivisionAuth(divisionCodesKey ? divisionCodesKey.split(',') : []);
  }, [divisions, divisionCodesKey, setDivisionAuth, resetDivisionAuth]);

  // Division 변경 = 하위 콤보 선택 초기화(design 02 §3 — 후보 집합이 바뀌므로). 재조회는 명시 Search 게이트.
  const handleDivisionChange = (picked: string): void => {
    set({
      divisionIds: picked
        .split(',')
        .filter(v => v && v !== 'ALL'),
      fromSiteIds: [],
      toSiteIds: [],
      incoterms: [],
      transModes: [],
    });
  };

  // CustomDropdown(multiple) onChange 두번째 인자는 콤마 join 문자열 — 객체 stringify 방지(typeof 가드).
  const pickedToCsv = (picked: unknown): string => (typeof picked === 'string' ? picked : '');
  const splitMulti = (picked: unknown): string[] =>
    pickedToCsv(picked)
      .split(',')
      .filter(v => v && v !== 'ALL');

  return (
    <SearchArea
```

## SSP0024 · §2 cboDivision / SelectedIndexChanged
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:94-120`

```tsx
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
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  // R6(design 01 R6 / 02 §6): 화면 진입 시 Division 콤보 기본 포커스.
                  autoFocus
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
```
