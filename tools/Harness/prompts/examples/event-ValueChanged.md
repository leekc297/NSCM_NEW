# 예제 — event-ValueChanged (1건 중 1)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0016 · §2 dCalendar / ValueChanged
- 위치: `features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx:244-270`

```tsx
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

          {/* Sum — W_/M_ 합계칼럼 표시 토글. WeeklyISO 면 숨김(design 01 D1). */}
          {showSum && (
            <Grid size={3} className={commonStyles.customGrid}>
              <div className={commonStyles.customCheckbox}>
```
