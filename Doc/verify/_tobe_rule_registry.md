# TO-BE 룰 원장 현황 — 2026-11-19 13:40:58

- 룰 **356**건 = CR 115 · DD 219 · SPR 1 · AG 21 (코드 스캔 파일 239)
- 출처: `tools/Harness/verify/tobe_rule_registry.py --build` 실측 · 원장 `tools/Harness/rules/tobe_rule_registry.csv`
- 현재 원장은 통합 뷰다 — 판정·생성 도구는 아직 원천 CSV 를 읽는다(전환은 EN-11).

## 종류

| 종류 | 건수 |
|---|---|
| TOBE_DIFF | 267 |
| TOBE_DEV | 89 |

## CR 무결성(강제 지점 실측)

| 상태 | 건수 | 뜻 |
|---|---|---|
| NO_ENFORCER | 66 | 코드 어디에도 룰 번호 없음 — ledger 의 산문 기대 행으로만 존재 |
| OK | 33 | 생성 단계 또는 하네스에 연결됨 |
| GEN_UNLINKED | 16 | 코드에 룰 번호는 있으나 생성 단계 미연결(사후 검출만) |

## CR 이 실제로 나타나는 단계(한 룰이 여러 단계에 걸리면 각각 셈)

| 단계 | CR 수 |
|---|---|
| LEDGER | 115 |
| E2E | 29 |
| JUDGE | 22 |
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

- `CR-029` : smoke-extra.ts:416;smoke-extra.ts:421;smoke-extra.ts:422;smoke-extra.ts:436;judge.py:1331;judge.py:1354;judge.py:1355
- `CR-040` : _verify.spec.ts:3974;judge.py:1003;ledger.py:437
- `CR-057` : _trace.spec.ts:1144;_trace.spec.ts:1155;_trace.spec.ts:1170;_trace.spec.ts:1172;mergecheck.ts:34;judge.py:3042
- `CR-071` : _trace.spec.ts:431;gen_expect.py:552;judge.py:315;judge.py:320;judge.py:323;judge.py:610;judge.py:961;judge.py:970 …(+23)
- `CR-073` : _trace.spec.ts:1107;_trace.spec.ts:1108;_trace.spec.ts:1111;_trace.spec.ts:1112;judge.py:1878;judge.py:1884;judge.py:1886;make_verify_docs.py:296
- `CR-074` : _trace.spec.ts:1354;eg_auth.spec.ts:508;eg_auth.spec.ts:509;judge.py:1870;judge.py:1873;judge.py:1877
- `CR-075` : port_pkg.md:34;judge.py:272;judge.py:295;judge.py:1085;judge.py:1089;judge.py:1092;sort_check.py:284;sort_check.py:310 …(+8)
- `CR-093` : griddisp.ts:29;griddisp.ts:32;griddisp.ts:44;griddisp.ts:49;insertpre.ts:95;facts_lockrules.py:258;judge.py:2758;judge.py:2765 …(+5)
- `CR-095` : scenario.ts:4;scenario.ts:50;scenario.ts:55;scenario.ts:56;gen_expect.py:280;gen_expect.py:1127;judge.py:275
- `CR-096` : judge.py:2225;judge.py:2227;judge.py:3013;judge.py:3020;judge.py:3021
- `CR-098` : smoke-extra.ts:358;smoke-extra.ts:359;judge.py:412;judge.py:414;judge.py:415;judge.py:418;judge.py:461;judge.py:462 …(+5)
- `CR-104` : _trace.spec.ts:443;_trace.spec.ts:446;judge.py:1589
- `CR-109` : judge.py:2872
- `CR-113` : judge.py:2660;judge.py:2668;judge.py:2669
