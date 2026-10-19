# Recon — 개발대상 대사표

개발대상 목록(xlsx) · As-is 파싱(AsisFacts) · To-Be(TobeFacts/소스/Oracle 메타) · 하네스 산출(gen/check/gap/문서/골든/E2E) 을 한 표로 대사해 **누락을 기계적으로 찾는다.**

```
python xlsx_to_csv.py          # Doc\Next SCM 개발대상_*.xlsx, UP_SP_DEV_STATUS_*.xlsx → Doc\recon\_input\*.csv + rules\map_screen.csv
node recon.js                  # → Doc\recon\대사표_화면.csv / 대사표_SP.csv / 대사표_시트.csv / 대사표.md / index.html
```

| 표 | 행 | 판정 |
|---|---|---|
| 화면 | 개발대상 ∪ As-is 파싱 ∪ To-Be 페이지 | OK / 누락-파싱 / 누락-ToBe / 대상외(-구현됨) / ToBe신규 / 재확인(GAP<60·BLOCK) |
| SP | 개발대상 SP ∪ 파싱 SP (화면별) | OK / 누락-ToBe / 공통(제외) / 대상외 + `파싱미검출(타화면 검출|전체 미검출)` · `목록외` |
| 시트 | UI_Detail 시트 ∪ grid_effective 시트 | OK / 누락-시트 / 누락-ToBe화면 / 미확인(메타 필요) |

- `rules/map_screen.csv` — As-is ID ≠ To-Be MENU_ID 짝(SCM0008→SYS0011, GSCM_USERINFO→SYS0002 …). xlsx 에서 생성하며 `source=manual` 행은 보존. gap.js/gen.js 도 이 표로 짝을 찾는다.
- 공통 화면(GSCM_USERINFO 등)은 파일명에 ID 가 없어 Pack 이 `TB_FX_ProgramInfo`(ProgramID↔ClassName) 별칭으로 screen_id 를 보정한다(AsisFacts Pack.cs).
- To-Be SP 매칭: `Doc\tobefacts\db\proc_meta.csv`(export_tobe_meta.py) 우선, 없으면 `To-be_v2_converted\06_Packages\*.sql` 의 PROCEDURE 선언.
- 시트 "미확인(메타 필요)" 는 `sheet_columns.csv` 를 내려받으면 OK/누락-시트로 재판정된다.
