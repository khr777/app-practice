package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.Reply;

@Mapper
public interface ReplyDao {

 
	List<Reply> getForPrintRepliesFrom(Map<String, Object> param);

	void writeReply(Map<String, Object> param);

	void softDeleteReply(@Param("id") int id);

	Reply getForPrintReplyById(@Param("id") int id);

	void modifyReply(Map<String, Object> param);

}
