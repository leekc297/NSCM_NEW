# DMF0074 Metal Link Price — Excel Upload 클라우드 이관 패키지 (2026-09-15)

## 증상
사내(로컬) 업로드 정상 (샘플 10행 SUCCESS 10 · Key/Period 21칸 누락 0) / **클라우드 전체 실패**.

## Excel Upload 경로 — 한 축이라도 구버전이면 전체 실패
| 단계 | 축 | 대상 | 파일 |
|---|---|---|---|
| ① 헤더 설정 | DB 메타 | `SCM_ADM_EXCEL_COLUMNS` DMF0074 / DMF0074_40 — HEADER_CONTENT `Period(Fr)_Ni` 형(2단) | `30_EXCEL_COLUMNS_DMF0074.sql` (멱등 MERGE) |
| ② 엑셀 파싱 | **BE** | `ExcelUtils.convertGroupedHeaderExcelToJson`(2단 병합 헤더 → `그룹명_하위명` 키) · `FileServiceImpl` 2단 판정 | `BE_MERGE/` |
| ③ 임시적재 · ⑤ 결과 | DB PKG (공용) | `PKG_NSCM_UI_EXCEL` — [E20260914-EXCELROW] | `10_` SPEC · `11_` BODY |
| ④ 검증 · 저장 | DB PKG | `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD` 외 | `12_` SPEC · `13_` BODY |
| 양식 다운로드 · 오류상세 | FE | MetalLinkPrice(2단 양식) · FcstUploadModal · gridAction | `FE_MERGE/` |

⚠ **①만 반영하고 ②(BE)가 구버전이면** 구 BE 가 `Period(Fr)_Ni` 토큰을 못 찾아 메탈 42열이 조용히 탈락 → **전 행 오류**. 반대로 BE 만 신버전이고 ①이 구 1단(`PeriodFr_Ni`)이어도 동일. **①·② 동시 반영.**

## 적용 절차 (DB = SCM_MGR 접속 · QA/DEV 모두)
1. `@00_PRECHECK.sql` — **조회 전용**. 판정:
   - [A] `EXPECTED_MISSING` 값 있음 → 그 객체는 보완 전 소스 → 해당 1x 파일 실행 (SPEC → BODY 순)
   - [A] `CLOUD_ONLY_MARKERS` 값 있음 → 클라우드에만 있는 수정 → **그 객체 전체교체 금지, 결과 공유 요청**
   - [B] `DIFF_*` = DIFF 또는 `HEADER_FORM` = 구 1단 / 행 없음 → `30` 실행
   - [C] `MISSING` 행 / `SCM_MST_SITE_ITEM.DEPT_ID` = 0 → 13 BODY 컴파일 실패 조건 → **실행 전 공유 요청**
   - [C] 시노님/EXECUTE 없음 → 화면에서 PLS-00201 (앱계정 SCMP_APP 에 부여 필요)
2. 해당 파일 실행 — `PKG_NSCM_UI_EXCEL` 은 전 화면 공용이므로 **[A]에 누락이 있을 때만**
3. `@90_VERIFY.sql` — VALID · USER_ERRORS 0 · INVALID 0 · HEADER `2단 OK` · 시노님/EXECUTE
4. BE: `BE_MERGE` 2파일 **클라우드 소스와 diff 병합** 후 빌드·재기동 (파일 통째 덮어쓰기 금지 — 아래 참고)
5. FE: `FE_MERGE` — 클라우드가 공통소스 최신이면 대부분 동일. diff 로 확인 후 차이만 반영
6. **Excel Form 재다운로드**(2단 양식) → `C_TESTDATA` 샘플로 업로드

## BE_MERGE 병합 포인트
- `ExcelUtils.java` — `convertGroupedHeaderExcelToJson` 메서드 (신설, 추가만)
- `FileServiceImpl.java` — `excelFileUplad` 의 파싱부: 2단 판정 우선(`groupedHeader`) → 아니면 기존 `convertExcelToJson`, `cvtListUploadRows(..., groupedHeader)` 날짜행 판별 건너뜀
  - 같은 파일에 DMF0014 1단 날짜헤더 정규화(`normalizeYmdHeader`)·헤더 필수토큰 검증(`validateExcelHeader`)도 들어 있음 — 클라우드판에 이미 있으면 유지, 없으면 함께 반영(DMF0014 업로드 경로)

## 원문 시점 (hook #152)
1x 파일 머리 `SOURCE-FRESH` = 사내 조회시각·LAST_DDL (2026-09-15 16:33). 추출 직전 재조회 FRESH-GATE 통과.
전달 후 24시간이 지났거나 사내 LAST_DDL 이 바뀌었으면 `python build_package.py` 로 재빌드 후 사용.

## 사내 사전 검증 (2026-09-15)
- 1x 파일 = 사내 DB 현재 원문(VALID) 직접 추출 · 사내 로컬 업로드 SUCCESS 10/10 에 쓰인 본문
- 00_PRECHECK 사내 실행: [A] 전 객체 공란 · [B] SAME/SAME · 2단 · [C] MISSING 0 · DEPT_ID 1 · METAL_KEY_VALUE(40) 24 · 시노님/EXECUTE 2/2
- 판정 로직 자가시험: 기대 마커에 가짜 `E20991231-FAKEPROBE` 주입 → `EXPECTED_MISSING` 에 정확히 검출
- `python build_package.py --selftest [--fake]` 로 재현

## 주의
- `13_PKG_DMF0074_PACKAGE_BODY` 에는 타 작업자 변경 `hook#150 (2026-09-06 AJS, TEAM = SCM_MST_SITE_ITEM.DEPT_ID)` 포함 — 클라우드에 `SITE_ITEM.DEPT_ID` 가 없으면 적용 불가([C] 확인).
- 샘플 10행은 사내 데이터 기준 조합. 클라우드에서 **C19(MRF 버전 판매계획 조합 부재)** 오류만 나면 패키지 문제가 아니라 데이터 차이 — 그 행의 End Customer/Model/Site 를 클라우드 실존 조합으로 바꿔 시험.
- 적용 후에도 실패하면 **Error Detail 메시지 전문 또는 BE 로그 ORA 오류**를 알려 주세요 (메시지로 ①~④ 중 어느 축인지 판정 가능).

## 원복
적용 전 클라우드 원문 백업: `SELECT TEXT FROM USER_SOURCE WHERE NAME='<객체>' AND TYPE='<타입>' ORDER BY LINE;` /
EXCEL_COLUMNS: `SELECT * FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0074','DMF0074_40');` 결과 보관.

## 파일
`00_PRECHECK.sql` · `10~13_*.sql` · `30_EXCEL_COLUMNS_DMF0074.sql` · `90_VERIFY.sql` · `_MANIFEST.md` · `BE_MERGE/` · `FE_MERGE/` · `C_TESTDATA/` · `build_package.py`
