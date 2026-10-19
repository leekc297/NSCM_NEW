# PKG_DMF0003 / PKG_DMF0021 — 저장 Validation 메시지 '_' 길이맞춤 제거 (2026-09-22, 사내 ZIOUI1 적용 완료)

DMF0082 동일 작업(`../DMF0082_MSG_UNDERSCORE_20260922/`)을 두 패키지에 적용. `라벨_____ : 값` → `라벨 : 값`.

## 새로고침 (타 작업자 수정분 보존)
1. 착수 시 사내오라클(zioui1 / ol9-db)에서 SPEC·BODY 최신 원문 재조회 → `00_backup/` (머리 SOURCE-FRESH 스탬프)
   - PKG_DMF0003 BODY LAST_DDL 2026-09-22 11:28:04 / PKG_DMF0021 BODY 2026-09-22 13:09:31
2. 적용 직전 FRESH-GATE — LAST_DDL + 원문 전체가 기준본과 동일할 때만 적용 (둘 다 통과)

## 전수 검색 (SPEC+BODY: `__` / `RPAD|LPAD(` / `'_'`)
| PKG | 대상 (수정) | 비대상 (유지) |
|---|---|---|
| PKG_DMF0003 BODY | 2블록 18줄 — L10989~11002 (End Customer/Project 분기, Sales site, Model, Customs Handbook, Fcst Type, Incoterms, Plant Site, YYYYMMDD) · L14952~14968 (동일 9라벨) | L2475 `/*__INTO_V_ERR_MSG__*/` 주석 표식 · L5138 `LPAD(..,6,0)` 번호 채움 · L7385/8140 `|| '_' ||` 값 연결(LAST_UPDATED_BY) |
| PKG_DMF0021 BODY | 1블록 9줄 — L3002~3010 (Project Code, Sales site, Model, Customs Handbook, Fcst Type, Incoterms, Plant Site, Cell Prod Site, Week) | L1380/1388/1396 `|| '_' ||` 값 연결(SORT_ORDER_NO) |
| SPEC 2종 | 0건 | — |

블록마다 마커 `[E20260922-MSGUNDERSCORE]` 주석 1줄. 로직 무변경(문자열 리터럴만).

## 파일
- `00_backup/BACKUP_PKG_DMF00{03,21}_{SPEC,BODY}_pre_msgunderscore_20260922.sql` — 적용 직전 원문
- `01_PKG_DMF0003_BODY.sql` · `01_PKG_DMF0021_BODY.sql` — 적용본
- `_new_*.sql` — 작업본

## 적용 결과
| PKG | BODY 상태 | 오류 | 잔존 `[A-Za-z]_{2,} *:` | live = 01 파일 | 새 LAST_DDL |
|---|---|---|---|---|---|
| PKG_DMF0003 | VALID | 0 | 0 | EQUAL | 2026-09-22 14:23:11 |
| PKG_DMF0021 | VALID | 0 | 0 | EQUAL | 2026-09-22 14:23:14 |

SPEC 무변경(VALID). 기준본 대비 diff = 변경 라벨 줄 + 마커 줄뿐.
화면 저장 재현(E2E)은 미실행. 클라우드 미적용.
