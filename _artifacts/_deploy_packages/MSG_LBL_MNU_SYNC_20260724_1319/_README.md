# MSG_LBL_MNU_SYNC_20260724_1319 — 메시지/라벨/메뉴 명칭 메타 클라우드 동기 (INSERT-only)

> 배경: 감사 `_deploy_packages/_AUDIT_MSG_LBL_MNU_20260724` — 사내 작업 등록 393 ID 중
> **323 ID(82%)가 어떤 이관 패키지에도 미포함** (LBL 188/189·MNU 13/13 전멸, MSG 114, API 8).
> 본 패키지가 4분류(MSG/LBL/MNU/API) 전수를 일괄 해소.

## ⭐ 원칙 (사용자 확정 2026-07-24)

**클라우드 기존재 row 는 수정/삭제하지 않는다.**
- 전 문장 = `INSERT ... FROM DUAL WHERE NOT EXISTS` (PK: MSG_ID + LANG_CD). **UPDATE/DELETE 0건.**
- 기존재 row 는 문구가 사내와 달라도 그대로 유지(skip) — 차이 확인은 90_VERIFY [2] 참고 수준.
- 재실행 멱등 — 몇 번을 실행해도 미존재분만 채움.

## 구성 / 적용 순서

| Step | 파일 | 내용 |
|---:|---|---|
| 1 | `sql/01_msg_lbl_mnu_insert_only.sql` | INSERT-only 1,103문 + COMMIT (393 ID × 언어 KO/EN/CN — 사내 원본 값·감사컬럼 그대로 보존) |
| 2 | `90_DIAGNOSE/90_VERIFY.sql` | [1] 393 ID 전수 존재 확인(기대 0행) [2] 타입별 카운트 [3] 재실행 멱등성 |
| - | `manifest.csv` | 포함 전수 목록 (MSG_ID / LANG_CD / 타입 / 문구 60자) |

## 대상 산정 기준 (실측 — 추측 0)

- 사내 OCGSCMD_P01 `SCM_ADM_MSG_M` 에서 `CREATED_BY IN ('admin','minyonglee1')` 인 **393 ID**
  (TO-BE 작업 등록분)의 **전체 언어 row 1,103건** (해당 ID 의 타 계정 언어 row 포함 — 언어셋 완결).
- row 분포: LBL 567 / MSG 460 / MNU 39 / API 37.
- DDL 5층 실측: PK(MSG_ID, LANG_CD) / NOT NULL = MSG_ID·LANG_CD·MSG_TP_CD·USE_YN·감사4 /
  MSG_NM·MSG_DESC nullable. 문구 내 개행은 `||CHR(10)||` 분해, 따옴표 `''` 이스케이프.

## 검증 완료 (사내 dry-run)

- 사내 DB 에 전문 실행 실측: **1,104문 전부 OK / 오류 0 / 행수 2,148 → 2,148 불변**
  (전건 기존재 → NOT EXISTS skip) — 문법·이스케이프·멱등성 전수 검증 완료.

## 미포함 / 한계

| 항목 | 사유 |
|---|---|
| 기존재 row 문구 차이 보정(UPDATE) | **원칙상 제외 (사용자 확정 — 기존재 무수정)**. 사내↔클라우드 문구 diff 가 필요하면 별도 감사로 목록화만 |
| seed row 문구 정정분 (CREATED_BY=SYSTEM 등, 수정만 우리 계정) | INSERT-only 원칙상 대상 아님 — 2차 감사 후 사용자 결정 |
| FE locale json (public/locales) | 이관 대상 제외 (사용자 확정 2026-07-24) |
| `SCM_ADM_MNU_M` (메뉴 트리 row 자체) | 별개 테이블 — 화면별 패키지 `01_menu_api_button.sql` 이 담당 (본 패키지는 명칭 라벨 MNU_* 만) |
