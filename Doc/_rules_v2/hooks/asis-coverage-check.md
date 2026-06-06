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
