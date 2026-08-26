# DMF0035 (Demand Plan Waterfall) 클라우드 이관 패키지 — 2026-08-20 취합

> **상태: 취합 완료 / 클라우드 미적용.** 본 화면의 **첫 클라우드 이관 패키지**다(직전 패키지 없음).
> DB 원문은 전부 **사내 라이브 신선 덤프**(`ALL_SOURCE`·원장 SELECT, 2026-08-20 —
> 누적 패치 파일 조합 아님). 축 확정은 **딕셔너리 기계 전수 스윕**으로만 수행했다
> (손나열 금지 — 2026-08-14 BTN 축 조용한 스킵 사고 계보).
>
> ⛔ 본 패키지 취합 과정에서 사내/클라우드 DB 에 실행한 것은 **SELECT 뿐**이다. DDL/DML 0건.

> ### ⚠️ 2026-08-20 (2차) 정정 — `SCM_ADM_PROC_M` 축 누락
>
> 사용자 신고: 클라우드 실측에서 **8시트 중 6시트가 `SCM_ADM_PROC_M` 0행** → **PLS-00306**
> ("잘못된 개수 또는 유형의 인수"). generic call-proc 은 `SCM_ADM_PROC_M` 을 읽어
> 인자 바인딩 목록을 만들기 때문에, PKG 가 VALID 여도 이 축이 비면 조회가 즉사한다.
>
> **근본원인**: `20_MENU_META_SYNC.sql` 의 MERGE 총 **63건** = `MNU_M` 1 + `PROGRAM` 1 +
> `API_M` 8 + `MNU_BTN_MPG_M` 8 + `USER_GR_MNU_MPG_M` 5 + `USER_GR_MNU_BTN_MPG_M` 40 = **정확히 63**.
> 즉 잔여분·0행 축이 아니라 **`SCM_ADM_PROC_M` 이 들어갈 자리가 처음부터 없었다** —
> 딕셔너리 기계 전수 스윕의 **대상 테이블 목록 자체에서 축이 빠진 것**이다.
> 스윕이 `PROGRAM_ID/MENU_ID/MNU_ID/...` 컬럼 보유 테이블을 축으로 잡았는데
> `SCM_ADM_PROC_M` 은 화면 ID 컬럼이 없고 **`PROC_NM` 으로만 연결**되는 축이라 필터에 걸리지 않았다
> (2026-08-14 BTN 축 조용한 스킵 사고와 동형 — 축 부재는 0행과 구분되지 않는다).
>
> **정정**: `A_DB/24_PROC_M_SYNC.sql` 신설(**80행**) + `A_DB/90_VERIFY.sql` **V10** 신설
> (배선 역추적 적출 — `MNU_BTN_MPG_M ⋈ API_M` 로 전 시트 호출 SP 를 뽑아
> `PROC_M_CNT` vs `ALL_ARGUMENTS ARG_CNT` 대조. **정상 = 0행**).
> 이후 화면 이관 패키지는 **PROC_M 을 상시 축으로** 포함해야 한다.

---

## 1. 이 화면의 실체

**TO-BE DMF0035 = AS-IS 3 WATERFALL 통합 단일 UI** (1차 = 조회 전용 리포트).

| GUBUN | AS-IS 원본 | 메인 SP | TITLE SP | Version 팝업 SP |
|---|---|---|---|---|
| MKT_FCST (초기값) | DMF0035 MKT FCST Waterfall | `PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL` | `PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE` | `PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP` (`MF_SF` 축) |
| SALES_PLAN | DMF0022 Sales Plan Waterfall | `PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` | `PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE` | `DMF0073_GET_VERSION_SALESPRICE` (9-arg 공유) |
| BIZ_PLAN | DMF0051 Biz Plan Waterfall | `PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL` | `PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE` | `PKG_SCM0002...WATERFALLPOPUP` (`BP` 축) |

- 메뉴: `SCM_ADM_MNU_M.MNU_ID = 'DMF0035'` / `UPPR_MNU_ID='Demand_Waterfall'` /
  `MNU_MSG_ID='MNU00691'` / **`ROUTE_PATH='report/demand-plan-waterfall'`**
- FE 코드 위치 = `nscm-fe/features/report/src/pages/demand-plan-waterfall/`
  → 메뉴 트리(Demand)와 **의도적으로 상이**하다. `viewRegistry` glob 키는 ROUTE_PATH 기준
  (`features/*/src/pages/*/index.ts` → `'report/demand-plan-waterfall'`)이므로 **개명 금지**.
- 그리드 = NSCM 최초 **Wijmo OLAP PivotGrid** 적용 (`@shared` 공용 `OlapPivotGrid`).

---

## 2. ⭐ 2026-08-20 당일 변경분 (반드시 포함)

| # | 변경 | 담긴 파일 | 검증 마커 |
|---|---|---|---|
| 1 | **PKG_DMF0035 조회 튜닝** — `GT_DM35_SCP_ITEM_INFO` 적재문의 행별 상관 스칼라 2분기를 선계산 LEFT JOIN 으로 치환. MKT GET **141s → 4.2s** | `A_DB/13_PKG_DMF0035_BODY.sql` | `E20260820-WFITEMPERF` × **2** |
| 2 | **PKG_DMF0022 구세대 회귀 정정** — 08-10 덮어쓰기로 소실된 08-06 정본 재적용. 없으면 **SALES PLAN 0행 재발** | `A_DB/15_PKG_DMF0022_BODY.sql` | `V_MEASURE_SHEET` × **6** |
| 3 | **FE 공용 `OlapPivotGrid.autoFitColumns` prop 신설** (컬럼 폭 자동 최적화 — 셀 2행 줄바꿈 제거) + DMF0035 Grid 에서 사용 | `B_FE/shared-olap-pivot-grid/OlapPivotGrid.tsx`, `B_FE/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx` | `autoFitColumns` |
| 4 | **PKG_DMF0035 DS2 방어** — GTT 무통계로 카디널리티 1 추정되는 것을 막는 세션 설정 1줄 | `A_DB/13_PKG_DMF0035_BODY.sql` | `E20260820-DS2` × **1** |
| 5 | ⭐ **PKG_DMF0035 2차 튜닝 (VERPUSH)** — `GT_DM35_T_LAST_SETUP_C` 적재문 **2본 × 원천표 3분기 = 6곳** 에 버전 술어를 UNION ALL 분기 **안으로** push. 버전 조건이 표 접근 **이후** outer JOIN 으로만 걸려 access predicate 가 `DIVISION_ID` 하나뿐이던 것을, PK 2번째 컬럼 `VERSION_NO` 까지 승격시켜 rowid 개별 fetch(`cell single block read`)를 줄인다 | `A_DB/13_PKG_DMF0035_BODY.sql` | `E20260820-VERPUSH` × **6** |

> #2 백업(사내 적용 직전 원문) = `_artifacts/_apply_corporate/DMF0022_REAPPLY_20260820/PKG_DMF0022_BODY_BACKUP_BEFORE_20260820.sql`
> #1 작업 아티팩트 = `_artifacts/_apply_corporate/DMF0035_TUNING_20260820/`
> #4 작업 아티팩트 = `_artifacts/_apply_corporate/DMF0035_DS2_20260820/`
> #5 작업 아티팩트 = `_artifacts/_apply_corporate/DMF0035_VERPUSH_20260820/` (백업 `00_BACKUP_PKG_DMF0035_BODY.sql`)
>
> **#5 등가성**: 기존 outer `JOIN SCM_MGR.GT_DM35_VERSION C ON A.VERSION_NO = C.VERSION_NO` 가 이미 동일 집합으로
> 제한하므로 추가 술어는 **조인이 어차피 제거할 행만** 제거한다 → 결과 집합 불변. `IN` 은 semi-join 이라 GTT 에
> 중복 `VERSION_NO` 가 있어도 행이 늘지 않고, 바깥은 `GROUP BY` + `MAX` 라 영향 없음.
> **#5 실증(사내)**: 5 케이스(CURRENT/MF div40/MF div81/MF 다중/SF div81) × rc1~rc3 **전행 완전 일치**
> (rc1 775 / 709 / 470 / 1,418 / 434), 독립 재현 1회 추가 PASS. 대상 문장 V$SQL 귀속 **3.41s → 1.62s/exec**,
> `ROWS_PROCESSED` 2,968 동일.

---

## 3. 파일 구성 / 적용 순서

```
00_CLOUD_PRECHECK.sql              C1 PKG·마커 기준선 / C2 GTT 구조 대조 / C3 GTT IDX / C4 ⚠공유 CMBO diff
                                   / C5 LOOKUP 21종 / C6 ⚠공유 시트 영향범위 / C7 메타 축 / C8 GRANT·시노님 / C9 MSG

A_DB/01_DDL_GTT.sql            1,002줄  GTT 49본 멱등 생성 (기존재 -955 skip)
A_DB/02_DDL_GTT_INDEX.sql         12줄  GTT 인덱스 2본 (2026-08-06 PERF)
A_DB/10_PKG_SCM0002_SPEC.sql     252줄  ⚠ 공유 PKG — 전체 원문
A_DB/11_PKG_SCM0002_BODY.sql   3,920줄  ⚠ 공유 PKG — 전체 원문 (부분 발췌 금지)
A_DB/12_PKG_DMF0035_SPEC.sql      57줄
A_DB/13_PKG_DMF0035_BODY.sql   3,816줄  ⭐ WFITEMPERF 튜닝 포함
A_DB/14_PKG_DMF0022_SPEC.sql      60줄
A_DB/15_PKG_DMF0022_BODY.sql   3,450줄  ⭐ 08-06 정본 재적용분
A_DB/16_PKG_DMF0051_SPEC.sql      56줄
A_DB/17_PKG_DMF0051_BODY.sql   1,671줄
A_DB/18_GRANT_SYNONYM.sql         80줄  EXECUTE GRANT 8 + SYNONYM 8 (+ ⭐§5 DMF0073 GRANT 2 + SYN 2)
A_DB/19_PROC_DMF0073_VERSION_SALESPRICE.sql
                                 121줄  ⭐ 신설 — standalone PROCEDURE 원문 (클라우드 결손 확인됨)
A_DB/20_MENU_META_SYNC.sql       328줄  MNU_M 1 / PROGRAM 1 / API_M 8 / BTN 8 / UG_MNU 5 / UG_BTN 40
A_DB/21_CMBO_SYNC.sql             52줄  CMBO 7본 MERGE (⚠ 5본 공유)
A_DB/22_SHEET_META_SYNC.sql      986줄  SHEET_COLUMNS 309 + SHEET_MEASURE 173 = 482행 재적재
A_DB/23_MSG_LBL_MNU_SYNC.sql     336줄  MSG/LBL/MNU 22코드 × 3언어 = 66행
A_DB/24_PROC_M_SYNC.sql          459줄  ⭐ 신설 — SCM_ADM_PROC_M 6본 × 80행 MERGE (PLS-00306 정정)
A_DB/90_VERIFY.sql               228줄  V1~V8 실측 + ⭐V10 배선 역추적(0행) + V9 런타임 스모크

B_FE/demand-plan-waterfall/            화면 폴더 **전체 12파일** (index.ts 포함 — 부분 이관 금지)
B_FE/shared-olap-pivot-grid/           ⚠ 공용 3파일 (OlapPivotGrid / olapUtils / organisms index)
B_FE/configs-types/procedures.d.ts     공용 타입 전체 (타 화면 선언 포함 — 무해)
B_FE/locales/{KO,EN,CN}.json           본 화면 소비 22키 발췌 (참고용 — 정본은 DB MSG_M)
B_FE/feature-report-scaffold/          @report 워크스페이스 미존재 시에만 필요 (§4.3)

C_BE/_NO_BE_CHANGE.md                  BE 변경 **0건** 실측 근거
```

### 적용 순서

1. **`00_CLOUD_PRECHECK.sql`** (QA/DEV 각각) — C2·C4·C6 판단 후 진행
2. `A_DB/01` → `A_DB/02` (GTT DDL + 인덱스)
3. `A_DB/10` → `11` → `12` → `13` → `14` → `15` → `16` → `17` (SPEC→BODY, **각각 단독 실행**)
   - 실행 계정 = **SCM_MGR**. 덤프 원문에 스키마 접두가 없다(`CREATE OR REPLACE PACKAGE BODY "PKG_xxx"`).
   - BE 가 기동 중이면 라이브 PKG 재컴파일이 `ORA-04021`/`ORA-00054` 로 막힐 수 있다 →
     BE 중지 후 실행하거나 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30` 선행.
   - ⚠ 파일 선두의 `--` 헤더 주석에는 검증 마커 리터럴을 넣지 않았다(실행기가 선행 주석을
     함께 넘기면 `ALL_SOURCE` 에 섞여 `90_VERIFY V3` 카운트가 어긋나기 때문).
4. `A_DB/19` — ⭐ **`DMF0073_GET_VERSION_SALESPRICE` 결손 시에만** (PRECHECK 로 부재 확인 후. §5.4)
5. `A_DB/18` (GRANT = SCM_MGR / SYNONYM = DBA. **19 를 실행했다면 §5 DMF0073 GRANT·시노님도 세트로**)
6. `A_DB/20` → `21` → `22` → `23` → ⭐ **`24`** (메타 — **24 는 20~23 뒤, 90 앞**)
7. `B_FE` 반영 → `pnpm install` (§4.2 wijmo olap 의존) → 빌드 → 재기동
8. `A_DB/90_VERIFY.sql` — **V10 이 0행이어야 PASS** + V9 런타임 스모크

---

## 4. 축별 실측 카운트 (사내 2026-08-20 — 기계 스윕 결과)

### 4.1 DB 축

| 축 | 대상 | 행수 | 비고 |
|---|---|---:|---|
| `SCM_ADM_MNU_M` | `MNU_ID='DMF0035'` | **1** | ROUTE_PATH `report/demand-plan-waterfall` |
| `SCM_ADM_PROGRAM` | `PROGRAM_ID='DMF0035'` | **1** | AS-IS 프로그램 마스터 |
| `SCM_ADM_API_M` | `API_ID LIKE 'DMF0035_%'` | **8** | 시트 8종 SP 배선 |
| `SCM_ADM_MNU_BTN_MPG_M` | `MNU_ID='DMF0035'` | **8** | 시트 8 × SEARCH |
| `SCM_ADM_USER_GR_MNU_MPG_M` | `MNU_ID='DMF0035'` | **5** | ADMIN / DM ADMIN / DM Planner / DM Viewer / SCP Planner |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | `MNU_ID='DMF0035'` | **40** | 5 그룹 × 8 시트 |
| ⭐ `SCM_ADM_PROC_M` | 결손 6 PROC_NM (`A_DB/24`) | **80** | 25+7+9+22+9+8 — 아래 분해표. 화면 ID 컬럼이 없어 1차 스윕에서 누락됐던 축 |
| `SCM_ADM_CMBO_SQL_M` | FE 실소비 7본 | **7** | QtyType·ReportBucketType(0806 작업분) + 공유 5 |
| `SCM_ADM_MSG_M` | 22코드 × 3언어 | **66** | MSG 6 / LBL 13 / MNU 3 |
| `SCM_MST_SHEET_COLUMNS` | 3 SHEET_NAME 전량 | **309** | Mkt 119 + sales 65 + Biz 125 |
| `SCM_MST_SHEET_MEASURE` | 3 SHEET_NAME 전량 | **173** | Mkt 73 + Sales 84 + Biz 16 |
| GTT | `GT_DM22/DM35/DM51/SPNC_*` | **49** | grep 축 49 = dep 축 49 (완전 일치) |
| GTT INDEX | — | **2** | `IDX1_GT_DM22_ITEM_SINGLE_V`, `..._V_T` |
| EXECUTE GRANT | SCMD_APP + SCMP_APP × 4 PKG | **8** | (+ RL_SCM_DML 롤 2건 — 옵션) / `90_VERIFY V6` 대상 |
| SYNONYM | SCMD_APP + SCMP_APP × 4 PKG | **8** | `90_VERIFY V6` 대상 |
| ⭐ EXECUTE GRANT (DMF0073) | SCMD_APP + SCMP_APP × `DMF0073_GET_VERSION_SALESPRICE` | **2** | `18` §5. `DBA_TAB_PRIVS` 실측(GRANTOR=SCM_MGR) — 검증은 `18` §6 |
| ⭐ SYNONYM (DMF0073) | SCMD_APP + SCMP_APP × 동명 | **2** | `18` §5. `ALL_SYNONYMS` 실측 |
| PKG BODY 라인 | SCM0002 / DMF0035 / DMF0022 / DMF0051 | **4,259 / 4,149 / 3,668 / 1,760** | `ALL_SOURCE` 기준 |

#### ⭐ 4.1-A 조회 성능 튜닝 (PKG BODY 3본 — 2026-08-20~21 사내 적용·검증 완료)

⚠ **PKG BODY 파일(`A_DB/13`·`15`·`17`)에는 아래 튜닝이 이미 포함**되어 있다. 별도 스크립트가 아니라
**BODY 를 적용하면 함께 반영**된다. 마커로 반영 여부를 판정한다(`90_VERIFY` V3·V13, 델타 패키지 `90_VERIFY_PERF` P3).

| PKG | 마커 | 무엇을 고쳤나 | 실측 효과(사내) |
|---|---|---|---|
| `PKG_DMF0035` (`A_DB/13`) | `[E20260820-DS2]` ×1 | 진입부 `optimizer_dynamic_sampling=2` — 클라우드 `ODS=0` 방어. 통계 없는 GTT 가 카디널리티 1로 추정돼 NL 폭발하는 것을 차단 | 클라우드 1,302초/회 → 새 플랜 생성 |
| | `[E20260820-WFITEMPERF]` ×2 | SCP 정보 적재문의 **행별 상관 스칼라 2분기 → 선계산 LEFT JOIN**, `ROWNUM=1` → `MAX(DOE)` 결정화 | **141s → 4.2s** (775행 전행 동일) |
| | `[E20260820-VERPUSH]` ×6 | `GT_DM35_T_LAST_SETUP_C` 적재 2문 × 원천표 3분기에 **버전 술어 푸시** → access predicate 승격 | 클라우드 **712s → 6.1s**, buffer 8.53M → 19.6K |
| | `[E20260820-RAWSCALAR]` ×2 | `GT_DM35_RAW_DATA`(MF/SF) 적재문의 **상관 스칼라 10개 → 선계산 3본 LEFT JOIN** | 3.163 → 1.788 s/exec, buffer −72.5% |
| | `[E20260820-VERPUSH2]` ×5 | 위 문장 포함 **미적용 5지점** 버전 술어 푸시 | 1.788 → **0.230 s/exec**, **디스크 219,587 reads → 0** |
| `PKG_DMF0022` (`A_DB/15`) | `[E20260820-DS2]` ×1 | 동일 ODS 방어 | — |
| | `[E20260820-D22PREREDUCE]` ×2 | **선행축소** — 아이템 마스터 GTT 를 `SUBSTR(ITEM_ID,1,12) IN (RAW prefix)` 로(243,050행 → 수백), 사이트 GTT 에 `EXISTS` | 논리 읽기 −22~60% |
| | `[E20260820-D22VERPUSH]` ×2 | `DM_PLN_SALES_PLAN_C` 에 division+버전 술어 → `IX_..._N3` 선두 개방 | div40 SP_W **물리 128,618 → 29,742 (−76%)** |
| `PKG_DMF0051` (`A_DB/17`) | `[E20260820-DS2]` ×1 | 동일 ODS 방어 | — |
| | `[E20260820-D51SCALAR]` ×1 | 행별 `FN_GET_DM_MKT_OWNER_NAME`×2 + 상관 스칼라 → DISTINCT OWNER 선계산 조인 | 함수 평가 **69,579회 → 264회** |
| | `[E20260820-D51REGROUP]` ×1 | 무용 GROUP BY 제거(입력=출력 항등 실측) | `ITEM_SINGLE_V` 388,722 → **1,884 BG (−99.5%)** |
| | `[E20260820-D51SEMI]` ×1 | `INNER JOIN SCM_MST_SITE` → `WHERE EXISTS`(조인키 유일 3,029/3,029 실측) | `SITE_ITEM` −94% |
| | `[E20260820-D51ITEMPFX]` ×1 | prefix(12자) 선행축소 | 243,050 → **3,559행** |

**전체 성적(사내)**: MKT 문장 3.163 → 0.230 s/exec(−93%) · SALES 논리 읽기 −41~74% · BIZ 합계 5,044,796 → 1,500,487 BG(**−70%**), SP 왕복 5.55 → 2.83초.

**공통 원칙(적용 시 참고)**
- **힌트 `/*+ */`·optimizer 파라미터 조작·강제 통계수집 0건** — 전부 구조 변경(hook #129 ①→②→③ 원순위).
  단 `DS2` 는 클라우드 `optimizer_dynamic_sampling=0` 환경 방어로 **프로젝트 표준**(`[E20260812-DS2]` 계보)이다.
- 값 동등성: MKT 5케이스 × 3회 / SALES 6케이스 × 3커서(18/18) / BIZ 10케이스 — **전행 일치** 확인 후 채택.
- ⚠ **철회한 처방 1건**: SALES 단가표 2본에 division+기간 술어를 넣었더니 PK NL 로 전환돼 **0.331s → 3.749s 악화** → 되돌림.
- ⚠ **구조로는 여기까지** — 잔여 풀스캔 3종(`DM_PLN_BP_FCST_C` 기간축 인덱스 부재 / `SCM_ITEM_M` (DIVISION_ID,ITEM_ID) 부재 / 단가표 2본)은 인덱스 없이는 제거 불가.
  → **제안만** `DMF0035_PERF_SALESBIZ_20260821/A_DB/91_INDEX_PROPOSAL_NOT_APPLIED.sql` (4건, **적용 안 함**. 그중 `FP_MGR.SCM_ITEM_M` 은 공용 마스터라 타 도메인 영향 검토 필수).
- ⚠ **회귀 감시축 2개**(적용 후 반드시 확인): `PKG_DMF0022` 의 **`v_measure_sheet` 6건**(사라지면 SALES PLAN 이 오류 없이 **조용히 0행**) · **`SCM_ADM_USER_MNU_EDIT_AUTH_V` 조인**(권한 뷰가 사실상 조회 필터 — 제거되면 결과 소멸. DMF0022 3행 / DMF0051 2행).
- 📦 **SALES/BIZ 만 재적용하려면** 델타 패키지 `_artifacts/_deploy_packages/DMF0035_PERF_SALESBIZ_20260821/` 사용(BODY 2본 + 검증 + 인덱스 제안).

#### ⭐ `SCM_ADM_PROC_M` 축 분해 (사내 실측 2026-08-20 / `A_DB/24_PROC_M_SYNC.sql`)

MERGE ON 키 = **실측 PK** `PK_SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD)`
— `ALL_CONSTRAINTS`/`ALL_CONS_COLUMNS` 로 확인(추정 ON 키 금지 계보). 감사컬럼 = `'admin'`.

| 시트 (`SHT_NM`) | PROC_NM | PROC_M 행 | `ALL_ARGUMENTS` | 동봉 |
|---|---|---:|---:|---|
| `mktFcstWaterfall` | `PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL` | 25 | 25 | ✅ 24 |
| `mktFcstSpreadTitle` | `PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE` | 7 | 7 | ✅ 24 |
| `salesPlanSpreadTitle` | `PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE` | 9 | 9 | ✅ 24 |
| `bizPlanWaterfall` | `PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL` | 22 | 22 | ✅ 24 |
| `bizPlanSpreadTitle` | `PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE` | 9 | 9 | ✅ 24 |
| `versionWf` | `PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP` | 8 | 8 | ✅ 24 |
| | **동봉 소계** | **80** | **80** | |
| `salesPlanWaterfall` | `PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` | 25 | 25 | ⛔ **미동봉** — 클라우드 정상 등재(25/25). **DMF0022 소관 공유 축, 덮어쓰면 회귀** |
| `version` | `DMF0073_GET_VERSION_SALESPRICE` | 9 | 9 | ⛔ 미동봉(메타는 클라우드 존재) — **결손은 객체 쪽**. §5.4 |

#### 시트 메타 PROGRAM_ID 분해 (⚠ 공유 시트)

| 테이블 | SHEET_NAME | 합계 | 분해 |
|---|---|---:|---|
| SHEET_COLUMNS | `Mkt Fcst Waterfall` | 119 | DMF0035 **71** + DMF0040 48 |
| SHEET_COLUMNS | `salesPlanWaterfall` | 65 | DMF0022 **65** |
| SHEET_COLUMNS | `Biz Plan Waterfall` | 125 | DMF0051 **61** + DMF0051_1 64 |
| SHEET_MEASURE | `Mkt Fcst Waterfall` | 73 | DMF0035 **49** + DM0035 24 |
| SHEET_MEASURE | `Sales Plan Waterfall` | 84 | DMF0022 **31** + DM0022 19 + DMF0021 17 + DMF0048 17 |
| SHEET_MEASURE | `Biz Plan Waterfall` | 16 | DMF0051 **9** + DMF0051_1 7 |

### 4.2 FE 축

| 항목 | 값 |
|---|---|
| 화면 폴더 파일 | **12** (`index.ts` + `__asis-mapping__.md` 포함) |
| 공용 파일 | **3** (`OlapPivotGrid.tsx` / `olapUtils.ts` / `organisms/index.ts`) |
| 공용 타입 | `configs/types/procedures.d.ts` (4,273줄 — DMF0035 블록 L157~) |
| locales 발췌 | 22키 × 3언어 (KO/EN/CN 전 키 존재 — 누락 0) |
| import 폐포 (페이지 밖) | `@foundation/{apis,constants,dayjs,lodash,models,query-client}` · `@shared/{clsx,components,hooks,lges,lges-icons,mui,stores}` · `features/master/src/components` · `@mescius/wijmo.grid`,`wijmo.grid.filter` · (공용 경유) `@mescius/wijmo.olap`, `@mescius/wijmo.react.olap`, `@mescius/wijmo.grid.xlsx` |

> ⚠ **wijmo OLAP 의존**: `@mescius/wijmo.olap` + `@mescius/wijmo.react.olap` (`5.20252.44`) 가
> 루트/`packages/shared` `package.json` 에 선언돼 있다. 클라우드 FE 에 미설치면 빌드 실패 —
> 이관 후 반드시 `pnpm install`.

### 4.2-A ⭐ FE 파일 배치 경로 (패키지 → 클라우드 저장소) — **경로가 폴더명과 다르니 표대로 옮길 것**

패키지의 `B_FE/` 하위 폴더명은 **분류용 별칭**이다. 실제 배치 위치는 아래와 같다(경로 전부 사내 저장소에 실존 확인, 2026-08-21).

| # | 패키지 경로 | **클라우드 배치 경로** (repo 루트 기준) | 방식 |
|---|---|---|---|
| 1 | `B_FE/demand-plan-waterfall/**` (12파일) | `nscm-fe/features/report/src/pages/demand-plan-waterfall/**` | **폴더 통째 교체** |
| 2 | `B_FE/shared-olap-pivot-grid/OlapPivotGrid.tsx` | `nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` | 파일 교체 |
| 3 | `B_FE/shared-olap-pivot-grid/olapUtils.ts` | `nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid/olapUtils.ts` | 파일 교체 |
| 4 | `B_FE/shared-olap-pivot-grid/organisms-index.ts` | `nscm-fe/packages/shared/src/components/organisms/index.ts` | ⚠ **병합**(barrel — 타 화면 export 보존) |
| 5 | `B_FE/configs-types/procedures.d.ts` | `nscm-fe/configs/types/procedures.d.ts` | ⚠ **병합**(DMF0035 블록만 — 타 화면 타입 보존) |
| 6 | `B_FE/locales/KO.json` · `EN.json` · `CN.json` | `nscm-fe/public/locales/KO.json` · `EN.json` · `CN.json` | ⚠ **키 병합**(22키 발췌본 — 전체 덮어쓰기 ⛔) |
| 7 | `B_FE/feature-report-scaffold/package.json` | `nscm-fe/features/report/package.json` | 조건부(§4.3) |
| 8 | `B_FE/feature-report-scaffold/tsconfig.json` | `nscm-fe/features/report/tsconfig.json` | 조건부(§4.3) |
| 9 | `B_FE/feature-report-scaffold/src/index.ts` | `nscm-fe/features/report/src/index.ts` | 조건부(§4.3) |

**필수 주의 4가지**
1. **①은 반드시 폴더 전체** — `index.ts` 는 `viewRegistry` glob 의 **유일한 등록 키**다. 일부 파일만 옮기면
   라우팅은 살아 있는데 탭 안에서 `resolveView()` 가 실패해 **"Page Not Found"** 가 뜬다(실사고 계보).
2. **④⑤⑥은 덮어쓰기 금지, 병합** — 셋 다 **타 화면과 공유하는 파일**이다. 통째로 덮으면 다른 화면의
   export·타입·라벨이 사라진다.
3. **②③에는 다른 화면 작업분이 함께 들어 있다** — `OlapPivotGrid.tsx` 의 `autoFitColumns`(컬럼 폭 자동
   최적화, 2026-08-20)는 DMF0035 요청으로 넣었지만 **공용 컴포넌트**다. 적용하면 이 컴포넌트를 쓰는
   모든 화면에 반영된다(현재 소비처는 DMF0035 뿐 — 실측).
4. **⑦⑧⑨는 클라우드에 `features/report` 가 없을 때만** (§4.3 참조). 이미 있으면 **적용 금지** —
   scaffold 의 `src/index.ts` 가 `sales-plan-waterfall` 을 export 하므로 그 폴더가 없으면 빌드가 깨진다.

배치 후 `pnpm install` → `pnpm type-check` → `pnpm build` 순으로 확인할 것(wijmo OLAP 의존 — 아래 경고 참조).

### 4.3 `@report` 워크스페이스

사내 기준 `nscm-fe/features/report` 는 이미 워크스페이스로 등록돼 있고(`apps/web/package.json`
`"@report": "workspace:*"`), 같은 폴더에 **`sales-plan-waterfall`(DMF0022 단독 TO-BE 화면)** 도 있다.
클라우드에 `features/report` 가 이미 있으면 `B_FE/feature-report-scaffold/` 는 **적용하지 말 것**
(`src/index.ts` 가 `sales-plan-waterfall` 을 export 하므로 그 폴더가 없으면 빌드가 깨진다).

### 4.4 0행 축 (조용한 스킵 방지 — 명기 의무)

| 축 | 결과 | 판단 |
|---|---|---|
| `SCM_ADM_EXCEL_COLUMNS` (PROGRAM_ID='DMF0035') | **0행** | 조회 전용 화면 — Excel Form/Upload 없음. 정상 |
| `SCM_ADM_EXCEL_UPLOAD` | **0행** | 동일 |
| `SCM_ADM_USER_MNU_SRCH_COND_M` | **0행** | 사용자 개인 조회조건 — 이관 대상 아님 |
| `SCM_ADM_USER_BMK_M` (즐겨찾기) | **0행** | 사용자 데이터 |
| PKG 4본 `TYPE` 의존 (`ALL_DEPENDENCIES REFERENCED_TYPE='TYPE'`) | **0행** | 사용자 정의 TYPE 없음 → TYPE DDL 동봉 불필요 |
| `SCM_ADM_LOOKUP_MASTER_DETAIL / LOOKUP_TYPE='SHEET_PRSL_YN'` (waterfall) | **0행** | 그리드 개인화 미적용 시트 = `PR_GET_SHEET_COLUMN_LIST` 가 비개인화 경로 사용 |
| BE Java/MyBatis waterfall 변경 | **0건** | `C_BE/_NO_BE_CHANGE.md` |

### 4.5 이관 제외 축 (명시)

| 축 | 사내 행수 | 제외 사유 |
|---|---:|---|
| `SCM_MST_TITLESET_USER` (PROGRAM_ID='DMF0035') | 607 | **사용자 개인화 — 이관 제외**(사용자 지시). 시트별: `mktFcstWaterfall` 748 / `salesPlanWaterfall` 394 / `bizPlanWaterfall` 288 / `Biz Plan Waterfall` 9 (전 프로그램 합) |
| `SCM_COM_SYS_LOG` (MNU_ID='DMF0035') | 151 | 실행 로그 |
| `NSCM_UI_TEMP` / `_0211` / `_0304` | 각 5 | 작업용 임시 테이블 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` / `*_BAK` 등 | — | 백업 스냅샷 테이블 |
| `SCM_ADM_LOOKUP_MASTER_DETAIL` (21 LOOKUP_TYPE) | 675 | **공유 마스터 — 덮어쓰지 않음.** PRECHECK C5 로 결손만 탐지 |

---

## 5. ⚠ 판단이 필요한 항목 (적용 전 결정)

### 5.1 공유 시트 메타 덮어쓰기 (`A_DB/22`)

`22_SHEET_META_SYNC.sql` 은 hook #98 §9 대로 **SHEET_NAME 단위 DELETE 후 전량 재적재**한다
(삭제 범위 = 삽입 범위). 그 결과 아래 **타 화면 행까지 사내 값으로 덮인다**:

| 영향 화면 | 테이블 | 행수 |
|---|---|---:|
| DMF0040 (MKT FCST Comparison) | SHEET_COLUMNS `Mkt Fcst Waterfall` | 48 |
| DMF0051_1 (Business Plan Confirm) | SHEET_COLUMNS `Biz Plan Waterfall` | 64 |
| DM0035 (MKT FCST Waterfall_bk) | SHEET_MEASURE `Mkt Fcst Waterfall` | 24 |
| **DMF0021** (라이브 화면) | SHEET_MEASURE `Sales Plan Waterfall` | **17** |
| DMF0048 | SHEET_MEASURE `Sales Plan Waterfall` | 17 |
| DM0022 (Sales Plan Waterfall_bk) | SHEET_MEASURE `Sales Plan Waterfall` | 19 |

→ **PRECHECK C6** 로 클라우드 현재 값을 뽑아 사내와 비교하고, 특히 **DMF0021** 이 클라우드에서
독자 변경된 이력이 있으면 해당 SHEET_NAME 블록만 분리 적용(또는 DMF0035/0022/0051 행만 UPSERT)할 것.

### 5.2 공유 CMBO 덮어쓰기 (`A_DB/21`)

7본 중 **5본이 공유**다 — `BucketType2`(DMF0042) / `SenderCode` / `ItemType` /
`UserSiteByEndCustomer`(전 화면 SalesSiteField) / `MyDivision`.
PRECHECK C4 의 `LEN`·`LAST_UPDATE_DATE` 가 사내와 다르면 덮어쓰기 여부를 판단할 것.
**본 화면 전용 필수 갱신분은 `QtyType`·`ReportBucketType` 2본**(2026-08-06 DMF0035 작업분)이다.

### 5.3 GTT 구조 diff (`A_DB/01`)

01 은 `-955`(기존재)를 무시한다. **이름만 같고 컬럼 구조가 다른 구세대 GTT** 가 클라우드에 있으면
조용히 통과한 뒤 런타임 `ORA-00904`/`ORA-00932` 로 터진다.
→ **PRECHECK C2** 의 `COL_CNT` 를 아래 사내 기준선과 대조하고, 불일치 GTT 는
`DROP TABLE SCM_MGR.<GTT> PURGE` 후 01 을 재실행할 것(GTT DROP 은 해당 세션들이 비어 있어야 함 —
BE 중지 후 수행. 사용 중이면 `ORA-14452`).

> 사내 GTT 컬럼수 기준선은 `A_DB/01_DDL_GTT.sql` 각 블록 헤더 주석(`-- <GTT> (N cols, SYS$SESSION)`)에
> 전부 기재돼 있다.

### 5.4 ⭐ `DMF0073_GET_VERSION_SALESPRICE` — **결손 확인됨** (구 "미동봉" → 격상, 2026-08-20)

`DMF0035_version_SEARCH` 의 API_URL 은 PKG 가 아닌 **standalone PROCEDURE**
`DMF0073_GET_VERSION_SALESPRICE` (9-arg 공유 계약, DMF0082 선례)이다.

**클라우드 실측 결과 = 결손 확인됨** — `SCM_ADM_PROC_M` 은 **9행 존재**하나
**객체 자체가 없다**(`ALL_ARGUMENTS` 인자수 **0**). 즉 메타는 맞고 실체가 없는 상태다.
따라서 이 축은 "선행 배포 확인만" 이 아니라 **본 패키지에서 실제로 해소해야 하는 결손**이다.
(같은 `version` 시트가 위 §4.1 PROC_M 분해표에서 유일하게 `ARG_CNT=0` 으로 적출된다.)

#### ⓐ standalone PROCEDURE 본문 — **동봉함**

- 사내 실측(`ALL_OBJECTS`): **`SCM_MGR.DMF0073_GET_VERSION_SALESPRICE` = `PROCEDURE` / `VALID`**
  / `LAST_DDL_TIME` 2026-07-21 16:39 / `ALL_SOURCE` **119줄**. → 사내에 실존하므로 원문을 덤프했다.
- 동봉 파일 = **`A_DB/19_PROC_DMF0073_VERSION_SALESPRICE.sql`** (128줄, 라이브 `ALL_SOURCE` 신선 덤프).
- ⚠ **공유 객체**다(DMF0073/DMF0082 계열과 9-arg 계약 공유). 클라우드에 **이미 있으면 실행 금지** —
  PRECHECK 로 `ALL_OBJECTS.LAST_DDL_TIME` 과 `ALL_ARGUMENTS` 인자수(9)를 먼저 대조할 것.
  이번 실측처럼 **부재(ARG_CNT 0)일 때만** `A_DB/19` 를 적용한다.
- 참고: 동 계열 `DMF0073_SAVE_VERSION_SALESPRICE` 는 **사내에서 `STATUS=INVALID`** 다.
  본 화면은 조회 전용이라 소비하지 않으므로 이관 대상이 아니다(사실만 기재).

#### ⓑ 앱계정 EXECUTE GRANT + 시노님 — `A_DB/18_GRANT_SYNONYM.sql` **§5 에 포함함**

사내 실측 구성과 동일하게 구성했다:

| 축 | 사내 실측 (2026-08-20) | 동봉 |
|---|---|---|
| `DBA_TAB_PRIVS` | `SCMD_APP` EXECUTE / `SCMP_APP` EXECUTE (둘 다 GRANTOR=`SCM_MGR`) — **2건** | `18` §5 GRANT 2문 |
| `ALL_SYNONYMS` | `SCMD_APP.` / `SCMP_APP.` 동명 시노님 → `SCM_MGR.(동명)` — **2건** | `18` §5 SYNONYM 2문 |

> ⚠ **GRANT 누락 = PLS-00201 계보**이며, 이 결함은 **화면 진입 시점이 아니라
> SALES PLAN 의 Version(돋보기) 팝업을 여는 시점에 터진다.** 조회가 정상이라고 통과시키면
> 나중에 사용자 손에서 터진다. **시노님 ≠ 권한** — 시노님만 만들면 `ALL_SYNONYMS` 는 VALID 로
> 보이지만 실행은 동일하게 실패한다(DMF0014 PLS-00201 사고와 동형).
> 객체(`19`) · GRANT · 시노님은 **반드시 세트로** 적용한다.

검증 = `90_VERIFY` **V7b**(`SP_EXISTS=1`) + **V10**(`version` 행이 `FAIL-A` 로 적출되지 않을 것)
+ `18` §6 의 DMF0073 3축(OBJECT 1 / GRANT 2 / SYNONYM 2).

### 5.5 ⭐ `SCM_ADM_PROC_M` 공유 축 덮어쓰기 금지 (`A_DB/24`)

`SCM_ADM_PROC_M` 은 화면 ID 컬럼이 없는 **전역 공유 축**이다(`PROC_NM` 으로만 연결).
`24_PROC_M_SYNC.sql` 은 결손 6본만 MERGE 하고 아래는 **의도적으로 제외**했다:

| 제외 대상 | 사유 |
|---|---|
| `PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` (25행) | **클라우드에 이미 정상 등재(25/25)**. DMF0022 소관 공유 축 — 덮어쓰면 회귀 |
| `DMF0073_GET_VERSION_SALESPRICE` (9행) | 클라우드 메타 9행 정상. 결손은 객체 쪽(§5.4) |

→ `24` 에 위 2본을 **추가하지 말 것**. 반대로 다른 화면 패키지가 이 축을 손댈 때도
같은 원칙(결손분만 MERGE, PK `(PROC_NM, COL_NM, COL_TP_CD)` 기준)을 지킨다.

---

## 6. 알려진 미결 (침묵 금지 — 전수 기록)

| # | 미결 | 근거 / 상태 |
|---|---|---|
| 1 | **BIZ PLAN 실화면 확인 대기** | GUBUN=BIZ_PLAN 경로는 사내에서 실화면 검증 미완. `PKG_DMF0051` 은 2026-08-07 이후 무변경 |
| 2 | **DMF0051 TITLE 기본컬럼 `DEFAULT_FLAG='Y'` 점검** | `PKG_DMF0051` 의 숨은컬럼 판정이 `C.DEFAULT_FLAG IS NULL` (0035/0022 는 `RTRIM(...,' -') IS NULL`). 클라우드 `'-'`/`' '` 변형이 있으면 컬럼셋이 갈린다 |
| 3 | **OLAP 표시 2차 잔여 5종** | ①PERIOD 3단 헤더 계층 ②chkColor 실적구간 회색 ③NOTATION 행 포맷·당기 강조·주말색 ④헤더 더블클릭 드릴 ⑤Version 팝업 `sPeriod`(조회기간 덮어쓰기 — 공유 SP 계약에 버전 기준일 컬럼 부재). 상세 = `B_FE/demand-plan-waterfall/__asis-mapping__.md` §4 |
| 4 | **Wijmo OLAP Evaluation 워터마크** | `wijmo.olap` 은 별도 라이선스 키가 필요할 수 있음. 클라우드 라이선스 키에 OLAP 모듈이 포함되지 않으면 그리드에 평가판 워터마크가 표시된다. **라이선스 확인 미완 — 미결** |
| 5 | **SALES PLAN 구세대 회귀 재발 감시** | `PKG_DMF0022` 는 08-10 에 한 번 구세대로 덮여 SALES PLAN 이 0행이 된 전력이 있다. 배포·재배포 시마다 `90_VERIFY V3-2`(`V_MEASURE_SHEET`=6)를 상시 축으로 확인할 것 |
| 6 | `fetchStaticColumns` 0행 (무해) | 스토어가 `POST /admin/menu/DMF0035/column` 을 `sheetNm='mktFcstWaterfall'` 로 호출하지만, `SCM_MST_SHEET_COLUMNS` 의 DMF0035 실등록명은 `'Mkt Fcst Waterfall'` 이라 0행이 반환된다. 그리드는 TITLE SP 결과(`titleRows`)만 쓰므로 화면 영향 없음 — 정리 대상으로만 기록 |
| 7 | `__asis-mapping__.md` §4 잔여6 문구 갱신 필요 | "CMBO 신설 대기: BucketType2 / QtyType" 은 **이미 등록 완료**(2026-08-06). 문서만 stale |
| 8 | **`DMF0073_GET_VERSION_SALESPRICE` 클라우드 실체 부재** | 클라우드 PROC_M 9행 / `ALL_ARGUMENTS` 0 = **결손 확인됨**. `A_DB/19` + `18` §5 로 해소 예정 — **적용·검증 미완** (§5.4) |
| 9 | **횡전개 — `PR_GET_DAY_RANGE` PROC_M 미동봉** | `DMF0003_DAYRANGE_AUTH_FIX_20260729` 이 `DMF0003_dayRange_SEARCH → PR_GET_DAY_RANGE` 를 API_M 에 신규 배선하면서 PROC_M(사내 **5행**)은 동봉하지 않았다. 클라우드에 해당 5행이 없으면 **동일 PLS-00306**. 본 패키지 소관 아님 — **DMF0003 측 확인 필요** |

---

## 7. sheet_name 3체계 (⭐ 데이터 개명 금지)

이 화면은 같은 개념에 대해 테이블별로 **다른 시트명**을 쓴다. PKG 본문 변수 대입(LIVE 코드) 실측:

| 축 | MKT (DMF0035) | SALES (DMF0022) | BIZ (DMF0051) |
|---|---|---|---|
| `SCM_MST_SHEET_COLUMNS` | `Mkt Fcst Waterfall` | `salesPlanWaterfall` | `Biz Plan Waterfall` |
| `SCM_MST_SHEET_MEASURE` | `Mkt Fcst Waterfall` | **`Sales Plan Waterfall`** | `Biz Plan Waterfall` |
| `SCM_MST_TITLESET_USER` | `mktFcstWaterfall` | `salesPlanWaterfall` | `Biz Plan Waterfall` |
| FE / `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` | `mktFcstWaterfall` | `salesPlanWaterfall` | `bizPlanWaterfall` |

PKG 본문 실측 (주석 아닌 LIVE):
```
PKG_DMF0035  V_P_PROGRAM_ID='DMF0035'  V_P_SHEET_NAME='mktFcstWaterfall'  V_P_COLS_SHEET='Mkt Fcst Waterfall'
PKG_DMF0022  v_program_id ='DMF0022'   v_sheet_name  ='salesPlanWaterfall' v_measure_sheet='Sales Plan Waterfall'
PKG_DMF0051  V_PROGRAM_ID ='DMF0051'   V_SHEET_NAME  ='Biz Plan Waterfall'
```

→ **실측값 그대로 적재한다. 통일·개명 금지** (개명 시 SP 본문과 어긋나 조용히 0행).

---

## 8. 스윕 방법론 (재현 가능)

| 축 | 방법 |
|---|---|
| 메타 테이블 축 | `ALL_TAB_COLUMNS` 에서 `PROGRAM_ID/MENU_ID/MNU_ID/PGM_ID/PRG_ID/SCREEN_ID/UI_ID` 컬럼 보유 테이블 **39종 전수** → 각각 `= 'DMF0035'` 카운트 → 히트 14축 / 0행 25축 |
| ⭐ **SP 배선 축 (2026-08-20 추가 — 위 스윕이 놓친 축)** | **화면 ID 컬럼으로는 잡히지 않는다.** `SCM_ADM_MNU_BTN_MPG_M`(MNU_ID) ⋈ `SCM_ADM_API_M`(API_ID) → `API_URL` 을 얻은 뒤 그 값으로 `SCM_ADM_PROC_M.PROC_NM` 과 `ALL_ARGUMENTS` 를 **양쪽 대조**. 이것이 `90_VERIFY V10` 이며, 신규 패키지의 **상시 축**이다 |
| 시트명 축 | `SHEET_NAME`/`SHT_NM` 컬럼 보유 테이블 **26종 전수** × 시트 11종 매칭 |
| GTT 축 | ① PKG 4본 `ALL_SOURCE` 전문 **주석 제거(hook #138)** 후 `GT_[A-Z0-9_]+` grep ② `ALL_DEPENDENCIES REFERENCED_TYPE='TABLE'` → **합집합 49 = 양축 완전 일치**, 딕셔너리(`ALL_TABLES TEMPORARY='Y'`)로 교차 확정 |
| LOOKUP 축 | PKG 4본 + CMBO 7본 본문에서 `LOOKUP_TYPE='...'` 리터럴 기계 추출 → 21종 |
| i18n 축 | FE 폴더 전수 `(MSG\|LBL\|MNU)\d{5}` grep 22종 (주석 전용 `LBL00774`·`MSG00109` 제외 — hook #138) + `MNU_M.MNU_MSG_ID` |
| FE import 폐포 | 화면 폴더 전 파일의 `import ... from '...'` 추출 → 페이지 밖 참조 전수 |
| BE 변경 | `git log --all -- nscm-be` grep + `nscm-be/src` 전문 grep (둘 다 0건) |

재생성: `python _generate_db_files.py` (SELECT 전용 — 사내 라이브 재덤프).

---

## 9. 실행하지 않은 것 (전부)

- 사내 DB: **SELECT 만** 수행. DDL/DML **0건**.
- 클라우드 DB: **접속하지 않음**.
- git: add/commit/push **0건** (log/status/diff 읽기만).
- FE/BE 빌드·테스트: 미실행.
