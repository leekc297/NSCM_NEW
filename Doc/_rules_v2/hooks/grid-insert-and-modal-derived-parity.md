# Hook #143 — GRID Insert 복사 · 셀 모달 파생 컬럼 = AS-IS 동작성 1:1

> 신설 2026-08-22 (사용자 지시: "GRID 에서 INSERT 시 AS-IS 와 동일하게 COLUMN DATA 를 복사해주세요 /
> PROJECT CODE, MODEL 등 GRID 에서 MODAL 선택 시 파생해서 채우는 COLUMN 값을 채워주세요 /
> 위의 2가지도 RULE 로 확정해서 GRID 동작성을 AS-IS 와 동일하도록 해주세요. (앞으로도)")
>
> 적용 범위: **편집 가능 그리드를 가진 모든 화면** (신규·보완 공통). 카테고리 = `03_grid_column_meta`.
> 짝 룰: [[ui-meta-dictionary-mandatory]](#142 — 메타 축) · hook #130(메타 실소비) · hook #59(cascade).

---

## §0. 왜 룰인가 (실사고 3건, 전부 DMF0082)

| 증상 (사용자 신고) | 실제 원인 | 축 |
|---|---|---|
| Model 모달을 띄워도 **조회 0행** | 신규행에 `DEPT_ID` 키가 없어 `undefined→''` 가 조회조건으로 나감. SP 술어가 `P_DEPT_ID='ALL' OR ...` 엄격비교라 빈값은 어느 것도 못 만난다 (실측 `PKG_COM0000.P_COM0008_GET_ITEM_BY_DIVISION_POPUP`: `'ALL'` 14,458행 / `''` **0행**) | §1 + §2 |
| Model 을 골라도 **Nick Name 이 빈 칸** | 파생 세팅 가드가 `'NICK_NAME' in target` 이었는데 신규 Insert 행 객체는 그 키를 만들지 않아 **항상 false** | §3 |
| Model 모달에 **현재 Model 이 안 넘어감** (Project 는 넘어감) | Item 모달만 현재 셀 값을 전달하지 않음. AS-IS 는 넘긴다 | §2 |

공통 구조: **AS-IS 는 "그리드 행이 값을 들고 있다"를 전제로 동작**하는데, TO-BE 신규행은 화면 코드가
만든 부분 객체라 그 전제가 깨진다. 그래서 "행에 키가 있나"로 판정하면 전부 조용히 빗나간다.

---

## §1. Insert 시 컬럼 복사 = AS-IS 복사 목록 그대로

### 의무

1. AS-IS `InsertRow()` 의 **포커스 행 복사 블록**을 찾아 복사 대상 컬럼을 **전량 열거**한다.
   (DMF0082 정본: `DMF0082_FcstNPrice_Mgmt.cs:2637-2670` — Division / Customer / ScmSiteId /
   ItemId / Incoterms / FcstType / DomExp / CELL_PROD_SITE_ID / CURRENCY / Measure)
2. **포커스 행이 없을 때의 기본값 분기도 함께 옮긴다** (AS-IS `:2674` `Measure = "MKT_FCST"`).
3. 그리드가 조회조건·팝업으로 **읽어 가는 컬럼은 화면에 안 보여도 복사한다.**
   AS-IS 행은 GET 커서가 채워 주므로 늘 값이 있다 — TO-BE 신규행에만 없는 것이 결함이다.
   ⇒ 판정 질문: *"AS-IS 에서 이 행을 셀 팝업/캐스케이드가 읽는가?"* 예 = 복사 대상.
4. 복사하지 **않는** 컬럼은 **사유를 코드 주석에 남긴다.** 무근거 누락 금지.

### ⭐ 기본 원칙 = **AS-IS 기준** (사용자 상시 지시 2026-08-22)

> "앞으로는 AS-IS 기준으로 적용 요청 합니다."

신규행 초기값·복사 목록·기본값은 **AS-IS `InsertRow()` 를 그대로** 옮긴다. TO-BE 판단으로 빼거나
바꾸지 않는다. 다르게 갈 때만 아래 §근거 명시 의무를 따른다.

### ⚠ 요구 문구는 **AS-IS 의 어느 분기**를 말하는지 먼저 가른다

AS-IS `InsertRow()` 는 대개 **2갈래**다 — 포커스 행이 있으면 **복사**, 없으면 **기본값**.
요구 문구가 한쪽만 겨냥했는데 양쪽에 적용하면 초기값이 어긋난다.

**실사고 — DMF0082 `MEASURE` (2026-08-22 사용자 신고)**

    AS-IS  if (bFocusYN) → Measure 를 포커스 행에서 복사
           else          → SetValue(..., Measure, "MKT_FCST")   ← 기본값
    요구   [통합테스트 35번] "라인추가시 measure 는 copy 하지 않음"   ← **if 분기만** 겨냥
    구현   시드 복사도 안 하고 **기본값도 안 넣어** `MEASURE: ''`   ← else 분기까지 삭제
    결과   AS-IS `'MKT_FCST'` ↔ TO-BE `''` — 초기값 불일치. 수량/가격 셀도 잠긴 채 시작.

⇒ **"copy 하지 않음" ≠ "기본값 없음".** 요구가 겨냥한 분기를 특정하고, 나머지 분기는 AS-IS 그대로 둔다.
   (hook #142 §4.3 의 "요구 문구를 기대값으로 직접 옮기지 말 것" 과 같은 계보다.)

### ⚠ 프레임워크 차이로 "AS-IS 분기가 재현되지 않는" 경우

AS-IS `bFocusYN` 은 `spdMain.Sheets[0].GetSelection(0)` 이 **null 이면 false** 다(`.cs:2504-2508`) —
사용자가 아무 셀도 안 고른 상태가 실제로 존재한다. 반면 **wijmo 는 데이터가 있으면
`selection.row` 가 기본 0 이상**이라 그 상태가 사실상 재현되지 않고, 항상 복사 분기를 탄다.

이런 차이는 **결함이 아니라 프레임워크 특성**이다. 없는 상태를 억지로 만들지 말고,
"AS-IS 의 어느 분기에 해당하는지" 를 판정한 뒤 그 분기의 값을 따른다
(DMF0082 `CURRENCY` = 복사 유지로 결정 — 사용자 확정 2026-08-22).

### AS-IS 와 달라지는 경우 = 근거 명시 의무

TO-BE 가 AS-IS 와 다르게 가는 것은 **사용자 지정이 있을 때만** 허용하고, 그 지정을 주석에 인용한다.
⚠ 인용할 때 **그 지정이 AS-IS 의 어느 분기를 대체하는지**까지 적는다 — 위 `MEASURE` 사고가
"지정을 인용했는데도" 발생한 이유가 분기 특정 누락이다.

```ts
// ✅ 올바른 형태 — 지정이 겨냥한 분기(복사)만 대체하고, 나머지 분기(기본값)는 AS-IS 그대로.
// [통합테스트 35번] "라인추가시 measure 는 copy 하지 않음" = AS-IS if 분기(:2668 복사) 대체.
//   else 분기의 기본값(:2674 "MKT_FCST")은 지정 대상이 아니므로 AS-IS 그대로 유지한다.
MEASURE: 'MKT_FCST',

// ⛔ 잘못된 형태 (2026-08-22 실사고) — 지정을 인용했지만 else 분기까지 삭제해 초기값이 어긋났다.
// MEASURE: '',
```

### 금지

- ⛔ 복사 목록을 **기억·추정**으로 작성 — AS-IS `.cs` 원문 대조 없이 쓰지 않는다 (hook #138: 주석 제외 LIVE 코드만).
- ⛔ 화면에 안 보인다는 이유로 키 생략 — 위 §0 1행 사고가 정확히 이것이다.

---

## §2. 셀 모달 호출 파라미터 = 현재 행 값 + **빈값 금지**

### 의무

1. **현재 셀 값을 넘긴다.** AS-IS 는 더블클릭한 행의 값을 팝업 인자로 넘기고, 팝업은 그것을
   검색창에 넣고 그대로 조회한다
   (`DMF0082_...cs:3786` → `Form_Load(…, sItemId, …)` / `DM0002_ItembyDivisionPopupEx.cs:302`
   `txtItemID.Text = sItemId;` → `:192 FindData()`).
2. **값이 없으면 `'ALL'` 로 넘긴다.** 빈 문자(`''`)는 조회 SP 가 0행을 준다.
   - `?.[key] ?? ''` 형태 **금지** — `??` 는 `null/undefined` 만 걸러 `''` 를 통과시킨다.
   - 모달 내부의 `preSearchParams.x ?? 'ALL'` 도 같은 이유로 `''` 를 막지 못한다. **호출처가 책임진다.**
   - 정본 헬퍼: `popupCellValue(key, fallback = 'ALL')` (ForecastPrice) / `rowValue(...)` (MktFcst).
3. **예외 — Project 는 `''`**: AS-IS 가 Item 팝업에 프로젝트를 빈값으로 넘긴다
   (`.cs:3785` `sProject = "";`). 이런 예외는 AS-IS 근거를 주석에 남기고 `fallback=''` 로 명시한다.

### 점검 SQL (신규 모달 배선 시 1회)

호출 대상 SP 를 **실제 배선 기준으로** 확인한 뒤(⚠ 이름이 비슷한 미사용 SP 가 존재한다 —
`V$SQL` 의 JDBC 모듈 실행 이력으로 확정할 것), 파라미터별로 `'ALL'` 과 `''` 를 각각 넣어 행수를 비교한다.
`''` 에서 행수가 무너지면 그 파라미터는 **반드시 `'ALL'` 폴백**이 필요하다.

---

## §3. 모달 선택 후 파생 컬럼 = AS-IS 세팅 목록 그대로

### AS-IS 계약 (DMF0082 정본)

| 모달 | 셀 자신 | 파생 컬럼 | 근거 |
|---|---|---|---|
| Model(Item) | `ITEM_ID` | `ITEM_NAME` · `ITEM_TYPE` · `NICK_NAME` | `.cs:3817-3823` |
| Project | `PROJECT_CODE` | `PROJECT_NAME` · `PROJECT_STATUS` · `BIZ_TYPE` · `PROJECT_OWNER` | `.cs:3751-3769` |

AS-IS 는 각 컬럼을 `if (GetColumnIndex(col) > 0)` 로 감싼다 = **그리드에 그 컬럼이 있으면 채운다.**

### 의무

1. 판정 축은 **그리드(=메타)에 컬럼이 있는가** 다. 정본:
   ```ts
   const setDerivedCell = (target: WijmoRowItem, binding: string, value: string) => {
     if (gridRef.current?.columns.getColumn(binding)) target[binding] = value;
   };
   ```
2. ⛔ **`'KEY' in target` 금지.** 신규 Insert 행 객체는 파생 컬럼 키를 만들지 않아 **항상 false** 다
   — 조회로 받은 행에서만 우연히 동작하고 신규행에서 조용히 빠진다 (§0 2행 사고).
3. **코드 컬럼 ↔ 명칭 값을 섞지 않는다.** 대상 컬럼이 `FPComboBox` 면 **코드**를 넣어야 한다.
   모달이 명칭만 노출한다면 **채우지 말고** 사유를 주석에 남긴 뒤 모달을 넓히는 것을 별건으로 올린다.
   - 실사고 후보: `BIZ_TYPE`(콤보 `BizType`, 코드) ← 모달은 `BIZ_TYPE_NAME`(명칭) 전달
   - 실사고 후보: `ITEM_TYPE`(콤보 `ItemType`, 코드) ← 모달은 `ITEM_CLASS_NAME`(명칭) 전달
   - 근거: AS-IS 도 **코드**를 넣는다 (`SCM0002_ProjectbyDivisionPopupEx.cs:68` `BizType="BIZ_TYPE"`).
4. **SAVE 오염 걱정으로 파생 세팅을 생략하지 않는다.** 저장 페이로드가 명시 키 목록으로 만들어지면
   (`forecast-price.save.ts keyOf`) 행에 표시용 키가 늘어도 payload 는 변하지 않는다.
   ⚠ 단, payload 를 `Object.keys(row)` 로 만드는 화면이라면 **먼저 그 빌더를 명시 키 방식으로 고친다.**

### 주의 — Insert 복사와 모달 선택은 **다른 이벤트**다

`NICK_NAME` 은 **Insert 복사 대상이 아니고**(AS-IS 실측 · 중복키 사고 2026-08-05 참조,
`forecast-price.save.ts` 주석) **모달 선택 시에는 채운다**(`.cs:3822`). 한쪽 근거로 다른 쪽을 결정하지 말 것.

---

## §4. POST-WRITE 점검 (편집 그리드 화면 종료 선언 전)

| # | 점검 | FAIL 시 |
|---|---|---|
| G-I1 | AS-IS InsertRow 복사 목록 ↔ TO-BE 신규행 객체 키 **전량 대조** (차이는 전부 사유 기재) | 종료 선언 금지 |
| G-I2 | 신규행이 셀 팝업 조회조건으로 쓰는 키를 **전부 보유** | 동 |
| G-M1 | 셀 모달 파라미터에 `?? ''` 잔존 0건 (`'ALL'` 폴백 또는 AS-IS 근거 있는 `''`) | 동 |
| G-M2 | 모달 파라미터를 `''` 로 넣었을 때 SP 행수 붕괴 여부 실측 | 동 |
| G-M3 | 파생 컬럼 가드에 `'KEY' in target` 잔존 0건 | 동 |
| G-M4 | AS-IS 파생 세팅 목록 ↔ TO-BE 세팅 목록 대조 (미채움은 코드/명칭 불일치 등 사유 기재) | 동 |
| G-M5 | 파생 대상이 `FPComboBox` 인 경우 **코드**를 넣는지 확인 | 동 |

### grep 점검

```bash
# G-M1 — 셀 모달 파라미터의 빈문자 폴백
grep -rn "?? ''" --include=*.tsx features | grep -i "deptId\|endCustomer\|salesSite\|divisionId"
# G-M3 — 파생 세팅의 잘못된 가드
grep -rn "' in target\|' in row\|' in dataItem" --include=*.tsx features
```

---

## §5. 한계

- AS-IS 팝업이 넘겨받은 값을 **검색 조건으로 쓰는지 표시만 하는지**는 팝업 소스를 봐야 안다
  (`DM0002_ItembyDivisionPopupEx` 는 검색창에 넣고 조회한다). 팝업별로 확인할 것.
- TO-BE 모달은 값을 **클라이언트 필터**로 쓰는 경우가 있다(`ItemByDivisionModal` — 서버에는 `''` 를
  보내고 받아 온 목록에서 거른다). 서버 조회 결과가 비면 필터가 정상이어도 0행으로 보이므로,
  0행 진단은 **① SP 행수 ② 클라이언트 필터** 순으로 가른다.
