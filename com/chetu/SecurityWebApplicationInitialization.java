package chetu;

import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;

public class SecurityWebApplicationInitialization extends AbstractSecurityWebApplicationInitializer{

	
	public SecurityWebApplicationInitialization() {
		super(WebSecurityConfig.class);
	}

	
}
