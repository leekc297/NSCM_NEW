# DMF0005 Model Code Change 저장 — 키 중복 사전 검증 `[E20261013-DMF0005MCDUP]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 사용자 요청(2026-10-13): "검증 메세지 추가 해주세요."

## 경위
- 신고: 클라우드 DMF0005 Model Code Change 팝업 저장 오류. 첨부된 ORA-01861 은 09-29 메인 그리드 저장의 과거 기록이었다(화면 오류 기록 최신 건).
- 실제 오류(클라우드 QA `SCM_SYS_LOG_BATCH` 10-13 13:17:37 · 13:21:10): `ORA-00001 (PK_SCM_MST_SITE_ITEM)` — BODY L1727(갱신) ← L1879(`SCM_MST_SITE_ITEM`).
- 원인: 변경 전 Model 과 같은 키에 변경 후 Model 이 이미 등록 → ITEM_ID 변경 시 키 중복.
- AS-IS(LGCE_SCMDEV `dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP`, 수정 2023-08-23, 조회 2026-10-13 13:46, 서버 LESDFPSTO1C01): PK 구성 동일 · 사전 검사 없음 · 중복이면 CATCH 에서 전체 ROLLBACK 후 `[2627]…` 반환.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | BODY 최신 원문 조회·백업 (LAST_DDL 10-12 19:18:19) | `00_BACKUP_PKG_DMF0005_BODY.sql` | 13:59 | 1,905줄 |
| 2 | CHECK_DUP 판정 대조 (읽기 전용) | `test_checkdup.py` | 14:01 | 7 시나리오 × 38 테이블 일치 |
| 3 | PKG_DMF0005 BODY 적용 (+84줄, 기존 문장 무변경) | `01_PKG_DMF0005_BODY.sql` (`build_apply.py apply`) | 14:03:56 | VALID · 오류 0 · DB==적용본 |
| 4 | 저장 SP 실호출 (키가 겹치는 쌍만) | `test_call.py` | 14:04 | 2건 PASS |
| 5 | 클라우드 패키지 리허설 (원복 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0005_MCDUP_CLOUD_20261013/` | 14:08:30 | 최종 적용 상태 · 마커 4 |

권한·시노님·메타·데이터 변경 없음. SPEC 무변경. 적용 전후 SCM_MGR INVALID 객체 수 332 → 332 (이번 작업과 무관하게 이미 332).

## 변경 내용
1. 변경 이력 1줄.
2. 내부 프로시저 `CHECK_DUP(P_TABLE, P_DIV40)` 신설 — 그 테이블의 유일 인덱스 중 ITEM_ID 를 포함한 것을 딕셔너리(`USER_INDEXES`·`USER_IND_COLUMNS`·`USER_TAB_COLUMNS`)에서 읽어,
   갱신 뒤 키가 겹치는 행이 있으면 `RAISE_INVALID` (CODE -1, 기존 INVALID 경로 = 전체 ROLLBACK + 로그).
   - 상대 행이 같은 배치에서 다른 코드로 옮겨가면 겹치지 않는 것으로 본다.
   - 서로 다른 변경 전 Model 두 개가 같은 변경 후 Model 로 모여도 겹치는 것으로 본다.
   - 날짜 키 컬럼은 형식을 명시해 문자로 바꾼다(세션 날짜 형식 비의존).
3. `CHANGE_TABLE` 에서 대상 행 수집 뒤·갱신 전 `CHECK_DUP` 호출 1줄.

메시지: `변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다.` / `MODEL : 전 -> 후` / `TABLE : …` / `KEY : 컬럼=값, …`

## 검증
- 판정 대조: 다른 방식(변경 반영 ITEM_ID 로 GROUP BY HAVING COUNT>1)으로 계산한 정답과 테이블별 일치.
  단일 쌍 충돌 3종 · 충돌 없음 1 · 두 Model 이 한 Model 로 모임 1 · 상대가 옮겨감 1 · 맞바꿈 1.
- 실호출: `MPCLGE19CY2G→MPCLGE19CY2M`(SCM_MST_SITE_ITEM 에서 차단) · `MPCLGEOCU31T→MPCLGEOCU31M`(DM_PLN_MKT_FCST_RESULT 에서 차단).
  둘 다 CODE -1 + 메시지, 호출 전후 38개 테이블 행 수·이력 건수 동일. 세션 날짜 형식 DD-MON-RR.

## 미실행
- 키가 겹치지 않는 변경쌍의 실호출(성공하면 실제 데이터가 바뀌고 COMMIT 되므로 호출하지 않음). 이 경로는 판정 대조(충돌 없음 → 메시지 없음)로만 확인.
- 화면에서의 메시지 표시 확인(사용자 확인 대상).
- 클라우드 적용.

## 남은 제약
- 같은 배치의 `A→B` + `B→C` 에서 A 행과 B 행 키가 같으면 검증은 통과하나 행 단위 갱신 도중 ORA-00001 가능(종전 동일). AS-IS 는 한 문장 갱신이라 통과. 실사례 미확인.

## 원복
`00_BACKUP_PKG_DMF0005_BODY.sql` 실행, 또는 패키지의 `99_ROLLBACK_MCDUP_PATCH.sql`.
