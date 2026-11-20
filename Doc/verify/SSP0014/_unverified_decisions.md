# SSP0014 미검증 결정 목록 (2026-11-20 08:3x · 라운드 3)

- 행별 조치는 `_unverified_plan.md`. 결정 8건, 행 9개
- 라운드 2 결정 중 D5(사업부 후보 EE)는 검사기 보완 T376 으로 처리함. 종전 D7 의 G5 인자 차이(T-3a730d4a)는 CR-096 판정 경로(T406)로 처리하고 팝업 교체만 D7 에 남김

| 번호 | 행 | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-3bb51520 (K4, 사람) | 버튼 바 스냅샷 승인 여부. 기대 버튼 목록의 USER_CHECK 를 빼고 승인할지 | snap_validate.py 2026-11-20 07:5x: 6건 중 MISMATCH 1, NA 3, OK 2. MISMATCH = 버튼_Div_40 기대 'USER_CHECK' 누락. USER_CHECK 는 저장 전 사용자 확인 호출(`/SSP0014/main/USER_CHECK/call-proc`)로 등록된 메뉴 버튼 코드이고 버튼 바에 그리는 단추가 아님. 기대 목록 원천 = plan.json accounts[0].expectedBtns(btn_auth) |
| D2 | V-16ab0403 (A2) | 기준정보에 없는 출발 사이트 코드를 코드 그대로 보여 주는 것을 결함으로 볼지, 데이터 정리 대상으로 볼지 | FROM_SITE 'CN003256_40-A' 25행이 이름 대신 코드로 보임. 2026-11-19 16:46 조회: TO-BE·AS-IS SCM_MST_SITE 0행. AS-IS 화면 표시는 미확인 |
| D3 | V-62f2170d (B4) | Operation group 후보 철자 차이를 받아들일지 | AS-IS 는 콤보에 코드 W, 이름 'Warrnaty'(철자 원문, SSP0014_ShipmentModelPIC.cs:183~187)를 직접 더함. TO-BE 표시 'Warranty'(combo_runtime.json). 종전 '?Warranty' 의 '?' 는 검사기 환산 실패 표시였음(T391 로 처리). 다음 CheckList 부터 사유에 두 철자가 나옴 |
| D4 | V-0db2d553 (B4) | From Site 후보 차이 2건이 데이터 차이인지 | 사업부 40: AS-IS 30건, TO-BE 32건. AS-IS만 '-', 'AZ00-A' · TO-BE만 'AC00-A', 'PL01279700_40-P'. 원천 UP_FX_GetCommonDataList_SCP PlantSiteByDivision(STRING_SPLIT 보조 조건)이라 자동 대조 불가 |
| D6 | EG-942cf54f (N1) | SCM_MST_SITE_ITEM AS-IS 키 24건 TO-BE 없음이 이관 누락인지 | AS-IS 키 127,575건 중 24건(예 82//ST00-P/EP096636PFBAD0D2). 사업부 82 ST00-P 품목. 비활성 코드 여부 미확인 |
| D7 | T-d1bd8978 (A6), T-bab6f023 (F4) | AS-IS Model 팝업(SCM0002, PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)을 공용 COM0013 MaterialByDivisionModal 로 바꾼 것을 받아들일지 | ShipmentModelPic.tsx:545~558 주석에 2026-10-12 사용자 지시로 교체라고 적힘. 이번 CheckList PKG_SCM0002 호출 0건, COM0013/materialByDivision/SEARCH HTTP 200. 팝업 교체를 정한 확정 룰은 원장에 없음. 대조표 갱신은 FE_GUIDE_20261119_1647.md G5 |
| D8 | EG-29c0f2b6 (A1, 사람) | 실전송 건수 비교에 쓸 시험 계정 지정 | '[측정 경로 없음] AS-IS 0행 · 양쪽 Measure 칸 설정이 있는 사용자 없음'. tools/E2E/users.json 에 지정 필요(비밀번호는 사용자 입력) |
| D9 | V-e96d7a0a (B7) | Team 조회조건이 없는 화면에 DMF0005 결함 유형 'Team 조회조건 후보' 행을 대상 없음으로 둘지 | AS-IS 조회조건 콤보 = Div, Operation group, From Site, Valid 4개(combo_src.csv). Team 없음. 검사기에 대상 없음 근거 경로가 없어 판정을 바꾸지 않음. B7 원천 해석(T380) 뒤 (b-재진입) 실측으로 판정됨 |
