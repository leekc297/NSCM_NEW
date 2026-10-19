# DbConn — NSCM DB 접속정보 관리 · 메타 export · 골든 테스트

| 파일 | 역할 |
|---|---|
| `dbconn.json` | 접속 **이름**(asis / tobe) → 종류·`.env` 키 접두어·스키마·readOnly. 비밀번호는 여기 없음 |
| `C:\Projects\NSCM\.env.asis` | 실제 값. `ASIS_DB_*`(MSSQL) / `TOBE_DB_*`(Oracle). **커밋 금지**, 출력·로그에 절대 남기지 않음 |
| `dbconn.py` | `connect(name)`, `describe(name)`(비밀번호 제외), `mask(text)`(예외 메시지 치환), `write_csv` |
| `probe.py` | 전 접속 점검 → `Doc\db\probe_<일시>.md` |
| `export_tobe_meta.py` | To-Be Oracle 메타 14종 → `Doc\tobefacts\db\*.csv` (gap.js/gen.js/E2E 가 읽음) |
| `gen_golden_cases.py` | 화면별 As-is SP ↔ To-Be PKG.PROC 짝·파라미터 초안 → `Doc\golden\golden_cases.csv` |
| `golden.py` | 같은 파라미터로 양쪽 실행 → 결과셋 대조 → `Doc\golden\<화면>\<SP>.md`, `_summary.md` |
| `param_defaults.json` | 파라미터 기본값(통합테스트_데이터셋 실측) |
| `db.cmd` | 일괄 실행(노트북) |

## 접속 추가/변경
1. `.env.asis` 에 `<PREFIX>_HOST/PORT/PDB(or NAME)/USER/PASS` 추가
2. `dbconn.json` 의 `connections` 에 이름·`envPrefix`·`type` 추가
3. `python probe.py <이름>` 으로 확인 — Vibe_Manager ▸ 환경 뷰에서도 마스킹된 값으로 보인다

## 안전 규칙
- `asis` 는 `readOnly: true` — `connect('asis', write=True)` 는 예외. SP 실행은 조회성(GET) 만
- `tobe` SAVE 류 골든 실행은 `--write` 일 때만, 실행 후 **ROLLBACK**
- 드라이버: Oracle = python-oracledb thin(클라이언트 불필요), MSSQL = pyodbc(ODBC Driver 17) → 없으면 pymssql
- `nscm-be/src/main/resources/config/config-*.yml` 에는 Oracle 비밀번호가 평문으로 들어 있다(프로젝트 관행) — Git 공개 범위를 확인할 것

## 골든 테스트 흐름
```
db.cmd                → probe / export / golden_cases.csv (초안)
(golden_cases.csv 에서 params·tobe_proc 보완, 보존하려면 manual=Y)
python golden.py DMF0003   또는   db.cmd golden
```
판정 PASS / COLS(컬럼 차이) / ROWS(행수) / DIFF(값) / ERR / SKIP. 컬럼명은 camel↔snake 무시 비교.

## run_sql.py — SQL*Plus 없이 하네스 SQL 실행
`python run_sql.py C:\Projects\NSCM\Doc\gen\DMF0052\DMF0052_PKG.sql` → 패키지 컴파일 + `USER_ERRORS` 출력.
`python run_sql.py ...\DMF0052_registration.sql` → DEFINE 치환·PL/SQL 블록·DBMS_OUTPUT 처리, BLOCK 8 결과 표시 후 **ROLLBACK**(기본). 결과가 맞으면 `--commit` 으로 재실행.
