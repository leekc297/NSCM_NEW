# SDM5010 Project Master 화면설계서 — 정오표 (설계자 확인용)

> 대상: `Doc/화면설계서_SDM/SDM5010/SDM5010_ProjectMaster_화면설계서_20260813.xlsx` (v1.0 확정 2026-08-04, 김태종) + SP 원문 `SQL_PACKAGE/PKG_SDM5010.txt`(1,122줄, KTJ 2026-08-14) + `TABLE/` DDL 2본.
> 작성: 2026-08-19 — 설계서 10시트 전수 덤프(openpyxl + drawings XML 도형 파싱) + PKG 전문 정독 실측.
> 처리 방침(hook #134 §0): **정정 구현 + 본 정오표 기록** — 설계자 확인 후 상이 시 회신 요청. 미결은 임의 완성 금지("설계 미완" 사유로 대사표 제외 처리).
> 양식: 3열(| # | 원문·실측 근거 | 적용 방침(확정) |).

## 1. PKG 결함 (D1~D24) — D1~D6·D10~D13 = **치명 결함 정정 승인(기확정)** / D7~D9·D14~D24 = 관찰 유지

| # | 원문·실측 근거 | 적용 방침(확정) |
|---|---|---|
| D1 | **TAB2 저장 SP 부재** — 설계서 TAB2 시트 B43~K47 이 `P_SDM5010_SAVE_TAB2_PJT_MASTER`(P_ACTIVE_FLAG/P_DPJT_KEY/P_DPJT_DEVELOP_STATUS/P_DISABLED/P_SES_USER_ID) 를 정의하나 PKG 는 4본(GET_TAB1/CANCEL/CONFIRM/GET_TAB2)뿐 — 스펙·바디 전문 실측 | **신규 작성 승인(기확정)** — 설계 계약 5-IN + O_RESULT_CURSOR. P_DISABLED↔`DPJT_MGMT_STATUS`('DISABLED'/'NORMAL') 매핑(F-20)·'M' 한정(P-13)·계약 외 CRUD_TYPE 거부(SDM1010 [가드 0] 판례)·CODE/MSG/EVENT 표준 커서 |
| D2 | **`'DIABLED'` 오타 2곳** — CANCEL L447·CONFIRM L699 가 `DPJT_MGMT_STATUS='DIABLED'` 기록. GET_TAB2 의 DISABLE_YN 판정 철자는 `'DISABLED'`(L869) → 오타 기록 행은 비활성 체크 표시 불가 | **`'DISABLED'` 정정 승인(기확정)** — 기록·판정 철자 통일. 기존 오염 행 데이터 정정 스크립트 동봉 |
| D3 | **CANCEL 부모행 복구 WHERE 결함** — "원 Project Code 상태 복구 : MODIFYING => COMPLETE" UPDATE 가 `WHERE DPJT_KEY = P_DPJT_KEY`(L464 — 자기 행) → 반려 직후 본행을 COMPLETE/NORMAL 로 되덮어 **반려가 소멸**(L443~450 REJECT 기록이 즉시 무효화) | **`WHERE DPJT_KEY = P_DPJT_KEY_PARENT` 정정 승인(기확정)** |
| D4 | **CONFIRM 원본행 전이 WHERE 결함** — "원 Project Code 상태 변경 : MODIFYING => MODIFIED" UPDATE 가 `WHERE DPJT_KEY = P_DPJT_KEY`(L701 — 자기 행) → 승인 직후 본행(COMPLETE/NORMAL, L682~684)을 MODIFIED/DIABLED 로 되덮어 **승인이 소멸** | **`WHERE DPJT_KEY = P_DPJT_KEY_PARENT` 정정 승인(기확정)** |
| D5 | **SPMS_PROJECT_USER_MAP 동기 부재** — CONFIRM 신규 Case 가 `DPJT_KEY` 를 `V_DPJT_CODE⏐⏐'_'⏐⏐SEQ` 로 재구성(L658)해 UPDATE(L672)하나 권한 원장 USER_MAP(PK DPJT_KEY,USER_ID — DDL 실측) 의 DPJT_KEY 미동기 → 기존 권한/요청 행 **고아화** + 권한등록 상태(USM 카운트) WRITING 회귀 | **동기 UPDATE 추가 승인(기확정)** — 승인 시 USER_MAP DPJT_KEY(+비정규 복제 DPJT_CODE/DPJT_SEQ/DPJT_NAME) 동기. 반려(CANCEL) 경로는 원장 유지(고아 미발생 — KEY 불변) |
| D6 | **OR 관용구 4곳** — `IF (X IS NOT NULL OR X != '')`(CANCEL L455·CONFIRM L653·L692) + WHERE `(V_DPJT_CODE IS NOT NULL OR V_DPJT_CODE != '')`(L686): Oracle ''=NULL 로 `!= ''` 상시 UNKNOWN → 전체가 `IS NOT NULL` 로 축약(의도가 AND 였어도 등가) | **`IS NOT NULL` 단일화 정정 승인(기확정)** — 기능 등가·오독 방지 정리(Oracle 빈문자열 판례) |
| D7 | GET_TAB1 파라미터 `P_SES_MENU_ID`/`P_SES_USER_GR_ID` 수신만 하고 WHERE/SELECT 미사용 (전문 실측) | 관찰(경미) — as-is 수용. 시그니처 유지(설계서 K28/K29 Session 계약) |
| D8 | `DIVISION_NAME`(L137 `DIV.DIVISION_ID` 재-alias)/`END_CUSTOMER_NAME`(SITE END_CUSTOMER 재-alias)/`SOP_PLANT_NAME`(SCM_SITE_ID 재-alias) — 실명칭 아님 | 관찰(경미) — as-is 수용(CODE=NAME 무증상 — SDM1020 D8·CMBO Division 판례 동형). 실명칭 요건 확정 시 SP 보완 |
| D9 | `SCM_MST_SSO_USER_INFO`/`SCM_MST_SSO_DEPT_INFO` **INNER JOIN**(TAB1·TAB2) — MGMT_USER_ID 미등재(퇴사 등)/부서 미등재 시 프로젝트 행 소실 | 관찰(경미·실측 대기) — SDM1020 D9 동형. 사내 원장 대조 후 LEFT 전환 여부 판단, 임의 수정 금지 |
| D10 | **CONFIRM `SELECT INTO` 무가드**(L646~650) — 대상 DPJT_KEY 부재 시 NO_DATA_FOUND → 공통 핸들러 -20001 raw 전파(사용자 메시지 없음) | **NO_DATA_FOUND 예외 분기 정정 승인(기확정)** — VALIDATION_FAIL 경로(CODE='-1' 커서)로 회수 |
| D11 | **신규 Case SEQ 채번 부재 + TO_CHAR 리딩 공백** — L658 `V_DPJT_KEY := V_DPJT_CODE ⏐⏐ '_' ⏐⏐ TO_CHAR(N_DPJT_SEQ,'000000')` 이 요청 행의 기존 DPJT_SEQ 재사용(채번 없음) + `TO_CHAR(n,'000000')` 은 부호 자리 공백 포함(`' 000001'`) → KEY 오염 | **SEQ = `MAX(DPJT_SEQ)+1`(DPJT_CODE 단위) 채번 정정 승인(기확정)** — SDM1020 BTN_REQ 채번 패턴 정합 + `FM000000` 포맷(공백 제거) |
| D12 | **6자리 가드 실패 = 허위성공** — CONFIRM UPDATE WHERE `LENGTH(V_DPJT_CODE)=6`(L687) 불충족 시 0건 갱신인데 결과 커서는 `CODE='0'/EVENT` 합산만 반환(L729~730) → 승인 무동작 허위성공. VALIDATION_FAIL 라벨(L737)은 `RETURN` 뒤 사문(도달 불가) | **정정 승인(기확정)** — FE 선검증(P-08 6자리) + SP 는 갱신 0건 시 CODE='-1' 실패 커서 반환(사문 라벨 활용 또는 IF 분기 — 주석 부활 방식 금지, hook #138) |
| D13 | **`'MODIFIED'` lookup 정합** — CONFIRM 이 원본행에 `DPJT_REG_STATUS='MODIFIED'`(L698) 기록하나 확정 등록상태 9항목 도메인(SDM1020 D13 — DRAFT/WRITING/WAITING/COMPLETE/REJECT/CHG_REG/MODIFYING/REQ_MOD/CHG_COMPLETE/CHG_REJECT)에 'MODIFIED' 부재 → GET_TAB2 RGS INNER JOIN(L1062 NOT IN 통과 후)에서 **행 소실** | **lookup 정합 정정 승인(기확정)** — 확정 도메인과 통합: 'MODIFIED' 리터럴을 도메인 등재값으로 정합(등재 or 리터럴 교체 — SDM1020 확정 목록 관리 주체와 동기, `08_LOOKUP_REG_STATUS_FULL.sql` 계보) |
| D14 | **TAB1 본인 필터** — `MGMT_USER_ID = P_SES_USER_ID`(L321): 관리자 승인 화면인데 본인 관리 프로젝트의 요청만 표시 | **설계 원문 유지 — 사용자 확정(기확정)**. SP 무수정. 관리자 전체보기 요건 발생 시 설계자 회신 후 보완 |
| D15 | SMD(Stack 공법) 서브쿼리가 SEGMENT2(cellType) 를 SELECT 하고도 ON 절은 division+stackMethod 2축만 — 동일 공법이 복수 cellType 에 등재되면 **행 곱**(TAB1·TAB2 동형) | 관찰(경미) — lookup 데이터가 (division,stackMethod) 유일이면 무증상. 도메인 정비 시 cellType 축 추가 여부 판단 |
| D16 | GET_TAB2 SELECT 목록 `PJM.REG_COMP_DATE` 2회 중복(L860·L870) | 관찰(경미) — 커서 동명 2컬럼(후행 무시 관례). D1 외 SP 무수정 원칙상 유지 |
| D17 | CANCEL 본행 `NOTE = P_NOTE` 덮어쓰기(L448) — 목업 NOTE 규약(TAB1_GRID S17 "기존 내용이 존재하면 딜리미터 후 내용 연결")과 상이(연결은 MERGE 전파 축에만 적용) | 관찰(경미) — as-is 수용. 본행 덮어쓰기가 의도인지 설계자 확인 요청 |
| D18 | 주석 결함 — CONFIRM `'NORMAL' -- 비활성`(L681)/`'DIABLED' -- 정상`(L699) 역전, CANCEL/CONFIRM Description "프로젝트 권한 요청 반려/승인"(실제는 등록 요청), CANCEL 승인 블록에 "반려 Process 처리" 주석 재사용 | 관찰(경미) — 주석은 분석 근거도 적용 대상도 아님(hook #138). LIVE 코드 기준 판정 유지 |
| D19 | 예외 JSON_OBJECT 파라미터 누락 — CANCEL 은 P_NOTE 누락, CONFIRM 은 15 IN 중 4종만 기록 | 관찰(경미) — 로그 축 부족. 정정 반영 시 함께 보강(선택) |
| D20 | GET_TAB1/GET_TAB2 커서 ORDER BY 부재 | 관찰(경미) — 정렬 FE 몫(SDM1020 O-6 동형) |
| D21 | CANCEL(L488)/CONFIRM(L724) **내부 COMMIT 보유** — E2E 직접 호출 시 rollback 무의미 | 관찰 — 검증은 집합 불변식 복원 방식(저장 SP 직접 호출 판례) |
| D22 | 템플릿 잔재 — 미사용 변수(VERSION 계열 6종·N_MAX_CNT·N_CNT·V_DPJT_KEY/V_NOTE[CANCEL]·N_DEL/INSERT_COUNT) + `RETURN` 뒤 VALIDATION_FAIL 블록 사문(L501/L737) + `ALTER SESSION SET optimizer_dynamic_sampling=2`(GTT 미사용 SP 에도 존재) | 관찰(경미) — 무해. 사문 라벨은 D12 정정 시 실경로로 활용 |
| D23 | RGS(등록상태 lookup) INNER 조인이 NAME/COLOR 를 산출하고도 커서 미출력 — 필터 겸 도메인 검증 축으로만 동작(TAB1 은 WAITING/REQ_MOD 한정이라 무해, TAB2 는 D13 소실 축과 연동) | 관찰(경미) — D13 정정으로 실질 해소. 등록상태 표시 요건 발생 시 커서 추가 |
| D24 | USM(권한등록 상태) 카운트가 REQUEST 상태 행 포함 — 제외 조건 `AND USM.SPMS_DPJT_AUTH_STATUS != 'REQUEST'` 는 **주석 처리 상태**(LIVE 는 전행 COUNT) → 요청만 있어도 COMPLETE 판정 | 관찰(경미) — 주석은 근거 아님(hook #138): LIVE 기준 수용. 판정 의도(요청 제외 여부) 설계자 확인 요청 |

## 2. 설계서 결함·확정 (F-1~F-23)

| # | 원문·실측 근거 | 적용 방침(확정) |
|---|---|---|
| F-1 | 기간 SP = 개요 H18 `P_SDM1010_GET_PERIOD`(P_FR/TO_BUCKET·DATE_VAL·BUCKET_TYPE·P_SES_USER_ID 7-param 설명) — 실서명·실배선은 `PR_GET_DAY_RANGE` **5-arg**(`p_created_by`/`p_month` IN 2 + `O_RC1`/`O_RC2`/`O_RESULT_CURSOR` OUT 3 — census 원문 실측) | **PR_GET_DAY_RANGE 5-arg 확정(기확정)** — SDM1010 R4(GET_PERIOD 결함)·SDM1020 계약 ⑤ 판례: o_rc2 DAY_RANGE 앵커 + FE dayjs 병행으로 M-1~Today 산출 |
| F-2 | 조회조건 라벨 "등록 요청일"(B18) vs 개요 버튼 F25 "등록완료일 필수" vs TAB2 SP 파라미터 `P_REG_COMP_DATE_FR/TO`(H40/H41 "등록 완료일") — 기간 축 명칭 혼선 | **기간 = REG_COMP_DATE 확정(기확정)** — 실필터 축(GET_TAB2 BETWEEN 원문). 라벨은 '등록 완료일' 계열로 정정 등재 |
| F-3 | TAB1 조회 파라미터 = Session 4종만(TAB1 시트 H26~H29) — 조회조건 6종 미전달 | **조회조건 = TAB2 전용 확정** — SDM1010 "조회조건 TAB2 전용화" 판례 준용. TAB1 은 Search 시 Session 기반 재조회만 |
| F-4 | 조회조건 LBL 공란 5건 — 사업부만 LBL00001(C13), 고객/Cell 유형/Biz Type/개발 현황/등록 요청일 공란(C14~C18) | 기존 LBL 실값 검증 후 재사용, 없으면 신규 채번(hook #98 §7 4단 — T-3) |
| F-5 | 버튼 다국어 코드 전부 '-'(C24~C28) | 공통 버튼 코드 사용(조회/저장/엑셀/컬럼설정 — 표준 버튼 메타) |
| F-6 | TAB1 승인/반려·TAB2 3년·팝업 메시지 코드 열 공란(TAB1 F64~F70·TAB2 F54·팝업 F79~F84) | 재사용 우선 매핑(MSG00002/00003 등 locales 실문구 대조) + 부재분만 01001+ 신규 채번(T-2) |
| F-7 | 오타 "실해하였습니다" 2건(TAB1 F66 반려 실패·F70 승인 실패) | "실패하였습니다" 로 정정 등재 |
| F-8 | TAB2 3년 제한 문구(F54) MSG 공란 | MSG00164 재사용 후보(DMF0021 동문 판례) — locales 실문구 대조 후 확정(T-2) |
| F-9 | **수정 시 D-PJT Code 편집 모순** — 확인 사항 2.1 "(등록) 구분 값이 '수정' 인 경우 D-PJT 코드 수정 불가"(B80) vs 2.2 수정 항목 목록(C82)에 'D-PJT Code' 포함 | **확정(기확정): '신규' 행만 D-PJT Code 편집(6자리 P-08), '수정' 행 편집 불가** — SP CONFIRM 수정 Case CODE 유지(L653~655)와 정합 |
| F-10 | 색상 표시 — 1.1 "구분 값이 '수정' 인 경우 색상 표시" + 1.1.1 "수정된 항목에 대해 별도 색상 표시"(필드 단위 해석 여지) — GET_TAB1 커서에 원본(수정 전) 값 부재 실측 | **DPJT_REG_CAT 기준 행 단위 색상 확정(기확정)** — 필드 diff 불가 확정. 색상 토큰은 미기재(T-7) |
| F-11 | 라벨 오타 — `Stock Method`(F12/F38 →Stack)/`Develoment Status`(F52 →Development)/`Project Authroty Registration`(C56~C103 →Authority)/`Reg Reg. Date`(F44 →Reg Req. Date) | LBL 등재 시 정표기로 정정(SDM1020 D11 동형 — 목업은 'Stack 공법' 정표기) |
| F-12 | `DPJT_ATUH_*` 컬럼명(AUTH 전위 오타) — UI컬럼 시트 4종(TAB1 E20~E23/TAB2 E48~E51) = SP 커서 alias(L146~150·L863~867)와 동철자 | **커서 실명 유지 확정(기확정)** — SDM1010 판례(SHEET_COLUMNS 도 오타 철자 등재, 커서와 1:1). 정정 등재 금지 |
| F-13 | TAB2 Sort Order 중복 3조 — 170(CNFM_USER_ID·DPJT_ATUH_REG_STR)/180(CNFM_USER_NAME·DPJT_ATUH_REG_STATUS)/240(REG_REQ_DATE·REG_COMP_DATE) + DISABLE_YN 160 이 목업 말미(V열 비활성)와 불일치 | **TAB2_GRID 목업(행11) 열 순서 기준 SORT_ORDER_NO 전면 재부여** — 요청~내용→최초 요청일→최종 등록일→승인자→권한 관리(관리·상태)→개발 현황→비활성(SDM1020 D6 판례) |
| F-14 | Input Type 전 행 'S'(TAB1 W4~W27·TAB2 W30~W53) — TAB1 확인 사항 2.2(수정 항목 11종)·TAB2 편집 2컬럼과 모순 | 편집 컬럼에 한해 INPUT_TP_CD 재지정: TAB1 수정 항목 = M/O 계열(콤보 `IO`·텍스트 `IM` — D-PJT Code 는 신규 행 한정 F-9), TAB2 `DPJT_DEVELOP_STATUS`/`DISABLE_YN` = `IO`, 나머지 'S' 유지(SDM1010 #11 판례) |
| F-15 | TAB1 `REG_COL`(등록 컬럼, Cell object=Button, T6 '등록') — SP 는 `'' REG_COL`(L153) 빈 문자열만 반환 | **FE 파생 렌더 확정** — 행 내 승인/반려 버튼(E06/E07 배선). 메타는 시트 기재대로 등재 |
| F-16 | TAB1_GRID S16~S21 NOTE 전파 규약("연결된 프로젝트 모두 동일 내역 Update, 기존 내용 존재 시 딜리미터 후 연결" — MC25/26/27 예시) | SP MERGE(동일 DPJT_CODE 전행, `', '` 딜리미터) 대응 확인 — P-11 등재. 본행 덮어쓰기 상이는 D17 |
| F-17 | 조회조건 Cell 유형 = `SCM0001_GET_LOOKUP_VALUES('SPMS_CELL_TYPE')` — 종속 명기 없음(H15). lookup 실구조는 SEGMENT1=DIVISION 축 보유(PKG CLT 조인 실측) → 전 division 값 노출 | 설계 원문 유지(비종속) + 관찰 기록 — division 종속 요건 확정 시 콤보 교체(설계자 확인 요청) |
| F-18 | Biz Type 콤보 병기 — UI컬럼 N13/N39 "DmBizType (or BizTypeByDivision)" + 개요 G16 `DmBizType`·H16 "Biz Type 선택 (사업부에 종속)" | **BizTypeByDivision 확정(기확정)** — 종속 요건 정합(SDM1020 CF-12 판례). 조회조건·셀 콤보 동일 적용 |
| F-19 | 권한 그룹 = "SPMS Administrator"(개요 C7 — 단일 기재) | **SPMS Administrator 단독 확정(기확정)** — SDM1020(Planner 병기)과 달리 단독. 버튼 권한 메타도 단독 그룹 등재 |
| F-20 | TAB2 저장 파라미터 `P_DISABLED`(H46 '비활성') — 원장에 DISABLED 컬럼 없음(DDL·PKG 실측: 관리 상태 = `DPJT_MGMT_STATUS`) | **`DPJT_MGMT_STATUS` 매핑 확정** — CHECKED→'DISABLED'/UNCHECKED→'NORMAL'(GET_TAB2 L869 판정과 왕복 정합, D2 철자 정정 전제). D1 신규 SP 계약 반영 |
| F-21 | 개발 현황 lookup `SPMS_DPJT_DEVELOP_STATUS` 시드 미기재 — 목업 도메인(TAB2_GRID U13~U15: 개발/Drop/양산)만 존재 | **임시 시드 DEV(개발)/PROD(양산)/DROP(Drop) — 기확정(임시)**. 실값은 사용자 확정 대기(T-4) — 확정 시 lookup 데이터만 보정 |
| F-22 | 권한관리 팝업 — 시트 전문이 SDM1010 권한관리와 동일(SP 8본 전부 `P_SDM1010_*` 기재 + UI컬럼 시트 POP1_* 블록 Program ID=SDM1010) | **SDM1010 계열 공용 `ProjectAuthRegModal` 재사용 확정** — 신규 작성 금지(SDM1020 O-5 판례). POP1_* 메타는 SDM1010 기등재 소비(재등재 금지) |
| F-23 | 메뉴 위치 = "샘플 수요 > Administration"(개요 B5) | SCM_ADM_MNU_M 등재 + **features/sdm 배치 확정**(Step 3.5 트리 walk-up — SDM 계열 = `nscm-fe/features/sdm/src/pages/project-master/`) |

## 3. 미결 (T-1~T-12 — 설계 미완, 임의 완성 금지, 대사표 "설계 미완" 사유 처리)

| # | 원문·실측 근거 | 상태 |
|---|---|---|
| T-1 | **컬럼 설정 버튼 호출 SP `?`**(개요 K28 — F28 "Popup - ColumnSettingModal 호출") | SP 임의 배선 금지(SDM1010 정오표 #14 판례) — 설계서 확정 기재 시 배선 |
| T-2 | **MSG 코드 공란 전수** — TAB1 승인/반려 6문구 + TAB2 3년 1문구 + 팝업 5문구 | 구현 시 locales 실문구 대조 후 재사용 우선(MSG00002/00003·MSG00164 후보 포함), 부재분만 01001+ 대역 신규 채번(공번 메우기·전대역 max+1 금지) |
| T-3 | **LBL 공란 5건** — 조회조건 고객/Cell 유형/Biz Type/개발 현황/등록 요청일(C14~C18) | 기존 LBL 실값 검증 후 재사용, 없으면 신규 4단 채번(hook #98 §7) |
| T-4 | **개발 현황 lookup 시드 미기재** — F-21 임시 시드 DEV/PROD/DROP | **임시 — 사용자 확정 대기.** 확정 시 lookup 데이터 보정(코드 체계 변경 시 원장 `DPJT_DEVELOP_STATUS` 기록값 동기 필요) |
| T-5 | **TABLE 폴더 DDL 구본** — `SPMS_PROJECT_MST.txt` 34컬럼(PKG 사용 `DPJT_MGMT_STATUS`/`DPJT_KEY_PARENT`/`CNFM_USER_ID` 3컬럼 부재)·`SPMS_PROJECT_USER_MAP.txt` 21컬럼 — **DB 실물 37/22컬럼이 정본(기확정)** | DDL 파일 기준 스키마 판단 금지 — DB 실물 딕셔너리 실측이 정본. 설계 발신처에 DDL 재수신 요청 |
| T-6 | **초기 자동조회 여부 미기재** — 개요·기능 상세 전체에 화면 진입 시 자동 조회 정의 없음 | 확정 전 자동조회 미배선(Search 버튼 대기 — SDM1020 U-08 동형) — 설계자 확인 요청 |
| T-7 | **'수정' 행 색상 값 미기재** — 행 단위 확정(F-10)이나 색상 토큰/범위 정의 없음(hook #95 3색 표준 밖 별도색) | 색상 토큰 확정 대기 — 확정 전 공통 warning 계열 임시 적용 여부 포함 설계자 확인 요청 |
| T-8 | **DPJT_MGMT_STATUS 도메인·전이 정의 부재** — PKG 리터럴 NORMAL/DISABLED(+SDM1020 'TEMP') 만 존재, 설계서에 관리 상태 정의 없음 | as-is 수용(SDM1020 U-06 동형) — 도메인 확정 요청 |
| T-9 | **비활성 체크 저장 후 효과 미정의** — TAB2 비활성('DISABLED') 프로젝트의 타 화면(SDM1010/1020 등) 노출·사용 제한 정책 부재 | 이번 범위 = 저장·표시만. 정책 확정 요청 |
| T-10 | **승인 시 D-PJT Code 유일성 검증 미정의** — 개요 F26 "중복값 확인" 은 TAB2 저장 문맥, CONFIRM 에는 타 프로젝트 동일 CODE 중복 가드 부재(6자리 가드뿐 — L686~687) | 임의 가드 추가 금지 — 유일성 축(CODE 단독 vs CODE+SEQ) 확정 요청. NOTE 전파(P-11)가 CODE 단위라 중복 시 오염 범위 확대됨을 부기 |
| T-11 | **User Selected Flag 의미 `?`** — UI컬럼 시트 U2 헤더 `?` 부기 | SDM1010 판례(개인화 플래그) 준용하되 값은 시트 기재 그대로 등재(SDM1020 U-07 동형) |
| T-12 | **REG_COMP_DATE NULL 행 기간 전멸** — GET_TAB2 는 REJECT 행 포함(NOT IN 3상태만 제외)이나 REJECT 행 완료일 NULL 이면 BETWEEN(L1085) 지정 시 소실(SDM1010 R8 동형) | 설계 의도(완료일 보유 행만 조회) 여부 확인 요청 — 확정 전 SP 무수정 |

## 4. 설계서 잔존 정리 권고 (구현 무관)

- 개정이력 2행(0.1 초안 2026-08-03 / 1.0 확정 2026-08-04) — 승인자 열 전부 공란.
- 레이아웃 시트는 도형(이미지) 위주 — 텍스트 셀은 " - TAB1"/" - TAB2" 뿐. 목업 실측은 `TAB1_GRID`/`TAB2_GRID` 시트 + drawing6/7/8 도형 텍스트로 대체(hook #134 §2-4).
- UI컬럼 시트 하단 POP1_TREE/GRID1~4 블록은 Program ID=SDM1010 — SDM5010 메타가 아니라 **재사용 참조**(F-22. SDM1010 기등재 메타 소비가 정본).
- 개요 시트 dims A1:AI320 이나 실데이터는 B2~F34 — 하단 빈 영역은 서식 잔재.
