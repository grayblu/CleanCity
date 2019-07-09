package multi.campus.clean.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminInterceptor extends BaseInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		
		if(session.getAttribute("ADMIN") == null) {
			redirect(request, response, "/user/login", "관리자만 접근할 수 있습니다.");	
			
			return false;
		}
		
		return super.preHandle(request, response, handler);
	}
	
}
