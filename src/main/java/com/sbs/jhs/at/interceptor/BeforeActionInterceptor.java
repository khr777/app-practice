package com.sbs.jhs.at.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component("beforeActionInterceptor") // 컴포넌트 이름 설정
public class BeforeActionInterceptor implements HandlerInterceptor {

	@Autowired
	@Value("${custom.logoText}")
	private String siteName;  //application.yml에서 정한 이름이 자동으로 주입된다.

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		// 여기에서 구워준 siteName은 모든 jsp에서 사용할 수 있어서 head.jspf에서 사이트 이름으로 활용했다.
		request.setAttribute("logoText", this.siteName);
		
		
		System.out.println("beforeActionInterceptor 실행됨!");

		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}