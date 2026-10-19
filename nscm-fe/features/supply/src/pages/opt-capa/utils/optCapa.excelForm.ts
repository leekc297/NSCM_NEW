import { EXCEL_FORM_HEADER_TOKENS } from '../opt-capa.constants';

/**
 * No Work Excel Form(업로드 양식) 생성 — AS-IS `BtnExcelForm_Click`(cs:3841-3844) 대체 경로.
 *
 * AS-IS 는 HelpServer 의 고정 파일 `NoWork_ExcelForm.xls` 를 HTTP GET 으로 내려준다
 * (`BaseForm.cs:5300-5311`). TO-BE 에는 그 파일 호스팅이 없으므로 표준(hook #135)대로
 * `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰으로 클라에서 만든다(design 01 §5 V-6).
 *
 * 계약의 핵심은 **1행 헤더 문자열**이다 — BE `FileServiceImpl.cvtListUploadRows` 가 토큰명으로
 * 헤더를 이름 조회하므로 1바이트라도 다르면 그 열이 전량 탈락한다(무증상 유실). 그래서 라벨을
 * 새로 만들지 않고 `EXCEL_FORM_HEADER_TOKENS` 를 그대로 header·key 로 쓴다.
 *
 * 데이터행은 **없다** — AS-IS 도 빈 양식을 내려준다.
 */
export const buildExcelFormColumns = (): { header: string; key: string }[] =>
  EXCEL_FORM_HEADER_TOKENS.map(token => ({ header: token, key: token }));

/** 양식 행 — 헤더만 있는 파일이라 빈 배열이다(`flatExcelDownload` 가 헤더는 columns 로 그린다). */
export const buildExcelFormRows = (): Record<string, string>[] => [];
