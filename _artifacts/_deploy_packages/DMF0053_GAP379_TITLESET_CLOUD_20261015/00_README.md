# DMF0053_GAP379_TITLESET_CLOUD_20261015 — Customer FCST Waterfall 사용자별 칸·Measure 설정 이관 (데이터, DB 만)

- 마커: `[E20261015-GAP379]` (SQL 머리) · 대상 테이블: `SCM_MGR.SCM_MST_TITLESET_USER` (PROGRAM_ID='DMF0053', SHEET_NAME='CUST Fcst Waterfall')
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순 · **FE·BE·PKG 무변경, BE 재기동 불필요**
- 사내 ZIOUI1: 적용 완료(2026-10-15 20:57) — `_artifacts/_apply_corporate/DMF0053_GAP379_20261015/APPLIED_OPERATIONS.md`

## 무엇을 넣나
- AS-IS 사용자가 저장해 둔 칸 구성·순서·정렬 방향(C)과 Measure 선택(M) 을 TO-BE 로 옮긴다. 원천은 AS-IS `LESDFPSTO1C01/LGCE_SCMDEV` 이고 2026-10-15 20:45 에 조회했다. DMF0053 은 162행(C 132행/8명, M 30행/15명)이다.
- ⚠ GAP 기재 "AS-IS 604행(C 463/23명)" 은 접속 가능한 AS-IS DEV 와 수치·사용자가 다르다. hwayoung.lim·yeo0422 는 DEV 에 없다. 그 604행 원천 DB 의 추출본을 주면 같은 생성기로 재생성한다.
- 판정은 실행하는 DB 기준이다(사내 전값을 WHERE 에 고정하지 않음). 셋 다 만족하는 행만 INSERT 한다.
  1. 칸 이름 확인: C 는 `SCM_MST_SHEET_COLUMNS`, M 은 `SCM_MST_SHEET_MEASURE`(VALID_YN='Y') 에 있어야 한다. 없는 칸이 들어가면 조회 정렬식에서 ORA-00904 가 나므로 반드시 거른다.
  2. PK 가 이미 있으면 넣지 않는다.
  3. 그 사용자가 같은 유형(C/M) 설정을 이미 갖고 있으면 넣지 않는다. TO-BE 에서 새로 만든 설정을 보존하기 위해서다.
- 멱등이다(재실행 시 0행). 비파괴다(기존 행을 변경·삭제하지 않음). 감사 4컬럼은 AS-IS 원값을 보존한다(사용자 개인 설정).

## 사내 검증 (ZIOUI1)
- 트랜잭션 안에서 이관 → 실제 조회 → ROLLBACK 으로 확인했다(`verify_txn.py`). FE 실전송값(81 · 2026-09-01~2027-02-28 · ONLY_WEEKLY) 에서 사용자만 바꿔 썼다.
  - 칸 설정 이관 8명 + Measure 만 이관 3명 = **11/11 PASS**. 오류 0, 결과코드 0 이었다.
  - 칸 제목이 기본 47칸에서 사용자 설정(39~46칸)으로 바뀌었다.
  - 정렬식이 AS-IS 칸 순서와 **순서까지 일치**했다.
- 리허설 순서: 00 → 10 → 90 → 10(재실행) → 99 → 90 → 10 → 90. 결과는 다음과 같다.
  - 이관 후: C 80→212행 / M 8→38행. 기존 TO-BE 4명 88행은 보존됐다.
  - 재실행 시 건수 동일, 99 후 반영 0, 재적용 후 132/30 반영, 무효 칸 0.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK.sql` | P2 메타 66 / 2 · **P3 판정 = INSERT 건수와 SKIP 사유** | P2 가 0 이면 메타 미이관 — 10 실행 금지, 회신 |
| 2 | `A_DB/10_APPLY_GAP379_TITLESET.sql` | `APPLY 후` 건수 = P1 + P3 INSERT | 오류 회신 |
| 3 | `A_DB/90_VERIFY.sql` | V1 IN_DB = P3 INSERT 건수(+이미 있던 행) · V2 무효 칸 0 PASS | 회신 |
| 4 | 화면: 이관된 사용자로 DMF0053 조회 | 그 사용자가 AS-IS 에서 쓰던 칸·순서로 표시 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP379_TITLESET.sql` | 이관 값과 지금도 같은 행만 삭제(그 뒤 사용자가 다시 저장한 행은 보존) | 회신 |
- P3 에 `SKIP 사용자 TO-BE 설정 보유` 가 나오면, 그 사용자는 클라우드에서 이미 설정을 새로 만든 것이다. 의도대로 보존한다.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| 데이터 `SCM_MST_TITLESET_USER` | ✅ 10_APPLY (INSERT … NOT EXISTS) |
| 메타 `SCM_MST_SHEET_COLUMNS` / `SCM_MST_SHEET_MEASURE` | 기존 메타 사용(변경 없음) — 00 P2 로 존재 확인 |
| PKG · FE · BE · MSG/LBL · GRANT | 해당 없음 |
