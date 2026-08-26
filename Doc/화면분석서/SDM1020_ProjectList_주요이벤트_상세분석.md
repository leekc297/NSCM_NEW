# SDM1020 Project List — 주요 이벤트 상세분석

> ⭐ **정본 원천 = 화면설계서 xlsx** (AS-IS GSCM 대응 화면 부재 — 순수 신규 화면, hook #134 §0/§2).
> 본 md 는 hook #105 E번호 양식으로 재기술한 설계서 전수 분석이며, `asis_mapping_gate --init` 의 원천이다.

## 원천 (전수 Read 실측)

| 구분 | 경로 | 비고 |
|---|---|---|
| 정본 설계서 | `Doc/화면설계서_SDM/SDM1020/SDM1020_ProjectList_화면설계서_20260814.xlsx` | 8시트 전수 덤프 (v1.1, 2026-08-13 "프로젝트 조회 → 프로젝트 조회/변경" 개명). 루트 0730 구판 참조 금지 |
| SP 원문 | `Doc/화면설계서_SDM/SDM1020/SQL_PACKAGE/PKG_SDM1020.txt` (+`PKG_SDM1020_BODY.txt` — 내용 동일 실측 diff 0) | 신규 3본 (KTJ 2026-08-13) |
| 테이블 DDL | `Doc/화면설계서_SDM/SDM1020/TABLE/SPMS_PROJECT_MST.txt` / `SPMS_PROJECT_USER_MAP.txt` | SDM1010 수신 정본과 동일 테이블 (PK: DPJT_KEY / (DPJT_KEY,USER_ID)) |
| 팝업 SP 재사용 실존 확인 | `_artifacts/_apply_corporate/SDM1010_DBSWAP_20260813/04_PKG_RECEIVED_PATCHED.sql` | 설계서 기재 `P_SDM1010_*` 팝업 8본 전부 수신 PKG_SDM1010(15본)에 실존 — 시그니처 대조 완료 |
| 정오표 | `Doc/화면분석서/SDM1020_ProjectList_정오표.md` | 설계서·SP 결함 D1~D12 + 미결 |

- 화면 구조: 단일 그리드(탭 없음) + 팝업 1 (`권한관리` — SDM1010 ProjectAuthRegModal 계열 재사용) + 공용 설정 모달(`ColumnSettingModal` — SP `?` 미결).
- 화면 성격: **저장 버튼 없음** — 그리드 변경은 [등록요청] 버튼에 의해서만 저장(개요 B27). 조회/변경 + 권한관리 + 권한요청.
- 권한 그룹: `SPMS Administrator` / `SPMS Planner` (개요 B7).
- 조회조건 5종(개요 B11:H17): 사업부(`MyDivision`, Single, 필수, 첫 값 — LBL00001)/고객(`EndCustomerByDivision`, Multi, ALL)/나의 권한(`SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_DPJT_AUTH_TYPE`, Multi, ALL)/등록 상태(동 SP `SPMS_DPJT_REG_STATUS`, Multi, ALL)/등록 완료일(Date, 필수, `PR_GET_DAY_RANGE` — M-1 ~ Today).
- SP: **신규 3본**(PKG_SDM1020) `P_SDM1020_GET_PJT_LIST` / `P_SDM1020_BTN_REQ_PJT_REG` / `P_SDM1020_REQ_PJT_AUTH` + **재사용 8본**(PKG_SDM1010) `P_SDM1010_GET_POP_USER_ORG` / `GET_POP_USER_BY_DEPT` / `GET_POP_PJT_AUTH_WRITE` / `GET_POP_PJT_AUTH_READ` / `GET_POP_PJT_AUTH_REQ` / `SAVE_POP_PJT_AUTH_WRITE` / `SAVE_POP_PJT_AUTH_READ` / `SAVE_POP_BTN_REJECT`.

## 이벤트 전수 요약표

| EID | 트리거 | 처리 | SP / 대상 |
|---|---|---|---|
| E01 | 화면 진입(초기화) | 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | MyDivision·EndCustomerByDivision·LOOKUP 2종·PR_GET_DAY_RANGE |
| E02 | 사업부(Division) 변경 | 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | fetchStaticColumns / 콤보 재조회 |
| E03 | 조회(Search) | 필수(Division·기간)·기간 역전 검증 → 조회 | P_SDM1020_GET_PJT_LIST |
| E04 | 그리드 셀 편집 | 관리자 행만 편집 + CODE/NAME 콤보 dataMap + 종속 셀 처리 | — |
| E05 | 권한요청 입력/조회 체크박스 | 상호배타(하나 선택 시 반대쪽 자동 해제) + 비활성 가드 | — |
| E06 | 등록요청 버튼 | Checked·변경내역 가드 → confirm → 변경 등록 요청 → 재조회 | P_SDM1020_BTN_REQ_PJT_REG |
| E07 | 권한요청 링크(그리드 내) | 체크값 가드 → confirm(요청/취소) → 권한 요청 → 재조회 | P_SDM1020_REQ_PJT_AUTH |
| E08 | 권한관리 링크 클릭 | 관리자 행만 — 권한관리 팝업 오픈(프로젝트 키 전달) | 팝업 SP 8본 |
| E09 | 팝업 오픈(초기 조회) | 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | P_SDM1010_GET_POP_USER_ORG / GET_POP_PJT_AUTH_WRITE / _READ / _REQ |
| E10 | 팝업 사용자 검색 | 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | P_SDM1010_GET_POP_USER_BY_DEPT |
| E11 | 팝업 조직도 부서 클릭 | 부서 정보만 전달 → 사용자 목록 조회 | P_SDM1010_GET_POP_USER_BY_DEPT |
| E12 | 팝업 (+) 버튼 | 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | — (pending) |
| E13 | 팝업 (−) 버튼 | 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | — (pending) |
| E14 | 팝업 요청 그리드 입력/조회 이동 | 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | — (pending) |
| E15 | 팝업 반려 버튼 | Alert 후 **즉시 SP 호출** → 반려 상태 즉시 표시 | P_SDM1010_SAVE_POP_BTN_REJECT |
| E16 | 팝업 OK(저장) | 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | P_SDM1010_SAVE_POP_PJT_AUTH_WRITE / _READ |
| E17 | 팝업 Close/X | 저장 없이 닫기(pending 폐기) | — |
| E18 | 엑셀 버튼 | 엑셀 다운로드(콤보 NAME 출력) | — |
| E19 | 컬럼 설정 버튼 | 공용 ColumnSettingModal 호출 — **SP `?` 미결(임의 배선 금지)** | (미결) |
| E20 | 기본 기능 | 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | — |
| E21 | 상태 TAG 렌더링 | 등록 상태 TAG + 권한요청 상태 TAG(warning-major) | — |

---

## E01. 화면 진입(초기화)

1. 조회조건 콤보 적재(1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수 — 개요 F13), 고객=`EndCustomerByDivision`(Multi, 기본 ALL, 사업부 종속 — 개요 H14), 나의 권한=`SCM0001_GET_LOOKUP_VALUES(p_lookup_type='SPMS_DPJT_AUTH_TYPE')`(Multi, ALL), 등록 상태=동 SP `'SPMS_DPJT_REG_STATUS'`(Multi, ALL).
2. 등록 완료일 기본값: `PR_GET_DAY_RANGE`(개요 H17 — P_FR/TO_BUCKET·DATE_VAL·BUCKET_TYPE·P_SES_USER_ID) → **M-1 ~ Today** (개요 F17).
3. 그리드 컬럼 메타: `fetchStaticColumns`/`fetchStaticMeasures`(SCM_MST_SHEET_COLUMNS — mount 시). Division 종속 컬럼 축(X열: 81 계열/40/82 — UI컬럼 정의 시트 X·Y열) 반영.
4. 버튼 권한: `useTabBtnPermissions` — SPMS Administrator/SPMS Planner 그룹별 버튼 매핑.
5. 초기 자동조회 여부는 설계서 미기재(정오표 미결 — 확정 전 자동조회 미배선).

## E02. 사업부(Division) 변경

- 설계서 개요 H13 원문: "사용자 권한에 따라 표시 - 변경 시 컬럼정보를 재조회, 그리드 내용 초기화".
- 처리: ①종속 콤보 재적재(고객 `EndCustomerByDivision` — ALL reset) ②`fetchStaticColumns` 재조회(Division 종속 컬럼 X/Y열) ③그리드 데이터 비움 + CRUD pending(체크·편집 tracker) reset. 재조회는 Search 버튼(자동 재조회 금지 — Division 변경 규약).

## E03. 조회(Search)

- 검증: Division 미선택 → `MSG00097`(P-09, 개요 F24 "사업부(Div), 등록완료일 필수") / 시작일>종료일 → `MSG00108`(P-10).
- SP: `P_SDM1020_GET_PJT_LIST` — 7 IN + O_CURSOR + O_RESULT_CURSOR (Project List 시트 H43~K49 = SP 시그니처 일치 실측):
  `P_DIVISION_ID` / `P_END_CUSTOMER`(Multi 콤마) / `P_DPJT_AUTH_TYPE`(Multi) / `P_DPJT_REG_STATUS`(Multi) / `P_REG_COMP_DATE_FR` / `P_REG_COMP_DATE_TO` / `P_SES_USER_ID`(Session).
- SP 내부(원문 실측): 멀티 필터 4종 = `UF_FX_STRING_SPLIT(p, ',')` WITH 테이블화 + `'ALL'` 이면 무필터. 기간 = `REG_COMP_DATE BETWEEN`(FR·TO 양쪽 NULL 이면 무필터). 나의 권한 필터 = `DPJT_AUTH_STATUS='REQUEST'` 행을 `'NONE'` 으로 치환 후 IN 판정.
- 결과 커서 주요 파생(원문 실측): `DPJT_AUTH_TYPE/`_NAME`(REQUEST 상태=권한없음 치환) / `DPJT_AUTH_MGMT`(ADMIN=`''`·그 외 `'-'`) / `DPJT_AUTH_REQ_STATUS`+`DPJT_AUTH_REQ_WRITE_NAME`+`DPJT_AUTH_REQ_WRITE_COLOR_TYPE`(관리자이고 REQ_COUNT>0 → '권한요청'/warning-major) / `DPJT_AUTH_REQ_WRITE`·`DPJT_AUTH_REQ_READ`(행별 3상태 `DISABLED`/`CHECKED`/`UNCHECKED`) — 컬럼명 결함은 정오표 D1/D2.
- 조회 성공 시 CRUD pending reset. 수정 중 재조회 confirm `MSG00703`(UC-02). ORDER BY 없음 — 정렬은 FE 몫.

## E04. 그리드 셀 편집

- 편집 가능 조건(P-01): **나의 권한 = 관리자(`DPJT_AUTH_TYPE='ADMIN'`) 행만** 항목 수정 가능(확인 사항 1.1/3.1.1). 비관리자 행 = 전 셀 잠금(Gray).
- 편집 대상 컬럼(정오표 D5 — 설계서 Input Type 전 행 'S' 를 편집 컬럼에 한해 IM/IO 재지정): Project Class/Customer/Project Name/Cell Type/Stack Method/Biz Type/SOP Date/SOP Plant/개발 현황.
- 셀 콤보(CODE/NAME — 저장 CODE·표시 NAME): Project Class=`DpjtClass`, Customer=`EndCustomerByDivisionDept`, Cell Type=`CellTypeByDivision`, Stack Method=`StackMethodByCellType`(**Cell Type 종속** — Cell Type 변경 시 Stack Method clear), Biz Type=`BizTypeByDivision`(정오표 미결 — 설계서 병기 중 확정값), SOP Plant=`PlantByDivisionCompany`, 개발 현황=`DpjtDevelopStatus`. SOP Date=FPDate(YYYY.MM.DD).
- 편집 발생 시 CRUD_TYPE='M' 마킹(EditTracker 공통 규약) — 등록요청 활성 조건(P-06)의 원천.

## E05. 권한요청 입력/조회 체크박스 컨트롤

- 상호배타(P-05, 확인 사항 2.1/2.1.1): 입력/조회 둘 중 하나만 선택 가능 — 하나 선택하면 다른 쪽 자동 해제(Unchecked).
- 비활성(P-04, 확인 사항 1.3.1): 권한요청 가능한 경우(나의 권한=권한없음·조회 권한)가 아니면 Checkbox 비활성. SP 가 행별 `DISABLED`/`CHECKED`/`UNCHECKED` 3상태를 내려줌(E03) — FE 는 이 값 단일 원천으로 렌더(CHECKED=요청 진행 중 표시).

## E06. 등록요청 버튼

- 대상: 그리드 Checked 행(개요 B27 "선택 프로젝트에 대한 프로젝트 변경 등록 요청 — 저장 버튼이 따로 없고 그리드 내용 변경 후 등록요청에 의해서만 수정 내역이 저장된다").
- 가드: 변경 내역 없으면 불가(P-06 — "수정된 내용이 없습니다." → MSG00004 재사용 후보) / 선택 0건 → "선택한 항목이 존재하지 않습니다."(P-07 — MSG00709 재사용).
- confirm: "프로젝트를 등록/변경 하시겠습니까?"(P-08 — MSG00710 재사용).
- SP: `P_SDM1020_BTN_REQ_PJT_REG` — 14 IN(`P_ACTIVE_FLAG` + 컬럼 12종 + `P_SES_USER_ID`) `'^'` 벌크 계약(행 단위 REGEXP_SUBSTR 분해 — 원문 실측). ⚠ 설계서 파라미터 표(B52: DIVISION/DPJT_KEY/SES_USER 3종)와 불일치 — SP 원문이 정본(정오표 관찰 O-1).
- SP 처리(원문 실측): 행별로 ①새 DPJT_SEQ 채번(`MAX(DPJT_SEQ)+1` — DPJT_CODE 단위) ②새 DPJT_KEY=`DPJT_CODE_000NNN` 로 **변경본 신규 INSERT**(DPJT_REG_STATUS='REQ_MOD' 변경요청, DPJT_REG_CAT='MOD', DPJT_MGMT_STATUS='TEMP', DPJT_KEY_PARENT=원본 키) ③원본 행 'MODIFYING'(변경중) 전이 UPDATE — 단 WHERE 절 결함으로 사문(정오표 D3 — PKG 최소 정정 승인). `P_ACTIVE_FLAG` 분기 부재(항상 INSERT 경로 — 정오표 D4: SP 무수정, **FE 가 'M' 행만 전달**).
- 결과: `O_RESULT_CURSOR`(CODE/MSG/EVENT) — CODE='0' 판정(위치 아닌 이름 기반). 성공 "성공적으로 등록요청 되었습니다."(MSG00711 재사용)/실패 "등록요청에 실패하였습니다."(MSG00712 재사용) → 재조회. 내부 COMMIT 보유.

## E07. 권한요청 링크(그리드 내 Exec. Link) 클릭

- 컬럼: `권한 요청 > 요청` 열(Exec. Link — 메타 컬럼명은 정오표 D1, FE 파생 컬럼으로 렌더). 나의 권한=권한없음·조회 권한 행만 노출(P-03 — GRID 목업: 관리자/입력 권한 행 `-`).
- 가드: 입력/조회 선택(Checked) 값 없음 → "권한요청 항목이 없습니다."(신규 채번 — 정오표 미결 MSG).
- confirm: "권한요청 하시겠습니까?"(신규 채번). **취소 재요청 경로**(Checked 요청 존재 상태에서 해제 후 클릭) → "권한요청을 취소 하시겠습니까?"(신규 채번, Project List I72) — 단 SP 에 취소 경로 부재(정오표 D12 — PKG 최소 정정 승인).
- SP: `P_SDM1020_REQ_PJT_AUTH` — `P_DPJT_KEY` / `P_DPJT_AUTH_REQ_WRITE` / `P_DPJT_AUTH_REQ_READ` / `P_SES_USER_ID` + O_RESULT_CURSOR.
- SP 처리(원문 실측): WRITE 체크 우선 → `V_DPJT_AUTH_TYPE_REQ`='WRITE'/'READ'/'NONE'(수용값 `'Y'/'TRUE'/'CHECKED'/'CHECK'` 대문자 비교). NONE 이 아니면 `SPMS_PROJECT_USER_MAP` MERGE(ON DPJT_KEY+USER_ID): 신규=INSERT(REQUEST 상태), 기존=UPDATE — 단 ADMIN/WRITE CONFIRM 보유자·동일 요청 반복은 no-op 가드(CASE 1/0). 메일링은 주석만("추가로 메일링 관련 로직 필요" — 정오표 미결). 내부 COMMIT.
- 성공 "성공적으로 권한요청 되었습니다."/실패 "권한요청에 실패하였습니다."(신규 채번 2건) → 재조회(체크박스 CHECKED 반영).

## E08. 권한관리 링크 클릭 → 팝업 오픈

- 컬럼 `DPJT_AUTH_MGMT`(권한 관리) — SP 가 관리자 행만 `''`(링크 노출), 그 외 `'-'`(P-02, 확인 사항 1.2). 링크 라벨 '권한관리'(GRID 목업 U12/U18). Cell object 공란 → FPModal+ATTRIBUTE1 규약 적용(정오표 D7).
- 클릭 → 권한관리 팝업 오픈. 입력 = 해당 행 프로젝트 코드(개요 D33 — 실전달 키는 DPJT_KEY invisible).
- 닫힘 후: 그리드 재조회 → "입력/조회 권한등록" 상태 값 update(개요 F33).

## E09. 팝업 오픈(초기 조회 4축)

- ①조직도: `P_SDM1010_GET_POP_USER_ORG`(P_SES_DIVISION_ID/P_SES_USER_ID — Session) ②입력 권한: `P_SDM1010_GET_POP_PJT_AUTH_WRITE`(P_DPJT_KEY=Parent GRID Focused Row/P_SES_DIVISION_ID/P_SES_USER_ID) ③조회 권한: `P_SDM1010_GET_POP_PJT_AUTH_READ`(동일) ④권한요청: `P_SDM1010_GET_POP_PJT_AUTH_REQ`(동일). 시그니처 = 수신 PKG_SDM1010 실측 대조 일치.
- 입력/조회 그리드 최초 Load 시 요청 정보 invisible 보유 의무(확인 사항 2.2.2 — P-18 전제).

## E10. 팝업 사용자 검색(Search)

- 검색 버튼 클릭 → **사용자 조회 조건 값만** 파라미터로 전달(확인 사항 1.1[팝업]) → `P_SDM1010_GET_POP_USER_BY_DEPT`(P_USER_INFO=User ID(Name)/P_DEPT_ID/P_SES_DIVISION_ID/P_SES_USER_ID).
- 조건 값 없으면 그리드 미출력(확인 사항 1.1.1 — P-13).

## E11. 팝업 조직도 부서 클릭

- 부서 클릭 → **부서 정보만** 파라미터로 전달(확인 사항 2.1[팝업 §1] — P-14) → 동 SP(P_DEPT_ID=조직도 GRID Focused Row).

## E12. 팝업 (+) 버튼 — 입력/조회 리스트 추가

- 선택 사용자를 입력 또는 조회 리스트로 이동(pending — OK 저장 시 확정).
- 가드 3종: 관리자 추가 불가(확인 사항 4.1 — "관리자는 권한을 추가할 수 없습니다." 신규 채번) / 입력 리스트 기존재("User 는 입력 리스트에 이미 존재합니다." → MSG00716 재사용) / 조회 리스트 기존재("User 는 조회 리스트에 이미 존재합니다." → MSG00717 재사용). 입력으로 추가하든 조회로 추가하든 **입력/조회 리스트 모두 체크**(확인 사항 4.2.1 — P-16).

## E13. 팝업 (−) 버튼 — 리스트 제외

- 입력/조회 리스트에서 사용자 제외(pending). 요청 정보가 존재하는 사용자 제외 시 **요청 그리드에 해당 사용자 정보를 추가**(확인 사항 2.2/2.2.1 — 상태/요청 정보 표시 위해 요청 정보 보유 의무 2.2.2). 최종 반려 처리는 OK 저장 시(확인 사항 3.1.2 — P-20).

## E14. 팝업 요청 그리드 → 입력/조회 이동(그리드 버튼 입력/조회)

- 요청 행을 입력/조회 영역으로 이동(권한관리 팝업 시트 B69/D69·D70) — 이동 시 요청 정보 보유(확인 사항 2.2.3). pending — OK 저장 시 확정(확인 사항 2.1[Process] — P-17).

## E15. 팝업 반려 버튼

- 반려 클릭 → Alert(confirm) 후 **바로 반려 처리(SP 호출 — OK 저장과 무관)**: `P_SDM1010_SAVE_POP_BTN_REJECT`(P_DPJT_KEY/P_USER_ID=요청 GRID Focused Row/P_SES_USER_ID) — 확인 사항 2.3.
- SP 정상 동작 후 "반려" 상태 값을 바로 표시(확인 사항 2.3.1 — P-19).

## E16. 팝업 OK(저장)

- `P_SDM1010_SAVE_POP_PJT_AUTH_WRITE` + `P_SDM1010_SAVE_POP_PJT_AUTH_READ`(각 P_ACTIVE_FLAG=I/D/M / P_DPJT_KEY / P_USER_ID / P_SES_DIVISION_ID / P_SES_USER_ID).
- **입력/조회 그리드의 모든 값을 저장 SP 에 전달**(확인 사항 3.1 — P-20): "반려" 상태 Update(3.1.1) + 입력/조회 권한 제외자의 요청 이력 반려 처리(3.1.2).
- 성공 "성공적으로 저장되었습니다."(MSG00002 Toast — hook #132 §3)/실패 "저장에 실패하였습니다."(MSG00003) → 닫힘 후 메인 그리드 재조회(E08 후처리).

## E17. 팝업 Close/X — 저장 없이 닫기(pending 폐기)

## E18. 엑셀 버튼

- 엑셀 다운로드(개요 B25) — 콤보 컬럼 NAME 출력(UC-05)·Excel Name 규약(UC-05 계열)·활성 그리드 라우팅.

## E19. 컬럼 설정 버튼

- CustomButton → 공용 `ColumnSettingModal` 호출(개요 F26). 설정 저장 시 그리드 비움 + CRUD reset(UC-03/hook #132 §2-2), 저장 성공 Toast.
- ⚠ 호출 SP = 설계서 `?`(개요 K26) — **SP 임의 배선 금지**(SDM1010 정오표 #14 판례 동일 — 정오표 미결). 설계서 SP 확정 기재 시 배선.

## E20. 기본 기능

- 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort(개요 B23 — 공통 필수). Insert 성 이벤트 부재 화면(행 추가 없음)이나 UC-01(필터 유지 `keepRowVisibleUnderFilter`)·UC-07(재조회 필터 유지 `rebindFilterColumns`) 공통 축은 대사표에서 판정.

## E21. 상태 TAG 렌더링

- `DPJT_REG_STATUS`(TAG — Reg Status): GRID 목업 범례(R36~R45) 도메인 = 작성중/승인대기/등록완료/반려/변경등록(수정등록 승인 후 원래 상태)/변경중(수정만 한 상태)/변경요청(수정 후 등록 요청)/등록완료(수정 후 등록 완료)/**?**(수정 후 등록 요청 반려 — 상태 코드 미정, 정오표 미결).
- `DPJT_AUTH_REQ_STATUS`(TAG — Auth Request Status): 관리자 행에 미처리 요청 존재 시 '권한요청'(COLOR_TYPE=warning-major). 컬럼명 정합은 정오표 D2.
