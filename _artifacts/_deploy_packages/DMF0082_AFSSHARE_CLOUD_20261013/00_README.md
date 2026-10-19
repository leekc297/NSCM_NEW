# DMF0082 조회 — MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 (클라우드 이관 · 패치형)

> 마커 `[E20261013-DMF0082AFSSHARE]` — PKG_DMF0082 BODY 조회 프로시저 2종에 MERGE 1문장씩 삽입. 기존 문장·원장·저장·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 | MKT_FCST 에 AS From Site 값이 있으면 같은 키의 다른 행에도 같이 보이고 셀 병합이 되게 (2026-10-13) |
| 종전 | AS From Site 는 수요 원장에만 저장돼 LOC 등 다른 메저 행은 빈칸 (AS-IS 도 동일) |
| 보완 | 조회 결과 안에서 MKT_FCST 행의 값을 같은 키의 빈 행에 채운다 |
| 키 | Division · Project · End Customer · Sales Site · Model · Customs Handbook · Fcst Type · Incoterms · Plant Site · Cell Prod Site |
| 채우지 않는 경우 | 자기 값이 있는 행 · MKT_FCST 행 자신 · 한 키의 MKT_FCST 값이 둘 이상 · 결과 컬럼에 AS From Site 가 없는 조회(40) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-13 18:21 → 리허설 재적용 18:25:18) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_AFSSHARE_20261013/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커 `N=2 PASS` · L2 마커 0 · L3 대상 품목 수 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_AFSSHARE_PATCH.sql](A_DB/10_APPLY_AFSSHARE_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 불일치면 ORA-20001 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(2) · V2 VALID/오류 0 · V3 4줄 · V4 화면 확인 대상 |

롤백: [A_DB/99_ROLLBACK_AFSSHARE_PATCH.sql](A_DB/99_ROLLBACK_AFSSHARE_PATCH.sql)

적용 뒤 화면 확인: 90 의 V4 `SAMPLE_SITE` 로 81 을 조회해, MKT_FCST 행과 같은 품목의 LOC 행에 같은 AS From Site 가 보이고 셀이 병합되는지 본다.

## 주의
- **패치형이다.** 클라우드 원문을 읽어 AS From Site 빈값 정규화 문장 뒤 2곳에만 끼워 넣는다. 앵커가 맞지 않으면 원문을 건드리지 않고 중단한다 → 00 의 L1 결과를 회신.
- **사내에서는 값이 있는 실제 데이터로 확인하지 못했다.** 사내 원장에 당주 이후 AS From Site 값이 있는 MKT_FCST 행이 없어, 값이 있을 때의 동작은 모의 행 테스트로만 확인했다. 클라우드 화면 확인이 첫 실데이터 확인이다.
- **AS-IS 와 다르게 가는 변경이다.** AS-IS 는 판가 행의 AS From Site 를 항상 빈칸으로 내려준다.
- 같은 메저 안에서 값 있는 주차와 빈 주차로 2행으로 나뉘던 행은 1행으로 합쳐진다(MKT_FCST 자신은 제외).
- 채워진 값이 보이는 수요 메저 행(SCM_FCST · VMI_In_Req · AS_In_Req)을 수정·저장하면 그 행의 원장에도 그 값이 기록된다. LOC 저장은 종전대로 기록하지 않는다.
- 같은 BODY 를 고치는 `DMF0082_MANDRET_CLOUD_20261013`(적용 완료) 등과는 구간이 달라 순서 무관.
- 10 은 패키지 BODY 재생성이라 DMF0082 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 실행.

## 리허설 (사내 ZIOUI1 2026-10-13 18:25, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 2건 PASS · L2 0) → 90(V1 미적용) → 10(`APPLIED … 마커 2곳`) → 10(`SKIP` 멱등) → 90(V1 PASS · V3 4줄) → 00(L2 2).
리허설 뒤 전후 비교 16케이스 · 모의 행 테스트 재실행 PASS.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 2곳 삽입 (조회 프로시저 2종) | A_DB/10_APPLY_AFSSHARE_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
