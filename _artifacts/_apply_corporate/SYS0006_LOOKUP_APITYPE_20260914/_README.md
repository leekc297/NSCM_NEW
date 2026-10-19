# SYS0006 API Type 룩업 디테일 등록 (2026-09-14)

## 상태: **사내 ZIOUI1 적용 완료** (2026-09-14, 사용자 지시) · 클라우드 ⛔ 미적용
- 1회차 5행 INSERT / 2회차 0행 (멱등 확인)
- `PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST('API_TP_CD')` → CODE/NAME 6행 (5코드 + 기존 '-' 행)
- `SCM_ADM_API_M` 코드 중 룩업 미포함 0종 · SEGMENT1 중복 0
- 사내 화면 콤보 5종 라벨 정상 (사용자 확인 2026-09-14)

## rev2 (2026-09-14) — 클라우드 콤보 '-' 5개 표시
- 증상: 클라우드 조회조건 API Type 목록이 '-' 5개 = 코드 5행이 이미 있고 SEGMENT2(NAME)='-'
- rev1 은 "코드 있으면 건너뜀"이라 클라우드에서 보정 안 됨 → 01 을 **목표 상태 MERGE**(없으면 INSERT / 있으면 SEGMENT2·순번·설명 보정)로 변경
- 사내 트랜잭션 모사 후 ROLLBACK 검증: 사내 재실행 0행 / 클라우드형('-' 5행) 5행 보정·재실행 0 / 백업형(EXCELUPLOAD '-' 만) 5행·재실행 0 / 같은 코드 '-'+목표 행 공존 시 ORA-00001 없이 건너뜀

## 1. 범위
- SYS0006 조회조건 **API Type 콤보** 가 읽는 `SCM_ADM_LOOKUP_MASTER_DETAIL` `LOOKUP_TYPE='API_TP_CD'` 5행 등록만
- MASTER / `SCM_ADM_CMBO_SQL_M` / FE / BE 변경 없음

| 파일 | 내용 |
|---|---|
| `01_MERGE_LOOKUP_API_TYPE.sql` | DETAIL 5행 MERGE (ON LOOKUP_TYPE+SEGMENT1, INSERT-only, 멱등) — 사내·클라우드 동일 |
| `99_ROLLBACK.sql` | 이번 5행만 DELETE (SEGMENT1·SEGMENT2 쌍 + CREATED_BY='admin') |

## 2. 배선 (조사 근거)
- 메뉴: `SCM_ADM_MNU_M` SYS0006 = MNU_URL `api-management`
- 조회조건: `nscm-fe/features/admin/src/pages/api-management/components/ApiManagementForm.tsx:44-73`
  `useTabLookupQueries({ lookupType: 'API_TP_CD' })` → `PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST(P_LOOKUP_TYPE, O_CURSOR)`
  → 옵션 `label: t(item.NAME, item.DESC)`, `value: item.CODE`. 반환 컬럼 = MASTER 헤더(CODE=SEGMENT1, NAME=SEGMENT2)
- 그리드 API_TP_CD: `SCM_MST_SHEET_COLUMNS` (SYS0006/apiList) `CELL_COMBO_DATA_TYPE='ApiType'`
  → `SCM_ADM_CMBO_SQL_M.ApiType` = `SEGMENT1 CODE, NVL(MSG.MSG_NM, DESCRIPTION) NAME ... VALID_YN='Y' ORDER BY DISPLAY_SEQ`

## 3. 적용 전 사내 조회값 (ZIOUI1)
- MASTER `API_TP_CD`: 'API Type', SEGMENT1 'CODE', SEGMENT2 'NAME', CREATED_BY 'SYSTEM'
- DETAIL: 서브에이전트 조사 시 0행 → **15:01 재조회 시 1행** `('-','-','-','-','-', DISPLAY_SEQ NULL, 'Y', DESCRIPTION NULL, CREATED_BY 'SYSTEM')`
  - 화면에서 빈 행이 저장된 흔적으로 보임. 이번 5행과 PK 충돌 없음. **삭제하지 않음** (콤보에 '-' 항목으로 보일 수 있음 — 정리 여부는 사용자 판단)
- `SCM_ADM_API_M` API_TP_CD: PROC_SELECT 255 / PROC_SAVE 99 / PROC 79 / POST 24 / EXCELUPLOAD 1
- LBL: LBL00321 'Procedure(Read)' / LBL00322 'Procedure(Save)' / LBL00346 'Excel Upload' (SCM_ADM_MSG_M 3개 언어 존재)

## 4. 등록 행 (사용자 확정: SEGMENT2 = 클라우드 원설계 LBL 코드)
| SEGMENT1 | SEGMENT2 | SEGMENT3~5 | DISPLAY_SEQ | DESCRIPTION | 조회조건 표시 예상 |
|---|---|---|---:|---|---|
| PROC_SELECT | LBL00321 | - | 10 | Procedure Select | Procedure(Read) |
| PROC_SAVE | LBL00322 | - | 20 | Procedure Save | Procedure(Save) |
| PROC | Procedure | - | 30 | Procedure | Procedure |
| POST | Post | - | 40 | Post | Post |
| EXCELUPLOAD | LBL00346 | - | 50 | Excel Upload | Excel Upload |

- 근거: 클라우드 원본 백업 `_artifacts/cloud-to-local-mirror/data/SCM_ADM_LOOKUP_MASTER_DETAIL_BAK.csv` (PROC_SELECT/LBL00321, PROC_SAVE/LBL00322, EXCELUPLOAD/'-'). PROC/POST 는 대응 LBL 없음 → 영문 명칭, 신규 LBL 채번 없음
- ON 키를 LOOKUP_TYPE+SEGMENT1 로 둔 이유: 클라우드에 EXCELUPLOAD/'-' 같은 원래 행이 있으면 PK(SEGMENT2 포함) 기준 MERGE 는 같은 코드를 한 줄 더 만든다 → 코드가 이미 있으면 넣지 않음(기존 행 보존)

## 5. 적용 후 확인 절차
1. DETAIL `API_TP_CD` = 기존 '-' 1행 + 5행, SEGMENT1 중복 0
2. `PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST('API_TP_CD')` 가 5개 코드 반환
3. `SCM_ADM_API_M` 코드 중 룩업 미포함 = 0종
4. 01 재실행 시 0행 (멱등)
5. SYS0006 화면 조회조건 API Type 콤보 라벨 표시 확인
