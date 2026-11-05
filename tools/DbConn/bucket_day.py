# -*- coding: utf-8 -*-
"""사업부 기본 Bucket 요일 — AS-IS UP_FX_GetCommonDataList 'DefaultBucketDay'(SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='DEFAULT_BUCKET_DAY' SEGMENT1=Division SEGMENT2=WEEKLY|MONTHLY → SEGMENT3) 를
TO-BE 사내오라클에서 같은 기준으로 읽는다(F9 주/월 입력 수량의 일자 배분 검사 · 2026-10-30).

  python tools/DbConn/bucket_day.py <DIVISION> <WEEKLY|MONTHLY|DAILY>   → JSON {"division","bucket","day","src"} (DAILY 는 AS-IS 와 같이 MONTHLY 로 조회)
"""
import json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def main():
    if len(sys.argv) < 3:
        print(json.dumps({'error': 'usage: bucket_day.py <DIVISION> <WEEKLY|MONTHLY|DAILY>'})); return 2
    div, bucket = sys.argv[1].strip(), sys.argv[2].strip().upper()
    seg2 = 'MONTHLY' if bucket == 'DAILY' else bucket
    try:
        from dbconn import connect
        with connect('tobe') as cx:
            cur = cx.cursor()
            cur.execute("SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='DEFAULT_BUCKET_DAY' AND VALID_YN='Y' AND SEGMENT1=:d AND SEGMENT2=:b", d=div, b=seg2)
            r = cur.fetchone()
        print(json.dumps({'division': div, 'bucket': bucket, 'day': (r[0] if r else ''), 'src': "SCM_ADM_LOOKUP_MASTER_DETAIL DEFAULT_BUCKET_DAY SEGMENT1=%s SEGMENT2=%s (AS-IS UP_FX_GetCommonDataList:3734)" % (div, seg2)}, ensure_ascii=False))
        return 0
    except Exception as ex:
        print(json.dumps({'division': div, 'bucket': bucket, 'day': '', 'error': str(ex)[:200]})); return 1


if __name__ == '__main__':
    sys.exit(main())
