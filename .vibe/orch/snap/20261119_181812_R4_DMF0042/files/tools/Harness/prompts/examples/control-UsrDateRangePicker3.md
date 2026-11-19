# 예제 — control-UsrDateRangePicker3 (4건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0017 · §1 dCalendar / UsrDateRangePicker3
- 위치: `features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx:223-249`

```tsx

          {/* Row1 — Material(팝업) / Model/Nickname(팝업) / Version* / Period* (사용자 지정 배치) */}
          {/* 주의: 사용자 지정으로 3줄을 항상 펼쳐 보이게 extraConditions(접힘 토글) 대신 conditions 한 곳에 모두 둔다. */}
          {/* Material(txtItemId) — 팝업 검색(btnItemId → MaterialByDivisionModal). AS-IS lblItemId.Text="Material". */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onModelSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ modelId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
```

## SCP0041 · §1 dCalendar / UsrDateRangePicker3
- 위치: `features/supply/src/pages/stock-osp/components/StockOspForm.tsx:232-258`

```tsx
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={noDivisionAuth}
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) => set({ plantSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>
          {/* Model — 텍스트 + 돋보기(ItemByDivisionModal, design 02 §popup) */}
          {model}
          {/* Period — 조회 기간(design 02 §1) */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
        </>
      }
    />
  );
};
```

## SCP0016 · §1 dCalendar / UsrDateRangePicker3
- 위치: `features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx:240-266`

```tsx
          {/* Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 D2). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}
        </>
      }
      extraConditions={
        <>
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, bucketOptions, v =>
            set({ bucket: v as BUCKET_TYPE })
          )}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          {popupField(t(LBL.MODEL, '_Model'), sc.itemId, onModelSearch, v => set({ itemId: v }))}
          {popupField(t(LBL.PROJECT, '_Project'), sc.projectCode, onProjectSearch, v =>
            set({ projectCode: v })
          )}

```
