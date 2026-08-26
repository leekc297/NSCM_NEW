# Hook — UI 메타 지식사전 대조 의무 (조회조건 / SHEET_COLUMN / SHEET_MEASURE)

> ⛔ 신규·보완 화면의 **조회조건·그리드 컬럼 메타·MEASURE** 를 "화면마다 다시 판단" 하지 말 것.
> **지식사전을 먼저 대조**하고, 사전이 답을 주지 못하는(`confidence: low/none`) 항목만 AS-IS 를 확인한다.
> 반복되던 사고 3종 — ① 콤보 미설정·오지정으로 **CODE 노출** ② ITEM(MODEL) **모달 미설정으로 선택 창 안 뜸**
> ③ MEASURE 가 AS-IS 와 **말없이 어긋남** — 을 사람 기억이 아니라 데이터로 막는다.

작성: 2026-08-21 (사용자 지시 — "COLUMN 에 대한 지식정보를 관리해서 실수를 줄이고자 합니다")
트리거: T01(신규 화면) · T01M(화면 수정) · T04(Grid/컬럼 메타) · T05(조회조건/콤보) · T20(완료 선언 전)
관련 hook: `ui-category-setup-column-meta`, `ui-category-setup-no-arbitrary-data`,
`column-lookup-meta-standard`, `search-condition-asis-tobe-catalog`(#112),
`search-condition-datasource-asis-parity`(#117), `cascade-combo-filter`(#59),
`ui-dynamic-property-management`

---

## §0. 사전 위치

| 파일 | 내용 |
|---|---|
| `Doc/_rules_v2/_dictionary/00_INDEX.md` | 진입점 · 규모 · 한계 |
| `Doc/_rules_v2/_dictionary/01_search_conditions.md` | 조회조건 **항목 축** 34종 (154 조건 실측) |
| `Doc/_rules_v2/_dictionary/02_sheet_columns.md` | `COLUMN_NAME` 축 3,225종 + 결함 전수 |
| `Doc/_rules_v2/_dictionary/03_sheet_measures.md` | MEASURE 494종 + AS-IS↔TO-BE 대사 |
| `Doc/화면분석서/UI메타_지식사전_v1.0.xlsx` | 사람 검토용 9시트 뷰 |
| `_artifacts/_diagnostics/ui_meta_dictionary_20260821/` | 파이프라인(재실행) + JSON 정본 |

> MD/xlsx 는 **생성물**이다. 직접 고치지 말고 파이프라인을 고쳐 재생성한다.

---

## §1. PRE-WRITE — 작성 전 대조 (의무)

### §1.1 조회조건

`01_search_conditions.md` §1 표에서 해당 항목 행을 찾아 **그대로** 따른다.

| 확인 항목 | 실패 시 증상 |
|---|---|
| `binding` = `ARG` | 콤보 SQL 이 `@토큰` 을 요구한다. **FE 가 따옴표 포함 값을 전달**하지 않으면 조용한 0행 → CODE 노출 |
| `binding` = `CASCADE` | 상위 변경 시 하위 reset 누락 → 이전 division 값 잔존 (hook #59 5단계 적용) |
| `binding` = `FILTER` | 전량 fetch 1회 + 클라 필터. `useTabComboQuery` N회 호출 금지 |
| `div40/81/82` | 화면별 상이면 그 항목의 §2 상세표에서 해당 UI 행을 본다 |
| `TO-BE 필드` | `@master/searchFields` 공용 필드가 있으면 **재구현 금지** |

> ⚠ 우선순위는 **ARG > CASCADE > FILTER**. ARG 미전달은 화면에 오류가 안 뜨고 빈 목록/코드로만
> 나타나 발견이 가장 늦다.

### §1.2 SHEET_COLUMN

`02_sheet_columns.md` §1 에서 해당 `COLUMN_NAME` 행을 찾는다.

1. **표시 컨트롤 / 편집 컨트롤은 다른 축이다.** 표시 표준이 `FPTextBox` 라고 편집도 텍스트가 아니다
   (읽기전용 표시 행이 다수라 전 행 최빈값은 항상 TextBox 로 수렴한다).
   INSERT/편집이 되는 컬럼이면 **편집 표준**을 본다.
2. `편집 컨트롤 = FPModal / FPTextModal` 이면 **`CELL_COMBO_DATA_TYPE`(모달키)를 반드시 채운다.**
   공란이면 선택 창이 안 뜬다. ⚠ 2026-08-22 슬롯 전환 — 종전 `ATTRIBUTE1` 이 아니다(§4.2 참조).
   모달키 자리에 division 목록(`'81,82'`)을 넣는 오입력이 실제로 있었다 — 사전의 `모달키` 열 값을 쓴다.
3. `편집 콤보` 를 쓸 때는 **`콤보등록` 열이 `O`** 인지 본다. `X` 면 `SCM_ADM_CMBO_SQL_M` 미등록이라
   그대로 쓰면 0행 → CODE 노출이다. 사전의 **TO-BE 실사용 대안**(§4)을 보고 매핑을 먼저 정한다.
4. `confidence` 가 `low`/`none` 이면 **표준이 아니다.** AS-IS 화면을 확인하고 결정한다. 추정 금지.
5. `교대쌍` 열이 채워져 있으면 그 컬럼은 **짝과 함께** 판단한다 (§3).

### §1.3 SHEET_MEASURE

`03_sheet_measures.md` §2 에서 해당 화면의 차이 행을 확인한다.

- `MISSING` = AS-IS 존재/TO-BE 부재 → **이관 누락**. 등록 필요 여부를 사용자에게 보고한다.
- `EXTRA` = TO-BE 단독 → **확장 근거 문서가 있어야 한다.** 없으면 결함 취급.
- `DIFF` = 계통을 본다. `DIV_81_EXPANSION`(81 세분 토큰 추가)·`EMPTY_TO_DEFAULT`(Oracle NOT NULL
  DEFAULT 로 공란이 채워짐)는 설명되는 차이. **`REAL` 만 확인 대상**이다.
  ⚠ `EMPTY_TO_DEFAULT` 도 무해하지 않다 — `DEFAULT_FLAG` `''`→`'Y'` 는 "기본 미표시" 였던 measure 가
  **기본 표시**로 바뀌는 의미 변경이다 (titleset seed 가 `DEFAULT_FLAG='Y'` 기준).

---

## §2. 사전은 **대조·검출용**이다 (등록기가 아니다)

`ui-category-setup-no-arbitrary-data` 를 그대로 승계한다.

- ⛔ 사전 값으로 `SCM_MST_SHEET_COLUMNS` / `SCM_MST_SHEET_MEASURE` 를 **자동 INSERT/UPDATE 하지 않는다.**
- ✅ 허용 = ① 사용자 명시 요청 ② AS-IS 실데이터를 **그대로** 복사 ③ 누락 **보고**
- 사전이 말하는 "표준" 은 **모집단의 최빈값**이지 운영자의 결정이 아니다. 운영 결정은 admin UI 가 갖는다.

---

## §3. 교대쌍 (swap pair) — 메타만 보면 오해하는 구조

같은 라벨을 가진 `X`(콤보)와 `T_X`(텍스트)가 **둘 다 `VISIBLE='Y'`** 인 화면이 있다.
합쳐진 것이 아니라 AS-IS `.cs` 가 **모드별로 번갈아** 노출한다.

정본 실측 — DMF0049 `DMF0049_Sales_ETC_Reports.cs`:

| 시점 | 동작 |
|---|---|
| `InitSpread()` L233-234 | 콤보측(`DEPARTMENT_ID`/`DEPT_ID`) `Visible = false` |
| `FindData()` L520-521 | 조회 직후 다시 `false` |
| `EditButton()` L388-391 | 콤보측 `true` ↔ 텍스트측(`T_DEPARTMENT_ID`/`T_DEPT_ID`) `false` |
| `InsertRow()` L895-898 | 동일 |

SP 는 `R.DEPARTMENT_ID AS T_DEPARTMENT_ID` 로 **같은 코드를 한 번 더** 주고, 명칭은 별도
`T_DEPARTMENT_NAME`(lookup 조인)에 담는다.

⇒ **판정 규칙**: `T_` 접두 컬럼이 짝과 같은 라벨을 가지면 "중복 등록" 으로 오판하지 말 것.
TO-BE 로 옮길 때 교대 트리거를 무엇으로 할지는 **화면 단위 결정 사항**이다
(TO-BE 에는 AS-IS 의 Edit 버튼이 없는 화면이 있다 — 임의로 정하지 말고 확인한다).

---

## §3.5 ⭐ division별 AS-IS 기준 원천 (사용자 지정 2026-08-21)

TO-BE 가 AS-IS 보다 **넓은 division 을 개방한 화면**은, 개방된 division 의 동작 근거가 자기 AS-IS
원본에 **없다**. 그 상태로 "AS-IS 대조" 를 하면 답이 안 나오고, "AS-IS 에 없음 = 결함" 으로 읽으면
전량 오판한다.

⇒ **division 마다 AS-IS 기준 화면을 달리 본다.** 매핑은 `00_config.py::DIVISION_BASELINE` 이 단일 소스다.

| 대상 | division | **AS-IS** 기준 화면·시트 |
|---|---|---|
| DMF0082 | **40** | `DMF0003 / Mkt Fcst` |
| DMF0082 | **81 계열 · 82** | `DMF0082 / FcstNPrice` (자기 화면) |

### ⛔ 기준은 언제나 **AS-IS** 다 — TO-BE 끼리 베끼지 않는다

TO-BE 화면을 기준으로 삼으면 그 화면의 오류가 그대로 전파된다. **실제 사고**:

> AS-IS DMF0003 `Mkt Fcst.PLANT_SITE_ID` 콤보 = `FromSiteByDivision`(사이트 코드)
> → TO-BE DMF0003 이 `PlantByDivisionCompany`(플랜트 코드)로 **변경**
> → TO-BE DMF0082 가 그 **변경본을 복사**(라벨·`DIVISION_ID` 문자열까지 동일, `SORT` 만 210→121)
> → 그리드 셀(플랜트 코드 `HQ04`) ↔ 조회조건(사이트 코드 `HQ07-A`) **교집합 0건**
>   = 그리드에서 고른 값이 조회조건으로 영영 검색되지 않고, GET 이 사이트 코드를 주면 **CODE raw 노출**

사용자 확정: *"DMF0003 도 표준이 아니다. AS-IS 의 사전정보를 기준으로 COMBO 를 사용하면
`FromSiteByDivision` 가 적용되는 것이 맞다."*

### 적용 규칙

1. 조인 키 = **`COLUMN_NAME` 정규화본**(`cfg.norm_col`). 시트명은 화면마다 다르다(`FcstNPrice` ↔ `Mkt Fcst`).
2. **division 접미를 뗀다.** AS-IS DMF0003 은 division 40 전용 컬럼에 `40` 접미를 붙여 행을 나눈다
   (`DIVISION_ID`/`DIVISION_ID40` · `END_CUSTOMER`/`END_CUSTOMER40` · `ITEM_ID`/`ITEM_ID40` ·
   `SCM_SITE_ID`/`SCM_SITE_ID40`). DMF0082 는 한 컬럼으로 전 division 을 덮는다.
   → 떼지 않으면 같은 축이 "기준에만 4 + TO-BE만 4" 로 갈라져 **허위 격차 8건**이 된다.
3. 기준은 **시트 단위**로 좁힌다. 화면 전체로 비교하면 기준 화면의 다른 시트
   (DMF0003 의 `Customer Demand Analysis`/`PSI`) 컬럼이 섞인다 — 실제로 22건이 그 노이즈였다.
4. `DIVISION_ID` 공란 = division 무관(전 division 공통)으로 판정한다.
5. **`INPUT_TP_CD` 는 판정 불가 축**이다. AS-IS 는 전행 `'S'` 라 항상 불일치로 잡혀 진짜 신호를 덮는다.
   AS-IS 의 실제 편집 가능 여부는 `.cs` `LockRange`/`LockColumn` 에 있고 메타에 없다.
   → 별도 버킷(`attr_undecidable`)으로 빼되 숨기지 않는다.
6. **콤보 ID 문자열이 달라도 실체가 같으면 결함이 아니다.** TO-BE 는 AS-IS lookup 을 그대로 읽으면서
   ID 만 camelCase 로 바꾼 사례가 있다 — 반드시 `SQL_DTL_CTN` 본문을 대조한다.
   실측 정상례: `CURRENCY_LIST`→`CurrencyList` / `CUST_GROUP`→`CustGroup`
   (둘 다 `LOOKUP_TYPE` 이 AS-IS ID 그대로). 반대로 `PlantByDivisionCompany` 는 **테이블 자체가 다르다** = 결함.
7. 조회조건도 같은 규칙으로 기준 화면에서 뽑는다 — 기준 화면의 AS-IS `div40`/`div81`/`div82` 서술에
   "진입 불가/비활성" 이 있으면 그 division 에서 **사용 불가**로 본다.

### 실행

```bash
python 08_build_division_baseline.py     # → dict_division_baseline.json
```

산출은 division 마다 `missing_vs_baseline`(기준에 있고 TO-BE 에 없음) / `tobe_only` /
`attr_mismatch`(실불일치) / `attr_undecidable`(판정 불가) / 조회조건 사용가능·불가 목록을 준다.

⚠ **대조표다.** 이 값으로 메타를 자동 INSERT 하지 않는다(§2 승계). 새 화면을 이 규칙에 넣으려면
`DIVISION_BASELINE` 에 근거와 함께 등재한다.

---

## §4. POST-WRITE — 화면 단위 게이트 (의무)

```bash
cd _artifacts/_diagnostics/ui_meta_dictionary_20260821
python 06_verify.py --program {MENU_ID}
```

**ERROR 0 이 아니면 화면 작업 종료를 선언하지 않는다.**

| 코드 | 심각도 | 증상 |
|---|---|---|
| D1 | ERROR | 콤보인데 `CELL_COMBO_DATA_TYPE` 공란 → CODE 노출 |
| D2 | ERROR | 콤보 SQL_ID 가 `SCM_ADM_CMBO_SQL_M` 미등록 → 0행·CODE 노출 |
| D3 | INFO | 콤보가 `@토큰` 요구 — FE 전달 필요 (메타만으론 판정 불가) |
| D4 | ERROR | **모달 컨트롤**(`FPModal`/`FPTextModal`)인데 `CELL_COMBO_DATA_TYPE`(모달키) 공란/오값 → 선택 창 안 뜸 |
| D13 | WARN | 모달 컬럼의 `ATTRIBUTE1` 에 모달키 값 잔존 → 구 규약(슬롯 이전 전) 잔재 |
| D14 | WARN | `DIVISION_ID` 가 AS-IS 보다 **축소** → 그 division 에서 컬럼이 사라짐 |
| D15 | INFO | `DIVISION_ID` 가 AS-IS 보다 **확장** → TO-BE 추가분, 근거 확인 대상 |
| D5 | WARN | 사전 편집표준은 모달인데 **모달이 없는** 컨트롤로 등록 → 선택 창을 띄울 수 없음 |
| D6 | ERROR | `INPUT_TP_CD` 가 FE enum(`S/O/M/IO/IM`) 밖 (`MI`/`OI` 역순 등) → 편집 불가 fallthrough |
| D7 | ERROR | `HORIZONTAL_ALIGN_CODE` 가 `C/L/R` 밖 (`Center`/`Left`) → 좌측 fallback |
| D8 | ERROR | `CELL_CONTROL_OBJECT_TYPE_CODE` 가 허용값 밖 (`'S'` 오기입) → 미해석 |
| D9 | ERROR | PK(`PROGRAM_ID,SHEET_NAME,COLUMN_NAME`) 중복 → 어느 행이 적용될지 비결정적 |
| D10 | ERROR | AS-IS lookup 에만 있고 FE enum 에 없는 컨트롤(`FPExNum`) → 미해석 |
| D11 | ERROR | 키 3부 중 공란 행 → 어느 화면에도 속하지 않는 쓰레기 행 |

> ⚠ 게이트가 FAIL 하면 **먼저 도구 오탐인지 데이터 결함인지 가른다.** 정정 후에는 전체 실행으로
> 회귀시켜 다른 축이 깨지지 않았는지 확인한다.

### §4.1 ⭐ 셀 컨트롤 `FPTextModal` — 텍스트 편집 + 모달 (2026-08-22 신설)

`FPModal` 은 공용 DataGrid 에서 **세 가지를 한 덩어리로** 지배한다
(`packages/shared/.../dataGridUtils.ts` — `beginningEdit` cancel `:275` / `is-popup` 아이콘 `:161` /
`wj-cell-popup` `:227`). 그래서 기존 두 값으로는 AS-IS 동작을 표현할 수 없었다.

| 값 | 타이핑 | 돋보기 아이콘 | 모달 |
|---|---|---|---|
| `FPTextBox` | O | **X** | (있어도 사용자가 알 수 없다) |
| `FPModal` | **X** | O | O |
| **`FPTextModal`** | **O** | **O** | **O** |

AS-IS 는 `TextCellType` + `BackgroundImage(ImagePopUp)` + `CellDoubleClick` 조합이라 **둘 다** 됐다
(`DMF0082_FcstNPrice_Mgmt.cs:404-407` / `:2541` / `:3772`). TO-BE 가 이를 `FPModal` 로 옮기면서
**AS-IS 에 있던 타이핑 기능이 사라졌다** — 그 복원값이다.

**규약**

1. 모달키는 **`CELL_COMBO_DATA_TYPE`** 이다 (2026-08-22 전환 — §4.2). 새 슬롯을 만들지 않는다.
2. `ATTRIBUTE1` 은 **파라미터(`sParam1`) 자리**다 — division 토큰 등이 들어가는 것이 정상이다.
   모달키를 여기 넣으면 D13 으로 적출된다.
3. 값 도메인은 **세 곳이 같이** 움직인다. 하나라도 빠지면 조용히 깨진다:
   · FE enum `CELL_CONTROL_TYPE.TEXT_MODAL` (`packages/foundation/.../column-config.ts`)
   · 사전 허용 도메인 `cfg.CELL_CONTROL_TYPES` (없으면 D8 로 정상값을 결함 처리)
   · **admin 드롭다운 CMBO `ColumnControlType`** — lookup 테이블이 아니라 **하드코딩 UNION ALL** 이다.
     미등재 시 운영자가 고를 수 없고, 기존 행을 admin 에서 열면 **빈 셀로 보여 저장 시 유실**된다.
4. 판정 기준: **AS-IS 가 텍스트인데 화면이 팝업도 연다** → `FPTextModal`.
   AS-IS 가 타이핑을 막았다면 `FPModal` 을 유지한다. 임의 승격 금지.

### §4.4 ⭐ AS-IS 와 **의도적으로 다른** 값 — 등록부에 남기고 되돌리지 않는다 (2026-08-22 신설)

AS-IS 대조가 정본이지만, **AS-IS 메타가 화면 사실과 다른 경우**가 있다. 이때는 TO-BE 가 달라지는 것이
맞고, 그 사실을 **등록부에 남겨** 나중에 "AS-IS 와 다름" 만 보고 되돌리는 것을 막는다.

**실사고 — `DMF0082 VERSION_NO.VISIBLE_FLAG`**

    AS-IS 메타  VISIBLE_FLAG = 'N'
    AS-IS 화면  **보인다** (Measure 앞, SORT 390 < MEASURE 450)

원인은 프레임워크 오버로드다. DMF0082 는 `SpreadInfo.CreateSheetHeaderColumn`
(`SpreadInfo.cs:1324`, 호출 `DMF0082_FcstNPrice_Mgmt.cs:421`)을 쓰는데 **이 오버로드는
`VISIBLE_FLAG` 를 한 번도 읽지 않는다**(구간 내 출현 0회 — `isVisible` 을 `VALID_YN` 으로만 판정).
다른 오버로드 5곳(`:1871 :2208 :2556 :2908 :14472`)만 검사한다.

⇒ TO-BE 는 플래그를 정상 적용하므로 `'N'` 을 그대로 두면 **AS-IS 에 보이던 컬럼이 사라진다.**
   화면 파리티를 위해 TO-BE 를 `'Y'` 로 올린다(런타임 사실을 메타로 표현). 같은 시트 `MEASURE` 선례 동일.

### 의무

1. AS-IS 와 다르게 가는 값은 **`00_config.py` 의 `INTENTIONAL_DIVERGENCE` 에 등록**한다 —
   키 `(PROGRAM_ID, SHEET_NAME, COLUMN_NAME, FIELD)` · 값 `(AS-IS, TO-BE, 사유)`.
   사전 산출물(`dict_sheet_columns.json` → `meta.intentional_divergence`)에 그대로 실린다.
2. 사유에는 **왜 AS-IS 메타를 따르면 안 되는지**를 파일·라인 근거로 적는다("화면에서 확인" 만으로는 부족).
3. ⛔ 등록부에 있는 값을 AS-IS 대조 결과만 보고 정정하지 않는다. 되돌리려면 **등록부부터 지운다**
   (지우는 근거를 남긴다).

### 판정 순서

    ① AS-IS 메타  →  ② AS-IS 화면(프레임워크 경로 확인)  →  ③ 둘이 다르면 등록부에 사유와 함께 등록

②를 건너뛰면 "메타가 N 이니 TO-BE 도 N" 으로 정리해 **화면에서 컬럼이 사라진다.**

---

### §4.3 ⭐ `DIVISION_ID` 는 **AS-IS 동일 화면·동일 시트 실측값**이 정본 (2026-08-22 신설)

> 계기 — DMF0082 `CELL_PROD_SITE_ID` 실사고. 사용자 지적으로 발견.

**무엇이 잘못됐나**

    요구 (2026-08-11)  "CELL_PROD_SITE_ID 는 81 에서 제외"
    구현               기대값을 `'40,82'` 로 적음   ← 81 만 빼고 **82 를 남김**
    AS-IS 실측         DMF0082 / FcstNPrice = `'40'` 단독
    전파               검증 스크립트 + 클라우드 패키지 3본에 `'40,82'` 고정
    회귀 복구(08-20)   그 잘못된 기대값을 정본 삼아 다시 `'40,82'` 로 "복원"

**원인은 단 하나 — 요구 문구를 기대값으로 직접 옮기고 AS-IS 를 대조하지 않았다.**
`82` 는 형제 시트(`Sales Price Save All` = `'40,82,81,…'`)의 값이 섞인 것으로 보인다.

### 의무

1. **division 토큰은 요구 문구가 아니라 AS-IS 실측이 정본이다.** "81 에서 제외" 같은 문구는
   *무엇을 빼라*만 말하고 *무엇이 남아야 하는지*는 말하지 않는다. 남는 집합은 AS-IS 에서 읽는다.
2. 대조 단위는 **화면 + 시트 + 컬럼** 이다. 같은 화면이라도 시트가 다르면 값이 다르다
   (DMF0082 `FcstNPrice`=`'40'` ↔ `Sales Price Save All`=`'40,82,81,…'`).
3. 기대값을 **검증 스크립트·이관 패키지에 박기 전에** AS-IS 대조를 끝낸다. 한 번 박히면 회귀 복구가
   그 값을 정본으로 삼아 되돌려 놓는다(위 08-20 사례).
4. AS-IS 와 다르게 갈 때는 **근거를 남긴다**(TO-BE 81/82 확장 등). 근거 없는 확장 = D15 확인 대상.

### 금지

- ⛔ 형제 시트·형제 화면의 division 값을 그대로 복사 — 이번 사고의 `82` 유입 경로다.
- ⛔ AS-IS 에 있던 토큰을 근거 없이 제거 — 그 division 에서 컬럼이 통째로 사라진다(D14).
- ⛔ 메타 1행만 수기 UPDATE — 이번 건은 배포 패키지도 백업도 없이 `admin` 이 1행만 고쳐
  경위 추적에 work_report 역추적이 필요했다. 패키지 + 백업 + VERIFY 를 반드시 남긴다.

### 게이트

`06_verify.py` 가 AS-IS↔TO-BE 를 (화면·시트·컬럼) 키로 대조해 **D14(축소, WARN) / D15(확장, INFO)**
로 적출한다. 2026-08-22 기준 실측 = 동일 13,548 · 확장 301 · 축소 16.
**축소가 확장보다 위험하다** — AS-IS 에 있던 division 에서 컬럼이 사라지기 때문이다.

---

### §4.2 ⭐ 모달 식별자 슬롯 = `CELL_COMBO_DATA_TYPE` (2026-08-22 사용자 결정)

> "어떤 모달을 열지는 Cell Combo Data Type 에 넣어서 관리" / "FPComboBox 일 때는 Combo,
> FPModal·FPTextModal 일 때는 Modal 호출용으로 cellCboDataTp 를 사용" (사용자 지시)

`CELL_COMBO_DATA_TYPE` 은 **컨트롤 타입에 따라 의미가 갈리는 슬롯**이다.

| 컨트롤 | `CELL_COMBO_DATA_TYPE` 의미 |
|---|---|
| `FPComboBox` | 콤보 SQL_ID (`SCM_ADM_CMBO_SQL_M`) |
| `FPModal` · `FPTextModal` | **모달키** (`ITEM` / `PROJECT` / `ProjectAuthRegModal` …) |

**왜 옮겼나 — AS-IS 에는 모달 개념이 메타에 없다** (실측)

- AS-IS 14,675행 전수에서 `FPModal` **0건**, `ATTRIBUTE1` 에 Modal/Popup 류 문자열 **0건**.
  AS-IS 는 모달을 `.cs` 의 `CellDoubleClick` + `new XxxPopup()` 으로 직접 열었으므로 메타 슬롯이 불필요했다.
- `ATTRIBUTE1~5` 는 AS-IS `SpreadInfo` 의 `sParam1~5`(콤보·모달 파라미터) 자리이고, 실제 값도
  division 토큰(`'40'`, `'81,82'`)이다. 모달키를 거기 넣은 것은 **TO-BE 관례**였고, 그 과정에서
  AS-IS 파라미터 값을 덮어썼다(2026-08-21~22 실사고 — 되돌림 완료).

**적용 범위** — DM(`DMF*`) 7행만 이전했다. **SDM/SYS 11행은 사용자 지정으로 미변경**이라 아직
`ATTRIBUTE1` 을 모달키로 쓴다(D13 이 정보성으로 적출). 그 화면들을 손볼 때 함께 전환한다.

**FE 계약** — 모달 컨트롤이면 `cellCboDataTp` 를 1순위로 읽고, 같은 값을 `_comboKey` 로는
**넘기지 않는다**(`'ITEM'` 을 콤보 ID 로 조회하는 사고 방지).
정본 = `MktFcstGrid.tsx` `isModalCtrl` 분기 / `SalesFuturePriceGrid.tsx` / `ForecastPriceGrid.tsx`.

---

**D5 파리티 가드** — 사전 편집표준은 *컬럼명 축의 통계*일 뿐이다. 같은 이름이라도 화면마다 의미가 다르므로
**해당 셀의 AS-IS 실값과 같으면 D5 를 내지 않는다**(§2 와 동일 원칙: AS-IS 가 정본, 사전은 대조용).
실사고: `DMF0049 MDF Reports.ITEM_ID` 는 AS-IS 가 `FPComboBox`/`DM_LOOKUP_DIV` 인 lookup 구분 콤보인데
`ITEM_ID` 통계 표준이 모달이라 결함으로 적출됐다.

---

### §4.5 ⭐ **저장 키 컬럼은 Column Setting 과 독립이어야 한다** (2026-08-22 사용자 승인 A안)

GET 이 돌려주는 컬럼을 **사용자별 Column Setting** 이 정하는 구조에서는, 그 목록에 **저장 키**가
섞여 있으면 표시 선택이 저장 정합성을 조용히 깨뜨린다.

```
C_TITLE  FROM SCM_MST_TITLESET_USER U  WHERE U.USER_ID = p_created_by
                                         AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
   → V_COLUMN / V_GROUPBY → 동적 SQL 의 SELECT 목록
```

사용자가 키 컬럼을 숨기면 → GET 미반환 → FE 가 `''` 전송 →
**① 검증이 오판해 수정 차단 ② MERGE ON 키 불일치로 중복행.**

### 실사고 (DMF0082, 2026-08-22)

`CELL_PROD_SITE_ID` 를 숨긴 계정(titleset 15컬럼)에서 **기존 행 수정이 전부 막혔다**:

```
[1] I(qty=7,  CPS='HQ06-A')  → 원장 [('HQ06-A', 7.0)]                     통과
[2] M(qty=55, CPS='')        → 'Cell Prod Site* 를 Common으로 등록 할 수 없습니다.'
                                원장 무변화                                차단
```

⚠ **진단 시 주의** — 이건 전역 장애가 아니다. 실측 결과 titleset 보유 16명 중 **15명은 정상**이었고
숨긴 1명만 막혔다. *테스트 계정의 Column Setting 을 전역 결함으로 오인하지 말 것.*
(본 세션에서 실제로 "134행 72% 수정 불가" 라고 잘못 보고했다가 계정별 실측으로 철회했다.)

### 의무

1. **저장 키 컬럼 목록을 명시한다** — 출처는 SAVE 의 `MERGE ON` 절 + FE `save.ts keyOf`. 추정 금지.
2. GET 은 그 컬럼을 **titleset 과 무관하게 항상 반환**한다. 표시 여부는 메타/FE 가 정하므로
   payload 에 한 컬럼 더 실리는 것은 무해하다.
3. `V_GROUPBY` 에도 **함께** 넣는다 — SELECT 목록에만 넣으면 `ORA-00979`.
4. **행수 변화를 실측해 보고한다.** GROUP BY 에 컬럼이 추가되면 그동안 뭉쳐 보이던 행이 분리된다.
   실측: 숨긴 계정 **7,658 → 7,859 (+201)** / 이미 보유한 계정은 **변화 없음**(7,809 불변).
5. 같은 이름의 커서·변수 블록이 **여러 프로시저에 중복**되면(DMF0082 는 `C_TITLE`/`V_COLUMN` 2벌)
   본문 전체 문자열 치환 금지 — **프로시저 구간별로 잘라** 각 구간 안에서만 치환한다.
   FE 배선도 전수 확인할 것(`SEARCH` → `..._GET_MAIN_DATA` / `SEARCH_CURRENT` → `..._GET_MAIN_DATA_CURRENT`).

정본 패키지: `_artifacts/_deploy_packages/PKG_DMF0082_GET_KEYCOL_ALWAYS_20260822/`
검증: `_artifacts/_diagnostics/_dmf0082_keycol_verify_20260822.py` (V1 숨긴 계정 실값 수신 / V2 기존행 수정 / V3 보유 계정 회귀)

---

## §5. 사전 재생성 (원천이 바뀌었을 때)

```bash
cd _artifacts/_diagnostics/ui_meta_dictionary_20260821
python 01_dump_asis.py && python 02_dump_tobe.py     # 전건 덤프 + 스냅샷 정합성 게이트
python 03_build_searchcond_dict.py
python 04_build_column_dict.py
python 05_build_measure_dict.py
python 06_verify.py --selftest                        # exit 0 확인 (검출기 합성 검증 포함)
python 07_build_outputs.py                            # MD 4본 + xlsx
python 08_build_division_baseline.py                  # division별 AS-IS 기준 대조 (§3.5)
```

`01_dump_asis.py` 는 **스냅샷 정합성**을 검사한다 — `clean COUNT == NOLOCK COUNT == sys.partitions`
이고 두 번 샘플이 같아야 진행한다. AS-IS DEV 는 작업 중 실제로 변동한다
(2026-08-21 실측: `SHEET_COLUMNS` 15,105 → 0(재적재 창) → 14,675). 찢어진 스냅샷으로 사전을 만들지 않는다.

---

## §6. 한계 (사전을 믿을 수 있는 범위)

1. **AS-IS 근거 = DEV(`LGCE_SCMDEV`)**. QA(`10.34.221.91:7433`)는 도달 불가로 미반영.
   QA 개방 시 `NSCM_ASIS_*` 환경변수만 바꿔 `01_dump_asis.py` 재실행 → 차이 대사.
2. **편집·모달 축은 AS-IS 메타로 검증 불가.** AS-IS `INPUT_TP_CD` 는 전행 `'S'` 이고 `FPModal` 은 0건이다
   (AS-IS 는 `.cs` `LockRange`/`SetCellType`/`new XxxPopup()` 으로 처리했다).
   근거는 TO-BE 실적 + AS-IS `.cs` 이며 `confidence` 로 강도를 표시한다.
3. **조회조건은 13UI 만 소스 실측**이다. 그 밖은 카탈로그(2026-01-22 스냅샷) 커버리지 표기.
4. 컨트롤·정렬 허용값 정본 = **TO-BE `SCM_ADM_LOOKUP_MASTER_DETAIL`**(64,500행). AS-IS 와 동일함을
   교차검증했다(컨트롤 13종 · align `C/L/R`). 허용값 = **FE enum ∪ lookup** —
   `FPModal`/`FPText` 는 FE 전용(lookup 미등재), `FPExNum` 은 lookup 전용(FE 미해석).
   ⚠ 2026-08-21 15:57 적재 창에서 이 테이블이 **일시 0행**이었다. 그 스냅샷으로 사전을 만들면
   허용값이 비어 **전 컬럼이 위반으로 뒤집히므로**, `02_dump_tobe.py` 는 0행이면 중단한다.
   같은 이유로 "갑자기 전 화면 콤보가 CODE 로 보인다" 진단의 0순위는 이 테이블 행수다
   (CMBO 167건 중 **113건**이 이 테이블을 읽는다).
