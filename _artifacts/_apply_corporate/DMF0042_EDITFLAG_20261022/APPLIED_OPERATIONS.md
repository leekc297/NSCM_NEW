# DMF0042 편집 불가(노란 셀 0) — 개인 컬럼 설정 사용자 EDIT_FLAG 누락 (사내 ZIOUI1 적용 기록)

- 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA` 컬럼 목록 '개인 설정 있음' 분기 (L2740)
- 마커: `[E20261022-EDITFLAG]` 1곳 · 접속: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost)
- 기준본: DB 재조회 LAST_DDL **2026-10-19 16:04:36** (VALID) → 적용 10:32:23 (FRESH-GATE 통과)
  → 클라우드 패키지 리허설로 원복·재적용, 최종 LAST_DDL **2026-10-22 10:38:06** (md5 `f22daded…` = 적용본)

## 증상·원인
| 항목 | 실측 |
|---|---|
| 증상 | 클라우드 minyonglee1 / 40 / 2026-10-01~2027-04-30 조회 — 노란 셀 0, 편집 불가 |
| 권한 경로 | 그룹 ADMIN · GET_ADMIN_GROUP ALL · CMBO BizPlanUserAuthGroup · PROC_M 18행 · payload `userGroup=ADMIN` 모두 정상(클라우드 사용자 확인) |
| SP 직접 호출 (수정 전) | 72행 · **결과 컬럼에 EDIT_FLAG 없음** → FE editLock R1(`EDIT_FLAG==='Y'`) 전행 잠금 |
| 메타 | SHEET_COLUMNS 'Biz Plan' EDIT_FLAG = VISIBLE_FLAG 'N' · **DEFAULT_FLAG 'N'** · VALID_YN 'Y' (10-19 F-19 빈 값 일괄 'N') |
| SP 분기 | 개인 설정 없음(L2709) = 10-19 KBJ `NVL(RTRIM(...),'N')='N'` 대응 / **개인 설정 있음(L2740) = `RTRIM(...) IS NULL` 미대응** → 'N' 숨은 고정 칸 제외 |
| 영향 | DMF0042 'Biz Plan' 개인 컬럼 설정 보유 사용자 11명 전원 (minyonglee1 9행 보유) |

## 변경 (1줄 + 원래 줄 주석)
`AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL` → `--` 주석 보존 + `AND NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'` (기본 분기와 같은 판정). 메타·데이터·FE·BE 무변경.
- 개인 설정 분기에 새로 들어오는 칸 = VISIBLE_FLAG 'N' · DEFAULT_FLAG 'N' · VALID_YN 'Y' 인 **EDIT_FLAG 1개뿐** (REPORT_GROUP5 는 VALID_YN 'N').

## 검증 (SP 직접 호출 — 조회 전용)
| 항목 | 결과 |
|---|---|
| 컴파일 | VALID · ALL_ERRORS 0 · DMF0042 관련 INVALID 0 |
| minyonglee1 / ADMIN / 40 / 20261001~20270430 | 72행(수정 전과 동일) · **EDIT_FLAG 'Y' 72행** · 커서2 VALID_YN Y 202701~202707 |
| admin(개인 설정 없음 — 기본 분기, 회귀) | 1,434행 · EDIT_FLAG 'Y' 전행 |
| 클라우드 패키지 리허설 | 90→99→00→10→10(SKIP)→90→99→99(SKIP)→10→90 기대대로 · 99 후 md5 = 수정 전 · 10 후 md5 = 적용본 · 10/99 SKIP 사본 선컴파일 OK |
- ⚠ 화면 런타임(노란 셀 표시·편집) 미검증 — 사용자 확인 필요.

## 동일 패턴 잔존 (미수정 — 별도 확인 대상)
`RTRIM(<x>.DEFAULT_FLAG, ' -') IS NULL` 활성 줄: PKG_DMF0022 L150·344·2839·2899 / PKG_DMF0035 L2996·3061·4042·4201 / PKG_DMF0051 L175·372·525·1471·1509.

## 파일
- `apply.py`(plan/apply · FRESH-GATE · 실패 시 자동 복원) · `00_BACKUP_PKG_DMF0042_BODY_2026-10-19_1604.sql` · `_new_PKG_DMF0042_BODY.txt`
- 클라우드: `_artifacts/_deploy_packages/DMF0042_EDITFLAG_TITLESET_CLOUD_20261022/`
