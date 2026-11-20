# 예제 — control-UsrMultiLineEditor (13건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 txtItemId / UsrMultiLineEditor
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx:245-271`
- 비고: AS-IS 콤마 다중 텍스트 입력 → TO-BE 다중선택 필드로 재현

```tsx
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={div40}
            multiCheckbox
          />
          <ItemField
            gridSize={3}
            value={sc.itemIds}
            onChange={v => set({ itemIds: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            itemIds={sc.itemIds}
            multiCheckbox
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
```

## SSP0019 · §1 txtConfirmId / UsrMultiLineEditor
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:332-358`
- 비고: Confirm ID InputField(콤마 다중)

```tsx
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CONFIRM_ID, '_Confirm ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.confirmId}
                  onChange={e => set({ confirmId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Current (체크박스 — design 02 §1 #11 / 03 §3 SetCheckRow. 그리드 행표시 토글, 서버 재조회 없음). LBL01065. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CURRENT, '_Current')}
              labelAlign='right'
              render={() => (
                <input
                  type='checkbox'
                  disabled={noDivisionAuth}
```

## SSP0024 · §1 txtMaterialId / UsrMultiLineEditor
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:145-171`

```tsx
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  sortBy='label'
                  value={sc.scmSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      scmSiteIds: String(picked ?? '')
                        .split(',')
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
```
