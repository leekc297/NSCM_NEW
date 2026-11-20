# TO-BE 룰 원장 현황 — 2026-11-20 08:22:33

- 룰 **357**건 = CR 116 · DD 219 · SPR 1 · AG 21 (코드 스캔 파일 261)
- 출처: `tools/Harness/verify/tobe_rule_registry.py --build` 실측 · 원장 `tools/Harness/rules/tobe_rule_registry.csv`
- 현재 원장은 통합 뷰다 — 판정·생성 도구는 아직 원천 CSV 를 읽는다(전환은 EN-11).

## 종류

| 종류 | 건수 |
|---|---|
| TOBE_DIFF | 267 |
| TOBE_DEV | 90 |

## CR 무결성(강제 지점 실측)

| 상태 | 건수 | 뜻 |
|---|---|---|
| NO_ENFORCER | 65 | 코드 어디에도 룰 번호 없음 — ledger 의 산문 기대 행으로만 존재 |
| OK | 34 | 생성 단계 또는 하네스에 연결됨 |
| GEN_UNLINKED | 17 | 코드에 룰 번호는 있으나 생성 단계 미연결(사후 검출만) |

## CR 이 실제로 나타나는 단계(한 룰이 여러 단계에 걸리면 각각 셈)

| 단계 | CR 수 |
|---|---|
| LEDGER | 116 |
| E2E | 30 |
| JUDGE | 25 |
| STATIC | 16 |
| DOC | 2 |
| FE_GATE | 2 |
| VM | 1 |
| SP_GATE | 1 |
| SP_GEN | 1 |
| FE_GEN | 1 |

## 코드에 있는데 원장에 없는 룰 번호 — 0건

- 없음

## judge.py 에 번호로 박힌 CR — 17종 (EN-11 에서 원장 구동으로 전환할 대상)

- `CR-029` : smoke-extra.ts:419;smoke-extra.ts:424;smoke-extra.ts:425;smoke-extra.ts:439;judge.py:1516;judge.py:1539;judge.py:1540
- `CR-040` : _verify.spec.ts:4027;judge.py:1181;ledger.py:437
- `CR-057` : _trace.spec.ts:1152;_trace.spec.ts:1163;_trace.spec.ts:1178;_trace.spec.ts:1180;mergecheck.ts:34;judge.py:3313
- `CR-065` : labelalias.ts:47;labelalias.ts:65;smoke-extra.ts:116;judge.py:1155;judge.py:1165
- `CR-071` : _trace.spec.ts:432;gen_expect.py:552;judge.py:330;judge.py:335;judge.py:338;judge.py:738;judge.py:1089;judge.py:1098 …(+23)
- `CR-073` : _trace.spec.ts:1115;_trace.spec.ts:1116;_trace.spec.ts:1119;_trace.spec.ts:1120;judge.py:2065;judge.py:2071;judge.py:2073;make_verify_docs.py:319
- `CR-074` : _trace.spec.ts:1362;eg_auth.spec.ts:522;eg_auth.spec.ts:523;judge.py:2057;judge.py:2060;judge.py:2064
- `CR-075` : port_pkg.md:34;judge.py:287;judge.py:310;judge.py:1263;judge.py:1267;judge.py:1270;sort_check.py:288;sort_check.py:314 …(+8)
- `CR-084` : insertpre.ts:95;facts_lockrules.py:258;facts_lockrules.py:781;judge.py:3011;judge.py:3015;judge.py:3016;snap_validate.py:117
- `CR-093` : griddisp.ts:29;griddisp.ts:32;griddisp.ts:44;griddisp.ts:49;insertpre.ts:95;facts_lockrules.py:258;judge.py:3002;judge.py:3009 …(+8)
- `CR-095` : scenario.ts:4;scenario.ts:50;scenario.ts:55;scenario.ts:56;gen_expect.py:280;gen_expect.py:1127;judge.py:290
- `CR-096` : judge.py:2420;judge.py:2422;judge.py:3284;judge.py:3291;judge.py:3292;popup_args_check.py:523;popup_args_check.py:526
- `CR-098` : smoke-extra.ts:361;smoke-extra.ts:362;judge.py:427;judge.py:429;judge.py:430;judge.py:433;judge.py:476;judge.py:477 …(+5)
- `CR-104` : _trace.spec.ts:444;_trace.spec.ts:447;judge.py:1776
- `CR-109` : judge.py:3138
- `CR-113` : judge.py:2904;judge.py:2912;judge.py:2913
- `CR-116` : judge.py:1448;judge.py:1454
