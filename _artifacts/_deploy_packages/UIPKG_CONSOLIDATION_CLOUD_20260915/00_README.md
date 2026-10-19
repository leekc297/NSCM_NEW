# UIPKG_CONSOLIDATION_CLOUD_20260915 — UI별 standalone SP → PKG 취합 클라우드 이관

> 빌드 2026-09-15 21:03 · 원천 = 사내 ZIOUI1 적용·검증본 (`_artifacts/_apply_corporate/UIPKG_CONSOLIDATION_20260915/`)
> ⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 · 모든 객체 SQL 머리 `SOURCE-FRESH`(사내 추출 시각) — 24시간 경과·사내 재변경 시 `python build_cloud.py` 재빌드

## 개요
- 대상: 15 PKG · standalone 43건 (목록 원본 `Doc/화면분석서/TOBE_UI별_PKG전환대상_20260914.md`, 09-15 재조회 확정)
- 원칙: standalone 본문 무수정 이관(동일명 기존 멤버는 META 실사용 standalone 본문으로 교체 — PKG_DMF0008 AJS 멤버 포함) · 내부 호출은 PKG 멤버로 전환
- 신규 PKG: `PKG_SYS0012` · 신규 앱계정 권한/시노님: `PKG_DMF0008`, `PKG_SYS0012`
- 부수 영향: 이관된 본문의 `$$PLSQL_UNIT` 이 PKG 이름을 반환 → `SCM_SYS_LOG_BATCH.PROGRAM_NAME` 표기가 PKG 이름으로 바뀜(조회 로직 영향 0 확인)

## PKG 목록
| PKG | 대상 SP | BODY 교체 | 외부 호출부 | META 전환 | API 버튼 | 상세 |
|---|---:|---|---:|---|---:|---|
| PKG_DMF0000 | 1 | - | 0 | - | 0 | [README](PKG_DMF0000/README.md) |
| PKG_DMF0003 | 1 | Y | 2 | - | 0 | [README](PKG_DMF0003/README.md) |
| PKG_DMF0006 | 1 | Y | 1 | - | 0 | [README](PKG_DMF0006/README.md) |
| PKG_DMF0007 | 1 | Y | 0 | - | 0 | [README](PKG_DMF0007/README.md) |
| PKG_DMF0008 | 7 | Y | 0 | Y | 12 | [README](PKG_DMF0008/README.md) |
| PKG_DMF0014 | 3 | Y | 0 | - | 0 | [README](PKG_DMF0014/README.md) |
| PKG_DMF0020 | 1 | Y | 2 | - | 0 | [README](PKG_DMF0020/README.md) |
| PKG_DMF0040 | 1 | Y | 0 | Y | 1 | [README](PKG_DMF0040/README.md) |
| PKG_DMF0043 | 10 | Y | 1 | Y | 11 | [README](PKG_DMF0043/README.md) |
| PKG_DMF0048 | 1 | - | 0 | Y | 1 | [README](PKG_DMF0048/README.md) |
| PKG_DMF0072 | 5 | Y | 0 | Y | 5 | [README](PKG_DMF0072/README.md) |
| PKG_DMF0082 | 3 | Y | 0 | Y | 1 | [README](PKG_DMF0082/README.md) |
| PKG_SYS0012 | 3 | Y | 0 | Y | 3 | [README](PKG_SYS0012/README.md) |
| PKG_SYS0014 | 4 | Y | 0 | Y | 4 | [README](PKG_SYS0014/README.md) |
| PKG_SYS0017 | 1 | Y | 0 | - | 0 | [README](PKG_SYS0017/README.md) |

## 전체 적용 순서 (환경별 · QA → DEV)

### 0. 준비
1. 모든 PKG 폴더의 `00_PRECHECK.sql` 을 먼저 실행해 **DIFF · ⚠ABSENT · MISSING 이 하나도 없는지** 확인. 하나라도 있으면 전체 중단·결과 공유
2. 교체할 객체(10/11/12 대상)의 클라우드 현재 원문을 백업(각 PKG README §원복)

### 1. DB 객체 (SCM_MGR)
1. `00_COMMON/00_RECOMPILE_INVALID_STANDALONE.sql`
2. PKG 폴더를 **아래 순서**로 각 README ②(10 → 11 → 12) 실행
   `PKG_DMF0000`(본문 없음) → `PKG_DMF0003` → `PKG_DMF0006` → `PKG_DMF0007` → **`PKG_DMF0008`(PKG_DMF0000 멤버 호출)** → `PKG_DMF0014` → `PKG_DMF0020` → `PKG_DMF0040` → **`PKG_DMF0043`(11_BODY 직후 반드시 12_CALLER_DMF0043_GET_MAIN_SPREAD_TITLE)** → `PKG_DMF0048`(본문 없음) → `PKG_DMF0072` → `PKG_DMF0082` → **`PKG_SYS0012`(신규)** → `PKG_SYS0014` → `PKG_SYS0017`
3. `00_COMMON/90_RECOMPILE_DEPENDENTS.sql`
4. 각 PKG `20_GRANT_SCM_MGR.sql` (SCM_MGR) → `21_SYNONYM_SCMP_APP.sql` (**SCMP_APP**)
5. 각 PKG `90_VERIFY.sql` — 전부 VALID·SAME·ERRORS 0
6. 화면 실측(내부 호출 전환분 — 저장 경로)

### 2. META 전환 (SCM_MGR)
1. META 전환 대상 8 PKG(DMF0008·0040·0043·0048·0072·0082·SYS0012·SYS0014) `30_META_SWITCH.sql` → DMF0043 은 `31_PROC_M_DATATYPE_FIX.sql` 추가
2. 각 `38_META_VERIFY.sql` → 화면 실측(조회·저장 버튼) · 실패 PKG 는 `39_META_ROLLBACK.sql`

### 3. standalone 정리 (화면 실측 완료 후 · 담당자 판단)
1. 각 PKG `40_DROP_STANDALONE_SCM_MGR.sql` (가드 통과분만 삭제) → `41_DROP_SYNONYM_SCMP_APP.sql` (SCMP_APP)
2. 원복 필요 시 `49_RESTORE.sql`

## ⚠ 주의
- `PKG_DMF0043` : 11_BODY 적용 순간 기존 멤버가 `P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE` 로 바뀐다 → **12_CALLER_DMF0043_GET_MAIN_SPREAD_TITLE 를 바로 이어서** 실행해야 standalone 래퍼·`DMF0043_GET_CONTRIBUTE_MAIN_DATA` 가 INVALID 되지 않는다(사내 18:58 실측 — 1분간 INVALID 후 보정).
- DIFF 판정 PKG 는 전체교체 금지 — 클라우드에만 있는 수정이 사라진다. 결과 공유 후 차이분 병합본을 다시 만든다.
- 범위 밖 발견(미조치): PROC_M `DATA_TP_CD='VARCHAR2'` 행이 SCM0005 11행 · SCM0008 11행 · DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL 1행에 존재 — 값이 비어 호출문이 깨질 수 있음(별도 확인 권장).

## 사내 검증 근거
- STEP 2 `VERIFY.md` 멤버 43 시그니처·코드 동일 0 불일치 · 신규 INVALID 0
- STEP 3 `VERIFY.md` API 38 · PR_GET_PROC_INFO_LIST 해석 전부 PKG 멤버 · BE 실호출 17 API 성공(mainTitle 은 PROC_M 결함 정정 후 125행)
- STEP 4 `JUDGE.md` 43 PASS (판정 전용) · 음성 시험(사용중 SP → SKIP) 확인
- STEP 5 PRECHECK 사내 자가시험: 교체 객체 32 POST · standalone 43 SAME · 가짜 해시 → DIFF 검출
- 누락 게이트: 사내 적용 작업 원장(`02_apply/APPLIED_OPERATIONS.md`) 파일 47건 전부 폴더 포함
