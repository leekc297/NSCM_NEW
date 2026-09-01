# DMF0014 Excel Form — 헤더 전용(데이터 0행) 변경 (2026-08-27 사내 적용 ✅)

사용자 요청: "DMF0014 EXCEL FORM 조회 시 데이터는 없이 HEADER 만 생성 — PKG.SP 변경".
hook #135 "Excel Form = 현재 조회조건 데이터" 원칙의 **화면별 예외**(DMF0082 는 종전 유지).

| 파일 | 내용 |
|---|---|
| `BACKUP_PKG_DMF0014_20260827_*.sql` | 정정 전 SPEC+BODY 전문 (V7 키조합 실데이터판) — 원복 = 그대로 실행 |
| `PREVIEW_PKG_DMF0014_BODY.sql` | 정정 후 BODY (배포본, 16:51 사내 적용 · VALID · USER_ERRORS 0) |
| 생성 스크립트 | `_artifacts/_diagnostics/dmf0014_excelform_hdronly_apply.py` |

## 변경 — `P_DMF0014_GET_EXCEL_FORM_DATA` [E20260827-EXCELFORM-HDRONLY]
- 시그니처·커서 컬럼명 불변. 동적 키조합 SQL(V7, L7167~7303) 제거 → `FROM DUAL` 헤더 캐리어 1행:
  식별 14컬럼 = NULL / `PERIOD_BUCKETS` = 조회구간·버킷타입의 버킷 일자 전량 / `UPLOAD_VALID_WEEKS` = division 내 VALID_YN='Y' 버킷.
- 실측(call-proc, 81 · 20260831~20261130 · WEEKLY): rows 1 · 키 전부 NULL(BE 는 NULL 키를 내려주지 않음) · PERIOD_BUCKETS 14주.

## FE 동반 변경 — `CustomerFcstTemplateModal.tsx`
- `headerOnly = rows.every(r => !r.SCM_SITE_ID)` → `dataRows=[]`: 미리보기·다운로드 데이터행 0, 컬럼(식별 13 + 버킷 일자)만 생성. 타입체크 13/13.
- 결과: Excel Form 파일 = 1행 헤더(토큰 원형 + YYYYMMDD 버킷) + 빈 시트. 업로드 계약(HEADER_CONTENT 토큰·1단 일자 헤더) 그대로.

## 클라우드
⛔ 미적용 — 이관 시 본 PREVIEW(A_DB) + FE 모달 1파일.
