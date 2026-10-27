# DMF0082 조회 — LAST UPDATED BY / LAST UPDATE DATE 는 행 키가 아닌 참고값 (클라우드 이관 · 패치형)

> 마커 `[E20261027-DMF0082LASTUPD]` — PKG_DMF0082 BODY 조회 프로시저 2종에 블록 1개씩 삽입. 기존 문장·데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 증상 | Column Set 에 LAST UPDATED BY · LAST UPDATE DATE 를 넣으면 같은 키가 여러 줄로 갈리고 메저 값이 줄마다 나뉜다 |
| 원인 | 최종 피벗이 결과 컬럼 전체로 묶는다. 원천은 일자 행 단위라 행마다 수정일·수정자가 달라, 두 컬럼이 묶음 기준에 들어가면 조합 수만큼 줄이 생긴다 |
| 규칙 (사용자 요청 2026-10-27) | 두 컬럼은 키가 아닌 참고값. 선택한 컬럼의 키마다 **수정일이 가장 큰 행의 수정자 · 수정일 한 쌍**만 표시. 메저 표기는 선택 여부와 무관하게 같아야 함. 선택하지 않으면 로직 미적용 |
| 보완 | 두 컬럼 중 하나라도 결과 컬럼에 있을 때만, 키(결과 컬럼 + 메저 순번 − 두 컬럼)마다 수정일 최대 행의 값으로 조회용 임시 테이블의 두 값을 통일한 뒤 피벗 (수정일 동률이면 수정자 MAX) |
| 달라지지 않는 것 | 두 컬럼을 선택하지 않은 조회(블록 미실행) · 줄 수 · 메저 값 · 원장 · 저장 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-27 13:33:46 → 리허설 재적용 13:42:55) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_LASTUPD_20261027/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L1 앵커GET `1 PASS` · L1 앵커CUR `2` · L2 마커 0 · L3 두 컬럼 선택 사용자 수 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_LASTUPD_PATCH.sql](A_DB/10_APPLY_LASTUPD_PATCH.sql) | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 불일치면 ORA-20001/20002 로 중단·원문 무변경, 컴파일 실패면 원문 자동 복원) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(2) · V2 VALID/오류 0 · V3 마커·MERGE 줄 |

롤백: [A_DB/99_ROLLBACK_LASTUPD_PATCH.sql](A_DB/99_ROLLBACK_LASTUPD_PATCH.sql) — 되돌리면 두 컬럼을 선택한 사용자에게 다시 줄이 갈려 나온다.

화면 확인: Column Set 에 두 컬럼을 넣고 조회 → 넣기 전과 줄 수·메저 값이 같고, 두 컬럼에 그 줄의 가장 최근 수정일과 그 수정자 하나만 보이는지.

## 주의
- **패치형이다.** 클라우드 원문을 읽어 ASCII 앵커 2곳에만 끼워 넣는다.
  - GET_MAIN_DATA: 숨긴 PLANT_SITE_ID 대표값 MERGE(`[E20260918-KEYCOLGRAIN2]`) 끝 뒤 — 클라우드에 이 MERGE 가 없으면 L1 앵커GET 이 0 → 중단, 회신.
  - GET_MAIN_DATA_CURRENT: 피벗 IN 리스트 빈값 방어 `IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0` 앞 (센티널 세대 '-'/'/' 차이와 무관한 줄).
- **컬럼 이름 하드코딩은 두 컬럼뿐.** 키는 그때그때의 결과 컬럼 목록에서 만든다 — 다른 컬럼 설정에도 그대로 맞는다.
- 수정일 정밀도: GET_MAIN_DATA = 원천 CREATE_DATE(초 단위) / GET_MAIN_DATA_CURRENT = 'YYYYMMDD'(일 단위, 원천 형식 그대로) — 같은 날 여러 수정자면 수정자 MAX.
- 같은 BODY 를 고치는 다른 미적용 패키지(MANDCOL·MANDRET·AFSSHARE 등)와 구간이 달라 순서 무관.
- 10 은 패키지 BODY 재생성이라 DMF0082 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 한가할 때 실행.

## 리허설 (사내 ZIOUI1 2026-10-27 13:42, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`, 원문 == 수정 전 원문 True) → 00(L1 GET 1 · CUR 2 · L2 0) → 90(V1 미적용) → 10(`APPLIED … 마커 2곳`) → 10(`SKIP`) → 90(V1 PASS · VALID · 오류 0) → 99(`ROLLED BACK`, 원문 == 수정 전 True) → 99(`SKIP`) → 10(`APPLIED`).
리허설 뒤 전후 비교 40케이스 재실행 — 결과는 APPLIED_OPERATIONS.md.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 2곳 삽입 (조회 프로시저 2종) | A_DB/10_APPLY_LASTUPD_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 (테스트용 Column Set 행은 같은 세션 INSERT 후 ROLLBACK — 잔존 0 확인) |
