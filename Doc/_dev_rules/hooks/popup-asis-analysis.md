# Hook — POPUP 화면 As-Is 원시소스 정밀 분석 + SCSS 적용 의무

> ⭐ **2026-06-01 신규.** POPUP 작업 시 As-Is `.cs` + `.Designer.cs` 전체 Read 의무. 추측/단순화 절대 금지. SCSS Module 강제.

작성: 2026-06-01 (DMF0043_ContributeRatePopup 작업 후 사용자 요구 + 사고 사례 반영)

상위 룰: 룰 25 §3.3.1 / 룰 24 §3.5 / 룰 31 §5.0

---

## §0. 트리거

POPUP 신규 작성 또는 기존 POPUP 수정 작업 시 본 hook 의 모든 단계 의무.

---

## §1. AS-IS 원본 정밀 Read 9단계

| 단계 | 작업 | 사고 방지 |
|---:|---|---|
| 1 | `Doc/_legacy_source/.../POPUP/{POPUP_NAME}.cs` **전체 Read** (수백~수천 라인) | 일부만 읽고 단순화 금지 |
| 2 | `Doc/_legacy_source/.../POPUP/{POPUP_NAME}.Designer.cs` **전체 Read** | 컨트롤 인벤토리 누락 방지 |
| 3 | `protected override` 메서드 모두 추출 (FindButton/EditButton/InsertButton/SaveButton/DeleteButton) — BaseForm default vs 화면 override | Edit 모드 동작 정확 매핑 |
| 4 | `FoxDataRequest("..._SP_NAME")` 호출 모두 추출 — LOAD / SAVE / 부가 SP | SP signature 누락 방지 |
| 5 | DefColumns struct 컬럼 추출 — binding / header / readOnly / lock 패턴 | column metadata 1:1 |
| 6 | 권한 분기 (`UserInfoContext.Current["NowGroupID"]`) 확인 — admin only CRUD vs 모두 | 권한 누락 방지 |
| 7 | Edit toggle 동작 (`SwitchLock` + `LockColumn`/`LockRange`) — 영구 잠금 컬럼 vs 편집 가능 | 일부 컬럼 read-only 정확 매핑 |
| 8 | bulk save 패턴 (^ 구분 string × N) vs row-by-row | mutate / apiClient.post 선택 |
| 9 | MSG i18n 코드 모두 추출 (`MessageHelper.GMessageBox("MSGXXXXX")`) | 사용자 메시지 누락 방지 |

---

## §2. To-Be 작성 의무

| 항목 | 의무 | 룰 |
|---|---|---|
| SCSS Module 강제 | `{Popup}.module.scss` — inline style 절대 금지 | 룰 03 / 룰 24 §3.5 |
| Dialog 컴포넌트 | `CustomDialog` (`@shared/components`) — `Dialog` 아님 | 룰 23 §1 |
| Grid 컴포넌트 | Wijmo `FlexGrid` + GridAction 표준 | 룰 12 §5 |
| Alert | `setAlert/confirm` (`useMessageStore`) — `window.alert/confirm` 금지 | 룰 14 |
| Button 매핑 | AS-IS 모든 button click 핸들러 1:1 (`hotkeyConfig` 표준 + `customButtons`) | 룰 31 §5.0 |
| AS-IS 라인 주석 | `// AS-IS {file}:{LNN}` 모든 매핑 코드에 명시 | 룰 24 §3 |

---

## §3. SCSS Module 패턴 (CustomDialog 영역 fit 의무)

```scss
.dialogContent {
  display: flex;
  flex-direction: column;
  gap: 12px;
  /* ❌ height: 100% 또는 fixed 큰 height → CustomDialog 영역 초과 → footer 영역 잘림 */
  /* ✅ 자연 flex 흐름. gridWrapper 만 height 명시 */
  padding: 4px 0;
}

.gridWrapper {
  height: 300px;           /* fixed — 영역 예측 가능 */
  border: 1px solid #e0e4e9;
  border-radius: 4px;
  overflow: hidden;
  background: white;
}

.actionBar {
  display: flex !important;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  padding: 12px 8px;
  border-top: 1px solid #e0e4e9;
  background: white;
  flex-shrink: 0;
  position: sticky;        /* 가시성 보장 */
  bottom: 0;
  z-index: 10;
  min-height: 48px;
}
```

**금지**:
- ❌ JSX 의 `style={{ }}` inline (Wijmo `height: '100%'` 1건만 표준 허용)
- ❌ Global className (`className='headerContainer'`) — 모두 `className={styles.X}` module hash
- ❌ `dialogContent height: 100%` 또는 큰 fixed (600px+) — CustomDialog 영역 초과 시 actionBar 잘림

---

## §4. `__asis-mapping__.md` POPUP 섹션 의무

```markdown
## POPUP 매핑 (룰 24 §4 + 룰 25 §3.3.1)

| # | POPUP | AS-IS .cs / Designer.cs | LOAD SP | SAVE SP | Button 5종 | Edit Toggle | 권한 | 상태 |
|---:|---|---|---|---|---|---|---|---|
| 1 | DMF0043_ContributeRatePopup | `DMF0043_ContributeRatePopup.cs:395 + Designer.cs:362` | `GET_CONTRIBUTE_RATE_POPUP(p_yyyy)` | `SAVE_DM_MST_CONTRIBUTE_VER` (^ bulk) | Find/Edit/Insert/Save/Delete | VER_SEQ 영구 잠금 + 나머지 4 동적 | ADMIN only (현재 모두) | ✅ |
```

❌ 1건 이상 → PR Reject

---

## §5. 사고 사례 (2026-06-01 DMF0043_ContributeRatePopup)

| 사고 | 원인 (위반한 단계) | Fix |
|---|---|---|
| 화면 데이터 미조회 | §1.4 Agent 가 sheet 매핑 `VERSION_POPUP` 선택 → BE 가 다른 popup SP (`GET_CONT_VIEW_VERSIONPOPUP`) 호출 | sheet 를 `RATE_POPUP` 으로 정정 |
| CRUD 버튼 미표시 | §3 `dialogContent height: 100%` → CustomDialog 영역 외 push → actionBar 가려짐 | `dialogContent` height 제거 + `actionBar position: sticky bottom` |
| SCSS 부분 미적용 | §3 일부 className 이 global (`'headerContainer'`) → module hash 안 적용 | 모두 `styles.X` 로 변경 |
| Edit toggle 잘못 적용 | §1.7 AS-IS L174 `SwitchLock + LockColumn(0, VER_SEQ, true)` 의미 — VER_SEQ까지 잠금 유지, 나머지 4컬럼 편집 — 부분 read-only 정확 매핑 필요 | column.isReadOnly 동적 변경 + VER_SEQ 영구 lock |

---

## §6. PR 머지 게이트 자기 점검

- [ ] AS-IS `.cs` + `.Designer.cs` 전체 Read 했음 (offset/limit 분할이라도)
- [ ] `protected override` 5 메서드 모두 매핑 (또는 명시적 비활성 + 사유)
- [ ] SP 3종+ (LOAD/SAVE/콤보) 매핑 + PROC_M / API_M 메타 확인
- [ ] DefColumns 5+ 컬럼 모두 매핑 (binding / header / readOnly / lock)
- [ ] 권한 분기 코드 또는 TODO 주석
- [ ] Edit toggle 동작 정확 매핑 (어느 컬럼 영구 잠금)
- [ ] SCSS Module + Module 외 className 0건
- [ ] CustomDialog 영역 안에서 actionBar visible (실제 화면 확인)
- [ ] `__asis-mapping__.md` POPUP 섹션 ❌ 0건

---

## §7. 관련 룰

- 룰 25 §3.3.1 — POPUP As-Is 원본 정밀 분석 의무
- 룰 24 §3.5 — Inline style / Global className 금지
- 룰 31 §5.0 — Figma button 명세 + hotkeyConfig 표준
- 룰 23 §1 — `CustomDialog` (Dialog 아님) + Wijmo FlexGrid
- 룰 14 — `setAlert` (`window.alert` 금지)
- 룰 12 §5 — GridAction hotkey 표준
