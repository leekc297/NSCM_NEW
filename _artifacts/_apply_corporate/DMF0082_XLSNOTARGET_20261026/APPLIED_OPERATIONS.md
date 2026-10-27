# DMF0082_XLSNOTARGET_20261026 — 사내 ZIOUI1 실행 기록 (SCM_MGR, 59.19.252.148 · SERVER_HOST=localhost)

[E20261026-DMF0082XLSNOTARGET] Excel Upload(81, Model 빈칸) — 저장 대상 Model 0 이면 SUCCESS 대신 ERROR.

| 시각 (2026-10-26) | 작업 | 파일 | 결과 |
|---|---|---|---|
| 23:00 | 기준본 조회 (PKG_DMF0082 BODY, LAST_DDL 2026-10-21 22:47:30, VALID) | (세션 조회) | DB 무변경 |
| 23:12 | 패키지 생성 | `../../_deploy_packages/DMF0082_XLSNOTARGET_CLOUD_20261026/build_package.py` | `PKG_DMF0082_BODY.ASIS.sql/.raw` · `TOBE.raw` · A_DB 4종 (DB 무변경) |
| 23:2x | 복원 가드 실증 — 시험 프로시저 `TMP_XLSNT_GUARD` 깨진 소스 → INVALID → 자동 복원 VALID | (scratch) | 시험 객체 DROP · 잔존 0 |
| 23:14~23:30 | 1차 리허설 — 10_APPLY 의 CREATE 가 타 세션(`DMF0082_MKTAMT_AUDIT_20261026/verify_mktamt_audit.py`, SID 714) 의 PKG 실행 pin 에 15분 대기 후 **미실행** | `run_rehearsal.py` | 원문 무변경(LAST_DDL 그대로). 단 10 이 `WHEN OTHERS THEN NULL` 로 오류를 삼켜 'APPLIED' 오출력 → Python 대조(CHECK 1)가 차단 |
| 23:33 | 생성기 정정 — CREATE 오류 중 ORA-24344 만 진행, 그 외 `-20006` 중단 + 적용 후 USER_SOURCE 표식 수 확인(`-20007`) | `build_package.py` | |
| 23:43 | PKG_DMF0082 사용 세션 0 확인 | | |
| 23:44:51 | 재생성 (FRESH, LAST_DDL 10-21 22:47:30 동일) | `build_package.py` | |
| 23:44~23:46 | 리허설: FRESH-GATE → 99 SKIP → 00 → **10 APPLY** → 10 SKIP → 90 → **99 ROLLBACK** → 99 SKIP → **10 APPLY(최종)** → 90 → 00 | `run_rehearsal.py` → `_rehearsal_out/rehearsal.out.txt` | CHECK 0~5 PASS · 적용본 == Python 적용본 · 원복본 == 기준본 (바이트 동일) · **현재 적용 상태 LAST_DDL 23:46:21 VALID · 오류 0 · 의존 INVALID 0** |
| 23:46:41 | E2E (BE 와 같은 호출 체인, 테스트 ID `XLSNT_T1`) | `e2e_upload.py` | **16/16 PASS** (아래) |

## E2E 결과
| 케이스 | 결과 |
|---|---|
| C01 정상 Model 빈칸 · LOC 대상 (81/Sales T.Porsche/BMW P/BMW/A15BW7003/KRW) | SUCCESS |
| C02 정상 Model 빈칸 · RTF_SYS_RP 대상만 (81/ESG팀/Lion Bus/A17LS4001/USD) | SUCCESS |
| C03 10-26 신고 조합 (Alte · A21BW2003 · AI/빅데이터1.빅데이터분석팀) | ERROR `No MODEL for END CUSTOMER / PROJECT CODE.` (이전 SUCCESS·저장 0행) |
| C04 End Customer–Project 불일치 | ERROR `No MODEL for END CUSTOMER / PROJECT CODE.` |
| C05 Team 이 Project 품목 부서 아님 | ERROR `No MODEL for TEAM / PROJECT CODE.` |
| C06 품목·부서 일치 · LOC/RTF 없음 (BMW/A21BW2005/독일마케팅1팀) | ERROR `No Upload Target MODEL (LOC / RTF_SYS_RP).` |
| C07~C11 없는 Team / End Customer / Project / Currency / Division 82 | ERROR `Invalid TEAM.` / `Invalid END CUSTOMER.` / `Invalid PROJECT CODE.` / `Invalid CURRENCY.` / `Invalid Division.` (기존 검사 동작 확인) |
| C12 Division 빈칸 | SKIP (빈 줄 취급 — AS-IS 동일) |
| C13 Model 입력 정상 / C14 없는 Model (회귀) | SUCCESS / ERROR `Invalid MODEL.` |
| G1 대상 없는 행으로 저장(OK) | CODE -1 `ERR_RTN: - Validation Check` · 원장 무변경 |
| S1 C02 행 저장 | CODE 0 · EVENT 30 · FP 30 = FP_H 30 (AMRSAB100-A4 × LOC/KRW/USD × 2026-12, LOC=10) |

- 정리: `CREATED_BY='XLSNT_T1'` + `PROJECT_CODE='A17LS4001'` + `ATTRIBUTE8='EXCEL UPLOAD'` FP 30 · FP_H 30 DELETE, 스테이징 삭제 → 원장 (0,0) == 전 (0,0). `SCM_SYS_LOG_BATCH` 로그 행은 남김.
- 원복: `../../_deploy_packages/DMF0082_XLSNOTARGET_CLOUD_20261026/A_DB/99_ROLLBACK_XLSNOTARGET_PATCH.sql` (블록만 제거 — 이후 타 작업자 변경 보존).
- ⚠ 동시 작업: 타 세션 `DMF0082_MKTAMT_AUDIT_20261026` 이 22:56 원문 기준 PKG_DMF0082 BODY 적용을 준비 중이었다. 그 스크립트는 FRESH-GATE 가 있어 이 적용(23:46) 뒤에는 중단·재병합해야 한다 (덮어쓰기 없음).
