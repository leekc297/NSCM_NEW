# DMF0082 조회 — 시스템 컬럼 DEFAULT_FLAG 'N' 내성 `[E20261013-DMF0082DEFFLAGN]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 사용자 지시(2026-10-13): "DEFAULT_FLAG 가 'N' 으로 처리되어도 오류가 발생하면 안됩니다."

## 증상·원인
- 10-13 11:48:22 부터 DMF0082 조회 `SQL ERROR` — 실제 오류 `ORA-00904: "SORT_KEY"` (PKG_DMF0082 L4741 `OPEN O_RC1`).
- 11:48:18 DBeaver 스크립트로 `SCM_MST_SHEET_COLUMNS`(DMF0082·FcstNPrice) 시스템 컬럼 10종의 `DEFAULT_FLAG` 가 `'/'` → `'N'` 으로 변경됨
  (GROUP_ID·VERSION_NO·MEASURE_GROUP·BUCKET·EDIT_FLAG·SORT_KEY·NEW_FLAG·ATTR1·VMI_STD_DIO·AS_YN, 수정자 minyonglee1).
  같은 날 10:14:35 에는 반대 방향(`'N'` → `'/'`) 스크립트가 실행됐었다.
- 조회 SP 의 C_TITLE 커서 2번째 UNION 이 `NVL(TRIM(DEFAULT_FLAG),'/')='/'` 인 컬럼만 골라 0건 → 컬럼 목록에 SORT_KEY 가 빠지고 고정 문장 `ORDER BY SORT_KEY` 가 실패.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | BODY 최신 원문 조회·백업 (LAST_DDL 10-13 10:32:50) | `00_BACKUP_PKG_DMF0082_BODY.sql` | 11:59 | 17,121줄 |
| 2 | 컬럼 목록 전후 비교(메타 값 전환은 미커밋·ROLLBACK) | `test_ctitle_equiv.py` | 11:59 | PASS |
| 3 | PKG_DMF0082 BODY 적용 (판정 2곳, +12줄) | `01_PKG_DMF0082_BODY.sql` (`build_apply.py apply`) | 12:00:27 | VALID · 오류 0 · DB==적용본 · INVALID 4→4 |
| 4 | 조회 SP 실호출 | `test_call.py` (`81 82` 추가) | 12:00~ | 6건 PASS |

권한·시노님·메타 데이터 변경 없음. SPEC 무변경.

## 변경 내용
`P_DMF0082_GET_MAIN_DATA` · `P_DMF0082_GET_MAIN_DATA_CURRENT` 의 C_TITLE 2번째 UNION 판정 1줄씩.
- 종전(줄 주석으로 보존): `AND NVL(TRIM(C.DEFAULT_FLAG), '/') = '/'`
- 보완: `AND ( RTRIM(C.DEFAULT_FLAG, ' -/') IS NULL OR C.COLUMN_NAME IN (시스템 컬럼 10종) )`
- 그 외 'N' 컬럼(사용자 선택 컬럼 39종)은 종전대로 제외 — 포함하면 GROUP BY 축이 늘어 행이 갈린다.
- 10종을 이름으로 지정한 이유: 'N' 49행 안에서 VISIBLE_FLAG·USER_SELECTABLE_FLAG 등 메타 속성으로는 10종만 가려낼 수 없다
  (DEPT_ID·DEPT_NAME_KO·MDM_PROJECT_NAME 도 숨김, VERSION_NO 는 표시).

## 검증
- 컬럼 목록 비교: Column Set 저장 사용자 20명 + 저장 내역 없는 사용자 1 × 프로시저 2종.
  기준(종전 문장 × '/') 대비 보완 문장 × '/' · 'N' · 'Y' · '-' · ' ' 모두 순서까지 동일(각 21/21).
  종전 문장 × 'N' 은 21/21 에서 SORT_KEY 빠짐(오류 재현).
- 실호출(메타 'N' 상태 그대로): 11:48 실패 호출 2건 · CURRENT 프로시저 · k0101 · 81 전체 · 82 전체 = 전부 SUCCESS, 첫 커서에 SORT_KEY 있음.

## 미실행
- 화면에서의 조회 확인(사용자 확인 대상).
- 클라우드 패키지 미작성·미적용.
- 같은 판정을 쓰는 다른 화면 SP(DMF0003·DMF0020·DMF0043·DMF0053 등)는 손대지 않음.

## 원복
`00_BACKUP_PKG_DMF0082_BODY.sql` 실행(적용 직전 원문).
