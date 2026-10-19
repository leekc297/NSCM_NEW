# DMF0044 · DMF0049 개발본 잔존 제거 — AS-IS 운영 일치 (DB 단, 클라우드 이관)

> 마커 `[E20261006-ASISPARITY]` — `PKG_DMF0044` BODY · `PKG_DMF0049` BODY

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용 · BODY 2개** — SPEC · FE · BE · 메타 · 권한 · 테이블 · 데이터 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-10-06 16:17:43 / 16:17:44) — [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0044_0049_ASISPARITY_20261006/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 전제 | 클라우드 BODY 가 사내 변경 직전 판본과 같을 것 — `PKG_DMF0044` 지문 `10486/587998`(사내 10-01 10:18:26 판본) · `PKG_DMF0049` 지문 `1296/71362`(= [DMF0049_DEPTNAME_NVL_CLOUD_20261001](../DMF0049_DEPTNAME_NVL_CLOUD_20261001/) 적용본). PRECHECK `[H-0044]` · `[H-0049]` 가 패키지별로 판정 |
| BE 재기동 | 불요 |

## 1. 변경

운영 AS-IS 에 없는 개발 SR [E20260107-001542] 로직이 TO-BE 에 남아 있던 것을 운영과 같게 맞춘다 (asis_delta_20261002 "DMF0044 개발본 잔존" 4블록 · "DMF0049 개발본 잔존" 2블록).

| 패키지 · 멤버 | 변경 | 화면에서 달라지는 점 |
|---|---|---|
| `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` | 팀명 없음 검증 문구 2곳 → `'TEAM정보가 존재하지 않아 저장할 수 없습니다.'` | Transfer 차단 문구만 바뀜 |
| 같은 멤버 | 부서명(DEPARTMENT_NAME) 없음 검증 + 오류 처리 9줄 줄 주석 | 부서명 NULL 행이 있는 버전도 Transfer 됨 (리포트에는 부서명 `'-'`) |
| `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` | 구코드 COMPANY_ID 검증(`NERP_CONV_MASTER`) + 반환 11줄 줄 주석 | 구코드 회사로도 ETC Report 저장됨 |

변경분 전문 = [A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) (79줄).

## 2. 사내 검증

- 수정 전/후 복제 패키지(COMMIT 무력화)로 같은 입력 호출 11건: 변경 대상 6건만 달라지고 회귀 5건은 결과 데이터 동일. 원장 무변경(다른 접속 지문 대조).
- 실제 패키지의 성공(COMMIT) 경로 · 화면 경유는 실행하지 않았다.
- 본 패키지의 `00` · `90` 을 사내에서 실행: `00` = 두 패키지 `SKIP — 이미 적용됨`, `90` = V1~V5 전부 PASS.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각, 번호순)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — 조회 전용. 패키지별 JUDGE `적용` / `SKIP` / `⚠`(→ §4). `[D1]` 부서명 NULL 버전 · `[D2]` 팀명 NULL 버전(참고)
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 SPEC+BODY → `BAK_SRC_DMF0044_ASISPARITY` · `BAK_SRC_DMF0049_ASISPARITY` (있으면 건너뜀)
3. [A_DB/11_PKG_DMF0044_BODY.sql](A_DB/11_PKG_DMF0044_BODY.sql) — BODY 전체본 (642KB · 10,495줄 · 첫 실행문 `CREATE OR REPLACE PACKAGE BODY "PKG_DMF0044"` ~ `END PKG_DMF0044;` + `/`). `[H-0044]` 가 `적용` 일 때만
4. [A_DB/14_PKG_DMF0049_BODY.sql](A_DB/14_PKG_DMF0049_BODY.sql) — BODY 전체본 (78KB · 1,304줄 · `CREATE OR REPLACE PACKAGE BODY "PKG_DMF0049"` ~ `END PKG_DMF0049;` + `/`). `[H-0049]` 가 `적용` 일 때만
5. [A_DB/13_RECOMPILE_DEPENDENTS.sql](A_DB/13_RECOMPILE_DEPENDENTS.sql) — 본체 · 의존 INVALID 재컴파일 안전망 (사내 의존: `PKG_DMF0049` BODY → `PKG_DMF0044`)
6. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID · V2 `PKG_DMF0044`(마커 11 · 운영 문구 2 · 옛 문구 0 · 부서명 검증 0) · V3 `PKG_DMF0049`(마커 12 · 구코드 검증 0) · V4 `SCMP_APP` EXECUTE · V5 의존 INVALID 0

두 BODY 는 서로 독립이라 한쪽만 적용해도 된다. 순서는 0044 → 0049 권장(0049 가 0044 를 호출).

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) → 13

## 4. 지문이 다르면 수동 반영

JUDGE 가 `⚠` 인 패키지는 전체본(11 / 14)을 쓰지 않는다 — 전체본은 사내 누적본이라 클라우드에만 있는 변경을 지우거나, 클라우드에 아직 없는 사내 선행 변경을 같이 올린다.
[12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) 의 `-` 줄을 클라우드 BODY 에서 찾아 `+` 줄로 바꾼 뒤 컴파일하고 90 으로 확인한다. `@@` 줄 번호는 사내 기준이므로 앞뒤 원문으로 위치를 찾는다.

## 5. 주의

- AS-IS 가 SR [E20260107-001542] 를 운영에 배포하면 본 건을 되돌려야 한다 (줄 주석 접두 `--[E20261006-ASISPARITY] ` 제거 + 문구 2곳 원복).
- [DMF0049_DEPTNAME_NVL_CLOUD_20261001](../DMF0049_DEPTNAME_NVL_CLOUD_20261001/) 의 선택 항목 `02_DATAFIX`(기존 NULL 부서명 보정)는 본 건 적용 후에는 Transfer 를 위해서는 필요 없다(부서명 NULL 이어도 전송됨). 리포트에 `'-'` 대신 실제 부서명을 넣으려면 여전히 유효하다.
- 재빌드: `python _build.py` (사내 DB 최신 원문을 다시 읽어 전 파일 재생성).
