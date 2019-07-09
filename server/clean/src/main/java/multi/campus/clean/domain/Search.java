package multi.campus.clean.domain;

import javax.validation.constraints.NotEmpty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Search {
	@NotEmpty(message="검색 유형을 선택하세요")
	String type;
	String content;
}
