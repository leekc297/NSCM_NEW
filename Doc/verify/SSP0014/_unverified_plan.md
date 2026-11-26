# SSP0014 미검증 해소 계획 (2026-11-25 02:3x · 라운드 1)

- 입력: unverified_triage.csv 02:17:55(원장 verify_ledger.csv 02:17 와 같은 시각이라 재생성 안 함)
- 목록 144행 = 원장 ERROR 127행 + AI 검토 행 17행(원장 PASS 16 · NA 1). 원장 ERROR 127행 전부 목록에 있음
- 처리 순서 = 행 수가 많은 묶음부터. 집계 행은 하위 행을 따라감

## 묶음

| 묶음 | 내용 | 행 | 조치(고칠 파일) | 원인(실측) | 처리 |
|---|---|---|---|---|---|
| P1 | 차등짝 112 | 112 | tools/Harness/verify/pkg_asis_map.py(T532) · sp_pair.csv SSP0014 3행 재생성 | PKG_SSP0014 2026-11-24 13:55 재컴파일로 명세 'AS-IS -> P_' 주석이 빠짐. pkg_asis_map 가 명세 주석만 읽어 sp_pair.csv 230·231행 tobe_proc 빈 값 → diff_verify SKIP '짝 없음' | 처리 |
| P2 | A6 USER_ID_CHECK 13 | 13 | tools/Harness/verify/diff_ingest.py(T533) · sort_check.py 문구 | sort_check.csv 는 AS-IS·TO-BE 모두 ORDER BY 없음 + 검증 SP 로 NA(CR-075 ③)인데 차등 ORDER 판정이 sort_check 결과를 보지 않음. dbo.SSP0014_GET_USER_ID_CHECK.sql:22~28 ORDER BY 없음 | 처리 |
| P3 | 저장 왕복 행 식별 5 | 5 | tools/E2E/lib/rowlink.ts(신규 T534) · saveprobe.ts · crud.ts | USER_ID 저장 뒤 USER_NAME 이 함께 바뀌어(results.json '근접 일치 r0 USER_NAME 이련→육평') 행 식별 정확 일치 0건. 근접 일치는 ITEM_ID 만 다른 이웃 행과 동률. 원복 뒤 '(행 식별 0건)'. 사내 DB 01:02:34 eunjin.choi 로 복원 확인 | 처리 |
| P4 | G2·G9 User ID 콤마 2 | 2 | tools/Harness/verify/judge.py(T535) + P1 짝 복구 | judge.py G9 AS-IS 단일 비교 판정(T381)이 sp_pair.csv GET 짝(tobe_proc)이 빈 SP 를 건너뜀. G2 행(T497 표식)은 판정 대상 밖. AS-IS sql:86~88 LIKE 단일값, 85줄 Item ID 만 String_Split | 처리 |
| P5 | A1 같은 사용자 1 | 1 | tools/Harness/verify/a1_live.py(T536) | a1_live.py:183 이 인자 이름 user_id 를 로그인 사용자로 봄. AS-IS sql:86~88 @p_user_id = LIKE 검색어, SCM_MST_TITLESET_USER 참조 없음 | 처리 |
| P6 | DB-SYN 2 | 2 | P1 짝 복구(sp_pair.csv 재생성) | mapping_trace.py:1102~1127 이 AS-IS SP 이름을 sp_pair.csv 짝(sp_pair_tobe)으로 TO-BE PROC 시노님 결과에 잇는데 짝이 빈 값 | 처리 |
| P7 | Model 팝업 SP 2 | 2 | 검사기 수정 없음 · 가이드 FE_GUIDE_20261119_1647.md G5 · 결정 D7 | 대조표 28·36·72·98·131줄 = SCM0002 팝업. FE = MaterialByDivisionModal(COM0013, ShipmentModelPic.tsx:545~558). 이번 실행 sqllog_calls.json 에 두 팝업 SP 호출 0건. 대조표 수정은 DB MODE 금지 | 보류(가이드·결정) |
| P8 | B4 Warrnaty 1 | 1 | tools/Harness/verify/combo_oracle.py(T537) | AS-IS 하드코딩 항목 W:Warrnaty(cs:183)를 표시명으로만 짝지어 TO-BE 'Warranty' 를 '?Warranty' 로 남김 | 처리 |
| P9 | A2 비활성 사이트 1 | 1 | 결정 D2 | CN003256_40-A = AS-IS·TO-BE SCM_MST_SITE VALID_YN 'N'(11-25 02:4x 조회). AS-IS 콤보 원천 PlantSiteByDivision 도 VALID_YN='Y' 만 후보. AS-IS 화면 표시 미확인 | 결정 |
| P10 | K4 스냅샷 1 | 1 | 결정 D1 | snap_validate.py 11-25 02:4x: 6건 MISMATCH 1(버튼_Div_40 'USER_CHECK' 누락) · NA 3 · OK 2 | 사람 |
| P11 | 집계 4 | 4 | 하위 행 따라감 | 집계 행 | 집계 |
| 합계 | | 144 | | | |

## 행 목록

| 묶음 | 행 ID | 규칙 | 유형 | 담당 | 원장 | 대상 |
|---|---|---|---|---|---|---|
| P1 | AD-00c298eb | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-01c50b01 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-0207067b | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-02913504 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-03813da7 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-07e6862e | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-0f04adbd | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-132401f8 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-1710c6cd | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-1a8b4904 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-1b67816c | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-1c54dac6 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-1db24f84 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-1dcb0833 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-1fcaa759 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-2209ed9d | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-2a3611d6 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-2dc052ff | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-2fea247f | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-32989d9e | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-33f4bf55 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-3b555fcb | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-40c68570 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-467a8ea9 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-48f19363 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-49d82fe5 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-4daf7c41 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-589f2292 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-5c1b1e33 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-5f7c70da | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-5fec0e71 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-604a3809 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-61126185 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-628f2c6e | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-62ca9690 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-646a0185 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-6527bda0 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-68f1584d | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-6dcea621 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-6e79b17e | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-6ecb42f1 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-6fde857b | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-6fe6b4f5 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-7306741f | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-73e700aa | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-75def704 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-77389ec1 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-798731e5 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-7c842ef2 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-812bda7a | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-82bf5564 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-82e4469a | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-84de4a48 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-885a2b72 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-89dc148f | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-8ab71072 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-8acc9f35 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-8b590fa8 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-92362299 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-92e87cfc | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-9394466f | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-96ab6b45 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-9817fdc1 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-981e13f3 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-9970b1d9 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-9d593d92 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-9eb7b83f | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-a1c0209f | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-a5f4ccad | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-a7b0a7ab | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-a941327e | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-ab66d15b | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-abc1ee9e | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-ae15c161 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-b0d16abb | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-b784e12c | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-bbb9a397 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-bdf7f569 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-bfadcbd6 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-bfe6d488 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-c28d25e0 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-c55e8ba5 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-c94e134d | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-cbbdf1ce | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-cd2a3186 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-cf851c63 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-d2344784 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-d509eab4 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-d5b953c5 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-d88c3c8e | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-d90ec5be | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-d98a5b8f | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-db49eb95 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-dc5ef9ee | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-dc9300bb | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-de3cb47b | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-de8df197 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-e202d9b9 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-e290a971 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-e4e243e2 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-e4fd77c8 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-e6fa68c9 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-e71aef68 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-e71ffc67 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-ec30f7b0 | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-effc047b | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-f1f40f9a | A6 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통·유일 행 상대 순서 |
| P1 | AD-f25f3003 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-f3260120 | A1 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 행·키 집합(공통 · AS-IS 전용 · TO-BE 전용 ) |
| P1 | AD-f8e5ef43 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-f929a7d5 | A7 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 공통행 컬럼 값(공통 행 · 불일치 셀 ) |
| P1 | AD-f97db233 | A5 | 차등짝 | 엔진 | ERROR | SSP0014 (짝 없음) 결과 컬럼 집합(AS-IS 전용 · TO-BE 전용 ) |
| P2 | AD-0437c9bc | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-09b44044 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-174c2ddd | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-279962b4 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-51993393 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-69aebf72 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-8878632d | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-9121416d | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-a3fc75f7 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-bd7200cb | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-c2d21f53 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-c8cb8953 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P2 | AD-ead84776 | A6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 SSP0014_GET_USER_ID_CHECK 공통·유일 행 상대 순서 |
| P3 | V-09388b3d | F6 | 검사기공백 | 엔진 | ERROR | SSP0014 빈값 저장 |
| P3 | V-244ceb9e | F6 | AI검토:검사기오판 | 엔진 | PASS | SSP0014 화면 |
| P3 | V-504dee98 | F1 | 검사기공백 | 엔진 | ERROR | SSP0014 2행 동시 저장 |
| P3 | V-65af2f69 | F6 | 검사기공백 | 엔진 | ERROR | SSP0014 0 값 저장 |
| P3 | V-9bcbf1f5 | F1 | 검사기공백 | 엔진 | ERROR | SSP0014 컬럼별 저장 왕복 |
| P4 | V-3809bf77 | G9 | AI검토:검사기오판 | 엔진 | PASS | 조회조건 User ID(Name) |
| P4 | V-a70af79e | G2 | AI검토:검사기오판 | 엔진 | PASS | 조회조건 User ID(Name) |
| P5 | EG-29c0f2b6 | A1 | AI검토:검사기오판 | 엔진 | NA | SSP0014 실전송 건수 main/같은 사용자 |
| P6 | T-7e9aebc2 | DB-SYN | 검사기공백 | 엔진 | ERROR | SSP0014_GET_SHIPMENT_MODEL_PIC |
| P6 | T-a910edb5 | DB-SYN | 검사기공백 | 엔진 | ERROR | SSP0014_SAVE_SHIPMENT_MODEL_PIC |
| P7 | T-bab6f023 | F4 | 검사기공백 | 엔진 | ERROR | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP |
| P7 | T-d1bd8978 | A6 | 검사기공백 | 엔진 | ERROR | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP |
| P8 | V-62f2170d | B4 | 데이터전제 | 엔진 | ERROR | 조회조건 Operation group |
| P9 | V-16ab0403 | A2 | 판단 | 엔진 | ERROR | SSP0014 콤보 칸 이름 표시 |
| P10 | V-3bb51520 | K4 | 스냅샷승인 | 사람 | ERROR | SSP0014 스냅샷 버튼 Div 40 |
| P11 | T-3487b794 | X-ROW | 집계 | 집계 | ERROR | SSP0014_ShipmentModelPIC.SaveData |
| P11 | T-ee384c11 | A6 | 집계 | 집계 | ERROR | ProgressForm(FindData/SaveData) · 2 |
| P11 | T-f5883fbb | F4 | 집계 | 집계 | ERROR | ProgressForm(FindData/SaveData) · 2 |
| P11 | V-e80b9f38 | N1 | 집계 | 집계 | ERROR | [결함 유형 묶음 N1-G01 · 2건] 공란 데이터 표기(단일 센티널) |

## 처리하지 못한 행

| 행 ID | 막힌 곳 | 원인 | 필요한 결정 |
|---|---|---|---|
| T-d1bd8978, T-bab6f023 | nscm-fe/features/shipping/src/pages/shipment-model-pic/__asis-mapping__.md 28·36·72·98·131줄 | 대조표가 바뀐 팝업(COM0013)을 적지 않음. DB MODE 라 대조표 수정 불가 | D7 팝업 교체 인정 여부 · 가이드 G5 반영 |
| V-16ab0403 | AS-IS 화면 표시 | 후보에 없는 비활성 코드의 AS-IS 표시 미확인 | D2 |
| V-3bb51520 | snap_approve.py | 스냅샷 승인은 사용자 절차 | D1 |
