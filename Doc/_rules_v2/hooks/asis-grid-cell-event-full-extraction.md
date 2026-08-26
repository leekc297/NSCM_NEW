# Hook #146 — AS-IS 그리드 셀 EVENT 전수 추출 → TO-BE 누락 0

> 신설 2026-08-22 (사용자 명시). 계기 = DMF0082 에서 **AS-IS 그리드 셀 종속(컬럼 변경 → 다른 컬럼 변화)이
> 통째로 미반영**인 채 화면이 "완료" 로 다뤄져 온 것.
>
> 사용자 원문:
> > "AS-IS 소스에서 사용한 EVENT의 경우에는 MD 파일로 정리 후 TO-BE 에 누락없이 적용되도록 해주세요.
> >  이부분은 RULE 로 적용하도록 MD, HOOK 파일을 보완해주세요. **절대 누락되지 안되는 영역입니다.**"
>
> 적용 범위: **그리드가 있는 모든 화면**(신규·보완 공통). 카테고리 = `11_asis_parity`(주) · `03_grid_column_meta` · `12_process_ops`.
> 짝 룰: [[grid-insert-and-modal-derived-parity]](#143 — 모달 파생) · [[comment-live-code-discrimination]](#138 — 주석≠근거) ·
> [[verification-evidence-and-scale]](#145 — 근거 형식) · [[ui-meta-dictionary-mandatory]](#142).

---

## §0. 왜 신설하나 — 추정본이 정본 행세를 했다

DMF0082 의 기존 분석 문서 `Doc/_analysis/domain_DM/screens/DMF0082_FcstNPrice_Mgmt/events.md` 는
본문에 스스로 **"추정 이벤트 핸들러 (40+)"** 라 적어 두고, `.cs` 전체 read 를 미이행 상태로 남겼다.
그 추정본이 이후 구현의 유일한 이벤트 근거로 쓰였고, 실측하니 **핸들러 이름부터 틀렸다.**

| 추정본 주장 | Designer 실측 |
|---|---|
| `spdMain_CellEditEnded` | **없음** |
| `spdMain_Paste` | **없음** (실제 `ClipboardPasted`) |
| `spdMain_KeyDown` | **없음** (실제 `KeyUp`) |

결과: **"AS-IS 에 있는 셀 종속이 TO-BE 에 반영됐는지" 를 아무도 축 단위로 말할 수 없는 상태**가 됐다.
근거 문서가 추정본이라 대조할 분모 자체가 없었고, 사용자가 화면에서 의심해 물을 때까지 드러나지 않았다.

⚠ 그 뒤 실측에서 **판정이 두 번 뒤집혔다** — 처음엔 "12축 중 8축 미배선" 으로 보고했으나 TO-BE 코드를
되짚으니 **실질 결손 0** 이었다(§1.4 참조). 분모가 없으면 "미반영" 도 "반영" 도 똑같이 근거가 없다.
이 룰이 요구하는 것은 **축 목록(분모) + 축별 양방향 실측**이다.

---

## §1. PRE-WRITE — 그리드 화면 착수 전 **이벤트 전수 추출** 의무

### 1.1 배선 실측이 먼저다 (추정 금지)

`.Designer.cs` 의 **이벤트 등록문**을 grep 해 실제 배선 목록을 확정한다. 문서·기억·유사 화면에서
핸들러 이름을 옮겨 적지 않는다.

```bash
grep -n "\.\(CellDoubleClick\|ComboSelChange\|EditChange\|Changed\|ClipboardPasted\|LeaveCell\|KeyUp\|KeyDown\|TopChange\|EditModeOff\) *+=" *.Designer.cs
```

### 1.2 판정은 **주석 제거본**에서만 (hook #138)

정본 도구 `_artifacts/_diagnostics/strip_code_comments.py` 의 `strip_cs`(라인 보존).
이 축에서 주석을 세면 **있지도 않은 종속이 생긴다** — DMF0082 실측:

- `spdMain_LeaveCell` 150 LOC → **본문 전체 주석** = 동작 없음
- `ComboSelChange` 의 `MEASURE` 분기 → **본문 전체 주석** = 동작 없음
- 반대로 주석 처리된 `SetValue(e.Row, iCol, "")` 계열이 다수 — 이걸 "값 삭제 종속" 으로 읽으면 오구현

### 1.3 핸들러는 **전 라인** 읽는다 (anti-simplification)

LOC 를 먼저 재고 그 수만큼 읽는다. DMF0082 실측 규모: `Changed` 2,089 · `ClipboardPasted` 335 ·
`CellDoubleClick` 299 · `ComboSelChange` 172 — **합계 약 3,000 LOC**. 샘플링·grep 만으로 끝내지 않는다.

⚠ 종속이 한 핸들러에 모여 있지 **않다.** DMF0082 는 `ComboSelChange`(콤보 선택)와 `ClipboardPasted`
(붙여넣기)에 **서로 다른 절반**이 들어 있었다. 하나만 읽으면 절반을 놓친다.

---

### 1.4 ⭐ **TO-BE 판정 전 — 트리거 컬럼이 편집 가능한지 먼저 본다**

AS-IS 종속을 "TO-BE 미배선" 으로 적기 전에 **트리거 컬럼의 `INPUT_TP_CD`** 를 실측한다.
편집 불가(`S`) 컬럼은 이벤트가 **발생 자체를 못 하므로** 배선이 없어도 결손이 아니다.

```sql
SELECT COLUMN_NAME, INPUT_TP_CD, DIVISION_ID, VISIBLE_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = :prog AND SHEET_NAME = :sheet;
```

| `INPUT_TP_CD` | 뜻 | 종속 필요? |
|---|---|---|
| `S` | 조회전용 | **불요** — 트리거 불가 |
| `O` / `M` | 편집 / 필수 | 필요 |
| `IO` / `IM` | 신규행만 편집 / 필수 | 필요(신규행 한정) |

`DIVISION_ID` 스코프도 함께 본다 — 해당 division 에 컬럼이 아예 없으면 AS-IS 의 "잠금 토글" 과 **등가**다.

> ⛔ **실사고 (2026-08-22, 이 룰 자신의 계기)** — DMF0082 를 "12축 중 8축 미배선" 으로 보고했는데,
> 코드·메타를 되짚으니 **실질 결손 0** 이었다. `DIVISION_ID`·`TEAM_ID` 가 `S`(조회전용)라 E-01·E-02 는
> 트리거가 없었고, E-03/E-05/E-06/E-07 은 **행별 `apply*` 함수 + WeakMap 캐시**로 이미 구현돼 있었다.
> AS-IS 문서만 보고 TO-BE 코드를 안 읽은 결과다 (#145 §1 이 금지하는 형태). **양쪽을 다 읽어야 판정이다.**

### 1.5 TO-BE 구현 패턴 (정본)

메타 `ATTRIBUTE2` 가 아니라 **행별 서버 재조회 + WeakMap 캐시**가 이 프로젝트의 정본이다.

```
apply*(dataItem)  →  apiClient.getCombo({comboId, …행 키})  →  ref.current.set(dataItem, rows)
cellEditEnded / pastedCell  →  트리거 binding 판정  →  apply*(dataItem)
```

정본 코드: `ForecastPriceGrid.tsx` — `applySalesBucket`(:396) `applyEditMeasures`(:422)
`applySalesSites`(:463) `applyCellProdSites`(:480), 트리거 :1169~1196, 편집·붙여넣기 공통 배선 :1510~1511.
**Insert 행 프라이밍**(행 생성 즉시 시드 키로 재조회)도 함께 둔다 — 사용자가 시드 그대로 저장하면
필터가 한 번도 적용되지 않는다.

---

## §2. 산출물 — 화면별 `events_grid_cell.md` (필수)

위치: `Doc/_analysis/{domain}/screens/{화면}/events_grid_cell.md`
정본 예시: `Doc/_analysis/domain_DM/screens/DMF0082_FcstNPrice_Mgmt/events_grid_cell.md`

### 필수 섹션

| § | 내용 | 공란 허용 |
|---|---|---|
| §0 | Designer 실측 배선 + 핸들러별 **라인·LOC·판독여부** | ⛔ |
| §1~ | 핸들러별 **컬럼 → 영향 → 동작 → `파일:라인`** 표 | ⛔ |
| 종속 그래프 | 전 핸들러 통합 다이어그램 | ⛔ |
| **TO-BE 반영 현황** | `E-01…` 축 번호 + `✅/⛔/❓` | ⛔ |

### 동작 유형은 **구분해서** 적는다 (뭉뚱그리면 오구현)

| 유형 | 뜻 | DMF0082 예 |
|---|---|---|
| `콤보 재조회` | 하위 콤보의 **후보 집합**을 서버에서 다시 가져온다 | `SCM_SITE_ID → MEASURE 콤보` |
| `값 세팅/클리어` | 다른 컬럼의 **값**을 산식으로 쓴다 | `SCM_SITE/INCOTERMS → BUCKET` |
| `잠금 토글` | 편집 가능/불가만 바뀐다 | `DIVISION 81* → PLANT_SITE 해제` |
| `자기 셀 되돌림` | 방금 편집한 셀을 비우고 메시지 | 신규행 8키 중복 → `MSG00260` |
| `파생 채움` | 팝업 선택 결과로 여러 컬럼을 채운다 | `PROJECT_CODE → 4컬럼` (hook #143) |

⭐ **콤보 파라미터 계약을 반드시 명시한다** — "무엇이 바뀌면 무엇이 바뀌는가" 의 실체다.

```
CELL_PROD_SITE_ID 콤보 ← (DIVISION_ID, ITEM_ID)
MEASURE 콤보           ← (DIVISION_ID, SCM_SITE_ID, bucketType)
BUCKET 값              ← SALES_BUCKET(DIVISION_ID, SCM_SITE_ID, INCOTERMS)
```

---

## §3. ⛔ `ATTRIBUTE2` 로 대체하지 않는다

공용 `DataGrid` 의 컬럼 메타 `ATTRIBUTE2` 종속은 **"상위 콤보를 바꿔 하위 셀 값이 후보 밖이 되면 비운다"**
는 좁은 처리다. AS-IS 는 **후보 집합 자체를 서버 재조회**하거나 **다른 컬럼 값을 산식으로 세팅**한다.
축이 다르므로 `ATTRIBUTE2` 등록으로 이 항목을 닫지 않는다.

실측(2026-08-22): DMF0082 `SHEET_COLUMNS.ATTRIBUTE2` 정의 **0건**. 전 화면 통틀어 보유 화면은
DMF0008(8) · DMF0004(6) · DMF0005(6) · DMF0006(3) · SYS0009(1) 뿐이다.

---

## §4. 대사표 등재 의무

추출한 축은 **하나도 빠짐없이** `__asis-mapping__.md` 에 `EVENT:` 접두로 한 행씩 올린다.

```
| EVENT:E-06 | SCM_SITE/INCOTERMS 변경 → BUCKET 값 (SALES_BUCKET) | <구현 위치 or 공란> | — | 미구현 |
```

- 행 단위가 아니라 **축(E-nn) 단위** — 한 핸들러를 "구현" 한 줄로 닫지 않는다 (#145 §5)
- `구현` 주장에는 **대조 가능한 근거**(파일:라인 / 백틱 심볼 / 백틱 리터럴) 필수 (#145 §1)
- **미완 구간을 문서에 명시**한다 — 다 못 읽었으면 "전수 완료" 라 쓰지 않는다

---

## §5. 종료 게이트 (그리드 화면 완료 선언 전 — 전부 통과)

| # | 게이트 | 판정 |
|---|---|---|
| G146-1 | `events_grid_cell.md` 존재 · §0 핸들러표 **판독여부 전부 ✅** | 미판독 1건이라도 남으면 FAIL |
| G146-2 | 배선 목록이 `.Designer.cs` grep 결과와 **정확히 일치** | 추정 이름 1건이라도 있으면 FAIL |
| G146-3 | 종속 표의 모든 행에 `파일:라인` 근거 | 공란 FAIL |
| G146-4 | TO-BE 반영 현황에 `❓` 0건 | 미확인 남기고 완료 선언 금지 |
| G146-4b | **⛔ 판정 행마다 트리거 `INPUT_TP_CD` 실측치 기재** | 미기재 = 판정 무효(§1.4) |
| G146-4c | **TO-BE 코드 실측 근거**(`파일:심볼:라인`) 없이 `⛔` 금지 | 문서만 보고 미배선 단정 = FAIL |
| G146-5 | 대사표 `EVENT:` 축 = 문서의 축 수와 **동수** | 불일치 FAIL |
| G146-6 | `⛔`(미구현) 축은 **사용자 보고** 후 결정 | 조용히 남기지 않는다 |

> ⛔ **"주요 이벤트는 반영했다" 는 표현을 쓰지 않는다.** 축 번호별 `✅/⛔` 로만 말한다.
> 이 영역은 사용자가 **"절대 누락되지 안되는 영역"** 으로 지정했다.
