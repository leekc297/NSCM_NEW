# UI 메타 지식사전 — 진입점

> **스냅샷** 2026-08-21 · **AS-IS 원천** DEV / LGCE_SCMDEV
> **재생성** `_artifacts/_diagnostics/ui_meta_dictionary_20260821/` (01~05 실행 후 07_build_outputs.py)
> ⚠ 이 파일은 생성물이다. 직접 수정하지 말고 파이프라인을 고쳐 재생성한다.
>
> 조회조건 / SHEET_COLUMN / SHEET_MEASURE 3종 지식사전의 목차와 사용법.


## 무엇을 언제 읽나

| 상황 | 읽을 파일 |
|---|---|
| 신규/보완 화면의 **조회조건** 작성 전 | [01_search_conditions.md](01_search_conditions.md) |
| 신규/보완 화면의 **그리드 컬럼 메타** 작성 전 | [02_sheet_columns.md](02_sheet_columns.md) |
| 화면의 **MEASURE** 등록·대조 시 | [03_sheet_measures.md](03_sheet_measures.md) |

## 규모

| 사전 | 항목 | 근거 |
|---|---:|---|
| 조회조건 | 34종 (154 조건 레코드 / 13UI 실측) | DMF 13UI 조회조건 MATRIX v1.0 (extract/*.json 154조건) |
| SHEET_COLUMN | 3225종 | AS-IS 14,675행 + TO-BE 15,702행 |
| SHEET_MEASURE | 494종 | AS-IS 1,505행 + TO-BE 1,711행 |

## 현재 적출 현황

- 컬럼 결함 — ERROR **1145** · WARN 147 · INFO 521
- 표준 콤보 TO-BE 미등록 **117컬럼** (매핑 판단 대상)
- MEASURE 대사 (DM) — DIFF 118 / MISSING 1 / EXTRA 17 · 설명되지 않는 실차이 **6건**
- 게이트: **PASS** (FAIL 0 / WARN 3)

## 사용 규약

1. 사전은 **대조·검출용**이다. 사전 값으로 `SCM_MST_SHEET_COLUMNS` 를 자동 INSERT 하지 않는다
   (`ui-category-setup-no-arbitrary-data`). 등록은 운영자·사용자 결정이다.
2. `confidence` 가 `low`/`none` 인 컬럼은 표준이 아니다 — AS-IS 화면을 확인하고 결정한다.
3. 화면 작업 종료 전 `python 06_verify.py --program {MENU_ID}` 로 해당 화면 ERROR 0 을 확인한다.
4. 원천이 바뀌면 파이프라인을 재실행한다. MD 를 직접 고치지 않는다.

## 한계

1. AS-IS 근거는 **DEV**(`LGCE_SCMDEV`) 스냅샷이다. QA(10.34.221.91:7433)는 본 PC 에서 도달 불가로
   확인됐다. QA 개방 시 환경변수만 바꿔 재실행하고 차이를 대사한다.
   ⚠ DEV 는 작업 중 변동한다 — 2026-08-21 당일 테이블 재적재가 실측됐다
   (`asis_volatility_note.json`).
2. **편집·모달 축은 AS-IS 메타로 검증 불가**하다 (AS-IS `INPUT_TP_CD` 전행 'S' · `FPModal` 0건).
3. 조회조건은 13UI 만 소스 실측이다. 그 밖은 카탈로그(2026-01-22 스냅샷) 커버리지로 표기된다.
4. 컨트롤·정렬 허용값 정본 = **TO-BE `SCM_ADM_LOOKUP_MASTER_DETAIL`**(64,500행) — AS-IS 와 동일
   (컨트롤 13종·align C/L/R)임을 교차검증했다. 허용 컨트롤 = FE enum ∪ lookup.
   ⚠ 2026-08-21 15:57 적재 창에서 이 테이블이 **일시적으로 0행**이었다. 그 상태로 사전을 만들면
   허용값이 비어 전 컬럼이 위반으로 뒤집히므로, `02_dump_tobe.py` 는 0행이면 **중단**한다.
