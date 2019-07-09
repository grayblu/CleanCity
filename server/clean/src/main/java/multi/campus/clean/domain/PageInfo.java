package multi.campus.clean.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageInfo<T> {
	int totalCount;
	int totalPage;
	int page;
	int perCount;
	List<T> list;
}