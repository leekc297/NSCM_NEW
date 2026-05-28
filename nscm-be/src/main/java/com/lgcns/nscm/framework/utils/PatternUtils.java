package com.lgcns.nscm.framework.utils;


import java.util.List;
import java.util.regex.Matcher;

public class PatternUtils {

    /**
     * Don't let anyone instantiate this class
     */
    private PatternUtils() {}

    /**
     * Java Style의 정규식 패턴의 특수문자들을 escape 시키기 위하여 정의한 정규식 패턴
     */
    private static final java.util.regex.Pattern ESCAPE_PATTERN = java.util.regex.Pattern.compile("([.\\\\\\[\\]^$+{}()|])");

    /**
     * 도스 파일시스템의 wildcard중 *를 Java Style RegExp로 변경하기 위해 사용되는 정규식 패턴
     */
    private static final java.util.regex.Pattern ASTERISK_PATTERN = java.util.regex.Pattern.compile("\\*");

    /**
     * 도스 파일시스템의 wildcard중 ?를 Java Style RegExp로 변경하기 위해 사용되는 정규식 패턴
     */
    private static final java.util.regex.Pattern QUESTION_PATTERN = java.util.regex.Pattern.compile("\\?");

    /**
     * 여러개의 wildcard 적용시 seperator로 사용될 ;를 정의하기 위해 사용되는 정규식 패턴
     */
    private static final java.util.regex.Pattern MULTIPLE_PATTERN = java.util.regex.Pattern.compile(";");


    private static final char[] START_PREFIX = new char[] {'$', '{'};
    private static final char END_SUFFIX = '}';

    /**
     * 주어진 wildcard를 분석하여 Java 정규식 패턴으로 리턴한다.<BR>
     * 대소문자 구분은 하지 않는다.
     *
     * @param wildcard 분석 대상이 될 wildcard 문자열
     * @return Pattern 분석된 자바 정규식 패턴
     */
    public static java.util.regex.Pattern compileWildcardPattern(String wildcard) {
        return compileWildcardPattern(wildcard, false);
    }

    /**
     * 주어진 wildcard 배열을 분석하여 Java 정규식 패턴 배열로 리턴한다.<BR>
     * 대소문자 구분은 하지 않는다.
     *
     * @param wildcard 분석 대상이 될 wildcard 문자열
     * @return Pattern 분석된 자바 정규식 패턴
     */
    public static java.util.regex.Pattern[] compileWildcardPattern(List<String> wildcard) {
        java.util.regex.Pattern[] patterns = new java.util.regex.Pattern[wildcard.size()];
        for (int i = 0; i < wildcard.size(); i++) {
            patterns[i] = compileWildcardPattern(wildcard.get(i).trim(), false);
        }
        return patterns;
    }

    /**
     * 입력된 문자열 값이 지정된 Pattern 값에 매칭되는지 확인한다.
     *
     * @param pattern 검사 패턴
     * @param string 검사할 원본 문자열
     * @return 패턴 일치 여부
     */
    public static boolean matches(java.util.regex.Pattern pattern, String string) {
        return pattern.matcher(string).matches();
    }

    /**
     * 입력된 문자열 값이 지정된 Pattern 배열 값 중 하나에라도 매칭되는지 확인한다.
     *
     * @param patterns 검사 패턴 배열
     * @param string 검사할 원본 문자열
     * @return 패턴 중 최소 하나라도 일치하는지 여부
     */
    public static boolean matches(java.util.regex.Pattern[] patterns, String string) {
        for (java.util.regex.Pattern pattern : patterns) {
            if (pattern.matcher(string).matches()) {
                return true;
            }
        }
        return false;
    }

    /**
     * 주어진 wildcard를 분석하여 Java 정규식 패턴으로 리턴한다.
     *
     * @param wildcard 분석 대상이 될 wildcard 문자열
     * @param ignoreCase wildcard 분석시 대소문자 구분할지를 결정 (true:대소문자 구분)
     * @return Pattern 분석된 자바 정규식 패턴
     */
    public static java.util.regex.Pattern compileWildcardPattern(String wildcard, boolean ignoreCase) {
        String wildcardLocal = wildcard;
        String wildcardPattern;

        Matcher escapeMatcher = ESCAPE_PATTERN.matcher(wildcardLocal);
        wildcardLocal = escapeMatcher.replaceAll("\\\\$1");

        Matcher asteriskMatcher = ASTERISK_PATTERN.matcher(wildcardLocal);
        wildcardLocal = asteriskMatcher.replaceAll("(.*)");

        Matcher questionmarkMatcher = QUESTION_PATTERN.matcher(wildcardLocal);
        wildcardLocal = questionmarkMatcher.replaceAll("(.)");

        Matcher multipleMacher = MULTIPLE_PATTERN.matcher(wildcardLocal);
        wildcardLocal = multipleMacher.replaceAll(")|(");

        wildcardPattern = "(" + wildcardLocal + ")";

        if (!ignoreCase) {
            return java.util.regex.Pattern.compile(wildcardPattern);
        } else {
            return java.util.regex.Pattern.compile(wildcardPattern, java.util.regex.Pattern.CASE_INSENSITIVE);
        }
    }


    /**
     * 입력한 Format 대상을 입력한 값으로 변경
     * @param format String
     * @param replaceTarget String Target of replace
     * @param replaceValue String Value of replace
     * @return String 변경된 결과
     */
    public static String replaceFormatValue(String format, String replaceTarget, String replaceValue) {
        if (format == null) {
            return null;
        }
        if (replaceTarget == null || replaceValue == null) {
            return format;
        }

        StringBuilder result = new StringBuilder();
        StringBuilder replaceName = new StringBuilder();
        StringBuilder orgReplaceTarget = new StringBuilder();
        boolean isStartPrefix = false;
        char[] formats = format.toCharArray();

        for (int idx = 0; idx < format.length(); idx++) {
            if (formats[idx] == START_PREFIX[0] && formats[idx + 1] == START_PREFIX[1]) {
                isStartPrefix = true;
                orgReplaceTarget.append(formats[idx]).append(formats[idx + 1]);
                idx++;
                continue;
            }

            if (isStartPrefix && formats[idx] != END_SUFFIX) {
                replaceName.append(formats[idx]);
                orgReplaceTarget.append(formats[idx]);
                continue;
            }
            else if (isStartPrefix && formats[idx] == END_SUFFIX) {
                orgReplaceTarget.append(formats[idx]);
                if (replaceTarget.contentEquals(replaceName)) {
                    result.append(replaceValue);
                }
                else {
                    result.append(orgReplaceTarget);
                }
                replaceName.delete(0, replaceName.length());
                orgReplaceTarget.delete(0, orgReplaceTarget.length());
                isStartPrefix = false;
                continue;
            }

            result.append(formats[idx]);
        }

        return result.toString();

    }

    /**
     * 파일이름으로 등록이 가능여부를 검증
     * @param name String 입력항목
     * @return boolean
     */
    public static boolean isAcceptableFileName(String name) {
//        return java.util.regex.Pattern.matches("^[0-9a-zA-Z가-힣].*\\s*\\.*$", name);
    	return java.util.regex.Pattern.matches("^[0-9a-zA-Z가-힣](.*[0-9a-zA-Z가-힣])?$", name);
    }

    /**
     * 입력한 파라미터를 이용하여 패턴 생성
     * @param format String
     * @param value int
     * @return String
     */
    public static String formatPattern(String format, int value) {
        return format + "%0" + String.valueOf(value).length() + "d";
    }
}
