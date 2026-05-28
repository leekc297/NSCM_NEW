package com.lgcns.nscm.framework.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import jakarta.servlet.http.HttpServletRequest;

public class RequestUtils {

    /**
     * 클라이언트(Client)의 IP주소를 조회하는 기능
     * @param  request Request객체
     * @return String ip Address IP주소*/
    public static String getClientIP(HttpServletRequest request) {

        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /**
     * 클라이언트(Client)의 OS 정보를 조회하는 기능
     * @param  request Request객체
     * @return String osInfo OS 정보
     */
    public static String getClientOsInfo(HttpServletRequest request) {

        String user_agent = request.getHeader("user-agent");
        return  user_agent.toUpperCase().split(";")[2].split("\\)")[0];

    }

    /**
     * 클라이언트(Client)의 웹브라우저 종류를 조회하는 기능
     * @param  request Request객체
     * @return String webKind 웹브라우저 종류
     */
    public static String getClientWebKind(HttpServletRequest request) {

        String user_agent = request.getHeader("user-agent");

        // 웹브라우저 종류 조회
        String webKind;
        if (user_agent.toUpperCase().contains("GECKO")) {
            if (user_agent.toUpperCase().contains("NESCAPE")) {
                webKind = "Netscape (Gecko/Netscape)";
            } else if (user_agent.toUpperCase().contains("FIREFOX")) {
                webKind = "Mozilla Firefox (Gecko/Firefox)";
            } else {
                webKind = "Mozilla (Gecko/Mozilla)";
            }
        } else if (user_agent.toUpperCase().contains("MSIE")) {
            if (user_agent.toUpperCase().contains("OPERA")) {
                webKind = "Opera (MSIE/Opera/Compatible)";
            } else {
                webKind = "Internet Explorer (MSIE/Compatible)";
            }
        } else if (user_agent.toUpperCase().contains("SAFARI")) {
            if (user_agent.toUpperCase().contains("CHROME")) {
                webKind = "Google Chrome";
            } else {
                webKind = "Safari";
            }
        } else if (user_agent.toUpperCase().contains("THUNDERBIRD")) {
            webKind = "Thunderbird";
        } else {
            webKind = "Other Web Browsers";
        }
        return webKind;
    }

    /**
     * 클라이언트(Client)의 웹브라우저 버전을 조회하는 기능
     * @param  request Request객체
     * @return String webVer 웹브라우저 버전
     */
    public static String getClientWebVer(HttpServletRequest request) {

        String user_agent = request.getHeader("user-agent");

        // 웹브라우저 버전 조회
        String webVer = "";
        String [] arr = {"MSIE", "OPERA", "NETSCAPE", "FIREFOX", "SAFARI"};
        for (String s : arr) {
            int s_loc = user_agent.toUpperCase().indexOf(s);
            if (s_loc != -1) {
                int f_loc = s_loc + s.length();
                webVer = user_agent.toUpperCase().substring(f_loc, f_loc + 5);
                webVer = webVer.replaceAll("/", "").replaceAll(";", "").replaceAll("\\^", "").replaceAll(",", "").replaceAll("//.", "");
            }
        }
        return webVer;
    }


    /**
     * HttpServletRequest 로부터 URI 값 가져오기
     * @return String URI
     */
    public static String getRequestUri(HttpServletRequest request) {
        return request!= null ? request.getRequestURI() : "";
    }

    /**
     * HttpServletRequest 로부터 Servlet Path 값 가져오기
     * @return String Servlet Path
     */
    public static String getServletPath(HttpServletRequest request) {
        return request!= null ? request.getServletPath() : "";
    }


    /**
     * 요청 정보의 Content-Type 을 반환함
     * @return String Request Content-Type
     */
    public static String getContentType(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        return StringUtils.hasLength(request.getContentType()) ? request.getContentType() : "";
    }

    /**
     * 클라이언트 요청 Media Type
     * @return Media Type MediaType of request
     */
    public static MediaType getMediaType(HttpServletRequest request) {
        String contentType = request!= null ? request.getContentType() : "";
        return !"".equals(contentType) ? MediaType.valueOf(contentType) : MediaType.ALL;
    }

    /**
     * HTTP header로부터 referrer 반환
     * @return String Request referrer
     */
    public static String getReferrer(HttpServletRequest request) {
        return request != null ? request.getHeader(HttpHeaders.REFERER) : "";
    }

    /**
     * HttpServletRequest로부터 multipart file 반환
     *
     * @param request HttpServletRequest HTTP 프로토콜의 request 정보
     * @return List MultipartFile의 리스트
     */

    public static List<MultipartFile> getMultipartFile(HttpServletRequest request) {
        MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
        Map<String, MultipartFile> map = mRequest.getFileMap();

        List<MultipartFile> mFiles = new ArrayList<>();
        for (Map.Entry<String, MultipartFile> pairs : map.entrySet()) {
            mFiles.add(pairs.getValue());
        }
        return mFiles;
    }
}
