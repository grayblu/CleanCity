package multi.campus.clean.domain;

import javax.validation.constraints.NotEmpty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginInfo {
	@NotEmpty(message="사용자 아이디는 필수 항목입니다.")
	String userid;
	@NotEmpty(message="비밀번호는 필수 항목입니다.")
	String passwd;
	String target; // 리다이렉트할 url
	String reason; // 리다이렉트 된 이유
}
