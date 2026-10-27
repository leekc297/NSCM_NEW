# APPLIED_OPERATIONS — [E20261021-DMF0020SAVECLOB] 사내 ZIOUI1 (2026-10-21)

| 시각 | 작업 | SQL 파일 | 결과 |
|---|---|---|---|
| 19:20 | 수정 전 원문 백업 (SPEC LAST_DDL 10-09 13:38:30 · BODY 10-13 18:20:09) | `00_BACKUP_ASIS/PKG_DMF0020_{SPEC,BODY}.PRE_SAVECLOB.sql` · `SCM_ADM_PROC_M.PRE_SAVECLOB.txt` | md5 spec aa1485… body 8eb920… |
| 19:25 | 1차 패치(28마커) 리허설 적용→원복→재적용 | `_deploy_packages/DMF0020_SAVECLOB_CLOUD_20261021/A_DB/10·99` (1차본) | VALID |
| 20:11 | 1차 패치 원복 (2차 패치로 교체 목적) | 99 (1차본) | 수정 전 원문 md5 일치 |
| 20:11~20:12 | **2차 패치(44마커) 리허설 00→10→90→99→00→10→90 · 최종 적용** | `A_DB/00_PRECHECK_CLOUD.sql` · `10_APPLY_SAVECLOB_PATCH.sql` · `90_VERIFY.sql` · `99_ROLLBACK_SAVECLOB_PATCH.sql` | SPEC/BODY VALID · 오류 0 · 의존 4객체 VALID · PROC_M 33행 CLOB |
| (10 내부) | 의존 재컴파일 DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL/POPUP(PROCEDURE) · PKG_DMF0000 · PKG_DMF0082 BODY | 10 의 recompile_dependents | VALID |
| (10 내부) | `UPDATE SCM_ADM_PROC_M SET DATA_TP_CD='CLOB'` 두 PROC_NM IN 33행 | 10 | 33행 · COMMIT |
| 20:17~20:24 | 실제 저장 시험 (격리 82 키 · 원장/이력 삽입 후 삭제 · COMMIT) | `e2e_scale_save.py` · `e2e_scale_save_popup.py` | 원장·이력 잔존 0 |

## 작업 ↔ 파일 대조표
| 작업 | 클라우드 패키지 파일 |
|---|---|
| PKG_DMF0020 SPEC/BODY 패치 + PROC_M CLOB + 의존 재컴파일 | `A_DB/10_APPLY_SAVECLOB_PATCH.sql` (한 파일에 전부) |
| 원복 | `A_DB/99_ROLLBACK_SAVECLOB_PATCH.sql` |
| 시험 행 삽입·삭제 | 이관 대상 아님 (사내 시험 전용) |

## 시험 스크립트
- `test_saveclob.py` (pre / pre-t4b / post) · `equiv_setbased.py` (A5~A8 동치) · `equiv_all_indb.py` (_ALL 동치, DB 내 CLOB 호출) · `e2e_scale_save.py` · `e2e_scale_save_popup.py` · `_test_out/` 로그·스냅샷
- python-oracledb thin 의 CLOB/큰 문자열 바인드는 이 DB 에서 ORA-03120/03138(연결 끊김) → 대량 시험은 DB 안 익명 블록에서 CLOB 조립·호출로 수행.
