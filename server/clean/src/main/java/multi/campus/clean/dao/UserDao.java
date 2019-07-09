package multi.campus.clean.dao;

import java.util.List;

import multi.campus.clean.domain.User;

public interface UserDao extends CrudDao<User, String> {
	List<User> getUsers() throws Exception;
	
	List<User> getCollectingList() throws Exception;
}
