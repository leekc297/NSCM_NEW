# TITLESET COLUMN_WIDTH / CELL_COLOR / TEXT_COLOR 추가 (DB 전용)

> 2026-07-27 | 범위: **DB만** (테이블 컬럼 추가 + 조회/저장 프로시저·PKG 반영). UI/FE 소스 **무변경**.
> 사내 Oracle(OCGSCMD_P01) 적용·검증 완료. 클라우드는 sql/ 을 01→06 순서로 실행.

## 적용 순서

| 파일 | 내용 |
|---|---|
| `01_ddl_titleset_user.sql` | `SCM_MST_TITLESET_USER` +3 컬럼 (COLUMN_WIDTH NUMBER / CELL_COLOR VARCHAR2(30) / TEXT_COLOR VARCHAR2(30)) — 멱등 |
| `02_sp_set_titleset_popup.sql` | **저장** `SCM0002_SET_TITLESET_POPUP` (API_M 배선 대상) — 파라미터 3종 + '^' split + INSERT 7곳 |
| `03_sp_get_titleset_popup.sql` | **조회** `DMF0002_GET_TITLESET_POPUP` (API_M 배선 대상) — 3종 반환 |
| `04a_pkg_scm0002_spec.sql` / `04b_pkg_scm0002_body.sql` | **PKG 저장** `PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP` 동일 반영 |
| `05_pkg_dmf0002_body.sql` | **PKG 조회** `PKG_DMF0002.P_DMF0002_GET_TITLESET_POPUP` 동일 반영 (+기존결함 fix, 아래 참고) |
| `06_proc_m_meta.sql` | `SCM_ADM_PROC_M` — columnWidth(10)/cellColor(11)/textColor(12) 등재, OUT 커서 13/14 재배치 |

## 설계

- 신규 파라미터 3종은 기존 방식과 동일한 **'^' 구분 다건 문자열**, 전부 `DEFAULT NULL` → **하위호환**: 값을 보내지 않는 기존 화면(DMF0003/0021/0044/0048/0082)은 그대로 동작 (검증 완료)
- `COLUMN_WIDTH` 미전달 시 `SCM_MST_SHEET_COLUMNS.COLUMN_WIDTH` 폴백, 색상은 NULL
- 조회는 `USER_COLUMN_WIDTH`(사용자값 우선 + 폴백) / `CELL_COLOR` / `TEXT_COLOR` 3컬럼 추가 반환
- SP 본문은 라이브 소스를 앵커 변환(`build/10·20_*.py`)해 생성 — **기존 로직 재작성 없음**

## 검증 결과 (사내)

- 4개 객체 전부 VALID, 컴파일 에러 0
- 저장→조회 라운드트립: `('DIVISION_ID', 120, '#FFFF00', '#FF0000')`, `('ITEM_ID', 250, '#E0E0E0', '#0000FF')` 정상
- PKG 저장: `('ITEM_ID', 333, '#ABCDEF', '#123456')` 정상 / PKG 조회 3컬럼 노출 확인
- 하위호환(3종 미전달): `(100, NULL, NULL)` — 폴백 정상
- 테스트 행은 전량 삭제 완료

## ⚠ 부수 발견 — PKG_DMF0002 기존 결함 수정

`PKG_DMF0002` body가 `SCM0002_SET_DEFAULT_TITLESET_POPUP`을 **4인자로 호출**(실제는 OUT 커서 포함 5인자)하고 있어, 재컴파일 시 PLS-00306으로 INVALID가 되는 상태였습니다(과거 컴파일본이 VALID로 남아있던 것). 익명 블록으로 지역 커서를 선언해 5인자 호출로 교정했고, 현재 VALID입니다. 로직 변경은 없습니다.

## 미포함 (요청 범위 밖)

- FE/UI 소스 — 화면에서 3종을 입력·표시하려면 별도 FE 작업 필요 (현재는 DB가 값을 받을 준비만 된 상태)
- `SCM0002_SET_DEFAULT_TITLESET_POPUP`(기본값 리셋)은 3종 미반영 — 필요 시 별도 요청
