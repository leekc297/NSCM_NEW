# Hook #130 — ui-meta-consumption-and-crud-path-coverage (UI 메타 실소비 + CRUD 경로 전수 커버리지)

> **트리거**: UI 신규 추가(T01) / UI 보완·수정(T01M) / 화면 완료 선언 전(T20)
> **상위 룰**: `anti-simplification.md` · hook #126 `verification-completion-honesty`
> **성격**: 문서 hook(guide) + 자동 검사 항목(러너/grep) 동반

---

## §0 배경 — 사용자 지적 (2026-08-11, DMF0044 실사고 3종)

> "POPUP 의 DESIGN 부터 기능을 구현하지 않았던 부분, MAIN GRID 에 UI CATEGORY SETUP 데이터가
> 사용되지 않았던 부분, CRUD 기능이 완료되었다고 했는데 실제로는 오류가 다 발생하고 있었던 부분이
> **치명적인 보완사항**으로 확인됩니다."

⚠ **세 건 모두 기존 8게이트·9섹션 러너를 "종합 PASS" 로 통과한 상태였다.** 게이트가 본 것은
"메타가 존재하는가 / 타입이 맞는가 / 대사표 칸이 찼는가" 였고, **"화면이 그 메타대로 실제로
동작하는가"** 와 **"저장 경로를 전부 왕복했는가"** 는 아무도 보지 않았다.

| # | 실사고 (DMF0044) | 기존 게이트가 통과시킨 이유 |
|---|---|---|
| A | 메인 그리드가 `INPUT_TP_CD` 를 **안 봄**. FE 하드코딩 목록(`INSERT_LOCKED_COLUMNS`)으로 판정 → 메타 전 컬럼 `'S'`(Only Search)인데 화면은 입력 가능 | G3 는 메타 **존재/타입**만 검사. 러너 섹션4 도 값 화이트리스트만 봄. **소비 여부 미검사** |
| B | `ITEM_ID` 셀 팝업이 **아이콘 없음**(`CELL_CONTROL` 공백) → 사용자가 팝업 존재를 모름. 팝업 파라미터 `deptId` 가 `'ALL'` 하드코딩 → AS-IS(행의 팀) 대비 후보 과다 | 대사표에 "구현" 으로 기입돼 있었음. **3요소 중 1요소(트리거)만 있어도 '구현'** 으로 통과 |
| C | ETC 신규행 저장이 **성공 토스트 + `CODE='0'` 인데 원장에 아무것도 안 써짐**(payload `CUTOFF_TYPE` 빈값 → SP 분기 통째 skip). 이어서 ORA-01400 2건 | E2E F섹션이 **저장 경로 1개**(PLAN·DATA_TYPE='2')만 왕복. ETC 원장·Cutoff 저장·신규행 경로 **미커버** |

---

## §1 A. 메타 실소비 증명 — "존재"가 아니라 "소비"

### A-1 하드코딩 금지 (BLOCK)
화면 코드에 **컬럼명 목록**으로 표시/편집/잠금을 결정하는 상수가 있으면 위반이다.

```
⛔ const INSERT_LOCKED_COLUMNS = new Set(['DEPARTMENT_NAME', 'DEPT_NAME', ...])
⛔ const EDITABLE = ['QTY','PRICE']            ⛔ if (binding === 'XXX') editable = true
✅ staticEditableByMeta(col.inputTpCd, row)    ✅ col.cellCtrlObjTpCd === 'FPComboBox'
```

- **AS-IS `.cs` 의 `LockRange` 목록을 FE 상수로 옮기는 것이 전형적 함정**이다.
  AS-IS 파리티는 **메타 값**으로 보존한다(잠금 컬럼 = `INPUT_TP_CD='S'`).
- 공용 규약 재발명 금지 — 판정은 `packages/foundation/src/utils/gridUtils.ts` `GridUtils.isEditableCell`
  과 **동일 규약**이어야 한다: `IM`/`IO` → `EDIT_FLAG!=='N' && CRUD_TYPE==='I'` /
  `M`/`O` → `EDIT_FLAG!=='N'` / `S`·미지정 → false.
- 화면이 자체 게이트를 두면 **색(formatItem)과 편집(beginningEdit)이 같은 함수**를 보게 한다.
  둘이 갈리면 "노란색인데 편집 불가" 계열 사고가 난다.

### A-2 메타↔실동작 모순 검출 (필수 질문)
> **"이 화면에서 편집되는 컬럼이, 메타에서도 편집 가능으로 되어 있는가?"**

`INPUT_TP_CD` 가 전 컬럼 `'S'` 인데 화면이 편집되면 **둘 중 하나는 틀린 것**이다.
- 메타가 틀렸으면 → 운영자/사용자 승인 후 메타 정합 (값은 **AS-IS 근거로만** 도출)
- 화면이 틀렸으면 → 화면을 메타에 맞춘다
⛔ **모순을 방치한 채 "동작하니 통과" 금지.**

### A-3 적용 대상 메타 축 (전수)
`VISIBLE_FLAG` / `INPUT_TP_CD` / `CELL_CONTROL_OBJECT_TYPE_CODE` / `CELL_COMBO_DATA_TYPE`
/ `ATTRIBUTE1~5`(콤보 파라미터) / `COLUMN_WIDTH` / `HORIZONTAL_ALIGN_CODE` / `SORT_ORDER_NO`
— 각각 **FE 소비 지점(파일:라인)** 을 대사표에 적는다.

---

## §2 B. 셀 컨트롤 3요소 — 하나라도 없으면 '미구현'

셀 팝업/콤보는 **3요소가 모두 있어야** '구현'이다. 하나만 있어도 대사표에 '구현' 을 적지 않는다.

| 요소 | 팝업(FPModal) | 콤보(FPComboBox) |
|---|---|---|
| ① **메타 등재** | `CELL_CONTROL_OBJECT_TYPE_CODE='FPModal'` → 공용 그리드가 `wj-cell-popup` **아이콘** 렌더 | `='FPComboBox'` + `CELL_COMBO_DATA_TYPE` |
| ② **트리거 배선** | 더블클릭/클릭 핸들러 → 모달 open | `useTabComboQueries` 구독 + `dataMap` |
| ③ **파라미터·반환 계약** | 입력 = **행 값**(AS-IS `Form_Load(...)` 인자 1:1) / 반환 = 대상 컬럼 대입 | AS-IS SpreadInfo 계약(division + `DM_LOOKUP_DIV` 는 컬럼 `ATTRIBUTE1`) |

**판정 질문**:
- ①이 없으면 → **사용자가 그 기능의 존재를 알 수 없다**(아이콘 미표시). 기능이 있어도 "미구현"에 가깝다.
- ③이 `'ALL'`/공백 하드코딩이면 → AS-IS 보다 넓거나 좁은 후보가 나온다. **AS-IS 인자 목록과 1:1 대조**한다.
- ⚠ `FPModal` 은 공용 그리드가 **인라인 편집을 cancel** 한다(값은 모달로만). 타이핑도 필요하면
  `FPText` 등으로 두고 트리거만 유지한다 — **선택 결과를 사용자에게 알리고 결정받는다.**

---

## §3 C. 저장 경로 전수 커버리지 — "CRUD 완료" 의 정의

### C-1 저장 SP 개수 = 왕복 검증 개수 (BLOCK)
화면이 호출하는 **저장 SP 를 전수 인벤토리**하고, **각각** 왕복을 실증한다.
1개만 돌리고 "CRUD 완료" 선언 금지.

> DMF0044 실측: 저장 SP 2개(ETC `..._REPORT_C` / Cutoff `..._REPORT_C_CF`) + 쓰기 대상 원장 2개
> (`PLAN_REPORT_C` / `ETC_REPORT_C`). E2E 는 **그 중 1조합만** 왕복하고 "PASS" 였다.

### C-2 축 정의 (각 축 독립 — 서로 대체 불가)
| 축 | 내용 | 대체 가능? |
|---|---|---|
| 기존행 U | 조회된 행 값 수정 → 저장 | — |
| **신규행 C** | **화면 InsertRow 로 만든 행** 저장 | ⛔ 기존행 `activeFlag='I'` 로 **대체 불가** — 신규행은 화면이 채우지 않은 컬럼(키/구분자)이 **빈값**이라 경로가 다르다 |
| 삭제 D | 삭제 후 원장 제거 확인 | — |
| 조회 R | 저장분이 **같은 화면 재조회**에 보이는지 | ⛔ "저장 성공"으로 대체 불가 — 읽는 표≠쓰는 표일 수 있다 |

### C-3 성공 판정 (BLOCK)
- ⛔ **토스트·`CODE='0'` 은 증거가 아니다.** 반드시 **원장 SELECT** 로 확인한다.
- ⛔ **분기 skip 무동작 주의**: payload 의 구분자 컬럼(예: `CUTOFF_TYPE`)이 비면 SP 의
  `IF <구분자> = '...'` 분기가 통째로 건너뛰어져 **아무것도 안 써도 SUCCESS** 가 나온다.
  ⇒ 저장 직후 **영향 행수(원장 delta)** 를 세고, 0 이면 FAIL 로 판정한다.
- 신규행 payload 는 화면이 채우지 않는 컬럼이 빈값이다 → **NOT NULL × 빈값** 조합을 사전 점검
  (Oracle `''`=NULL. hook #119 / #127 계보).

### C-4 검증 harness 는 실제 payload 형태여야 한다 (BLOCK)
> DMF0044 실사고: harness 가 부서명/팀명에 **실측 실명**을 넣어 호출해 ORA-01400 을 **놓쳤다**.
> AS-IS 는 그 컬럼을 잠그기만 하고 채우지 않아 실제 payload 는 **빈값**이다.

- harness 파라미터는 **FE 가 실제로 보내는 값**을 그대로 재현한다(빈값·센티널 포함).
- 다행(`'^'` bulk) 화면은 **다행 payload** 로 검증한다 — 단일행 테스트는
  "2번째 행부터 NULL" 계열(BE 단일 주입 키) 결함을 **구조적으로 놓친다**.

---

## §A-보강 VISIBLE_FLAG 소비 검증 — 판정 주체는 FE 다 (2026-08-11 실사고 2건 추가)

> DMF0049 실사고: ①같은 라벨의 컬럼 쌍(`DEPARTMENT_ID`+`T_DEPARTMENT_ID` 둘 다 'Department*')이
> 모두 `VISIBLE_FLAG='Y'` → 화면에 **Department·Team 이 2개씩** 표시. AS-IS 는 `T_*` 를
> `.Visible = false` 로 끈다(정본 `.cs` L393~394·L948~949 — `true` 는 소스 전체에 없음).
> ②정정 후 검증에서 "SP 반환 여부"를 기준 삼아 **FAIL 오탐**을 냈다.

1. **검증 기준 = 반환된 `VISIBLE_FLAG` 값** — `PR_GET_SHEET_COLUMN_LIST` 는 VISIBLE_FLAG 를
   **필터하지 않고 컬럼으로 반환**한다(WHERE 에 VISIBLE 조건 없음). 숨김 컬럼도 반환되는 것이 정상이며,
   거르는 주체는 FE(`filter(c => c.visible !== false && c.display !== false)`)다.
   ⇒ "반환됐으니 FAIL" 은 오탐. **`VISIBLE_FLAG='Y'` 집합에서 라벨 중복 0** 을 판정한다.
2. **완료 선언 전: division 별 `표시 라벨 중복 0`** — 같은 `COLUMN_LABEL_NAME` 을 가진 표시('Y') 컬럼이
   2개 이상이면 FAIL. AS-IS 대조는 `.Visible=false` 지정(코드) + 라벨(메타) 양쪽으로 한다.
3. **AS-IS 인용은 정본 `.cs` 기준** — 같은 화면의 평면본(`GSCM.DM.Plan.UIL/`)과 정본
   (`GSCM.DM.Forms.UIL/.../`)은 **라인번호가 밀린다**. 대사표 E00 의 정본 확정을 따른다.
4. **모달도 동일** — 모달 정적 컬럼이 자체 시트(예: `exchangeRate`)를 조회하는 화면은 그 시트의
   메타 행 수·라벨 중복까지 같은 기준으로 검증한다(FE 는 응답을 dedup 없이 그대로 렌더한다).

---

## §4 자동 검사 (러너·grep 연동)

| 검사 | 방법 | 판정 |
|---|---|---|
| A-1 하드코딩 | 화면 폴더에서 컬럼명 배열 상수 grep — `new Set\(\[\s*'[A-Z_]{3,}'` / `= \['[A-Z_]{3,}'` | 히트 = BLOCK(사유 필요) |
| A-2 모순 | `SHEET_COLUMNS` 시트 전 행 `INPUT_TP_CD='S'` **AND** 화면에 편집 코드 존재 | WARN → 사유 필수 |
| B-① | `CELL_CONTROL_OBJECT_TYPE_CODE='FPModal'` 컬럼 수 ↔ FE 모달 트리거 수 | 불일치 = FAIL |
| C-1 | 화면 저장 SP 인벤토리 ↔ E2E 왕복 축 수 | 불일치 = **ERROR(미실행)** |
| C-3 | 저장 직후 원장 delta = 0 | FAIL |

> 러너 확장 전까지는 **완료 선언 보고서에 위 5행을 표로 직접 기재**한다.

---

## §5 완료 선언 양식 — 커버리지 표 의무 (hook #126 확장)

완료 선언 시 **무엇을 검증했는지**뿐 아니라 **무엇을 검증하지 않았는지**를 같은 표에 적는다.

```
| 축 | 상태 | 근거(리포트/SELECT/파일:라인) |
|---|---|---|
| 저장경로 ①ETC   | PASS  | harness 6행 payload I/M/D + 원장 SELECT |
| 저장경로 ②Cutoff | ERROR | 미실행 — E2E 시나리오에 축 없음 |
| 메타 소비        | PASS  | staticEditableByMeta(inputTpCd) — 하드코딩 0 |
| 셀 팝업 3요소    | PASS  | 메타 FPModal / dblclick L392 / deptId 행값 |
```

⛔ 축을 **표에서 생략**하는 것이 가장 흔한 위반이다. 안 본 축은 반드시 `ERROR` 행으로 남긴다.

---

## §6 실사고 계보

- 2026-08-11 DMF0044 — 메타 미소비(전 컬럼 'S' 인데 편집 가능) / 팝업 아이콘 부재·파라미터 하드코딩
  / ETC 신규행 저장 조용한 무동작(분기 skip) → ORA-01400 2건 → 저장 경로 2개 중 1개만 검증
- 2026-08-06 SYS0017 — "8게이트 통과" 주장이 SYS_LOG 실측에서 **SAVE 호출 0건** (hook #125 §0.5 계기)
- 2026-08-08 DMF0082 — 콤보 등록만 세고 소비지점 미검사 → 결함 9건 (hook #117 §5.5 계기)

> Cross-ref: `screen-completion-gate.md` G3/G6/G9 · #125 `ui-selfcheck-runtime-mandatory`
> · #126 `verification-completion-honesty` · #117 §5.5~§5.12 · #119/#127 (NULL·센티널)
