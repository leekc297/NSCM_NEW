# GAP467 SYS0014 그룹 원장 — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- AS-IS 대조: LGCE_SCMDEV `TB_FX_GroupInfo`/`TB_FX_UserGroupInfo` 직접 조회 + TO-BE 이관 사본 `TB_FX_GROUPINFO`/`TB_FX_USERGROUPINFO`(GAP 수치 원천, 실측 일치)
- 사용자 결정(2026-10-15): Guest 변경 없음 · '-' 원래 값 유지(1차 '/' 결정 → 사본 근거 제시 후 '-' 로 교체) · CAPA Planner Y(1차 N → 사본 근거로 Y) · SSP ADMIN 추가 · 사용자 매핑 255행 이관
- 참고: 같은 날 14:36 타 작업자 백업 테이블 `*_BAK20261015_SYS0014_1` 4개 존재(내 작업 아님 · 무변경)

| # | 시각 | 작업 | 결과 |
|---|---|---|---|
| 1 | 20:27:57 | 1차 적용(4그룹: CAPA N · System Monitor · SSP ADMIN · '/') + 리허설 | 그룹 4 추가 |
| 2 | 20:49 | 1차 적용분 제거 `00_undo_first_apply.py` ('/' 참조 0 확인 후) | 4행 삭제 |
| 3 | 20:49:28~ | 최종 패키지 리허설 00→10→10→90→99→99→10→90 (`_deploy_packages/SYS0014_GAP467_GROUPMST_CLOUD_20261015/_rehearsal_out/`) | 그룹 4 · 매핑 255(− 34 · CAPA 220 · SysMon 1) · 재실행 0 · 원복 255/4 |
| 4 | 20:49:53 | 화면 SP 스모크 `smoke.py` → `smoke_AFTER.out.txt` | 그룹 23 · 사용자 220/1/34 · 권한 조회 정상 |

현재 상태 = 최종 적용. 원복 = 패키지 `A_DB/99_ROLLBACK_GAP467_GROUP_M.sql`.
