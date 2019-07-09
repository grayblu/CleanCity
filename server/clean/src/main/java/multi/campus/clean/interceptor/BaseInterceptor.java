package multi.campus.clean.interceptor;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;

public class BaseInterceptor extends HandlerInterceptorAdapter {
	@Autowired
	ServletContext context;
	
	//redirect할 url 문자열 생성
	String getUrl(HttpServletRequest request) {
		String url = request.getRequestURI().substring(context.getContextPath().length());
		String query = request.getQueryString();
		
		if(query != null) {
			url = url + "?" + query;
			System.out.println(url);
		}
		
		return url;
	}
	
	// redirect시 전달할 정보를 flash attribute로 등록
	void saveFlash(HttpServletRequest request, HttpServletResponse response, String target, String reason) {
		FlashMap flashMap = new FlashMap();
		flashMap.put("target", target);
		flashMap.put("reason", reason);
		System.out.println("리다이렉트시 타겟 > " + target +", 이유 > " + reason);
		FlashMapManager flashMapManager = RequestContextUtils.getFlashMapManager(request);
		flashMapManager.saveOutputFlashMap(flashMap, request, response);
	}
	
	// 지정한 url로 redirect 요청
	void redirect(HttpServletRequest request, HttpServletResponse response, String target, String reason) throws Exception {
		String url = getUrl(request);
		saveFlash(request, response, url, reason);
		System.out.println("리다이렉트시 타겟url > " + url +", 이유 > " + reason);
		response.sendRedirect(context.getContextPath() + target);
	}
}
