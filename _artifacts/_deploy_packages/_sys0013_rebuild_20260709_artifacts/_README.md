# SYS0013 Dynamic Query 재개발 이관 패키지 (2026-07-09)

기존 FE 개발분 일괄 삭제 후 신규 재개발 + SP 전면 PKG_SYS0013 통합 (멤버 10 → 15).
기준 스펙 = `Doc/화면설계서/SYS0013_DynamicQuery_상세동작_개발용.md`. 사내 적용 완료 / 클라우드 적용 대기.

## 구성 (실행 순서)

| 순서 | 경로 | 내용 |
|---|---|---|
| 1 | `01_ddl/100_PKG_SYS0013_SPEC.sql` → `200_..._BODY.sql` | PKG v2 — 기존 GET 7 byte-identical / SAVE 3 이력(_H) 보강(D1 승인) / 신규 5 멤버(GET_HISTORY·SAVE_USER_GROUP·DELETE_USER_GROUP·EXECUTE_HIST·VALIDATE_QUERY). `.dbeaver.sql` = 종결자 '/' 없는 판 |
| 2 | `02_meta/300_SYS0013_META_REBUILD.sql` | 멱등 — API_M 2U+2I / PROC_M rename·stale 삭제·**SAVE 3종 data(JVARCHAR)+sesUserId 표준 수렴**·신규 3 SP 행 / BTN_MPG 2 / USER_GR×2 / MSG_M(LBL00761·MSG00655) / CMBO 2종 / SHEET_COLUMNS DQ_ID S |
| 3 | `03_grant/README.md` | GRANT/SYNONYM 불필요 근거 (63번 PKG 단위 GRANT 자동 커버) |
| 4 | `fe/` | dynamic-query 15파일(재개발) + procedures.d.ts(SYS0013 엔트리 — 병합 주의: 기존 파일에 SYS0013 블록만 추가) + locales 3종(참고 — gen:i18n 이 MSG_M 에서 재생성) |
| — | `04_rollback/` | PKG SPEC/BODY 원본(baseline) + 메타 스냅샷(meta_baseline.json) |
| — | `05_verify/verify_db.py` | 스모크 12종 (회귀/신규 멤버/D1 이력/PROC_M 대사 — 부작용 ROLLBACK) |

## ⚠ 원자성 (필수)

**02_meta 의 PROC_M SAVE 3종 변경(pData→data)과 fe/ 배포는 동시 반영** — 구 FE + 신 PROC_M 조합은 저장이 깨진다.
(사내는 2026-07-09 메타+FE 동시 반영 완료. 클라우드는 1→2→fe 순으로 같은 창에서 적용.)

## 미포함 (별도 차수 — D3 결정)

standalone SP 24종(SYS0013_* 14 + PR_DM_ADM_DQ_* 10) DROP — 검증 기간 보존(롤백 안전망), 앱 미참조 확인 후 별도 제출.
FN_DQ_* 4 + TYPE 6 은 영구 유지(동적 SQL 이 이름으로 참조).
