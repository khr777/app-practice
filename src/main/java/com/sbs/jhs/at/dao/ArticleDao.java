package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Reply;

@Mapper
public interface ArticleDao {
	List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);
	
	// 어디에서? articleDao.xml에서.  그리고 articleDao.java에 있으면 xml에 무조건 해당 메서드 쿼리가 있어야 한다. 
	Article getForPrintArticleById(@Param("id") int id); // @Param("id") 의미 : int id를 "id"라는 이름으로 쓸 수 있다.  

	void write(@RequestParam Map<String, Object> param);

	int modify(@RequestParam Map<String, Object> param);

	int softDelete(int id);

	void hitUp(int id);

	void deleteModify(int id);

	int getForPrintListArticlesCount(@RequestParam Map<String, Object> param, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);

	Integer getForPageMoveBeforeArticle(int id);

	Integer getForPageMoveAfterArticle(int id);


	List<Reply> getForPrintReplies(@Param("articleId") int articleId); // @Param("id") 의미 : int id를 "id"라는 이름으로 쓸 수 있다.

	Reply getReply(@Param("id") int id);


	Reply getForPrintReplyById(@Param("id") int id);
	
	
	//코드 최신 전 -> @RequestParam Map<String, Object> param, int id 는 중복?이어서 함께 articleDao로 보낼 수 없는가봄??에러 발생한다. int id 빼니까 오류 안남.
	void modifyReply(Map<String, Object> param);

	//List<Reply> getForPrintRepliesFrom(@Param("id") int id, @Param("from") int from);

	List<Reply> getForPrintRepliesFrom(@RequestParam Map<String, Object> param);

	void writeRelIdUpdate(@Param("relId")int relId);

	Article getArticleById(@Param("id") int id);



}
