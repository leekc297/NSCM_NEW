# foxquery_sql: FoxQuery 인라인 SQL 원문

FoxQuery 정의(`04.WSL\FoxQuery` 아래 `.foxml`, `.xml`) 중 SP 호출이 아닌 SQL 문장을 엔드포인트마다 파일 하나로 꺼낸 것입니다.

- 파일 이름 = 엔드포인트 키에서 `\`, `/`, `#` 등 파일 이름에 못 쓰는 글자를 `_` 로 바꾼 것
- 주석 처리된 엔드포인트는 `.commented.sql`
- 어느 엔드포인트의 SQL인지는 `../foxquery_endpoints.csv` 의 `text_file` 열로 찾습니다.
- 이 SQL이 참조하는 테이블·SP·함수 목록은 `../foxquery_sql_refs.csv` 에 있습니다.
- SP 호출(procedure) 엔드포인트는 원문이 SP 이름 하나라서 여기 없고, `foxquery_endpoints.csv` 의 `sp_name` 에 있습니다.
