# SDM1010 Project Registration 화면설계서 — 정오표 (설계자 확인용)

> 대상: `Doc/화면설계서_SDM/SDM1010_ProjectReg_화면설계서_20260806.xlsx` (v1.1, 2026-08-05)
> 작성: 2026-08-12 — 설계서 전수 분석(15시트) 중 실측된 오류·미결 13건과 TO-BE 구현 적용 방침.
> 처리 방침(사용자 확정 2026-08-12): **정정 구현 + 본 정오표 기록** — 설계자 확인 후 상이 시 회신 요청.

| # | 구분 | 설계서 기재(원문) | 실측 근거 | TO-BE 적용(정정) |
|---|---|---|---|---|
| 1 | 컬럼명 오타 | TAB1 `DPJT_ATUH_REG_STR` / `DPJT_ATUH_REG_STATUS` | AUTH→ATUH 전위 오타 (UI컬럼 정의 시트 Sort 180/190) | `DPJT_AUTH_REG_STR` / `DPJT_AUTH_REG_STATUS` 로 정정 등재 |
| 2 | SP 파라미터 누락 | `P_SDM1010_GET_TAB1_PJT_REG` 파라미터 = Session 4종만 (DIVISION/USER/MENU/USER_GR) | TAB2 SP 는 조회조건 6종+Session 인데 TAB1 만 조회조건 부재 — 조회조건(고객/나의권한/등록상태/등록완료일)이 정의돼 있으므로 명백한 정의 공백 | TAB2 준용: `P_END_CUSTOMER`/`P_DPJT_AUTH_TYPE`/`P_DPJT_REG_STATUS`/`P_REG_COMP_DATE_FR`/`P_REG_COMP_DATE_TO` 추가 (총 9 IN) |
| 3 | Sort 순번 중복 | TAB2 `DPJT_AUTH_TYPE`/`DPJT_AUTH_TYPE_NAME` 둘 다 230 / POP2_GRID5 `SAMPLE_A~D_DATE` 4개 전부 260 | UI컬럼 정의 시트 실측 | TAB2: 230/231 재부여. POP2: 목업(My Work_GRID — Sample A→B→C→D→SOP 순) 기준 90/100/110/120 재부여, SOP_DATE 150·SOP_PLANT 160/170 유지 |
| 4 | MSG ID 미부여 | 삭제/등록요청/요청취소 메시지 전체, 저장·삭제 Confirm, 팝업 (+) 중복 2건, TAB2 3년 제한 | TAB1/TAB2/권한관리 팝업 시트 메시지 코드 열 공란 | 표준 채번(SCM_ADM_MSG_M 신규 — KO=EN 3언어)하여 부여, 채번표는 메타 SQL 에 명시 |
| 5 | SP 명명규칙 위반 | My Work 조회 SP `SDM1010_GET_POP_MY_WORK` (유일하게 `P_` 접두 없음) | 나머지 11본은 전부 `P_SDM1010_*` | `P_SDM1010_GET_POP_MY_WORK` 로 통일 |
| 6 | 콤보 오지정 | POP2_GRID5 `SOP_PLANT_ID`/`SOP_PLANT_NAME` 의 Cell Combo Data Type = `CellTypeByDivision` | SOP Plant 는 TAB1/TAB2 에서 `PlantByDivisionCompany` — 복붙 오류로 판단 | `PlantByDivisionCompany` 로 정정 |
| 7 | Visible 비정상 값 | TAB2 `DPJT_AUTH_TYPE` Visible = `D` (Y/N 외) | UI컬럼 정의 시트 실측 | CODE 컬럼 관례(페어의 코드측=숨김)에 따라 `N` 으로 정정 |
| 8 | 라벨 오타 | `Stock Method`(→Stack 공법) / `Develoment Status`(→Development) / Program Name `Project Authroty Registration`(구판 명칭+오타 잔존) | 목업 시트는 'Stack 공법' 표기 — 라벨만 오타 | `Stack Method` / `Development Status` / Program Name=`Project Registration` 으로 정정 |
| 9 | 중복 판정 기준 미정의 | 저장 검증 "중복값 확인"(MSG00043)의 중복 판정 축 미기재 | 개요 버튼 시트 | 논리키 = `DIVISION_ID + DPJT_CLASS + END_CUSTOMER + DPJT_NAME` 으로 구현(표시 필드 조합). 상이 시 회신 요청 |
| 10 | 미결 설계 이슈 | "신규 입력 시 권한등록이 동시에 가능한지 확인 필요"(확인사항 2.1.4/2.2 중복 기재) | TAB1 시트 | Master-Detail 1:N 구조상 **프로젝트 저장 후 권한등록 가능**으로 확정 구현(신규 미저장 행 링크 비활성). 동시 등록 필요 시 후속 보완 |
| 11 | Input Type 전 행 'S' | UI컬럼 정의 시트 Input Type = 전 컬럼 `S`(정적) — 확인사항 2.1.1 "수정 가능 항목" 과 모순. 또한 2.1.1 의 '사업부'는 조회조건 종속·자동 부여 컬럼이라 편집 대상 부적합 | 시트 vs 확인사항 대조 | 편집 컬럼에 한해 INPUT_TP_CD 정정: Class/Customer/PJT Name=`IM`, Cell Type/Stack Method/Biz Type/SOP Date/SOP Plant=`IO`, 나머지 `S` 유지. '사업부'는 편집 제외 |
| 12 | 반려/변경등록 동작 미정의 | 반려 상태 행의 재수정 가능 여부, '변경등록' 진입 트리거 미기재 (범례에만 존재) | TAB1_GRID 범례 vs 기능 정의 부재 | 이번 구현: 반려 행=잠금(조회만), 변경등록 경로=미구현(후속). 상태 코드 체계에는 6종 전부 등재해 확장 대비 |
| 13 | My Work 팝업 미완성 | 조회조건·메시지·확인사항 전부 공란, "추가 정의 필요"/"내용 추가" 명시. 하단 승인/반려 블록 정의 없음 | My Work 팝업 시트·개요 팝업표 | **조회 전용 최소 구현**(정의된 그리드 15컬럼 + P_SDM1010_GET_POP_MY_WORK) — 승인/반려 블록은 설계 확정 후 후속 (사용자 확정) |

| 14 | 버튼 배선 보류 | 개요 버튼 '컬럼 설정'/'Measure 설정' = CustomButton, 모달명만 기재(`?` 미확정) — **호출 SP 미기재** | 설계서 개요 K29/K30 `?` 표기 | ⛔ **SP 임의 배선 금지**(사용자 지시 2026-08-12) — 이번 범위 제외. 설계서에 SP 확정 기재 시 배선·구현 (기존 화면들은 titleset 계열 공용 SP 사용 — 참고만) |

## ⭐ 2026-08-13 — DB 객체 수신 정본 교체 (사용자 지시) + 수신본 결함·특성 기록

자체 개발 DB 객체(SDM_MST_* 3테이블·시퀀스 2·구 PKG 12 SP) 전량 폐기 → `C:\TRANFILE\RECEIVE\SDM1010` 수신 정본(SPMS_PROJECT_MST/_USER_MAP + PKG 15 SP, 작성 KTJ)으로 교체. FE 전면 재배선. **수신본 실측 결함 — 정정 3건(마커)·as-is 2건 (발신처 확인 요청)**:

| # | 구분 | 내용 | 처리 |
|---|---|---|---|
| R1 | 차단급 결함 | `NVL(x,'') != ''` 가드 13곳 — Oracle ''=NULL 로 항상 UNKNOWN → **SAVE I/M/D 전 분기 사문**(저장 전면 무동작, EVENT=0 허위성공) | 정정 `[E20260813-EMPTYCHK]` — `IS NOT NULL` 등가 |
| R2 | 차단급 결함 | INSERT 초기상태 'DRAFT' 인데 삭제·등록요청 가드는 'WRITING' 한정 → 신규행 삭제/요청 불가 | 정정 `[E20260813-DRAFTGUARD]` — `IN ('WRITING','DRAFT')` |
| R3 | 결함 | 권한 저장(replace-set)의 대상 집합이 반대 유형 권한자 포함 → WRITE 저장이 기존 READ 권한을 NULL 소거(역도 동일) | 정정 `[E20260813-XTYPE]` — 해당 유형·요청 보유자로 한정 (CRUD 5축 실측 검증) |
| R4 | 결함(as-is) | GET_PERIOD 의 TO 구간이 D/W 분기에서 P_FR_BUCKET 오참조 + PW/Y 미구현 | 미정정 — FE 는 FR/TO 동일 bucket(D/W/M)만 사용 |
| R6 | 결함(콤보 정합) | 공용 `EndCustomer` 콤보 = div 40 에서 CODE=**PROJECT_CODE** 반환 — §1/§5 고객 INNER 도메인(SCM_MST_SITE div+END_CUSTOMER)과 불일치 → **40 에서 콤보 값으로 저장한 행이 조회에서 영구 소실** (div40·'DJI' 실사고 재현 2026-08-13) | 정정 — 전용 콤보 `SpmsEndCustomer` 신설(조인 도메인 1:1) + TAB1 셀 콤보·조회조건 고객 콤보 교체. 좌초 행 1건은 유효 고객(EC001)으로 데이터 정정. ⚠ div40 SITE 고객 도메인 1건뿐 — 데이터 결핍 별도 |
| R5 | 미완성(as-is) | GET_POP_MY_WORK 의 SAMPLE_A~D_DATE = 하드코딩 리터럴(placeholder) | 미정정 — 표시 유지·실데이터 아님 명기 |
| R7 | 결함(TAB2 0행 ①) | §5 GET_TAB2 는 본인 USER_MAP 권한행 보유 프로젝트만 표시 — **관리자(MGMT_USER_ID=본인)가 등록한 프로젝트는 본인 TAB2 에서 0행** (2026-08-13 실사고 — 8단 INNER JOIN 은 전 행 생존, 이 술어 단독 전멸 실측) | 정정 `[E20260813-TAB2MGMT]` ×3 — 관리자 본인 포함 + AUTH_TYPE 'ADMIN' 표시(lookup 명칭) + 권한 필터 CASE 동기 + `DPJT_AUTH_STATUS != 'REQUEST'` NULL-안전화 |
| R8 | 결함(TAB2 0행 ②) | §5 등록완료일 기간 지정 시 `REG_COMP_DATE` NULL(등록 미완료) 행이 BETWEEN 에서 전멸 — 기본 기간(전월~당월말) 주입만으로 진행 중 프로젝트 전부 미표시 | 정정 `[E20260813-TAB2COMPNULL]` — 미완료 행은 완료일 기간 필터 대상 아님(항상 표시). 완료 행만 기간 매칭 |

> **권한 단일 유형 확정 (2026-08-13 사용자 확인)**: 동일인은 입력(WRITE)/조회(READ) 중 **하나만 보유** — PK (DPJT_KEY, USER_ID) 구조·replace-set 후승자 우선이 정본 동작. "양쪽 다 표시" 요청은 사용자 철회("현재가 맞습니다").
> **비 SDM1010 파생 사고 (2026-08-13)**: `scripts/sync-i18n.mjs` 가 구주소(10.34.220.80) API 실패 시 목데이터로 실 locales 를 덮어써 **전 화면 LBL '_' fallback 표시** — 후보 URL(env→로컬 BE→구주소) + 실패 시 기존 locales 보존·중단으로 정정, 로컬 BE(2,487건)로 재생성 복구.

**신 계약 특성 (설계 확정으로 수용·FE 반영)**: TAB1 조회 = 본인(MGMT_USER_ID) 관리 프로젝트 한정(관리자 전체보기 없음·조회조건 파라미터 미사용 — 조회조건 TAB2 전용화와 정합) / 상태 도메인 DRAFT·WRITING·WAITING(구 REQUEST/CHG_* 폐지) / 권한 = SPMS_PROJECT_USER_MAP 단일 원장(WRITE·READ·ADMIN + REQ 컬럼·REQUEST/CONFIRM/REJECT) — 승인 = 목록 포함 저장 / TAB1 커서 `DPJT_ATUH_*` 오타 alias 4종이 정본(SHEET_COLUMNS 도 오타 철자 등재) / SAVE M·D 는 dpjtCode·dpjtSeq 실값 필수(빈 값=조용히 0건) / TAB2 기간 지정 시 REG_COMP_DATE NULL(미완료) 행 제외(빈 기간=전체) / END_CUSTOMER·LOOKUP 다수 INNER JOIN — 미등재 코드 행은 조회 소실(LOOKUP 9종 도메인 정비 완료) / GET_TAB1·TAB2 ORDER BY 없음(정렬 FE 몫). 권한 요청 생성 경로는 여전히 본 PKG 밖(요청 컬럼 세팅 주체 미정의 — 기존 확인 요청 유지).

## 부기 — 구현 시 보충 결정 (설계서 미기재 항목, 설계자 확인 요청)

- **2단 헤더 그룹 (2026-08-13 보완)**: UI컬럼 정의 시트의 Small/Large Label 은 그룹 정의 없이 컬럼 라벨 복제뿐이나, 목업(TAB1_GRID/TAB2_GRID)은 2단 헤더 — TAB1 `권한 등록[등록|상태]` / TAB1·TAB2 `프로젝트 관리자[부서|성명]`. → SHEET_COLUMNS 에 SMALL/LARGE_CLASS_LABEL_NAME=`Auth Management`(leaf: Registration/Status) / `Project Manager`(leaf: Department/User, 숨김 CODE 페어 포함) 등재. 사내 적용 + 패키지 04_META.sql [3b] 동기(`_artifacts/_apply_corporate/SDM1010_SHEETCOL_GRIDHDR_20260813.sql`)
- **TAB2 D-PJT Code 위치 (2026-08-13 보완)**: UI컬럼 정의 시트 Sort 20(선두)이나 목업 열 순서는 SOP Site 뒤·프로젝트 관리자 앞 → SORT_ORDER_NO 185 로 재배치 (목업 우선)
- **조회조건 = TAB2 전용 (2026-08-13 사용자 지시)**: 조회조건 영역(사업부/고객/나의권한/등록상태/등록완료일)은 두 번째 탭(나의 프로젝트 현황)에서만 노출, 첫 번째 탭(프로젝트 등록)에서는 비노출(Search Area 토글도 숨김). TAB1 조회는 세션 MyDivision 첫 값 + 기본 기간(M-1~Today)으로 동작 — 사업부 기본값 보정을 폼→페이지 레벨로 이동. TAB1 SP 의 조회조건 파라미터(정오표 #2 추가분)는 유지(기본값 ALL 전달)
- **Insert 시 Division 필수입력 (2026-08-13 사용자 지시 — 정오표 #11 '사업부 편집 제외' 결정 역전)**: 조회조건 TAB2 전용화로 TAB1 에서 division 자동 부여 근거가 사라짐 → TAB1 `DIVISION_NAME` = `IM`(신규행 전용 편집+필수 MSG00113) + `MyDivision` 셀 콤보(메타)로 전환, 신규행 division 자동 부여 제거. division 종속 콤보(CellType/BizType/Plant ByDivision)는 행 division 의 dataMap 스왑 + division 변경 시 종속 셀 clear. SAVE SP 필수 가드에 DIVISION_ID 추가(원장 NOT NULL — 미가드 시 raw ORA-01400)
- **저장 후 저장행 미조회 실사고 정정 (2026-08-13)**: TAB1 GET 이 `M.DIVISION_ID = P_DIVISION_ID` 하드 등호 + FE 가 조회조건(비노출) division 을 전달 → 타 division 으로 저장한 행이 재조회 조건 밖 실종(재현: div 81 저장 → div 40 조회 0행). 정정 = ①TAB1 GET division 필터 NVL-ALL(빈값=전체) ②FE TAB1 필터 = 조건 전부 빈값(내 권한 범위 전체 조회 — validateSearch TAB1 무검증) ③저장 성공 시 필터 활성 후 재조회(최초 미조회 상태 Insert→저장에서도 저장분 표시). TAB1 조회 의미 = "내 권한 범위 전체" 로 확정(조회조건 TAB2 전용화의 귀결) — 설계자 상이 의견 시 회신 요청
- **저장 허위성공 실사고 (2026-08-13 — BE 로그 실증)**: FE 가 신규행 화면 내부 표기 `CRUD_TYPE:'C'` 를 SAVE SP 에 그대로 전송 → SP JSON_TABLE 'I'/'M'/'D' 분기 전부 미해당으로 **통째로 무시**되어 `CODE=0/EVENT=0` 허위성공(성공 토스트 + 원장 미기록). 동반 결함: 날짜 셀 편집값이 표시 포맷(`'8/31/2026'` 실측)으로 남는데 원장 날짜 컬럼 전부 VARCHAR2(8). → 정정 ①`toSaveRow` 에서 'C'→'I' 변환+`*_DATE` YYYYMMDD 정규화 ②SP [가드 0] 미계약 CRUD_TYPE 전체 거부(`INVALID_CRUD_TYPE`) — silent no-op 구조 차단. 검증: 사고 원문 페이로드 재전송=INVALID 거부·정정 페이로드=저장+전체조회 표시·CRUD 18/0·vitest 36. ⚠ 기존 단위테스트가 `CRUD_TYPE:'C'` 보존을 단언(결함의 정본화) — E2E 러너도 'I' 자작 페이로드라 미검출: **SAVE 검증은 FE 실빌더(toSaveRow) 산출물로 해야 함**
- **저장 후 자동 재조회 미동작 정정 (2026-08-13 — BE 로그 실측)**: handleSave 의 `setFilter()+refetch?.()` 병용이 금지 계보(stale closure) 그대로 재현 — 최초 저장 시 refetch 가 이전 렌더 관찰자(filters=undefined)로 **전-파라미터 NULL 호출**을 쏘고 결과가 옛 쿼리키에 적재돼 그리드 미갱신(09:33:08 TEST1 실측 — 수동 Search 로야 표시). → `setFilter(TAB1)` 단독으로 정정: 최초 저장=enabled 전환 자동 fetch / 재저장=filters 참조 변경 invalidate→active refetch, 단일 호출로 즉시 갱신
- **권한관리 팝업 목업 정합 재설계 (2026-08-13 사용자 지시)**: 초기 구현이 설계서 목업(image7)과 상이 — ①헤더바(Project Name + **User ID(Name) 검색 + Search(F5)**) 부재 → `P_SDM1010_GET_POP_USER_BY_DEPT` 에 P_USER_NAME 추가(ID/성명 부분일치·조건 전무=0행, PROC_M 재등재) ②레이아웃 목업 재배치(트리|사용자 목록 세로|[+][−] 2쌍|입력→∨∧→조회→요청 스택) + **∨∧ 입력↔조회 이동 신규** ③요청 처리 = 행내 [✓입력][✓조회][x반려] 버튼 — 승인 시 해당 리스트 pending 추가(2.2)·요청과 다른 권한 승인(2.4, SAVE_REQ payload AUTH_TYPE 동봉+NVL 폴백)·반려 상태 표시(2.3)·모든 확정은 OK(2.2.1/2.3.1) ④조회 리스트 메타 = POP1_GRID3 소비(+SEARCH 배선 등재 — 원천 AUTH_MGMT SP) ⑤POP1_GRID4 처리 컬럼 REQ_ACTION 메타+SP SELECT 등재 ⑥모달 높이 72vh→57.6vh(80%). 검증 = 순수함수 16케이스·SP 왕복(검색 4조합·교차승인·폴백)·CRUD 18/0·게이트 PASS 8/WARN 1·E2E FAIL 0
- **관찰 (설계 확인 요청 — 기존 계약)**: 편집형 컬럼이 전부 IM/IO(신규행 전용)라 **저장된 DRAFT 행은 셀 수정 불가** — 확인사항 2.1.1 '수정 가능 항목'이 기존 행 수정을 의도한 것이면 M/O 전환 필요 (SAVE SP 'M' 경로는 준비돼 있음). E2E WARN 로 표면화(2026-08-13)
- **Default 열 모순 (2026-08-13 실사고 정정)**: UI컬럼 정의 시트 'Default' 열이 표시 컬럼 대부분 'N'(키/Division 계열만 'Y') — 목업의 전 컬럼 표시와 모순. `PR_GET_SHEET_COLUMN_LIST` 는 비개인화(SHEET_PRSL_YN 미등록) 화면에서 `DISPLAY_FLAG=DEFAULT_FLAG` 직결이라 'N' 컬럼이 그리드에서 전부 탈락(TAB1 15→2/TAB2 17→1 실측). → 전 101행 DEFAULT_FLAG='Y' 정정(비개인화 화면 관례 — DMF0044 실측 62/62 'Y'). Default 열의 의도가 별도라면 회신 요청

- **DPJT_KEY/DPJT_CODE 채번 규칙 미기재** → 임시 규칙: DPJT_KEY=`DPJT`+seq10, DPJT_CODE=`YY`+seq4 (목업 예 '26VW01' 과 형식 상이 — 채번 규칙 확정 시 변경)
- **콤보 원천 미기재** (DpjtClass/CellTypeByDivision/StackMethod — 콤보명만 기재): lookup `SPMS_DPJT_CLASS`/`SPMS_CELL_TYPE`/`SPMS_STACK_METHOD` 신설로 구성, 값은 설계서 목업 샘플에서 추출(개발/제품검증, 파우치/각형/원통, ALS/AZS) — 실값 확정 시 lookup 데이터만 보정하면 됨(SYS0010 Lookup 화면)
- **권한 요청 생성 경로 미기재**: 요청 리스트의 원천(누가 어디서 요청을 넣는가)이 설계서에 없음 — 승인/반려 처리만 구현, 요청 등록 화면은 후속

## 부기 — 설계서 잔존 정리 권고 (구현 무관)

- 폐기 후보 시트 3: `TAB1_GRIDv1` / `TAB2_GRIDv1` / `권한관리 팝업_GRID_초안` (현행 시트와 상이 — 혼선 방지 삭제 권고)
- 개정이력 최종 2026-08-05 v1.1 인데 파일명은 20260806 — 8/6 변경분 이력 미기재, 승인자 전부 공란
- 권한 요청 상태 해제 조건 1안(기간 자동 해제)/2안(반려 프로세스) 미결(초안 시트 B72~C74) — 이번 구현은 2안 계열(반려 처리)로 동작하나 자동 해제는 없음
- 다국어 코드: 조회조건 4개·버튼 전체 미할당 — TO-BE 는 표준 LBL 재사용(Search=LBL00112 등) + 신규 채번으로 충당
