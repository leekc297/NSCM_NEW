# 클라우드 이관 통합 패키지 — 6화면 (2026-07-22)

> DMF0003(MKT FCST) · DMF0082(Fcst&Price) · DMF0021(Sales Plan) · DMF0042(Business Plan) · DMF0044(Sales Reports) · DMF0049(Etc Sales Reports)
> 본 README **하나로 전체 적용 가이드**. 화면별 폴더 = `fe/` + `sql/` + `sp/`, 공통 = `fe-common/`.
>
> ⭐ 정책 (2026-07-22 사용자 확정):
> ① **Router 관련 코드 이관 없음** — 화면 연결은 §3 의 메뉴 Table `ROUTE_PATH` 컬럼 등록으로 수행 (클라우드 viewRegistry 자동 해석).
> ② **PROC_M(프로시저 메타)은 자동 실행 제외** — `_ADD_PROC_M_*.sql` 별도 파일. §4 가이드에 따라 선별 적용.
> ③ **SHEET_COLUMNS/MEASURE 는 전체 주석 상태** — `_COMMENTED_sheet_columns_measure_*.sql`. 그대로 실행 시 아무것도 이관되지 않음. §5 발췌 실행법.

---

## 1. 폴더 구조

```
CLOUD_6SCREENS_20260722_1002/
├── README.md                       ← 본 문서 (유일한 가이드)
├── fe-common/                      ← 공통 FE (Router 계열 제외 — §6)
│   ├── configs/types/procedures.d.ts               (6화면 블록 포함 — 블록 병합 권장)
│   ├── features/master/.../columnSettingModal/     (leftTitle 확장 — 하위호환)
│   ├── features/master/.../projectByDivisionModal/ (etc 파라미터 확장 — 하위호환, DMF0049)
│   ├── packages/shared/.../columnSelectDualList/   (leftTitle 확장 — 하위호환)
│   └── packages/shared/src/lib/bucket-distribution.ts (배분 공통 유틸 — DMF0021)
└── DMF00xx/  (화면 6개 각각)
    ├── fe/features/demand/src/pages/<화면폴더>/    ← 화면 전체 (그대로 복사)
    ├── sql/
    │   ├── 01_~NN_*.sql                            ← 순번대로 실행 (멱등 MERGE)
    │   ├── _ADD_PROC_M_<ID>.sql                    ← ⚠ 자동 실행 금지 — §4
    │   └── _COMMENTED_sheet_columns_measure_<ID>.sql ← 전체 주석 — §5
    └── sp/
        ├── 00_GTT_DDL_<ID>.sql (+DMF0003 은 00_TYPES_DDL)  ← 최우선 실행
        ├── PKG_<ID>_SPEC.sql / PKG_<ID>_BODY.sql
        └── <ID>_*.sql (standalone)
```

---

## 2. 화면별 적용 순서 (공통 — 6화면 동일 절차)

> 실행 계정 = SCM_MGR. 순서 엄수. 전부 멱등(재실행 안전).

```
# ── Step 1. GTT/TYPE DDL — PKG 컴파일 '이전' 필수 (누락 = ORA-00942) ──
sqlplus SCM_MGR/**@{dsn} @sp/00_TYPES_DDL_DMF0003.sql     # DMF0003 만 존재 (TYPE 4종)
sqlplus SCM_MGR/**@{dsn} @sp/00_GTT_DDL_<ID>.sql          # 기존재 GTT 는 ORA-00955 자동 skip

# ── Step 2. PKG (SPEC → BODY) → standalone SP 전량 ──
sqlplus SCM_MGR/**@{dsn} @sp/PKG_<ID>_SPEC.sql
sqlplus SCM_MGR/**@{dsn} @sp/PKG_<ID>_BODY.sql
for f in sp/<ID>_*.sql; do sqlplus SCM_MGR/**@{dsn} @$f; done
# INVALID 0 확인:
#   SELECT object_name, status FROM all_objects
#    WHERE (object_name LIKE '<ID>%' OR object_name='PKG_<ID>') AND status='INVALID';

# ── Step 3. 메타 SQL — 순번(01→NN)대로만 실행 (_ADD_/_COMMENTED_ 는 자동 실행 대상 아님) ──
for n in sql/0*.sql sql/1*.sql; do sqlplus SCM_MGR/**@{dsn} @$n; done

# ── Step 4. PROC_M 선별 적용 — §4 가이드 ──
# ── Step 5. (선택) SHEET_COLUMNS/MEASURE — §5 가이드 ──
# ── Step 6. ROUTE_PATH 등록 — §3 가이드 (메타 적용 '마지막'에 실행 — 01/P1 의 구 ROUTE_PATH 값을 덮음) ──

# ── Step 7. FE 복사 ──
robocopy DMF00xx\fe\features {repo}\nscm-fe\features /E
robocopy fe-common {repo}\nscm-fe /E     # §6 주의 확인 후 1회만

# ── Step 8. 빌드 + 브라우저 확인 ──
pnpm type-check && pnpm lint && pnpm build
```

**적용 의존 순서 (화면 간)**: **DMF0044 → DMF0049** 순서 필수 (DMF0049 의 United 버전 팝업이 DMF0044 SP 5종·PROC_M 을 공유).
나머지 화면은 순서 무관.

---

## 3. ⭐ 메뉴 Table `ROUTE_PATH` 등록 가이드 (Router 코드 이관 대체)

클라우드 FE 의 화면 연결은 **`SCM_ADM_MNU_M.ROUTE_PATH` 컬럼**으로 동작합니다 — Router/viewRegistry 코드 수정이 필요 없습니다.

**규약**: `ROUTE_PATH = '<features 도메인 폴더>/<페이지 폴더명>'` **2단** (클라우드 viewRegistry 해석 규약 —
`features/<도메인>/src/pages/<페이지폴더>` 를 빌드타임 자동 수집하고 ROUTE_PATH 로 매칭).
⚠ 메뉴 트리 계층 경로(예: `demand/demand-plan/...` 3단)가 **아님** — 반드시 아래 2단 값 사용.

⭐ 2026-07-22 갱신: 각 화면 `sql/99_<ID>_route_path.sql` 로도 제공됩니다 (컬럼 부재 시 ALTER 자동 + UPDATE + 검증, 멱등)
— 순번 실행(§2 Step 3)에 포함되며 99 라 자동으로 마지막에 실행됩니다. 아래는 일괄 수동 실행용:

```sql
-- 컬럼이 없으면 1회: ALTER TABLE SCM_MGR.SCM_ADM_MNU_M ADD (ROUTE_PATH VARCHAR2(4000));
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/mkt-fcst'          WHERE MNU_ID = 'DMF0003';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/forecast-price'    WHERE MNU_ID = 'DMF0082';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/sales-plan'        WHERE MNU_ID = 'DMF0021';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/business-plan'     WHERE MNU_ID = 'DMF0042';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/sales-reports'     WHERE MNU_ID = 'DMF0044';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/etc-sales-reports' WHERE MNU_ID = 'DMF0049';
COMMIT;

-- 검증
SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0003','DMF0082','DMF0021','DMF0042','DMF0044','DMF0049');
```

- ROUTE_PATH 미등록(또는 미배포 환경) 시 폴백: `MNU_URL` **마지막 세그먼트 = 페이지 폴더명**이면 자동 매칭.
  본 패키지의 01/P1 SQL 이 MNU_URL 을 폴더명과 동일한 kebab 으로 정렬해 둠(business-plan / sales-reports / etc-sales-reports 등).
- ⚠ **DMF0003 예외**: MNU_URL='mkt_forecast'(AS-IS 표기) ↔ 폴더 'mkt-fcst' 불일치 — 폴백이 안 됨.
  **ROUTE_PATH 등록이 필수**이거나, viewRegistry 의 `URL_ALIASES` 에 `mkt_forecast: 'mkt-fcst'` 1줄이 있어야 함.
- 01/P1 SQL 안에 구(3단) ROUTE_PATH 재파생 UPDATE 가 포함된 화면이 있음 — 반드시 **본 절을 마지막에 실행**해 2단 값으로 확정.

---

## 4. ⭐ PROC_M(프로시저 메타) 선별 적용 가이드 — `_ADD_PROC_M_<ID>.sql`

프로시저 파라미터 메타는 클라우드에서 자체 관리 중일 수 있어 **자동 실행에서 제외**했습니다(파일명이 순번이 아님).

**적용 절차**:
1. 클라우드 현황 확인:
   ```sql
   SELECT PROC_NM, COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M
    WHERE PROC_NM LIKE '%<ID>%' GROUP BY PROC_NM ORDER BY 1;
   ```
2. `_ADD_PROC_M_<ID>.sql` 내부의 PROC 목록과 대조 — **클라우드에 없는 PROC / 파라미터 수가 다른 PROC 만** 해당 블록(DELETE+INSERT 세트)을 발췌해 실행.
   전체 실행도 가능(각 PROC 를 DELETE 후 재등록하는 멱등 구조)하나, 클라우드가 임의 수정한 PROC_M 이 있으면 덮어쓰므로 대조 후 결정.
3. ⚠ 참고: `SCM_ADM_PROC_M` 은 **9컬럼**(USE_YN 없음). COL_NM=camelCase, SORT_ORD=DB POSITION.
4. ⚠⚠ **DMF0049 SAVE(36 IN)** 는 파라미터 순서가 **DB POSITION 실측 정본**
   (…31 cellModelInfo, 32 cellModel, 33 measure, 34 yyyymmdd, 35 qty, 36 sesUserId — 분석 문서의 다른 순서 표기는 오기로 확정).
   **임의 재정렬 절대 금지** — 값이 전부 밀리는 치명 결함이 됩니다.
5. 공유 PROC(재사용 — 별도 등록 불필요, 클라우드 기존재 가정): `DMF0002_GET_TITLESET_POPUP` /
   `SCM0002_SET_TITLESET_POPUP` / `PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE` / `PR_GET_DAY_RANGE`.
   부재 시 별도 확보 필요(본 패키지 범위 밖 공유 자산).

---

## 5. ⭐ SHEET_COLUMNS / SHEET_MEASURE 발췌 실행 가이드 — `_COMMENTED_sheet_columns_measure_<ID>.sql`

6화면 전부 **전체 블록 주석(`/* ... */`) 상태**로 제공 — 그대로 실행하면 아무것도 이관되지 않습니다.
(클라우드 UI Category Setup(admin)에서 관리 중인 컬럼 메타를 일괄 덮어쓰지 않기 위한 사용자 통제 정책.)

**적용을 원할 때**:
- 전체 적용: 파일 상단 `/*` 와 하단 `*/` 두 줄만 제거 후 실행 (멱등 MERGE + COMMIT 포함).
- 부분 적용: 필요한 컬럼의 `MERGE INTO ... ;` 블록만 복사해 실행 (블록 단위 독립 — 안전).
- 행수: DMF0003=96+47 / DMF0082=(파일 내 명기) / DMF0021=(파일 내 명기) / DMF0042=63+9 / DMF0044=58+18 / DMF0049=42+3.
- ⚠ 미적용 시 전제: 클라우드에 해당 PROGRAM_ID 의 SHEET_COLUMNS/MEASURE 가 이미 존재해야 그리드 컬럼이 표시됩니다.
  0건이면 화면 그리드가 비므로, 그 경우 본 파일 전체 적용이 필요합니다:
  ```sql
  SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
   WHERE PROGRAM_ID IN ('DMF0003','DMF0082','DMF0021','DMF0042','DMF0044','DMF0049')
   GROUP BY PROGRAM_ID, SHEET_NAME;
  ```
- ⚠ DMF0003 `10_..._visible_fix.sql`(순번 실행분)은 SHEET_COLUMNS 3행 VISIBLE 정정 UPDATE 입니다 —
  컬럼 메타 통제를 원하면 이 파일도 실행 전 검토하세요. DMF0042 `10_..._P7...` 의 SHEET_COLUMNS 1행
  UPDATE(FPComboBox 배선)는 FE 콤보와 세트 — 실행 권장.

---

## 6. fe-common 반영 주의 (Router 계열 제외됨)

| 파일 | 내용 | 반영 방법 |
|---|---|---|
| `configs/types/procedures.d.ts` | 6화면 블록 포함 로컬 최신본 | ⚠ 클라우드 자체 화면 타입 보유 시 통째 교체 금지 — **DMF0003/0021/0042/0044/0082/0049 블록만 병합** |
| `columnSettingModal/*` · `columnSelectDualList/*` | leftTitle/rightTitle optional 확장 (하위호환) | 통째 교체 안전 |
| `projectByDivisionModal/*` | `etc` 파라미터 확장 (미전달='N' 하위호환) — DMF0049 ETC='Y' 호출 | 통째 교체 안전 |
| `bucket-distribution.ts` | 배분 공통 룰1/룰2 순수함수 — DMF0021 저장이 사용 | 신규 파일 추가 |

**포함하지 않은 것 (Router 관련 — 정책 ①)**: Router.tsx / useMDIStore.ts / viewRegistry.tsx / RouterSync / route-paths.ts / menu.ts.
화면 연결은 §3 ROUTE_PATH 등록만으로 완성됩니다 (클라우드 viewRegistry 가 `features/*/src/pages/*` 를 자동 수집).

---

## 7. 화면별 특이사항 (요약)

| 화면 | 특이사항 |
|---|---|
| **DMF0003** (mkt-fcst) | 저장 SP = **PKG 병합 3점 정합**(_ADD_PROC_M 의 PKG 한정명 + 08 API 전환 + PKG BODY SAVE 멤버) — 한쪽만 적용 시 -9994. `00_TYPES_DDL` 4종 선행. ⚠ ROUTE_PATH 필수(§3 — MNU_URL 'mkt_forecast' 폴백 불가) |
| **DMF0082** (forecast-price) | 배분 5갭 교정본(월요일 폴백/끝자리±/non-40 BUCKET 존중). GTT 37종 |
| **DMF0021** (sales-plan) | ⚠ 저장 = **버킷 태그 원문 전송**(M_yyyymm/W_yyyymmww — SP 가 SUBSTR 파싱. 날짜 변환 금지) + 월→주 배분(`bucket-distribution` 필요 — fe-common). 40+ETC=월말일 단일 |
| **DMF0042** (business-plan) | sql 01~03 = SP 패치 3건(P0a/b/c — SP 배포 후에도 멱등 안전). 06 = TITLESET rename / 10 = CELL_PROD_SITE 콤보(FE 와 세트) |
| **DMF0044** (sales-reports) | sql 01 에 **MSG00681~688 신규 8종** 포함(선행 필수 — 0049 도 사용). Data Type 저장 이원화(SAVE/_C_CF) |
| **DMF0049** (etc-sales-reports) | ⚠ **DMF0044 선적용 필수**(United 팝업 SP/PROC 공유). SAVE 36 IN = DB POSITION 정본(§4-4). MSG 신규 0 |

## 8. 공통 검증 (배포 후)
1. 메뉴 클릭 → 6화면 오픈 (ROUTE_PATH 해석 — 미해석 시 §3 재확인).
2. 각 화면 조회 → 그리드 컬럼/데이터 (컬럼 없으면 §5 SHEET 미존재 — 발췌 적용).
3. 저장 왕복 1건씩 (-9994 = PROC_M 미적용(§4) / "권한 없음" = 권한 SQL(순번 내) 미적용).
4. `SCM_ADM_USER_MNU_EDIT_AUTH_V` 에 DMF0044/0049 행 존재 확인 (0건 = 조회 빈 결과).

---

## 9. ⭐ 클라우드 type-check 3오류 조치 — `fe-fix_typecheck/` (2026-07-22 추가)

클라우드 `type-check` 에서 아래 3오류가 발생한 경우의 break-fix 입니다.
원인은 **이전 패키지 반입 시 클라우드측 3파일이 구판으로 덮이거나 소실**된 것 — 본 폴더 파일을 **동일 경로에 그대로 복사**하면 해소됩니다 (로컬 `apps/web` tsc 0 오류 검증 완료).

| 클라우드 오류 | 원인 | fix 파일 (→ 동일 경로 복사) |
|---|---|---|
| `Router.tsx: '@foundation/constants' has no exported member 'ROUTE_PATHS'` | foundation 에서 `route-paths.ts` 소실 (클라우드 Router/useMDIStore 는 참조 유지) | `packages/foundation/src/constants/route-paths.ts` |
| `RouterSync.tsx: 'setActiveByTabId' does not exist` | `useMDIStore.ts` 가 구판으로 덮여 `setActiveByTabId` 액션 소실 | `apps/web/src/mdi/useMDIStore.ts` |
| `useMDIStore.test.ts: '"fcstNPrice_40"' does not satisfy …` | DMF0082 시트 개명(`FcstNPrice`, 2026-07-13 AS-IS 정본) 이 procedures.d.ts 에 반영됐으나 테스트 파일은 구키 | `apps/web/src/mdi/useMDIStore.test.ts` |

**추가 수작업 1건**: `packages/foundation/src/constants/index.ts` 에 아래 barrel 라인이 없으면 **추가** (index.ts 는 클라우드 자체 export 가 있을 수 있어 파일 통째 제공하지 않음):

```ts
export * from './route-paths';
```

> 참고: `route-paths.ts` 는 §6 의 "Router 계열 제외" 정책 예외가 아니라 **클라우드가 이미 참조 중인 파일의 복구**입니다 (신규 이관 아님).
> 적용 후 `pnpm run type-check` 재실행 → `@web` 포함 11 패키지 통과 확인.
