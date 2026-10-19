# DMF0035 — MEASURE POPUP 설정 순서가 조회에 반영되지 않는 결함 정정

| 항목 | 값 |
|---|---|
| 대상 | `SCM_MGR.PKG_DMF0035` PACKAGE BODY |
| 적용 환경 | 사내 ZIOUI1 **적용 완료** (2026-09-17 18:50:55, STATUS=VALID, 컴파일 에러 0) |
| 적용 전 LAST_DDL | 2026-09-16 15:59:17 (4,311 lines) |
| 변경 | MEASURE 가드 블록 1곳 — **+7행** (정렬축 보강 2행 + 근거 주석 5행) |
| 클라우드 | **미적용** — 본 패키지로 이관 필요 |

## 1. 증상

> DMF0035 조회 시 MEASURE POPUP 에서 설정된 메저 순서대로 메저가 조회되지 않습니다.

## 2. 정렬 설계 (원래 의도)

최종 결과의 정렬은 **동적 SQL 말미 단 1곳**이다.

```
L3707   CHR(10) || ' ORDER BY ' || V_ORDER_LIST;      ← 전 버킷(D/W/M) 공통
```

그리고 메저 축은 REPLACE 규약으로 **팝업 순서**로 치환되도록 설계돼 있다.

```
L3080   V_COL_LIST   := REPLACE(V_COL_LIST,   'MEASURE', 'MEASURE_GROUP,MEASURE,SORT_ORDER_NO');
L3082   V_ORDER_LIST := REPLACE(V_ORDER_LIST, 'MEASURE', 'SORT_ORDER_NO');     ← 팝업 순서
```

`SORT_ORDER_NO` 는 `GT_DM35_SEL_MEASURE`(= titleset `'M'` = MEASURE POPUP 저장분)에서 오며,
L3602 에서 `M.SORT_ORDER_NO` 로 SELECT·L3621 에서 JOIN 되어 **값 자체는 이미 실려 있었다**.

## 3. 근본 원인 — 가드가 `V_COL_LIST` 에만 MEASURE 를 넣는다 (비대칭)

`'C'`(컬럼) 개인화를 가진 사용자는 MEASURE 가 컬럼 목록에서 **두 번** 빠진다.

| 단계 | 내용 |
|---|---|
| ① L2988 | `AND U.COLUMN_NAME NOT IN ('MEASURE')` — 개인화 목록에서 명시적 제외 |
| ② L3030~3037 | 재주입 UNION ALL arm 조건이 `VISIBLE_FLAG='N'` 인데 **MEASURE 는 `VISIBLE='Y'`**(실측) → 재주입 안 됨 |
| ③ L3063~3065 | 보정 가드가 **`V_COL_LIST` 에만** `,MEASURE` 추가 — `V_ORDER_LIST` 는 미보강 |
| ④ L3082 | REPLACE 가 치환 대상('MEASURE')을 못 찾아 **무동작** → ORDER BY 에 `SORT_ORDER_NO` 부재 |

→ **메저 순서가 비결정**(PIVOT/집계 결과 순서에 좌우)이 된다.

개인화가 없는 사용자는 `SHEET_COLUMNS`(`DEFAULT_FLAG='Y'`) 경로로 MEASURE 가
`V_COL_LIST`·`V_ORDER_LIST` 양쪽에 들어와 **무증상**이라 결함이 가려져 있었다.

### 바로 아래 VERSION_NO 가드는 이미 양쪽을 보강하고 있었다

```
L3073~3077  [E20260916-VERCOL]
    V_COL_LIST   := V_COL_LIST || ',VERSION_NO';
    V_ORDER_LIST := CASE WHEN ... THEN 'VERSION_NO ASC' ELSE V_ORDER_LIST || ',VERSION_NO ASC' END;  ← 정렬축도 보강
```

MEASURE 가드(2026-09-09)가 먼저 만들어졌고, VERSION_NO 가드(2026-09-16)가 **뒤늦게 정렬축 보강을
추가**하면서 두 가드가 비대칭으로 남았다. L3062 주석 *"정렬은 REPLACE 규약이 담당"* 은
REPLACE 가 동작할 전제(목록에 MEASURE 존재)가 깨진 상태를 고려하지 못한 것이다.

### 실측 — 대상 사용자

`SCM_MST_TITLESET_USER` (`DMF0035` / `Mkt Fcst Waterfall` / type `'C'`) 보유 계정 **6명 전원 해당**:
`jaehun_cho` · `jiwon.park` · `k0101` · `minyonglee1` · `qjastar` · `wonqthanq`

`SCM_MST_SHEET_COLUMNS` 실측: `MEASURE` = SORT 999 / VISIBLE `Y` / DEFAULT `Y` / SORT_METHOD 공란.

## 4. 정정 내용 (L3063~3065 → +7행)

VERSION_NO 가드와 **동형**으로 맞춘다.

```sql
IF INSTR(',' || REPLACE(REPLACE(V_COL_LIST,' ',''),CHR(10),'') || ',', ',MEASURE,') = 0 THEN
    V_COL_LIST := V_COL_LIST || ',MEASURE';
    --[E20260917-MEASUREORDER] 정렬축도 함께 보강 (아래 VERSION_NO 가드와 동형)
    V_ORDER_LIST := CASE WHEN V_ORDER_LIST IS NULL OR LENGTH(TRIM(V_ORDER_LIST)) = 0
                         THEN 'MEASURE ASC' ELSE V_ORDER_LIST || ',MEASURE ASC' END;
END IF;
```

이후 L3082 REPLACE 가 `MEASURE ASC` → **`SORT_ORDER_NO ASC`** 로 치환한다.

### 위치를 말미로 둔 근거

개인화 없는 경로에서 MEASURE 의 `SORT_ORDER_NO` 는 **999**(전 컬럼 중 최후미)다.
말미 추가가 그 경로와 동일한 정렬 위치를 만든다 — 두 경로의 결과 순서가 일치한다.

### 부작용 점검

`REPLACE(V_ORDER_LIST,'MEASURE','SORT_ORDER_NO')` 가 `MEASURE_GROUP` 까지 치환할 위험 —
`MEASURE_GROUP` 은 `VISIBLE='N'` + `DEFAULT='N'` 이라 양쪽 분기 조건(`DEFAULT='Y'` /
`DEFAULT_FLAG` 공란) 어디에도 걸리지 않아 **목록에 들어오지 않는다**(실측). 해당 없음.

## 5. 검증 — `verify_order.py` (SP 와 동일 로직 재현)

| 대상 | MEASURE in 목록 | 적용 전 `SORT_ORDER_NO` | 적용 후 |
|---|---|---|---|
| 개인화 없음 (SHEET_COLUMNS 경로) | O | **포함** | 포함 (불변) |
| jaehun_cho | X | **미포함** | **포함** |
| jiwon.park | X | **미포함** | **포함** |
| k0101 | X | **미포함** | **포함** |
| minyonglee1 | X | **미포함** | **포함** |
| qjastar | X | **미포함** | **포함** |
| wonqthanq | X | **미포함** | **포함** |

개인화 없는 경로의 최종 ORDER BY 말미(불변 확인):
`... , CELL_PROD_SITE_ID ASC, VERSION_SORT DESC, VERSION_NO , SORT_ORDER_NO`

## 6. 파일

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0035_BODY.sql` | 적용본 전체 4,318행 (SOURCE-FRESH 스탬프 + `CREATE OR REPLACE` + 종결자 `/` + newline) |
| `build_and_apply.py` | 빌더 — ALL_SOURCE 재조회 · 가드 블록 유일성 assert · **L3082 REPLACE 규약 존재 assert** · 적용 직전 LAST_DDL 재확인 (FRESH-GATE, hook #152) |
| `verify_order.py` | 개인화 유무별 `V_ORDER_LIST` 생성 결과 검증 |

## 7. 클라우드 이관 절차

1. 클라우드 `PKG_DMF0035` BODY 의 MEASURE 가드가 `V_COL_LIST := V_COL_LIST || ',MEASURE';` 단독인지 확인
2. `build_and_apply.py` 를 클라우드 접속으로 재실행 (FRESH-GATE 가 클라우드 원문 위에 변경만 재병합)
   — 사내 산출 `01_*.sql` 을 그대로 덮어쓰지 말 것
3. 적용 후 `STATUS=VALID` · `ALL_ERRORS` 0 · `verify_order.py` 재실행

## 8. 사용자 확인 요청

- 화면에서 MEASURE POPUP 순서를 바꾼 뒤 조회해 순서 반영 확인
- 이 정정은 **행 순서만** 바꾼다 — 조회 건수·값에는 영향이 없다(ORDER BY 만 변경)


---

# ⭐ 2차 — SALES PLAN / BIZ PLAN 타입 확대 (2026-09-17 19:14)

사용자 요청: *"동일하게 SALES PLAN, BIZ PLAN TYPE 일 때도 MEASURE 순서 지켜지도록 확인해서 필요 시 보완"*

## A. 타입별 실행 SP — 서로 다른 패키지다

`SCM_ADM_MNU_BTN_MPG_M` × `SCM_ADM_API_M` 조인 실측:

| GUBUN | SHT_NM | API_URL (실행 SP) |
|---|---|---|
| MKT_FCST | `mktFcstWaterfall` | `PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL` (1차 정정분) |
| SALES_PLAN | `salesPlanWaterfall` | **`PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL`** |
| BIZ_PLAN | `bizPlanWaterfall` | **`PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL`** |

## B. 두 패키지도 동일한 구조적 비대칭 보유

| 항목 | PKG_DMF0022 | PKG_DMF0051 |
|---|---|---|
| 최종 정렬 | `ORDER BY v_OrderList` 1곳 | 동일 (L1770) |
| REPLACE 규약 | L2929 `MEASURE → SORT_ORDER_NO,MEASURE` | L1536 동일 |
| MEASURE 가드(수정 전) | L2924~2926 **`v_ColList` 에만** | L1531~1533 **동일** |

## C. SALES 는 실제 결함 상태였다 — 메타 `DEFAULT_FLAG` 차이로 발현

'개인화 없음' 분기 조건 = `DEFAULT_FLAG='Y' OR (VISIBLE='N' AND DEFAULT 공란)`

| 시트 (PROGRAM_ID=DMF0035) | DEFAULT_FLAG (수정 전) | 분기 포함 |
|---|---|---|
| Mkt Fcst Waterfall | `Y` | O |
| Biz Plan Waterfall | `Y` | O |
| **Sales Plan Waterfall** | **`-`** | **X → 결함** |

SALES 의 MEASURE 는 `DEFAULT='-'` + `VISIBLE='Y'` 라 **양쪽 조건 모두 불일치** →
컬럼목록 19개에 미포함 → REPLACE 무동작 → ORDER BY 에 `SORT_ORDER_NO` 부재.
개인화(`'C'`) 보유자는 정상이었고 **개인화 없는 사용자만** 순서가 무시됐다.

## D. 사용자 메타 조치 (2026-09-17 19:09, minyonglee1)

`SCM_MST_SHEET_COLUMNS` `DMF0035`/`Sales Plan Waterfall`/`MEASURE` → `DEFAULT_FLAG='Y'`
→ 다른 두 시트와 값이 정렬됐고, 재검증 결과 **3개 타입 전부 정상**으로 전환.

| 타입 | 개인화 없음 | 개인화 'C' |
|---|---|---|
| SALES | X → **O** (19→20개, MEASURE SORT=900) | O |
| BIZ | O | O |
| MKT | O | O (1차 패치분) |

## E. 코드 대칭화 적용 (사용자 승인 2026-09-17)

메타로 동작은 해소됐으나 **가드 비대칭이 잠재 상태**로 남아, `DEFAULT_FLAG` 가 다시 바뀌면
동일 증상이 재발한다(이번 건이 정확히 그 경로였다). 사용자 승인으로 두 패키지를
`PKG_DMF0035` 와 **동형**으로 맞췄다.

```sql
IF INSTR(... ',MEASURE,') = 0 THEN
    v_ColList := v_ColList || ',MEASURE';
    --[E20260917-MEASUREORDER] 정렬축도 함께 보강
    v_OrderList := CASE WHEN v_OrderList IS NULL OR LENGTH(TRIM(v_OrderList)) = 0
                        THEN 'MEASURE ASC' ELSE v_OrderList || ',MEASURE ASC' END;
END IF;
```

들여쓰기는 패키지별 원문을 승계했다(DMF0022 = 8칸 / DMF0051 = 12칸).

| 패키지 | 적용 전 LAST_DDL | 적용 후 | 상태 | 라인 |
|---|---|---|---|---|
| PKG_DMF0022 | 09-16 15:59:17 | **09-17 19:14:16** | VALID / 에러 0 | 3,782 → 3,789 |
| PKG_DMF0051 | 09-16 14:42:46 | **09-17 19:14:17** | VALID / 에러 0 | 1,845 → 1,852 |

## F. 회귀 방지 실증 — `verify_guard_effect.py`

메타가 다시 `'-'` 로 되돌아간 상황을 **모의**(DB 무변경, 조회만)해 가드 효과를 확인했다.

| 타입 | A 현행 메타 | B 회귀 모의 (적용 전 → 적용 후) |
|---|---|---|
| SALES | O → O | **X → O** |
| BIZ | O → O | **X → O** |
| MKT | O → O | **X → O** |

회귀 모의 시 생성되는 ORDER BY 말미(SALES/BIZ):
`... VERSION_SORT DESC,VERSION_NO DESC,SORT_ORDER_NO,MEASURE ASC`

→ 이제 **메타 값과 무관하게** 메저 순서가 보장된다.

## G. 3 패키지 최종 상태

| 패키지 | 마커 `[E20260917-MEASUREORDER]` | 보강행 | STATUS |
|---|---:|---|---|
| PKG_DMF0035 | 1 | L3071 | VALID |
| PKG_DMF0022 | 1 | L2932 | VALID |
| PKG_DMF0051 | 1 | L1539 | VALID |

## H. 파일 (추가분)

| 파일 | 내용 |
|---|---|
| `02_PKG_DMF0022_BODY.sql` | SALES 적용본 3,789행 |
| `03_PKG_DMF0051_BODY.sql` | BIZ 적용본 1,852행 |
| `patch_sales_biz.py` | 빌더 — FRESH-GATE · 가드 유일성 assert · REPLACE 규약 존재 assert · 들여쓰기 승계 |
| `verify_sales_biz.py` | 3 시트 × 개인화 유무 MEASURE 포함 판정 |
| `verify_guard_effect.py` | 메타 회귀 모의로 가드 효과 실증 |

## I. 클라우드 이관 (갱신)

**3 패키지 모두** 이관 대상이다 — `PKG_DMF0035` / `PKG_DMF0022` / `PKG_DMF0051`.
추가로 메타 1건: `SCM_MST_SHEET_COLUMNS` `DMF0035`/`Sales Plan Waterfall`/`MEASURE`
`DEFAULT_FLAG='Y'` (사내 사용자 조치분 — 클라우드도 동일 값인지 확인 필요).

빌더는 클라우드 접속으로 재실행할 것(사내 산출 SQL 직접 덮어쓰기 금지).
