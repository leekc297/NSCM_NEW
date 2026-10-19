# 예제 — control-TextBox (7건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0014 · §1 txtUser / TextBox(User ID(Name) LIKE)
- 위치: `features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx:183-209`

```tsx
              )}
            />
          </Grid>

          {/* Valid (단일 + ALL) — YesOrNo. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  allOption
                  value={sc.validYn}
                  options={validOptions}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model/Nickname — 입력 + 돋보기(공용 MaterialByDivisionModal COM0013, SCP0013 정합). 다건(콤마).
              팝업 선택 결과 ITEM_ID 를 itemId(GET P_ITEM_ID)로 채운다. SSP0014 GET SP 에는 nick_name 파라미터가
              없어 서버 필터는 itemId 단일이며, 라벨만 Model/Nickname 으로 표기(사용자 지시 2026-10-12). */}
          <Grid size={3}>
            <FormItem
```

## SCP0033 · §1 txtItemId / TextBox
- 위치: `features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx:121-147`
- 비고: -

```tsx
                  onChange={(_, picked) =>
                    set({
                      divisionIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Model (단일 텍스트 직접입력, 팝업 없음 — design 02 §1 #2). prefix 검색. LBL00669(라벨 "Model", 키 ITEM_ID). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.itemId}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
```

## SCP0106 · §1 txtItem / TextBox
- 위치: `features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx:380-406`
- 비고: 대소문자 변환을 넣지 않는다 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지

```tsx
                )}
              />
            )}
          </Grid>
          {/* Item — 라벨이 DivisionType 으로 갈린다(01 L-03): Cell/Module-Pack = Basic Nickname /
              Electrode = Model. **`showElectrodeType`(Cell 전용)을 조건으로 쓰면 Module/Pack 에서
              "Model" 이 떠서 틀린다** — 조건은 `!== ELTR` 이다(SCP0105 와 갈리는 지점).
              입력창 + 팝업 아이콘은 한 덩어리로 묶는다(hook #121 popupSearchField). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={
                showOperation
                  ? t('LBL00054', '_Basic Nickname')
                  : t('LBL00669', '_Model')
              }
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={disabled}
                  // 대소문자 변환을 넣지 않는다 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지.
                  onChange={event => setSearchCondition({ nickName: event.target.value })}
                  onDoubleClick={onOpenItemPopup}
                  InputProps={{
```
