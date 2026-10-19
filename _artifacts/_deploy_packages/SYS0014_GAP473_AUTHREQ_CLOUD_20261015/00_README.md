# SYS0014_GAP473_AUTHREQ_CLOUD_20261015 — 그룹 사용자·사업부 권한 삭제 시 권한 요청 기록도 삭제 (클라우드 패치, DB 만)

- 마커: `[GAP473 2026-10-15]` 2곳
- 대상: `SCM_MGR.PKG_SYS0014` PACKAGE BODY → `P_SYS0014_SAVE_GROUP_USER_M` 안 DELETE 2문장 삽입
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- **FE·BE 무변경 · BE 재기동 불필요.** 메타 · 권한 · 기존 원장 데이터 무변경.

## 무엇이 바뀌나
| 동작 (SYS0014 Group User 저장) | AS-IS (LGCE_SCMDEV) | TO-BE 현재 | 패치 후 |
|---|---|---|---|
| UserInfo 행 삭제 (사용자를 그룹에서 뺌) | `UP_FX_DeleteUserGroupInfo` — 매핑·사업부 권한 + **`SCM_MST_AUTH_REQUEST` (GROUP_ID, USER_ID)** 삭제 | 매핑·사업부 권한만 삭제 → 요청 기록 잔존 | 요청 기록도 삭제 |
| Division 행 삭제 (사업부 권한 지움) | `UP_FX_DeleteUserGroupAuthExtention` — 권한 + **요청 (GROUP_ID, USER_ID, DIVISION_ID=PrntCode, PLANT_ID=Code)**, AuthType 'D' 면 **요청 (GROUP_ID, USER_ID, DIVISION_ID=Code)** 삭제 | 권한만 삭제 → 요청 기록 잔존 | 요청 기록도 삭제 (UNIT_TP_CD=AuthType · UNIT_ID=Code · UPPR_UNIT_ID=PrntCode) |
| GroupInfo 행 삭제 (그룹 자체) | `UP_FX_DeleteGroupInfo`(별도 화면) — 요청 기록 삭제 없음 | 요청 기록 삭제 없음 | **변경 없음** (AS-IS 동일) |

- 이미 남아 있는 요청 기록(매핑 없는 기록)은 이 패치가 지우지 않는다. 사내 기준 25,349행 중 4,411행. 정리가 필요하면 별도 결정.

## 검증 (2026-10-15, 사내 ZIOUI1 59.19.252.148, SERVER_HOST=localhost)
- 착수 원문: PKG_SYS0014 BODY LAST_DDL 2026-10-09 13:38:47 (ALL_SOURCE 새로 조회). 사내 적용 21:13:24 → 리허설 후 최종 LAST_DDL 21:18:18, DB 원문 == 적용본.
- E2E (저장 SP 를 FE 페이로드 형태로 직접 호출, 원장에 없는 시험 사용자 `ZZ_GAP473_T1` · 그룹 `DM Planner`, 끝나고 시험 행 전부 삭제):
  | 단계 | 적용 전 | 적용 후 |
  |---|---|---|
  | Division 81 삭제 | 요청 81·82 남음 | 요청 82만 남음 |
  | UserInfo 삭제 | 요청 81·82 남음 | 요청 0 |
  | 시험 키 외 행수 (요청/매핑/권한) | 25,349 / 13,113 / 25,013 불변 | 25,349 / 13,113 / 25,013 불변 |
- 생성기 DRY-RUN: 10 적용 == 적용본 · 10 재실행 SKIP · 99 원복 == 수정 전 · 99 재실행 SKIP.
- 사내 리허설 99→00→10→10→90→99→99→10→90 전부 기대대로 (`_rehearsal_out/`, `_rehearsal_console.txt`).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS 2행 · L2 4행 · L3 마커 0 · L5 0행 (L4 는 숫자만 회신) | L1 FAIL 이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP473_PATCH.sql` | `APPLIED — PKG_SYS0014 BODY VALID · 마커 2곳` | `중단 — …` 이면 원문은 바뀌지 않음. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 2 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 2 PASS | 회신 |
| 4 | 화면 SYS0014 | 요청 기록이 있는 사용자의 사업부 권한 또는 그룹 매핑 삭제 → 저장 → `SCM_MST_AUTH_REQUEST` 에서 해당 행 사라짐 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP473_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터 · DRY-RUN, 문구는 사내 적용기 `_apply_corporate/SYS0014_GAP473_AUTHREQ_20261015/apply_gap473.py` 와 단일 소스).
- `run_rehearsal.py` · `_rehearsal_out/` · `_rehearsal_console.txt` — 사내 리허설 결과.
- `_md5_corporate.txt` — 사내 수정 전·적용본 md5.
