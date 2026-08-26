# DMF0035 SALES PLAN / BIZ PLAN — PKG 성능개선 **델타** 이관 패키지

> 생성 2026-08-21 · 사내 적용·검증 완료 / **클라우드 미적용**
> 원 패키지 `DMF0035_CLOUD_20260820` 의 **후속 델타**입니다. 전체 재적용이 아니라 **PKG BODY 2본만** 교체합니다.

## 1. 왜 델타인가 (범위)

2026-08-20~21 SALES/BIZ 튜닝으로 바뀐 것은 **PKG BODY 2본뿐**입니다.
**메타·DDL·GTT·GRANT·FE 변경 0** — 그래서 원 패키지를 다시 돌릴 필요가 없습니다.

| 파일 | 대상 | 신규 마커 |
|---|---|---|
| `A_DB/15_PKG_DMF0022_BODY.sql` (3,711행) | SALES PLAN | `[E20260820-D22PREREDUCE]` 2 · `[E20260820-D22VERPUSH]` 2 |
| `A_DB/17_PKG_DMF0051_BODY.sql` (1,810행) | BIZ PLAN | `[E20260820-D51SCALAR]` · `[D51REGROUP]` · `[D51SEMI]` · `[D51ITEMPFX]` 각 1 |
| `A_DB/90_VERIFY_PERF.sql` | 적용 검증 | P1~P6 |
| `A_DB/91_INDEX_PROPOSAL_NOT_APPLIED.sql` | ③ 인덱스 **제안만** | SALES 3 + BIZ 1 = 4건 (**적용 안 함**) |

기존 마커(`[E20260820-DS2]` 등)는 두 본 모두 **보존**되어 있습니다(P3 에서 함께 검증).

## 2. 무엇을 고쳤나 (hook #129 원순위 — ①→②→③, 힌트·optimizer 파라미터·강제 통계수집 **0건**)

### SALES PLAN (`PKG_DMF0022`)
- **④ 선행축소 2곳** — ①아이템 마스터 GTT 적재를 `SUBSTR(ITEM_ID,1,12) IN (RAW_DATA prefix 집합)` 으로 축소(243,050행 → 수백) ②사이트 GTT `WHERE 1=1` 에 `EXISTS(RAW_DATA)` 추가
  ⚠ **prefix(12자) 단위여야 함** — 소비처가 `SUBSTR(...,1,12)` 로 MAX 집계하므로 정확 ITEM_ID 축소는 그룹을 바꿔 값이 달라진다
- **② access 술어 승격 2곳** — `DM_PLN_SALES_PLAN_C` 에 division + 버전 술어 추가 → `IX_DM_PLN_SALES_PLAN_C_N3` 선두 개방
- **① 상관 스칼라: 손대지 않음** — 병목 문장 집합 안에 0건. 패키지 전체 후보 2건은 실측 0.034s/0.041s 로 병목이 아니어서 제외(#129 ⓿ "병목 아닌 곳 금지")

### BIZ PLAN (`PKG_DMF0051`)
- **① 행별 함수·상관 스칼라 3개 제거** — `FN_GET_DM_MKT_OWNER_NAME` ×2 + DEPT_ID 스칼라 → DISTINCT OWNER 선계산 + LEFT JOIN (평가 **69,579회 → 264회**)
- **② 무용 GROUP BY 제거** — 입력=출력 항등임을 실측(169,928 IN=OUT)
- **② INNER JOIN → EXISTS** — SELECT 무기여 + 조인키 유일(3,029/3,029) 실측 후 존재필터로 전환
- **④ 선행축소** — SALES 와 동일 prefix 축소(243,050 → **3,559행**)

## 3. 성적 (사내 실측 · 논리 읽기 BG 정본)

| 화면 | 케이스 | BG BEFORE → AFTER | 개선 |
|---|---|---|---|
| SALES | div40 CURRENT | 262,914 → 134,094 | −49% |
| SALES | div40 SP_W | 351,843 → 159,924 (물리 128,618 → **29,742**) | −55% / 물리 −76% |
| SALES | div82 CURRENT | 171,790 → 68,545 | −60% |
| BIZ | CURRENT | 692,912 → 192,750 | **−72%** |
| BIZ | 기간축소 | 982,878 → 223,690 | **−77%** |
| BIZ | **합계 5케이스** | 5,044,796 → **1,500,487** | **−70%** |

BIZ 문장별: 최종 동적SQL −78% · `ITEM_SINGLE_V` 388,722 → **1,884(−99.5%)** · `SITE_ITEM` −94%. SP 왕복 5.55 → **2.83초**.

> ⚠ 벽시계(elapsed)는 측정 중 타 세션 부하로 이상치가 섞였습니다. **BG/disk 를 정본**으로 보십시오.

## 4. 값 동등성 (되돌린 처방 포함)

- **SALES**: 6케이스 × rc1/rc2/rc3 = **18/18 전행 일치**(행수 2021/865/405/3310/1847/877 불변)
- **BIZ**: **10케이스 전부 PASS** — 정렬순 해시 + 멀티셋 해시 + GTT 6종 전행(서버측 해시 2시드)
- ⚠ **SALES 처방 1건 철회**: 단가표 2본에 division+기간 술어를 넣었더니 옵티마이저가 PK NL 로 전환되어 **0.331s → 3.749s 로 악화**(SQL_ID `ftz4kvgxttgk9`). 값은 같았지만 느려져 되돌렸습니다 — 근거는 `91_INDEX_PROPOSAL` ③-1/③-2 주석 참조

## 5. 적용 순서

1. **조회를 멈춘 상태**에서 적용할 것. 조회 세션이 패키지를 물고 있으면 `CREATE OR REPLACE` 가 **library cache pin 으로 무한 대기**합니다.
   물고 있으면 `DMF0035_CLOUD_20260820/A_DB/97_REDEPLOY_LOCKED.sql` 절차(배포를 먼저 대기열에 올리고 → 세션 kill)를 사용하세요.
2. `A_DB/15_PKG_DMF0022_BODY.sql` → `A_DB/17_PKG_DMF0051_BODY.sql` 순서로 실행(각 파일 말미 `SHOW ERRORS` 로 즉시 확인)
3. `A_DB/90_VERIFY_PERF.sql` 실행 — **P1 VALID / P2 0행 / P3 마커 전수 PASS / P4 = 6 / P5 행 존재**
4. 화면 1회 조회 후 `90_VERIFY_PERF.sql` **P6** 로 성적 확인

### 사내 실증값 (기대치 — 2026-08-21)
```
P1  PKG_DMF0022 PACKAGE/BODY VALID · PKG_DMF0051 PACKAGE/BODY VALID
P2  ALL_ERRORS 0
P3  D22PREREDUCE 2 · D22VERPUSH 2 · D51SCALAR 1 · D51REGROUP 1 · D51SEMI 1 · D51ITEMPFX 1 · DS2 각 1  → 전수 PASS
P4  v_measure_sheet 6
P5  권한축 PKG_DMF0022 3행 · PKG_DMF0051 2행
```

## 6. ⚠ 회귀 감시축 (P4/P5 — 반드시 확인)

- **`v_measure_sheet` 6건**: 사라지면 SALES PLAN 이 **오류 없이 조용히 0행**이 됩니다(2026-08-20 구세대 덮어쓰기 실사고 계보)
- **`SCM_ADM_USER_MNU_EDIT_AUTH_V` 조인**: 권한 뷰가 사실상 **조회 필터**라, 제거·완화되면 조회 결과가 사라집니다. 이번 튜닝에서 **원문 그대로 보존**했습니다

## 7. 한계 · 미결 (단정하지 않는 것)

1. **클라우드 개선폭 단정 불가** — 클라우드 `DM_PLN_BP_FCST_C` 는 58,335,432행으로 사내(6,768,311행)의 **8.6배**. 특히 prefix 축소 이득은 원장 품목 집합의 좁기에 비례하므로 비율이 다를 수 있습니다. 다만 세 처방 모두 **읽는 블록 수 자체를 줄이는 구조 변경**이라 방향은 공통입니다.
2. **구조로는 여기까지** — `DM_PLN_BP_FCST_C`(기간 축 인덱스 부재)·`SCM_ITEM_M`(DIVISION_ID+ITEM_ID 부재)·단가표 2본의 풀스캔은 구조 변경만으로 제거 불가. → `91_INDEX_PROPOSAL_NOT_APPLIED.sql` **제안만**, 적용하지 않았습니다. ③-3 은 `FP_MGR` 소유 공용 마스터라 **타 도메인 영향 검토 필수**.
3. **`GT_DM51_SCM_CITY` 1,283,852행(고유값 647) — 정책 판단 필요.** AS-IS 원문이 **DISTINCT 없는 1:1 변환**이라 그대로 두었습니다. dedup 하면 div 81 에서 12,665 원장행이 조인 성립해 **SUM 이 바뀝니다**(div 40 영향 0). AS-IS 파리티 유지 / 값 변경 감수 중 확정 필요.
4. **BIZ 값 등가는 div 40 에서만 실증** — div 81/82 는 조회 기간에 원장 데이터가 없어 rc1=0(0행 회귀검사만).
5. 권한 뷰가 행을 5배 증식시키는 패턴이 **PKG_DMF0022/0035 에도 동일**하게 있습니다(값은 정상 — 뷰가 다시 접음). 권한축 무수정 지시에 따라 보존.

## 8. 원복

두 본 모두 적용 전 라이브 백업이 있습니다.
- `_artifacts/_apply_corporate/DMF0022_PERF_20260820/00_BACKUP_PKG_DMF0022_BODY.sql`
- `_artifacts/_apply_corporate/DMF0051_PERF_20260820/00_BACKUP_PKG_DMF0051_BODY.sql`
