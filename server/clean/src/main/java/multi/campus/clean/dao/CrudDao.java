package multi.campus.clean.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface CrudDao<M, K> {
	int count() throws Exception;
	
	List<M> getPage(@Param("start") int start, @Param("end") int end) throws Exception;
	
	M findById(K k) throws Exception;
	
	Integer insert(M m) throws Exception;
	
	int update(M m) throws Exception;
	
	int delete(K k) throws Exception;
}
