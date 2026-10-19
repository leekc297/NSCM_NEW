# SYS0014_GAP476_SUBAUTH_CLOUD_20261015 — 사업부 권한 삭제 시 하위(공장·고객) 권한도 삭제 (클라우드 패치, DB 만)

- 마커: `[GAP476 2026-10-15]` 1곳
- 대상: `SCM_MGR.PKG_SYS0014` PACKAGE BODY → `P_SYS0014_SAVE_GROUP_USER_M` 기존 unit_auth DELETE 문 바로 앞에 DELETE 1문장 삽입
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- **FE·BE 무변경 · BE 재기동 불필요.** 메타 · 권한 · 기존 원장 데이터 무변경.
- 같은 날 `SYS0014_GAP473_AUTHREQ_CLOUD_20261015`(권한 요청 기록 동반 삭제)와 서로 독립 — 앵커가 겹치지 않아 적용 순서 무관. 두 패키지 모두 적용해야 AS-IS 삭제 동작과 같아진다.

## 무엇이 바뀌나
| 사업부(D) 권한 줄 삭제 시 | 지우는 범위 |
|---|---|
| AS-IS `UP_FX_DeleteUserGroupAuthExtention` | 고른 줄 + **AuthType='D' 면 같은 그룹·사용자의 PrntCode=그 사업부 줄 전부** + 권한 요청 |
| TO-BE 현재 | 고른 줄만 (하위 권한 줄 잔존) |
| 패치 후 | 고른 줄 + 같은 그룹·사용자의 `UPPR_UNIT_ID` = 그 사업부 줄 (TO-BE 매핑: AuthType=UNIT_TP_CD · Code=UNIT_ID · PrntCode=UPPR_UNIT_ID). 권한 요청은 GAP473 패키지 |

- 이미 남아 있는 하위 권한 줄은 이 패치가 지우지 않는다. 사내 실측: 하위(P) 7줄 모두 `UPPR_UNIT_ID='-'`(상위 사업부 코드 없음)라 어느 사업부를 지워도 연결되지 않는다 — 정리가 필요하면 별도 결정. 클라우드 수치는 00_PRECHECK L4 로 회신.

## 검증 (2026-10-15, 사내 ZIOUI1 59.19.252.148, SERVER_HOST=localhost)
- 착수 원문: PKG_SYS0014 BODY LAST_DDL 2026-10-15 21:18:18 (GAP473 적용본, ALL_SOURCE 새로 조회). 사내 적용 21:26:31 → 리허설 후 최종 LAST_DDL 21:29:30, DB 원문 == 적용본 (마커 GAP473 2 · GAP476 1).
- E2E (저장 SP 를 FE 페이로드 형태로 직접 호출, 원장에 없는 시험 사용자 `ZZ_GAP476_T1` · 그룹 `DM Planner`, 끝나고 시험 행 전부 삭제):
  - 준비: D 81 · D 82 · P ZZP81(상위 81) · P ZZP82(상위 82)
  - D 81 삭제 → 적용 전: `D 82 · P ZZP81 · P ZZP82` 남음 (ZZP81 잔존 재현) / 적용 후: `D 82 · P ZZP82` 만 남음 ✅
  - 시험 키 외 권한 행수 25,013 불변 · GAP473 E2E 회귀 PASS
- 생성기 DRY-RUN: 10 적용 == 적용본 · 10 재실행 SKIP · 99 원복 == 수정 전 · 99 재실행 SKIP · **GAP473 미적용 원문**에서도 10→99 왕복 일치.
- 사내 리허설 99→00→10→10→90→99→99→10→90 전부 기대대로 (`_rehearsal_out/`, `_rehearsal_console.txt`).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS · L2 1행 · L3 마커 0 · L5 0행 (L4 는 숫자만 회신) | L1 FAIL 이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP476_PATCH.sql` | `APPLIED — PKG_SYS0014 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문은 바뀌지 않음. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 1 PASS | 회신 |
| 4 | 화면 SYS0014 | 하위 권한이 있는 사업부 줄 삭제 → 저장 → 그 사업부 아래 하위 권한 줄도 사라짐 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP476_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터 · DRY-RUN, 문구는 사내 적용기 `_apply_corporate/SYS0014_GAP476_SUBAUTH_20261015/apply_gap476.py` 와 단일 소스).
- `run_rehearsal.py` · `_rehearsal_out/` · `_rehearsal_console.txt` — 사내 리허설 결과.
- `_md5_corporate.txt` — 사내 수정 전·적용본 md5.
