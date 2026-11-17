# TO-BE 룰 원장 현황 — 2026-11-17 13:03:52

- 룰 **352**건 = CR 111 · DD 219 · SPR 1 · AG 21 (코드 스캔 파일 230)
- 출처: `tools/Harness/verify/tobe_rule_registry.py --build` 실측 · 원장 `tools/Harness/rules/tobe_rule_registry.csv`
- 현재 원장은 통합 뷰다 — 판정·생성 도구는 아직 원천 CSV 를 읽는다(전환은 EN-11).

## 종류

| 종류 | 건수 |
|---|---|
| TOBE_DIFF | 263 |
| TOBE_DEV | 89 |

## CR 무결성(강제 지점 실측)

| 상태 | 건수 | 뜻 |
|---|---|---|
| NO_ENFORCER | 68 | 코드 어디에도 룰 번호 없음 — ledger 의 산문 기대 행으로만 존재 |
| OK | 29 | 생성 단계 또는 하네스에 연결됨 |
| GEN_UNLINKED | 14 | 코드에 룰 번호는 있으나 생성 단계 미연결(사후 검출만) |

## CR 이 실제로 나타나는 단계(한 룰이 여러 단계에 걸리면 각각 셈)

| 단계 | CR 수 |
|---|---|
| LEDGER | 111 |
| E2E | 25 |
| JUDGE | 19 |
| STATIC | 15 |
| DOC | 2 |
| FE_GATE | 2 |
| VM | 1 |
| SP_GATE | 1 |
| SP_GEN | 1 |
| FE_GEN | 1 |

## 코드에 있는데 원장에 없는 룰 번호 — 0건

- 없음

## judge.py 에 번호로 박힌 CR — 14종 (EN-11 에서 원장 구동으로 전환할 대상)

- `CR-040` : _verify.spec.ts:3767;judge.py:948;ledger.py:437
- `CR-057` : _trace.spec.ts:1069;_trace.spec.ts:1080;_trace.spec.ts:1095;_trace.spec.ts:1097;mergecheck.ts:28;judge.py:2376
- `CR-071` : _trace.spec.ts:410;gen_expect.py:549;judge.py:311;judge.py:316;judge.py:319;judge.py:555;judge.py:906;judge.py:915 …(+22)
- `CR-072` : _verify.spec.ts:683;_verify.spec.ts:834;_verify.spec.ts:835;judge.py:2110;judge.py:2121;judge.py:2123;judge.py:2380;ledger.py:509
- `CR-073` : _trace.spec.ts:1032;_trace.spec.ts:1033;_trace.spec.ts:1036;_trace.spec.ts:1037;judge.py:1497;judge.py:1503;judge.py:1505;make_verify_docs.py:296
- `CR-074` : _trace.spec.ts:1279;judge.py:1489;judge.py:1492;judge.py:1496
- `CR-075` : port_pkg.md:34;judge.py:268;judge.py:291;judge.py:1025;judge.py:1029;judge.py:1032;sort_check.py:284;sort_check.py:310 …(+8)
- `CR-092` : _trace.spec.ts:18;_trace.spec.ts:407;_trace.spec.ts:655;_trace.spec.ts:1365;labelalias.ts:1;gen-e2e.js:270;new_screen.md:19;judge.py:1407 …(+7)
- `CR-093` : griddisp.ts:29;griddisp.ts:32;griddisp.ts:44;griddisp.ts:49;insertpre.ts:95;facts_lockrules.py:258;judge.py:2133;judge.py:2140 …(+4)
- `CR-095` : scenario.ts:4;scenario.ts:45;scenario.ts:50;scenario.ts:51;gen_expect.py:277;gen_expect.py:1124;judge.py:271
- `CR-096` : judge.py:2347;judge.py:2354;judge.py:2355
- `CR-098` : smoke-extra.ts:270;smoke-extra.ts:271;judge.py:408;judge.py:410;judge.py:411;judge.py:414;judge.py:457;judge.py:458 …(+5)
- `CR-104` : _trace.spec.ts:422;_trace.spec.ts:425;judge.py:1215
- `CR-109` : judge.py:2225
