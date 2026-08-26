# SDM5010 Project Master — 메타 등재 계약 (FE 소비용)

- 적용일: 2026-08-19 · 사내 Oracle(100.65.143.121:1521/OCGSCMD_P01, SCM_MGR) 직접 적용 완료 (01~06 실행, 99 미실행, 03 시노님은 DBA 몫)
- 원천: 화면설계서 `SDM5010_ProjectMaster_화면설계서_20260813.xlsx` 'UI컬럼 및 Measure정의' openpyxl 실측 48행(TAB1 24 + TAB2 24) + `PKG_SDM5010.txt` 원문(주석/라이브 판별 strip_code_comments.py)
- PKG: **치명 결함 정정 후 배포** — SPEC+BODY VALID · USER_ERRORS 0 · ALL_ARGUMENTS 44=44 · BODY 마커 14 실측
- 템플릿: `SDM1020_META_20260819` + SDM1010/1020 DB 실행분 관례 승계 · 감사컬럼 전부 'admin'

## ① PROC_M COL_NM (FE payload 키 — ALL_ARGUMENTS positional 완전 일치 44=44)

### PKG_SDM5010.P_SDM5010_GET_TAB1_PJT_REG_REQ (6)
| # | COL_NM | IO | TYPE | 비고 |
|---|---|---|---|---|
| 1 | sesDivisionId | IN | VARCHAR | 세션 (SDM1010 GET_TAB1 실행분 관례 승계) |
| 2 | sesUserId | IN | VARCHAR | 세션 |
| 3 | mnuId | IN | VARCHAR | 세션 메뉴 ID |
| 4 | userGroup | IN | VARCHAR | 세션 권한그룹 |
| 5 | data | OUT | CURSOR | |
| 6 | result | OUT | PROC_RESULT | |

- TAB1 은 **본인 필터 유지** (2026-08-19 사용자 확정): SP 내부 `MGMT_USER_ID = P_SES_USER_ID` + `DPJT_REG_STATUS IN ('WAITING','REQ_MOD')`.

### PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL (6) — 반려 (행 단위)
divisionId, dpjtKey, dpjtKeyParent, note, sesUserId → result(OUT PROC_RESULT)

### PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM (16) — 승인 (행 단위)
dpjtKey, dpjtCode, dpjtSeq, dpjtKeyParent, divisionId, dpjtClass, endCustomer, dpjtName, cellType, stackMethod, bizType, sopDate, sopPlantId, note, sesUserId → result(OUT PROC_RESULT)

### PKG_SDM5010.P_SDM5010_GET_TAB2_PJT_MASTER (10)
divisionId, endCustomer, cellType, bizType, dpjtDevelopStatus, regCompDateFr, regCompDateTo, sesUserId → data(OUT CURSOR), result(OUT PROC_RESULT)
- 멀티선택 콤마 다중: endCustomer/cellType/bizType/dpjtDevelopStatus (+divisionId). `'ALL'` = 전체.
- **기간 = REG_COMP_DATE** (2026-08-19 사용자 확정). Fr/To 모두 빈값이면 기간 무제한.

### PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER (6) — [D1 신규 작성]
activeFlag('M' 단건만 유효 — 그 외 CODE '1' 반환), dpjtKey, dpjtDevelopStatus, disabled, sesUserId → result(OUT PROC_RESULT)

### period 시트 (공유 SP — PROC_M 기등재 재사용, 본 트랙 재등재 없음)
PKG_SDM1010.P_SDM1010_GET_PERIOD (9행 기등재): frBucket, frDateVal, frBucketType, toBucket, toDateVal, toBucketType, sesUserId → data, result

## ② BTN 코드 (hasButton 게이트 축 — 12)
| SHT_NM | MNU_BTN_CD | API_ID | API_URL | TP |
|---|---|---|---|---|
| TAB1 | SEARCH / EXCEL / FILTER / SORT | SDM5010_TAB1_{코드} | PKG_SDM5010.P_SDM5010_GET_TAB1_PJT_REG_REQ | PROC_SELECT |
| TAB1 | CONFIRM (승인) | SDM5010_TAB1_CONFIRM | PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM | PROC_SAVE |
| TAB1 | CANCEL (반려) | SDM5010_TAB1_CANCEL | PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL | PROC_SAVE |
| TAB2 | SEARCH / EXCEL / FILTER / SORT | SDM5010_TAB2_{코드} | PKG_SDM5010.P_SDM5010_GET_TAB2_PJT_MASTER | PROC_SELECT |
| TAB2 | SAVE | SDM5010_TAB2_SAVE | PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER | PROC_SAVE |
| period | SEARCH | SDM5010_period_SEARCH | PKG_SDM1010.P_SDM1010_GET_PERIOD | PROC_SELECT |

- 권한: **SPMS Administrator 단독** (2026-08-19 사용자 확정) — UGR_MNU 3계층(SDM/SDM_Admin/SDM5010) + UGR_BTN 12. DISTINCT 그룹=1 실측.
- 컬럼 설정 버튼: SDM1010/1020 관례대로 API 미등재 (master 공용 정본 모달, hook #132).

## ③ MSG/LBL 최종 매핑 (용도 → 코드)

### LBL — 재사용 8 + 신규 1 (LBL00863, max=LBL00862 실측 +1)
| 용도 | 코드 | 실문구 | 구분 |
|---|---|---|---|
| 조회조건 사업부 | LBL00001 | Div | 재사용 |
| 조회조건 고객 | LBL00643 | Customer | 재사용 |
| 조회조건 Cell 유형 | LBL00046 | Cell Type | 재사용 (실측 기존재) |
| 조회조건 Biz Type | LBL00607 | Biz Type | 재사용 (실측 기존재) |
| 조회조건 개발 현황 | **LBL00863** | Development Status | **신규** |
| 조회조건 등록 완료일 | LBL00857 | Reg Complete Date | 재사용 |
| TAB1 승인 버튼 | LBL00623 | Approve | 재사용 (실측 기존재) |
| TAB1 반려 버튼 | LBL00624 | Reject | 재사용 (실측 기존재) |
| 메뉴 SDM_Admin | MNU_SDM_Admin (신규 3언어) | Administration | 신규 |
| 메뉴 SDM5010 | MNU_SDM5010 (신규 3언어) | Project Master | 신규 |

### MSG — 재사용 8 + 신규 6 (MSG01008~MSG01013, MSG01xxx max=MSG01007 실측 +1)
| 용도 | 코드 | 구분 |
|---|---|---|
| Division 미선택 | MSG00097 | 재사용 |
| 조회 기간 역전 | MSG00108 | 재사용 |
| **조회 기간 3년 초과** | **MSG00164** | **재사용 — 지시서 신규 7코드 중 조정**: 실문구 완전 일치 기존재 2건(MSG00164/MSG00715) 실측. FE 전 화면 소비 20회 + KO/EN/CN 번역 완비인 MSG00164 채택 (i18n 재사용 원칙 2026-08-14 확정 룰). MSG00715 는 소비 0 중복 잔재 — 불변 |
| 승인 confirm | MSG01008 (선택한 프로젝트 등록 요청을 승인하시겠습니까?) | 신규 |
| 승인 성공 | MSG01009 (선택한 프로젝트 등록 요청이 승인되었습니다.) | 신규 |
| 승인 실패 | MSG01010 (프로젝트 등록 요청 승인에 실패하였습니다.) | 신규 — 설계서 '실해' 오타 정정 |
| 반려 confirm | MSG01011 (선택한 프로젝트 등록 요청을 반려하시겠습니까?) | 신규 |
| 반려 성공 | MSG01012 (선택한 프로젝트 등록 요청이 반려되었습니다.) | 신규 |
| 반려 실패 | MSG01013 (프로젝트 등록 요청 반려에 실패하였습니다.) | 신규 — 동일 오타 정정 |
| 권한관리 팝업 입력/조회 기존재 | MSG00716 / MSG00717 | 재사용 |
| 권한관리 팝업 관리자 추가불가 | MSG01007 | 재사용 (SDM1020 신설분) |
| TAB2 저장 성공/실패 | MSG00002 / MSG00003 | 재사용 |

기존 코드 문구 덮어쓰기 0건 (NOT EXISTS 삽입 — 재사용 코드 실문구 사전 검증 완료).

## ④ SHEET_COLUMNS 최종 48컬럼 (PROGRAM_ID='SDM5010')

### TAB1 (24 — SORT 10~240, xlsx 순서 유지·중복 없음)
DPJT_KEY(H), DPJT_SEQ(H), DPJT_REG_CAT(FPComboBox·DpjtRegCat·**S 유지** — '*' 표기이나 편집 대상 아님+승인 SP 파라미터 부재), DIVISION_ID(IM·Division), DPJT_CLASS(IM·DpjtClass), END_CUSTOMER(IM·EndCustomerByDivisionDept), DPJT_NAME(IM·FPTextBox), CELL_TYPE(IO·CellTypeByDivision), STACK_METHOD(IO·StackMethodByCellType), BIZ_TYPE(IO·**BizTypeByDivision** 확정), SOP_DATE(IO·FPDateText), SOP_PLANT_ID(IO·PlantByDivisionCompany), DEPT_ID(H), DEPT_NAME, MGMT_USER_ID(H), USER_NAME, DPJT_ATUH_REG_STR(FPModal·ATTRIBUTE1='ProjectAuthRegModal'), DPJT_ATUH_REG_STATUS(TAG), DPJT_ATUH_REG_STATUS_NAME(H·TAG), DPJT_ATUH_REG_STATUS_COLOR_TYPE(H·TAG), DPJT_CODE(IO·FPTextBox — 6자리 필수는 FE validation), NOTE(IO·FPTextBox), **REG_COL**(CT 'S'·**ATTRIBUTE1='REG_ACTION'** — 승인/반려 행 액션 토큰, 커서는 '' 반환·FE 파생 렌더), DPJT_KEY_PARENT(H)

### TAB2 (24 — xlsx SORT 중복(240×2/170×2/180×2) → 목업 TAB2_GRID 순서 10~240 재채번)
DPJT_KEY(H), DPJT_SEQ(H), DPJT_REG_CAT, DIVISION_ID, DPJT_CLASS, END_CUSTOMER, DPJT_NAME, CELL_TYPE, STACK_METHOD, BIZ_TYPE, SOP_DATE(FPDateText), SOP_PLANT_ID, DPJT_CODE(H — xlsx 실측 Visible=N·width 0), NOTE, REG_REQ_DATE(FPDateText·라벨 'Reg Reg. Date'→'Reg Request Date' 정정), REG_COMP_DATE(FPDateText), CNFM_USER_ID(H — xlsx Visible=Y 이나 width 0+ID/NAME 쌍 관례로 'N' 정정), CNFM_USER_NAME, DPJT_ATUH_REG_STR(FPModal), DPJT_ATUH_REG_STATUS(TAG), DPJT_ATUH_REG_STATUS_NAME(H·TAG), DPJT_ATUH_REG_STATUS_COLOR_TYPE(H·TAG), **DPJT_DEVELOP_STATUS**(IO·DpjtDevelopStatus), **DISABLE_YN**(IO·FPCheckBox)

- TAB2 편집 = SAVE SP 파라미터 1:1 (DPJT_DEVELOP_STATUS / DISABLE_YN) 만 IO. 나머지 전부 S.
- **DPJT_ATUH_* 커서 실명 유지** (2026-08-19 사용자 확정 — 개명 금지, AS-IS 오타 그대로).
- 라벨 '*' 제거 · 오타 정정(Stock→Stack / Develoment→Development) · TAG=CT 'S'+ATTRIBUTE1 'TAG' · DEFAULT_FLAG 가시 컬럼 전부 'Y'(히든은 xlsx 값 유지).
- 권한관리 팝업 42행(POP1_*)은 SDM1010 소유 메타 재사용 — 본 트랙 미등재.

## ⑤ GET 커서 실컬럼 (2026-08-19 배포본 callproc 실측)

### P_SDM5010_GET_TAB1_PJT_REG_REQ O_CURSOR (36열)
DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_REG_CAT, DPJT_REG_CAT_NAME, DIVISION_ID, DIVISION_NAME, DPJT_CLASS, DPJT_CLASS_NAME, END_CUSTOMER, END_CUSTOMER_NAME, DPJT_NAME, CELL_TYPE, CELL_TYPE_NAME, STACK_METHOD, STACK_METHOD_NAME, BIZ_TYPE, BIZ_TYPE_NAME, SOP_DATE, SOP_PLANT_ID, SOP_PLANT_NAME, DEPT_ID, DEPT_NAME, DEPT_NAME_KO, DEPT_NAME_EN, DEPT_NAME_CN, MGMT_USER_ID, USER_NAME, USER_NAME_EN, DPJT_ATUH_REG_STR, DPJT_ATUH_REG_STATUS, DPJT_ATUH_REG_STATUS_NAME, DPJT_ATUH_REG_STATUS_COLOR_TYPE, NOTE, REG_COL, DPJT_KEY_PARENT

### P_SDM5010_GET_TAB2_PJT_MASTER O_CURSOR (36열)
DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_REG_CAT, DPJT_REG_CAT_NAME, DIVISION_ID, DIVISION_NAME, DPJT_CLASS, DPJT_CLASS_NAME, END_CUSTOMER, END_CUSTOMER_NAME, DPJT_NAME, CELL_TYPE, CELL_TYPE_NAME, STACK_METHOD, STACK_METHOD_NAME, BIZ_TYPE, BIZ_TYPE_NAME, SOP_DATE, SOP_PLANT_ID, SOP_PLANT_NAME, NOTE, REG_REQ_DATE, REG_COMP_DATE, CNFM_USER_ID, CNFM_USER_NAME, DEPT_ID, DEPT_NAME, DPJT_ATUH_REG_STR, DPJT_ATUH_REG_STATUS, DPJT_ATUH_REG_STATUS_NAME, DPJT_ATUH_REG_STATUS_COLOR_TYPE, DPJT_DEVELOP_STATUS, DPJT_DEVELOP_STATUS_NAME, DISABLE_YN, **REG_COMP_DATE(2회 중복 — SP 경미 결함 무수정 영역. FE 는 컬럼명 1회 바인딩(첫 출현)에 의존할 것)**

- 메타 미등재 보조 컬럼(*_NAME 계열)은 FE 표시 보강 시 활용 가능.

## ⑥ DISABLE_YN / DPJT_MGMT_STATUS 계약 (3상태)
- 원장 DPJT_MGMT_STATUS 상태값: **NORMAL**(정상) / **DISABLED**(비활성 — 저장·반려 시) / (미설정 NULL — 기존 데이터).
- GET 표현: `DISABLE_YN = CASE WHEN DPJT_MGMT_STATUS='DISABLED' THEN 'CHECKED' ELSE 'UNCHECKED' END` (NULL 도 UNCHECKED).
- SAVE 입력 `disabled`: **'CHECKED' 정확 일치만 DISABLED**, 그 외(UNCHECKED/NULL/기타) → NORMAL.
- CANCEL(반려) 시 반려행은 SP 내부에서 DISABLED 로 전이 (정정 후 — 구 'DIABLED' 오타).

## ⑦ PKG 정정 지점 (02_PKG_SDM5010.sql — BODY 마커 14 실측, 경미 D7~D9·D15~D24 무수정)
| 마커 | 내용 |
|---|---|
| D1 | P_SDM5010_SAVE_TAB2_PJT_MASTER 신규 (SPEC+BODY — 'M' 단건 UPDATE + CODE/MSG/EVENT 커서) |
| D3 | CANCEL 부모행 복구 UPDATE `WHERE DPJT_KEY=P_DPJT_KEY`→`P_DPJT_KEY_PARENT` |
| D4 | CONFIRM 원본행 전이 UPDATE 동일 정정 |
| D5 | 승인 DPJT_KEY 변경 직후 `SPMS_PROJECT_USER_MAP.DPJT_KEY` 동기 UPDATE (키 실변경+본행 갱신시에만) |
| D6 ×4 | `( x IS NOT NULL OR x != '' )` → `x IS NOT NULL` (Oracle ''=NULL 항진) |
| D10 | CONFIRM 엄격 SELECT INTO — NO_DATA_FOUND/TOO_MANY_ROWS → 결과커서 CODE '1' 반환 |
| D11 | 신규 승인 SEQ = `SELECT NVL(MAX(DPJT_SEQ),0)+1 ... WHERE DPJT_CODE=...` 채번 |
| DISABLED ×2 | 'DIABLED' 오타 → 'DISABLED' (CANCEL 반려행 / CONFIRM 원본행) |
| REGSTS | `'MODIFIED'` → `'CHG_COMPLETE'` — lookup 권위 정합 (SPMS_DPJT_REG_STATUS VALID Y 10행에 MODIFIED 미등재, CHG_COMPLETE='등록완료(변경 후)' 의미 일치. MODIFIED 유지 시 TAB2 GET RGS INNER JOIN 에서 원본행 영구 소실) |

## 적용 실측 행수 (2026-08-19 검증 SELECT)
| 축 | 행수 |
|---|---|
| LOOKUP (MASTER 1 + DETAIL 3) | 4 |
| PKG ALL_ARGUMENTS (GET_TAB1 6 / CANCEL 6 / CONFIRM 16 / GET_TAB2 10 / SAVE 6) | 44 = PROC_M 44 |
| GRANT EXECUTE → SCMP_APP | 1 (적용) |
| CMBO (DpjtDevelopStatus — 스모크 3행: DEV 개발/PROD 양산/DROP Drop) | 1 |
| MNU_M (SDM_Admin Lv2 SORT2 + SDM5010 Lv3, ROUTE_PATH NULL) | 2 |
| SHEET_COLUMNS TAB1 / TAB2 (SDM1010 126·SDM1020 30 무손상) | 24 / 24 |
| API_M / MSG_API | 12 / 36 |
| MNU_BTN_MPG_M | 12 |
| USER_GR_MNU_MPG_M (SPMS Administrator × 3계층) | 3 |
| USER_GR_MNU_BTN_MPG_M (단독 그룹 실측 DISTINCT=1) | 12 |
| MSG/LBL 신규 (MNU 2 + MSG 6 + LBL 1) ×3언어 | 27 |

## 미실행 (의도)
- `99_ROUTE_PATH.sql` ('sdm/project-master') — FE viewRegistry(`pages/<화면>/index.ts`) 완성 후 별도 적용.
- `03_GRANT_SYNONYM.sql` [3-2] `CREATE SYNONYM SCMP_APP.PKG_SDM5010` — **DBA 실행** (주석 처리 상태, 적용 시도 안 함).

## 발견사항 (후속 판단 필요)
1. **CMBO 'DpjtRegCat' 미등재**: SHEET_COLUMNS TAB1/TAB2 DPJT_REG_CAT 가 참조하나 CMBO_SQL_M 부재 (SDM1010 은 해당 컬럼 미사용이라 전례 없음). 본 화면은 표시 전용('S')이라 차단 아님 — 명칭 표시 필요 시 커서 DPJT_REG_CAT_NAME 사용 또는 콤보 후속 등재.
2. **개발현황 lookup 은 임시 시드** (DEV/PROD/DROP — 사용자 확정): 운영 확정값 수령 시 사내 MERGE 보수.
3. **조회조건 'Cell 유형'/'개발 현황' 콤보**: 설계서는 `SCM0001_GET_LOOKUP_VALUES` 프로시저 호출 명세 — SDM1020 계약과 동일하게 PROC_M 미등재 상태(전 화면 공통). FE 는 셀 콤보용 `CellTypeByDivision`/`DpjtDevelopStatus`(등재 완료) 재사용 가능.
4. MSG00715 = MSG00164 와 동일 문구 중복 잔재 (소비 0) — 불변 유지, 신규 소비 금지.
5. 클라우드 미적용 — 사내 전용 적용분. 이관 시 본 폴더 01~06 + (FE 완성 후) 99 + DBA 시노님 1문.
