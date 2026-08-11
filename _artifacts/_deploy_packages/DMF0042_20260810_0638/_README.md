# DMF0042 (Business Plan) 클라우드 이관 패키지 — 2026-08-10 06:38

> **목적**: 2026-08-09 사내 적용·검증 완료분(**AUTHUNION** + FE 셀 콤보 파라미터 배선)의 **증분 이관**.
> **원천**: 사내 live 덤프(`PKG_DMF0042` BODY 2026-08-09 11:03).
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2곳 동시 적용 의무** (`feedback_cloud_be_build_out_of_sync_diagnosis`)

---

## 0. 선행(PREREQ)

| 선행 | 확인 |
|---|---|
| `DMF0042_44_49_CLOUD_APPLY_ORDER_20260805.md` §1 **1~9** (PKG 취합 → `DBWORK_7UI` → COMBO_ASIS_ALIGN) | `90_VERIFY.sql` [1] PACKAGE/BODY VALID |
| 동 순서서 §1 **8·9** (titleset 오염 1행 DELETE / titleset 가드 2줄) | 미적용 시 본 패키지보다 먼저 |

> 본 패키지의 `01_PKG_DMF0042_BODY.sql` 은 위 8·9(가드)까지 **포함한 live 스냅샷**이다.
> 8(데이터 DELETE)만 별도 수행하면 된다.

---

## 1. 적용 순서

| # | 파일 | 내용 |
|---:|---|---|
| 1 | (권장) 클라우드 BE 정지 | `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` |
| 2 | `01_PKG_DMF0042_BODY.sql` | 사내 live BODY **6,600행** — AUTHUNION 포함 누적. SPEC 무변경 |
| 3 | 클라우드 BE 재기동 | |
| 4 | `90_VERIFY.sql` | QA·DEV 각각 |
| 5 | `fe/business-plan/` | FE 스냅샷 — **폴더 통째 교체** |

---

## 2. 변경 요약

### AUTHUNION (2026-08-09)

편집 권한 판정 1곳(BODY 구 L1784 `SEGMENT1 = p_userinfo`)을 **보유 그룹 합집합**으로 확장(+2행).
2026-08-04 사용자 확정 정책.

사내 판정식 전/후 실측:

| 전달값 | 전 | 후 | 판정 |
|---|---:|---:|---|
| `ADMIN`(그룹명) | 1 | 1 | 유지 |
| `GHOST_GROUP`(구세대 ghost groupId) | 0 | 3 | 해소 |
| `bpark416`(USER_ID 직전달) | 0 | 1 | 해소 |
| DM Planner (W/S) · Viewer | 0 | 0 | **과권한 0** |

적용 후 15계정 E2E·9섹션 게이트 재실행 결과가 적용 전과 **동일**(FAIL 0) = 회귀 0.

### FE — 메타 셀 콤보 파라미터 배선

`components/BusinessPlanGrid.tsx` — `DM_LOOKUP_DIV` 계열 셀 콤보가 파라미터 미전달로 **조용히 0행**이던 것을
`param1`(division)·`param2`(컬럼 `ATTRIBUTE1`)로 배선. `comboSig` 에 division 포함(dataMap 잔존 차단).

> AS-IS 공급 계약: `SpreadInfo.cs` L1975~1981(커서 `ATTRIBUTE1~5` → `sParam1~5`)
> ← `DMF0042_GET_SPREAD_TITLE`(`ATTRIBUTE1 = @p_division_id` / `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1`).

---

## 3. 검증 (`90_VERIFY.sql` — QA·DEV 각각)

| # | 항목 | 기대 |
|---|---|---|
| 1 | PKG 컴파일 | PACKAGE VALID / PACKAGE BODY VALID |
| 2 | 컴파일 에러 | 0행 |
| 3 | AUTHUNION | MARKER=1 / UNION_PRED=1 / BODY_LINES=**6,600** |
| 4 | 판정식 원문 | 보유그룹 합집합 형태 육안 확인 |
| 5 | 과권한 회귀 | 대표 계정 3종(관리자·W/S·Viewer) 사내 실측과 동일 |

추가 화면 실증: 조회(81/82/40) → `FCST_TYPE` 셀 콤보 드롭다운에 **값이 보이는지**(코드 raw 표시 아님) 확인.

---

## 4. FE 스냅샷 (`fe/`)

| 경로 | 반영 위치 | 파일 |
|---|---|---:|
| `fe/business-plan/` | `nscm-fe/features/demand/src/pages/business-plan/` | 26 |

> ⚠️ **폴더 통째 교체 의무** — 파일 단위 덮어쓰기 금지 (`feedback_cloud_shell_generation_mismatch`).
> 이번 변경 파일: `components/BusinessPlanGrid.tsx`(+ `__asis-mapping__.md` 토큰 대사표 절 추가).
> ⚠️ lint·type-check 는 **클라우드 셸에서 사용자 실행**.

---

## 5. MSG / LBL / MNU / BTN·API·CMBO 감사

| 분류 | 신규/변경 | 근거 |
|---|---|---|
| MSG_M / LBL_M / locales | **0** | 신규 문구 없음 |
| MNU_M | **0** | 무변경 |
| BTN_MPG / API_M / PROC_M | **0** | 시그니처 무변경 |
| CMBO | **0** | 기존 콤보에 **파라미터를 넘기지 않던 FE 배선**을 고친 것 — 콤보 정의 자체는 무변경 |

> 그리드 셀 콤보 **권한판(`*Auth`)은 교체 금지 확정**(2026-08-09 실측): 권한판 0행 계정 8건 +
> 원장 값 중 권한판 후보 밖 DEPT_ID **73.0%** → 교체 시 CODE→NAME 표시 파손. 본 패키지도 비권한판 유지.

---

## 6. 원복

적용 전 BODY 를 SPOOL 로 확보 후, 문제 시 그 스냅샷으로 재컴파일.
```sql
-- SPOOL cloud_PKG_DMF0042_BODY_before_20260810.sql
-- SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042'
--   AND TYPE='PACKAGE BODY' ORDER BY LINE;
-- SPOOL OFF
```

---

## 7. 근거 자료 (`diagnostics/`)

| 파일 | 내용 |
|---|---|
| `2026-08-09_DMF0042_gate_closure.md` | 종결 보고서 |
| `DMF0042_20260810_0612.md` | 완료 게이트 — FAIL 0 (섹션 3·7 WARN 2 는 **기존 상태**, 본 증분과 무관) |
| `DMF0042_http_e2e_20260810_0554.md` | 15계정 HTTP E2E — 종합 PASS(FAIL 0 / WARN 0) |
| `authunion_apply.py` | AUTHUNION 적용기(치환 건수 불일치 시 중단) |
