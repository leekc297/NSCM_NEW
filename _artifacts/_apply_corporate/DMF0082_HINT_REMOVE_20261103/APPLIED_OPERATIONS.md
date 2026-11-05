# DMF0082_HINT_REMOVE_20261103 — 사내 ZIOUI1 힌트 제거 기록

- 요청(2026-11-03): 11-02 적용한 `P_DMF0082_GET_MAIN_DATA` 힌트가 속도 저하로 제외 결정됐으나 사내에 남아 있음 → 어제 추가한 힌트만 제거.
- 접속: ZIOUI1 · SERVER_HOST=localhost · SESSION_USER=SYSTEM · CURRENT_SCHEMA=SCM_MGR
- 치환 쌍: `_deploy_packages/DMF0082_HINT_CLOUD_20261102/A_DB/99_ROLLBACK_HINT_PATCH.sql` 의 7곳(H1~H5, H6a, H6b) `c_new → c_anc`. 그 스크립트는 USER_SOURCE 기준이라 SYSTEM 접속에서는 대상을 못 찾으므로 `remove_hint.py` 로 ALL_SOURCE(SCM_MGR) 에 같은 치환을 적용.
- 보존: 13:44:43 반영된 POJ "Biz Type 미입력 저장 차단 문구 변경"(차이 7줄, `_diff_vs_1027_original.txt`). 제거본과 10-27 원본의 차이는 이것뿐.

| 시각 | 작업 | 결과 |
|---|---|---|
| 14:20:37 | 현재 상태 조회 | BODY VALID · LAST_DDL 13:44:43 · 마커 6 |
| 14:26:22 | `remove_hint.py check` | 7곳 각 1건 매칭 · 제거본 마커 0 |
| 14:26:56 | `remove_hint.py apply` (FRESH-GATE PASS) | BODY VALID · 오류 0 · 적용본 == DB 원문 · 마커 0 · 스키마 INVALID 85→85 |

- 백업(제거 직전 원문): `00_BACKUP_BEFORE_REMOVE.sql` / 적용본: `01_PKG_DMF0082_BODY_HINT_REMOVED.sql` / 결과: `_apply_result.json`
- 클라우드: 힌트 미적용 상태였으므로 조치 없음. 도크오라클: 힌트 적용 이력 없음.
