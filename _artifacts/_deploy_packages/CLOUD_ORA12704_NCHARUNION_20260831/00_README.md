# CLOUD_ORA12704_NCHARUNION_20260831 — 클라우드 DMF0082 조회 SQL ERROR 정정

## 증상 → 원인 (검증 SQL 실측, 2026-08-31)

- 증상: 클라우드 DMF0082 조회 시 SQL ERROR (`SCM_COM_SQL_LOG.EXCEPTION` = `InvocationTargetException: null` 래퍼)
- §1 실측: **PKG_DMF0082 PACKAGE BODY = INVALID** — `ORA-12704 문자 집합이 일치하지 않습니다` (8869행 문장/8985행 지점).
  PKG_DMF0021 BODY 도 동일 오류(클라우드 308/311행). P_SYS0014_GET_AUTH_LIST_M 도 INVALID(2026-08-31 15:26).
- §2 마커 14종 전부 존재 / §3 의존 객체 부재 0 / §4 SCMP_APP EXECUTE 정상 → 이관 자체는 완료.
- 근본 원인: **클라우드 TB_FX_%(프레임워크 테이블)의 문자 컬럼이 N-타입(NVARCHAR2)** —
  사내는 `TB_FX_USER.DEPT_ID = VARCHAR2(200)` 실측. `VARCHAR2 UNION NVARCHAR2` 는 Oracle 이
  컴파일 단계에서 ORA-12704 로 거부한다 (비교 연산은 암묵 변환 허용, **집합 연산은 불허**).
  - PKG_DMF0082: 부서 매핑 서브쿼리 `LOOK.SEGMENT3(VARCHAR2) UNION TB_FX_USER.DEPT_ID`
  - PKG_DMF0021: 동일 `PM_TEAM_MAPPING` 서브쿼리 (`SEGMENT1/SEGMENT3 UNION DEPT_ID, DEPT_ID`)
  - P_SYS0014_GET_AUTH_LIST_M: `A.UNIT_ID(VARCHAR2) UNION ALL TB_FX_USERGROUPAUTHEXTENTION.CODE/JV_PLANT_ID`
- BODY INVALID → 호출 시 ORA-04063 → BE 래퍼가 실오류 은닉(-9994 계보).

## 정정 [E20260831-NCHARUNION]

TB_FX_% 컬럼을 UNION 브랜치에서 `TO_CHAR()` 로 감싸 charset-중립화 (N-타입이든 VARCHAR2 든 VARCHAR2 로 정규화).
- 사내 실측: 3본 컴파일 0 오류·VALID + 부서 서브쿼리 결과 동일(LESIC) + DMF0082 GET CODE 0.
- 전수 스윕: 사내 TB_FX_% 참조 115 소스 중 UNION 인접 15본 — 클라우드 INVALID 교차분은 위 3본뿐 (나머지는 클라우드 VALID = 미해당).

## 적용 순서 (클라우드)

0. (백업) 현재 본문 보존: 각 객체 `SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='...' ORDER BY LINE` spool.
1. `01_PKG_DMF0082_BODY.sql`
2. `02_PKG_DMF0021_BODY.sql`  ← 사내 정본 전체본(클라우드 현재본보다 최신 변경 포함 — 사내=정본 정책)
3. `03_P_SYS0014_GET_AUTH_LIST_M.sql`
4. `04_POSTCHECK.sql` 실행 → 결과 회신 (3본 VALID + ORA-12704 잔존 0 이 통과 기준)

## 참고 — 근본 권고

클라우드 TB_FX_% 테이블의 N-타입 컬럼을 사내와 동일한 VARCHAR2 로 정렬하는 것이 장기 정합 방향
(N-타입 유지 시 비교 연산도 암묵 변환으로 인덱스 미사용 가능). 프레임워크 소유 테이블이라 본 패키지에서는 건드리지 않음.
