# SCP0100 클라우드 — PKG_SCP0100 BODY 컴파일 오류(ORA-00904 "PLAN_TYPE") 조치

## 증상 (2026-10-30 클라우드)
PKG_SCP0100 실행 시 BODY 가 오류와 함께 컴파일됨. `PLAN_TYPE` / `A.PLAN_TYPE` 부적합한 식별자 10건
(977·1085·1110·1185·1269·1555·1604·1651·1700·1761 행 문장).

## 원인
- 오류 행 번호가 사내 ZIOUI1 PKG_SCP0100 BODY(LAST_DDL 2026-10-16 09:42, VALID) 원문과 1:1 일치.
- 해당 문장은 모두 `GT_SCP0100_*` 임시테이블(GTT)의 `PLAN_TYPE` 컬럼(E20260708-000926)을 읽거나 씀.
- 사내 GTT 16개는 `PLAN_TYPE VARCHAR2(200)` 를 마지막 컬럼으로 보유. 클라우드 GTT 에는 없음.

## 실행
| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | `01_SCP0100_GTT_SYNC.sql` | GTT 25개 구조를 사내와 동일하게 맞춤 → 영구 테이블 컬럼 점검(조회만) → PKG_SCP0100 재컴파일 → 결과 확인 |

- SCM_MGR 로 접속해 **전체 F5**. 반복 실행해도 안전(멱등).
- 구조가 다른 GTT 는 DROP 후 재생성한다. GTT 는 세션 임시 데이터만 담으므로 잃는 데이터가 없다.
  패키지에 컬럼목록 없는 위치기반 INSERT(QTY_DETAIL·QTY_CELL_GROUP·QTY_PRODUCT_LEVEL1~3)가 있어 컬럼 순서까지 맞춰야 한다.
- 재생성 시 인덱스 7개·권한(RL_SCM_DML/RL_SCM_SEL)도 같이 만든다. SCMP_APP 시노님은 그대로 유효.

## 결과 확인
- 출력 마지막 `RESULT CREATE=… REBUILD=… SKIP=…`
- 확인 0(영구 테이블 누락 컬럼) = **0건**이어야 함. 행이 나오면 그 결과를 전달 바람.
  사내 `SCP_RPT_GLOBAL_PSI_MD_{WW,MM,DETAIL_WW,DETAIL_MM}.PLAN_TYPE` 은 NOT NULL·PK 컬럼이라 이 스크립트에서 손대지 않는다.
- 확인 1 = PACKAGE / PACKAGE BODY 모두 VALID, 확인 2 = 0건.
- `ORA-14452` 가 나면 GTT 를 쓰던 세션이 남아 있는 것이다. BE 재기동 후 다시 실행.

## 사전 검증 (사내 ZIOUI1, 2026-10-30 15:43~)
- 동기화 블록을 DROP/CREATE 차단 모드로 실행 → 25개 모두 SKIP(구조 동일), 확인 0 = 0건.
- 25개 CREATE + 인덱스 7개 DDL 을 임시 이름(ZT_/ZI_)으로 실제 생성 → 32건 성공, 구조 서명 25/25 일치 → 즉시 DROP(잔존 0).
- 클라우드 DB 에는 직접 실행하지 않았다.

## 클라우드 결과 (2026-10-30 사용자 회신)
- DEV: 01 실행 후 VALID.
- QA: 01 실행 시 GTT 25개 SKIP. 확인 0 에서 `SCP_RPT_GLOBAL_PSI_MD_MM`·`_WW` 의 PLAN_TYPE 누락. BODY 1079·3302 행 ORA-00904 로 INVALID.

## QA 추가 조치 — `02_SCP0100_PSI_MD_PLANTYPE_QA.sql` (QA 전용, SCM_MGR 로 전체 F5)
- PLAN_TYPE `VARCHAR2(50) NOT NULL` 추가. 기존 행 = `'FN'` (배치 P_PLAN_TYPE 기본값·실적 FN 고정 근거. 사내 값 분포 FN/MA/PR).
- PK 를 사내 구성(3번째 PLAN_TYPE)으로 재생성. 기존 PK 컬럼이 새 PK 에 다 들어가는지 먼저 확인하므로 중복 위험 없음.
- QA 배치 `PR_SCP_RPT_GLOBAL_PSI_MD_WW/MM` 이 PLAN_TYPE 버전이면 DEFAULT 제거(사내와 동일). 구버전이면 DEFAULT 'FN' 유지 + WARN → 배치 프로시저 이관 필요.
- 이후 PKG_SCP0100 + 배치 3종 재컴파일, 확인 1~3.
- ⚠ 배치 수행 시간을 피해 실행. PK 재생성 시간은 QA 행수에 비례.
- 사전 검증(사내, 테이블 복사본 3,000행 ×2): 신버전 배치 경로·구버전 경로 모두 컬럼 추가·PK 재생성·DEFAULT 처리 정상, 재실행 SKIP 확인, 복사본 삭제(잔존 0).
