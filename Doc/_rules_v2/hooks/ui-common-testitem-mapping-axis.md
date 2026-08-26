# Hook #133 — ui-common-testitem-mapping-axis ⭐⭐⭐ (사용자 명시 2026-08-12)

> **트리거**: UI 생성(T01)·보완(T01M) 시 대사표(`__asis-mapping__.md`) 생성·검증 전부.
> **한 줄**: 통합테스트 **UI 공통 부문 6항목**(구분='Common')은 화면 분석 md 에 없어도
> **모든 화면 대사표에 상시 축(`COMMON:UC-01~06`)으로 항상 추가**하고 전 행 판정한다.
> **강제 도구**: `asis_mapping_gate.py` — `--init` 이 §UI 공통 축을 자동 생성,
> `--check` 가 **6행 중 1행이라도 부재하면 FAIL** (조용한 미편입 차단).
> **연관**: #132(§2-2/§3 이 UC-03/04 의 구현 표준) · asis-coverage-check §0.1 · #124/#126

---

## §1 배경 (Why)

통합테스트 사전점검의 **구분='Common' 행**은 "전체 UI" 대상 공통 요구라서 특정 화면 결함 행과
달리 **화면별 분석 md 에 등장하지 않는다** → EID 1:1 대사표가 원천 md 만 보면 이 6건은
어느 화면에서도 대사 대상이 되지 않고 조용히 누락된다(2026-08-12 사용자 지정으로 상시 축 신설).

## §2 원천 (단일 소스)

`Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` [수정사항] 시트
**구분='Common' 6행** — 도구 상수 `asis_mapping_gate.py::UI_COMMON_ITEMS` 가 정본.
항목 추가·개정 = **이 상수만 수정**하면 전 화면 `--check` 가 신규 행 부재를 FAIL 로 잡는다.

| ID | 요구 | 구현 표준(선례) |
|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 추가 행 표시 — ⭐ **필터는 유지한 채** (2026-08-14 역전, §5) | `keepRowVisibleUnderFilter(grid, newRow)` (`@foundation/utils`). ⛔ `gridFilterRef.current?.clear()` **금지** |
| COMMON:UC-02 | 수정 중 다른 데이터 조회 시도 = confirm | handleSearch 선두 `hasPendingChanges()` → **MSG00703** confirm — 미가드 시 `setInsertedRows([])` 가 변경분 조용히 폐기 (DMF0021 C2) |
| COMMON:UC-03 | 컬럼 추가/제외 적용 = 기존 데이터 Reset 후 재조회 유도 | 설정 저장 → **그리드 비움**(hook #132 §2-2 — 자동 재조회 ⛔) |
| COMMON:UC-04 | CRUD 완료 = Alert 아닌 하단 중앙 Toast | `setToast type:'success'` (hook #132 §3 — Alert 는 실패·검증·confirm 전용) |
| COMMON:UC-05 | Excel Download 콤보 컬럼 = Name 출력 | 공용 `gridAction.ts` excelDownload **dataMap 승계**(2026-08-12 공용 보완 — 소비 경로 확인만) |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 전건 조회 | SP `FN_STRING_SPLIT` 계열 다중 매칭(+빈값 NULL 가드 — feedback_sp_empty_filter_null_like_join_wipe) |
| COMMON:UC-07 | ⭐ 필터가 걸린 상태에서 **재조회해도 조회가 되고 필터도 그대로 적용** (2026-08-14 신설, §5) | 재조회 후 `rebindFilterColumns(grid, gridFilterRef.current)` (`@foundation/utils`) — 헤더 필터 표시만 남고 조건이 풀리는 현상 차단 |

## §3 의무 (MUST)

1. **신규 화면(T01)**: `--init` 이 생성한 §UI 공통 축 6행을 다른 EID 행과 동일하게 **전 행 판정**
   (구현+위치 / 제외·해당없음+사유). 빈 칸 = `--check` FAIL.
2. **화면 보완(T01M)**: 대사표에 §UI 공통 축이 없으면(구양식) **먼저 6행을 추가·판정 후** 보완 진행
   — `--check` 가 부재를 FAIL 로 강제한다.
3. 판정은 **실측**으로: UC-01/02 는 핸들러 코드에서 clear/confirm 실재 확인, UC-05 는 공용 경로
   소비 확인(로컬 Excel 구현이면 dataMap 승계 여부 직접 확인), UC-06 은 SP 의 split 처리 실재 확인.
4. 소급 일괄 작업은 하지 않는다 — **화면별 실제 작업 시점 적용** (hook #124 소급 정책 동일).

## §4 점검

```bash
# 대사표에 공통 축 존재 + 전 행 판정 (부재 시 FAIL 메시지에 누락 ID 나열)
python _artifacts/_diagnostics/asis_mapping_gate.py --check <페이지폴더>
# FE 측 빠른 실측 (UC-01/02/04/07)
grep -n "keepRowVisibleUnderFilter\|rebindFilterColumns\|MSG00703\|setToast" <페이지>/*.tsx
# ⛔ 있으면 위반 — UC-01 은 필터를 풀지 않는다
grep -n "gridFilterRef.current?.clear()" <페이지>/*.tsx
```

## §5 ⭐⭐⭐ 그리드 필터 상시 유지 2종 (사용자 공통 수정사항 2026-08-14 — **UI 적용 시 상시**)

> 사용자 전달 원문 "공통 수정사항" 2건. **전 UI 상시 적용 대상**이며 아래 지정 화면은 명시 대상이다.

| # | 요구 | 현상(결함) | 대상 화면(원문 명시) |
|---|---|---|---|
| **1 (UC-01 역전)** | 필터가 걸린 상태에서 **Insert 해도 라인이 추가되도록** | 추가된 라인이 **사라지거나**, **필터가 풀리는** 현상 | N:N Mapping Master / Sales price / Business plan / Sales reports / ETC sales reports / MKT FCST / Sales Plan / Demand manager |
| **2 (UC-07 신설)** | 필터가 걸린 상태에서 **재조회해도 조회되고 필터도 적용** | 조회하면 컬럼에 필터 표시는 **남아 있지만 필터가 풀린 상태**로 조회됨 | Sales Monitoring / Sales price / Business Plan / Sales Reports / ETC Sales Reports / MKT FCST / Sales Plan / Demand manager |

### §5.1 ⛔ 종전 구현(필터 clear)은 **폐기**

2026-08-11 통합테스트 1st C1 대응으로 `handleInsert` 말미에 `gridFilterRef.current?.clear()` 를
넣은 화면들이 있다. 이는 **요구 ①의 후반부("필터가 풀리는 현상")를 스스로 만드는 구현**이다.
필터는 **유지**하고, 신규행만 필터 예외로 통과시켜야 한다.

### §5.2 구현 표준 — 공용 유틸 2종만 사용 (자체 구현 금지)

두 요구 모두 이미 `@foundation/utils`(`packages/foundation/src/utils/gridAction.ts`)에 정본이 있다.
화면에서 wijmo 내부(`_newAddedRowsSet` / `_filters`)를 직접 만지지 말 것.

| 요구 | 호출 | 시점 |
|---|---|---|
| ① Insert | `keepRowVisibleUnderFilter(grid, newRow)` | 신규행 객체를 만든 **직후**(그리드 반영 전) |
| ② 재조회 | `rebindFilterColumns(grid, gridFilterRef.current)` | 조회 응답 반영 후 레이아웃 재적용 시점 |

- **①의 원리**: `FlexGridFilter._filter` 는 `grid._newAddedRowsSet` 에 든 행을 **조건 검사 없이 통과**시킨다.
  그런데 그 등록이 FlexSheet 전용 `rowChanged` 에만 걸려 있어 FlexGrid 신규행은 등록되지 않는다
  → 값이 빈 신규행이 필터에 걸려 사라진다. 유틸이 추가 시점에 직접 등록한다.
- **②의 원리**: `columnGroups` 재대입마다 wijmo 가 `Column` 객체를 **통째로 재생성**하는데
  `FlexGridFilter` 는 죽은 Column 참조를 붙든 채 남는다 → "헤더 필터 표시는 있는데 조건은 안 먹는"
  상태. `filterDefinition` 왕복(get→set)으로 재바인딩하면 선택 값·조건이 그대로 승계된다.
- ⚠ ②가 `apply()` 를 태우면서 ①의 예외 Set 을 비우므로, 유틸은 왕복 전후로 그 Set 을 보존한다
  — **두 유틸을 각각 쓰되 순서를 바꾸거나 사이에 직접 `apply()` 를 넣지 말 것**.

### §5.3 적용 범위

- 신규(T01)·보완(T01M) **모든 그리드 화면**에 상시 적용 — 위 표의 화면 목록은 사용자 지정 최소 대상이다.
- 소급 일괄 작업은 하지 않는다(§3-4 동일) — **화면별 작업 시점에 UC-01/UC-07 을 함께 처리**한다.

---

## §6 Cross-ref — 화면별 지정 요구 축과의 관계 (hook #139, 2026-08-20)

- 본 #133 = **전 화면 상시 공통 7항목** (COMMON:UC-01~07). 화면별로 **지정된** 보완요청은
  hook #139 `request-ledger-and-subclause-mapping` 의 원장(`Doc/단위테스트_보완대상/보완요청_원장.md`)
  + 대사표 `REQ:` 축 + 러너 섹션 10 이 담당한다 (미적용 전제 · PENDING 0 의무).
- 원장의 Common 행(REQ:1ST-C1~C6 등)은 `=COMMON:UC-nn` 위임 표기로 본 축이 판정을 담당한다
  (이중 판정 방지). §5.3 의 "화면별 작업 시점 소급" 대기 목록은 #139 의 `REQ:RULE-` 행 유형으로
  원장에 분모로 실존한다 (소멸 불가).
