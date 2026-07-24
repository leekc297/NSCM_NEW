# DMF0082 (Fcst&Price) — 클라우드 이관 패키지 (20260722_1050)

> 페이지: `features/demand/src/pages/forecast-price/` · 실행 계정 = SCM_MGR · 모든 SQL 멱등(재실행 안전)
>
> ⭐ 정책 (2026-07-22 사용자 확정):
> ① **Router 관련 코드 이관 없음** — 화면 연결은 §3 메뉴 Table `ROUTE_PATH` 등록으로 수행.
> ② **PROC_M 은 자동 실행 제외** — `_ADD_PROC_M_DMF0082.sql` (§4 선별 적용).
> ③ **SHEET_COLUMNS/MEASURE 는 전체 주석** — `_COMMENTED_sheet_columns_measure_DMF0082.sql` 그대로 실행 시 아무것도 이관 안 됨 (§5 발췌 실행).



## 1. 폴더 구조

```
DMF0082_20260722_1050/
├── README.md                  ← 본 문서
├── fe/features/demand/src/pages/forecast-price/     ← 화면 FE 전체 (그대로 복사)
├── sql/
│   ├── 01_~NN_*.sql                          ← 순번대로 실행
│   ├── 99_DMF0082_route_path.sql               ← ⭐ 메뉴 ROUTE_PATH 등록 (순번 '마지막' — §3)
│   ├── _ADD_PROC_M_DMF0082.sql                 ← ⚠ 자동 실행 금지 — §4
│   └── _COMMENTED_sheet_columns_measure_DMF0082.sql  ← 전체 주석 — §5
├── sp/                        ← GTT DDL + PKG(SPEC→BODY) + standalone SP
├── fe-common/                 ← 공통 FE (6화면 패키지 동일본 — 1회만 반영, §6)
└── fe-fix_typecheck/          ← 클라우드 type-check 3오류 break-fix (기적용 시 skip, §7)
```

## 2. 적용 순서

```
# Step 1. GTT/TYPE DDL — PKG 컴파일 '이전' 필수 (누락 = ORA-00942)
sqlplus SCM_MGR/**@{dsn} @sp/00_GTT_DDL_DMF0082.sql      # 기존재 GTT 는 -955 자동 skip

# Step 2. PKG(SPEC → BODY) → standalone SP 전량
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0082_SPEC.sql
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0082_BODY.sql
#   이후 sp/DMF0082_*.sql 전부 실행. INVALID 0 확인:
#   SELECT object_name, status FROM all_objects
#    WHERE (object_name LIKE 'DMF0082%' OR object_name='PKG_DMF0082') AND status='INVALID';

# Step 3. 메타 SQL — 순번(01→99)대로만 (_ADD_/_COMMENTED_ 는 실행 대상 아님)
#   ⭐ 99_DMF0082_route_path.sql 이 메뉴 ROUTE_PATH 등록 수행 — 반드시 순번 '마지막' (§3)
# Step 4. PROC_M 선별 적용 — §4
# Step 5. (선택) SHEET_COLUMNS/MEASURE 발췌 — §5
# Step 6. FE 복사
robocopy fe\features {repo}\nscm-fe\features /E
robocopy fe-common {repo}\nscm-fe /E          # 6화면 중 1회만 (§6)
# Step 7. 빌드 확인: pnpm run type-check → lint → build
```

## 3. ⭐ 메뉴 Table `ROUTE_PATH` 등록 (Router 코드 이관 대체)

클라우드 FE 는 `SCM_ADM_MNU_M.ROUTE_PATH` 로 화면을 연결합니다 (viewRegistry 가 `features/*/src/pages/*` 자동 수집 후 매칭).
**규약 = `<features 도메인>/<페이지 폴더명>` 2단** — 메뉴 트리 계층 경로(3단) 아님.

⭐ **실행 파일 = `sql/99_DMF0082_route_path.sql`** (컬럼 부재 시 ALTER ADD 자동 수행 + UPDATE + 검증 — 멱등).
순번 실행에 포함되지만 **반드시 마지막(99)** 이어야 합니다 — 01/P1 안의 구(3단) ROUTE_PATH 재파생 UPDATE 를 2단 값으로 덮기 때문.

수행 내용 (수동 실행 시 동일):
```sql
-- 컬럼이 없으면 1회: ALTER TABLE SCM_MGR.SCM_ADM_MNU_M ADD (ROUTE_PATH VARCHAR2(4000));
UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/forecast-price' WHERE MNU_ID = 'DMF0082';
COMMIT;
-- 검증
SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0082';
```

- ROUTE_PATH 미등록 시 폴백: `MNU_URL` 마지막 세그먼트 = 페이지 폴더명이면 자동 매칭.

## 4. ⭐ PROC_M 선별 적용 — `_ADD_PROC_M_DMF0082.sql`

클라우드가 PROC_M 을 자체 관리 중일 수 있어 자동 실행에서 제외했습니다 (파일명 비순번).

1. 현황 확인:
   ```sql
   SELECT PROC_NM, COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M
    WHERE PROC_NM LIKE '%DMF0082%' GROUP BY PROC_NM ORDER BY 1;
   ```
2. 파일 내 PROC 목록과 대조 — **없는 PROC / 파라미터 수가 다른 PROC 만** 해당 블록(DELETE+INSERT 세트)을 발췌 실행.
   전체 실행도 멱등이나, 클라우드가 임의 수정한 PROC_M 이 있으면 덮어쓰므로 대조 후 결정.
3. ⚠ `SCM_ADM_PROC_M` = **9컬럼 (USE_YN 없음)** / COL_NM=camelCase / SORT_ORD=DB POSITION.
4. 공유 PROC(클라우드 기존재 가정 — 부재 시 별도 확보): `DMF0002_GET_TITLESET_POPUP` / `SCM0002_SET_TITLESET_POPUP` / `PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE` / `PR_GET_DAY_RANGE`.

## 5. ⭐ SHEET_COLUMNS / SHEET_MEASURE 발췌 실행 — `_COMMENTED_sheet_columns_measure_DMF0082.sql`

**전체 블록 주석(`/* ... */`) 상태** — 그대로 실행하면 아무것도 이관되지 않습니다 (admin UI Category Setup 관리분 보호 정책).

- 전체 적용: 파일의 `/*` 와 `*/` 두 줄만 제거 후 실행 (멱등 MERGE + COMMIT).
- 부분 적용: 필요한 `MERGE INTO ... ;` 블록만 복사해 실행 (블록 독립 — 안전).
- 행수: SHEET_COLUMNS + SHEET_MEASURE = **69 + 14**.
- ⚠ 미적용 전제 = 클라우드에 DMF0082 의 SHEET 메타가 이미 존재해야 그리드가 뜸. 0건이면 전체 적용 필요:
  ```sql
  SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
   WHERE PROGRAM_ID = 'DMF0082' GROUP BY SHEET_NAME;
  ```

## 6. fe-common (6화면 패키지 동일본 — 1회만 반영)

| 파일 | 내용 | 반영 방법 |
|---|---|---|
| `configs/types/procedures.d.ts` | 6화면 블록 포함 로컬 최신본 | ⚠ 통째 교체 금지 — **필요 화면 블록만 병합** |
| `features/master/.../columnSettingModal/*` · `packages/shared/.../columnSelectDualList/*` | leftTitle/rightTitle optional 확장 | 통째 교체 안전 (하위호환) |
| `features/master/.../projectByDivisionModal/*` | `etc` 파라미터 확장 (미전달='N') | 통째 교체 안전 |
| `packages/shared/src/lib/bucket-distribution.ts` | 배분 공통 룰1/룰2 순수함수 | 신규 파일 추가 |

Router 계열(Router.tsx/useMDIStore/viewRegistry/RouterSync/route-paths/menu.ts)은 정책 ① 에 따라 **포함하지 않음**.

## 7. fe-fix_typecheck (클라우드 type-check 3오류 break-fix — 기적용 시 skip)

이전 반입으로 클라우드측 파일이 구판으로 덮인 경우의 복구본 — **동일 경로에 복사**:

| 오류 | fix 파일 |
|---|---|
| `'ROUTE_PATHS'` export 없음 | `packages/foundation/src/constants/route-paths.ts` |
| `'setActiveByTabId'` 없음 | `apps/web/src/mdi/useMDIStore.ts` |
| `'fcstNPrice_40'` 제약 위반 | `apps/web/src/mdi/useMDIStore.test.ts` |

+ `packages/foundation/src/constants/index.ts` 에 `export * from './route-paths';` 라인이 없으면 추가 (index.ts 는 통째 제공하지 않음 — 클라우드 자체 export 보존).

## 8. 화면 특이사항

- ⭐⭐ **W/M 분기 복원 + 정렬 파리티 (2026-07-22 패치 — 사내 적용·실측 검증 완료)**: PKG `P_DMF0082_GET_MAIN_DATA` 가 ①주(W_)/월(M_) 동적컬럼 데이터 공백(집계 분기 미승계) ②measure-major 정렬(SORT_KEY 오변환 — AS-IS=999 상수) 결함 보유했음 → 본 패키지의 `PKG_DMF0082_BODY.sql`(패치본)+`00_GTT_DDL_DMF0082.sql`(MF_SP +YYYYMM/YYYYMMWW/WEEK_END_YN/MONTH_END_YN 4컬럼) 반영. **클라우드 적용 순서: `00A_GTT_REBUILD` → `00_GTT_DDL` 재실행 → `PKG_DMF0082_BODY` 재컴파일**. 정렬이 여전히 흩어지면 titleset 재시드: `DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082'; COMMIT;` (다음 조회 시 설계값 자동 재시드).
- ⚠⚠ **클라우드 조회 ORA-01438 (-9994) break-fix**: 클라우드에 구판 GTT(QTY NUMBER(20,10))가 기존재하면 -955 skip 으로 교정본(30,10)이 반영되지 않음 → `sp/00A_GTT_REBUILD_DMF0082.sql` 실행(전체 DROP) 후 `00_GTT_DDL_DMF0082.sql` 재실행 + INVALID 재컴파일. ORA-14452 시 BE 재기동 후 재시도.
- 배분 룰 5갭 교정본 포함 (달력 기반 월→주 배분 / SALES_BUCKET + SUN-first 요일 / 월요일 폴백 / 끝자리± 마지막 주 / non-40 BUCKET 존중).
- GTT 다수 사용 화면 — `00_GTT_DDL_DMF0082.sql` 선행 필수.

## 9. 검증 (배포 후)

1. 메뉴 클릭 → 화면 오픈 (미해석 시 §3 ROUTE_PATH 재확인).
2. 조회 → 그리드 컬럼/데이터 (컬럼 없으면 §5 SHEET 메타 0건 — 전체 적용).
3. 저장 왕복 1건 (-9994 = PROC_M 미적용(§4) / "권한 없음" = 권한 SQL 미적용).
4. `SCM_ADM_USER_MNU_EDIT_AUTH_V` 에 DMF0082 행 존재 확인 (0건 = 조회 빈 결과 가능).
