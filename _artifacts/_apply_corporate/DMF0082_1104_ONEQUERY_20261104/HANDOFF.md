# HANDOFF — PKG_DMF0082_1104 GET_MAIN_DATA 속도 개선 작업 인수인계 (작성 2026-11-06 06:30)

> 다른 PC 에서 이어서 작업하기 위한 문서. 이 폴더(`_artifacts/_apply_corporate/DMF0082_1104_ONEQUERY_20261104/`) 하나에 도구·빌드 산출물·측정 기록이 전부 있다.
> 이 PC 에만 있던 파일 2개는 같은 폴더에 복사해 두었다: `HANDOFF_plan_copy.md`(계획 원문) · `HANDOFF_memory_copy.md`(세션 메모리 원문, apply #1~#26 상세 이력).
> 상세 타임라인(시각·출처 포함)은 `APPLIED_OPERATIONS.md`, 원 STEP ↔ 새 CTE 대조표는 `STEP_MAP.md`.
>
> ※ 2026-11-06 LG PC 수신 메모: 이 문서는 타 세션(ejene PC)에서 작성한 원문을 그대로 저장한 것. 수신 시점 LG PC 로컬 폴더는 커밋 BACKUP_20261105_172240(apply #19) 상태라 apply #20~#26 산출물(`_plan_probe.py`·`_s3var.py`·`_s3opt.py`·`_vsql_children.py`·`_compare_kid20~24`·`_measure_*h`·`_perf_table_h.out`·`_body_24/25_build.sql`·`_oneq_*_before*.py`)이 아직 없다. "소스 올려줘/내려줘" 동기화 후 사용할 것.

## 0. 한 줄 요약
사내오라클 ZIOUI1 의 `SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`(DMF0082 FCST & PRICE MGMT 조회, 50 STEP·GTT 20여 개)를 **원본은 건드리지 않고** 복제본 `PKG_DMF0082_1104` 에서 3문장(S1 사이트·품목 / S2 적재 / S3 동적 PIVOT) 구조로 재작성하고 26회 적용을 거쳐 속도를 개선했다. 행 단위 등가(94 시나리오 FAIL 0)가 증명된 **apply #26** 이 현재 1104 본체에 올라가 있다. 원본 교체·클라우드 이관 등은 **사용자 결정 대기**.

## 1. 현재 DB 객체 상태 (2026-11-06 06:09 확인, `ALL_OBJECTS`)
| 객체 | BODY LAST_DDL | 내용 | 용도 |
|---|---|---|---|
| `PKG_DMF0082` | 2026-11-04 14:48:42 | 원본 (불변 · 모든 apply 직전 FRESH-GATE 로 확인) | 비교 기준 A(원본) |
| `PKG_DMF0082_1104` | **2026-11-06 06:09:06** | **apply #26** (#24 LKGTT+LOCB + #25 SZCLASS + #26 NOJPPD) · VALID · ALL_ERRORS 0 · BODY 28,837행 | 본체 (납품 후보) |
| `PKG_DMF0082_1104A` | 2026-11-05 11:42:07 | apply #18 스냅샷 (원본과 등가 실증본) | 등가 비교 기준 A 대용(원본 MF_W 445s 대기 회피) |
| `PKG_DMF0082_1104B` | 2026-11-06 00:45:52 | apply #23 (LKGTT) | 폴백 |
| `PKG_DMF0082_1104C` | 2026-11-06 04:50:06 | apply #26 (1104 본체와 소스 동일) | 실험용 사본 |

- GT_DMF0082_* GTT 34개: 통계 없음(SESSION) · 인덱스 없음. SHARED 통계 재적용은 사용자 결정 사항.
- 세션 설정은 원문 그대로: `ALTER SESSION SET optimizer_dynamic_sampling = 2` · cursor_sharing=EXACT.

## 2. 최종 측정 결과 (측정 h · `_perf_table_h.out` · 3회 중앙값 · Current · 당월1일~+6개월 · 06:10~06:23)
| 사용자 | 사업부 | 원본 PKG_DMF0082 (proc+fetch) | 1104 #26 (proc+fetch) | 비 | 행수 |
|---|---|---|---|---|---|
| k0101 | 40 | 5.6+2.9 = **8.5s** | 3.5+2.7 = **6.4s** | 0.74 | 7,019 |
| k0101 | 81 | 7.8+3.8 = **11.5s** | 5.4+3.1 = **8.2s** | 0.71 | 7,909 |
| k0101 | 82 | 22.2+10.8 = **33.0s** | 10.7+6.6 = **17.1s** | 0.52 | 16,157 |
| minyonglee1 | 40 | 63.7+6.0 = **69.7s** | 4.2+2.8 = **7.0s** | 0.10 | 7,619 |
| minyonglee1 | 81 | 12.2+7.6 = **19.8s** | 7.5+2.8 = **10.1s** | 0.51 | 8,042 |
| minyonglee1 | 82 | 28.4+16.0 = **44.4s** | 11.6+5.3 = **16.9s** | 0.38 | 16,253 |

- 출처: `_measure_new1104h.out/.json`(1104, 06:10:21~06:13:25) · `_measure_orig1104h.out/.json`(원본, 06:13:46~06:22:32). 측정 전후 원장 변경 없음 · 행수 동일 · 정렬 digest 동일.
- 목표 3초는 전 조합 미달(최저 k0101/40 6.4s). 남은 큰 구간 = 82 의 S3 출력 + fetch(k0101/82 proc 10.7 + fetch 6.6).
- 버전 경로(MF_W/SF_W/SP_W/MF_D 단일·복수)는 원본 457~583s → 1104 1.9~27s (apply #14 VERLOOP · `_compare_ver13.out`).

## 3. 등가 증명 상태
- 최신: **kid24** (`_compare_kid24.out`, 04:54~06:08) = 1104A(#18) vs 1104C(#26) · 사용자 2 × 사업부 3 × {Current, 버전 4종, 복수 2종, 필터 9종+qty} = **94 시나리오 FAIL 0 · 미실증 16**(0행 시나리오: sender=NOSUCH=이상④ 재현 · cust 0행 · 81 SF_W/MF_D · 82 MF_D 데이터 없음).
- 사다리: 원본 vs 1104A(#18) 는 cur18(60)·multi18(12)·full12(94) 로 FAIL 0 실증 → 이후 변경본은 1104A 기준으로 비교.
- 판정 = 6 커서 행수·열수·정렬 SHA·ORDER BY 키 SHA(+ `--gtt` 시 TEMP_SITE_ITEM/TEMP_FCST_N_PRICE 행수·정렬 SHA). 40 사업부 cur1 의 "동률 순서 차이" 12건은 ORDER BY 동률 행의 순서만 다른 것(PASS).
- 사용자 결정(11-04): 행 단위 완전 동일 — 원문 이상 동작 5건(계획 §Context)도 그대로 재현한다. 수정은 별도 결정.

## 4. apply 이력 요약 (상세 = HANDOFF_memory_copy.md · APPLIED_OPERATIONS.md §1)
| # | 일시 | 내용 | 결과 |
|---|---|---|---|
| 기준선 | 11-04 16:26 | 1104 = 원문 | k0101 6.1/8.2/23.0 · minyonglee1 65.7/12.7/29.9 (proc) |
| 1 | 11-04 17:09 | 3문장 구조(S0 토큰·S1·S2·S3) | — |
| 2 | 17:39 | 룩업 WS·MEA·LD 를 CTE→GTT 적재 | 무통계 카티션 32분+ 사고 → 소형 룩업은 GTT 적재 유지(CTE 화 금지) |
| 5 | 18:40 | S2 사업부별 정적 INSERT 3본(PL/SQL IF) | — |
| 6 | 19:08 | S3 MSP 항등 판정 + M5/M6 집계 LEFT JOIN | — |
| 8 | 20:02 | M7 ROWID 방식 | #7(2식 조인 450s) 대체 |
| 10 | — | PIVOT→SUM(CASE) 악화 원복 | — |
| 11 | 21:10 | 2-B 버전 경로 본체 + A9 arm 원문 힌트 복원 | k0101/40 30s→4.9s |
| 12 | 23:29 | PP arm 키 없는 교차조인 → 측정값 매핑 등가조인 | 원본 minyonglee1/40 64s 원인(L1750 PP arm NL) 해소 65.9→7.8s |
| 14 | 11-05 04:38 | VERLOOP — FCST_C/PRICE_C 룩업을 버전별 바인드 루프, LPC 복수버전 재집계 | MF_W 81/82 457~583s → 1.9~27s |
| 15 | 11:18 | 판가 arm 윈도 좁히기(C 속성을 윈도 밖 4키 재조인) | S2 82 12.6→6.35s |
| 18 | 11:29 | #16/#17 해시 PARTITION 실험 원복 | = 1104A 스냅샷 |
| 19 | 17:31 | KIDPIVOT — 44열 그룹 키를 KID 정수로 압축해 피벗 | 82 fetch 14.2→4.6s |
| 20 | 20:26 | KEYSGRP — LUW 윈도·DISP 제거, SRCA 43열 GROUP BY 로 KEYS | S3 OPEN 20.7→7.9s |
| 22 | 23:17 | DUPSHORT — 12키 중복 0 이면 59열 중복검사·DELETE 생략 | 0.98s 절감 |
| 23 | 11-06 00:45 | LKGTT — 항등 경로 M3R/M5R 을 GTT⋈CAL 인라인 | S3 OPEN 7.87→5.41s |
| 24 | 03:53 | LOCB — LOC9/8/5 원천 1회 물질화 (#23 포함) | S2 6.02→5.77s · **81 회귀 20.7s 발견 → 원인 커서 계획 고착** |
| 25 | 04:40 (1104C) | SZCLASS — S2 INSERT 를 TEMP_SITE_ITEM 행수 구간별 2본(FLT_L/FLT_S) + S3 `/* [SZ:L|S] */` | 소수 행 필터가 먼저 파싱돼도 전체조회 40 4.2/81 5.5/82 10.5s 유지 |
| 26 | 04:50 (1104C) → 06:09 본체 | NOJPPD — 판가 arm 안쪽 질의 `AND ROWNUM > 0`(항상 참) 으로 조인 술어 푸시다운 차단 | 40 site 필터 48.9→1.33s · 전체 회귀 없음 · 소수 행 필터 +0.3~0.7s |

폐기된 실험(재시도 금지 · 근거는 메모리 사본): PIVOT→SUM(CASE)(#9) · 해시 PARTITION(#16/17) · MREF(#21, DISPK 스필 5.5s) · MD5/ORA_HASH 키 조인 · PWAGG(판가 윈도→집계 조인, S2 악화) · S3 SORT GROUP BY 치환 v12~v15(동률) · 소형 룩업 CTE 화(#2 사고).

## 5. 반드시 보고해야 하는 설계 요소 (#25·#26)
1. **SZCLASS**(`build.py` sz_split · 선언 `V_TSI_CNT/V_FNP_CNT/C_SZ_TSI=8192/C_SZ_FNP=50000`): GTT 통계가 없고 세션 DS2 라 S2 정적 INSERT 의 실행계획은 *처음 하드파싱한 세션의 GTT 행수*로 굳는다(PL/SQL 정적 SQL 은 주석을 제거해 주석으로 커서를 나눌 수 없음). 그래서 같은 문장을 마지막 CTE 이름만 다르게(`FLT_L`/`FLT_S`) 2본 두고 TEMP_SITE_ITEM 행수로 분기한다. 의미 동일, sql_id 만 분리.
2. **NOJPPD**(`oneq_blocks.py` 판가 arm A6/A7 X 서브쿼리 `AND ROWNUM > 0`): 힌트는 아니지만 옵티마이저 변환(JPPD)을 막는 장치다. 행 집합 동일. 사용자에게 명시했음(06:25 보고).
3. SP 안 DBMS_STATS 수집 금지(hook #129, 원본 마커 `[E20260812-PERF-NOSTATS]`) · 신규 힌트 금지(사용자 승인 전) · 원문 힌트 L2292(A9 arm) 만 복원 상태.

## 6. 다른 PC 환경 준비
1. 저장소 최신화: 이 폴더의 미추적 파일 111개(측정·프로브·빌드 산출물)가 있다. 올릴 때는 메모리 규칙대로 "소스 올려줘"(NSCM_NEW.git · 전체 작업 트리) 절차를 쓴다. 최소한 이 폴더 전체 + `tools/DbConn/` 가 있어야 한다.
2. DB 접속: `tools/DbConn/dbconn.py` 가 `C:\Projects\NSCM\.env.asis`(gitignore 대상 · **수동 복사 필요**)에서 `TOBE_DB_HOST / TOBE_DB_PORT / TOBE_DB_PDB / TOBE_DB_USER / TOBE_DB_PASS` 를 읽는다(사내오라클 ZIOUI1 · system 계정 · CURRENT_SCHEMA SCM_MGR). 값은 Vibe_Manager 환경설정 또는 기존 PC 의 .env.asis 에서 가져온다(이 문서에 비밀번호 기재 안 함). 접속 확인:
   ```
   python -I -c "import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn'); import dbconn; c=dbconn.connect('tobe', dbconn.load_cfg()); print(c.cursor().execute('SELECT SYS_CONTEXT(''USERENV'',''DB_NAME'') FROM DUAL').fetchone())"
   ```
3. Python 3.11.5 · `oracledb` 4.0.1 (이 PC 기준). 도구는 모두 `python -I <script>` 로 실행하며 경로 `C:\Projects\NSCM\tools\DbConn` 을 하드코딩하고 있다(다른 드라이브면 수정).
4. 10046 프로파일(`profile.py`)은 `V$DIAG_TRACE_FILE_CONTENTS` 로 DB 에서 읽으므로 클라이언트 설치물 불필요.
5. 작업 중 이 PC 에서 겪은 환경 사고: 동적 포트 고갈(SMSNotifier 소켓 16K · WinError 10055 → 재부팅으로 해소) · Bash 도구가 heredoc 안 `\\` 를 `\` 로 접음(파이썬 패치 스크립트는 raw string·`chr(10)` 사용).

## 7. 도구와 명령
| 도구 | 용도 · 사용법 |
|---|---|
| `build.py` | 조립 원천 `00_BACKUP_PKG_DMF0082_1104_BODY.sql`(복제 직후 원문) 에서 GET_MAIN_DATA 만 교체해 `02_PKG_DMF0082_1104_BODY_2B.sql` 생성. `ONEQ_STAGE=2B python -I build.py build`(파일만) / `apply`(FRESH-GATE → 1104 BODY 교체 → ALL_ERRORS) / `restore`(원문 원복) |
| `oneq_blocks.py` | S0~S2 블록(Current 경로 arm 템플릿 · 판가 arm A6/A7 · LOCB · NOJPPD) |
| `oneq_2b.py` | 버전 경로 S2 arm |
| `oneq_split.py` | 룩업 GTT 적재(WS·MEA·LD · VERLOOP) |
| `oneq_s3.py` | S3 동적 SQL(KIDPIVOT·KEYSGRP·DUPSHORT·LKGTT·SZ 토큰) |
| `_apply_as.py <PKG> [drop]` | 현재 빌드 파일을 다른 패키지 이름(1104B/1104C)으로 배포·삭제. 등가 비교가 1104 를 호출 중일 때 재컴파일(ORA-04068) 회피용 |
| `_clone_1104a.py [drop]` | 1104 → 1104A 복제(현재 1104A 는 #18 스냅샷이므로 **재실행 금지**, drop 만) |
| `compare.py <tag> --pkgA PKG_DMF0082_1104A --pkgB <PKG> --scen current,ver,multi,filters --gtt` | 등가 매트릭스 94 시나리오(약 75분) → `_compare_<tag>.out` · `_matrix_<tag>.txt/json`. 표본값은 A 의 Current 호출 직후 세션 GTT 최빈값(사전 데이터셋 금지) |
| `measure.py <PKG> <tag> 3` | 3회 벽시계(proc/fetch)·행수·digest·게이트·원장 변경 감시 → `_measure_<tag>.json/.out` |
| `perf_table.py <orig.json> <new.json>` | 전후 대조표(markdown) |
| `profile.py` | 10046 문장별 시간 귀속(env `QPT_PKG` `QPT_USER` `QPT_VER`) → `_prof*_*.txt` |
| `_plan_probe.py <PKG> <user> <div> AUTO [site=..|item=..|biz=..|project=..|owner=..|team=..|plant=..|qty=Y|none]` | 커서 purge → 필터 호출(하드파싱) → 같은 커서로 전체조회 시간 · S2/S3 자식 계획(`DUMP_PLAN=1`) |
| `_vsql_children.py` · `_s3var.py` · `_s3opt.py` | V$SQL 자식 계획 조사 · S3 변형 실험 harness · 10053 |
| 커서 purge | `DBMS_SHARED_POOL.PURGE(RAWTOHEX(ADDRESS)||','||HASH_VALUE, 'C')` — S2(`INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE%` · PROGRAM=PKG_DMF0082_1104*) + S3(`WITH INTOG AS%`). 원본 커서는 건드리지 않는다 |

## 8. 표준 작업 사이클 (추가 튜닝 시)
1. 룰 Read: `Doc/_rules_v2/anti-simplification.md` → `Doc/_rules_consolidation/TRIGGER_ROUTER.md` → `hooks/oracle-db-workflow.md` · `hooks/db-source-refresh-before-work.md` · hook #129(성능 순서).
2. 원본 FRESH-GATE: `PKG_DMF0082` BODY LAST_DDL = 2026-11-04 14:48:42 인지 확인. 다르면 차이분을 1104 에 먼저 반영.
3. `oneq_*.py` 수정 → `ONEQ_STAGE=2B python -I build.py build` → `python -I _apply_as.py PKG_DMF0082_1104C` 로 사본 배포.
4. 프로파일/프로브로 효과 실측(동시 실행 금지 · 측정값은 시각·출처와 함께 기록).
5. `compare.py kidNN --pkgA PKG_DMF0082_1104A --pkgB PKG_DMF0082_1104C --scen current,ver,multi,filters --gtt` → 94 FAIL 0.
6. `V$ACCESS`(PKG_DMF0082*) 0 · python 세션 0 확인 → `ONEQ_STAGE=2B python -I build.py apply` → VALID · ALL_ERRORS 0 · 마커 수 확인(현재 `ROWNUM > 0` 12 · `FLT_L AS`/`FLT_S AS` 6/6 · LKGTT 3 · LOCB AS 12 · KEYSGRP 1).
7. S2/S3 커서 purge → `measure.py PKG_DMF0082_1104 newNN 3` → `measure.py PKG_DMF0082 origNN 3` → `perf_table.py` → APPLIED_OPERATIONS.md §1 타임라인 + 대조표 기록.
8. 측정·비교가 도는 동안 1104* 재컴파일 금지(ORA-04068 · 커서 무효화). compare 와 measure 동시 실행 금지.

## 9. 금지·주의 (사용자 상시 지시 포함)
- 원본 `PKG_DMF0082` 수정·교체 금지(사용자 결정 전). 클라우드 QA/DEV 미적용.
- 신규 힌트 금지(승인 전) · SP 내 DBMS_STATS 금지 · 원장 테이블 인덱스 생성은 승인 사항.
- 감·예측 수치 금지 — 이번에 실측한 값만 출처·시각과 함께. 못 쟀으면 '미측정'.
- 실저장 시험·사용자 설정 덮어쓰기 금지(이 작업은 조회 SP 만 다룸 · compare/measure 는 ROLLBACK 으로 끝남).
- 보안 에이전트(Somansa SMSNotifier)·무관 python 프로세스 종료 금지 · 파괴적 Git 작업 승인 필요.
- 엔진 작업 후 CheckList 재작성 자동 제안 금지.
- 보고는 한국어 · 단순 질문은 짧게.

## 10. 사용자 결정 대기 항목 (06:25 보고 기준)
1. 원본 `PKG_DMF0082` 를 1104 본체(#26)로 교체
2. 클라우드 QA/DEV 이관 패키지 생성(`tools/CloudPkg/cloud_pkg.py`)
3. GTT SHARED 통계 재적용(원본 계획도 바뀜)
4. `DM_PLN_CFM_SELLING_PRICE` (DIV, PROJECT, SITE, ITEM) 인덱스
5. 사본 정리: `python -I _clone_1104a.py drop` · `python -I _apply_as.py PKG_DMF0082_1104B drop` · `python -I _apply_as.py PKG_DMF0082_1104C drop`
6. APPEND 힌트(S2 최종 INSERT 1.3~2.0s) · 추가 튜닝 진행 여부(82 S3 출력·fetch)
7. 원문 이상 동작 5건(계획 §Context) 수정 여부

## 11. 다음 레버 후보 (각각 실측 전 효과 미측정 · 프로파일 출처 `_prof27/28_1104C_minyonglee1_82.txt` · `_prof29_1104_k0101_81.out`)
- S3: SRCA 적재 3.2s · DISPK/피벗 1.6s · fetch(82 5~6s, 행 16K × ≈410 PIVOT 열)
- S2: BASE 판가 윈도 1.7s · CUR LOC9/8/5 LEFT JOIN 1.8s · 최종 INSERT 2.0s(APPEND 승인 사항)
- S1: 마스터 룩업 NL 0.7s 형태 변경
- 구조적: GTT 통계(사용자 결정) · 판가 테이블 인덱스(사용자 결정)

## 12. 주요 파일 인벤토리
| 파일 | 내용 |
|---|---|
| `00_BACKUP_PKG_DMF0082_1104_BODY.sql` | 복제 직후 원문(968,114자) · 조립 원천 · restore 대상 |
| `02_PKG_DMF0082_1104_BODY_2B.sql` | 현재 빌드 = #26 (1104 본체·1104C 와 동일) |
| `_body_24_build.sql` / `_body_25_build.sql` | #24 / #25 빌드 보존본 |
| `_build_before25.py` · `_oneq_s3_before25.py` · `_oneq_blocks_before26.py` · `_oneq_blocks_before24.py` · `_oneq_2b_before24.py` | 패치 전 백업 |
| `_oneq_blocks_pwagg_rejected.py` | 폐기 실험(PWAGG) |
| `_compare_kid24.out` · `_matrix_kid24.*` | 최신 등가 증명 |
| `_measure_*h.*` · `_perf_table_h.out` | 최종 측정 |
| `_compare_*` · `_matrix_*` · `_measure_*` · `_prof*` · `_plan_probe*` · `_s3var_*` · `_s3opt_*` · `_s2_*children*` · `_cursor_survey_24.txt` · `_ash_div40_223.txt` | 회차별 등가·측정·프로파일·진단 기록(시각 = 파일 내 타임스탬프) |
| `_s3_<user>_<div>*.sql` | S3 동적 SQL 덤프(실험 입력) |
| `STEP_MAP.md` | 원 STEP(L번호) ↔ 새 CTE 대조표 · 이상 5건 재현 위치 · SZCLASS/NOJPPD/LOCB 행 |
| `APPLIED_OPERATIONS.md` | 타임라인(§1) · 대조표 §1-1~§1-3 · 되돌리기(§2) · 미적용(§3) |
| `HANDOFF_plan_copy.md` · `HANDOFF_memory_copy.md` | 이 PC 밖 파일 복사본(계획 · 메모리) |

## 13. 함정 목록 (실제로 겪은 것)
- EXPLAIN PLAN(바인드 리터럴)은 실행 계획과 다르다 → 10046/V$SQL_PLAN 실행 자식으로만 판단.
- 같은 문장도 V$SQL 자식마다 계획이 다르고 **처음 파싱한 데이터 크기로 굳어 전 세션에 공유**된다(81 회귀 20.7s 사건). 측정 전 purge · SZCLASS 가 방어.
- GTT 무통계에서 소형 룩업을 CTE 로 바꾸면 카티션·NL 로 32분+ (#2).
- 키 없는 교차조인·2식 NULL-안전 조인은 HASH JOIN 폭주(#7 450s).
- compare 표본 추출은 ROLLBACK 전에 · GTT(PRESERVE) 행도 트랜잭션 단위.
- 바인드 술어 arm 은 FILTER 로 단락되지 않으므로 S2 는 사업부·경로별 정적 INSERT 본을 PL/SQL IF 로 고른다(동적 SQL 금지 — 클라우드 QA 는 바인드 피킹 없음).
- Bash 도구 heredoc 의 `\\` 접힘 · `V$SQL_PLAN_STATISTICS_ALL` 에 LAST_TEMP_SPACE 열 없음 · DBMS_SHARED_POOL.PURGE 는 `RAWTOHEX(ADDRESS)||','||HASH_VALUE` 문자열로.

## 14. 다른 PC 에서 첫 프롬프트 예시
> `_artifacts/_apply_corporate/DMF0082_1104_ONEQUERY_20261104/HANDOFF.md` 를 읽고 PKG_DMF0082_1104 작업을 이어서 진행. 현재 1104 본체 = apply #26, 측정 h 보고 완료. 다음 할 일 = (사용자 지시).
