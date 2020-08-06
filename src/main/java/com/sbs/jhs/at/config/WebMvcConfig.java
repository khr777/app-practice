package com.sbs.jhs.at.config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration  // 이 어노테이션을 적용하면 스프링부트에서 이 파일을 "설정"파일처럼 맨 처음에 읽어드린다.
public class WebMvcConfig implements WebMvcConfigurer {
	// beforeActionInterceptor 인터셉터 불러오기
	@Autowired
	@Qualifier("beforeActionInterceptor")
	HandlerInterceptor beforeActionInterceptor;  // 필수정보를 입력해놓는 역할

	// needToLoginInterceptor 인터셉터 불러오기
	@Autowired
	@Qualifier("needToLoginInterceptor")
	HandlerInterceptor needToLoginInterceptor;   // 로로그인이 되지 않았으면 되돌려 보내는 역할

	// needToLogoutInterceptor 인터셉터 불러오기
	@Autowired
	@Qualifier("needToLogoutInterceptor")
	HandlerInterceptor needToLogoutInterceptor;   // 로그아웃이 안되어 있으면 다시 돌려보내는 역할

	
	// 이 함수는 인터셉터를 적용하는 역할을 합니다.
	@Override
	public void addInterceptors(InterceptorRegistry registry) { // before~Interceptor가 모든걸 가로챈다.
		// beforeActionInterceptor 를 모든 액션(/**)에 연결합니다. 단 /resource 로 시작하는 액션은 제외
		// beforeActionInterceptor 인터셉터가 모든 액션 실행전에 실행되도록 처리
		// WebMvcConfig class가 실행되는 순서 (1).
		registry.addInterceptor(beforeActionInterceptor).addPathPatterns("/**").excludePathPatterns("/resource/**");
		
		
		//   /resource/**   /resource/common.css 까지 로그인 여부로 관여하면 안된다.
		// 메인, 로그인, 로그인 처리, 가입, 가입 처리, 게시물 리스트, 게시물 상세 빼고는 모두 로그인 상태여야 접근이 가능하다.
		// ★ 로그인 없이도 접속할 수 있는 URI 전부 기술
		// WebMvcConfig class가 실행되는 순서 (2).
		registry.addInterceptor(needToLoginInterceptor).addPathPatterns("/**").excludePathPatterns("/resource/**")
				.excludePathPatterns("/usr/").excludePathPatterns("/usr/member/login").excludePathPatterns("/usr/member/doLogin")
				.excludePathPatterns("/usr/member/join").excludePathPatterns("/usr/member/doJoin")
				.excludePathPatterns("/usr/article/list").excludePathPatterns("/usr/article/detail");

		// 로그인, 로그인처리, 가입, 가입 처리는 로그인 상태일 때 접근할 수 없다.
		// 로그인 상태에서 접속할 수 없는 URI 전부 기술
		// WebMvcConfig class가 실행되는 순서 (3).
		registry.addInterceptor(needToLogoutInterceptor).addPathPatterns("/usr/member/login")
				.addPathPatterns("/usr/member/doLogin").addPathPatterns("/usr/member/join").addPathPatterns("/usr/member/doJoin");

	}
}