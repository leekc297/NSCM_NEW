# DMF0082 조회 ORA-00904 "SORT_KEY" — 컬럼 메타 시스템 컬럼 DEFAULT_FLAG 복원 (클라우드)

| 항목 | 값 |
|---|---|
| 증상 (클라우드 QA 10-12 18:33~) | DMF0082 조회 시 SQL ERROR — `ORA-00904: "SORT_KEY"` (PKG_DMF0082 결과 커서 OPEN). 사용자·조회조건 무관 전원 발생. 17:31 까지는 정상 |
| 원인 | 조회 SP 는 출력 컬럼 목록에 "컬럼 메타에서 `DEFAULT_FLAG` 가 빈 값인 컬럼"(SORT_KEY·EDIT_FLAG·GROUP_ID 등 시스템 컬럼)을 더한다. 클라우드 메타의 이 10개가 전부 `'N'` 으로 바뀌어 있어 하나도 안 잡힘 → 정렬절의 SORT_KEY 가 출력 목록에 없음 (V08 [K3] FAIL) |
| MANDCOL 패치와의 관계 | 무관. 패치는 숨김 판정만 바꾸고 출력 컬럼 목록·메타는 건드리지 않는다. 사내에서 메타 10행만 `'N'` 으로 바꾸면 같은 줄에서 같은 오류가 재현되고, 되돌리면 정상 (리허설) |
| 누가 바꿨나 | **미확인.** 메타 행의 수정 시각 컬럼이 갱신되지 않았다(08-07 그대로). 00 파일 끝의 선택 조회(이력 조회)로 추적 가능할 수 있음 |
| 조치 | 10개 컬럼 중 지금 값이 `'N'` 인 행만 공백 1칸으로 복원. SP·다른 컬럼·다른 화면 무변경 |
| 사내 | 변경 없음 (사내 메타는 원래 공백). 리허설로 `'N'` → 복원 왕복만 수행해 10행의 수정자/수정 시각이 admin · 10-12 18:49 로 바뀜 |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | P1 10행 `복원 대상` · P2 SP 가 쓰는 센티널 줄 `FAIL` |
| 2 | [A_DB/10_APPLY_SYSCOL_DEFFLAG.sql](A_DB/10_APPLY_SYSCOL_DEFFLAG.sql) | `APPLIED — 10행을 공백으로 복원 · COMMIT` (이미 정상이면 `SKIP`) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 10행 `정상 (빈 값)` · V2 `PASS` · V3 `OK … SORT_KEY 포함 Y` |

원복: [A_DB/99_ROLLBACK_SYSCOL_DEFFLAG.sql](A_DB/99_ROLLBACK_SYSCOL_DEFFLAG.sql) — 실행하면 조회 오류 상태로 되돌아간다.

## 주의
- P1 에 `확인 필요` 가 있거나 10행이 아니면 10 을 실행하지 말고 결과 회신.
- DEV 등 다른 클라우드 DB 도 같은 상태일 수 있다 — 00 으로 먼저 확인.
- 같은 메타 구조(DEFAULT_FLAG 빈 값 = 시스템 컬럼)를 쓰는 다른 화면이 함께 바뀌었는지는 확인하지 않았다.

## 리허설 (사내 ZIOUI1 2026-10-12 18:49, `_rehearsal_out/`)
00(PASS · 공백 10) → 10(`SKIP`) → 99(10행 `'N'`) → 90(V2 FAIL · V3 `ORA-00904 "SORT_KEY"` line 4741 = 클라우드 오류 재현) → 10(`APPLIED — 10행`) → 90(V1 정상 · V2 PASS · V3 OK 2,158행 · SORT_KEY 포함 Y) → 00(PASS · 공백 10).
