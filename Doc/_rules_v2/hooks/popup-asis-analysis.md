# Hook — popup-asis-analysis (Popup 9 category 정밀 분석 의무)

> **트리거**: POPUP 작업 / 신규 modal 작성 시
>
> **목적**: AS-IS popup 의 모든 검색조건 / 표시 컬럼 / 이벤트 / 콜백 4축 100% 매핑

---

## §0 PRE-WRITE 9 단계 의무

> 메모리 `feedback_popup_asis_precision.md` + 룰 25 §3.3.1:

- [ ] **1. AS-IS popup .cs 처음~끝 read** (UsrButton/UsrCombo/spdMain 등 모든 컨트롤 식별)
- [ ] **2. .Designer.cs 처음~끝 read** (좌표 + parent + visible 모든 인벤토리)
- [ ] **3. `protected override` 5 메서드 모두 분석** (Form_Load / FindButton / OnClickFindButton / Closed / 기타)
- [ ] **4. 모든 SP 호출 인벤토리** (`FoxDataClient → SP.NAME`)
- [ ] **5. DefColumns / SetColumnCount 의 모든 표시 column 인벤토리** (binding + header + width)
- [ ] **6. 권한 처리 패턴** (`_SAVE_AUTH` / `_AUTH` filter flag)
- [ ] **7. Edit toggle 패턴** (LockColumn / UnLockColor)
- [ ] **8. bulk save 패턴** (다중 선택 시 처리)
- [ ] **9. 호출자 화면 인벤토리** (`grep -rn "new XxxPopup" GSCM/`)

→ 9 단계 모두 완료 후 `_asis/01_popups/{popup-name}.md` 작성 (9 category 템플릿).

---

## §1 표준 TO-BE modal 작성 (룰 10 §3)

- [ ] **CustomDialog** 사용 (`@shared/components`) — `Dialog` (MUI) 직접 사용 금지
- [ ] **position='basic'** 명시 (중앙 표시 — `position='overflow'` 사고 회피)
- [ ] **height 명시 안 함** (DEFAULT_HEIGHT='50vh' 자동 — SCSS `min-height: 70vh` 강제 금지)
- [ ] **SCSS Module** 사용 (`*.module.scss`) — global CSS / inline style 금지
- [ ] **setAlert / setConfirm** (`@shared/hooks`) — `window.alert` 금지
- [ ] **useMemo preSearchParams** (refetch loop 방지)

---

## §2 POST-WRITE 검증

```bash
MODAL="features/{domain}/src/components/{newModal}/{Name}Modal.tsx"
test -f "$MODAL" || exit 0

# 1. CustomDialog + position='basic'
grep -c "<CustomDialog" "$MODAL"   # ≥ 1
grep -A 5 "<CustomDialog" "$MODAL" | grep -c "position='basic'"   # ≥ 1

# 2. Dialog (MUI) 직접 사용 금지
grep -cE "from '@mui/material'.*Dialog\b|import \{.*Dialog\b.*from '@shared/lges'" "$MODAL"   # = 0

# 3. SCSS Module min-height vh 강제 금지
SCSS="${MODAL%.tsx}.module.scss"
test -f "$SCSS" && grep -cE "min-height: \d+vh|height: \d+vh" "$SCSS"   # = 0

# 4. useMemo preSearchParams (refetch loop)
grep -B 2 "preSearchParams" "$MODAL" | grep -c "useMemo"   # ≥ 1 (사용 시)

# 5. window.alert / window.confirm 금지
grep -cE "window.alert\(|window\.confirm\(" "$MODAL"   # = 0
```

---

## §3 신규 modal vs 공용 11종 우선 사용 (메모리 룰)

> 메모리 `reference_public_modals_master_components.md`:

**의무 순서**:
1. **공용 11종 인벤토리 확인** (`@master/components/index.ts`): ProjectByDivisionModal / ItemByDivisionModal / CustomerModal / TeamModal / RegionModal / StorageLocationModal / OwnerByDivisionModal / OwnerModal / ProjectModal / ColumnSettingModal / SearchFields
2. **AS-IS popup ↔ 공용 11종 매핑** (`_asis/01_popups/00_inventory.md` §2)
3. **매핑 modal 있음 → 재사용**: 격차 항목 (검색조건 / 표시컬럼 / 이벤트) 보강만 (`headerTitle?` prop override 등)
4. **매핑 modal 없음 → 신규 작성** (`@master/components/{newModal}/`)

→ 메모리 `feedback_deploy_package_completeness.md`: 신규 modal 작성 시 메타 SQL 5종 (API_M + BTN_MPG + PROC_M + body + SHEET_COLUMNS) 동봉 의무.

---

## §4 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| Popup 9 category 템플릿 | `_asis/01_popups/__POPUP_TEMPLATE__.md` |
| Popup 인벤토리 | `_asis/01_popups/00_inventory.md` |
| 공용 modal 11종 | `_tobe/10_popup_modal.md` §1 |
| 신규 modal 작성 | `_tobe/10_popup_modal.md` §3 |
| Deploy 패키지 완전성 | 메모리 `feedback_deploy_package_completeness.md` |
| CustomDialog position='basic' | 메모리 `feedback_popup_dialog_layout.md` |
