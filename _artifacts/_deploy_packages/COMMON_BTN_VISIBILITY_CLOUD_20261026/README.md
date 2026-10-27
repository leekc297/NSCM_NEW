# COMMON_BTN_VISIBILITY_CLOUD_20261026 — 공통버튼 노출 TO-BE 룰(기능 × 권한 × Division) 이관 패키지

**적용 룰(사용자 지시 2026-10-26, CR-070)**: Insert(F8)/Delete(F9)/Save(F7)/Upload 공통버튼은
① 화면에 그 기능이 있고(`hotkeyConfig` 핸들러) ② 사용자(조회조건 Division 이 단일이면 그 Division 단위권한 그룹)에게 버튼 코드 권한이 있을 때만 보인다.
AS-IS 가 기능 없는 버튼을 일괄 노출해도 TO-BE 는 숨긴다(정합검증 PASS). Division 선택이 바뀌면 권한을 다시 조회해 노출을 바꾼다(cascade).

| 폴더 | 내용 | 사내(ZIOUI1) 적용 | 클라우드 |
|---|---|---|---|
| `00_PRECHECK/` | 패치 전 `PKG_NSCM_UI_COM_AUTH` SPEC/BODY 원문(사내 ALL_SOURCE 2026-10-26) — 클라우드 원문과 문자 대조 후 20_PKG 적용 | — | 대조 |
| `20_PKG/PKG_NSCM_UI_COM_AUTH_COMMON.sql` | `PR_GET_MNU_BTN_AUTH_DIV(P_USER_ID, P_MNU_ID, P_DIVISION_ID, DATA)` 추가(기존 4 프로시저 무변경). 단일 Division → `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M`(UNIT_TP_CD='D') 그룹 + Division 단위권한이 전혀 없는 전역 그룹(ADMIN 직접부여·GUEST) / NULL·'ALL'·복수 → 그룹 합집합 | ✅ 15:0x 컴파일 VALID (USER_ERRORS 0) | 실행 |
| `30_META/30_BTN_META_INSERT_DELETE.sql` | FE 가 Insert/Delete 기능을 가진 23 메뉴 × 시트의 `SCM_ADM_MNU_BTN_MPG_M` INSERT/DELETE 코드 57행 + 그룹 권한(같은 메뉴·시트 **SAVE 권한 복사**) — 멱등 MERGE, admin 이 `USE_YN='N'` 으로 둔 코드(SCP0028·DMF0044)는 건드리지 않음. 근거 `btn_meta_gap_report.csv`(SKIP = DMF0013: 메뉴 USE_YN=N / SCP0018·SCP0039: SAVE 권한 자체 없음 → FE 도 NO-OP) | ✅ `--commit` (MERGE 114 OK · 재실행 0건 = 멱등) | 실행 |
| `90_VERIFY/90_BTN_AUTH_DIV_SAMPLES.sql` | 표본 사용자 × Division 호출(DBMS_OUTPUT). 사내 실측: dodae 40 → SEARCH 만 · jiwon.park 40 → 0건(81 만 권한) · minyonglee1 ALL/40/EE → SAVE | ✅ | 사용자 ID 환경에 맞게 |
| `99_ROLLBACK/` | PKG 원문 복원 · 메타 추가분 삭제(CREATED_BY='admin' & 2026-10-26 이후 한정) | — | 필요 시 |
| `B_BE/` | `MenuController`(`?divisionId` 선택 파라미터) · `AuthService`/`Impl`(3-인자 오버로드) · `Auth.xml`(`retrieveMenuBtnAuthDiv`) — 실경로 | 로컬 BE 재기동 완료 | 배포 |
| `B_FE/` | `SubTitle.tsx`(DefaultButtonActions F7/F8/F9 `false` · `PERMISSION_BUTTON_CODE` 중앙 게이트 · `singleDivisionOf(searchParam)`) · `useTabBtnPermissions.ts`(`divisionId`) · 화면 9개(Bod/DemandGroupMaster/IntegrationPsi = `hasButton('INSERT'/'DELETE')` 코드별 게이트 · InventoryRaw/ShipmentChangeRequestConfirm/LongTermStock/MasterValidation/PlanControl/WaterfallShipmentPlanSemi = NO-OP `() => undefined` → `false`) — 실경로 | Vite HMR | 배포 |

**검증**: `Doc/e2e/specs/SCP0007.auth.spec.ts`/`authcrud` (기대 = `Doc/tobefacts/db/btn_auth.csv` 재추출 — jaeuk.shin INSERT/DELETE/SAVE/SEARCH · dodae SEARCH) · `check.js B08` 양방향(AS-IS NO-OP 인데 핸들러 노출 = 위반).
**룰 문서**: `Doc/_rules_v2/hooks/subtitle-button-actions-mandatory.md §1.0` · `menu-button-dynamic-fetch.md §1.1` · `tools/VibeManager/rules/10_RULES_KEEP.md F6` · `tools/Harness/rules/confirmed_requirements.csv CR-070`.
**미해결(보고)**: `shipment-change-request-confirm.constants.ts`·`waterfall-shipment-plan-semi.constants.ts` 의 MS1(AS-IS MSG00109 ID 그대로 — TO-BE 같은 문구 없음, MSG01001+ 신규 등록 필요)은 이 작업 이전부터 있던 위반이라 이 패키지 범위 밖.
