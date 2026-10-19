# DMF0082 조회 — MF_SP INSERT lateral 해소 (hook #129 1순위, 클라우드 이관 · 패치형)

> 마커 `[E20261012-DMF0082LATFIX]` — PKG_DMF0082 BODY 의 GET_MAIN_DATA 1곳 + History 2줄만 변경. 힌트·데이터·GTT·메타 변경 없음.

| 항목 | 값 |
|---|---|
| 증상 (클라우드 QA 10-12 R01~R07) | 조회 중앙값 40 18s · 81 10s(10-11 이후 31~35s) · 82 10s. 메저 9개 조건에서 MF_SP INSERT(`18xg1y5298qgq`) 5~17s, 결과 PIVOT 5~13s, 판가 4~10s |
| 원인(이번 분) | MF_SP INSERT 의 VD 인라인뷰(`SCM_MST_SITE` 82 `VMI_STD_DIO` 선집계) ON 절에 바인드 상수조건 `p_division_id='82'` → 옵티마이저가 집계 뷰를 lateral(`VW_LAT_62E7BAE7`)로 전개, F(`GT_DMF0082_TEMP_FCST_N_PRICE`) 행마다 `MERGE JOIN OUTER`+`BUFFER SORT` 재평가 (클라우드 R05 P0 · 사내 동일 구조) |
| 조치 | 조건을 뷰 WHERE 안으로 이동. 등가 = 비82 → 뷰 0행 → LEFT JOIN 미매칭 → NULL(기존 ON 거짓과 동일) / 82 → 동일 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-12 10:31:26) — 복제본 6커서 전행 동등성 40/81/82 × minyonglee1(1메저)/k0101(9메저) **6/6 PASS**(행 순서까지) · 적용본 재검증 PASS · MF_SP INSERT 1회 CPU 1.15s→0.47~0.64s(1메저) · 1.33~1.70s→0.95~1.51s(9메저) · 계획 `VW_LAT`·`MERGE JOIN` 소멸. [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_LATFIX_20261012/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 왜 패치형인가 | 클라우드 BODY(10-09 12:08, 17032/885680)에는 사내 AJS 10-08·10-11·10-12 수정이 없다. 사내 전체본을 올리면 타 작업자 변경을 함께 배포하게 되므로, **클라우드의 USER_SOURCE 를 읽어 앵커 1곳만 치환**하는 PL/SQL 블록으로 적용한다 (00 에서 앵커 1건 확인 → 10 치환 → 90 검증) |
| BE 재기동 | 불요 |
| 기대 효과 | MF_SP INSERT 구간 CPU 약 40~60% 감소(클라우드 5.3/7.7/16.7s 기준 2~8s). 조회 전체(3초 목표)는 결과 PIVOT fetch·판가 82·클라우드 행당 CPU 가 남아 다음 라운드 |
| 1-b(GROUP BY 제거) 불채택 | 복제본 6커서 6/6 PASS 였으나 시나리오 매트릭스 `Current,MF_W_…`(복수 버전) 에서 **FAIL**(81 결과 7,674→8,602행) — 중복제거 블록의 키가 전 컬럼(VERSION_NO 포함)이라 MF_SP GROUP BY 키 유일성은 구조적으로 보장되지 않음(복수 버전은 원본이 SUM/MAX 로 합침). 결과 동일 요건 위반 → 폐기. 파일은 `_not_shipped_NOGRPBY/` 에 보관(적용 금지) |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 `N=1 PASS` · L2 마커 0 · L3 VW_LAT=1(고칠 대상) · L4 실행중 세션 없음 |
| 2 | [A_DB/10_APPLY_LATFIX_PATCH.sql](A_DB/10_APPLY_LATFIX_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 마커 2 PASS · V2 VALID/ERR 0/DEP_INVALID 0 · V3 뷰 WHERE 안에 `AND    p_division_id = '82'` · V4 `OK` 3줄 · V5 `VW_LAT=0 MERGE_JOIN=0 PASS` |

롤백: [A_DB/99_ROLLBACK_LATFIX_PATCH.sql](A_DB/99_ROLLBACK_LATFIX_PATCH.sql) (역치환, 마커 0 확인 후 CREATE OR REPLACE). 사내에서 00→99→10→90 왕복 리허설 완료(§리허설).

## 주의
- 10 은 `CREATE OR REPLACE PACKAGE BODY` 라 실행 중 세션이 있으면 library cache pin 대기 — 00 L4 로 확인 뒤 한가할 때 실행.
- 10 적용 직후 첫 조회는 하드파싱 1회(GTTSTATS SHARED 통계가 있어 10-09 류 1행 추정 재발 없음 — 90 V5 에서 PHV 확인).

## 리허설 (사내 ZIOUI1, `_rehearsal_out/`)
- 10:46 — 99(역치환 → 마커 0, VALID) → 10(치환 → `APPLIED … 마커 2곳`, VALID) → 90(V1 2 PASS · V4 40/81/82 OK · V5 패치 문장 VW_LAT 0) → 00(L1 앵커 0 = 적용 상태, L2 마커 2). PL/SQL 상수는 한글 바이트 때문에 VARCHAR2(32767) 로 선언(첫 리허설 ORA-06502 → 정정).
- 90 V4 소요는 사내 DB 가 타 작업자 인덱스 재생성(병렬 8, 4시간↑) 중이라 수십~수백 초 — 시간값은 참고 금지, 행수·VALID·계획만 본다.
