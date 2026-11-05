# SCP0111 메타 보완 — 클라우드 이관 (2026-10-29)

원천 = 사내 ZIOUI1 2026-10-29 12:10:15 적용분 (`_artifacts/_apply_corporate/SCP0111_META_20261029/APPLIED_OPERATIONS.md`)

## 실행
`01_SCP0111_META_CLOUD.sql` 전체 F5 1회. 재실행 안전(MERGE NOT MATCHED / INSERT NOT EXISTS — 기존 행 미변경).
- [0] PRECHECK 실패 시 중단: `-20001` PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE 없음 → PKG 선이관 / `-20002` MSG01477·78 이 다른 용도로 선점 → 재채번 요청
- [5] VERIFY 기대값: BTN_MPG 1 · API_M 1 · PROC_M 2 · MSG_M 6

## 내용
| 테이블 | 키 | 비고 |
|---|---|---|
| SCM_ADM_API_M | SCP0111_essPackLine_SEARCH | 사내 기등록(2026-09-23) — 클라우드 부재 대비 |
| SCM_ADM_PROC_M | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE × (o_rc1 100, O_RESULT_CURSOR 101) | 사내 기등록 — 클라우드 부재 대비 |
| SCM_ADM_MNU_BTN_MPG_M | (SCP0111, essPackLine, SEARCH) | 신규 |
| SCM_ADM_MSG_M | MSG01477, MSG01478 × KO/EN/CN | 신규 채번 |

## FE 동반 (화면 반영에 필요 — 본 SQL 만으로는 화면 변화 없음)
FE 반영 전에는 기존 동작 그대로다(신규 시트·코드를 아직 아무도 호출하지 않음). FE 변경 가이드는 작업 보고서 참조.
