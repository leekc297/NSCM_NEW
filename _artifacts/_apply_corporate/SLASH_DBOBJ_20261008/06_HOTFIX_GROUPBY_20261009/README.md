# [E20261009-GRPBYFIX] DMF0020 조회 ORA-00979 핫픽스 — 클라우드 DEV/QA 적용 패키지

> 상위 패키지: `_artifacts/_apply_corporate/SLASH_DBOBJ_20261008/` (10-08 NULL 센티널 '-'→'/' DB 객체 변경). 본 폴더는 그 회귀 1건의 핫픽스.

## 1. 증상 · 원인 (확정)
- 증상: 클라우드 DEV DMF0020 조회 → `ORA-20001 [PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE] ORA-00979: "A"."CURRENCY": must appear in the GROUP BY clause … line 5040`
- 원인: **10-08 SLASHOBJ 반영분의 회귀.** `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` 의 RTF 집계 INSERT 2문장(Current 분기 L5040 / SP_ 분기 L5131)에서 SELECT 쪽 `NVL(A.CURRENCY,'-')` 2줄(L5052·L5145)만 `NVL(NULLIF(RTRIM(A.CURRENCY),''),'/')` 로 바꾸고, 같은 문장의 **GROUP BY 쪽 2줄(L5072·L5173)은 `NVL(A.CURRENCY,'-')` 로 남아** 식이 달라짐.
  - 변경 전 원문(`00_BACKUP_corp`)은 SELECT·GROUP BY 모두 `NVL(A.CURRENCY,'-')` 로 일치 → 정상 동작. 즉 그 전부터 있던 오류가 아님.
  - PL/SQL 컴파일은 이 불일치를 잡지 않아 사내·클라우드 모두 BODY 는 VALID 로 보였고 실행 시점에만 ORA-00979. 사내 ZIOUI1 에서도 동일 파라미터로 동일 오류 재현됨(10-09 13:2x).
- PKG_DMF0020 의 10-08 수정분 10줄 전부 재점검: 위 2줄 외 동일 케이스 없음(스캐너 `_work/groupby_scan.py` — 10-08 적용 직후 본에서 새로 생긴 불일치 = 정확히 L5052·L5145 2건, 변경 전 원문 대비).

## 2. 조치
- L5072·L5173 GROUP BY 식을 SELECT 식과 동일하게 교정 + 마커 `[E20261009-GRPBYFIX]`. 그 외 본문은 사내 ZIOUI1 2026-10-09 13:33 적용본 전체(10-08 19:27 AJS 변경 "Catch_Up" 1줄 포함 — 클라우드 정책 "사내 적용본 일괄" 과 동일).
- 사내 적용 2026-10-09 13:33:07 (FRESH-GATE: 적용 직전 LAST_DDL 2026-10-08 19:27:10 확인) → VALID · 오류 0 · 새 INVALID 0.
- 사내 검증: 사용자 오류 파라미터 그대로 `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` 실행 — Current 9,556행 / SP_W_20260825_V002 1,528행, 결과커서 (0, SUCCESS). 02_VERIFY V1~V4 전부 통과.

## 3. 클라우드 적용 순서 (SCM_MGR 접속, 각 파일 전체 F5, 바인드·DEFINE 없음)
| 순서 | 파일 | 기대 결과 |
|---|---|---|
| 1 | `01_APPLY_PKG_DMF0020_BODY_GRPBYFIX.sql` | `APPLY | PACKAGE BODY PKG_DMF0020 | VALID` · `APPLY ERR` 0행 |
| 2 | `02_VERIFY_DMF0020_GRPBYFIX.sql` | V1 VALID/ERR 0행 · V2 4줄(전부 `'/'` 식)·`V2 MISMATCH` 0행 · V3 `rows=N`(오류 없이) · DBMS_OUTPUT `V4 Current | OK rc1_rows=N | rc2=0,SUCCESS` + `V4 SP_… | OK …`(SP_ 버전 없으면 SKIP). 마지막 ROLLBACK 포함 |
| 원복 | `99_ROLLBACK_PKG_DMF0020_BODY_to_1726.sql` | 핫픽스 직전 클라우드 본(17:26 페이로드)으로 — ⚠ 되돌리면 ORA-00979 재발 |

- 상위 SLASHOBJ 패키지의 `05_CLOUD_PAYLOAD_corp/`·`03_CLOUD_APPLY_sqlplus/`·`01_NEW_corp/` 의 PKG_DMF0020 사본도 핫픽스 본으로 교체함(03 재실행 시 회귀 재발 방지). `03_CLOUD_APPLY_ONEFILE.sql`·`04_CLOUD_VERIFY.sql` 의 PKG_DMF0020 구간(10166줄 기대치)은 **아직 구본** — 96 객체 일괄 보완(다음 단계) 끝나면 `build_cloud_sql_package.py` 로 재생성 예정.

## 4. 파일
- `01_APPLY_PKG_DMF0020_BODY_GRPBYFIX.sql` — BODY 전체 CREATE OR REPLACE(10,167줄) + 상태/오류 조회
- `02_VERIFY_DMF0020_GRPBYFIX.sql` — V1~V4 (V4 = DBMS_SQL 로 REF CURSOR 행수 집계, 커밋 없음)
- `99_ROLLBACK_PKG_DMF0020_BODY_to_1726.sql`
- `_work/` — 사내 FRESH 원문(19:27 본)·수정본·호출 테스트(`call_get.py`)·스캐너(`groupby_scan.py`)·96 객체 FRESH 원문(`fresh_all/`, 다음 단계용)
