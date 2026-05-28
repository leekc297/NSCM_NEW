package com.lgcns.nscm.framework.utils;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.StandardCharsets;

public class StringUtils {

    /**
     *  값을 double 형으로 변환 한다 값이 없는 경우는 0을 반환
     * @param value : 변환할 값
     * @return : 변환된 값
     */
    public static double parseStringToDouble(Object value) {
        if (value == null) {
            return 0;
        } else {
            String StringValue = value.toString();
            return StringValue.isEmpty() ? 0 : Double.parseDouble(StringValue);
        }
    }

    /**
     *  값을 Long 형으로 변환 한다 값이 없는 경우는 0을 반환
     * @param value : 변환할 값
     * @return : 변환된 값
     */
    public  static long parseStringToLong(Object value) {

        if (value == null) {
            return 0;
        } else {
            String StringValue = value.toString();
            return StringValue.isEmpty() ? 0 : Long.parseLong(StringValue);
        }
    }

    /**
     *  값을 Int 형으로 변환 한다 값이 없는 경우는 0을 반환
     * @param value : 변환할 값
     * @return : 변환된 값
     */
    public  static int parseStringToInt(Object value) {

        if (value == null) {
            return 0;
        } else {
            value = Math.round(parseStringToDouble(value));
            String StringValue = value.toString();
            return StringValue.isEmpty() ? 0 : Integer.parseInt(StringValue);
        }
    }

    /**
     *  값에 소수점이 몇자리까지 표현되었는지를 확인하여 소수점 이하 자리수의 숫자 형식을 반환
     * @param value : 확인할 값
     * @return : 숫자 형식을 반환
     */
    public static String parsePointFormat(String value) {
        String numberFormatInfo = "";
        if (!value.contains(".")) {
            numberFormatInfo = "#,##0";
        } else {
            String[] spitValues = value.split("\\.");
            numberFormatInfo = "#,##0."+ "0".repeat(spitValues[1].length());
        }
        return numberFormatInfo;
    }

    /**
     *  주소 값에 / 를 . 으로 변환하며 마지막에 Stream  문자를 제외
     * @param value : 호출 경로
     * @return : steam 문자를 제외한 경로
     */
    public static String makeSqlIdFromUrl(String value) {
        String[] reBuildUrlList = value.split("/");
        StringBuilder sbUrl = new StringBuilder();
        int reBuildUrlListSize =  reBuildUrlList.length;
        for (int urlCount =0;urlCount<reBuildUrlListSize;  urlCount++) {

            if (reBuildUrlListSize - 1 == urlCount && reBuildUrlList[urlCount].equalsIgnoreCase("stream")) {
                continue;
            } else {
                if (!reBuildUrlList[urlCount].isEmpty()){
                    if (!sbUrl.isEmpty()){
                        sbUrl.append(".");
                    }
                    sbUrl.append(reBuildUrlList[urlCount]);
                }
            }
        }
        return sbUrl.toString();
    }

    /**
     * @MethodName : cutStringByBytes
     * @Description: 문자열을 maxBytes 변수의 상수로 제한
     * <pre>
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param value
     * @param      : @param maxBytes
     * @param      : @return
     * @return     : String
     */
    public static String cutStringByBytes(String value, int maxBytes) {
        if (value == null || value.isEmpty()) return value;

        byte[] strBytes = value.getBytes(StandardCharsets.UTF_8);
        if (strBytes.length <= maxBytes) {
            return value;
        }

        // 바이트 단위로 자른 뒤, 깨진 글자가 없도록 다시 문자열로 변환
        // CharBuffer를 이용하면 마지막 글자가 깨지는 현상을 방지할 수 있습니다.
        ByteBuffer bbuf = ByteBuffer.wrap(strBytes, 0, maxBytes);
        CharBuffer cbuf = StandardCharsets.UTF_8.decode(bbuf);
        return cbuf.toString();
    }
}
