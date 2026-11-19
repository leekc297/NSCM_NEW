# TO-BE 룰 원장 현황 — 2026-11-18 20:34:26

- 룰 **353**건 = CR 112 · DD 219 · SPR 1 · AG 21 (코드 스캔 파일 238)
- 출처: `tools/Harness/verify/tobe_rule_registry.py --build` 실측 · 원장 `tools/Harness/rules/tobe_rule_registry.csv`
- 현재 원장은 통합 뷰다 — 판정·생성 도구는 아직 원천 CSV 를 읽는다(전환은 EN-11).

## 종류

| 종류 | 건수 |
|---|---|
| TOBE_DIFF | 264 |
| TOBE_DEV | 89 |

## CR 무결성(강제 지점 실측)

| 상태 | 건수 | 뜻 |
|---|---|---|
| NO_ENFORCER | 67 | 코드 어디에도 룰 번호 없음 — ledger 의 산문 기대 행으로만 존재 |
| OK | 30 | 생성 단계 또는 하네스에 연결됨 |
| GEN_UNLINKED | 15 | 코드에 룰 번호는 있으나 생성 단계 미연결(사후 검출만) |

## CR 이 실제로 나타나는 단계(한 룰이 여러 단계에 걸리면 각각 셈)

| 단계 | CR 수 |
|---|---|
| LEDGER | 112 |
| E2E | 27 |
| JUDGE | 20 |
| STATIC | 15 |
| DOC | 2 |
| FE_GATE | 2 |
| VM | 1 |
| SP_GATE | 1 |
| SP_GEN | 1 |
| FE_GEN | 1 |

## 코드에 있는데 원장에 없는 룰 번호 — 0건

- 없음

## judge.py 에 번호로 박힌 CR — 13종 (EN-11 에서 원장 구동으로 전환할 대상)

- `CR-029` : smoke-extra.ts:416;smoke-extra.ts:421;smoke-extra.ts:422;smoke-extra.ts:436;judge.py:1331;judge.py:1354;judge.py:1355
- `CR-040` : _verify.spec.ts:3899;judge.py:1003;ledger.py:437
- `CR-057` : _trace.spec.ts:1144;_trace.spec.ts:1155;_trace.spec.ts:1170;_trace.spec.ts:1172;mergecheck.ts:28;judge.py:2973
- `CR-071` : _trace.spec.ts:431;gen_expect.py:552;judge.py:315;judge.py:320;judge.py:323;judge.py:610;judge.py:961;judge.py:970 …(+22)
- `CR-073` : _trace.spec.ts:1107;_trace.spec.ts:1108;_trace.spec.ts:1111;_trace.spec.ts:1112;judge.py:1876;judge.py:1882;judge.py:1884;make_verify_docs.py:296
- `CR-074` : _trace.spec.ts:1354;eg_auth.spec.ts:508;eg_auth.spec.ts:509;judge.py:1868;judge.py:1871;judge.py:1875
- `CR-075` : port_pkg.md:34;judge.py:272;judge.py:295;judge.py:1085;judge.py:1089;judge.py:1092;sort_check.py:284;sort_check.py:310 …(+8)
- `CR-093` : griddisp.ts:29;griddisp.ts:32;griddisp.ts:44;griddisp.ts:49;insertpre.ts:95;facts_lockrules.py:258;judge.py:2692;judge.py:2699 …(+5)
- `CR-095` : scenario.ts:4;scenario.ts:47;scenario.ts:52;scenario.ts:53;gen_expect.py:280;gen_expect.py:1127;judge.py:275
- `CR-096` : judge.py:2944;judge.py:2951;judge.py:2952
- `CR-098` : smoke-extra.ts:358;smoke-extra.ts:359;judge.py:412;judge.py:414;judge.py:415;judge.py:418;judge.py:461;judge.py:462 …(+5)
- `CR-104` : _trace.spec.ts:443;_trace.spec.ts:446;judge.py:1589
- `CR-109` : judge.py:2806
