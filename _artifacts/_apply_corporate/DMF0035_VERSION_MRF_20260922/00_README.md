# DMF0035 Version 팝업 — Monthly Rolling Forecast (SALES 전용) 편집·저장 (2026-09-22, 사내 ZIOUI1 적용)

## 요청
DMF0035 Version 팝업에 MONTHLY ROLLING FORECAST 컬럼 추가(**SALES PLAN WATERFALL 일 때만**), 당주일 때 Y/N 콤보로 수정·저장.
SALES 가 아닐 때는 컬럼 미표시 + 저장 권한 없음(사용자 확정).

## AS-IS 근거
- 팝업 `DMF0073_VersionBySalesPricePopup` — GridEdit(.cs L410~436: `EDITABLE='Y'` 행만 MRF 셀 해제), SaveData(L231~304)
- 저장 SP `dbo.DMF0073_SAVE_VERSION_SALESPRICE` → `DM_MST_VERSION.ATTRIBUTE7` / LAST_UPDATED_BY / LAST_UPDATE_DATE UPDATE
- 조회 SP `DMF0073_GET_VERSION_SALESPRICE` EDITABLE = 현재 주차 (TO-BE 변환본 사내 기존재 — 무수정 재사용)
- TO-BE 에는 저장 SP·배선이 없었다 → 신설

## 작업 ↔ 파일
| # | 작업 | 파일 | 상태 |
|---|---|---|---|
| 0 | 적용 전 원문 백업 (SOURCE-FRESH) | `00_backup/BACKUP_PKG_DMF0035_{SPEC,BODY}_pre_mrf_20260922.sql` | — |
| 1 | PKG SPEC — `P_DMF0035_SAVE_VERSION_MRF` 선언 | `01_PKG_DMF0035_SPEC.sql` | 적용 VALID (15:48) |
| 2 | PKG BODY — 저장 프로시저 신설 | `02_PKG_DMF0035_BODY.sql` (본문 원본 `_proc_body.sql`) | 적용 VALID (16:01 — SP_ 버전 가드 추가 재적용) |
| 3 | 배선 메타 — API_M / BTN_MPG `version/SAVE` / PROC_M 5행 / 그룹권한 4 | `03_META_WIRING.sql` (멱등 MERGE) | 적용 |
| FE | 모달 컬럼·콤보·편집 게이트·Save | `nscm-fe/features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx` | 로컬 반영 |
| FE | 타입 — version 응답 `YYYYMMDD`·`EDITABLE` 추가 | `nscm-fe/configs/types/procedures.d.ts` | 로컬 반영 |
| DOC | AS-IS 매핑 | `.../demand-plan-waterfall/__asis-mapping__.md` §2 | 로컬 반영 |

## 동작
- 컬럼: SALES 만 `Monthly Rolling Forecast`(Type 뒤, 170, 가운데) — 콤보 = 공용 CMBO `YesOrNo`
- 편집 셀 = 행 `EDIT_FLAG` × 컬럼 inputTpCd 'O' (공용 `GridUtils.isEditableCell` — 노란 배경·편집 차단 공용 처리)
  - `EDIT_FLAG='Y'` ⇔ SALES × `hasButton('SAVE')` × SP `EDITABLE='Y'` × SP `EDIT_YN='Y'`(사업부 편집권한) × 버전 기준일 이번 주(월~일)
  - 'Current' 행은 SP 가 EDITABLE='N' — 항상 잠김
- Save 버튼: SALES × SAVE 권한일 때만 표시. 변경 행만 `^` 연결 → `/DMF0035/version/SAVE/call-proc` → 성공 토스트 + 재조회
- 편집 가능 MRF 셀 더블클릭 = 콤보 편집 (버전 확정 OK 로 처리하지 않음)
- MSG(전부 재사용): 변경없음 MSG00004 · 필수 MSG00614 · 확인 MSG00001 · 완료 MSG00606 · 오류 MSG00618 / SP MSG·EVENT
- 사용자 = PROC_M `sesUserId`(BE 세션 자동 주입 — 요청값 미사용)

## 권한 (AS-IS 대비 변경점 — 조정 가능)
- AS-IS: 팝업 버튼 권한 없음 → 화면 진입자 전원 편집
- TO-BE: `version/SAVE` = **ADMIN · DM ADMIN · DM Planner · SCP Planner** (DM Viewer 제외). 바꾸려면 `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 만 조정
- 메인 화면 저장버튼은 `save:false` 고정이라 메뉴 단위 SAVE 권한 신설의 영향 없음

## 서버 재검증 (AS-IS 에 없던 보강 — 정상 경로에선 화면 게이트와 동일 조건이라 통과)
1. 건수 일치 2. 값 Y/N 3. **Sales Plan 버전(`VERSION_TYPE LIKE 'SP\_%'`)** 4. 당주(`ISO_YYYYWW` — 연도 포함) 5. 사업부 편집권한(`PR_SCM_EDIT_YN`)
- AS-IS `DIVISION_ID = 단일값` 비교(복수 Division 선택 시 0건) → 콤마 분할 IN 으로 해소

## 검증 (로컬 BE + 사내 DB, HTTP E2E — 테스트용 당주 버전 행 생성 후 삭제, 잔존 0)
| 케이스 | 결과 |
|---|---|
| 조회 — 당주 SP 테스트 행 | EDITABLE=Y · EDIT_YN=Y · MRF=N |
| SP 당주 Y 저장 | CODE 0 / 1건 · DB ATTRIBUTE7='Y' · LAST_UPDATED_BY=minyonglee1 · 재조회 Y |
| SP 당주 N 저장(복구) | CODE 0 / DB 'N' |
| **MF(MKT) 당주 버전 저장** | CODE -1 (Sales Plan 버전 아님) · DB 불변 |
| 값 'X' | CODE -1 |
| 지난 주 버전(SP_W_20260827_V001) | CODE -1 · DB 불변 |
| 건수 불일치 | CODE -1 |
| 메뉴 권한 — ADMIN(minyonglee1) | SAVE 포함 |
| 메뉴 권한 — DM Viewer 전용(yeonjusung) | SAVE 없음 → Save 버튼·편집 불가 |
| FE 문법 | esbuild 변환 OK (타입체크·린트는 요청 시) |

- 화면(브라우저) 조작 확인은 미실행. 사내 DB 에 현재 당주 SP 버전이 없어(마지막 SP_W 08-27) 실데이터 편집은 주간 배치로 버전이 생긴 뒤 가능.

## 클라우드
미적용 · 이관 패키지 미작성.
