# DMF0014 Excel Upload — 클라우드 DB 재반영 패키지 (2026-09-15)

## 증상
클라우드 DMF0014 Excel Upload 시 예전과 같은 SQL ERROR 재발 → DB 객체가 보완 전 소스로 되돌려진 것으로 추정.
사내 ZIOUI1 에서도 같은 계열 원복이 확인됨(`PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40` NLSDATE 소실, 09-11 09:29:58 — 오늘 재반영).

## ⚠ 클라우드는 직접 조회 불가 — 반드시 00_PRECHECK 먼저
작성자는 클라우드 DB 접속 수단이 없다. 어떤 객체가 되돌려졌는지는 **00_PRECHECK 결과로만** 판정한다.

## Excel Upload 경로와 포함 객체 (사내 현재 원문 = 오늘 검증본)
| 단계 | 객체 | 파일 |
|---|---|---|
| ① 업로드 설정 | `SCM_ADM_EXCEL_COLUMNS` (DMF0014/FCST Upload) | `30_EXCEL_COLUMNS_DMF0014.sql` (멱등 MERGE) |
| ② 임시적재 · ④ 결과 | `PKG_NSCM_UI_EXCEL` **(공용 — 전 화면 Excel Upload)** | `10_` SPEC · `11_` BODY |
| ③ 검증 · ⑤ 저장 | `PKG_DMF0014` | `12_` SPEC · `13_` BODY |
| ⑤ 저장 후 반영 | `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` / `_40` | `14_` · `15_` |

객체별 사내 LAST_DDL · 줄수 · 수정 마커 = `_MANIFEST.md`.

## 적용 절차 (SCM_MGR 접속, SQL*Plus/SQLcl/SQL Developer 스크립트 실행)
1. `@00_PRECHECK.sql` — **조회 전용**. 행마다
   - `EXPECTED_MISSING` : 사내 보완 마커 중 클라우드에 **없는** 것 → 값이 있으면 그 객체는 **보완 전 소스**
   - `CLOUD_ONLY_MARKERS` : 클라우드에만 있는 수정 마커 → 값이 있으면 **그 객체는 전체교체 금지**(결과 공유 요청)
   - EXCEL_COLUMNS 행 `DIFF_*` = 사내 값과 차이
2. `EXPECTED_MISSING` 이 있고 `CLOUD_ONLY_MARKERS` 가 빈 객체만 해당 파일 실행
   (SPEC 과 BODY 가 같은 객체면 SPEC → BODY 순서)
   - `PKG_NSCM_UI_EXCEL` 은 공용이므로 **해당 행에 누락이 있을 때만** 실행
3. `DIFF_*` 가 있으면 `@30_EXCEL_COLUMNS_DMF0014.sql`
4. `@90_VERIFY.sql` — 전 객체 VALID · USER_ERRORS 0 · INVALID 0 · SCMP_APP 시노님/EXECUTE 존재
5. 화면에서 Excel Upload 재시도 (패키지 상태변수 없음 → BE 재기동 불요)

## 사내 사전 검증 (2026-09-15)
- 각 파일 본문 == 사내 DB 원문 (6/6 일치)
- 00_PRECHECK 사내 실행: 전 객체 `EXPECTED_MISSING`·`CLOUD_ONLY_MARKERS` 공란, EXCEL_COLUMNS `SAME/SAME`
- 판정 로직 자가시험: 기대 마커에 가짜 `E20991231-FAKEPROBE` 주입 → `EXPECTED_MISSING` 에 정확히 검출

## 적용 후에도 오류가 나면
화면/BE 로그의 **ORA 오류 전문**을 알려 주세요. DB 가 최신인데도 나면 BE(`FileServiceImpl`/`ExcelUtils`)·FE 이관본 차이일 수 있습니다.

## 원복
적용 전 클라우드 원문을 먼저 백업: `SELECT TEXT FROM USER_SOURCE WHERE NAME='<객체>' AND TYPE='<타입>' ORDER BY LINE;` 결과 보관.
