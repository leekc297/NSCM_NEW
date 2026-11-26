# framework_actions: 공통 프레임워크 메서드 실행 문장

화면이 부르는 `01.Framework` 아래 공통 메서드(예: `DataService.GetDMInnerTable`)의 본문을 문장 단위로 꺼낸 것입니다. switch case 별 필터와 엔드포인트가 들어 있습니다.
화면 폴더의 `actions.csv` 에서 공통 메서드 호출(CALL_EXT, COMBO_DATA)을 이 파일로 이어 엔드포인트·SP 까지 따라갈 수 있습니다.

| 파일 | 내용 |
|---|---|
| `actions.csv` | 공통 메서드 본문의 실행 문장 전수(메서드당 1회 기록) |
| `actions_entries.csv` | 메서드별로 어느 메서드에 어떤 호출 조건으로 닿는지(path, call_guard) |
| `actions_summary.csv` | 메서드별 문장 수, 분류율 |

Pack 을 화면 지정 없이 전체로 실행할 때만 다시 만듭니다.
