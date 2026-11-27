# SCP0005 결정 목록 (미검증 해소 라운드 7, 2026-11-25 23:3x)

- 라운드 6 원문: _unverified_decisions.md.bak_20261125_r6

- 라운드 4, 5 결정 원문: _unverified_decisions.md.bak_20261125_r5
- 권장안은 원문 근거가 있는 쪽. 근거가 없으면 '근거 없음'
- 판정 이름: 통과, 오류, 해당없음, 사용자 판정, 미검증

| 결정 | 정할 내용 | 행 수 | 행 ID | 선택지 | 선택지별 결과 | 권장안 | 근거 경로:줄 |
|---|---|---|---|---|---|---|---|
| R7-D1 | SCP0005 저장 중복 오류 알림 문구. 화면이 서버 문구 'DUP DATA.'(99010), 'DUP PRIORITY.'(99020)를 그대로 띄움. AS-IS 는 '저장시 중복 오류가 발생하였습니다. ( Route Id : n )' (R4-D6 을 실측으로 바꿈) | 3 | V-3134fc3e, T-ece1c98b, T-f048d4a9 | A 저장 프로시저 오류 문구를 AS-IS 문구로 보완 / B 서버 문구 표시를 TO-BE 규칙으로 등록 | A: 오류 유지, 보완 뒤 통과 / B: 통과, 규칙 원장 등록 | A(AS-IS 원문 SCP0005_DistributionRoute.cs:813 이 MSG00043 을 띄움. 보완은 PKG_SCP0005 줄 1323~1324, 1347~1348 문구로 가능) | row_run 23:21(RR20261125232134), PKG_SCP0005 줄 1323~1348 |
| R7-D2 | SCP0005 그리드 To City 칸 더블클릭 도시 팝업에서 고른 값이 칸에 안 들어가는 일이 2번 관측됨. 22:36 측정 1행 선택 ADALV 인데 칸 ADCAN 유지, 23:35 측정 2행 Ctrl 선택 뒤 칸 CAWND 유지. 같은 팝업을 To Country 칸에서 열면 반영됨 | 1 | EG-6e3313da | A 다음 CheckList 에서 다시 재 보고 재현되면 화면 결함으로 가이드 작성 / B 지금 화면 결함으로 확정 | A: 이번은 미검증, 다음 측정에서 통과 또는 오류 / B: 오류, FE 가이드 작성 | A(재현 2회, 원인 미확인. 셀 편집 종료가 팝업 값을 덮는지 확인 필요, DistributionRouteGrid.tsx:165~181) | popup_rowsets.json call 6, popup_results.json(22:10), 원장 EG-6e3313da(23:35) |
| R6-D1 | SCP0005 툴바 Excel Form 단추가 팝업 없이 양식 파일(35칸)을 바로 내려받음. 사용자 요구로 바꾼 동작인지 | 1 | V-a32c8abf | A 요구대로 바꾼 동작 / B 팝업이 있어야 함 | A: 사용자 판정 → 통과, 화면 변경 없음 / B: 오류, 팝업을 여는 화면 보완 필요 | A(확정 규칙 CR-095: 팝업 없는 다운로드는 사용자 판정, 오류 아님) | e2e_results.json V-a32c8abf(19:02 row_run), confirmed_requirements.csv CR-095 |
| R6-D2 | SCP0005 Excel Upload 행 상태(Error-Required 등 10행) 대조. 시험 파일 만들기(파일 안 중복)와 응답 짝짓기를 고쳤으나 같은 행 시도 2회가 차서 이번에 다시 재지 않음 | 1 | V-219edc76 | A 다음 CheckList 에서 다시 잼 / B 지금 한 번 더 행 단위 재측정 허용 | A: 다음 CheckList 에서 미검증 → 통과 또는 오류 / B: 지금 판정, 시도 3회째 허용 | A(19:02 측정 응답 건수 성공 1, 오류 9 가 시험 파일 기대와 같음. 짝짓기만 틀렸음) | m1_upload.json(18:57), ExcelUploadForm2.cs:1026~1080, m1upload.ts buildM1Rows·uploadStatuses |
| R6-D3 | SCP0005 업로드 팝업 인자 대조. AS-IS 시트 이름 인자가 TO-BE 업로드 주소의 시트 이름과 같음(Distribution Route). 같은 행의 다른 인자 묶음이 판정을 덮어 해당없음으로 닫힘 | 1 | V-a6bb7234 | A 다음 CheckList 판정 따름 / B 지금 행 단위 재측정 허용 | A: 다음 CheckList 에서 통과로 바뀜 / B: 지금 통과, 시도 3회째 | A | popup_args.csv 3행(19:04), SCP0005_DistributionRoute.cs:78, 233, 376, ExcelUploadModal.tsx:133~134 |
| R6-D4 | (라운드 7 해소) SCP0005 신규 행 저장 왕복 시험 행 정리. 화면 삭제는 신규 행만 지워 DB 정리로 넘기게 고침(T640, T647). 23:32 재측정 정리 완료 | 1 | ES-836708a8 | A 저장 왕복 판정 유지, 정리 실패는 시험 도구 과제로 따로 / B 정리 실패면 미검증 | A: 통과 유지 / B: 미검증으로 돌아감, 정리 경로 보완 뒤 재측정 | B(기대값 원문에 '정리와 복원 완료' 포함. 남은 시험 행 11172, 11173 은 19:13 백업 뒤 삭제) | e2e_results.json ES-836708a8(19:13), Doc/e2e/results/SCP0005/results.json '정리 예외: TimeoutError locator.click', cleanup/cleanup_*.sql |
| R4-D1 | Route Id 더블클릭 이력 팝업이 TO-BE 에 없음 | 5 | V-0e9099ba, V-4cfc72f5, V-a46588cb, T-fce350f2, T-ea530cd5 | A 화면 보완 뒤 측정 / B 이력 팝업 없음을 TO-BE 규칙으로 인정 | A: 미검증 유지, 보완 뒤 통과 또는 오류 / B: 해당없음 | A(DB MODE 라 화면 수정 안 함, FE 가이드 G1) | SCP0005_DistributionRoute.cs:1093~1103, FE_GUIDE_20261120_0854.md G1 |
| R4-D2 | 다른 화면이 Route Id 를 넘겨 SCP0005 를 열 때만 부르는 조회. 진입 경로 시험 추가 여부 | 1 | T-719d403c | A 진입 경로 시험 추가 / B 해당없음 | A: 미검증 → 통과 또는 오류 / B: 해당없음 | A | SCP0005_DistributionRoute.cs:208, 499 |
| R4-D3 | 단추 묶음 화면 사진 승인(Division 40) | 1 | V-5daefe3f | A 승인 / B 거부 | A: 통과 / B: 오류 | A(누락 4건은 서버 연결 이름, 화면에 Excel Upload 있음) | snap/snap_validate.csv 3행 |
| R4-D4 | 콤보 칸에 후보 밖 값 붙여넣기 AS-IS 기대값 | 9 | V-6f2db8d3, V-ba8f9817, V-5804ccc8, V-5a4e9648, V-7ac42873, V-753a87af, V-cb7ed54f, V-3d0ea655, V-d8ff8497 | A AS-IS 실측 뒤 확정 / B 후보 밖 값 차단을 기대값으로 | A: 미검증 유지 / B: 통과 또는 오류 | A | SpreadInfo.cs:521 |
| R4-D5 | 키 중복 신규 행 서버 차단 실저장 허용 | 1 | V-b3450ff5 | A 허용 / B 미허용 | A: 통과 또는 오류, 이력 표 기록 남음 / B: 미검증 유지 | B | SCP0005_SAVE_DISTRIBUTION_ROUTE.sql:580~641 |
| R4-D6 | 저장 중복 문구. TO-BE '[99010] DUP DATA.' ↔ AS-IS '저장시 중복 오류가 발생하였습니다. ( Route Id : n )' | 3 | T-ece1c98b, T-f048d4a9, V-3134fc3e | A 화면 문구 보완 / B TO-BE 규칙 인정 | A: 오류 유지, 보완 뒤 통과 / B: 통과 | 근거 없음 | SCP0005_DistributionRoute.cs:813 |
| R4-D7 | 업로드 창을 닫을 때 재조회 확인 질문. TO-BE 는 성공 때만 묻지 않고 재조회 | 3 | V-4a0b6271, T-2c4e7c8a, T-e19b6757 | A TO-BE 규칙 등록 / B 오류 | A: 통과 / B: 오류 | 근거 없음 | SCP0005_DistributionRoute.cs:379~384 |
| R4-D10 | 정렬 키 4칸 빈 값 위치 차이 | 3 | EG-9afd4a78, EG-89828767, EG-e6b3240d | A 조회 프로시저 정렬에 빈 값 앞 지정 / B 그대로 | A: 통과 / B: 통과(빈 값 0행 실측) | A | sort_check.csv 2, 3, 6행 |
| R5-D1~D5 | 라운드 5 공용 판정 변경 5건(0 값 저장 문구 대조, 빈값 0 변환, 업로드 덮어쓰기 문구, 붙여넣기 잘림, 닫힌 알림 제외) | 8 | V-72fbb5b2, V-7116d2aa, V-087d756b, V-8fd091cc, V-3e95d2be, T-eea49685, T-6a512ae5 | A 권장안 유지 / B 되돌림 | A: 지금 판정 유지 / B: 미검증으로 돌아감 | A | _unverified_decisions.md.bak_20261125_r5 R5-D1~D5 |
| C-1 | 기준 원장 판단 대기. 다른 화면 결함 유형이 이 화면에 대상이 없다는 판단(Measure, Team, Version 팝업 등) | 24 | criteria.md 판단 대기 C-d4a59387d1 ~ C-6ccd08f95a | A 대상 아님 / B 대상 | A: 해당없음 / B: 미검증 | A 23건, C-6ccd08f95a(조회조건 기간 칸 사진)는 근거 없음 | criteria/criteria.md:8~34 |
| C-2 | 기준 원장 실측 대조 판단 대기(AS-IS 미호출 조회 2, 저장 인자 차이 2, 화면에만 있는 컨트롤 등) | 29 | criteria.md 실측 행 | A 사람 확인 / B 대상 아님 | A: 미검증 유지 / B: 해당없음 | 근거 없음 | criteria/criteria.md:35~63 |
