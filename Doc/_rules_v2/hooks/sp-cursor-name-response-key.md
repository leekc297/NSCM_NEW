# Hook — SP OUT cursor 이름 ↔ FE response 키 정합 (fallback chain 의무)

> **Trigger**: T07 (데이터 조회/SAVE) + T08 (BE/SP) — FE 가 `useTabProcQuery` / `useProcMutation` 결과에서 cursor data 추출 시
> **PR 차단 강도**: ⭐⭐⭐ (단일 키 의존 시 빈 grid 회귀)
> **신설일**: 2026-06-22 (DMF0008 V11→V12 회귀 사고)

작성: 2026-06-22
상위 룰: `anti-simplification.md` / `procedure-dts-ssot-mandatory.md`
짝 hook: `proc-meta-signature-match.md` / `sp-dual-cursor-pattern.md`
관련 메모리: `feedback_sp_cursor_reassignment_overwrite.md`

---

## §0. 사고 (2026-06-22 — DMF0008 V11→V12)

### §0.1 증상
- 사용자: "DMF0008 REPAIR 더블클릭 시 하단 조회 되어야 하는데 데이터가 안 보임. SP 정상 호출 확인됨."
- BE log: SP `DMF0008_GET_SALES_SITE` 정상 응답, 1 row 반환.
- FE: 빈 grid 표시.

### §0.2 직접 증거 (BE log)
```json
"result": { "O_RESULT_CURSOR": [{...1 row...}], "DATARESULT": [] }
```

### §0.3 root cause
- SP `DMF0008_GET_SALES_SITE` OUT 단일 cursor 이름 = **`O_RESULT_CURSOR`** (대문자, SP signature `ALL_ARGUMENTS` 확인)
- BE 응답 key = `O_RESULT_CURSOR` (NSCM 표준: cursor 이름 그대로 응답)
- FE 코드: `salesSiteData?.o_rc1` (소문자) → undefined → `?? []` → 빈 grid

### §0.4 회귀 기원
이전 코드 (working):
```ts
const salesSiteRows = safeRows(salesSiteData?.O_RESULT_CURSOR ?? salesSiteData?.o_rc1);
```

V11 fix (2026-06-20) 주석: "typo dead code `?? salesSiteData?.o_rc1` 제거".
→ V11 가 **올바른 fallback (`O_RESULT_CURSOR`) 을 dead code 로 오인하고 제거** + 잘못된 키 (`o_rc1`) 만 남김 → **회귀 사고**.

```ts
// V11 (회귀)
const salesSiteRows = salesSiteData?.o_rc1 ?? [];
```

---

## §1. 원칙

FE 가 SP 응답에서 row 추출 시 **사내 PROC_M 또는 SP signature 의 ARGUMENT_NAME 을 그대로** 키로 사용. 단일 키 의존 금지 — fallback chain 필수.

---

## §2. NSCM 표준 cursor 명명 규약

| SP 패턴 | 첫 OUT cursor | 둘째 OUT cursor (optional) |
|---|---|---|
| 단일 cursor SP | `o_rc1` (소문자) **또는** `O_RESULT_CURSOR` (대문자) | — |
| dual cursor SP | `o_rc1` | `O_RESULT_CURSOR` |
| 권한·검증 wrapper | `o_rc1` | `O_RESULT_CURSOR` (실 데이터) |

⚠️ SP 별로 다름. **PROC_M / SP signature cross-check 의무**.

---

## §3. FE 추출 표준 (fallback chain)

### §3.1 단일 cursor SP 추출

```ts
// Primary 우선 + alias fallback
const rows = data?.o_rc1 ?? data?.O_RESULT_CURSOR ?? [];

// 또는 SP 가 O_RESULT_CURSOR 단일 인 경우 (사내 PROC_M cross-check 확인 후)
const rows = data?.O_RESULT_CURSOR ?? data?.o_rc1 ?? [];
```

### §3.2 dual cursor SP 추출

```ts
const mainRows = data?.o_rc1 ?? [];                    // primary
const validationRows = data?.O_RESULT_CURSOR ?? [];    // wrapper / 검증
```

### §3.3 procedures.d.ts 타입 정의 동반

```ts
DMF0008: {
  salesSite: {
    response: {
      o_rc1: { ... };                  // procedures.d.ts SSOT 정의
      O_RESULT_CURSOR?: { ... };       // alias optional 표시
    };
  };
};
```

---

## §4. PRE-WRITE 점검 (FE 신규 화면)

cursor data 추출 코드 작성 전 다음 cross-check 의무:

1. [ ] **SP signature 조회** — `SELECT POSITION, ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS WHERE OBJECT_NAME='...'`
2. [ ] **PROC_M 메타 조회** — `SELECT COL_NM FROM SCM_ADM_PROC_M WHERE PROC_NM='...' AND COL_TP_CD='OUT'`
3. [ ] **BE log 실제 응답 키 확인** — `SCM_COM_SQL_LOG.PARAMS` 또는 SystemLogAspect 의 callProc result JSON
4. [ ] **fallback chain 작성** — primary `??` alias `?? []`

위 4 점검 모두 ✅ 일 때만 진행. cursor 이름 추측 금지.

---

## §5. POST-WRITE grep 검증

```bash
# 단일 cursor 의존 패턴 잔존 검색 (회귀 차단)
grep -nE "Data\?\.o_rc1 \?\?  \[\]|Data\?\.O_RESULT_CURSOR \?\? \[\]" features/

# 발견 시 → fallback chain 추가 의무
```

---

## §6. dead code 정리 시 주의 (V11 회귀 교훈)

`safeRows()` helper / `??` fallback 제거 시:

| 행위 | 위험 |
|---|---|
| ❌ "이게 dead code 같아 보임" 추정 제거 | V11 회귀처럼 working fallback 제거 위험 |
| ✅ git blame + 이전 commit 이력 추적 | 의도 확인 후 제거 |
| ✅ BE log 응답 키 직접 확인 후 제거 | 어느 키가 실제 사용되는지 검증 |

---

## §7. 사고 카탈로그

| 일자 | 화면 | 사고 | Fix |
|---|---|---|---|
| 2026-06-20 | DMF0008 V11 | `?? salesSiteData?.o_rc1` 를 dead code 로 오인하고 제거 + 잘못된 키만 남김 | (당시 미인지) |
| 2026-06-22 | DMF0008 V12 | SP signature + BE log 검증 → `O_RESULT_CURSOR` primary + `o_rc1` fallback 복원 | ✅ 적용 완료 |
| 2026-06-22 | DMF0008 V13 | 하단 sub-tab lazy fetch — `tab-driven-lazy-fetch.md` 별도 hook | ✅ |

---

## §8. 자기 진화 메타

### 8.1 generalizable 패턴
NSCM 의 BE 가 cursor 데이터를 응답에 넣을 때 **SP signature 의 OUT ARGUMENT_NAME 을 그대로 키로** 사용. PROC_M 의 COL_NM 등록 값과 일치해야 함.

### 8.2 작성 시 의무
- procedures.d.ts 에 모든 가능한 cursor key 정의 (primary + alias optional)
- FE 추출 코드에 fallback chain 의무 (단일 키 의존 금지)
- dead code 정리는 BE log + git blame 검증 후
