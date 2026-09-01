# DMF0074_D4D5_CLOUD_20260827 — Excel Upload 결함 D4·D5 정정 (클라우드 이관)

사내 적용 2026-08-27 16:17 완료·실증 (`_artifacts/_apply_corporate/DMF0074_D4D5_20260827/README.md`).
⚠ 전제: 클라우드 PKG_DMF0074 BODY 가 사내 2026-08-16 NULLFIX + 08-18 MRFPARITY 판과 동일해야 함 — `DMF0074_CLOUD_20260819` 패키지(A_DB 02) 미적용이면 그 패키지를 먼저 적용하거나, 본 01 파일(사내 라이브 신선 덤프 = NULLFIX·MRFPARITY·D4·D5 전부 포함)로 통째 교체.

| # | 파일 | 방식 | 내용 |
|---|---|---|---|
| 01 | A_DB/01_PKG_DMF0074_BODY.sql | CREATE OR REPLACE PACKAGE BODY (4,020줄) | [E20260827-D4-NOLOADGUARD] P_MODE>0 오류잔존/적재0 → CODE '-1' · [E20260827-D5-ORDER] C21~C23 을 C19 앞으로 |
| 90 | A_DB/90_VERIFY.sql | SELECT | VALID·ERR 0·마커 3·순서 |

FE/메타 변경 없음 (FE 는 `inner.CODE !== '0'` 를 이미 실패로 처리 — MetalLinkPrice.tsx onSave).
DBeaver Execute Script(Ctrl+Alt+X) 또는 sqlcl `@01_PKG_DMF0074_BODY.sql`.