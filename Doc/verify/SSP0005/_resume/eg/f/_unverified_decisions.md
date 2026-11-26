# SSP0005 미검증 결정 목록, 라운드 1, 2026-11-20

| 번호 | 행 ID | 정할 내용 | 근거 |
|---|---|---|---|
| D-01 | V-dd7c2ad9, V-d9d87624 | 스냅샷 2건 승인 여부 | snap_validate.py(10:0x) MISMATCH 2건. 조회조건_Div_40 누락 [Plant Site], 버튼_Div_40 누락 [GET_SCP_PERIOD]. GET_SCP_PERIOD 는 화면 버튼이 아닌 조회 코드라 기대값 확인 필요 |
| D-02 | T-9c47fb04, T-c02b5322 | 대조표 X-LOC 2행 구현 위치 보강 여부 | DB MODE 라 대조표(FE 폴더) 수정 안 함. AI 검토는 '해당 없음', '0건' 행에도 구현 위치를 요구하는 검사기 문제로 봄. 미확인 |
| D-03 | V-fe598693, V-704a25d6, V-3eb21b5c, V-c851f50b, V-ebc184b9, V-c9bd2b82, V-4ee21f62, V-f6f2c4b9, V-b263da2c | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)를 TO-BE 에 둘지, 기준표를 Company(단일)로 고칠지 | tools/Harness/rules/search_cond.csv 628행(src_row 968). AS-IS Designer 조회조건 = Company, Division, Period, Day of the week, Input Value. TO-BE 화면 = Company(LBL00047) |
| D-04 | EG-397e1a0f 외 J2 5행, EG-ffe74885 외 K4 5행, EG-be85b4af, EG-434d8ee2, EG-49decbad | Insert, Delete 권한이 있는데 툴바 버튼을 숨긴 것이 맞는지 | AS-IS InsertButton 본문 주석 1줄(행 추가 기능 없음). 기대 = CR-070 버튼 권한 합집합 노출. TO-BE 룰 원장에 '기능 없는 버튼 숨김' 규칙 미확인 |
| D-05 | EG-7cce21d1, EG-de6ec4d2, EG-2d8daf5d, EG-8fa997a6 | 기준정보 키 대조 범위를 화면 SP 참조 표로 줄일지, Company 후보 25건 비활성 판정 | 화면 SP 4개는 SSP_MST_SHIP_CALENDAR, SCM_SYS_CALENDAR_M 만 참조. SCM_MST_PLAN_DETAIL 11건, SCM_MST_PROJECT 3건, SCM_MST_SITE_ITEM 24건 누락은 이 화면과 무관. FP_MGR.SCM_COMPANY_M Active 조건 AS-IS 콤보 SQL 미확인 |
| D-06 | V-9c955342, EG-36e64c07 | Division 초기값(ALL 표시)과 후보 EE 누락 판정 | 초기값 칸 입력값 '​'(placeholder ALL). EE 는 Division 원장 유효값 밖 코드인지 미확인 |
| D-07 | V-6f1aea63 | MSG00135(편집 모드 아님) 막기를 Bulk Update 모달 OK 단계(MSG00719)로 옮긴 것을 같은 동작으로 볼지 | CR-103 편집 버튼 없음. 검사기는 모달 열기 직후 알림만 봄 |
| D-08 | FACT-3ddf08b1, FACT-46f9e6c0, FACT-1b8d4243, FACT-c1215450, FACT-22d28d04, FACT-84c8a011, FACT-305e97da, FACT-998312f7, V-803fc0b5, V-ec9e8596, V-8bccac42, V-b4c1b701 | AS-IS 사실 추출기 보완(D_ 동적 콤보 컬럼, cboInputValue DataBind, DefColumns 상수 COMPANY→COMPANY_ID, 호출되지 않는 ClearUsrCheckedList 매개변수 control) | 이번 라운드 미착수. 다음 라운드 대상 |
| D-09 | T-c7d508e6, T-7407a2ae, T-85585e48, EG-a594e950, V-23e055de, V-21c0cf89, T-ff291a6c, V-d8993ea0, V-ce2c787d, V-0ac85697, V-fbce9494, 원장 판정필요 A1 집계 16행 | 검사기 미착수 항목(버튼코드-프로시저 연결, API 별칭 골든 매칭, perDiv 빈 키, 가드 유형, combo 순서 COND 경로, golden cols 없음, 기간 역전 입력, 달력 열기, 기간 조건 Like 대상) | 이번 라운드 미착수. 0행 해소 뒤 다음 CheckList 결과로 다시 분류 |
| D-10 | V-f2bd7c17 | DIVISION_ID 헤더 글자 잘림(글자 50 > 칸 47px) 수용 여부 | 사람 판정 행(T102) |
