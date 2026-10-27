---
trigger: AS-IS 조회조건 영역에 '그리드 일괄 입력' 컨트롤 묶음(Day of the week / Day Type / Category + Input Value + Input 버튼)이 있는 화면의 신규 작성·보정 (T01/T01M/T05)
mode: PRE-WRITE 의무 + POST-WRITE 검증
related: hooks/search-condition-labelless-toggle-input-column.md(#154) · hooks/popup-modal-and-routing-mandatory.md · hooks/common-button-grid-routing.md · hooks/search-area-extra-conditions.md
created: 2026-10-23
reason: 사용자 지시 (2026-10-23) — "SCP UI 중 조회 INPUT BUTTON 이 들어가는 UI 의 경우 POPUP 으로 구현되어 있는데 이부분도 공통으로 적용되어 있으니 다른 화면 개발이나 보정 시 동일하게 사용될 수 있도록 RULE 추가" · "SCP0096 의 Input button 을 popup 으로 구현한 기능"
---

# Hook #155 — 조회영역 일괄 입력(Input 버튼) = 버튼 영역 버튼 + 입력 팝업 ⭐⭐⭐ (공통 패턴)

> **한 줄**: AS-IS 가 조회조건 줄에 두던 **일괄 입력 묶음**(적용 대상 선택 콤보 + 입력값 + `Input` 버튼)은 TO-BE 에서 **조회영역에서 빼고**,
> SubTitle **버튼 영역의 버튼 1개**(`customButtons`) → **입력 팝업**(화면 종속 `components/<Page>InputModal.tsx`)으로 옮긴다.
> 팝업의 OK 는 **그리드 셀에 일괄 기록만** 하고(EditTracker 경유), DB 저장은 기존 Save(F7) 가 한다.
> **정본 = SCP0096** `features/supply/src/pages/shipment-working-day-osp/` (`ShipmentWorkingDayOsp.tsx` `handleInputOpen`/`handleInputConfirm` + `components/ShipmentWorkingDayOspInputModal.tsx`). 선례 = SCP0098 `capa-mobility-it` `BulkUpdateModal`.

---

## §0. 근거

| 출처 | 내용 |
|---|---|
| 사용자 지시 2026-10-23 | SCP0096 의 Input 버튼을 팝업으로 구현한 기능을 다른 화면 개발·보정에 동일하게 사용 |
| 조회조건 기준표(룰 E11 · `tools/VibeManager/rules/40_SEARCH_COND.md`) | 변경내용 **'버튼영역 이동'** + 추가검토 **"Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경"** — 대상: **SCP0019** Work Calendar(OSP) · **SCP0096** Shipment Working Day(OSP) · **SCP0098** CAPA (Mobility IT) · **SSP0005** Shipment Working Day (각 Day of the week/Day Type/Category + Input Value + Input) |
| 공통소스 채택(2026-10-22) | SCP0096 은 공통소스판으로 교체된 화면 — 이 패턴이 팀 공통 구현으로 확정 |

---

## §1. 적용 대상 / 비대상

| 구분 | 대상 |
|---|---|
| AS-IS 조회영역의 `Input`(또는 `Apply`) 버튼이 **그리드 셀에 값을 써넣는** 화면(조회 SP 호출 없음 · 저장은 별도 Save) | ✅ |
| 그 버튼과 짝인 '대상 선택'(요일/Day Type/Category/SelectDay) 콤보와 '입력값'(Input Value) 콤보·텍스트 | ✅ (함께 팝업으로 이동) |
| 조회조건 기준표에서 `BUTTON_AREA` + 'Bulk Update' 검토문구가 붙은 행 | ✅ (하네스가 GEN_NOTES §12 에 표시) |
| `Input All`(SCP0006 — 다른 팝업 화면 호출) · `New/Fix/Unfix/Calculate`(서버 처리 버튼) · `Upload/Excel Form` | ⛔ 비대상 (버튼영역 이동만 — 각자 자기 동작) |

---

## §2. 의무 패턴 (MUST) — 정본 SCP0096

```tsx
// ① 화면(Page) — 버튼 영역 버튼 + 열기 가드 + 확정 처리
const [inputModalOpen, setInputModalOpen] = useState(false);
const handleInputOpen = useCallback((): void => {
  if (!hasSearched) { void setAlert({ type: 'alert', content: t(MSG.SEARCH_FIRST, '_Please search first.') }); return; } // 조회 선행
  setInputModalOpen(true);
}, [hasSearched, setAlert, t]);
// true = 성공(팝업 닫힘) / false = 가드·검증 실패(팝업 유지)
const handleInputConfirm = useCallback((target: string, value: string): boolean => {
  if (!canEdit) return false;                                   // 편집 권한 방어
  /* AS-IS Input 버튼 핸들러의 검증 그대로(형식·범위) → 실패 시 setAlert + return false */
  /* 대상 분기(AS-IS 그대로): SelectDay=선택 셀 / EveryDay=전체 / 요일별=해당 요일 컬럼 */
  /* 셀 기록 = g.setCellData(row, col, value, true) + editTracker.storeChange(item, binding, original, value) */
  /* 기록 0건이면 setAlert(MSG 선택 없음) + return false */
  g.invalidate(true); return true;
}, [canEdit, /* … */]);

<SubTitle
  /* … */
  customButtons={canEdit ? [{ label: t(LBL.INPUT, '_Input'), action: handleInputOpen }] : []}
/>
<ShipmentWorkingDayOspInputModal open={inputModalOpen} onClose={() => setInputModalOpen(false)} onConfirm={handleInputConfirm} />
```

```tsx
// ② 입력 팝업 — components/<Page>InputModal.tsx (+ .module.scss: .content{flex column gap16 padding8} .buttonWrapper{flex end gap8})
<CustomDialog size={520} height={280} minWidth={520} minHeight={280} type='modaless' position='basic'
  open={open} handleClose={onClose} disableEnforceFocus
  customHeaderTitle={<div className='headerContainer'><div className='headerDot' /><h2 className='headerTitle'>{t(LBL.INPUT, '_Input')}</h2></div>}
  customContentArea={
    <div className={styles.content}>
      <Grid container rowSpacing={1}>
        <Grid size={12}><FormItem className={commonStyles.formItem} label={t(LBL.DAY_OF_THE_WEEK, '_Day of the week')} labelAlign='right' render={() => <CustomDropdown … />} /></Grid>
        <Grid size={12}><FormItem className={commonStyles.formItem} label={t(LBL.INPUT_VALUE, '_Input Value')} labelAlign='right' render={() => <CustomDropdown disabled={!target} … />} /></Grid>
      </Grid>
      <div className={styles.buttonWrapper}>
        <Button appearance='contained' priority='primary' size='medium' buttonLabel={t(LBL.OK, '_OK')} onClick={handleOk} />
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel={t(LBL.CLOSE, '_Close')} onClick={onClose} />
      </div>
    </div>}
/>
// 열릴 때만 기본값으로 초기화(useEffect [open]) — AS-IS 기본(예: EveryDay / Y). handleOk: if (onConfirm(target, value)) onClose();
```

| # | 규칙 | 이유 |
|---|---|---|
| M1 | 조회영역에서 **일괄 입력 묶음 전부 제거**(대상 선택·입력값·Input 버튼) — 조회 파라미터에도 넣지 않는다 | 조회조건이 아니라 편집 도구(기준표 BUTTON_AREA) |
| M2 | 버튼 = SubTitle `customButtons` 1개. 라벨 = AS-IS 버튼 문구의 LBL(`t(LBL.INPUT, '_Input')` — 정본). 노출 = **편집 권한 게이트**(`canEdit`/`hasButton('SAVE')` 등 화면의 편집 판정과 동일) | 권한 없는 사용자에게 편집 도구 비노출(C1 동적 버튼 권한) |
| M3 | 열기 가드 = **조회 선행**(`hasSearched` 아니면 MSG SEARCH_FIRST) | 빈 그리드에 일괄 입력 방지 |
| M4 | 팝업 = 화면 종속 `components/<Page>InputModal.tsx` · `CustomDialog` 520×280 modaless basic · FormItem(`commonStyles.formItem`, labelAlign right) · OK(contained primary) / Close(outlined) · **열 때만 기본값 초기화** | 정본과 같은 모양·동작("한 사람이 개발한 것처럼") |
| M5 | 콤보/룩업 원천 = 조회영역에 있던 것 그대로(`useTabComboQueries`/`useTabLookupQueries` — 하드코딩 금지 E3). 입력값 비활성 조건(대상 미선택 시)도 AS-IS 그대로 | AS-IS 동작 보존 |
| M6 | OK = `onConfirm(...)` 이 **boolean** 반환: 성공 true → 닫힘 / 가드·검증 실패 false → 알림 후 팝업 유지 | 입력 재시도 가능 |
| M7 | 셀 기록 = `setCellData(…, true)` + **EditTracker.storeChange**(원값 보관) → `invalidate`. **저장 SP 호출 금지**(Save(F7) 가 EditTracker 로 저장) | 저장 payload 단일 출처(E7 CRUD_TYPE) · 되돌리기 가능 |
| M8 | 대상 분기·검증 메시지 = AS-IS Input 핸들러 원문 그대로(SelectDay=선택 셀 · EveryDay=전체 · 요일별) · 메시지 ID 는 문구로 찾은 TO-BE ID(E5) | AS-IS 한 줄도 누락 없음 |
| M9 | `__asis-mapping__.md`: 조회영역 컨트롤 행은 '구현'(위치 = InputModal) · Input 버튼 행 = '구현'(customButtons + InputModal) — '해당없음' 처리 금지 | 기능은 사라지지 않고 이동했다 |

---

## §3. 금지 (MUST NOT)

| # | 안티 패턴 | 결과 |
|---|---|---|
| X1 | 일괄 입력 콤보·입력값·Input 버튼을 **조회영역에 그대로** 두기 | 기준표 위반(SC2) · 조회조건과 편집 도구 혼재 |
| X2 | 팝업 OK 에서 **저장 SP 직접 호출** | 저장 경로 이원화 · 미저장 가드(dirty) 무력화 |
| X3 | 버튼 라벨 리터럴(`label: 'Bulk Update'`) — LBL 미사용 | 다국어 미적용(I18N2) · 화면마다 이름 다름 |
| X4 | 공용 `SubTitle`/`CustomDialog` 기본값 변경으로 해결 | shared default 변경 금지 |
| X5 | 조회 없이 팝업 열기 허용 · 권한 없는 사용자에게 버튼 노출 | M2·M3 |
| X6 | 화면마다 다른 팝업 모양(크기·버튼 순서·초기화 시점) | "한 사람이 개발한 것처럼" 위반 |

---

## §4. 현행 화면 상태 (2026-10-23 확인)

| 화면 | 상태 | 비고 |
|---|---|---|
| SCP0096 Shipment Working Day(OSP) | ✅ **정본** | `customButtons [{ label: t(LBL.INPUT,'_Input') }]` + `ShipmentWorkingDayOspInputModal` |
| SCP0098 CAPA (Mobility IT) | △ 선례(패턴 동일) | `BulkUpdateModal` — 버튼 라벨이 리터럴 `'Bulk Update'`(X3) · 파일 위치 `components/modals/` · 비동기 onConfirm(Promise<boolean>) 허용. touch 시 사용자 1줄 확인 후 정본으로 맞춤 |
| SCP0019 Work Calendar(OSP) | ❌ 미적용 | `working-time/components/WorkingTimeForm.tsx:175-219` — Day of the week·Input Value·Input 버튼이 조회영역에 그대로. 보정(touch) 시 본 hook 으로 이동 |
| SSP0005 Shipment Working Day | ❌ 미적용 | `shipping/.../shipment-working-day/components/ShipmentWorkingDayForm.tsx:40,62-92` — Day of the week·Input Value·Input 버튼이 조회조건 격자 안. 보정(touch) 시 본 hook 으로 이동 |

- **소급 일괄 수정 금지** — 화면 신규 작성·보완(touch) 시 적용. FE 수정은 사용자가 FE 직접 수정을 요청한 경우에만(2026-10-23 지시).

---

## §5. PRE-WRITE 체크

```
[ ] 1. AS-IS 조회영역에서 Input(Apply) 버튼과 짝 컨트롤(대상 선택·입력값) 식별 — 기준표 BUTTON_AREA 'Bulk Update' 행 · AS-IS 핸들러 원문
[ ] 2. 조회영역·조회 파라미터에서 제거 (M1)
[ ] 3. SubTitle customButtons 1개(LBL 라벨 · 편집 권한 게이트) + 조회 선행 가드 (M2·M3)
[ ] 4. components/<Page>InputModal.tsx — 정본 모양(520×280 modaless · FormItem · OK/Close · 열 때 초기화) (M4·M5)
[ ] 5. onConfirm boolean · EditTracker 경유 셀 기록 · 저장 SP 호출 없음 · AS-IS 분기·검증·메시지 그대로 (M6~M8)
[ ] 6. __asis-mapping__ 행 '구현'(위치 = InputModal / customButtons) (M9)
```

## §6. POST-WRITE 검증

- 하네스 `tools/Harness/check.js` **BU1**: 기준표가 'Bulk Update' 로 표시한 화면인데 ① `customButtons` 에 Input/Bulk 버튼이 없거나 ② `*InputModal.tsx`/`BulkUpdateModal.tsx` 가 없으면 경고(`--final` BLOCK) · ③ 버튼 라벨 리터럴(LBL 미사용)이면 경고.
- 조회조건 기준표 게이트 **SC2**: 조회영역에 일괄 입력 컨트롤이 남아 있으면 경고/차단.
- E2E smoke '조회조건 동작': 기준표 제외 조건(BUTTON_AREA)이 조회영역에 남아 있으면 FAIL.
- 화면 실측: 조회 → Input → 팝업(대상·값) → OK → 대상 셀 값 변경(노란 편집 표시) → Save(F7) → 재조회 반영.

---

## §7. 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-10-23 | 신설 — 사용자 지시(SCP0096 Input 버튼 팝업 = 공통 패턴). 정본 SCP0096 · 선례 SCP0098 · 대상 SCP0019/SSP0005. 동반: RULESET_MASTER §4·카운트 155 · 00_INDEX · 카테고리 04/00 · TRIGGER_ROUTER T05 · UI_MANDATORY_CHECKLIST · VM 룰 E14 · 하네스 BU1·GEN_NOTES §12 |
