# DMF0040 MKT FCST Comparison — 멀티선택 조회조건 / Plant Site 오류 보완 (2026-09-14)

사내 적용: ZIOUI1 (SCM_MGR) `PKG_DMF0040` BODY · 마커 `E20260914-MULTISEL` 6곳 · VALID / 오류 0 · 클라우드 ⛔ 미적용

## 결함 3건 (AS-IS `DMF0040_GET_MKT_FCST_COMPARISON` + `FN_SCM_GET_WHERE_SQL` DB 직접 대조)

| # | 증상 | 원인 | 보완 |
|---|---|---|---|
| 1 | Plant Site 선택 시 ORA-00907 (1건·2건 모두) | MKT_FCST_C 분기 동적 SQL 닫는 괄호 1개 누락 | 괄호 추가 |
| 2 | Div 40 End Customer 2건 이상 → 0행 | `PROJECT_CODE LIKE '%A,B%'` 콤마 문자열 통째 비교 (4곳) | AS-IS `LK` = 값별 `LIKE '%v%'` OR 결합 + `*`→`%` 로 복원 |
| 3 | Project Code 조인 미적용 | `P_PROJECT_CODE <> ''` 가 Oracle 에서 항상 UNKNOWN | `IS NOT NULL` |

## 실측 (1건 A / 1건 B / 2건 A,B 행수 — 수정 전 → 후)

- Div 81 Plant Site: ORA-00907 → 172 / 38 / **210**
- Div 40 End Customer: 58 / 40 / **0** → 58 / 40 / **98**
- Div 40 Project: 456 / 456 / 456(조건 무효) → 58 / 40 / 98
- 그 외(81·40 Sales Site·Team·End Customer(81)·Item Type·Project(81)·Model·Owner·Biz Type) 전후 동일·정상
- BE API(`/DMF0040/mktFcstComparison/SEARCH/call-proc`) 경로 동일 확인
- 러너: `_artifacts/_diagnostics/dmf0040_multiselect_sweep{,2,3}.py` (결과 json before/after)
- 미검증: Div 40 Plant Site (후보 값이 센티널 `-` 1개뿐)

## 파일

- `01_PKG_DMF0040_BODY.sql` — 적용본 (사내 라이브 기준)
- `00_BACKUP_PKG_DMF0040_BODY_pre_20260914.sql` — 원복용

## ⚠ 클라우드 이관 전 확인

사내 적용 전 본문은 09-09 클라우드 이관본 `PKG_DMF0040_VERLABEL_20260909` 과 다르다
(사내 = VERLABEL 수정 없음 + "ENG 언어 설정 시 Team 영문 표시 26.09.09 ssh" 포함).
`01` 전체 교체를 클라우드에 올리면 VERLABEL 이 되돌아갈 수 있다 → 클라우드 본문 기준으로 위 3건만 병합할 것.
