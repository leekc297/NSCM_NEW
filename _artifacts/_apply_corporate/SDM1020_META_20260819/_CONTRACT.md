# SDM1020 Project List — 메타 등재 계약 (FE 소비용)

- 적용일: 2026-08-19 · 사내 Oracle(100.65.143.121:1521/OCGSCMD_P01, SCM_MGR) 직접 적용 완료 (01~06 실행, 99 미실행)
- 정본 템플릿: `SDM1010_04_META_20260812.sql` 관례 승계 · 감사컬럼 전부 `admin` 실측 확인
- 원천: 화면설계서 `SDM1020_ProjectList_화면설계서_20260814.xlsx` `UI컬럼 및 Measure정의` 시트 openpyxl 실측 30행(행4~33) + PKG_SDM1020 커서/ALL_ARGUMENTS 실측

## ① PROC_M COL_NM (FE payload 키 — ALL_ARGUMENTS positional 완전 일치 검증 29=29)

### PKG_SDM1020.P_SDM1020_GET_PJT_LIST (9)
| # | COL_NM | IO | TYPE |
|---|---|---|---|
| 1 | divisionId | IN | VARCHAR |
| 2 | endCustomer | IN | VARCHAR (콤마 다중) |
| 3 | dpjtAuthType | IN | VARCHAR (콤마 다중) |
| 4 | dpjtRegStatus | IN | VARCHAR (콤마 다중) |
| 5 | regCompDateFr | IN | VARCHAR |
| 6 | regCompDateTo | IN | VARCHAR |
| 7 | sesUserId | IN | VARCHAR |
| 8 | data | OUT | CURSOR |
| 9 | result | OUT | PROC_RESULT |

### PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG (15) — 행 단위 호출 (CLOB bulk 아님)
activeFlag(I/D/M), dpjtKey, dpjtCode, dpjtSeq, divisionId, dpjtClass, endCustomer, dpjtName, cellType, stackMethod, bizType, sopDate, sopPlantId, sesUserId → result(OUT PROC_RESULT)

### PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH (5)
dpjtKey, dpjtAuthReqWrite, dpjtAuthReqRead, sesUserId → result(OUT PROC_RESULT)

## ② BTN 코드 (시트별 — hasButton 게이트 축)
| SHT_NM | MNU_BTN_CD | API_ID | API_URL | TP |
|---|---|---|---|---|
| Project List | SEARCH | SDM1020_main_SEARCH | PKG_SDM1020.P_SDM1020_GET_PJT_LIST | PROC_SELECT |
| Project List | EXCEL | SDM1020_main_EXCEL | 〃 | PROC_SELECT |
| Project List | FILTER | SDM1020_main_FILTER | 〃 | PROC_SELECT |
| Project List | SORT | SDM1020_main_SORT | 〃 | PROC_SELECT |
| Project List | REQ (등록요청) | SDM1020_main_REQ | PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG | PROC_SAVE |
| Project List | AUTHREQ (권한요청 링크) | SDM1020_main_AUTHREQ | PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH | PROC_SAVE |
| period | SEARCH | SDM1020_period_SEARCH | PR_GET_DAY_RANGE | PROC_SELECT |

- API_ID 시트 토큰 = `main` (시트명 'Project List' 공백 포함 — API_ID 공백 전례 0건, DMF0003 'Mkt Fcst'→`_main_` 전례 승계). SHT_NM 은 실명 `Project List`.
- `CONDITION` 버튼 코드: 전 DB 사용 전례 0건(SDM1010 미등재) — 등재하지 않음.
- 컬럼 설정 버튼: SDM1010 관례대로 API 미등재 (공용 CustomButton — ColumnSettingModal 대신 master 공용 정본 모달 사용, hook #132).
- 권한 부여: ADMIN / SPMS Administrator / SPMS Planner 3그룹 × 7버튼 = 21 (UGR_BTN), 메뉴 매핑 3 (상위 SDM/SDM_Project 는 기존재 확인만).

## ③ MSG/LBL 최종 매핑 (용도 → 코드)

### LBL — 전부 재사용 (신규 채번 0건)
| 용도 | 코드 | 실문구(KO) |
|---|---|---|
| 조회조건 사업부 | LBL00001 | Div |
| 조회조건 고객 | LBL00643 | Customer |
| 조회조건 나의 권한 | LBL00855 | My Authority |
| 조회조건 등록 상태 | LBL00856 | Reg Status |
| 조회조건 등록 완료일 | LBL00857 | Reg Complete Date |
| 등록요청 버튼 | LBL00859 | Reg Request |
| 메뉴 라벨 | MNU_SDM1020 (신규 3언어) | Project List |

### MSG — 재사용 11 + 신규 6 (MSG01002~01007, MSG01001 사용 중이라 +1부터)
| 용도 | 코드 | 구분 |
|---|---|---|
| Division 미선택 | MSG00097 | 재사용 |
| 조회 기간 역전 | MSG00108 | 재사용 |
| 수정된 내용 없음 | MSG00004 (수정한 내용이 없습니다.) | 재사용(유사) |
| 선택 항목 없음 | MSG00709 | 재사용 |
| 등록/변경 Confirm | MSG00710 | 재사용 |
| 등록요청 성공 | MSG00711 | 재사용 |
| 등록요청 실패 | MSG00712 | 재사용 |
| 권한요청 항목 없음 | **MSG01002** (권한요청 항목이 없습니다.) | 신규 |
| 권한요청 Confirm | **MSG01003** (권한요청 하시겠습니까?) | 신규 |
| 권한요청 취소 Confirm | **MSG01004** (권한요청을 취소 하시겠습니까?) | 신규 |
| 권한요청 성공 | **MSG01005** (성공적으로 권한요청 되었습니다.) | 신규 |
| 권한요청 실패 | **MSG01006** (권한요청에 실패하였습니다.) | 신규 |
| 관리자 권한추가 불가(팝업) | **MSG01007** (관리자는 권한을 추가할 수 없습니다.) | 신규 |
| 입력 리스트 기존재(팝업) | MSG00716 | 재사용 |
| 조회 리스트 기존재(팝업) | MSG00717 | 재사용 |
| 저장 성공(팝업) | MSG00002 | 재사용 |
| 저장 실패(팝업) | MSG00003 | 재사용 |

기존 코드 문구 덮어쓰기 0건 (NOT EXISTS 삽입 — MSG00004/MSG01001 원문 유지 실측 확인).

## ④ SHEET_COLUMNS 최종 30컬럼 (PROGRAM_ID='SDM1020' / SHEET_NAME='Project List', SORT 10단위)
DPJT_KEY(H), DPJT_SEQ(H), DIVISION_ID(IM·Division), DPJT_CLASS(IM·DpjtClass), END_CUSTOMER(IM·EndCustomerByDivisionDept), DPJT_NAME(IM·FPTextBox), CELL_TYPE(IO·CellTypeByDivision), STACK_METHOD(IO·**StackMethodByCellType**), BIZ_TYPE(IO·**BizTypeByDivision** 확정), SOP_DATE(IO·FPDateText), SOP_PLANT_ID(IO·PlantByDivisionCompany), DPJT_CODE, DEPT_ID(H), DEPT_NAME, MGMT_USER_ID(H), USER_NAME, DPJT_AUTH_TYPE(H), DPJT_AUTH_TYPE_NAME, DPJT_REG_STATUS(TAG), DPJT_REG_STATUS_NAME(H·TAG), DPJT_REG_STATUS_COLOR_TYPE(H·TAG), REG_COMP_DATE(FPDateText), DPJT_DEVELOP_STATUS(FPComboBox·DpjtDevelopStatus), DPJT_AUTH_MGMT(FPModal·ATTRIBUTE1='ProjectAuthRegModal'), **DPJT_AUTH_REQ_STATUS**(TAG), **DPJT_AUTH_REQ_WRITE_NAME**(TAG·D2 개명), **DPJT_AUTH_REQ_WRITE_COLOR_TYPE**(TAG·D2 개명), DPJT_AUTH_REQ_WRITE(IO·FPCheckBox), DPJT_AUTH_REQ_READ(IO·FPCheckBox), **DPJT_AUTH_REQ_LINK**(D1 개명·FE 파생 — 커서 미반환·ATTRIBUTE1='REQ_ACTION')

- D2 커서 실측: O_CURSOR 는 `DPJT_AUTH_REQ_STATUS`(실존) + `DPJT_AUTH_REQ_WRITE_NAME` + `DPJT_AUTH_REQ_WRITE_COLOR_TYPE` 반환. `DPJT_AUTH_REQ_READ` 는 커서에 2회 SELECT(동명 중복 — SP 잠재결함, 메타는 1행) — FE 는 마지막 값 승리에 의존하지 말고 컬럼명 1회 바인딩.
- 커서는 메타 30컬럼 외 보조 컬럼도 반환: DIVISION_NAME, DPJT_CLASS_NAME, END_CUSTOMER_NAME, CELL_TYPE_NAME, STACK_METHOD_NAME, BIZ_TYPE_NAME, SOP_PLANT_NAME, DEPT_NAME_KO/EN/CN, USER_NAME_EN, DPJT_DEVELOP_STATUS_NAME (메타 미등재 — FE 표시 보강 시 활용 가능).
- 라벨 '*' 4종은 INPUT_TP_CD='IM' 로 흡수(라벨에서 제거). D11 오타 정정(Stack Method / Development Status) 반영. FPDate→FPDateText, TAG→CT 'S'+ATTRIBUTE1 'TAG' (SDM1010 DB 실행분 관례).
- xlsx 'Division' 열(81 계열 다중값)은 SDM1010 관례대로 meta DIVISION_ID=NULL 로 미적재 (division 분기는 FE/SP 처리).

## ⑤ CMBO 신설 결과 + PR_GET_DAY_RANGE
- **StackMethodByCellType** 신설 완료 (MDU_DIVS_CD='CM'). 토큰 `@divisionId`, `@cellType` — 빈값 NVL 가드(전체 반환), `@cellType` 전달 시 SEG2 센티널 `'-'`(공통) 행 항상 포함. 스모크: div=81→2행(ALS/AZS), 빈값→6행, 40+'-'→2행 PASS. 현재 lookup 데이터는 전 행 SEG2='-' (셀유형별 세분값 미입력 상태).
- **DpjtDevelopStatus 등재 생략(보고)**: LOOKUP_TYPE 'SPMS_DPJT_DEVELOP_STATUS' 가 MASTER/DETAIL 모두 0행 — lookup 신설 전 콤보 작성 불가. SHEET_COLUMNS 의 CELL_COMBO_DATA_TYPE='DpjtDevelopStatus' 는 설계대로 유지(현재는 빈 콤보) → lookup+콤보 후속 등재 필요.
- **PR_GET_DAY_RANGE 실존** (SCM_MGR PROCEDURE VALID). PROC_M 기등재 공유 5행: createdBy(IN VARCHAR), month(IN NUMBER), o_rc1/o_rc2(OUT CURSOR), o_result_cursor(OUT PROC_RESULT) — ALL_ARGUMENTS 5=5 일치. period 시트 배선 완료(SDM1020_period_SEARCH). ⚠ 설계서의 P_FR_BUCKET 7-인자 서명은 실물과 다름 — 실물 서명(createdBy/month) 기준으로 호출할 것 (DMF0021 등 dayRange 호출 화면 참조). M-1~Today 기본값은 FE dayjs 계산 병행 가능.
- 조회조건 '나의 권한'/'등록 상태' 콤보: 설계서는 `SCM0001_GET_LOOKUP_VALUES`(p_lookup_type='SPMS_DPJT_AUTH_TYPE'/'SPMS_DPJT_REG_STATUS') 호출 — SP 실존(VALID)하나 **PROC_M 미등재** (전 화면 공통 미등재 상태). generic call-proc 경유 시 등재 필요 여부는 FE 구현 시점 판단.
- 조회조건 '고객' 콤보 = `EndCustomerByDivision`(기존재, @sesUserId 주입 필요 — combo-muti 비대칭 주의) / 그리드 셀 콤보 = `EndCustomerByDivisionDept`(기존재).

## 적용 실측 행수 (2026-08-19 검증 SELECT)
| 축 | 행수 |
|---|---|
| MSG: MNU_SDM1020 | 3 |
| MSG: 신규 MSG01002~01007 | 18 (6×3) |
| MSG: MSG_API_SDM1020_* | 21 (7×3) |
| MNU_M (ROUTE_PATH NULL) | 1 |
| SHEET_COLUMNS 'Project List' | 30 (SDM1010 126행 무손상) |
| PROC_M (GET 9 / BTN_REQ 15 / AUTH 5) | 29 = ALL_ARGUMENTS 29 |
| API_M | 7 |
| MNU_BTN_MPG_M | 7 |
| USER_GR_MNU_MPG_M | 3 |
| USER_GR_MNU_BTN_MPG_M | 21 |
| CMBO (StackMethodByCellType) | 1 |

## 미실행 (의도)
- `99_ROUTE_PATH.sql` — FE viewRegistry(`pages/<화면>/index.ts`) 완성 후 별도 적용 (선적용 시 탭 Page Not Found).
