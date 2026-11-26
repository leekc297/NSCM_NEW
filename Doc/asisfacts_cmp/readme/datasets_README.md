# datasets: 액션별 AS-IS 실행 결과셋

`tools/AsisFacts/datasets.py` 결과입니다(2026-10-23 사용자 승인). 화면 액션이 DB 까지 닿는 연결(`screens/<ID>/action_links.csv`)을 실제로 실행해 결과셋을 남겼습니다.

- 실행 단위: 액션이 직접 부르는 SP, FoxQuery 인라인 SQL, 테이블에 저장된 쿼리(SCM_ADM_DQ_LIST)
- 안전:
  - 모든 실행은 트랜잭션 안에서 하고 항상 ROLLBACK
  - 영구 테이블 쓰기, COMMIT, 암호화, 원문 없는 모듈이 실행 경로에 있으면 실행하지 않음(UNSAFE)
  - LOCK_TIMEOUT 10초, 쿼리 제한 60초, 동시 연결 4
- 파라미터 값 출처(우선순위): 코드 리터럴 → 사용자가 저장한 조회조건(ADMIN 최빈값) → 사업부 40·81·82 각각 → 실제 AS-IS 사용자 → 실행일 기준 날짜 → SP 기본값

| 경로 | 내용 |
|---|---|
| `runs.csv` | 실행 1건 1행(4,150건). run_id, db, kind(SP·SQL·DQ), name, division, params, param_sources, safety, status, sec, log_records, resultsets, error, screens |
| `runs_1st.csv` | 같은 열의 다른 실행 기록(4,240건). 만든 경위는 코드에서 확인하지 못함(미확인) |
| `plan.csv` | `--dry` 실행 계획(UNSAFE 사유, 파라미터 값과 출처) |
| `LGCE_SCMDEV/<SP 또는 키>/<run_id>_rs<n>.csv` | SCM DB 결과셋(결과셋마다 최대 1,000행). 폴더 671개 |
| `LGCE_FPDEV_TR/<SP 또는 키>/<run_id>_rs<n>.csv` | FP DB 결과셋. 폴더 298개 |

화면 폴더의 `action_data.csv` 가 액션 → 이 실행 기록(run_id)을 잇습니다.
