# DMF0014_UPLOAD_MASTERCHK_20260915 — Excel Upload 검증 마스터 확인 보완 [E20260915-DMF0014MSTCHK]

## 증상 (사용자 2026-09-15)
첨부 `DMF0014_Template_20260915_110612.xlsx` 업로드 → 검증 SUCCESS 3/3 → [OK] 저장 시 SQL ERROR.
BE 로그: `ORA-01403` @ `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` 541행 (SITE_ITEM by [Project]/[Model] 열, 예외처리 없음) ← PKG_DMF0014 3279행.
원인 행: 1행 Model `abcde`, 3행 Model `efg` (Customer Model 미등록 + Project/Model 조합 SITE_ITEM 부재).

## 근본 원인
TO-BE Customer Model 검증의 SITE_ITEM 조건 = `ATTRIBUTE4/5`(Customer Project/Model).
AS-IS `DMF0014_CUST_FCST_EXCEL_UPLOAD` L453~454 = `ATTRIBUTE12/13`(Project/Model 열, 2024-01-10 변경) — 변환 시 주석의 구 조건을 채택.
(AS-IS 접속: LESDFPSTO1C01 / LGCE_SCMDEV / SCP_MGR_DEV · 조회 2026-09-15 17:14 · modify_date 2026-04-11 23:30)

## 검증 전수 대조 (AS-IS 12종 ↔ TO-BE 15종)
AS-IS 활성 검증 12종은 TO-BE 에 전부 존재. 차이 = Customer Model SITE_ITEM 조건 1건.
반영 프로시저 SELECT INTO 무예외처리 지점 대조로 추가 필요 확정: 품목 분류(600행 SCM_MST_ITEM_SN), Customs Handbook(원장 '72' 등 비정상값 유입).
Measure Group×Measure 조합(490행)은 기존 Measure Group(CUST_FCST 한정)+Measure UOM 검증으로 이미 차단 — Div81 마스터 전 Measure = CUST_FCST 실측 → 미추가.

## 보완 (메인 프로시저만 · Division != 40 · `_SM` 무변경)
| # | 내용 | 메시지 |
|---|---|---|
| ① | Customer Model 검증 SITE_ITEM 조건 → ATTRIBUTE12/13 (AS-IS 파리티) | Invalid Customer Model - … [Customer Model*]/[Project]/[Model] 확인 |
| ② | Model 품목 마스터(SCM_MST_ITEM_SN) — 대상 품목 = Customer Model 품목, 없으면 [Model] | Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인 |
| ③ | Customs Handbook = LOOKUP 'DOM/EXP'(D/E) | Invalid Customs Handbook - … (D/E). [Customs Handbook*] 확인 |

## 적용·검증 (2026-09-15 17:21:26)
- FRESH-GATE 통과 → VALID · ERRORS 0 · 적용본 == DB · 마커 4 · INVALID 0
- 첨부 파일: Total 3 / Success 1 / Error 2 (2행 = ①②, 4행 = ①②③) → [OK] 저장 차단(오류 행 존재)
- 회귀: DMF0014 정상 샘플 10건 Success 10 / Error 0
- 클라우드 패키지 `_deploy_packages/DMF0014_EXCELUPLOAD_REAPPLY_CLOUD_20260915` 재빌드(13_ BODY = 본 적용본, SOURCE-FRESH 17:22)

## 파일
`00_BACKUP_ASIS/` 원복용 · `01_APPLY/` 적용본 · `apply_masterchk.py` (backup/apply)
