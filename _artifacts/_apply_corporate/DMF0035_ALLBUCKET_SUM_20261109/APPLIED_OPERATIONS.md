# DMF0035 버킷 전체(일·주·월) 데이터 제공 — 사내 ZIOUI1 적용 기록

마커 `[E20261109-ALLBUCKET]` · 2026-11-09 · 접속 = .env.asis TOBE_DB (59.19.252.148:2521/ZIOUI1, CURRENT_SCHEMA SCM_MGR) · 작업 모드 DB_ONLY

## 요청
- 사용자: MONTHLY 조회 시 월·주는 펼쳐지나 일(DAILY)이 열리지 않음 → 조회 시 버킷 전체 데이터 제공(MKT FCST · SALES PLAN · BIZ PLAN). DB PKG 만, FE 는 별도.
- 사용자 지시 18:23/18:26: Sum 은 이미 존재 → Sum 추가 작업 불필요 (1차로 넣었던 `P_SUM_YN` 파라미터·PROC_M `sumYn` 은 18:24 원복 · 이후 미적용).

## 변경 (BODY 2개만)
| 객체 | 변경 |
|---|---|
| PKG_DMF0035 BODY | private `F_DAILY_YN`(+`C_MAX_PERIOD_COLS`=900) 추가 · 메인 SP: C_BUCKET D 조건·T_WF_DATA YYYYMMDD·D_ 분기 = `V_DAILY_YN` · `V_SQL_TEXT`/`V_PV_*` → CLOB · DBMS_OUTPUT CLOB 4000자 절단 · TITLE SP: D 조건 2곳 = `V_DAILY_YN` |
| PKG_DMF0022 BODY | 동일 (메인 SP `v_sql_text`/`V_PV_*` → CLOB · TITLE SP D 조건 2곳) |
| spec · PKG_DMF0051 · PROC_M | 무변경 (PROC_M sumYn 잔존 0 확인 18:32) |

## 경과 (로그 = 이 폴더)
| 시각 | 단계 | 결과 |
|---|---|---|
| 18:08:04 | `fetch_fresh.py` 원문 조회 → `00_BACKUP_ASIS/` | 35 BODY LAST_DDL 11-05 17:45:58 · 22 BODY 11-05 17:53:40 · 51 BODY 11-04 14:48:42 |
| 18:10 | 현행 한계 실측 | MKT 40 DAILY 1년·1.5년·3년 = ORA-06502 |
| 18:18~18:21 | BEFORE 44 시나리오 (`results_BEFORE.jsonl`) | 오류 = DAILY 2년(82·SALES 40) ORA-06502 만 |
| 18:21:33 | 1차 적용 (Sum 파라미터 포함 · `apply_20261109.log`) | FRESH-GATE 6/6 · VALID · PROC_M 3/3 PASS |
| 18:24:48 | Sum 철회 원복 (`rollback_sum_20261109.log`) | 6객체 착수 원문 · PROC_M 원상 |
| 18:25:42 | 2차 적용 BODY 2 (`apply2_20261109.log`) | FRESH-GATE PASS · VALID · AFTER2 46 시나리오 FAIL 0 |
| 18:32:06~09 | 앵커 ASCII 화 재빌드 → 원복·재적용 (`rollback3_*.log` · `apply3_*.log`) | VALID · 적용본 == DB 원문 |
| 18:33~18:34 | 클라우드 패키지 리허설 (`_deploy_packages/DMF0035_ALLBUCKET_CLOUD_20261109`) | 실패 0 · 끝 상태 = `02_TOBE` 글자 단위 동일 · BODY LAST_DDL 18:34:19 |
| 18:35 | AFTER3 46 시나리오 (`results_AFTER3.jsonl` · `compare.py AFTER3`) | **FAIL 0** |

## 판정 기준 (`compare.py`)
1. 일자 외 컬럼 해시·행 수·주/월 컬럼 수 = 변경 전과 동일 (기존 값 불변)
2. WEEKLY/MONTHLY 새 일자 값 = 같은 기간 BEFORE DAILY 일자 값 (해시 일치)
3. DAILY · ONLY_WEEKLY = 일자 포함 완전 동일 / 기간 컬럼 > 900 = 일자 미포함
4. TITLE: SALES 는 SORT_ORDER_NO = ROW_NUMBER() 라 일자 행이 끼면 주·월 순번이 재번호 → 같은 기간 DAILY TITLE 과 완전 일치로 판정 (기존 DAILY 동작과 동일)

## 원복
`python apply_corp.py rollback` (00_BACKUP_ASIS 착수 원문 재컴파일 · PROC_M sumYn 정리)
