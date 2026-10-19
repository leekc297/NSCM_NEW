# SCM_MGR 정적 SQL — GROUP BY 불일치(ORA-00979 계열) 일괄 점검 결과

- 대상 DB: 사내오라클 ZIOUI1 · 기준 원문 = 실행 시점 ALL_SOURCE · 실행 없이 파싱만(DBMS_SQL.PARSE)
- 점검 객체(GROUP BY 가 있는 PACKAGE BODY · PROCEDURE · FUNCTION): **557개** (점검 실패 0개)
- GROUP BY 가 있는 정적 SQL 문장: **3210개** → 통과 3175 · **같은 계열 오류 2** · 미판정 33
- 점검 밖: 문자열로 조립하는 동적 SQL 중 GROUP BY 가 있는 곳 204곳 (60개 객체)

## 같은 계열 오류 — 1개 객체 · 2문장

| 객체 | 종류 | 상태 | LAST_DDL | 행 | 프로시저 | 오류 |
|---|---|---|---|---|---|---|
| PR_SSP_BI_SSP_RESULT_H | PROCEDURE | INVALID | 2026-10-14 09:28:18 | 250 | PR_SSP_BI_SSP_RESULT_H | ORA-00979: "A"."TO_SITE": must appear in the GROUP BY clause or be used in an aggregate function |
| PR_SSP_BI_SSP_RESULT_H | PROCEDURE | INVALID | 2026-10-14 09:28:18 | 1237 | PR_SSP_BI_SSP_RESULT_H | ORA-00979: "A"."TO_SITE": must appear in the GROUP BY clause or be used in an aggregate function |

## 미판정 — 33문장 (오류 코드별)

파싱이 다른 오류로 끝난 문장이다. 도구가 PL/SQL 전용 문법 · 변수 자료형을 흉내 내지 못한 경우가 대부분이며, 같은 계열 오류로 확인된 것은 아니다. 목록은 `findings.tsv`.

| 오류 코드 | 문장 수 |
|---|---|
| ORA-00942 | 13 |
| ORA-00980 | 10 |
| ORA-41900 | 4 |
| ORA-01747 | 2 |
| ORA-03048 | 1 |
| ORA-00923 | 1 |
| ORA-00928 | 1 |
| ORA-00907 | 1 |
