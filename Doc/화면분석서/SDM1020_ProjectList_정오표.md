# SDM1020 Project List 화면설계서 — 정오표 (설계자 확인용)

> 대상: `Doc/화면설계서_SDM/SDM1020/SDM1020_ProjectList_화면설계서_20260814.xlsx` (v1.1, 2026-08-13 — "프로젝트 조회 → 프로젝트 조회/변경" 개명) + SP 원문 `SQL_PACKAGE/PKG_SDM1020.txt`(BODY 파일과 diff 0 실측).
> 작성: 2026-08-19 — 설계서 8시트 전수 덤프 + SP 3본 원문 전수 정독으로 실측한 결함 D1~D14 와 미결 항목 (D13·D14 = 2026-08-19 사내 보정 시 추가).
> 처리 방침(hook #134 §0): **정정 구현 + 본 정오표 기록** — 설계자 확인 후 상이 시 회신 요청. 미결은 임의 완성 금지("설계 미완" 사유로 대사표 제외 처리).

## 1. 확정 결함 (D1~D14)

| # | 설계서/SP 원문 | 실측 근거 | 적용 방침 |
|---|---|---|---|
| D1 | GET 커서가 `DPJT_AUTH_REQ_READ` 를 **2회 SELECT**(동일 CASE 중복 — 2번째 블록 주석은 "쓰기 권한"이나 판정은 READ) + UI컬럼 정의 시트도 `DPJT_AUTH_REQ_READ` **동명 2행**(FPCheckBox 행 + Exec. Link 행) | PKG_SDM1020.txt L198~208·L209~219 (`AS DPJT_AUTH_REQ_READ` 2회) / UI컬럼 시트 B32·B33 행 | 메타는 **커서 실컬럼 기준 1회만** 등재. 권한요청 링크 컬럼은 **FE 파생 컬럼**(예: `DPJT_AUTH_REQ_LINK`)으로 분리 — SP 무수정 |
| D2 | GET 커서 산출 컬럼명 `DPJT_AUTH_REQ_WRITE_NAME`/`DPJT_AUTH_REQ_WRITE_COLOR_TYPE` vs UI컬럼 시트 `DPJT_AUTH_REQ_STATUS_NAME`/`DPJT_AUTH_REQ_STATUS_COLOR_TYPE` 불일치 | PKG L179·L185 (커서 alias) vs UI컬럼 시트 B29·B30 (메타 컬럼명) | **메타를 커서명으로 정합**(`DPJT_AUTH_REQ_WRITE_NAME`/`_WRITE_COLOR_TYPE`) — TAG 3요소 = `DPJT_AUTH_REQ_STATUS`(값)+커서명 NAME/COLOR |
| D3 | BTN_REQ_PJT_REG 의 원본행 MODIFYING 전이 UPDATE 가 `WHERE V_DPJT_KEY = V_DPJT_KEY_PARENT` — **로컬변수끼리 비교**(신규 키 vs 원본 키 = 항상 FALSE) → 원본 상태 전이 0건 사문 | PKG L668~676 (L627 에서 PARENT 보관 후 L629 에서 V_DPJT_KEY 재할당 — 두 값은 SEQ 가 달라 상시 불일치) | **PKG 최소 정정 승인됨**: `WHERE DPJT_KEY = V_DPJT_KEY_PARENT` (컬럼 참조로 정정) |
| D4 | BTN_REQ_PJT_REG 에 `P_ACTIVE_FLAG`(I/D/M) 파라미터가 있으나 **분기 없음 — 항상 INSERT 경로**(변경본 신규 생성) | PKG L473~750 전문에 `V_ACTIVE_FLAG` 분기 IF 부재 실측 | **SP 무수정** — FE 가 **'M'(수정) 행만** 골라 전달(신규/삭제 성 행 전송 금지). '^' 벌크 계약 유지 |
| D5 | UI컬럼 시트 Input Type 이 **전 컬럼 'S'** — 확인 사항 1.1(관리자 수정 가능)과 모순 | UI컬럼 시트 W4~W33 전수 'S' 실측 | 편집 대상 컬럼에 한해 INPUT_TP_CD 재지정: Project Class/Customer/Project Name=`IM`, Cell Type/Stack Method/Biz Type/SOP Date/SOP Plant/개발 현황=`IO`, 나머지 `S` 유지 (SDM1010 정오표 #11 판례 동일) |
| D6 | Sort Order 중복 5조 — 120(SOP_PLANT_ID·DPJT_AUTH_TYPE·_NAME)/170(DEPT_ID·AUTH_REQ_STATUS 3형제)/180(DEPT_NAME·AUTH_REQ_WRITE)/190(MGMT_USER_ID·REG_STATUS·AUTH_REQ_READ)/200(USER_NAME·REG_STATUS_NAME·AUTH_REQ_READ 링크) | UI컬럼 시트 G열 전수 실측 | **GRID 목업(행10~11) 열 순서 기준 SORT_ORDER_NO 전면 재부여** — 사업부→유형→고객→PJT Name→셀 유형→Stack 공법→Biz Type→SOP 일정→SOP Site→D-PJT Code→관리자(부서·성명)→나의 권한→등록 상태→등록 완료일→개발 현황→권한 관리→권한 요청(등록·요청상태·입력·조회·요청) |
| D7 | `DPJT_AUTH_MGMT`(권한 관리 링크) Cell object **공란** | UI컬럼 시트 M27 빈 셀 실측 | **FPModal + ATTRIBUTE1** 규약으로 등재(모달 링크 표준 — SDM1010 권한등록 링크 판례) |
| D8 | `DIVISION_NAME`/`END_CUSTOMER_NAME`/`SOP_PLANT_NAME` 이 실명칭이 아니라 **ID 재-alias** | PKG L137(`DIV.DIVISION_ID DIVISION_NAME`)·L244(`SIT.END_CUSTOMER END_CUSTOMER_NAME`)·L307(`SIT.SCM_SITE_ID SOP_PLANT_NAME`) | as-is 수용(CODE=NAME 무증상 — CMBO Division 판례와 동형). 실명칭 요건 확정 시 SP 보완 — 설계자 회신 요청 |
| D9 | `SCM_MST_SSO_USER_INFO`/`SCM_MST_SSO_DEPT_INFO` **INNER JOIN** — MGMT_USER_ID 미등재/부서 미등재 시 프로젝트 행 소실 | PKG L372~379 | **미결(실데이터 실측 후 별도 보고)** — 사내 원장 대조 후 LEFT 전환 여부 판단. 임의 수정 금지 |
| D10 | lookup 4종(PCL `SPMS_DPJT_CLASS`/CLT `SPMS_CELL_TYPE`/SMD `SPMS_CELL_STACK_METHOD`/BIZ `DM_BIZ_TYPE`) + RGS(`SPMS_DPJT_REG_STATUS`) **INNER JOIN** — 미등재 코드 행 소실(SDM1010 R6/LOOKUP 도메인 판례) | PKG L225~303·L380~396 | **미결(실데이터 실측 후 별도 보고)** — lookup 도메인 정비와 함께 판단 |
| D11 | 라벨 오타 3종: `Stock Method`(→Stack)/`Develoment Status`(→Development)/`Project Authroty Registration`(→Authority) | UI컬럼 시트 F11·F26·C36~C83 실측 (GRID 목업은 'Stack 공법' 정표기) | LBL 등재 시 `Stack Method`/`Development Status`/`Project Authority Registration` 으로 정정 |
| D12 | **권한요청 취소 경로 부재**: 화면은 취소 confirm(I72 "권한요청이 있었는데(Checked) 해제하고(Unchecked) 권한요청 하는 경우")을 정의하나, SP 는 `V_DPJT_AUTH_TYPE_REQ='NONE'` 이면 전체 skip + MERGE 의 DELETE 절은 주석(`--DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL`) | PKG L855~919 (IF NONE 미처리·L889 주석 실측) | **PKG 최소 정정 승인됨** — NONE(전부 해제) 시 본인 REQUEST 행 취소 처리 경로 추가(주석 활성화 방식 금지 — hook #138, 정정 SQL 별도 작성) |
| D13 | **등록상태 lookup 불완전 + GRID 목업 vs 메타 Division 한정값 모순**: ① `SPMS_DPJT_REG_STATUS` 에 SP 전이 리터럴 `MODIFYING`(PKG L610) 및 GRID R41/R44/R45 상태(변경등록/등록완료(변경 후)/등록반려) 미등재 — GET RGS INNER JOIN(VALID='Y')이라 미등재 상태 프로젝트는 화면 소실 ② GRID 목업(행10~29, 자동차=40)은 전 컬럼 표시이나 UI컬럼 시트 X열은 나의 권한·권한 관리(81계열), 개발 현황·권한 요청 계열(82+81계열) 한정 — **사용자 확정: 메타(UI Category Setup 데이터) 우선(2026-08-19), 목업 우선 완화 금지** | lookup 전행 실측 + PKG_SDM1010/1020 ALL_SOURCE 상태 리터럴 전수(strip 후 LIVE만) + UI컬럼 시트 X열 실측 | ① 사용자 확정 9항목 재구성: DRAFT(10)·WRITING(11) 작성중 / WAITING(20) 승인대기 / COMPLETE(30) 등록완료 / REJECT(40) 반려 / **CHG_REG(50) 변경등록[신규]** / **MODIFYING(60) 변경중[신규]** / REQ_MOD(70) 변경요청 / **CHG_COMPLETE(80) 등록완료(변경 후)[신규 — COMPLETE 재사용 아님: 확정 목록 별개 항목 + SEGMENT1 조인 fan-out 구조]** / **CHG_REJECT(90) 등록반려[신규]**. 잔재 REQUEST/CHG_DRAFT/CHG_REQUEST(VALID 'N') 불변 ② 설계서 X열 한정값을 DB `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 에 원문 반영(03 스크립트가 DIVISION_ID 를 통째 누락했던 상태 — 적용 전 30행 전부 NULL 실측). 40 조회 시 81계열/82 한정 9 가시컬럼 미표시 = 확정 계약. 적용본 = `08_LOOKUP_REG_STATUS_FULL.sql` / `09_SHEET_COLUMNS_DIVISION_FIX.sql` (2026-08-19 사내 적용) |
| D14 | **초기 표시 컬럼 5개뿐("보이는 컬럼이 몇 개 없음" 신고의 실원인)**: UI컬럼 시트 T열(Default)이 U열(User Selected)과 완전 역전 쌍으로 기재(가시 23컬럼 중 18컬럼 T='N') — SP 비개인화 경로는 `DEFAULT_FLAG AS DISPLAY_FLAG` 반환(PKG_NSCM_UI_COM_MENU L199~216)·FE 는 visible∧display 만 컬럼 생성 → division 무관 초기 표시 5컬럼. Division 은 원인 아님(적용 전 전행 NULL 실측) | DB 플래그 전행 실측 + SP 원문 + ProjectListGrid L80 + SDM1010 판례(126/126 전행 DEFAULT 'Y') | VISIBLE 'Y' ∧ DEFAULT 'N' 18행만 `DEFAULT_FLAG='Y'` 정정(VISIBLE 'N' 7행·USER_SELECTABLE 무수정). 근거 4축 = 사용자 확정 계약(Division 공란 = 공통 표시, VISIBLE 'Y' 기준) + SP 계약 + SDM1010 판례 + GRID 목업. U-07(T/U 의미 미정의)과 연계 — 설계자 확인 요청 유지 |

## 2. 관찰 (SP 원문 vs 설계서 — 구현 참고)

| # | 내용 | 실측 근거 | 방침 |
|---|---|---|---|
| O-1 | 설계서 Project List 시트의 등록요청 파라미터 표 = 3종(P_DIVISION_ID/P_DPJT_KEY/P_SES_USER_ID)뿐 — SP 실시그니처는 **14 IN**('^' 벌크 컬럼 12종 포함) | 시트 H52~H54 vs PKG L32~49 | **SP 원문이 정본** — FE 는 14 파라미터 전송('M' 행 한정 — D4) |
| O-2 | BIZ_TYPE 조인이 lookup `DM_BIZ_TYPE` 를 **division 무관** 매칭(SEGMENT1=BIZ_TYPE) — 셀 콤보는 `BizTypeByDivision`(division 축 보유) | PKG L288~303 | 콤보 확정값(BizTypeByDivision)과 조회 조인의 축 차이 인지 — 콤보 등재값이 lookup 도메인 안에 있으면 무해. lookup 도메인 정비(D10)와 함께 확인 |
| O-3 | GET 성공 커서 `O_RESULT_CURSOR` = `CODE/MSG/EVENT` 표준 — 성공판정은 **CODE 이름 기반**(위치 추출 금지) | PKG L441~442·L685~686·L925~926 | call-proc 성공판정 표준 적용 |
| O-4 | BTN_REQ/REQ_AUTH 는 **내부 COMMIT 보유** — E2E 직접 호출 시 rollback 무의미 | PKG L681·L921 | 검증은 집합 불변식 복원 방식(저장 SP 직접 호출 판례) |
| O-5 | 팝업 SP 8본(`P_SDM1010_GET_POP_USER_ORG`/`GET_POP_USER_BY_DEPT`/`GET_POP_PJT_AUTH_WRITE`/`_READ`/`_REQ`/`SAVE_POP_PJT_AUTH_WRITE`/`_READ`/`SAVE_POP_BTN_REJECT`)은 설계서 기재명 그대로 **수신 PKG_SDM1010(15본)에 실존** — 시그니처 대조 일치 | `_artifacts/_apply_corporate/SDM1010_DBSWAP_20260813/04_PKG_RECEIVED_PATCHED.sql` 스펙 실측 | 재사용 배선(신규 작성 금지) |
| O-6 | GET/BTN_REQ 커서·INSERT 에 ORDER BY 없음 — 정렬 FE 몫 / BTN_REQ 도입부 `ALTER SESSION SET optimizer_dynamic_sampling=2` + GTT 주석 블록(GT_F021_* — 템플릿 잔재, 실사용 없음) | PKG L574~591·L825~842 | 템플릿 잔재는 무해 — 이관 시 원문 보존 |

## 3. 미결 (설계 미완 — 임의 완성 금지, 대사표 "설계 미완" 사유 처리)

| # | 항목 | 설계서 근거 | 상태 |
|---|---|---|---|
| U-01 | **컬럼 설정 버튼 호출 SP `?`** | 개요 K26 `?` (F26 "Popup - ColumnSettingModal 호출") | SP 임의 배선 금지(SDM1010 정오표 #14 판례) — 설계서 확정 시 배선 |
| U-02 | **MSG 코드 15건 공란**(Main 10 + 팝업 5) | Project List B61~B74·권한관리 팝업 B75~B84 메시지 코드 열 공란 | 재사용 매핑(locales 실문구 대조 실측): **확정 기재 2** = MSG00097·MSG00108 / **동문 재사용 8** = MSG00709(선택 항목 없음)·MSG00710(등록/변경 confirm)·MSG00711/00712(등록요청 성공/실패)·MSG00716/00717(입력/조회 리스트 기존재)·MSG00002/00003(저장 성공/실패) / **근사 재사용 후보 1** = MSG00004("수정한 내용이 없습니다" vs 설계 "수정된 내용이 없습니다" — 재사용 우선 원칙) / **신규 채번 6** = 권한요청 5문구(항목 없음/confirm/취소 confirm/성공/실패)+관리자 추가불가 — 01001+ 대역(공번 메우기 금지) |
| U-03 | **LBL 4건 공란**: 조회조건 고객/나의 권한/등록 상태/등록 완료일 | 개요 C14~C17 공란(사업부만 LBL00001) | 기존 LBL 실값 검증 후 재사용, 없으면 신규 채번(hook #98 §7 4단) |
| U-04 | ~~**'변경반려' 상태 코드 미정** — "수정후 등록 요청 반려" 상태의 명칭·코드 `?`~~ **해소(2026-08-19)** | GRID 시트 R45 `?` 실측 | 사용자 확정 명칭 '등록반려' → 신규 코드 `CHG_REJECT` 등재. 등록상태 9항목 전체 확정 재구성 = D13 및 `_artifacts/_apply_corporate/SDM1020_META_20260819/08_LOOKUP_REG_STATUS_FULL.sql` |
| U-05 | **권한요청 메일링 미설계** — "해당 프로젝트 관리자에게 권한요청 메일링 추가"(시트) vs SP 주석 "추가로 메일링 관련 로직 필요"만 존재 | Project List H55 + PKG L917 | 이번 범위 제외 — 메일 인프라 설계 확정 후 |
| U-06 | **DPJT_MGMT_STATUS 'TEMP' 전이 미정** — 변경본 INSERT 시 'TEMP' 고정("최초 등록 시 TEMP"), 이후 전이 주체·시점 정의 없음 | PKG L660 + 설계서 전체에 관리 상태 정의 부재 | as-is 수용 — 승인 화면(관리자) 설계에서 확정 요청 |
| U-07 | **User Selected Flag 의미 `?`** — 시트 헤더에 `?` 부기 | UI컬럼 시트 U2 `?` 실측 | SDM1010 판례(개인화 플래그) 준용하되 값은 시트 기재 그대로 등재 |
| U-08 | **초기 자동조회 여부 미기재** | 개요·기능 상세 어디에도 화면 진입 시 자동 조회 정의 없음 | 확정 전 자동조회 미배선(Search 버튼 대기) — 설계자 확인 요청 |
| U-09 | REG_COMP_DATE NULL(미등록완료) 행 — 등록 완료일 필수 조건과 결합 시 **미완료 프로젝트 상시 미표시**(BETWEEN 전멸 — SDM1010 R8 동형) | PKG L435~438 + 개요 E17 필수 Y | 설계 의도(완료일 있는 프로젝트만 조회) 여부 확인 요청 — 확정 전 SP 무수정 |

## 4. 설계서 잔존 정리 권고 (구현 무관)

- 개정이력 v1.1(2026-08-13)이나 승인자 열 전부 공란.
- 레이아웃 시트는 도형(이미지) 위주 — 텍스트 셀 없음(openpyxl 덤프 기준). 목업 실측은 `GRID`/`권한관리` 시트로 대체(hook #134 §2-4).
- UI컬럼 시트 하단 SDM1010 팝업 블록(POP1_TREE/GRID1~4)은 Program ID=SDM1010 으로 기재 — SDM1020 메타가 아니라 **재사용 참조**(등재 주체 확인 요청: SDM1010 기등재 메타 소비가 정본).
