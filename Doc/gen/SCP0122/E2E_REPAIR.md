# SCP0122 E2E 수선 기록

## 수선 1 — authcrud — 2026-10-22 15:38

- 실패 원천: `Doc/e2e/logs/run_20261022_150804_authcrud.log` · `_summary.csv` "SCP0122","authcrud" FAIL 행 · 스크린샷 `artifacts/SCP0122.authcrud-…-chromium/test-failed-1.png`
- 실패 계정: jaeuk.shin (ADMIN 외 11 그룹, expected=SAVE|EDIT|SEARCH|INSERT|DELETE). hongjae.kim(메뉴 권한 N) = PASS
- 어노테이션: `crud: mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=Y found=N updated=N cleaned=Y restored=Y saveCalls=0`

### 실패 항목 1 — `[jaeuk.shin] 재조회 후 신규 행 존재` (found=N)

**판정: (c) E2E 기대값 결함 의심**

근거
1. 마커 입력 위치 — `SCP0122.plan.json` 에 `keyColumns` 가 없음(null) → `crudCycle` insert 모드가 `targetCol = 0` 에 마커 `E2E_xxx` 를 입력. 신규행 col 0 은 Div./Process(INPUT_TP_CD='S', 읽기전용)라 입력이 들어가지 않는다(스크린샷: 신규행 Process·Plan Group 은 조회조건 기본값, Act. Seq/Activity Name 공란).
2. 이 화면 신규행에서 편집 가능한 셀은 2개뿐이고 둘 다 자유 텍스트 마커를 받을 수 없다.
   - 메타 `Doc/tobefacts/db/sheet_columns.csv` (SCP0122 / Plan Activity Mgmt): `OPMZ_ACTV_SEQ` INPUT_TP_CD=M(숫자 순번) · `OPMZ_ACTV_NAME` INPUT_TP_CD=M, `FPComboBox`(Activity 마스터 코드 콤보) · 나머지 13컬럼 S.
   - AS-IS `GSCM\06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs:381-383` — 신규행 `DIVISION_ID~OPMZ_PLAN_GR_NAME`, `OPMZ_ACTV_CD`, `LINK_UI_TYPE~OPTION_YN` LockRange(true).
   - 저장 키 = PRS_CD+PLAN_GR_ID+ACTV_CD(마스터 코드) — 마커 문자열을 가진 행은 원천적으로 만들 수 없다.
3. Save 시 call-proc 0건(saveCalls=0)은 화면이 AS-IS 와 같이 동작한 결과다.
   - FE `nscm-fe/features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx:156-165` + `utils/plan-activity-mgmt.util.ts:38-45 isUnchangedRow` — ACTV_CD·ACTV_SEQ 가 PRE_* 와 같으면(신규행 공란=공란) 저장 대상 제외 → "변경 없음" 토스트, 호출 없음.
   - AS-IS `SCP0122_PlanActivityMgmt.cs:428-430` `if (action != FlagD && actv_cd == pre_actv_cd && actv_seq == pre_actv_seq) continue;` — 동일.
4. 부수 관찰(생성기 헬퍼) — `tools/E2E/lib/crud.ts` insert 모드의 `out.saved` 는 `s1.calls.every(<400)` 만 보고 `calls.length > 0` 을 요구하지 않아 call-proc 0건인데 saved=Y 로 기록됨(edit-save 모드는 `calls.length > 0` 요구). 이번 실패의 원인은 아니나 판정을 오도한다.

처리: 수정 없음(FE·DB·메타 모두 AS-IS 파리티 · 결함 미발견). `Doc/e2e/_expectation_issues.md` 에 생성기 보정 제안 등록.
- 참고: 같은 원인으로 crud 단계(`"SCP0122","crud"` FAIL, found=N·cleaned=N·타임아웃)도 실패 중 — 동일 (c) 범주.
- 미검증(정직 보고): 이번 실패에서는 SAVE call-proc 이 한 번도 발사되지 않아 `PKG_SCP0122.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT` 의 런타임 저장 경로는 E2E 로 검증되지 않았다(PASS 아님 · 미실행).
- FE 미수정 → check.js 미실행. DB 미수정 → 적용 SQL 없음. `__asis-mapping__.md` 변경 대상 행 없음.

판정요약: a=0 b=0 c=1

### 독립 판정 — 2026-10-26 15:49 (e2e-judge · 새 세션 · 읽기 전용)

결과: 판정 완료 · 화면 0 · DB 0 · 기대값 1(근거 확인 1) · 판정 불가 0 · 수선 세션 주장 a=0 b=0 c=1

| 항목 | 판정 | 근거 등급 | 실패 목록 | 근거 확인 | 사유 |
|---|---|---|---|---|---|
| [jaeuk.shin] 재조회 후 신규 행 존재 | expectation | hard | ✔ | ✔ 확인 tools\E2E\lib\crud.ts:105<br>✔ 확인 tools\E2E\lib\crud.ts:116<br>✔ 확인 tools\E2E\lib\crud.ts:123<br>✔ 확인 Doc\e2e\specs\SCP0122.authcrud.spec.ts:34<br>✔ 확인 GSCM\06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs:381<br>✔ 확인 GSCM\06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.cs:429<br>✔ 확인 nscm-fe\features\supply\src\pages\plan-activity-mgmt\PlanActivityMgmt.tsx:145 | plan.json 에 keyColumns 가 없어서 crudCycle insert 모드가 마커를 0번 열(Division~Plan Group 범위)에 넣습니다. 이 범위는 AS-IS 에서 신규 행일 때 잠기는 범위라 마커가 들어가지 않고, 마커가 없는 행은 재조회에서 찾을 수 없습니다. |

결과 봉투: Doc/gen/SCP0122/E2E_REPAIR.result.json · 기대값 보정 허용 = 근거 확인된 항목(1)만
