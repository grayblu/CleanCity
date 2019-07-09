package multi.campus.clean.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import multi.campus.clean.dao.GarbageCollectionDao;
import multi.campus.clean.domain.GarbageCollection;
import multi.campus.clean.domain.PageInfo;

@Repository
public class GarbageCollectionServiceImpl implements GarbageCollectionService {
	@Autowired
	GarbageCollectionDao dao;
	
	static final int PER_PAGE_COUNT = 10;
	
	@Override
	public PageInfo<GarbageCollection> getPage(int page) throws Exception {
		int start = (page-1) * PER_PAGE_COUNT;
		int end = start + PER_PAGE_COUNT;
		int totalCount = dao.count();
		
		List<GarbageCollection> list = dao.getPage(start, end);
				
		return new PageInfo<>(totalCount, (int)Math.ceil(totalCount / (double)PER_PAGE_COUNT), page, PER_PAGE_COUNT, list);
	}

	@Override
	public PageInfo<GarbageCollection> getUserCollection(int page, String userid) throws Exception {
		int start = (page-1) * PER_PAGE_COUNT;
		int end = start + PER_PAGE_COUNT;
		int totalCount = dao.userCount("%"+userid+"%");
		
		List<GarbageCollection> list = dao.getUserCollectionPage(start, end, "%"+userid+"%");
		
		return new PageInfo<>(totalCount, (int)Math.ceil(totalCount / (double)PER_PAGE_COUNT), page, PER_PAGE_COUNT, list);
	}
	
	@Override
	public PageInfo<GarbageCollection> getRegionCollection(int page, String region) throws Exception {
		int start = (page-1) * PER_PAGE_COUNT;
		int end = start + PER_PAGE_COUNT;
		System.out.println("지역 > " + region);
		int totalCount = dao.regionCount("%"+region+"%");
		System.out.println("사이즈 > " + totalCount);
		List<GarbageCollection> list = dao.getRegionCollectionPage(start, end, "%"+region+"%");
		System.out.println(list);
		
		return new PageInfo<>(totalCount, (int)Math.ceil(totalCount / (double)PER_PAGE_COUNT), page, PER_PAGE_COUNT, list);
	}
	
	@Override
	public Integer create(GarbageCollection garbageCollection) throws Exception {
		System.out.println("추가 하기 전 >> " + garbageCollection);
		return dao.insert(garbageCollection);
	}

	@Override
	public int update(int collectionNo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean delete(int collectionNo) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

}
