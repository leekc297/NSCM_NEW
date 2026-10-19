# 예제 — control-UsrCheckedList2 (7건 중 2)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0007 · §1 clbDivision / UsrCheckedList2
- 위치: `features/supply/src/pages/bod/components/BodForm.tsx:50-82`

```tsx
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.divisionId}
                  // Division_SCP 는 EE 사업부를 포함하므로 fetch 후 ATTRIBUTE3='EE' 행을 제외한다
                  // (AS-IS GetDivisionWithoutEE 재현 — 공유 콤보라 SQL 대신 화면에서 필터, bod.constants.ts 참조).
                  options={
                    divisions
                      ?.filter(item => item.ATTRIBUTE3 !== 'EE')
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00022', '_From Site')}
```

## SCP0017 · §1 clbLine / UsrCheckedList2
- 위치: `features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx:199-225`

```tsx
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true
          )}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v })
          )}
          {/* Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 L8). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}

          {/* Row1 — Material(팝업) / Model/Nickname(팝업) / Version* / Period* (사용자 지정 배치) */}
          {/* 주의: 사용자 지정으로 3줄을 항상 펼쳐 보이게 extraConditions(접힘 토글) 대신 conditions 한 곳에 모두 둔다. */}
```
