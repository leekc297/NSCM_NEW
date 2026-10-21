# PKG_SCP0100 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_SCP0100_GET_SHEET_CALENDAR_3SPAN: 첫 결과셋 컬럼(As-is 실측 6): COLUMN_NAME(nvarchar(9)), COLUMN_LABEL_NAME(nvarchar(30)), SMALL_CLASS_LABEL_NAME(nvarchar(30)), LARGE_CLASS_LABEL_NAME(nvarchar(30)), DAY_CODE(nvarchar(8)), SORT_ORDER_NO(nvarchar(10))
- P_SCP0100_GET_SITE: 첫 결과셋 컬럼(As-is 실측 2): CODE(nvarchar(30)), NAME(nvarchar(30))
- P_SCP0100_GET_PLAN_DATE: 임시테이블 #TMP_PLAN → GTT(03_GTT) 또는 WITH 절/컬렉션으로

## 이식 결과 (2026-10-20)

### O_RC 수 조정
- 골격 추정(GET_SITE O_RC1~4, GET_PLAN_DATE O_RC1~2)은 원문의 IF 갈래별 SELECT 를 센 값. 실행 시에는 갈래마다 SELECT 1개만 반환되므로 **세 프로시저 모두 O_RC1 1개**로 맞췄다.
- 사내 ZIOUI1 현행 시그니처와 같다(ALL_SOURCE 2026-10-20 조회 · PROC_M 5+4+5행). `e2e_plan.json` procs 와 `__asis-mapping__.md` §4 에는 O_RC 수 항목이 없어 수정할 곳이 없다.

### 프로시저별
- **CALENDAR_3SPAN**: 원문의 주석 구간(DEFAULT·1차·2차·3차 적용)은 옮기지 않았다(port_pkg 금지 항목). 실행되는 문장(주 `W_` + 월 `M_` UNION ALL, ORDER BY SORT_ORDER_NO)만 옮겼다. `MAX(SUBSTRING(x,4,1)) != ''` → Oracle 에서는 범위 밖 SUBSTR 이 NULL 이므로 `IS NOT NULL` 로 썼다. 결과는 같다. 그룹 키는 ORA-00979 를 피하려고 인라인 뷰의 WEEK_KEY 로 뽑았다.
- **GET_SITE**: SITE_TYPE × BUCKET 4갈래. `(@p IS NULL OR @p='')` → `TRIM(P) IS NULL`(MSSQL 의 '' 비교는 후행 공백을 무시함). As-is CI 콜레이션 대응으로 비교는 UPPER, 정렬은 사내 현행식 `UPPER(TRANSLATE(x,'_-','/')) NULLS FIRST, x NULLS FIRST` 를 그대로 가져왔다.
- **GET_PLAN_DATE**: #TMP_PLAN 은 버킷 갈래에서 한 번만 참조되므로 WITH 절로 옮겼다. `CONVERT(char(10),…,121)` → `TO_CHAR(…,'YYYY-MM-DD')`. LEFT JOIN 뒤 `WHERE FP_TARGET_YN='Y'`(결과적으로 내부조인)와 도달 불가능한 `(No Plan)` ELSE 는 원문대로 두었다.

### As-is 와의 차이 (사유)
- **필수값 검사 삭제(3개 프로시저)**: 골격의 `IS NULL → RAISE_INVALID` 는 As-is 에 없다. As-is 는 값이 비어도 오류 없이 0행/전체를 반환한다.
- **미일치 갈래 = 0행 커서**: As-is 는 결과셋이 없다. 사내 현행본은 O_RC1 을 열지 않은 채 반환하는데, 이를 클라이언트가 읽으면 오류가 난다(ORA-01001). 그래서 같은 컬럼(CODE, NAME)의 0행 커서를 연다. FE 에서 보이는 결과는 "데이터 없음"으로 같다.
- **EXCEPTION**: 골격 규약(WHEN OTHERS → RAISE_APPLICATION_ERROR -20001)을 유지했다. 사내 현행본은 `'-1'` 결과 커서를 반환하므로 오류 표시 방식이 다르다.

### 검증 (사내 ZIOUI1 SCM_MGR, 2026-10-20)
- 임시 패키지 `ZZ_PKG_SCP0100_PORTCHK` 로 컴파일: SPEC/BODY VALID, USER_ERRORS 0 → 검증 후 DROP(잔존 0). 사내 현행 PKG_SCP0100 LAST_DDL 은 변동 없음(SPEC 2026-10-09 13:38:32 · BODY 2026-10-16 09:42:30).
- 사내 현행 PKG_SCP0100 과 결과(컬럼·행·순서) 대조 78케이스: SAME 50 · 미일치 갈래(현행 미개설 ↔ 이식본 0행) 28 · DIFF 0.
- 미실행: AS-IS MSSQL 원본과의 직접 결과 대조(이번 대조 기준은 사내 To-Be 현행본).

### 배포 (⚠️ 단독 실행 금지)
- 사내 현행 PKG_SCP0100 에는 `P_SCP0100_GET_GLOBAL_PSI_REPORT` / `_WW_DATAONLY` / `_MM_DATAONLY` 와 내부 `PR_SET_FINAL_COLS` 가 있다. 이 파일을 `CREATE OR REPLACE` 로 그대로 실행하면 이 프로시저들이 지워진다. 반영할 때는 최신 원문을 다시 조회한 뒤(#152 FRESH-GATE) 그 위에 프로시저 단위로 병합한다.
- 공통 PKG 필요 항목: 없음(FN_SPLITSTRING · FN_CHAR_TO_DATE 는 SCM_MGR 에 VALID 로 있음).
