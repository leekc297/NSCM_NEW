# DMF0082 조회 — 화면 필수 표시 컬럼 항상 반환 `[E20261013-DMF0082MANDRET]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 사용자 지시(2026-10-13): "titleset table 에 저장된 값이 없더라도 user_selected_flag = 'N' 으로 저장된 Column 은 해당 Division 만 맞으면 필수로 조회되어야 하는 컬럼"

## 증상·원인
- AS From Site 를 필수 표시(USER_SELECTABLE_FLAG='N')로 바꾼 뒤 DMF0082 에서 컬럼은 보이는데 값이 빈칸.
- 클라우드 QA 실측: 메타 `VISIBLE=Y DEFAULT=N SELECTABLE=N`, 조회 계정 minyonglee1 은 Column Set 저장 내역(`SCM_MST_TITLESET_USER` 'C')에 AS_FROM_SITE 없음.
- 화면은 필수 컬럼을 저장 내역에 없어도 항상 표시한다. 조회 SP 는 결과 컬럼을 저장 내역으로 만들고, 그와 무관하게 넣는 것은 저장 키 12컬럼(`[E20260822-KEYCOL]`)뿐이었다.
- 사내 재현: 81 · minyonglee1(저장 내역에 있음) = 결과에 AS_FROM_SITE 있음 / k0101(없음) = 없음.

## 변경 내용
`P_DMF0082_GET_MAIN_DATA` · `P_DMF0082_GET_MAIN_DATA_CURRENT` 의 저장 키 강제 추가 루프 바로 뒤에 루프 1개씩 삽입(+44줄, 기존 문장 무변경).
- 대상 컬럼 = `SCM_MST_SHEET_COLUMNS` 에서 `VALID_YN='Y'` · `USER_SELECTABLE_FLAG='N'` · `VISIBLE_FLAG='Y'` 이고 `DIVISION_ID` 목록에 조회 사업부가 있는 것
  (`[E20261012-DMF0082MANDCOL]` 과 같은 식 = 화면 컬럼 메타 조회와 같은 division 토큰 규칙).
- 최종 피벗 원천 임시 테이블(`GT_DMF0082_MF_SP` / `GTT_MF_SP`)에 실제로 있는 컬럼만 넣는다 — 없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않는다.
- 이미 결과 목록에 있으면 넣지 않는다(멱등). 컬럼 이름을 SP 에 적지 않았다 — 메타만 바꾸면 따라간다.
- 결과 목록에 들어간 컬럼은 묶음 기준(GROUP BY)에도 들어간다 — Column Set 에 그 컬럼을 넣은 사용자와 같은 모습.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | BODY 최신 원문 조회·백업 (LAST_DDL 10-13 17:16:38 — 16:26 사본과 내용 동일, 재컴파일만) | `00_BACKUP_PKG_DMF0082_BODY.sql` | 17:22 | 17,133줄 |
| 2 | 적용 전 조회 결과 저장 (조회만) | `test_before_after.py before` | 17:42 | 12케이스 |
| 3 | PKG_DMF0082 BODY 적용 | `01_PKG_DMF0082_BODY.sql` (`build_apply.py apply`) | 17:45:00 | VALID · 오류 0 · DB==적용본 · INVALID 127→126 |
| 4 | 전후 비교 | `test_before_after.py after` | 17:45 | 12케이스 PASS |
| 5 | 클라우드 패키지 리허설 (원복 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0082_MANDRET_CLOUD_20261013/` | 17:48:59 | 최종 적용 상태 · 마커 2 |
| 6 | 리허설 뒤 전후 비교 재실행 | `test_before_after.py after` | 17:50 | 12케이스 PASS |

권한·시노님·메타·데이터 변경 없음. SPEC 무변경.

## 검증 (프로시저 2종 × 사업부 3 × 사용자 2 = 12케이스, 사이트 지정)
| 케이스 | 결과 |
|---|---|
| 81 · 82 + Column Set 에 AS_FROM_SITE 없는 사용자(k0101) | AS_FROM_SITE 컬럼만 추가, 그 외 컬럼·행 내용 동일 (81 92행 · 82 1,867행) |
| 81 · 82 + 있는 사용자(minyonglee1) | 컬럼·행 모두 적용 전과 동일 |
| 40 (대상 사업부 아님) | 두 사용자 모두 적용 전과 동일 |

- 조건: 81 HKMC_KR_ASA · 82 NextEra_US_PHX · 40 acer/acer_CN_CKG. 전체 조회는 건당 5분이라 사이트를 지정했다.
- `GET_MAIN_DATA_CURRENT` 는 81·82 에서 0행이라 컬럼 목록만 비교됐다.

## 미실행
- 화면에서의 표시 확인(사용자 확인 대상). 사내 81 원장에는 AS From Site 값이 있는 행이 없어(10월 이후 0건) 값이 실제로 보이는 것까지는 사내에서 확인하지 못했다. 82 는 '-' 값이 내려오는 것을 확인.
- 클라우드 적용.

## 원복
`00_BACKUP_PKG_DMF0082_BODY.sql` 실행, 또는 패키지의 `99_ROLLBACK_MANDRET_PATCH.sql`.
