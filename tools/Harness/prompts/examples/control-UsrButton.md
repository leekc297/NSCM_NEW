# 예제 — control-UsrButton (23건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 btnColumn / UsrButton
- 위치: `features/demand/src/pages/dmf0045/ShipmentRequest.tsx:361-388`

```tsx
      [newRow] as unknown as Partial<WijmoRowItem>[],
      'above',
      { preserveMergeManager: true }
    ) as unknown as ShipmentRequestRow[] | undefined;
    const target = added?.[0];
    if (target) {
      for (let i = 0; i < g.rows.length; i++) {
        if (g.rows[i]?.dataItem !== target) continue;
        g.select(i, Math.max(0, g.selection.col));
        g.scrollIntoView(i, -1);
        break;
      }
    }
    // addRowSet 은 setState 를 호출하지 않으므로 강제 리렌더 — rows(=spRows) 재계산 유도.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — AS-IS DeleteButton 1:1 — Action='I'(신규 삽입행)만 즉시 제거. DB 조회행 무동작(silent).
  //   저장행 삭제는 셀 0 저장(SP 'D' 전환) 경로만 — 여기서는 신규행만.
  const handleDelete = () => {
    if (isPending) return;
    const g = gridRef.current;
    if (!g) return;
    GridAction.removeRow(g as unknown as FlexGridType<WijmoRowItem>, true, true);
    forceGridRerender(v => v + 1);
  };

  // SubTitle 공통버튼 — 미명시(sort/filter/condition/resetCondition/excel)는 DefaultButtonActions 자동.
```

## SSP0019 · §1 btnItemId / UsrButton
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:294-320`
- 비고: Model 팝업 오픈 버튼('...') → onOpenModelPopup

```tsx
                    fullWidth
                    disabled={noDivisionAuth}
                    value={sc.itemId}
                    onChange={e => set({ itemId: e.target.value })}
                    onKeyDown={e => e.key === 'Enter' && onSearch()}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='...'
                    disabled={noDivisionAuth}
                    onClick={onOpenModelPopup}
                  />
                </div>
              )}
            />
          </Grid>

          {/* SO No (텍스트 콤마 다중 — design 02 §1 #9). LBL01111. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SO_NO, '_SO No')}
              labelAlign='right'
              render={() => (
                <InputField
```

## SSP0024 · §1 btnMaterialId / UsrButton
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:156-182`

```tsx
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Material — 입력 + 돋보기(SSP0024 전용 ItemByDivisionModal), 다건(콤마/개행). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  className={commonStyles.popupSearchField}
                  value={sc.materialId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onMaterialSearch} />
```
