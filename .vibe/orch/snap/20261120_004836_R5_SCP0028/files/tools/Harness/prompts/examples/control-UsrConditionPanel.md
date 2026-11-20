# 예제 — control-UsrConditionPanel (10건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 usrConditionPanel1 / UsrConditionPanel
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx:168-213`

```tsx
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division*(단일) / Team / End Customer / Sales Site */}
          {/* Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화 (store setDivision + onDivisionChange,
              TO-BE 공통 요건 — AS-IS clbDivision_SelectedIndexChanged 의 Team/EC/Site/Plant 재조회 +
              Project/Item 클리어 + InitSpread 를 포함하며 Bucket/Sum 까지 초기값으로 되돌린다).
              편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
              자동 복귀(commit 51d4e9fa 패턴). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    const next = String(option ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setDivision(next);
                      onDivisionChange();
                    });
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
```

## SSP0024 · §1 usrConditionPanel1 / UsrConditionPanel
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:74-100`

```tsx
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

  return (
    <SearchArea
```

## SSP0014 · §1 usrConditionPanel1 / UsrConditionPanel(HidePanel)
- 위치: `features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx:252-278`

```tsx
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
            type: 'alert',
            // MSG01261 은 `{0}` 단일 중괄호 플레이스홀더라 i18next 보간({{ }})으로는 치환되지
            //   않는다 — 공통 SAVE_SUCCESS 와 동일하게 .replace('{0}', ...) 로 직접 치환한다.
            //   (개행 "\n\r" 은 i18n 로더 unescapeControlChars 가 실제 개행으로 되돌린다.)
            //   fallback 은 EN 등록 문구(KO 문구 하드코딩 금지) — {0} 없으면 replace 는 no-op.
            content: t(MSG.USER_NOT_REGISTERED, {
              defaultValue: 'This user does not have permission to the SSP Planner.',
            }).replace('{0}', check.invalidUser),
```
