# DMF0082 화면 저장 — 대용량 한도 해제 + 저장 본체 트랜잭션 원자화 `[E20260929-DMF0082SAVETXN]`

- 대상 DB: 사내 ZIOUI1 (SCM_MGR) · 적용: 2026-09-29 20:54:14 (PKG_DMF0082 SPEC/BODY LAST_DDL)
- 착수 기준본 LAST_DDL: SPEC 2026-09-15 18:58:28 / BODY 2026-09-23 23:38:52 (ALL_SOURCE 새로 조회 · FRESH-GATE 통과)
- 클라우드: **미적용**

## 점검 결과 (사내 실측)
| # | 항목 | 결과 |
|---|---|---|
| 1 | FE→BE→SP 전달 | 분할 없이 1회 호출 (`^` bulk 17개 파라미터) |
| 2 | 크기 한도 | SP IN 이 VARCHAR2 → 32,767B 초과 시 저장 전체 실패 (32,768B = ORA-06502, 3,001행 = 바인드 실패) |
| 3 | 암묵 COMMIT | PRESERVE ROWS GTT 대상 `DBMS_STATS.GATHER/SET/DELETE_TABLE_STATS`, GTT `TRUNCATE` 모두 커밋 (LOCAL_TRANSACTION_ID 소멸 실측) |
| 4 | 부분저장 창 | 40 경로: RTF_SYS_RP DELETE/INSERT(L13355) 후 GATHER(L13981) 에서 확정 → 이후 판가·수요 런타임 오류 시 RTF_SYS_RP 만 남음 |

## 변경
| 코드 | 내용 |
|---|---|
| S1 | SPEC `P_DMF0082_SAVE_MAIN_DATA` IN 17종 VARCHAR2 → CLOB |
| B1 | BODY 동일 17종 → CLOB |
| B2 | 로그용 `SUBSTR(p,1,50)` → `DBMS_LOB.SUBSTR(p,50,1)` |
| B3 | 첫 영구 DML 이후 GATHER 3건 → `NULL; --[TAG] ...` (GT_PRDM1_TEMP_EXCH 1, GT_PRDM1_T_MAIN 2) |
| B4 | GTT 초기화 직후(영구 DML 이전) `DELETE_TABLE_STATS(GT_PRDM1_TEMP_EXCH)` — 세션 잔존 통계 제거, dynamic_sampling=2 위임 |
| B5 | 40 경로 전파 PR 호출 직전 명시 `COMMIT` — 저장 본체(RTF_SYS_RP·판가·수요·_H) 원자 확정 경계 |
| B6 | 헤더 이력 1행 |
| M1 | `SCM_ADM_PROC_M` SAVE IN 17행 DATA_TP_CD VARCHAR → CLOB |

### 남은 한계 (미수정 — 사용자 결정 필요)
40 경로 2단계(CFM→MKT_FCST 전파 `P_PR_DM_PLN_CFM_TO_MKT_FCST` → 공용 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`)는
공용 PR 내부 DBMS_STATS 26회(대형 영구 테이블 `DM_PLN_MKT_FCST` 포함, 배치 JOB 공유)가 커밋하므로 원자 불가.
2단계 실패 시 본체는 저장된 상태로 오류 메시지가 표시된다 (종전과 동일 — 종전에도 전파 PR 첫 TRUNCATE 에서 확정).

## 파일 ↔ 작업 대조
| 파일 | 작업 |
|---|---|
| `00_BACKUP_ASIS/PKG_DMF0082_{SPEC,BODY}.PRE_SAVETXN.sql` | 원복본 (착수 시 DB 조회본) |
| `00_BACKUP_ASIS/SCM_ADM_PROC_M.PRE_SAVETXN.txt` | PROC_M 18행 착수 시 값 |
| `01_APPLY/PKG_DMF0082_{SPEC,BODY}.SAVETXN.sql` | 적용본 (SOURCE-FRESH 스탬프) — 적용 순서 SPEC → BODY |
| `01_APPLY/02_SCM_ADM_PROC_M.SAVETXN.sql` | PROC_M 17행 CLOB (멱등) |
| `99_RESTORE_SCM_ADM_PROC_M.sql` | PROC_M 원복 |
| `apply_savetxn.py` | `backup` / `apply`(FRESH-GATE) / `restore` |
| `test_savetxn.py` | `big N`(32K 초과 → V81-00 'F' 종료, 무변경) / `replay`(LOC 판가 1건 현재값 재저장) |

## 검증
| 항목 | 결과 |
|---|---|
| 컴파일 | SPEC/BODY VALID · ALL_ERRORS 0 · 적용본==DB 원문 |
| 적용 전 기준선 `big 3000` | 실패 (ORA-03120, 바인드 단계) |
| 정적: 첫 영구 DML(L13361) ~ 1단계 COMMIT(L14874) 커밋 요인 | 0건 |
| 파싱 부하 (CLOB 루프 벤치, GTT) | 1,000행 0.3s / 3,000행 0.9s / 6,000행 2.4s |
| `big` / `replay` 실행 (적용 후) | **미실행** — 자동 모드 권한 차단, 사용자 실행 필요 |
| BE HTTP 경유 E2E | 미실행 |
