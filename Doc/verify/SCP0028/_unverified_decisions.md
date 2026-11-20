# SCP0028 결정 목록 · 2026-11-20 08:24

| 결정 | 행 ID | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-d9f71764, V-d7cde174, V-a5e26726, V-fbb3bbaf | 화면 결함(필수 안내 없음)으로 FAIL 처리할지, 공란 입력 뒤 수정 상태 확인 검사를 먼저 넣을지 | AS-IS SaveData(cs:583~609)는 한 칸만 비운 수정 행을 수정 건수에 세고 checkRequiredOfSpread 필수 안내로 막음. TO-BE 실측 '저장 요청·안내 모두 없음'. 공란 입력이 수정 상태(M)를 만들었는지 실측 없음 |
| D2 | EG-ea38ffcb | 공용 모달 결함으로 볼지(다른 화면 공통), TO-BE 룰로 볼지 | AS-IS 팝업 더블클릭 = 선택 후 닫기(SCM0002_ItembyDivisionPopup.cs:316~320). TO-BE 공용 모달(COM0013 MaterialByDivisionModal) 더블클릭 뒤 닫히지 않음(OK 경로는 반영) |
| D3 | T-fad117f6, T-2c20a3fc | Model 팝업 COM0013 교체를 TO-BE 룰로 등록할지(등록하면 FX-018·019 오류 제외), AS-IS 팝업으로 되돌릴지 | 대조표 17행이 쓰지 않는 SP(P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)를 적음. FE 가이드 FE_GUIDE_20261120_0817.md G1. 팝업 교체(COM0013)는 코드 주석 '사용자 지시 2026-10-08' 말고 등록 룰 없음(fixlist FX-SCP0028-018·019 AI 검토 실결함) |
| D4 | V-480372c9, V-86b2f489 | 권장안 PASS(전달 방식 차이). 승인하면 판정 경로에 넣음 | AS-IS 팝업 고정 플래그 _action_flag D·I 를 TO-BE 는 setBatchMode(I·D)로 전달(ShipmentLotSize.tsx:338~344). CR-096 은 공용 검색 모달 대상이라 화면 고유 일괄 팝업에는 직접 해당 안 함 |
| D5 | V-5d06fca9 | 권장안 PASS(AS-IS 원문과 같음). 승인하면 B6 기준표 없는 화면 경로를 AS-IS 사실(combo_src args)로 판정 | AS-IS cboValid.DataBind(Data.Type.YesOrNo, true)(cs:135) = 단일 콤보 + ALL. TO-BE 단일 + ALL(실측 다중=false · ALL=true). 조회조건 기준표 행 0 |
| D6 | EG-6cc339e1, EG-273588ca | 건수 표시는 CR-100 처럼 TO-BE 팝업 룰로 볼지. DATA 는 From Site 를 채운 뒤 재는 검사기 보완(다음 라운드) 승인 | 일괄입력 팝업: 건수 문구 없음(DM-C8 기대) · 'I' 진입 자동 조회 없이 Find 때 From Site 필수 알림(AS-IS 같은 동작 cs:261~266)으로 행 0 |
| D7 | EG-bd80125c | 메시지 코드 등록 뒤 FE 가이드 작성 여부(DB MODE) | 화면 고정 한글 '{0}은 {1} 보다 클 수 없습니다.'(useShipmentLotSizeValidation.ts:52) |
| D8 | V-15f47ff2 | CR-116 등록 확인 · 두 그룹 EDIT 권한 데이터를 AS-IS 와 맞출지 | CR-116 등록(사용자의견 SCP0104 V-24ff60ab 일반화). TO-BE 권한 설정에 SCP0028 EDIT 없는 그룹 2개(CAPA Planner, SSP ADMIN · AS-IS CRUD) |
| D9 | V-f3e94ee4, V-e9891c92, V-2611b990, V-9b370c0f, V-df3bcadf | 권장안 NA(대상 없음). 승인하면 판별 규칙 반영(지난 라운드 D7 과 같음) | 다른 화면 연쇄 결함 유형(DMF0003·DMF0082 AS From Site, DMF0005 Cust Group, Measure, 상위 셀 cascade). SCP0028 그리드 연쇄 칸 없음(C2 TRACE 2행 NA). 칸 이름(From Site·Active)만 겹침 |
| D10 | V-a99ddb18 | 저장하지 않고 편집으로 조건을 만드는 시험 허용 여부 | H2 배경색 조건(M 행, LOT_SIZE와 INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0(Div 40 265행) |
| D11 | T-6dc0e2d5, T-52d59336 | 공용 SP 를 화면 단위 대상으로 둘지 | PR_GET_MNU_BTN_AUTH 정렬(A6)·시노님(DB-SYN). 공용 권한 SP(PKG_NSCM_UI_COM_AUTH) |
