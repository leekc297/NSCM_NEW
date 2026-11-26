# _fpdb: AS-IS FP DB(LGCE_FPDEV_TR) 추출 결과

FP 화면이 쓰는 별도 DB(LGCE_FPDEV_TR)를 SCM DB 와 같은 방법(`db.ps1`, 읽기 전용 SELECT)으로 뽑은 결과입니다. 파일 구성과 열 뜻은 `../db/README.md` 와 같습니다.

| 항목 | 값 |
|---|---|
| 접속 기록 | `db/_db.log` 첫 줄 `connected: ... / LGCE_FPDEV_TR` |
| 객체 수 | 4,073 |
| SP·함수·뷰 원문 | 1,335개, 원문 없음 0 |
| 추출일 | `db/db_objects.csv` 수정일 2026-10-23 |

| 경로 | 내용 |
|---|---|
| `db/*.csv` | 카탈로그·원문 분석(`../db/README.md` 표와 같음) |
| `db/modules/` | SP·함수·뷰 원문 |
| `db/meta/` | 메타 테이블 데이터 |
