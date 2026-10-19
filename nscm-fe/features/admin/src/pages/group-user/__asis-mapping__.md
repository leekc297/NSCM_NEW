# SYS0014 Group User — AS-IS ↔ TO-BE 매핑

> **AS-IS 원본 = SCM0005** `GroupUserInfo.cs` (06_UIL/common/GSCM.SystemMgmt.UIL) + SP `UP_FX_GetGroupInfoList` / `UP_FX_GetUserGroupInfoList` / `UP_FX_GetUserGroupAuthExtentionList` / `UP_FX_SaveUserGroupInfo`.
> AS-IS SpdSheet 5종(GroupInfo/UserInfo/Division/Plant/Customer) 중 **Plant/Customer 는 `//AddSheet` 주석(미사용)** → TO-BE 도 3그리드(GroupInfo/UserInfo/Division)만 구현.

## 화면 구조 (좌 GroupInfo + 우상 UserInfo + 우하 Division) — AS-IS 레이아웃 정합
| 영역(SHT_NM) | Grid | SP | 응답 컬럼 | 편집 |
|---|---|---|---|---|
| GroupInfo | GroupUserMainGrid | `P_SYS0014_GET_GROUP_LIST_M` | USER_GR_ID/USER_GR_NM/USE_YN | Group 등록/수정/삭제 |
| UserInfo | GroupUserInfoGrid | `P_SYS0014_GET_USER_BY_GROUP_M` | USER_ID/USER_NM/USER_ENG_NM/USER_EML/DEPT_NM/USE_YN + 감사4 | 그룹내 사용자 매핑 |
| Division | GroupUserUnitGrid | `P_SYS0014_GET_AUTH_LIST_M` | UNIT_ID/UNIT_NM/**JV_PLANT_ID**/UPPR_UNIT_ID/EDIT_YN/USE_YN | 단위 권한 (그룹 조건부 D/J) |
| 저장(통합) | — | `P_SYS0014_SAVE_GROUP_USER_M` (CLOB `$[*]` + SHT_NM 분기) | — | 3시트 CRUD 일괄 |

## 표시 컬럼 (SCM_MST_SHEET_COLUMNS — 2026-06-26 조정 반영)
- **GroupInfo (2)**: GroupID(USER_GR_ID, IM) · GrpName(USER_GR_NM, M)
  - `USE_YN` 표시 컬럼 삭제(2026-06-26) — SP/타입엔 잔존(신규 row 저장 default 'Y').
- **UserInfo (10)**: UserID(USER_ID) · UserName(USER_NM) · EnglishName(USER_ENG_NM) · Email(USER_EML) · Dept_Name(DEPT_NM) · UseYN(USE_YN) · Create By(CREATED_BY) · Create Date(CREATION_DATE) · Last Update By(LAST_UPDATED_BY) · Last Update Date(LAST_UPDATE_DATE)
  - `Dept_ID` 삭제 + 감사 4컬럼 추가(2026-06-26). 감사 소스 = `SCM_ADM_USER_GR_MPG_M`.
- **Division (2)**: Name(UNIT_ID) · **JV Plant(JV_PLANT_ID)**
  - 기존 Code(UNIT_ID)→**Name 라벨변경**, UNIT_NM(부문명) 컬럼 제거(2026-06-26).
  - **JV Plant 구현(2026-06-26)** — AS-IS `FindData_Division`: 그룹='JV Planner'면 AuthType='J'(DIVISION+JV_PLANT), 그 외 'D'. SP `P_SYS0014_GET_AUTH_LIST_M` = **UNION ALL** (비JV→`SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` D / JV Planner→`TB_FX_USERGROUPAUTHEXTENTION` J JOIN `SCM_MST_DIVISION`). **auth 테이블 컬럼 추가 없이** 기존 `TB_FX_USERGROUPAUTHEXTENTION.JV_PLANT_ID` 컬럼 JOIN 으로 동시 출력.
  - **데이터 이관(`08_JV_PLANNER_DATA_MIGRATION.sql`)**: AS-IS 실데이터 — user master 11 + JV Planner 매핑 11 + J auth 17행(JV_PLANT_ID). 멱등(WHERE NOT EXISTS).
  - ⚠️ **저장 경로 미구현(표시 전용)**: JV(JV_PLANT) 편집 저장은 `TB_FX_USERGROUPAUTHEXTENTION` 기록 필요 — 현 SAVE SP 는 `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` 만 기록. 사용자 요청은 조회(QUERY 동시 출력) 범위.
- 모든 표시 컬럼 SP 출력과 1:1. 타입 SSOT = `configs/types/procedures.d.ts` SYS0014.

## API ↔ 버튼 (SCM_ADM_MNU_BTN_MPG_M ↔ SCM_ADM_API_M)
| SHT_NM | BTN_CD | API_ID |
|---|---|---|
| GroupInfo | SEARCH / SAVE / **INSERT / DELETE** | API_SYS0014_GET_GROUP_LIST / _SAVE_GROUP_USER / (client) / (client) |
| UserInfo | SEARCH / **INSERT / DELETE** | API_SYS0014_GET_USER_BY_GROUP / (client) / (client) |
| Division | SEARCH / **INSERT / DELETE** | API_SYS0014_GET_AUTH_LIST / (client) / (client) |

> **굵게** = INSERT/DELETE 는 클라이언트 동작(API_ID NULL) — `useTabBtnPermissions().hasButton()` 권한 분기용 등록. INSERT/DELETE 는 **포커스/선택 그리드**(activeSheetRef + gotFocus) 기준 적용.
> UserInfo INSERT(2026-10-08 통합테스트 지적 "한 명씩 되풀이" 보완): 빈 행을 넣지 않고 공용 `SsoUserModal` 을 **멀티 체크 모드**(`multiCheckbox` + `setSelectedValues`, 신규 optional prop — 기본값 false 로 기존 단건 호출처 11곳 동작 보존)로 먼저 띄워 선택한 사용자 전부를 행으로 넣는다 — AS-IS `InsertRow` L786~811 `UserInfoPopup.SelectedUserInfoList` 1:1(GroupID/UserID/UserName/UserName_E/Dept_Name/UseYN='Y'). 이미 있는 USER_ID 는 건너뛰고(PK USER_GR_ID+USER_ID), D 표시 행을 다시 고르면 삭제 취소. 신규 행의 User ID 칸 더블클릭 단건 팝업은 그대로 둔다.

## 권한 (Validation 대응)
- `useTabBtnPermissions({ menuId: 'SYS0014' })` → BE `GET /admin/menu/SYS0014/auth` → `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 기반 `hasButton(BTN_CD)`.
- onInsertUser: Group 미선택 시 `MSG00625`. insertUnit: Group/User 미선택 시 `MSG00626`. onSave: 변경 0 시 `MSG00627`. 저장 성공 `MSG00002`. 변경불가 셀 `MSG00007`.
- onSave UserInfo 필수값(2026-10-08 추가, 사용자 결정 "화면에만"): USER_ID / USER_NM 공백이면 `MSG00429` "{0} 값은 필수 입력 항목입니다."(라벨은 칸 메타 colLblNm)로 차단. 배경: 화면·저장 SP 모두 필수 검사가 없고 `SCM_ADM_USER_GR_MPG_M.USER_ID` 가 DEFAULT ON NULL '-' 라 빈 값이 '-' 로 저장됐다. 헤더 빨간 점(IM)은 표시일 뿐 검증과 연결돼 있지 않았다(useSaveWithValidation 미사용). GroupInfo 쪽(USER_GR_ID/USER_GR_NM, 그리드 isReadOnly·메타 'S')과 SP 가드는 미처리 — 별도 결정.

## 점검 결과
모든 행 ✅ — AS-IS SCM0005 레이아웃/컬럼 정합 + 메타/SP/권한 1:1 매핑. JV Plant 만 데이터 소스 확정 후 추가 예정(표시).
