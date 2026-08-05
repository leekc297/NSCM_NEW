# Hook — asis-coverage-check (As-Is 4축 100% 매핑 검증)

> **트리거**: PR 머지 게이트 (pre-submit 통합 검증의 일부)
>
> **목적**: AS-IS 의 모든 Event / API / Validation / Expression 이 TO-BE 에 1:1 매핑되었는지 확인

---

## §0 4 축 cross-check (의무)

### §0.1 Event 축

```bash
CS="GSCM/06.UIL/.../DMF{XXX}_*.cs"
TOBE="features/{domain}/src/pages/{screen}/"

# AS-IS event 카운트
AS_EVENTS=$(grep -cE "CellDoubleClick|CellEditEnded|SelectedIndexChanged|ComboSelChange|EditChange|TopChange|LeaveCell|ActiveSheetChanging" "$CS")

# TO-BE event handler 카운트
TO_EVENTS=$(grep -rcE "dblClick=|cellEditEnded=|onChange=" "$TOBE" | awk -F: '{sum+=$2} END {print sum}')

# 매핑 의무: TO_EVENTS ≥ AS_EVENTS (TO-BE 가 더 통합적일 수 있음)
```

### §0.2 API 축

```bash
# AS-IS DataService / FoxDataClient 호출
AS_API=$(grep -cE "DataService\.|FoxDataClient" "$CS")

# TO-BE useTabProcQuery / useProcMutation / useTabComboQueries
TO_API=$(grep -rcE "useTabProcQuery|useProcMutation|useTabComboQueries|apiClient\." "$TOBE" | awk -F: '{sum+=$2} END {print sum}')

# 매핑 의무: 호출 의미별 1:1
# (예: GetDMInnerTable("MyDivision") → useTabComboQueries({filters: ['MyDivision']}))
```

### §0.3 Validation 축

```bash
# AS-IS MessageHelper.GMessageBox
AS_VAL=$(grep -oE "MSG\d{5}" "$CS" | sort -u | wc -l)

# TO-BE setAlert / setConfirm + i18n key
TO_VAL=$(grep -roE "t\('MSG\d{5}'" "$TOBE" | sort -u | wc -l)

# 매핑 의무: TO_VAL ≥ AS_VAL (각 MSG ID 사용)
```

### §0.4 Expression 축

```bash
# AS-IS LockColumn / LockRange / SetValue Auto-Sync / SetBGColor
AS_EXPR=$(grep -cE "LockColumn|LockRange|SetBGColor|\.SetValue\(" "$CS")

# TO-BE column meta + cellEditEnded handler
# - LockColumn → column meta `_inputEditType: 'D'`
# - SetValue Auto-Sync → cellEditEnded handler + storeChange
# 수동 cross-check (자동 grep 어려움)
```

---

## §0.5 ⭐ 권한 게이트 축 — "범위 밖"을 "부재"로 읽지 말 것 (2026-07-30 신설)

> 실사고: DMF0082 환율 팝업의 편집 권한을 **5그룹으로 오판**했다. 근거로 삼은 제약매트릭스가
> `grep MSG00096` 0건 + *"해당 게이트는 호출되는 다른 팝업 소스에 있을 가능성 — **본 문서 범위 밖**"* 이라 적었는데,
> 그 단서를 무시하고 "부재"로 결론했다. 실제로는 `DMF0000_ExchangeRatePopup.DefineProperty()` L112~143 에
> `switch(NowGroupID) { case "ADMIN": case "DM ADMIN": break; default: Edit/Insert/Save 숨김 }` 가 있었다.

**두 가지 규칙:**

1. **분석서의 "범위 밖 / 미확인 / 가능성 있음" 표기는 "부재"가 아니다.**
   그 표기를 만나면 **가리키는 원본 파일을 직접 열어 확인**한다. 확인 전에는 "부재"로 단정 금지.
   호출되는 팝업·공용 폼(`DMF0000_*` / `SCM0002_*` 등)은 **화면 소스와 별개 파일**이므로 화면 .cs 만 훑으면 못 잡는다.

2. **권한 게이트는 메시지 검색으로 찾을 수 없다.** AS-IS 는 게이트를 3가지로 구현한다:

| 구현 | 탐지 방법 |
|---|---|
| **버튼 미표시** (`Set_ButtonVisibleFalse(list)` / `btnXxx.Dispose()` / `.Visible=false`) | `grep -nE "Set_ButtonVisibleFalse|\.Dispose\(\)|Visible\s*=\s*false|LayoutVisibility"` |
| **메시지 후 return** (`MessageHelper.GMessageBox("MSG00096")`) | `grep -oE "MSG[0-9]{5}"` |
| **컨트롤 잠금** (`LockColumn` / `LockRange` / `Enabled=false`) | `grep -nE "LockColumn|LockRange|Enabled\s*=\s*false"` |

`grep MSG00096` 0건은 **"권한 게이트 없음"이 아니라 "메시지형 게이트 없음"** 이다.
반드시 `switch (UserInfoContext.Current["NowGroupID"])` / `NowGroupID ==` 전수 검색을 함께 수행한다:

```bash
grep -nE 'NowGroupID' "$CS" "$POPUP_CS"          # 그룹 분기 전수
grep -nE 'case "(ADMIN|DM ADMIN|DM Planner|SCP Planner|DM Viewer)"' "$CS" "$POPUP_CS"
```

**보고 의무**: `__asis-mapping__.md` 에 **권한 매핑** 절을 두고 (그룹 → 허용/차단 객체 → TO-BE 근거 메타 행) 를 적는다.
TO-BE 메타(`SCM_ADM_USER_GR_MNU_BTN_MPG_M`)는 **시트(`SHT_NM`) 단위**이고 `useTabBtnPermissions` 는 **메뉴 단위로 평면화**한다 —
같은 BTN_CD 가 메인 시트와 팝업 시트에 함께 있으면 팝업만 조이려는 축소가 메인에 영향을 줄 수 있으니 시트별로 대조할 것.

## §1 격차 식별 + 보고

> 4 축 cross-check 실패 시 격차 list 작성:

```markdown
# __asis-mapping__.md (PR 머지 게이트 의무 파일)

## Event 매핑 (AS-IS N 건 → TO-BE M 건)
| AS-IS | TO-BE | 매핑 상태 |
|---|---|---|
| spdMain_CellDoubleClick (binding=PROJECT) | handleGridDblClick + binding 'PROJECT_CODE' | ✅ |
| cboDivision_SelectedIndexChanged | setSearchParams({ divisionId }) | ✅ |
| ... | ... | ... |

## API 매핑
| AS-IS | TO-BE | 매핑 상태 |
|---|---|---|
| DataService.GetDMInnerTable("MyDivision") | useTabComboQueries({filters:['MyDivision']}) | ✅ |
| FoxDataClient → DM.DMF0004_GET_DATA | useTabProcQuery<MENU_ID, SHEETS.SITE> | ✅ |
| FP_Log2 "SpeedUp" | (Phase 5 G3 후 usePerfTrace.measure) | ⏳ G3 |
| ... | ... | ... |

## Validation 매핑 (MSG ID)
| AS-IS | TO-BE | 매핑 상태 |
|---|---|---|
| MSG00096 권한 없음 | setAlert(t('MSG00096')) | ✅ |
| MSG00002 필수 항목 | useSaveWithValidation 자동 | ✅ |
| ... | ... | ... |

## Expression 매핑
| AS-IS | TO-BE | 매핑 상태 |
|---|---|---|
| LockColumn(col, true) | column meta `_inputEditType: 'D'` | ✅ |
| SetValue Auto-Sync SCM_SITE_ID | applySalesSite util + cellEditEnded | ✅ |
| ... | ... | ... |

## Button 매핑 (CRUD 6 + Aux 4)
| AS-IS .cs override | TO-BE hotkeyConfig | 매핑 상태 |
|---|---|---|
| FindButton() override | search: setFilters | ✅ |
| InsertButton() override | insert: handleInsert | ✅ |
| ... | ... | ... |
```

---

## §2 카운트 검증 (PR 머지 게이트)

```bash
# AS-IS event / API / validation 카운트 = __asis-mapping__.md 행 수
test $(grep -cE "CellDoubleClick|CellEditEnded|SelectedIndexChanged" "$CS") -le $(grep -c "^|" __asis-mapping__.md | awk '...')

# 사고 패턴 (메모리 룰): 4 축 누락 1 건이라도 = anti-simplification 위반
```

---

## §3 적용 룰 cross-ref

| 축 | 룰 |
|---|---|
| Event | `_tobe/07_datagrid.md` (cellEditEnded / dblClick) + `_asis/02_screens/__TEMPLATE__.md` §6 |
| API | `_tobe/03_main_component.md` (useTabProcQuery) + `_tobe/11_be_controller_service.md` + `_asis/00_framework/02_DataService.md` |
| Validation | `_tobe/14_error_handling.md` (Phase 4 신규) + `_asis/00_framework/03_MessageHelper.md` (MSG ID 표) |
| Expression | `_tobe/08_column_meta.md` + `_tobe/07_datagrid.md` (cellEditEnded cascade) |
| Button | `_tobe/09_subtitle_hotkey.md` + `_asis/00_framework/01_BaseForm.md` (CRUD 6대 + Aux 4대) |
