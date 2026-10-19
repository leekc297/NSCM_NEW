# 예제 — control-UsrCheckedList (32건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 clbCustomer / UsrCheckedList
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx:214-240`

```tsx
            'Team',
            sc.deptIds,
            teamOptions,
            v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] }, 'team')
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            v => set({ endCustomers: v, scmSiteIds: [] }, 'endCustomer')
          )}
          {multiField('LBL00011', 'Sales Site', sc.scmSiteIds, salesSiteOptions, v =>
            set({ scmSiteIds: v })
          )}
          {/* Row 2 — Plant Site(40 비활성) / Project*(40 비활성) / Model·Nickname / Bucket* */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            v => set({ plantSiteIds: v }),
            { disabled: div40 }
          )}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
```

## SSP0019 · §1 clbDivision / UsrCheckedList
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:136-162`
- 비고: Division CustomDropdown(multiple, MyDivisionInEE_SCP)

```tsx
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  autoFocus
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={divisionCsv}
                  options={divisionOptions}
                  onChange={(_, picked) => handleDivisionChange(pickedToCsv(picked))}
                />
              )}
            />
          </Grid>

          {/* From Site (다중, EE 분기 comboId — design 02 §1 #2 / §3). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
```

## SSP0024 · §1 cboPlantSite / UsrCheckedList
- 위치: `features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx:117-143`

```tsx
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   AS-IS SetChangedControl 도 division 변경 시 그리드 datasource 를 비운다(cs:197~200
                  //   `SpreadInfo.ClearDataSource`) — setDivision 의 filters clear 로 useTabProcQuery 가 disabled 되어
                  //   그리드가 빈다. 편집중(dirty)이면 MSG00704 confirm 후에만 실행하고 취소 시 controlled 콤보가
                  //   이전 Div 로 복귀, 미저장 편집·신규행은 공용 DataGrid 자동 reset 이 되돌린다(commit 51d4e9fa 패턴).
                  onChange={(_, picked) => {
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Plant Site (다중 CheckedList) — division 하위 EE operation plant(서버 @divisionId cascade). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
```
