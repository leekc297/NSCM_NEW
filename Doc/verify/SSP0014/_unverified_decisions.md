# SSP0014 미검증 결정 목록 (2026-11-19 17:0x · 라운드 2 갱신)

- 행별 조치는 `_unverified_plan.md`. 결정 7건(D1~D7), 행 11개. D8 은 라운드 2 에서 검사기 보완으로 처리
- 근거 칸의 DB 조회 시각은 그 줄에 적은 시각(사내 ZIOUI1 · AS-IS 개발 MSSQL .env.asis)

| 번호 | 행 | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-3bb51520 (K4, 사람) | 버튼 바 스냅샷 승인 여부. 기대 버튼 목록의 USER_CHECK 를 빼고 승인할지 | snap_validate.py 16:4x: 6건 중 MISMATCH 1, NA 3, OK 2. MISMATCH = 버튼_Div_40 기대 'USER_CHECK' 누락. USER_CHECK 는 저장 전 사용자 등록 검사 호출(useShipmentModelPicValidation.ts `/SSP0014/main/USER_CHECK/call-proc`)이라 버튼 바에 나오지 않음. 기대 목록 원천 = plan.json accounts[0].expectedBtns(btn_auth) |
| D2 | V-16ab0403 (A2) | 기준정보에 없는 출발 사이트 코드를 코드 그대로 보여 주는 것을 결함으로 볼지, 데이터 정리 대상으로 볼지 | FROM_SITE 'CN003256_40-A' 25행이 이름 대신 코드로 보임. 16:46 조회: TO-BE·AS-IS SCM_MST_SITE 0행, TO-BE SSP_MST_MODEL_USER 2행이 이 값 사용. AS-IS 화면이 같은 행을 어떻게 보여 주는지 미확인 |
| D3 | V-62f2170d (B4) | Operation group 후보 'Warranty' 표기 차이 판정 | AS-IS 는 콤보에 코드 W, 이름 'Warrnaty'(철자 원문) 를 직접 더함(SSP0014_ShipmentModelPIC.cs:183~187). TO-BE 후보 표시 '?Warranty'. 검사기가 TO-BE 표시값을 AS-IS 코드로 바꾸지 못함. 앞 글자 '?' 가 화면 표시인지 측정 문자 깨짐인지 미확인 |
| D4 | V-0db2d553 (B4) | From Site 후보 차이 2건이 데이터 차이인지 | 사업부 40: AS-IS 30건, TO-BE 32건. AS-IS만 '-', 'AZ00-A' · TO-BE만 'AC00-A', 'PL01279700_40-P'. 원천 UP_FX_GetCommonDataList_SCP PlantSiteByDivision(STRING_SPLIT 보조 조건)이라 자동 대조 불가 |
| D5 | EG-a6f6bebc (J1) | 사업부 후보에 EE 가 없는 것을 AS-IS 와 같다고 볼지 | 근거 후보: AS-IS UP_FX_GetCommonDataList 'MyDivision' 분기 `A.ATTRIBUTE3 <> 'EE'`(Doc/asisfacts/db/modules/dbo.UP_FX_GetCommonDataList.sql:365, 2018-07-05 'Division EE 제외' 이력 34행). 화면은 SSP_BIGFILTER 'MyDivisionCMM' 을 씀(combo_src.csv). MyDivisionCMM ↔ MyDivision 분기 대응 미확인. 대응이 확인되면 eg_auth.spec.ts DIV_FILTER 원천(combo_src.csv filters)에 넣어 기계 판정 |
| D6 | EG-942cf54f (N1) | SCM_MST_SITE_ITEM AS-IS 키 24건 TO-BE 없음이 이관 누락인지 | AS-IS 키 127,575건 중 24건(예 82//ST00-P/EP096636PFBAD0D2). 사업부 82 ST00-P 품목. 비활성 코드 여부 미확인 |
| D7 | T-a5fcd2ff (H6), T-3a730d4a (G5), T-049a5854 (M4), T-d1bd8978 (A6), T-bab6f023 (F4) | Model 팝업이 출발 사이트를 조건으로 받지 않는 차이를 받아들일지 | 라운드 2(17:0x): 화면 팝업은 2026-10-12 사용자 지시로 COM0013(MaterialByDivisionModal)로 바뀜(ShipmentModelPic.tsx:545~558). 대조표 오기는 FE_GUIDE_20261119_1647.md G5. AS-IS 는 clbFromSite 값을 _ScmSiteId 로 넘김(cs:849), TO-BE 는 divisionId, scmModuleType, operationGroup, itemId 만 넘김(popup_args.csv P25 NA '팝업 교체·조건 축소 여부 사람 확인') |
| D8 | 없음(라운드 2 처리) | 결정 불필요 | 원인 = AS-IS 상수 이름 DIVISION ≠ 칸 이름 DIVISION_ID(cs:77). 검사기 결함 T359 로 고침(mapping_trace.py) |
