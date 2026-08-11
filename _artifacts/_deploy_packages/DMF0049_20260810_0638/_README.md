# DMF0049 (Etc Sales Reports) 클라우드 이관 패키지 — 2026-08-10 06:38

> **목적**: 2026-08-09 **AUTHUNION** + 2026-08-10 **UI 보완·검증**(게이트 FAIL 0) 분의 **증분 이관**.
> **원천**: 사내 live 덤프(`PKG_DMF0049` BODY 2026-08-09 13:20) + FE 스냅샷(2026-08-10).
> **검증 상태**: 완료 게이트 **FAIL 0**(PASS 8 / WARN 1) · HTTP 셀프 E2E **FAIL 0**(WARN 1).
> ⛔ **DMF0044 패키지 선행 필수** — DMF0049 SAVE 가 `PKG_DMF0044` 를 내부 호출한다(§0).
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2곳 동시 적용 의무** (`feedback_cloud_be_build_out_of_sync_diagnosis`)

---

## 0. 선행(PREREQ)

| 선행 | 확인 |
|---|---|
| `DMF0042_44_49_CLOUD_APPLY_ORDER_20260805.md` §1 **1~9** (PKG 취합 3UI → `DBWORK_7UI` → COMBO_ASIS_ALIGN) | `90_VERIFY.sql` [1] PACKAGE/BODY VALID |
| ⛔ **DMF0044 패키지 필수 선행** | 같은 배치의 `DMF0044_20260810_0638` 을 **먼저** 적용. `PKG_DMF0049` 본문(BODY L1158)이 `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` 를 호출하는데, 그 안의 **PRODUCT_DETAIL NOT NULL 정정**이 없으면 **DMF0049 SAVE 가 100% 실패**한다(ORA-01400) |

---

## 1. 적용 순서

| # | 파일 | 내용 |
|---:|---|---|
| 1 | (권장) 클라우드 BE 정지 | `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` |
| 2 | `01_PKG_DMF0049_BODY.sql` | 사내 live BODY **1,201행** — AUTHUNION 포함. SPEC 무변경 |
| 3 | 클라우드 BE 재기동 | |
| 4 | `90_VERIFY.sql` | QA·DEV 각각 |

---

## 2. 변경 요약

### ⭐ 2026-08-10 UI 보완 (FE) — 차단급 결함 2건 + cascade 이관

| # | 내용 | 실측 |
|---|---|---|
| D-① | 메타 셀 콤보 **파라미터 전무** → `DM_LOOKUP_DIV` 3컬럼이 **조용한 0행**(그리드가 CODE raw 표시) | 무전달 0 → 전달 시 BIZ_TYPE 6 / ITEM_ID 16 / ITEM_USE 7 |
| D-② | `sEditMeasure` 콤보 값 **미따옴표** → BE raw 치환에서 식별자로 해석 | 따옴표 X = **HTTP 500(-9994)** / O = 1행. 종전엔 `sEditMeasure` 가 항상 빈값이라 **82 편집 개방이 무력화** |
| D-④ | DEPT_ID **부모키 cascade 소실** — 메타 콤보(`DMF0044_DEPARTMENT_TEAM2`)에 부모키 컬럼이 없어 필터가 통째로 무효 | `resolveDeptIdRows` 2분기 이관(AS-IS L1268/L1294) |
| D-⑤ | cascade clear **4분기 매트릭스** 이관 (`cascadeClearColumns`) | AS-IS L1276~1287 · L1331~1405 |
| D-⑥ | 미배선 export 4종 정리 | `callProc`/`isDiv81`/`existingStaticEditable`/`baseYmOf` |

> ⚠ '기타' 분기가 **DMF0044 와 다르다** — DMF0049 AS-IS 는 ETC 콤보 줄(L1293)을 주석 처리하고
> L1294 `DMF0044_DEPARTMENT_TEAM2` 를 쓴다. 형제 화면이라도 원문 그대로 따랐다.

### AS-IS 파리티 판정 (코드 무변경)

`SCM_MST_SHEET_COLUMNS` 가 AS-IS↔TO-BE **42행 / VISIBLE 33행 완전 일치**(직접 대조).
`EndCustomerByDivisionDeptAuth` · `SiteByEndCustomer` 는 붙는 컬럼이 **양쪽 모두 `VISIBLE_FLAG='N'`**(숨김)
이라 셀이 렌더되지 않는다 ⇒ **적용 대상 없음**이 파리티.

### AUTHUNION (2026-08-09)

편집 권한 판정 1곳(BODY 구 L341)을 **보유 그룹 합집합**으로 확장(+3행). 2026-08-04 사용자 확정 정책.

사내 판정식 전/후 실측: `ADMIN` 1→1 유지 / `minyonglee1` 1→4 유지 /
**`bpark416`(USER_ID 직전달) 0→1 해소** / 나머지 0→0 = **과권한 0**.

> 적용 준비 중 안전장치가 정상 작동했다 — DMF0049 는 파라미터가 **소문자 `p_user_group`**
> (DMF0044 는 대문자)이라 1차 치환 0건 → 자동 중단 → 원문 확인 후 정정.
> 원문과 다르면 손대지 않는 설계(`authunion_apply.py`)가 의도대로 동작한 사례.

### FE (`fe/etc-sales-reports/` — 21파일)

> ⚠️ **폴더 통째 교체 의무** — 파일 단위 덮어쓰기 금지 (`feedback_cloud_shell_generation_mismatch`).

이번 변경 파일: `EtcSalesReports.tsx` · `components/EtcSalesReportsGrid.tsx` ·
`utils/etc-sales-reports.{gridCombos,editLock,api}.ts` · `EtcSalesReportsUtils.test.ts`(신규 42 tests).

> 공용 `versionModal/` 은 무변경. 클라우드에 미반영이면 구 순서서 §2 F1 을 먼저 반영할 것.
> ⚠️ **lint·type-check 는 클라우드 셸에서 사용자가 실행**(로컬 실행 금지 룰).

---

## 3. 검증 (`90_VERIFY.sql` — QA·DEV 각각)

| # | 항목 | 기대 |
|---|---|---|
| 1 | PKG 컴파일 | PACKAGE VALID / PACKAGE BODY VALID |
| 2 | 컴파일 에러 | 0행 |
| 3 | AUTHUNION | MARKER=1 / UNION_PRED=1 / BODY_LINES=**1,201** |
| 4 | 판정식 원문 | 보유그룹 합집합 형태 육안 확인 |
| 5 | 과권한 회귀 | 대표 계정 3종(관리자·W/S·Viewer) 사내 실측과 동일 |

추가 화면 실증: V1~V5(United 주입→조회→편집 매트릭스→세트 CRUD→저장 36키).

---

## 4. MSG / LBL / MNU / BTN·API·CMBO·FE 감사

| 분류 | 신규/변경 | 근거 |
|---|---|---|
| MSG_M / LBL_M / locales / MNU_M | **0** | 신규 문구·메뉴 없음(MSG00283/00688/00096/00429 전부 기등록 재사용) |
| BTN_MPG / API_M / PROC_M | **0** | 시그니처 무변경 |
| CMBO | **0** | `DMF0044_DEPARTMENT_TEAM` 은 **DMF0044 패키지**가 등록한다(§0 선행) — 여기서 중복 등록하지 않는다 |
| FE | **21파일** | `fe/etc-sales-reports/` — §2 참조 |

---

## 5. 원복

```sql
-- SPOOL cloud_PKG_DMF0049_BODY_before_20260810.sql
-- SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049'
--   AND TYPE='PACKAGE BODY' ORDER BY LINE;
-- SPOOL OFF
```

---

## 6. 이월 (본 패키지 범위 밖)

- ⭐ **적용 후 화면 육안 확인 필수** — 특히 **Insert/Delete(C 축)**. E2E 는 이 경로가
  **실데이터를 파괴**하는 것이 확인돼(`insert_delete_safe: False`) 의도적으로 생략했다.
  DMF0049 SAVE SP 는 `dataSeq` 가 기존 값이면 `activeFlag='I'` 여도 DELETE→INSERT 경로를 탄다.
- DEPT_ID cascade 3분기(미입력 / '기타' / 부서 선택)와 82 편집 개방(`sEditMeasure`)도 육안 확인.
- 원장 데이터는 **division 40 단독**(157,842행 / `CUTOFF_TYPE='REPORT_SP_W'`) — 81·82 조회 0행은 정상.
- AUTHUNION 전사 미적용 잔여 **26 객체 + 혼재 1** — 최우선 4객체/2화면
  (`PKG_DMF0020`+`DMF0020_GET_OWNER_DATA` · `PKG_DMF0048`+`DMF0048_GET_DM_PLN_SALES_MONITORING`).
  이 4건 해소 전까지 `GET_ADMIN_GROUP` 의 `minyonglee1|ALL` 테스트 행은 **제거 불가**(load-bearing).

---

## 7. 근거 자료 (`diagnostics/`)

| 파일 | 내용 |
|---|---|
| `AUTHUNION_COVERAGE_20260809.md` | 전사 AUTHUNION 적용 현황(조건식 형태 전수 스캔) |
| `authunion_apply.py` | 적용기 — `--dump/--patch/--deploy/--verify`, 치환 건수 불일치 시 중단 |
