# DMF0082_HINT_20261102 — 사내 ZIOUI1 적용 기록 `[E20261102-DMF0082HINT]`

- 요청(2026-11-02): P_DMF0082_GET_MAIN_DATA 힌트 6건 적용 + 전후 속도 확인. 표 문구는 사용자 제공 이미지.
- 접속: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost
- 기준 원문: ALL_SOURCE 재조회 · BODY LAST_DDL 2026-10-27 16:31:46 (17,944줄) → `00_BACKUP_PKG_DMF0082_BODY.sql`
- 원복: `_deploy_packages/DMF0082_HINT_CLOUD_20261102/A_DB/99_ROLLBACK_HINT_PATCH.sql` (사내 검증 · 원복 후 원문 == 백업 True)
- 참고: 측정 중 사용자 통보 = 사내 데이터 이관 진행 중. 부하량은 측정하지 않음.

| 시각 | 작업 | 결과 |
|---|---|---|
| 09:31~09:43 | 적용 전 측정 `measure.py before` | `_measure_before.json` |
| 09:43:54 | 힌트 적용(별칭 CAL) | VALID · 오류 0 · 스키마 INVALID 86→86 |
| 09:45~09:59 | 측정 `after_CAL` | 40·81 느려짐 · `_measure_after_CAL.json` |
| 10:01:46 / 10:01:58 | 원복 → 표 문구 그대로(CALL) 적용 | VALID · 오류 0 |
| 10:03~10:14 | 측정 `after_CALL` | 40 행수 7,619(원본·CAL 7,721) — 빠진 102행 전부 RTF_SYS_RP |
| 10:17:30 | 원복 · 기준 재측정 `before2` | 7,721 |
| 10:35~10:47 | 교차 측정 `ab.py` (HINT/BASE 2주기, BODY 4회 재컴파일) | 40·81·82 지문 HINT == BASE · 전 호출 7,721/8,042/16,251행 → 7,619 는 힌트 때문 아님. 원인은 확정하지 못함(사용자 통보 이관과 시점 관계 미측정) |
| 10:49~10:57 | 클라우드 패키지 리허설 | `DMF0082_HINT_CLOUD_20261102/00_README.md` |
| 10:57:45 | 패치 방식 CALL 적용본 | VALID · 마커 6 |
| 11:05:29 | 사용자 확인 = CAL 이 맞음 → CALL 원복 | 원문 == 적용 전 백업 True |
| 11:05~11:13 | CAL 패키지 재생성·리허설 | 40 +2.3% · 81 +6.2% · 82 -39.8% (3회 중앙값) · NOTE OK |
| 11:13:49 | **최종 = 패치 방식 CAL 적용본** | VALID · 마커 6 · 줄 수 17,945 |

최종 원문은 패키지 `20_APPLY_HINT_PATCH.sql` 적용 결과다. `01_PKG_DMF0082_BODY.sql` 은 CALL 시험판이라 최종 원문과 별칭·주석이 다르므로 쓰지 않는다.
