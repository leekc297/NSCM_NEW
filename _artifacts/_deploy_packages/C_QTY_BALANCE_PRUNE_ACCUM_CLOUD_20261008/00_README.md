# C_QTY_BALANCE_PRUNE_ACCUM_CLOUD_20261008 — `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE` ② 파티션 키 조건 + ③ ACCUM 사본 제거 (사내 적용본 → 클라우드)

> 사용자 결정 2026-10-08: "② 파티션 키 조건 추가 · ③ ACCUM 사본 GTT 제거 · ④ 인덱스 6개 유지비 — 확인 후 신중하게 개선 진행". ①(BALANCE 전량 교체 → MERGE) 은 제외.
> 전제 = 클라우드 `C_QTY_BALANCE_CORPSYNC_CLOUD_20261008`(사내 10-01 판, 3,092줄) 적용 상태. 진단 전체: `_artifacts/_diagnostics/BATCH_LONGRUN_IDENTIFY_20261008/00_README.md` §4-12~4-13.

| 파일 | 내용 |
|---|---|
| `01_PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE.sql` | **v2** 전체 원문(SOURCE-FRESH 헤더 + `CREATE OR REPLACE` + 3,124줄 + `/`). 파티션 키 28곳(v1 32곳에서 퇴행 4곳 제외). **사내 적용 2026-10-08 17:02:17 VALID**. 클라우드는 v1(16:29) 상태 → **v2 재적용 필요** |
| `02_VERIFY.sql` | V0 적용 전(판본·파티션 키 동일성·실행 세션·백업) → V1~V3 적용 후(VALID·3,128줄·마크 39·키 32·ACCUM 3·AJS 2·오류 0·의존 객체·권한) |
| `03_RUN_COMPARE_cloud.sql` | 조회만(그대로 F5): R0 버전 · R0-b 기준선 · R5 소요·문장별 ASH 비교 |
| `03a_RUN_OLD_cloud.sql` | **구판 실행**(01 적용 전, 그대로 F5): MF_W → SF_W 직접 호출 + COMMIT, 회당 초 출력. C SP 직접 호출이라 **메일 0·제외시간 무관** |
| `03b_RUN_NEW_AND_COMPARE_cloud.sql` | **신판 실행 + 결과 동치**(01 적용 후, 그대로 F5, 입력값 없음): 같은 호출 후 블록 시작 시각 플래시백(= 03a 결과)과 측정값별 건수·QTY 합·키 해시 비교, 마지막 줄 `DIFF_ROWS=0 => EQUIVALENT` |
| `04_DIFF_vs_1001.diff` | 10-01 원문 대비 unified diff (38 hunk) — 검토용 |

## 1. 적용 순서 (클라우드, SCM_MGR)
1. `02` V0·V0-b·V0-c — 현재 판 3,092줄 / **파티션 키 = 가상컬럼 `CUTOFF_YYYYMMDD_DATE` = `TO_DATE("CUTOFF_YYYYMMDD",'YYYYMMDD')` 두 표 모두 확인(다르면 중단)** / 실행 세션 0. V0-d 백업 권장.
2. `03` R0/R0-b(조회) → **`03a` 그대로 F5 = 구판 실행**(MF_W·SF_W 회당 초 출력).
3. `01` 전체 실행(F5) → `02` V1~V3.
4. **`03b` 그대로 F5 = 신판 실행 + 동치 비교**(03a 와 연속) → 마지막 줄 `DIFF_ROWS=0 => EQUIVALENT` 이어야 완료. `03` R5 로 회당 소요·문장별 비교(기대: VMI INSERT 42초 → 수 초, ACCUM 단계 소멸).
5. 결과(회당 초 · R4 · R5)를 공유 → 다음 단계(④·30초 잔여) 판단.

## 1-b. v1 → v2 (2026-10-08 17:02) — 클라우드 16:35 실측 후 퇴행 4곳 제외
- 클라우드 v1 실행(03b, 16:35): 결과 동치 44/44 · VMI INSERT 85→3초(2회) · ACCUM 단계 소멸 확인. 그러나 `DELETE FROM DM_PLN_MKT_FCST_C A WHERE A.MEASURE IN (SELECT … GT_DPMFCQB_MEASURE_MF_ALL) … NOT EXISTS(예외품목)`(원문 L501, CFM_C 짝 L589 + 'RTF' 짝 L526/L616) 가 **PHV 1056814193(해시 안티조인) → 4008302274(행별 FILTER/PUSH_SUBQ)** 로 바뀌어 2회 8초→35초. 원인 = 파티션 키 등식이 하나 더 붙자 행 추정 22→1(클라우드 `_optim_peek_user_binds=false`·`optimizer_dynamic_sampling=0`) → 서브쿼리 푸시 선택.
- v2 = 이 4곳만 원문 그대로(주석으로 사유 명시), 나머지 28곳·③ 유지. 사내 등가 검증은 v1 과 동일 범위(제외 4곳은 원문 그대로라 추가 검증 불요).
- 2회차 공정 비교(17 U4, 캐시 워밍 후끼리): v1 SF_W 151초 vs 14:04 C#2 160초 = −9초. 내역: VMI −41 · 퇴행 +13/+4 · BALANCE INSERT aq7z +19(플랜 동일, 같은 시간대 인덱스 통계수집과 겹쳐 I/O·버퍼 증가) · 예외품목 INSERT 4q3x +7(전 파티션 풀스캔, 콜드). v2 기대 2회차 ≈ 134초.

## 2. 변경 내용 (원문 대비, 결과 동치)
### ② 파티션 키 조건 추가 — 28곳 (v2; v1 은 32곳)
- 두 _C 테이블은 주 단위 INTERVAL 파티션인데 파티션 키가 **가상컬럼** `CUTOFF_YYYYMMDD_DATE` 라서, 문자 `CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD` 만으로는 프루닝이 되지 않았다(클라우드 K4 `PARTITION RANGE ALL`, 사내 109/17 파티션 전체 탐색).
- 변수 `C_CUTOFF_DATE DATE := TO_DATE(C_CUTOFF_YYYYMMDD,'YYYYMMDD')`(변환 불가 시 NULL → 원문처럼 0건 매칭) 를 선언하고, `_C` 테이블에 걸린 `CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD` **32곳 전부** 바로 아래에 `AND <alias.>CUTOFF_YYYYMMDD_DATE = C_CUTOFF_DATE` 를 추가. 가상컬럼 정의상 결과 집합 불변.
- v2 추가 제외 4곳: L506/L531/L594/L621(MEASURE IN GTT + NOT EXISTS DELETE, §1-b 퇴행). 그 외 제외 4곳(의도적): L1810/L1909 는 CTE 간 조인(`A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD`, _C 직접 아님), L2693/L2721 은 GTT(`GT_DPMFCQB_MF_C_BALANCE_MKT_FCST`). 버전만으로 거르는 _C 접근(L424~474, L1108, L1475~1982, L2902~3051 의 일부)은 원문에 CUTOFF 조건이 없어 **정의적 동치가 성립하지 않으므로 손대지 않음**(사내 데이터로는 버전↔CUTOFF 1:1 이나 보증 아님).
### ③ `GT_DPMFCQB_CUTOFF_MST_ACCUM` 사본 단계 제거
- 원문: `CUTOFF_MST` → ACCUM INSERT(윈도 누적합) → ACCUM 예외품목 DELETE(당주월요일 이후) → ACCUM 집계로 TEMPX INSERT → TEMPX 예외 DELETE. ACCUM 은 이 구간 외 참조 0.
- 변경: `CUTOFF_MST` 인라인뷰에서 같은 윈도 누적합을 계산하고(예외 제거 **이전** 전 행 기준 — 원문 순서 보존) 같은 예외 조건을 `NOT EXISTS` 로 걸어 TEMPX 를 직접 적재. 초기화 `DELETE FROM GT_DPMFCQB_CUTOFF_MST_ACCUM` 제거. TEMPX 예외 DELETE 는 원문 유지(중복이지만 무해, 0행). GTT 객체 자체는 남겨둠(DROP 없음).
- 효과(클라우드 14:04 실측 기준): ACCUM 적재 4~5초 + 2회차 초기화 6초 + 예외 DELETE 가 사라짐. 회당 약 10초.
### 손대지 않은 것
- 힌트 0. 인덱스 DDL 0(④ 아래). ① 전량 교체 유지. PLANT_SITE_ID 건 무관.

## 3. 등가 검증 (사내 ZIOUI1, 2026-10-08)
| 검증 | 방법 | 결과 |
|---|---|---|
| ② 문장 단위 (T2) | 실테이블만 참조하는 8 문장의 대상 행 집합(ROWID 건수·해시)을 조건 전/후로 비교, **40 MF_W_20260824 · 81 MF_W_20260930 · 82 MF_W_20260825** | 24/24 SAME (예: BALANCE DELETE 집합 153,573 / 64,633 / 91,442 행 동일). 같은 집합을 구하는 데 전체 파티션 36~55초 → 단일 파티션 0.02초 |
| ② VMI SELECT (앞선 검증) | 40 MF_W_20260824 전/후 (행수·QTY 합·키 해시) + EXPLAIN | 1,402행 완전 일치, `PARTITION RANGE ALL` → `RANGE SINGLE(557)` |
| ③ 파이프라인 (T1) | 세션 GTT 만 사용: CUTOFF_MST 를 실데이터(40 23,740행 · 81 26,156 · 82 3,981)로 채우고 예외품목 300키(1/3 CELL NULL) 투입 → 원문 4단계 vs 신판 2단계의 TEMPX (건수·키+값 해시·합계) 비교 | 3/3 EQUIVALENT (12,877 / 11,707 / 2,699행). 원문 예외 DELETE 가 실제로 381/781/348행 제거한 상태에서 동일 |
| 컴파일 | 사내 CREATE OR REPLACE | VALID · 3,128줄 · 오류 0 · 의존 7객체 VALID · 권한 유지 |
| 실행 E2E | **사내 미실행** — C 호출 안의 `PR_DM_DNM_CREATE_C_WS_RTF` 가 중간 COMMIT 하므로 롤백 불가, 사내 공유 스냅샷을 다시 쓰게 됨 | → 클라우드 03 R1/R3/R4 로 대체(같은 버전을 구판·신판으로 연속 실행해 플래시백 비교) |

## 4. ④ 인덱스 6개 유지비 — 검토 결과 **DDL 미적용(권고: 삭제하지 않음)**
`DM_PLN_MKT_FCST_C`(4,012만 행) 인덱스 6개 17.5GB > 테이블 6.9GB. BALANCE 재삽입 37.7만 행이 행당 54 블록을 만지는 원인. 사내 DBA_INDEX_USAGE(19c) 와 V$SQL_PLAN 으로 사용 실태 확인:

| 인덱스 | 컬럼 | 접근(누적) | 특징 | 판정 |
|---|---|---:|---|---|
| PK_..._C_PART | DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,…(14)+CUTOFF_YYYYMMDD_DATE | 6,139 | 1000+행 반환 5,778 | 유지 |
| IDX_..._N3 | DIVISION_ID,VERSION_NO,MEASURE,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,QTY,CUTOFF_YYYYMMDD | 8,532,701 | 0행 반환 8.5M = 존재확인(상관 서브쿼리) 주력 | 유지 |
| IDX_..._SUPPLY_VERSION | VERSION_NO | 3,000,319 | 1행 반환 2.96M = DIVISION_ID 없이 VERSION_NO 만으로 찾는 호출자 존재(PK/N3 로 대체 불가) | 유지 |
| IDX_..._N1 | DIVISION_ID,MEASURE,YYYYMMDD,QTY,CUTOFF_YYYYMMDD | 166,174 | 0행 반환 161K = 존재확인 | 유지 |
| IX03_..._C | CUTOFF_YYYYMMDD,CUTOFF_TYPE | 2,436 | 1000+행 1,624 — 문자 CUTOFF 로 거르는 호출자(파티션 키 미사용)의 유일 경로 | 유지 |
| IDX_..._SUPPLY | DIVISION_ID,MEASURE,PROJECT_CODE,ITEM_ID,FCST_TYPE,YYYYMMDD | 811 | 1000+행 583, 공급(SCP) 측 조회. BALANCE DELETE 물리읽기 38초의 대상(버전이 선두 아님 → 리프 산재) | 유지 |

- 6개 모두 당일 사용 이력이 있고, 각각 다른 인덱스로 대체되지 않는 접근 패턴(VERSION_NO 단독·CUTOFF 단독·존재확인)을 가진다. **삭제 근거 없음.** 삭제·INVISIBLE 은 전 화면·SP 의 실행계획을 바꾸는 DDL 이라 증거 없이 하지 않는다.
- 남는 선택지(사용자 결정, 이 패키지 미포함): (a) 클라우드 `DBA_INDEX_USAGE` 로 같은 표를 확인(15 L1-d) — 클라우드에서만 0 접근인 인덱스가 있으면 그때 INVISIBLE → 관찰 → DROP 순으로. (b) `IDX_..._SUPPLY`·`N1` 의 prefix 압축(`ALTER INDEX … REBUILD ONLINE COMPRESS n`) 으로 리프 블록 수를 줄여 DELETE 물리읽기를 낮추는 방법 — 유지비(행당 블록 수)는 그대로이고 효과는 리빌드 후 실측 필요.
- 즉 ④ 로 줄일 수 있는 것은 현재 증거로는 없고, ① 의 84초는 "행 수를 줄이는 것(MERGE, 제외됨)" 외 경로가 없다. 클라우드 R5 실측 후 다시 판단.

## 5. 기대 효과와 잔여 (클라우드 14:04 실측 169초/회 기준)
- ② VMI INSERT 43초 → 수 초(탐색 파티션 17→1, NL 프로브 1/17) + ① DELETE 4문장의 인덱스 탐색 축소(물리읽기 일부) + `0m8x8bt5uuc33`·`achpqsdmpwpha`·`ftquxsqy458u3` 등 _C 조회 전부 단일 파티션.
- ③ 회당 약 10초 절감(2회차 초기화 6 + 적재 4).
- 잔여 = ① BALANCE 전량 삭제·재삽입 ≈84초(제외 결정) + 기타 ≈25초 → **회당 30초 목표는 ① 없이는 도달 불가**(예상 100~110초). R5 실측으로 확정.

## 6. 원복
`_deploy_packages/C_QTY_BALANCE_CORPSYNC_CLOUD_20261008/01_…sql`(10-01 판 3,092줄) 재실행. 또는 V0-d 백업 테이블의 line/text 를 `CREATE OR REPLACE ` 뒤에 이어 붙여 실행.
