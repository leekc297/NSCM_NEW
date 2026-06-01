# Hook — 신규/수정 화면 진입 시 As-Is DB baseline 자동 점검

> ⭐⭐ **2026-06-01 신규** (Plan Stage 5).
> 신규 화면 작업 진입 (룰 25 §0.5) 또는 DB 오류 발생 시 As-Is 원본 cross-check 자동 실행.

작성: 2026-06-01
상위 룰: 룰 25 §0.5 / 룰 24 §6.5 / 룰 21 §12
도구: `_artifacts/_diagnostics/` (Stage 4)

---

## §0. 트리거

본 hook 의 모든 단계 의무 적용:
1. **신규 화면 진입 시** — 룰 25 §1 5종 자료 Read 직후, 코드 작성 전
2. **DB 오류 발생 시** — ORA-XXXXX / PLS-00XXX
3. **Row 수 불일치 의심 시** — 화면 결과 As-Is 와 다름 신고
4. **컬럼/스키마 의문 시** — "이 컬럼 진짜 있나?" 의문

---

## §1. 4단계 baseline 점검

### Step 1. 매핑 표 등록

`_artifacts/_diagnostics/_mapping_asis_tobe.csv` 에 신규 화면의 SP / 테이블 매핑 1줄 이상 추가.

```csv
DM,SP_DMF0099_GET_DATA,PKG_DMF0099,P_DMF0099_GET_DATA,SCM_MST_FOO,SCM_MST_FOO,
```

### Step 2. Row count cross-check (모든 신규 화면 의무)

화면 진입 시 의존 테이블 row count 비교:

```bash
./_artifacts/_diagnostics/row_count_diff.sh <TABLE_NAME>
```

조건:
- |Diff| ≤ 1% (또는 절대 차이 < 100) — **OK**
- |Diff| > 1% (또는 절대 차이 ≥ 100) — **사용자 확인 의무** (마이그레이션 보강 작업 별도)

### Step 3. Column inventory cross-check (신규 화면 의무)

```bash
./_artifacts/_diagnostics/column_inventory.sh <TABLE_NAME>
```

조건:
- 컬럼 수 / 컬럼 명 1:1 일치 — **OK**
- 불일치 — **즉시 사용자 보고** (잘못된 매핑 또는 마이그레이션 누락)

### Step 4. SP body diff (조건부)

조건:
- 신규 화면 SP 가 PIVOT / 동적 컬럼 / bulk save 패턴 — **의무**
- 그 외 단순 CRUD — **선택**

```bash
./_artifacts/_diagnostics/sp_body_diff.sh <ASIS_SP> <TOBE_PKG>
```

---

## §2. baseline 결과 보고서

```markdown
## As-Is DB Baseline (룰 25 §0.5 / hook screen-entry-asis-baseline)

| 점검 | 대상 | 결과 |
|---|---|---|
| Row count diff | `<TABLE>` | ✅ OK (As-Is 1234 / To-Be 1234) |
| Column inventory | `<TABLE>` | ✅ OK (15 cols) |
| SP body diff | `SP_X` | ⚠️ 차이 있음 (As-Is 240 lines / To-Be 195 lines) — 검토 필요 |

baseline OK → 코드 작성 진입
baseline 결함 → 사용자 보고 + 결정 대기
```

---

## §3. 사고 사례 (DMF0043)

| 사고 | baseline 미실행 시 발생 | baseline 실행 시 사전 검출 |
|---|---|---|
| `SCM_MST_SITE_ITEM.ATTRIBUTE1/2 NULL` 18 rows 만 | 화면 빈 결과 → 5단계 진단 후 발견 | `row_count_diff.sh` + `column_inventory.sh` 로 즉시 발견 |
| DTL 96 row 누락 | 저장 후 빈 결과 → SP 의심 | `row_count_diff.sh` 로 즉시 발견 (1.5M vs 27K) |
| SP `[col]` → `"col"` 미변환 | ORA-00936 발생 후 fix | `sp_body_diff.sh` 로 변환 잔존 사전 검출 |

---

## §4. PR 머지 게이트 자기 점검

- [ ] `_mapping_asis_tobe.csv` 에 신규 화면 1줄 이상 추가
- [ ] `row_count_diff.sh` 결과 |Diff| ≤ 1% 또는 사용자 승인
- [ ] `column_inventory.sh` 결과 컬럼 1:1 일치 또는 사용자 승인
- [ ] (해당 시) `sp_body_diff.sh` 결과 검토 + `__asis-mapping__.md ## DB Baseline` 섹션 작성

---

## §5. 관련 룰

- 룰 25 §0.5 (Plan Stage 5 추가) — 신규 화면 진입 의무
- 룰 24 §6.5 — As-Is DB 직접 cross-check
- 룰 21 §12 — DB 오류 사고 묶음
- `_artifacts/_diagnostics/README.md` — 도구 사용법
