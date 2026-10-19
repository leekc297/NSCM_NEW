# Excel Upload 헤더 불일치 메시지 — "Invalid Column Header Title" (2026-09-22)

> ✅ **완료 처리 (사용자 2026-09-22)** — 이후 보완은 UI 개발자가 진행 예정.
> 현재 상태: 사내 DB MSG01151 변경 적용 / 로컬 BE 3파일 변경 적용·재기동(미커밋) / 클라우드 미적용.
> 사용자 제공 파일 `C:\TRANFILE\RECEIVE\DMF0014_Template_20260915_110612.xlsx` 실측:
> 원본 → `Invalid Column Header Title` ↵ `Diviion*, Custoer Project*` / 헤더만 고친 사본 → 헤더 통과(데이터 오류 3건 — 헤더 무관).

## 요청
DMF0014 Excel Upload 헤더가 다르면 메시지 = "Invalid Column Header Title".
DMF0074 · DMF0082 Excel Upload 도 헤더가 다르면 같은 메시지. (MSG01151 문구를 바꾸는 방식 — 사용자 제안 채택)

## 종전 동작 (실측)
- 공통 `FileServiceImpl.validateExcelHeader` 가 HEADER_CONTENT 의 `*` 토큰만 대조.
  DMF0014 → `Error excelFileUplad: 엑셀 파일의 Header 정보 확인 후 재 Upload 하세요! (누락된 필드: Sales Site*)`
- DMF0074 / DMF0074_40 / DMF0082 는 `*` 토큰 0개 → **헤더 검사 자체가 없어** 틀린 헤더도 통과.

## 변경
| 축 | 파일 | 내용 |
|---|---|---|
| DB | `01_MSG01151_UPDATE.sql` (사내 적용 완료) | MSG01151 KO/EN/CN = `Invalid Column Header Title` (멱등 MERGE, 감사컬럼 admin). 원복 = `00_BACKUP_MSG01151.sql` |
| BE | `nscm-be/src/main/java/com/lgcns/nscm/general/file/FileServiceImpl.java` | 대상 4 formId(DMF0014 / DMF0074 / DMF0074_40 / DMF0082)만: 헤더 불일치 → MSG01151 문구(세션 언어, 미등록 시 기본 문구)로 중단, 접두어 없이 전달. 검사 토큰 = `*` 있으면 `*` 토큰(DMF0014 — 뒤 기간 컬럼 동적) / 없으면 전 토큰(DMF0074·DMF0082). 누락 목록은 BE 로그(warn)에만 |
| BE | `nscm-be/src/main/resources/sql/admin/Excel.xml` | `selectMessageNm` 추가 (MSG_ID 1건, 세션 언어 → EN → 그 외) |
| BE | 동 `FileServiceImpl.java` (2차, 사용자 추가 요청) | 메시지 **아래 줄에 잘못된 헤더명 나열** — 엑셀에 적힌 헤더 중 양식 토큰·기간(날짜) 컬럼·빈 헤더가 아닌 것, 파일 컬럼 순서. 2단 양식은 `그룹명_하위명`. 잘못 적힌 헤더 없이 컬럼만 빠진 경우엔 빠진 헤더명 |
| BE | `nscm-be/src/main/java/com/lgcns/nscm/framework/utils/ExcelUtils.java` | 행 Map 3곳 `HashMap` → `LinkedHashMap` (파일 컬럼 순서 보존 — 위 나열 순서용. 후속 처리는 키 조회·명시 정렬만 해서 동작 무변화) |
| FE | 없음 | 3화면 모두 공용 FcstUploadModal 이 `res.data.message` 를 그대로 alert |

대상 외 화면: 코드 경로 불변 (`*` 토큰 검사 + 기존 문구·접두어).

## 검증 (로컬 BE 재기동 + 사내 DB, mode=0 검증만 — 저장 없음)
| 케이스 | 결과 |
|---|---|
| A DMF0014 `Sales Site*`→`Sales Sitee*` | 500 / `Invalid Column Header Title` |
| B DMF0014 정상 헤더 | 200 / SUCCESS 1 |
| C DMF0074 정상 양식 (`C:\TRANFILE\RECEIVE\DMF0074_Template_20260915_111214.xlsx`) | 200 / 16건 (종전과 동일 Past Date) |
| D DMF0074 그룹명 `Key`→`Keyy` | `Invalid Column Header Title` |
| E DMF0074 하위명 Period(Fr) `Co`→`Coo` | `Invalid Column Header Title` |
| F DMF0074 단일 컬럼 `Energy`→`Enegy` | `Invalid Column Header Title` |
| H DMF0082 정상 19컬럼 | 200 / SUCCESS 1 (mode=0 → 원장 기록 0 확인) |
| I DMF0082 `Model`→`Modell` | `Invalid Column Header Title` |
| 대상 외 대조 (DMF0013/DMF0003/SSP0018/DMF0081) | 계정 업로드 권한 없음(403) — 실호출 대조 불가, 코드 경로로만 확인 |

2차(잘못된 헤더명 나열) 재검증 — BE 재기동 14:03:
| 케이스 | 응답 message |
|---|---|
| A DMF0014 | `Invalid Column Header Title` ↵ `Sales Sitee*` |
| D DMF0074 그룹명 | ↵ `Keyy_Ni, Keyy_Co, Keyy_Li2CO3, …` (7개) |
| E DMF0074 하위명 | ↵ `Period(Fr)_Coo` |
| F DMF0074 단일 | ↵ `Enegy` |
| I DMF0082 | ↵ `Modell` |
| DMF0014 3곳 동시 오류 | ↵ `Plant Sitee*, Incoterm*, Measure Grp*` (파일 순서) |
| DMF0014 컬럼 삭제 | ↵ `Customer Project*` (빠진 헤더명) |
| 정상 B / C / H | 종전과 동일 통과 |

- DMF0074_40 (div 40 양식) 은 실파일 미검증 — DMF0074 와 같은 경로.
- 화면(브라우저) 확인 미실행.

## 클라우드 (미적용)
DB `01_MSG01151_UPDATE.sql` + BE 3파일(FileServiceImpl.java · Excel.xml · ExcelUtils.java) **함께** 반영.
BE 파일은 공통소스라 클라우드판과 diff 병합(통째 덮어쓰기 금지). BE 만 올리면 MSG01151 이 구 문구로 나오고, DB 만 올리면 변화 없음.
