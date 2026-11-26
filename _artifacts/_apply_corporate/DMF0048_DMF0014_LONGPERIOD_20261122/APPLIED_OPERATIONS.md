# [E20261122-LONGPERIOD] DMF0048, DMF0014 긴 기간 조회 Sql Error 보완 (사내 ZIOUI1, 2026-11-22)

## 원인 (SCM_SYS_LOG_BATCH, 2026-11-22 실측)
| 화면 | 오류 | 위치 | 조건 |
|---|---|---|---|
| DMF0048 | ORA-22835 CLOB→VARCHAR2 4000 초과(실제 4,857) | PKG_DMF0048 BODY 1828행 `FN_SPLITSTRING(V_PV_LIST, ',')` | Daily 1년 이상 |
| DMF0048 | ORA-22828 REPLACE 32K 초과(잠복) | 2327~2328행 | Daily 3년(PIVOT IN 35,468자) |
| DMF0014 | ORA-22828 REPLACE 32K 초과 | PKG_DMF0014 BODY 6649행 `REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION)` | Daily 2년 |

첨부 리포트의 원인(SQL 문장 64KB 한도)은 맞지 않음. 조회문은 CLOB 로 `OPEN FOR` 실행하므로 길이 한도 없음.

## 적용
| 객체 | 적용 전 LAST_DDL | 적용 후 LAST_DDL | 상태 | ALL_ERRORS |
|---|---|---|---|---|
| PKG_DMF0048 BODY | 2026-11-17 19:51:38 | 2026-11-22 13:42:38 | VALID | 0 |
| PKG_DMF0014 BODY | 2026-11-17 19:46:48 | 2026-11-22 13:42:40 | VALID | 0 |

- SCM_MGR INVALID 객체 수 적용 전 14, 적용 후 14
- 기준본 = 2026-11-22 13:42:18 ALL_SOURCE 조회본(`_base_*`), 적용 직전 FRESH-GATE 통과, 적용 뒤 DB 원문 == 적용본
- 원복 = `00_BACKUP_PKG_DMF0048_BODY.ASIS.sql`, `00_BACKUP_PKG_DMF0014_BODY.ASIS.sql`
- 변경 내용
  - DMF0048 1828행: 칸 목록을 `DBMS_LOB.INSTR`, `DBMS_LOB.SUBSTR` 로 자름
  - DMF0048 2327~2328행: 큰 목록 2개를 자리표시 위치에 잘라 붙임. 결과 칸 수가 1,000을 넘으면 ORA-20010 「MSG01505 조회 칸 수 N개가 1,000개를 넘습니다」
  - DMF0014 6649행: 기간 칸 목록을 자리표시 위치에 잘라 붙임

## 검증 (`verify_equiv.py`, `VERIFY_RESULT.txt`, 2026-11-22 13:47:53~13:48:35)
입력값 = SCM_COM_SQL_LOG 실제 화면 호출(Division 40, qjastar). DMF0014 는 데이터가 있는 Division 81(ohsun) 추가.

보완 전 원문 임시 사본 ↔ 보완 후, 같은 입력 결과 대조(칸, 행, 해시)
| 화면 | 기간 | Bucket | 결과 |
|---|---|---|---|
| DMF0048 | 2026-11-01~2027-04-30 | DAILY | 233칸 553행 일치 |
| DMF0048 | 2026-11-01~2027-11-03 | WEEKLY | 92칸 678행 일치 |
| DMF0048 | 2026-11-01~2027-11-03 | MONTHLY | 92칸 678행 일치 |
| DMF0048 | 2025-11-01~2028-10-31 | WEEKLY | 239칸 4,152행 일치 |
| DMF0014 | 2026-11-16~2027-11-15 | DAILY | 380칸 0행 일치 |
| DMF0014 | 2026-11-16~2028-11-15 | WEEKLY, MONTHLY | 120칸, 40칸 0행 일치 |
| DMF0014 Div81 | 2025-01-06~2026-01-05 | DAILY | 380칸 0행 일치 |
| DMF0014 Div81 | 2025-01-06~2027-01-05 | WEEKLY | 120칸 39행 일치 |
| DMF0014 Div81 | 2025-01-06~2027-01-05 | MONTHLY | 40칸 0행 일치 |

보완 전 실패 기간
| 화면 | 기간 | Bucket | 보완 전 | 보완 후 |
|---|---|---|---|---|
| DMF0048 | 2026-11-01~2027-11-03 | DAILY | ORA-22835(10:32:47 화면 오류와 같은 조건) | 460칸 678행 |
| DMF0048 | 2026-11-01~2028-11-01 | DAILY | ORA-22835 | 899칸 817행 |
| DMF0048 | 2026-11-01~2029-11-01 | DAILY | ORA-22835 | ORA-20010 1,338칸 초과 문구(FE 사전 알림 가이드 G1) |
| DMF0048 | 2026-11-01~2029-11-01 | WEEKLY, MONTHLY | 미측정 | 241칸 817행 |
| DMF0014 | 2026-11-16~2028-11-16 | DAILY | 미측정 | 747칸 0행 |
| DMF0014 Div81 | 2025-01-06~2027-01-05 | DAILY | ORA-22828(사본 재현) | 745칸 0행 |
| DMF0014 Div81 | 2025-07-01~2027-07-01 | DAILY | ORA-22828(사본 재현) | 746칸 0행 |

- DMF0014 Daily 0행: DM_PLN_CUSTOMER_PSI 에 Daily 업로드 대상(DM_MST_CUSTOMER_FCST UPLOAD_BUCKET_TYPE=DAILY) 행이 0건이라 값 대조는 미측정. 조회문 실행과 칸 수만 확인함
- DMF0014 FE 는 AS-IS 와 같이 기간 2년을 넘으면 MSG00164 로 막음(`CustomerFcstUpload.tsx:183~189`). 2년 Daily 747칸이라 1,000칸 한도 안임
- 긴 조회조건: Division 40 부서 목록 + 가짜 코드 700개(5,779자)를 DMF0048 P_DEPT_ID, P_SCM_SITE_ID, DMF0014 P_DEPT_ID 에 넣어 오류 0건(DMF0048 P_DEPT_ID 553행)
- 임시 사본 ZZLP_DMF0048_OLD, ZZLP_DMF0014_OLD 삭제 확인(잔여 0)

## 클라우드 이관 패키지 (DB MODE 수정본, 사내 리허설 OK, 경고 0)
- `_artifacts/_deploy_packages/DMF0048_CLOUD_DB_MOD_20261122_1349/`
- `_artifacts/_deploy_packages/DMF0014_CLOUD_DB_MOD_20261122_1350/`

## FE 가이드
- `Doc/verify/DMF0048/FE_GUIDE_20261122_1348.md` 1항목(G1 Daily 2년 초과 사전 알림, MSG01505)
