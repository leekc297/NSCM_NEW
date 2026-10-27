# DMF0020_SAVECLOB_CLOUD_20261021 — Batch Price Input·메인 Save 대량 저장 "SQL ERROR" 보완 (클라우드 패치, DB 만)

- 마커: `[E20261021-DMF0020SAVECLOB]` 44곳 (PACKAGE BODY) · 대상: `SCM_MGR.PKG_DMF0020` SPEC+BODY 두 저장 프로시저 + `SCM_ADM_PROC_M` 33행
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 (2026-10-21 20:12) · 리허설 00→10→90→99→00→10→90 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (md5 대조)
- **FE·BE 무변경 · BE 재기동 불필요** (PROC_M 은 호출마다 조회)

## 원인 (클라우드 진단 결과 2026-10-21 19:55, `A_DB/01_DIAG_CLOUD_SAVE_ERROR.sql`)
| 항목 | 값 |
|---|---|
| 저장 1회 행 수 | 335,745 |
| 페이로드 | 39.5MB (파라미터 최대 5,618,483자) |
| 저장 SP 입력 타입 | VARCHAR2 (한도 32,767자) |
| BE 예외 | InvocationTargetException (SP 진입 전 바인드 실패) |

- ① 입력 17종이 VARCHAR2 라 32,767자를 넘는 순간 호출 자체가 실패 → 화면 "SQL ERROR".
- ② 한도를 풀어도 분할(REGEXP … CONNECT BY LEVEL)·LOC 맞추기 상관 UPDATE 2개·보충 INSERT 의 DECODE NOT EXISTS 2개가 행 수의 제곱으로 느려져 335,745행은 약 2시간(사내 3,000/6,000/12,000행 = 0.8/2.7/10.9초 실측 외삽).

## 무엇이 바뀌나
| # | 대상 | 변경 |
|---|---|---|
| S1/B1 | `_ALL` IN 17종 · `_POPUP` IN 16종 | VARCHAR2 → CLOB |
| A2/A3 | `_ALL` 분할 | CLOB 선형 분할 함수 + FORALL 적재 (식은 원문 그대로: TRIM · NVL '/' · ITEM 제어문자 제거 · 숫자 변환 기본 0) |
| A4 | `_ALL` 예외 진단 JSON | SQL RETURNING CLOB + 4000 절단 (대량 시 진짜 오류가 ORA-40478 로 가려지는 것 방지) |
| A5/A6 | `_ALL` LOC 통화·ACTIVE_FLAG 맞추기 | 상관 UPDATE → LOC 집계 1회 + MERGE |
| A7/A8 | `_ALL` KRW·USD 보충 INSERT | NOT EXISTS 키 비교 DECODE(x,y,1,0)=1 → NVL(x,CHR(0)) 등호 (둘 다 NULL=NULL 동일 취급) |
| P2~P4 | `_POPUP` (Range 팝업 재저장) | 홀더 VARCHAR2(32767) → 토큰 컬렉션 · WHILE/INSTR/SUBSTR 루프 → 인덱스 루프 |
| M1 | `SCM_ADM_PROC_M` | 두 PROC_NM IN 33행 DATA_TP_CD VARCHAR → CLOB (BE jdbcType=CLOB 바인딩) |
- 원문 구간은 모두 `/*[E20261021-DMF0020SAVECLOB] BEGIN-ORIG …*/` 주석으로 보존 → 99 원복은 자기 소스에서 복원.
- 원장 처리(삭제·삽입·이력·Sales Plan 재계산)·검증 문구·메타(그 외)·권한·GTT 정의 무변경. 메인 Save 와 Batch Price Input 은 같은 `_ALL` 이라 함께 보완된다.

## 사내 검증 (ZIOUI1)
| 시험 | 결과 |
|---|---|
| 동치 — `_ALL` 경계값 300행(빈 INCOTERMS·탭 ITEM·'abc'/빈 가격·LOC 만 있는 키) 수정 전/후 GTT 상태 | 300행 완전 일치 |
| 동치 — `_POPUP` 분할 구간 290행 | 완전 일치 |
| 동치 — A5~A8 원문 4문장 vs 새 4문장, 무작위 300/2,000/5,000행(NULL·통화 불일치·D 플래그·메저 누락 포함) | 단계별 상태 전수 일치 |
| 속도 — 검증 단계까지 12,000 / 36,000 / 120,000 / 335,700행 | 0.2 / 0.6 / 1.8 / 5.1초 (패치 전 12,000행 10.9초) |
| 실제 저장 `_ALL` 15,000 / 45,000 / **335,700행** (원장·이력·Sales Plan 에 없는 82 키, 끝나고 삭제) | 5.0 / 7.3 / **47.9초 · SUCCESS · 원장·이력 335,700행 정확** |
| 실제 저장 `_POPUP` 20 / 500 / 3,100 LOC 입력 | 0.6 / 0.6 / 0.8초 · success · 원장 3배(LOC·KRW·USD) 정확 |
- 테스트 행 잔존 0 확인 (원장·이력).

## 남은 확인 (사내에서 못 한 것)
- **BE 경유 화면 저장은 미검증**: SP 는 DB 안에서 CLOB 변수로 호출해 검증했다. BE 의 CLOB 바인딩 경로(PROC_M CLOB)는 DMF0082 저장(10-01 이후 운영 중)과 같은 방식이다.
- **335,700행 저장 47.9초 중 36.7초 = 원장 저장 직전 DELETE** (원장 1,147만 행 인덱스 전체 읽기 + 해시 조인). 튜닝 규칙(#129)상 클라우드 실측 전 수정하지 않았다. 클라우드에서 타임아웃이 나면 `01_DIAG` 의 D3/D4 결과(소요 시간)를 회신 → 이 문장만 별도 보완.
- 클라우드 BE 는 저장 파라미터 전체(39.5MB)를 SQL 로그에 남긴다 — 저장 시간·DB 용량에 부담(BE 영역, 가이드 대상).

## 클라우드 원문 대조 (2026-10-21 22:40)
- 1차 10 실행이 `ABORT - anchor e_invalid_data EXCEPTION;\n\nBEGIN 0` 으로 중단(원문 무변경). 원인 = 클라우드 BODY(10-15 11:58, 9,430줄)는 사내 원문(10,212줄)에서 **빈 줄만 제거된 판** — 빈 줄 외 9,421줄 완전 일치 · SPEC 동일.
- 보완: 빈 줄을 포함하던 앵커(P2B)를 빈 줄 비의존으로 · 구간 지문은 사내판/클라우드판 두 값 허용(P4 8,829/8,804자).
- 검증: `02_EXPORT_CLOUD_SOURCE.sql` 로 받은 클라우드 원문에 **실제 10/99/00 PL/SQL 로직을 사내 DB 메모리에서 실행**(컴파일 없음) → 10 결과 == 시뮬레이터 적용본 · 99 결과 == 클라우드 원문 · 00 FAIL 0. 클라우드 적용본 = 사내 적용본(VALID)과 빈 줄 외 동일.

## 실행 순서 (전부 전체 F5, 값 입력 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 0 | `A_DB/01_DIAG_CLOUD_SAVE_ERROR.sql` · `A_DB/02_EXPORT_CLOUD_SOURCE.sql` | (진단·원문 내보내기 — 이미 실행함) | |
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 전부 PASS · L2 마커 0 · L3 VARCHAR · L5 0행 | **L1 FAIL 이면 10 실행 금지·결과 회신** (클라우드 BODY 는 10-15 11:58 판이라 사내와 다를 수 있음 — 지문으로 판정) |
| 2 | `A_DB/10_APPLY_SAVECLOB_PATCH.sql` | `APPLIED - PKG_DMF0020 SPEC/BODY VALID · markers 44 · PROC_M updated 33 (CLOB rows 33)` | `ABORT - …` = 원문 무변경. `COMPILE FAILED` = 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/0/0 · V3·V4 CLOB 17/16 PASS · V5 전부 VALID · V6 PASS | 회신 |
| 4 | 화면 DMF0020 Batch Price Input 대량 저장 | 저장 성공 | `01_DIAG` 재실행 결과 회신 |
| 원복 | `A_DB/99_ROLLBACK_SAVECLOB_PATCH.sql` | `ROLLED BACK - … markers 0 · PROC_M VARCHAR restored 33` | 회신 |

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터: 수정 전→적용 == 적용본, 적용본→원복 == 수정 전)
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과 · `_build_meta.json` — 지문·md5
- 사내 적용 기록·시험 스크립트: `_artifacts/_apply_corporate/DMF0020_SAVECLOB_20261021/`
