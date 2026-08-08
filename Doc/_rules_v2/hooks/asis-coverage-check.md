# Hook — asis-coverage-check (As-Is 4축 100% 매핑 검증)

> **트리거**: PR 머지 게이트 (pre-submit 통합 검증의 일부)
>
> **목적**: AS-IS 의 모든 Event / API / Validation / Expression 이 TO-BE 에 1:1 매핑되었는지 확인
>
> **2026-08-06 SYS0017 근본원인 감사 계기 개정**: §0.0 원천 브리지(hook #105 산출 md 공식 원천 인정) + §0.1 총합 비교(TO≥AS) **폐지** → **이벤트 ID(E01~) 1:1 대사표 의무**.

---

## §0.0 ⭐ 원천 브리지 — hook #105 산출 md = 4축 **공식 원천** (2026-08-06 신설)

해당 화면에 hook #105(screen-analysis-workbook-standard) 0단계 선행 산출물이 존재하면 그것이 4축 대사의 **공식 원천**이다 (원시 .cs grep 은 보조·cross-check):

| 산출물 | 커버 축 |
|---|---|
| `Doc/화면분석서/{ID}_{화면명}_주요이벤트_상세분석.md` — **E번호(E01~) 체계** | Event + API(이벤트별 SP 바인딩) + Validation(이벤트별 MSG) |
| `Doc/화면분석서/{ID}_{화면명}_제약매트릭스_상세.md` — 제약 ID(A/B/C/D…) 체계 | Expression(잠금/편집규칙) + Validation(제약별 MSG) + 권한 게이트(§0.5) |

- **근거 (SYS0017 감사 (c))**: 기존 §0.1 원천이 AS-IS `.cs` grep 카운트뿐이라 **hook #105 md(E번호)와 연결 조항이 없었다** — 분석 md 에 E01~E18 전 조문이 실존했는데도(예: E14-4 백업 DataTable 까지 명기) 게이트가 이를 참조하지 않아 5건 미구현(E01/E07/E08·E09/E13/E14·E15) 이 통과했다.
- md 부재 화면: 원시 `.cs` grep(§0.1-B 의 EID 를 handler 단위로 자체 채번)으로 수행하되, hook #123 (T01M md 선생성) 적용 대상인지 먼저 판정.

## §0 4 축 cross-check (의무)

### §0.1 Event 축 — ⭐ 이벤트 ID **1:1 대사표** (총합 비교 폐지, 2026-08-06)

> ❌ **폐지**: 구 판정식 `TO_EVENTS ≥ AS_EVENTS` (총합 비교) — 카운트가 맞아도 **개별 이벤트 누락을 검출하지 못한다**
> (SYS0017: 다른 handler 가 수를 채워 총합 통과 → E01/E07/E13/E14/E15 미구현이 그대로 관통).

**의무**: `__asis-mapping__.md` 에 **EID(E01~) 별 1:1 대사표** — §0.0 원천 md 의 **모든 E번호를 행으로 전수 나열**하고, 각 행에 [구현 위치 `파일:라인`] 또는 [미구현 사유] 를 기입한다. **빈 칸 1개 = 게이트 실패.**

```markdown
## Event 매핑 (EID 1:1 — 원천: {ID}_주요이벤트_상세분석.md E01~E{NN})
| EID | AS-IS 동작 (원천 md 요약) | 구현 위치 (파일:라인) | 미구현 사유 (구현 시 공란) | 상태 |
|---|---|---|---|---|
| E01 | F5 포커스 그리드 분기 조회 | MailSetup.tsx:88 handleSearch 포커스 분기 | — | ✅ |
| E07 | Message Insert 마스터 승계 | — | (미구현이면 사유 필수 — 공란 = FAIL) | ⛔ |
| ... | (E번호 전수 — 건너뛰기 금지) | | | |
```

- 세부 항번(E16-4 등 결과 분기)도 원천 md 에 있으면 행 분리 유지.

**⭐ 도구 의무 (2026-08-07 신설 — `_artifacts/_diagnostics/asis_mapping_gate.py`)**:

1. **스켈레톤 선생성 = 구현 시작 전 의무**: 구현 첫 파일 작성 **전에** `--init` 으로 대사표를 생성한다
   (수기 표 작성 금지 — 추출 누락 방지. 기존 파일 있으면 신규 ID 만 append, 기입값 보존):
   ```bash
   python _artifacts/_diagnostics/asis_mapping_gate.py --init "Doc/화면분석서/{ID}_*_주요이벤트_상세분석.md" <페이지폴더>
   # 제약매트릭스 md 는 동일 prefix 존재 시 자동 포함. 추출 해상도 = 헤더 EID + 세부 항번(E16-4) + 제약 표 행
   ```
2. **완료 게이트 = `--check` PASS 의무**: 화면 작업 종료 선언 전 `--check <페이지폴더>` 가 **exit 0** 이어야 한다.
   판정: 전 행이 [상태=구현 + 구현 위치 기입] 또는 [상태=제외·해당없음 + 사유 기입]. 빈 사유 = FAIL.
   ui_gate_runner.py 섹션 (2) 가 이 검사를 자동 포함한다 (screen-completion-gate 참조).
3. ⭐ **CRUD·모달 매트릭스 축 (2026-08-07 확장 — 사용자 요구 "MAIN UI 와 모달의 CRUD 누락 0")**:
   `--init` 이 대사표에 `## CRUD·모달 매트릭스` 섹션을 자동 생성한다 —
   ① `CRUD:{EID}:{액션}` 행: CRUD 성격 이벤트(SEARCH/INSERT/DELETE/SAVE/EDIT 키워드 다중 분류)를 액션 축으로 재정렬
      (조회 전용 화면이면 SEARCH 행만 생성 — 강제 CRUD 행 없음, `해당없음+사유` 상태 허용)
   ② `MODAL:{이름}` 행: **MAIN UI 가 여는 모달 전수** = 분석 md 팝업 절(Pop*/…Modal/…Dialog 명칭) ∪ FE 실존 파일
      (`<페이지폴더>/**/*{Modal,Dialog}*.tsx`) 합집합. FE 에만 있는 모달 = "분석 근거 확인 필요" 행.
   빈 셀 = `--check` FAIL. 매트릭스만 별도 판정 = `--check --matrix-only` (ui_gate_runner 섹션 (5)).
   런타임 짝 = screen-completion-gate §0.5 **G6-6** (모달별 CRUD 왕복: 열기→편집→OK→DB 반영).

- 참고 grep (보조 — 대사표를 대체하지 못함):

```bash
CS="GSCM/06.UIL/.../DMF{XXX}_*.cs"
TOBE="features/{domain}/src/pages/{screen}/"
grep -cE "CellDoubleClick|CellEditEnded|SelectedIndexChanged|ComboSelChange|EditChange|TopChange|LeaveCell|ActiveSheetChanging" "$CS"   # AS-IS handler 인벤토리 확인용
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

## Event 매핑 (⭐ EID 1:1 — §0.1 양식. 원천 md 의 E번호 전수, 빈 칸 = 게이트 실패)
| EID | AS-IS (원천 md / .cs handler) | 구현 위치 (파일:라인) | 미구현 사유 | 상태 |
|---|---|---|---|---|
| E02 | spdMain_CellDoubleClick (binding=PROJECT) | components/MainGrid.tsx:141 handleGridDblClick | — | ✅ |
| E03 | cboDivision_SelectedIndexChanged | MailSetupForm.tsx:52 setSearchParams({divisionId}) | — | ✅ |
| ... | ... | ... | ... | ... |

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
# 1. EID 전수 대사 — 원천 md 의 E번호 수 = __asis-mapping__.md Event 표 행 수 (1:1)
SRC_EIDS=$(grep -coE "^#+ *E[0-9]{2}|\bE[0-9]{2}(-[0-9]+)?\b" "Doc/화면분석서/{ID}_*_주요이벤트_상세분석.md")
MAP_EIDS=$(grep -cE "^\| E[0-9]{2}" __asis-mapping__.md)
# SRC_EIDS 산식은 md 서식에 맞춰 조정 — 판정은 "원천 E번호 전수 = 표 행 수" 동일성

# 2. 빈 칸 검출 — 구현 위치·미구현 사유 둘 다 공란인 행 = 게이트 실패 (총합 일치로 면제 불가)
grep -E "^\| E[0-9]{2}" __asis-mapping__.md | awk -F'|' '$4 ~ /^ *—? *$/ && $5 ~ /^ *$/ {print "⛔ 빈 칸: " $2}'

# 사고 패턴 (메모리 룰): 4 축 누락 1 건이라도 = anti-simplification 위반
```

---

## §3 적용 룰 cross-ref

| 축 | 룰 |
|---|---|
| **원천 브리지 (§0.0)** | `screen-analysis-workbook-standard.md`(#105 — 0단계 주요이벤트 md E번호 + 제약매트릭스) + `screen-modal-cascade-filter-analysis.md`(#123 — md 부재 시 선생성) |
| Event | `_tobe/07_datagrid.md` (cellEditEnded / dblClick) + `_asis/02_screens/__TEMPLATE__.md` §6 |
| API | `_tobe/03_main_component.md` (useTabProcQuery) + `_tobe/11_be_controller_service.md` + `_asis/00_framework/02_DataService.md` |
| Validation | `_tobe/14_error_handling.md` (Phase 4 신규) + `_asis/00_framework/03_MessageHelper.md` (MSG ID 표) |
| Expression | `_tobe/08_column_meta.md` + `_tobe/07_datagrid.md` (cellEditEnded cascade) |
| Button | `_tobe/09_subtitle_hotkey.md` + `_asis/00_framework/01_BaseForm.md` (CRUD 6대 + Aux 4대) |


---

## §0.2 ⭐ AS-IS 이벤트 핸들러 인벤토리 축 (2026-08-08 신설 — 사용자 요구)

> 사용자 질의: "앞으로는 UI 생성 시 AS-IS 의 모든 것을 놓치지 않도록 개발을 진행하고 CRUD 기능 테스트까지 완벽하게 할 수 있나요?"

**구조적 한계 인정**: §0.0/§0.1 의 대사표는 **분석 md 의 E번호**에 묶여 있고, **AS-IS 소스의 실제 핸들러
목록**에는 묶여 있지 않다. 따라서 **분석서가 놓친 핸들러는 게이트도 통과**시킨다.

> 2026-08-08 실측 — DMF0082 AS-IS `.cs` 의 UI 이벤트 핸들러는 **25개**인데 대사표가 이름으로 참조하던 것은
> **6개**뿐이었다(나머지 19개는 실제로 구현돼 있었으나 **기계적 대조가 없었다**).
> 같은 날 SP 프롤로그 누락도 동일 구조 — 분기 본문만 보고 첫 `IF @Code` 이전을 아무도 안 물었다.

### 의무

1. 구현 착수 전 / 완료 게이트 전에 실행:
   ```
   python _artifacts/_diagnostics/asis_mapping_gate.py --handlers <MENU_ID> <페이지폴더>
   python _artifacts/_diagnostics/asis_mapping_gate.py --check <페이지폴더> [--handlers-only]
   ```
2. `HANDLER:{메서드명}` 행 전수를 **구현(위치 필수) / 제외·해당없음(사유 필수)** 로 채운다. 빈 칸 = FAIL.
3. **사문(빈 몸통, 라이브 3행 이하)** 은 '제외' + 사유 — AS-IS 사문은 **미이관이 파리티**.
4. **플랫폼 차이**는 '해당없음' + 사유. 예(DMF0082 실측):
   `spdMain_KeyUp` = Ctrl+V 감지해 `ClipboardPaste()` 를 수동 호출하는 WinForms 배관 →
   Wijmo 는 `pastingCell`/`pastedCell` 로 네이티브 처리하므로 불요.
   `spdMain_EditChange` = `bPasteContinue` 내부 상태 플래그 → TO-BE 불요.
5. 추출은 `.cs` 의 **주석 제외 라이브 코드** 기준이며, 핸들러별 라인수를 함께 남겨 사문 판정 근거로 쓴다.

### 남는 사각지대 (명시 — 은폐 금지)

- 핸들러 **이름 규칙**을 벗어난 진입점(디자이너 배선만 있는 익명 핸들러 등)은 추출되지 않는다.
- 핸들러 **내부의 개별 분기**까지는 세지 않는다(그 축은 §0.1 EID + hook #117 §5.12 호출지점 대사가 담당).
- 이 축은 "AS-IS 에 있는데 아무도 안 물어본" 경로를 막을 뿐, **구현 품질**은 보증하지 않는다.


---

## §0.3 ⭐ 제약매트릭스 전수 편입 + **조용한 누락 차단** (2026-08-08 신설)

> 사용자 질의: "구현 품질을 올리기 위해 상세분석 MD 를 우선 작성하고 이를 기반으로 진행·분석하면 어떨까요?"

**분석 MD 는 문제가 아니었다.** DMF0082 는 상세분석 MD 5종을 이미 갖췄고, 2026-08-08 에 발견한 결함이
**전부 그 MD 에 라인 번호까지 적혀 있었다**:

| 결함 | 분석 MD 원문 |
|---|---|
| 기본 배분요일 FE 하드코딩 | 제약매트릭스 `P-23` — "BUCKET 빈값/0000000 → DEFAULT_BUCKET_DAY 룩업(sDefaultDay) … default 월요일" |
| CELL_PROD_SITE_ID 캐스케이드 부재 | 상세동작 :210 — "콤보 cascade: ItemId→CELL_PROD_SITE_ID" |

**진짜 원인은 추출기 정규식이 문서 ID 형식과 어긋나 조용히 흘린 것**이다:

| 대상 | 실제 형식 | 구 패턴 | 결과 |
|---|---|---|---|
| 제약 **200행** | `A-15` `P-23` `DP-13` `X-29` | `[A-K]\d{1,2}` (하이픈·P/S/X 불가) | **전량 누락** |
| EID 세부 **11행** | `E01-A` `E01-B` `E08-C` | `E\d(-\d)?` (숫자 접미만) | **전량 누락** |

→ "20/20 PASS"·"45/45 PASS" 는 실제로 **6 EID 만 검사한 결과**였다.

### 의무

1. **제약매트릭스 md 를 `--init` 인자에 반드시 포함**한다. 제약 ID 는 `[A-Z]{1,3}-?\d{1,3}` 를 지원한다.
2. **조용한 누락 차단**: 대사표에 *ID 행 꼴인데 파싱 안 되는* 행이 있으면 **FAIL** 이다
   (`RE_ID_LOOKALIKE`). 형식이 바뀌면 조용히 통과하지 못한다.
3. `--init` 은 **자기가 관리하는 2개 섹션만 교체**하고 나머지(핸들러 인벤토리·토큰 대사표 등)는 보존한다.
   (2026-08-08 이전에는 파일을 통째로 덮어써 다른 축을 파괴했다.)
4. 표 셀 안에서 `|` 는 **`／` 로 치환**한다. 이스케이프 파이프(`\|`)는 셀 분리를 밀어내 상태 판정을 깨뜨린다.

### §0.3-b ⭐ 추출 수와 **문서 자체 카운트**를 대조하라 (2026-08-08 추가)

행이 추출됐다고 전수가 아니다. 분석 md 가 §축별 카운트를 갖고 있으면 **그 값과 대사표 행 수를 축별로 대조**한다.
DMF0082 실측 — 1차 추출 200행이 "전수"로 보였으나 문서 자체 카운트는 **224** 였다. 차이 24 의 원인:

| 유형 | 실례 | 손실 |
|---|---|---|
| **범위 축약 행** | `\| PL-05~18 \| LockRange(...) ×14 \|` — **1행이 14건** | 13 |
| **ID 컬럼 없는 표** | §1.2 division 파라미터 흐름(대상／파라미터／라인 3열) | 10 |

→ 도구 대응: `RE_TABLE_RANGE` 로 범위 행을 **개별 ID 로 전개**(`[범위행 전개 k/n]` 표기),
  ID 없는 데이터 표는 `--init` 이 **건수를 warn 으로 보고**(수기 ID 부여 후 편입).
  ⚠️ 요약표(§축별 카운트 등)는 제약이 아니므로 보고 건수 전부를 편입 대상으로 오해하지 말 것 —
  DMF0082 보고 28건 중 실제 제약은 10건, 나머지 18건은 요약·주석표였다.

### 선례 (DMF0082, 2026-08-08)

대사표 **20행 → 280행**(EID 17 + CRUD 7 + 모달 7 + 핸들러 25 + 제약 **224**) 전수 PASS.
제약 224 = 문서 §9 축별 카운트와 **11개 축 전부 일치**(D 19 / DPF 10 / DP 13 / A 15 / M 25 / P 24 /
F 10 / L 14 / PL 37 / S 28 / X 29). 판정 내역: 구현 **160** / 제외 **41**(X 비활성 29 + 보류·사문 12) /
해당없음 **23**(플랫폼 차이 — WinForms Lock 복원·팝업 권한 우회·12월 W01 클라 보정·82 조회전용 키잠금 14 등).


---

## §0.4 ⭐ 단위테스트 — "값이 맞는가" 축 (2026-08-08 신설)

§0.1~§0.3 은 **누락 없음**을 강제한다. 인용 실재성 검사(`--citations`)도 "코드가 거기 있다"까지다.
**"AS-IS 와 동일하게 동작한다"는 아무도 증명하지 않는다.**

> 2026-08-08 실사고 — 함수는 존재했고 대사표는 "구현"이었는데 **주배분 분기식에 버그**가 있었고
> **LOC 월 기준일이 일요일**이었다. 배분 로직이 틀리면 **저장되는 수치가 틀린다**.

### 의무

1. **순수 함수부터 값으로 못 박는다.** 배분·편집판정·포맷 같은 계산 로직은 DOM 없이 테스트 가능하다.
   각 테스트에 **AS-IS 라인 인용 + 제약 ID(M-xx/P-xx)** 를 남긴다.
2. **테스트가 실효적인지 먼저 증명한다** — 수정 전 코드로 되돌려 **해당 테스트가 실제로 실패하는지** 확인.
   (도구·게이트를 만들 때와 동일한 절차. 통과만 보고 안심하면 그 테스트는 아무것도 지키지 않는다.)
   선례: DMF0082 결함 2건 재주입 → 회귀 테스트 **3건 정확히 실패** → 원복 후 18/18 통과.
3. `ui_gate_runner` **섹션 9** 가 페이지 폴더의 `*.test.ts(x)` 를 실행한다. 테스트 0건 = WARN.
4. ⭐ **"값 틀림(FAIL)" 과 "환경 깨짐(ERROR)" 을 구분**한다. 섞으면 게이트가 통째로 무시된다.
   DMF0082 실측 — `useForecastPriceStore.test.tsx` 는 jsdom 초기화 실패
   (`MIMEType is not a constructor`, Node↔jsdom 버전 불일치)로 **한 번도 실행된 적이 없었다.**
   존재하는데 실행 불가한 테스트 = **지키는 게 없는 테스트** → 환경 결함으로 별도 보고한다.

### 남는 사각지대

브라우저 렌더링·조작감(레이아웃·그리드 반응)은 여전히 **사용자 최종 테스트** 영역이다.
단위테스트는 계산의 정확성만 보증한다.
