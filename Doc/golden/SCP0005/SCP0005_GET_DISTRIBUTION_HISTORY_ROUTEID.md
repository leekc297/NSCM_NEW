# SCP0005 · SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID ↔ PKG_SCP0005.P_SCP0005_GET_ROUTE_HIST

- 실행: 2026-11-26 01:18:44
- 파라미터: `{"p_route_id": "7490"}`
- 종류: GET
- 빈 인자 p_route_id = 같은 화면 본 조회 SCP0005_GET_DISTRIBUTION_ROUTE 결과 칸 route_id 값(차등 검증 호출 #5 실측 인자로 AS-IS 25행 · TO-BE 25행 다시 조회 · 양쪽 공통 값 25개 중 AS-IS 첫 행 · T547)

### 결과셋 1  As-is 1행 ↔ To-Be O_RC 1행
- 일치
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서 · AS-IS ORDER BY 키 FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 비교 불가(공통 행 2 미만)
