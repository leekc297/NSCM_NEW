# DMF0082_GROUPMEASURE_81_20260901 — 81계열 메저 편집권한 정합

사용자 결정(2026-09-01): **① 추가 / ② 제거**

## 배경
`GET_ADMIN_GROUP_MEASURE` 룩업 = **메저별 편집 권한**(그룹 × 화면 × 사업부 × 메저).
AS-IS 원본은 DMF0082 에 **40 만 15행** 존재했고, 81계열은 이번 작업으로 신규 등재됐다.

## 이 룩업이 실제로 통제하는 메저 (PKG_DMF0082 [E20260820-MEASRULE] 실측)
| 메저 | 판정 방식 | 룩업 의존 |
|---|---|---|
| **MKT_FCST / SCM_FCST** | 이 룩업(+요일·시간창 LIMITMEAS) | **예** |
| VMI_In_Req | 코드 `division IN ('40','82')` (L3614) | 아니오 |
| AS_In_Req | 코드 `81%/82 + DM Planner(W/S)` (L3606) | 아니오 |
| LOC | 항상 개방(SCP Planner 만 코드로 차단 — E20260825-SCPPLOC) | 아니오 |

## 변경 내용
### ① 추가 — `SCM PI Admin × 81계열(6) × MKT_FCST` = 6행
40 에는 있으나 81계열에 없어 **해당 그룹이 81 에서 MKT FCST 를 편집할 수 없던 비대칭** 해소.

### ② 제거 — `DMF0082 × 81계열 × SCM_FCST` = 18행 (ADMIN 6 / SCM PI Admin 6 / SCP Planner 6)
`SCM_FCST` 는 `SCM_MST_SHEET_MEASURE` 상 **DIVISION_ID='40' 전용**이라 81 화면에 메저 자체가 없다 → 무효 행.
(40 의 SCM_FCST 는 유효하므로 **건드리지 않음** — DELETE 는 `SEGMENT3 LIKE '81%'` 한정)

### 대상 아님 — VMI_In_Req
81 추가 불필요. 코드가 `40·82` 로 판정하므로 81 행은 동작하지 않는다(40 의 기존 4행은 AS-IS 유산).

## 적용
1. `01_APPLY.sql` (INSERT 는 NOT EXISTS 가드 · DELETE 는 대상 한정 — **멱등**, 재실행 안전)
2. `02_POSTCHECK.sql` → **P1=6행 · P2=0행** 이 통과 기준 (P3 로 40 무영향 확인)
3. 화면에서 SCM PI Admin 계정 81 조회 → MKT FCST 편집 가능 여부 확인
4. 문제 시 `03_ROLLBACK.sql`

## 상태
- **사내: 적용 완료 (2026-09-01)** — INSERT 6 · DELETE 18 · COMMIT.
  POSTCHECK PASS: P1=6 · P2=0 · P3=15 · 총행 87→75.
  적용 후 81계열 = ADMIN/DM ADMIN/DM Planner/SCM PI Admin(LOC·MKT_FCST) · DM Planner(W/S)/SCP Planner(MKT_FCST) · SCM_FCST 0.
- **클라우드: 미적용** — 본 폴더 `01_APPLY.sql` 그대로 실행 후 `02_POSTCHECK.sql` 확인.
