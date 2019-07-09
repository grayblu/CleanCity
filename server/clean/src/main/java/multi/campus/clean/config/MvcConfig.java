package multi.campus.clean.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.BeanNameViewResolver;

import multi.campus.clean.interceptor.AdminInterceptor;
import multi.campus.clean.interceptor.LoginInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = { "multi.campus" })
@EnableTransactionManagement
public class MvcConfig implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		// 해당 경로의 파일은 Spring이 해석하지 않음, 정적 파일로 간주
		// css, js, 이미지 등의 정적 파일 배치 위치 등록 - 스프링이 처리 안함
		registry.addResourceHandler("/resources/**") // 적용 경로
				.addResourceLocations("/resources/"); // 웹 경로
	}

	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		// JSP 뷰 리졸버 설정
		// 뷰 이름 앞,뒤에 붙일 prefix, surfix 설정
		registry.viewResolver(new BeanNameViewResolver());
		registry.jsp("/WEB-INF/views/", ".jsp");
	}

	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setDefaultEncoding("utf-8");
		return resolver;
	}

	@Bean
	public LoginInterceptor loginInterceptor() {
		return new LoginInterceptor();
	}

	@Bean
	public AdminInterceptor adminInterceptor() {
		return new AdminInterceptor();
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(loginInterceptor())
			.addPathPatterns(new String[] {"/user/mypage/*"})
			.excludePathPatterns(new String[] {"/"});

		registry.addInterceptor(adminInterceptor())
			.addPathPatterns(new String[] {"/admin/**" })
			.excludePathPatterns(new String[] {});
	}
}