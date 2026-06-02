# Hook — As-Is 버튼 기능 → To-Be hotkeyConfig 매핑 의무

> ⭐ **신규 화면 생성 시 As-Is `.cs` 의 `protected override XxxButton()` 5+1대 분석 후, To-Be `hotkeyConfig` 의 각 버튼 활성화 (function) / 숨김 (false) 을 결정**
>
> 위반 시: As-Is 에 없는 버튼이 To-Be 화면에 표시되거나 (UX 혼선), As-Is 에 있는 버튼이 누락 (기능 손실).

작성: 2026-06-02 (DMF0072 NN Master Mapping 신규 화면 작업 + 사용자 명시 요구 반영)
관련 룰: `25_NEW_SCREEN_MANDATORY_CHECKLIST.md` §1.6, `12_GRID_COMMON.md`
관련 메모리: `feedback_asis_button_mapping_mandatory.md`

---

## §0. 배경 (사용자 명시 요구 — 2026-06-02)

> "신규화면 생성 Rule 에 As-is 기능 확인해서 Tobe 화면의 공통 버턴(Insert, Delete, Save) 활성화 여부도 결정해서 화면에 보이게 할지, 안보이게할지 반영해주세요."

To-Be 의 `SubTitle` 컴포넌트는 `hotkeyConfig` prop 으로 공통 버튼 6개 (search/insert/save/delete/manual/upload) 의 활성화 여부 결정:

| 값 | 동작 |
|---|---|
| `function` | 버튼 표시 + onClick 시 함수 실행 |
| `false` | 버튼 **숨김** |

→ As-Is `.cs` 의 `protected override XxxButton()` 메서드 정의 여부에 따라 결정 의무.

---

## §1. As-Is 버튼 인벤토리 (As-Is GSCM 표준 5+1대)

| # | As-Is 메서드 | 위치 (.cs) | 동작 | To-Be 매핑 |
|---:|---|---|---|---|
| 1 | `FindButton()` | §4 Button 영역 | `FindData()` 또는 SP 호출 (조회) | `hotkeyConfig.search` |
| 2 | `InsertButton()` | §4 Button 영역 | `InsertRow()` — 신규 행 추가, 기본값 set, cellType combo | `hotkeyConfig.insert` |
| 3 | `DeleteButton()` | §4 Button 영역 | `siMain.Delete()` — 'I' (신규) 행 삭제 또는 row 마킹 | `hotkeyConfig.delete` |
| 4 | `EditButton()` | §4 Button 영역 | `siMain.SwitchLock()` + `LockRange` (수정 모드 toggle, 컬럼별 잠금) | (hotkeyConfig 미지원 — Wijmo IsReadOnly toggle 별도) |
| 5 | `SaveButton()` | §4 Button 영역 | `SaveData()` — Validation + SAVE SP 호출 (보통 `^` 구분 join) | `hotkeyConfig.save` |
| 6 | `ExcelButton()` | §4 Button 영역 | `SimplexelService.ExportFpSpread` — Excel 다운로드 | `SubTitle` 기본 Excel (별도 활성화) |

추가 hotkeyConfig 가능 항목:
- `manual` — As-Is 에 매뉴얼 다운로드 버튼이 있을 때 (예: PDF/Help) — 없으면 `false`
- `upload` — As-Is 에 업로드 버튼이 있을 때 (예: 엑셀 업로드) — 없으면 `false`

---

## §2. 결정 매트릭스 (As-Is 메서드 정의 → To-Be 매핑)

```
As-Is .cs 에서:
  protected override void XxxButton() { /* 비어있음 또는 정의 안 됨 */ }
    → To-Be hotkeyConfig.xxx = false (버튼 숨김)

  protected override void XxxButton() { 실제 로직 } 
    → To-Be hotkeyConfig.xxx = handleXxx (function — 구현 또는 placeholder)
```

**placeholder 패턴** (As-Is 에 기능 있지만 To-Be 미구현):
```ts
const handleInsert = () => {
  // TODO As-Is 1:1 구현 — InsertRow() : DefColumns.DATA_TYPE_CODE='SCM' 기본값 + cellType combo + ACTIVE_YN='Y'
  void setAlert({ type: 'alert', content: '미구현 — As-Is .cs L538 InsertRow() 참조' });
};
```

→ 버튼은 As-Is 정합성 위해 **표시** 하되, 클릭 시 명시적 안내 (silent fail 금지).

---

## §3. 신규 화면 작성 시 자기 점검 (PRE-WRITE)

```
☐ As-Is .cs 의 `§4 Button` 영역 전체 Read?
☐ `protected override FindButton()` 정의 있나? → hotkeyConfig.search 결정
☐ `protected override InsertButton()` 정의 있나? → hotkeyConfig.insert 결정
☐ `protected override DeleteButton()` 정의 있나? → hotkeyConfig.delete 결정
☐ `protected override SaveButton()` 정의 있나? → hotkeyConfig.save 결정
☐ `protected override EditButton()` 정의 있나? → SubTitle 수정 모드 toggle 별도 처리
☐ `protected override ExcelButton()` 정의 있나? → SubTitle 기본 Excel 또는 커스텀
☐ manual/upload 버튼은 As-Is 에 있나? → 없으면 false 명시
```

**1건이라도 ✗ → As-Is 미분석 상태로 hotkeyConfig 작성 금지**. 룰 25 §0 anti-simplification 위반.

---

## §4. 자동 검증 grep (POST-WRITE)

```bash
# 1. As-Is .cs 의 5+1대 버튼 메서드 추출 (현재 화면)
grep -n "protected override void \(Find\|Insert\|Delete\|Edit\|Save\|Excel\)Button" \
     Doc/_legacy_source/06_UIL/domain_{DM,SCM,Common,SCP,SSP,FP}/**/{화면ID}*/{화면ID}*.cs

# 2. To-Be hotkeyConfig 의 매핑 표 확인 (function or false 명시)
grep -A 10 "HotkeyConfig\s*=" nscm-fe/features/**/{화면-slug}/{화면명}.tsx
```

**산출물 검증 표** (`__asis-mapping__.md` 에 의무 기록):

| Button | As-Is 메서드 (라인) | As-Is 본문 요약 | To-Be 결정 | 비고 |
|---|---|---|---|---|
| Search | FindButton (L265) | FindData(true) | function (handleSearch) | 활성 |
| Insert | InsertButton (L270) | InsertRow() — DATA_TYPE='SCM' 기본 + ACTIVE_YN='Y' | function (TODO placeholder) | 표시 + 미구현 안내 |
| Delete | DeleteButton (L275) | siMain.Delete() — 'I' 행만 | function (TODO placeholder) | 표시 + 미구현 안내 |
| Save | SaveButton (L389) | SaveData() — Validation + ^ join SP 호출 | function (TODO placeholder) | 표시 + 미구현 안내 |
| Edit | EditButton (L281) | SwitchLock + LockRange | (별도 — IsReadOnly toggle) | hotkeyConfig 미지원 |
| Excel | ExcelButton (L398) | SimplexelService.ExportFpSpread | SubTitle 기본 | 활성 |
| Manual | 없음 | — | false (숨김) | |
| Upload | 없음 | — | false (숨김) | |

---

## §5. 위반 사례 (실제)

| 사례 | 잘못된 hotkeyConfig | 원인 | 결과 |
|---|---|---|---|
| DMF0072 신규 작성 (2026-06-02 사용자 지적 전) | insert/save/delete 모두 `() => undefined` (빈 함수) | As-Is .cs §4 Button 영역 미분석 | 버튼 표시되지만 클릭 시 silent fail. 사용자 혼선. |
| (가상) 위반 패턴 | manual/upload 를 As-Is 분석 없이 무조건 false | As-Is 검토 누락 | As-Is 에 upload 가 있으면 기능 손실 |

---

## §6. cross-ref

- **룰 25 §1.6** "As-Is 버튼 분석 의무" — 본 hook 의 entry point
- **룰 24 §3 As-Is Event 축** — `Click_Click` / `_Click` 이벤트 핸들러 매핑과 통합
- **룰 12 §2 SubTitle hotkeyConfig** — hotkeyConfig 의 정확한 type 정의
- 메모리 `feedback_asis_button_mapping_mandatory.md`

---

## §7. 변경 이력

- **2026-06-02 작성** (사용자 명시 요구 — DMF0072 NN Master Mapping 작업 후)
