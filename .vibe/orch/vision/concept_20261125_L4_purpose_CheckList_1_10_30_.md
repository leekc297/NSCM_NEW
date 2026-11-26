# 개념 재정립: CheckList 시간 목적의 Overall Review 판정(효력 전 자료로 어긋남 연속 → 효력 뒤 실측으로만 판정)

## 목적(사용자 원문)
- 2026-11-20 지시(memory feedback_checklist_speed_accuracy_first_20261120.md): "CHECKLIST 는 10분에서 진짜 길어야 30분 내에 종료되어야 한다", "대체적인 방법으로 정합성에 문제가 되지 않으면 대체방법을 사용해서 시간을 줄이는 것에 동의하지만 정합성에 문제가 되는 것이라면 방법으로 고려해서는 안됩니다", "중복판단여부는 AI 가 판단"
- U2 2026-11-20 03:48: "화면1개에 대한 CHECKLIST 작업이 4시간 이상 소요된다는건 필요한 시점에 CHECKLIST 작업을 돌려서 볼 수 없다는 것과 동일합니다"
- 2026-11-20 지시(memory project_checklist_one_run_loop_20261120.md): "CHECKLIST 단계에서 미검증이 없어질때까지 한번에"
- 10-31 지시(memory feedback_no_guess_answers.md): "절대 감이나 예측으로 대답하지 않도록 해주세요. rule hook 하네스에 공통 적용"

## 지금 개념
CheckList 시간 목적이 맞는지 하루 1번 Overall Review(tools/VibeManager/orch-vision.js)가 판정함. 입력은 Doc/verify/<ID>/run_timing.json 마지막 줄(orch-vision.js:51 checklistTiming)과 digest7d S8.checklistRun(48행)이고, 판정 값은 맞음, 어긋남, 미확인 3가지임(75행, 88행). 진단 사다리 L4-1(orch-ladder.js:97-100)은 vision 폴더 판정 JSON 최근 12개에서 같은 목적의 '어긋남'이 3회 이어지면 L4 로 올림. 근거 시각과 같은 목적 개선안의 효력 시각(effMsOf, 77행)은 비교하지 않음. L3 판정(87~94행)과 L3→L4 올림(106~121행)은 effMsOf 로 효력 뒤 근거만 셈.

정리하면 지금 개념은 '마지막으로 기록된 소요가 30분을 넘으면 어긋남'임. 그 소요가 지금 실행 방식의 결과인지는 보지 않음.

## 어긋난 근거
| 사례 | 근거 | L3/L4 조치 | 그 뒤 |
|---|---|---|---|
| Overall Review 11-20 11:58 어긋남 | run_timing wall_min SCP0005 136.7, SCP0028 78.5, SSP0005 209.3, SSP0014 74.8분. S13 U2 경고 4건 | 20261121120359_VISION(재측정 단위, applied, appliedMs 1795414234680) | 반영 뒤 부분 재측정 0건. 효과 미측정 |
| Overall Review 11-21 12:03 어긋남 | events.jsonl:2001 SCP0028 ms_run 18571542(309.5분). 1차 측정 3954초, 부분 재측정 3회 4887+3854+3053초 | 같은 안 | 같음 |
| Overall Review 11-22 14:05 어긋남 | digest7d 26건 중앙값 1862.6초, p90 12908.3초. 2001줄 뒤 체인 종료 0건이라 '새 측정 없음'을 근거 문장에 적고도 어긋남으로 판정 | 20261123000419_VISION(30분 시계를 측정 1회와 문서 1판까지로, 보완 회차 반복) 승인 대기 | 아래 행 |
| Overall Review 11-23 14:54 어긋남 | 11-22 와 같은 수치. 근거 문장에 '새 측정 없음' 기록 | 20261123000419_VISION 반영 완료 2026-11-23 15:58:21(이력). quick.json 체인 checklist 와 checklist-delta 의 --no-docs 다음 --docs 순서 반영(quick.json:150,157,195,208,263,270,308,321). orch-usercheck.js chainTarget 1판 판정 반영 | 반영 뒤 CheckList chain.start, chain.end 0건(events.jsonl 3048~4125줄 체인 줄 10건 = usermanual 6, opsmanual 2, asislive 2). 1판 소요 미측정 |
| 이번 묶음 | ladder 묶음 firstAt 2026-11-22T14:06:36, lastSeenAt 2026-11-25T00:00:36, 근거 4건 모두 15:58:21 효력 전 | 없음 | 새 Overall Review 가 같은 효력 전 자료로 어긋남을 내는 동안 묶음이 참으로 남음 |

목적과 지금 개념이 어긋난 곳은 판정 규칙임. 실행 방식이 바뀐 뒤 실행이 0건이라 1판 30분 충족 여부는 측정 근거가 없음. Overall Review 가 '새 측정 없음'을 알면서 어긋남을 내는 것은 feedback_no_guess_answers 의 '못 쟀으면 미측정' 규칙과도 맞지 않음.

## 대안 개념
### A 효력 뒤 실측으로만 목적 판정, 실측 없으면 '실측 대기'
- 개념: CheckList 시간 목적의 판정 자료는 같은 목적 L4 개선안(20261123000419_VISION)의 효력 시각 뒤에 끝난 CheckList 체인의 1판 소요(chainTarget firstDocMin)임. 효력 뒤 실행이 0건이면 verdict = 미확인(사유 '실측 대기: 효력 뒤 CheckList 0건')으로 내고, L4-1 연속 횟수에서 효력 전 근거의 판정은 세지 않음
- 목적 충족: '필요한 시점에 볼 수 있어야'를 지금 방식의 1판 실측으로 잼. 실측이 없을 때 같은 진단을 반복하는 AI 호출이 없어짐
- 사례 변화: 이번 묶음 근거 4건은 효력 전이라 연속 0회가 되어 L4 에 오르지 않음. 다음 CheckList 1판이 30분을 넘으면 그 Overall Review 부터 어긋남이 쌓임
- 새로 할 일: orch-vision.js 입력에 효력 시각과 효력 뒤 checklist 체인 목록(runId, firstDocMin, chainMin) 추가. 지시문에 CheckList 시간 목적 판정 규칙 1-2 추가(1-1 styleRule 과 같은 형식). orch-ladder.js L4-1 에 근거 시각 > 같은 목적 L4 안 effMsOf 거름 추가. Overview 사다리 카드에 '실측 대기' 표시
- 버리는 것: run_timing.json 마지막 줄과 7일 digest 를 시점 구분 없이 목적 판정에 쓰는 것

### B 판정 규칙 유지, 사용자가 CheckList 1회 실행해 실측을 만듦
- 개념: 코드는 그대로 두고 다음 CheckList 실행으로 run_timing.json 과 digest 를 새 자료로 바꿈
- 목적 충족: 1판 실측 1건이 생김
- 사례 변화: 실행 전까지 매일 같은 효력 전 자료로 어긋남과 L4 진단이 반복됨. 실행 뒤에도 Overall Review 는 run_timing wall_min(체인 전체)을 보므로 1판이 30분 안이어도 체인 전체가 길면 어긋남이 이어짐. 20261123000419_VISION 이 정한 시계(1판)와 판정 시계(체인 전체)가 다른 문제가 남음
- 새로 할 일: 없음. CheckList 실행은 사용자 몫(vm-orchestra.md:35)
- 버리는 것: 없음

### C 목적 판정을 체인 전체 시계로 되돌림
- 개념: 30분을 체인 전체(보완 회차 포함)에 다시 댐
- 목적 충족: 사용자 원문 '종료되어야 한다'를 글자대로 봄
- 사례 변화: 20261123000419 개념 문서의 측정값(부분 재측정 1회 고정 소요 1657~1852초)으로는 보완 회차 1번만 있어도 30분을 넘음. 회차나 검사를 빼야 맞출 수 있어 feedback_checklist_speed_accuracy_first 금지 예(검사 항목·시험 빼기)에 걸림
- 판단: 채택하지 않음

## 권장안과 이유
A 를 권장함.
- 근거 4건이 모두 효력 전이고 효력 뒤 CheckList 실행이 0건이라, 지금 개념이 틀렸다는 측정 근거가 없음
- L3 판정과 L3→L4 올림은 이미 effMsOf 를 씀. A 는 L4-1 을 같은 규칙에 맞춤
- 판정 시계를 20261123000419_VISION 이 정한 1판 시계와 맞춤. B 는 두 시계가 달라 실행 뒤에도 어긋남이 남음
- 승인 대기 20261124000457_VISION(L4-2 지적 건수에 효력 거름)과 같은 목적임. 하나로 묶어 단계 원장(plans.json) 1건으로 진행하고 20261124000457_VISION 은 흡수함

## 전환(바뀌는 것 · 버리는 것 · 단계 · 확인 · 위험 · 되돌리기)
- 바뀌는 것: tools/VibeManager/orch-vision.js(입력 51행 근처, 지시문 75~76행 근처), tools/VibeManager/orch-ladder.js L4-1(97~100행), L4-2(101~105행, 흡수분), tools/VibeManager/orchestra.js 사다리 카드 표시, tools/VibeManager/test/t_orch_ladder.js, tools/VibeManager/test/t_orch_vision.js(없으면 새로)
- 버리는 것: 효력 전 자료로 내린 어긋남을 L4 연속 횟수에 세는 것. 시점 구분 없는 run_timing 마지막 줄 판정
- 단계 1: orch-ladder.js L4-1 에 목적 키와 같은 축 L4 안(제목 또는 묶음 key 의 목적, 연결 근거를 evidence 에 남김)의 effMsOf 를 구해 그보다 앞선 판정 run 은 연속 횟수에서 뺌. 확인 = 이번 묶음 근거 4건(11-20~11-23 14:54)과 효력 2026-11-23 15:58:21 표본에서 L4|purpose|CheckList화면1개10분길어야30분안에 가 나오지 않음, 효력 뒤 어긋남 3건 표본은 나옴
- 단계 2: orch-vision.js 입력에 checklistEffect { effAt, runsAfter: [{runId, firstDocMin, chainMin}] } 를 넣고 지시문에 규칙 1-2(효력 뒤 실행 0건 = 미확인 '실측 대기', firstDocMin > checklistTargetMin = 어긋남, 이하 = 맞음, chainMin 은 표시만) 추가. 확인 = 지시문 생성 시험에서 1-2 줄과 입력 필드 존재, events.jsonl:2001 형식 표본에서 runsAfter 0건
- 단계 3: 20261124000457_VISION 의 L4-2 효력 거름을 이 원장 단계로 흡수해 반영. 확인 = 그 안의 t_orch_ladder.js 표본(U2, U24, U25 와 효력 표본)이 L4|useraxis|checklistTime 을 내지 않음
- 단계 4: Overview 사다리 카드에 '실측 대기: 다음 CheckList 1회 필요' 표시. 확인 = orchestra.js 렌더 시험
- 단계 5(관찰, 사용자 실행): 다음 CheckList 1회 뒤 Overall Review 판정이 firstDocMin 으로 나왔는지 vision 판정 JSON 의 evidence 로 확인. 30분을 넘으면 plan_20261123000419_VISION.md 3단계(1차 측정 동시 실행, ledger_diff.py 차이 0건 조건)로 감
- 위험: 목적 키와 L4 안 연결이 틀리면 다른 목적 개선안의 효력이 어긋남을 가림. 연결한 안 id 를 묶음 근거와 판정 evidence 에 적어 확인함. CheckList 실행이 계속 없으면 목적 충족 여부가 '실측 대기'로 오래 남음. 사다리 카드 표시로 보이게 함
- 되돌리기: harness.json orch.l4PlanEnabled false 로 단계 원장 끔. 단계마다 반영 백업과 .bak_<날짜>_concept 사본으로 orch-vision.js, orch-ladder.js, orchestra.js, 시험 파일 복원. VMO 개선안 탭 되돌리기

## 반증
- A 가 틀렸다면 효력 뒤 CheckList 실행이 0건인데 사용자가 같은 목적으로 새로 지적함(user_checks 새 항목, 시각 2026-11-23 15:58 뒤). 이 경우 판정 자료를 실측만으로 두는 것이 늦은 것이므로 사용자 지적 1건을 L4 근거로 넣는 규칙이 다음 대상임
- 1판 시계가 틀렸다면 다음 실행에서 firstDocMin ≤ 30 인데 사용자가 CheckList 가 늦다고 지적함. 이 경우 대안 C 를 정합성 조건 안에서 다시 검토함
- 효력 거름이 틀렸다면 효력 뒤 실행에서 firstDocMin > 30 이 나왔는데도 L4-1 이 오르지 않음. 단계 1 시험의 효력 뒤 표본으로 확인함

## 미확인
- 20261123000419_VISION 의 appliedMs 가 null 임. effMsOf(orch-improve effectiveMsOf)가 이 안의 효력 시각을 history '반영 완료' 15:58:21 로 얻는지 미확인
- 2026-11-23 14:54 뒤 Overall Review 판정 JSON 이 vision 폴더에 없음(마지막 20261123_145412.json). ladder lastSeenAt 2026-11-25 00:00 은 같은 4건으로 다시 참이 된 것으로 읽었으나 meta.json 의 그 뒤 실행 기록은 확인하지 않음
- 1판 실소요: 반영 뒤 CheckList 실행 0건이라 미측정
- 20261121120359_VISION 재측정 단위 변경 효과: 반영 뒤 부분 재측정 0건이라 미측정
- orch-ladder.js openPlanFor 가 묶음 key 축(CheckList화면1개10분길어야30분안에)과 useraxis 축(checklistTime)을 같은 축으로 보는지: axisOfKey(246행)는 key 뒤 문자열만 비교하므로 다른 축으로 봄. 단계 3 흡수는 대상 파일 겹침(orch-ladder.js)으로 이뤄지는지 시험으로 확인 필요