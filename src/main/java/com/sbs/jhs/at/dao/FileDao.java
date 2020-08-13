package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.File;

@Mapper
public interface FileDao {

	void save(Map<String, Object> param);
	void changeRelId(@Param("id") int id, @Param("relId") int relId);

	List<File> getFiles(@Param("relTypeCode") String relTypeCode, @Param("relIds") List<Integer> relIds,
			@Param("typeCode") String typeCode, @Param("type2Code") String type2Code, @Param("fileNo") int fileNo);

	File getFileById(@Param("id") int id);

	void deleteFiles(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId);
	
	
	File getFile(String relTypeCode, int id, String typeCode, String type2Code, int fileNo); // 잉 이거 중복 있는 듯
	File getFileByRelId(@Param("relId") int relId,@Param("fileNo") int fileNo);
	
	void update(Map<String, Object> param);
}
