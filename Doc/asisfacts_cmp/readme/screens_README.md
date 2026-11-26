# screens: 화면별 결과(Fact Pack)

화면ID마다 폴더 하나입니다(예: `DMF0003`). 화면ID가 없는 공용 파일은 화면 폴더에 들어가지 않습니다.

- `_index.csv`: 화면 전체 목록
  - 파일 수, 현행·구버전 사본 수
  - 엔드포인트, 일치, FoxQuery 없음, 미해결, 주석 호출 건수
  - 컨트롤, 이벤트, 메타 컬럼 수
  - Grid 방식
  - 현행 csproj

화면 폴더의 파일은 만든 단계가 세 가지입니다.

| 단계 | 도구 | 이번 ZIP에서 |
|---|---|---|
| ① 스캔·Pack | `tools/AsisFacts` (`run.ps1` 의 pack) | 2026-11-25 의미 분석 반영본으로 새로 만듦 |
| ② Grid·DB 결합 | `tools/AsisFacts` (`grid.ps1`, Pack 의 DB 결합) | Pack 이 `../db/` 결과로 다시 만듦. `db/` 자체는 이번에 다시 뽑지 않음(2026-10-16 추출본) |
| ③ 검사 하네스 사실 추출 | `tools/Harness/verify/facts_*.py`, `links.py`, `datasets.py`, VM `gen.js` | 이번에 다시 만들지 않음. 각 도구가 마지막으로 실행한 시점의 파일 그대로 |

## 화면 폴더 안 파일

| 파일 | 단계 | 내용 |
|---|---|---|
| `<화면ID>_summary.md` | ① | 사람이 읽는 요약. 파일 구성 → 기능 흐름(진입점 → 메서드 → 엔드포인트 → SP) → 엔드포인트 목록 → 메타 컬럼 → 이벤트 → 컨트롤 → 확인 필요 → 주석 처리된 호출 |
| `files.csv` | ① | 이 화면 소스 파일. variant: current 현행 csproj · legacy 구버전 사본 · only 사본 없음 |
| `members.csv` | ① | 클래스·메서드 선언 |
| `controls.csv`, `props.csv` | ① | 디자이너 컨트롤 트리, 속성 대입 |
| `events.csv` | ① | 이벤트 연결(`+=`) |
| `flow.csv` | ① | 진입점 → 호출 메서드 → 엔드포인트 → SP 흐름 |
| `endpoints.csv` | ① | 이 화면이 쓰는 엔드포인트와 SP, status(`../README.md` status 표) |
| `commented_calls.csv` | ① | 주석 처리된 SP·쿼리 호출(활성 집계 제외) |
| `meta_reads.csv` | ① | DB 메타 컬럼을 읽는 지점 |
| `grid_code.csv` | ① | 코드로 Grid 를 정의하는 호출 |
| `actions.csv` | ① | 이벤트 처리 메서드 본문의 실행 문장 전수(메서드당 1회 기록) |
| `actions_entries.csv` | ① | 진입점별로 어느 메서드에 어떤 호출 조건으로 닿는지(path, call_guard) |
| `actions_summary.csv` | ① | 진입점별 문장 수, 분류율 |
| `dbmeta_<스키마>_<테이블>.csv` | ② | 화면ID가 값으로 들어 있는 메타 테이블 행(예: `SCM_MST_SHEET_COLUMNS`, `TB_FX_MenuItemInfo`) |
| `grid_rule.csv` | ② | 메타 규칙 전개: 컬럼 × Division 표시·필수·기본 선택 |
| `grid_diff.csv` | ② | 메타 규칙과 실제 SP 실행 결과(ROLLBACK) 비교 차이 |
| `grid_effective.csv` | ② | 메타 + 코드 재정의를 합친 Division 별 최종 컬럼 |
| `__asis-actions__.md` | ③ VM `gen.js` | AS-IS 액션 대조표(actions.csv 기반, TO-BE 구현 상태 기입용) |
| `action_links.csv` | ③ `links.py` | 액션 1건이 DB 까지 닿는 연결(홉 단위 1행) |
| `action_data.csv` | ③ `datasets.py` | 액션 → SP 실행 결과셋 연결(`../datasets/`) |
| `cell_rules.csv` | ③ `facts_cellrules.py` | 셀 입력 규칙 |
| `cell_clear.csv` | ③ `facts_cellclear.py` | 값 지움 규칙 |
| `cell_prereq.csv` | ③ `facts_prereq.py` | 입력 선행 조건 |
| `lock_rules.csv` | ③ `facts_lockrules.py` | 편집 잠금 규칙 |
| `sort_rules.csv` | ③ `facts_sortrules.py` | 정렬 규칙 |
| `combo_src.csv` | ③ `facts_combosrc.py` | 콤보 원천(SP, 코드, 인자 식, 필터, 바인딩 메서드) |
| `combo_values.json` | ③ `facts_combovalues.py` | 콤보 원천 후보 값(인자가 모두 리터럴인 원천만 AS-IS DB 에서 조회) |
| `grid_columns_asis.csv` | ③ `facts_gridcols.py` | 정합검증용 AS-IS 그리드 컬럼 선언 |
| `append_tables.csv` | ③ `facts_append_tables.py` | 저장 SP 가 저장마다 새 키로 행을 쌓는 테이블 |
| `edit_expect.csv` | ③ 검사 하네스(`run_verify`) | 편집 가능 기대값 |

화면마다 해당 내용이 없거나 ③ 도구를 아직 돌리지 않았으면 일부 파일이 없습니다.
