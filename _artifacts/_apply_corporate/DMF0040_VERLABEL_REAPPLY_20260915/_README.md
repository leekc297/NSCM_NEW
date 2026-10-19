# DMF0040_VERLABEL_REAPPLY_20260915 — MKT FCST Comparison 메저 = 선택 VERSION_ID 재반영

## 요구 (사용자 2026-09-15)
현재 사내 소스를 유지하고, 09-09 15:59:11 전체본 덮어쓰기 **이전 작업분(VERLABEL)** 이 적용되도록.

## 이력 (사내 ZIOUI1)
| 시각 | 사건 |
|---|---|
| 09-09 15:30~15:56 | [E20260909-VERLABEL] + Owner P53 사내 적용 (`_deploy_packages/PKG_DMF0040_VERLABEL_20260909`) |
| 09-09 15:59:11 | 타 출처 전체본(CRLF, `--ENG 언어 설정시 Team 그리드 영어로 표시 26.09.09 ssh`) 배포 → VERLABEL 소실 |
| 09-14 11:50 / 16:42 | MULTISEL 3건 적용 · PDB 원복 후 재적용 (VERLABEL 없는 본문 위) |
| **09-15 14:53:19** | **본 작업 — VERLABEL 4군데 외과 병합** |

## 대조 결과 (VERLABEL 패키지 본문 vs 현재 본문)
- VERLABEL 4군데 = 현재 본문에 없음 → **반영 대상**
- Owner 필터 P53 = 현재 본문에 동일 존재 → 대상 아님
- MULTISEL 6곳 · ssh Team 영문표시 = 현재 본문 전용 → **유지**

## 변경 (4군데, `P_DMF0040_GET_MKT_FCST_COMPARISON`)
1. 버전 분기 `V.VERSION_TYPE AS MEASURE` → `V.VERSION_NO AS MEASURE` + `V.VERSION_TYPE AS VERSION_TYPE`
2. Difference 분기 `'Difference' AS VERSION_TYPE` (UNION ALL 정합)
3. `VERSION_SORT` CASE `A.MEASURE` → `A.VERSION_TYPE`
4. 파생표 `SELECT DISTINCT ... , F.VERSION_TYPE`

## 적용·검증 (2026-09-15 14:53)
- 게이트(현재 BODY == 00_BACKUP) 통과 → BODY VALID · ERRORS 0 · 마커 VERLABEL 5 / MULTISEL 6 / ssh 1
- SP 직접 호출 (div40 / 20260801~20260930 / `MF_W_20260824_V001,MF_W_20260817_V001` / MONTHLY)

| | 행수 | MEASURE 분포 | 순서 |
|---|---:|---|---|
| 적용 전 | 786 | Version(A) 258 · Version(B) 257 · Difference 271 | A → B → Difference |
| **적용 후** | 786 | **MF_W_20260824_V001 258 · MF_W_20260817_V001 257** · Difference 271 | 최신 → 이전 → Difference |

## 파일
- `00_BACKUP_ASIS/PKG_DMF0040_BODY.ASIS.sql` — 원복용
- `01_APPLY/PKG_DMF0040_BODY.sql` — 적용본(사내 전체본)
- `apply_verlabel.py` — backup / test / apply (4군데 각 1건 매칭 아니면 중단)

## ⚠ 별건 (미조치)
로컬 SQL ERROR = `PKG_SCM0002` 가 09-11 공통소스 커밋 6eae9cf5(`.atlas/gscm-design/SCM0002/design/06_pkg_scm0002.sql`) 전체본으로 덮여
`P_SCM0002_GET_VERSIONBYWATERFALLPOPUP` 소실 → DMF0040 / DMF0035 Version 팝업 PLS-00302. 본 작업 범위 밖.

## 클라우드
01_APPLY 는 사내 전체본 — 클라우드 본문과 다를 수 있으므로 통째 교체 금지. `apply_verlabel.py` patch()(4군데)를 클라우드 본문에 적용.
