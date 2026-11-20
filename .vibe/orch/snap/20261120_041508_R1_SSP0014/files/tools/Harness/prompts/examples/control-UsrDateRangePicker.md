# 예제 — control-UsrDateRangePicker (5건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## DMF0045 · §1 drpPeriod / UsrDateRangePicker
- 위치: `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx:274-290`
- 비고: 컨트롤은 구현(편집가능 대체). AS-IS readOnly 속성만 미이식(D00-1-001·헤더 주석 27-33)

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

## SSP0019 · §1 drpPeriod / UsrDateRangePicker
- 위치: `features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx:242-287`
- 비고: Shipment Date 기간 range(DatePickerCalendar × 2)

```tsx
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
              labelAlign='right'
              render={() => (
                <div className={styles.periodWrapper}>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={noDivisionAuth}
                    value={toDate(sc.fromDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        set({ fromDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                  <span className={styles.periodSeparator}>~</span>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={noDivisionAuth}
                    mindate={toDate(sc.fromDate) ?? undefined}
                    value={toDate(sc.toDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        set({ toDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Model (텍스트 콤마 다중 + 팝업 버튼 — design 02 §1 #7/#8 / §4.6). LBL00669. */}
          <Grid size={3}>
            <FormItem
```

## SSP0023 · §1 drpPeriod / UsrDateRangePicker
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx:171-200`

```tsx
                  options={companyOptions}
                  onChange={(_, picked) => setCompany(str(picked))}
                />
              )}
            />
          </Grid>

          {/* From Site — Com_FromSitePlantEE, 다중선택(clbFromSite 체크리스트, 02 §2-2 C20). 미선택=전체.
              @divisionId @companyId 재조회. 자매 shipment-plan-mobility-it Plant Site 와 동일 패턴. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSite.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({ fromSite: str(picked).split(',').filter(v => v && v !== ALL) })
                  }
                />
              )}
            />
          </Grid>
```
