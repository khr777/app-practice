package com.sbs.jhs.at.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.controller.FileController;
import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.util.Util;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ArticleServiceImpl implements ArticleService {

	@Autowired
	private ArticleDao articleDao;
	@Autowired
	private FileService fileService;

	@Override
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom,
			String searchKeywordType, String searchKeywordTypeBody, String searchKeyword) { // getList();

		List<Article> articles = articleDao.getForPrintArticles(param, itemsInAPage, limitFrom, searchKeywordType,
				searchKeywordTypeBody, searchKeyword);

		return articles;
	}

	@Override
	public Article getForPrintArticleById(int id) {

		Article article = articleDao.getForPrintArticleById(id);
		
		

		File file = fileService.getFileById(article.getId());

		if (file != null) { // null 이 아니라는 의미는 파일이 존재한다는 것.
			article.getExtra().put("file__common__attachment__1", file);
			// 파일이 존재한다면 댓글의 extra에 "file__~~" 변수명으로 file을 저장하는 것.
		}

		

		return article;
	}

	@Override
	public int write(Map<String, Object> param) { // add

		articleDao.write(param);

		int id = Util.getAsInt(param.get("id"));

		// 이 값이 존재한다는거 자체가 댓글만 입력된게 아닌 파일첨부된 댓글이 입력된 것임을 알 수 있다.
		// fileIdsStr로 Ids 복수형을 보아 파일이 1개가 아닌 여러개가 전송될 수도 있겠구나. 여러개 첨부 가능하구나. 라고 유추할 수
		// 있다.
		String fileIdsStr = (String) param.get("fileIdsStr");

		// 몰라도 되는 코드이지만 의미하는 바는? 파일이 여러개일 경우 파일 번호를 ,기준으로 쪼개서 한 곳에 모으는 작업을 하는 코드
		if (fileIdsStr != null && fileIdsStr.length() > 0) {
			List<Integer> fileIds = Arrays.asList(fileIdsStr.split(",")).stream().map(s -> Integer.parseInt(s.trim()))
					.collect(Collectors.toList());

			// 1. 파일이 먼저 생성된 후에, 관련 데이터가 생성되는 경우에는, file의 relId가 일단 0으로 저장된다.
			// 2. 그것을 뒤늦게라도 이렇게 고처야 한다.
			// 3. 최초 셋팅한 fileId는 0 이고, 파일이 생성되어야 relId를 알 수 있으니 마지막 쯤에 update로 relId를 입력해주는
			// 것!
			// 4. 먼저 발송, 저장된 파일의 관련 relId 셋팅해주어야 댓글에서 파일을 불러올 수 있다. 그렇지 않으면 파일 보여지지 않는다.
			for (int fileId : fileIds) {
				fileService.changeRelId(fileId, id);
			}

		}

		return id;
	}

	@Override
	public int modify(@RequestParam Map<String, Object> param, int id) {
		int a = articleDao.modify(param);
		return a;
	}

	@Override
	public int softDelete(int id) {
		int a = articleDao.softDelete(id);
		return a;
	}

	@Override
	public void hitUp(int id) {
		articleDao.hitUp(id);

	}

	@Override
	public void deleteModify(int id) {
		articleDao.deleteModify(id);

	}

	@Override
	public int getForPrintListArticlesCount(@RequestParam Map<String, Object> param, String searchKeywordType,
			String searchKeywordTypeBody, String searchKeyword) {
		return articleDao.getForPrintListArticlesCount(param, searchKeywordType, searchKeywordTypeBody, searchKeyword);
	}

	@Override
	public Integer getForPageMoveBeforeArticle(int id) {
		return articleDao.getForPageMoveBeforeArticle(id);
	}

	@Override
	public Integer getForPageMoveAfterArticle(int id) {
		return articleDao.getForPageMoveAfterArticle(id);
	}

	@Override
	public Map<String, Object> getReplyDeleteAvailable(int id) {
		Reply reply = getReply(id);
		return null;
	}

	@Override
	public Reply getReply(int id) {
		return articleDao.getReply(id);
	}

	@Override
	public Reply getForPrintReplyById(int id) {
		Reply reply = articleDao.getForPrintReplyById(id);

		return reply;
	}

	@Override
	public List<Reply> getForPrintReplies(@RequestParam Map<String, Object> param) {

		List<Reply> replies = articleDao.getForPrintRepliesFrom(param);

		Member actor = (Member) param.get("actor");

		System.out.println("articleService's member : " + actor);

		for (Reply reply : replies) {

			// 출력용 부가데이터를 추가한다.
			updateForPrintInfo(actor, reply);
		}

		return replies;

	}

	public void updateForPrintInfo(Member actor, Reply reply) {
		reply.getExtra().put("actorCanDelete", actorCanDelete(actor, reply));
		reply.getExtra().put("actorCanModify", actorCanModify(actor, reply));

	}

	// 액터가 해당 댓글을 수정할 수 있는지를 알려준다.
	public boolean actorCanModify(Member actor, Reply reply) {
		return actor != null && actor.getId() == reply.getMemberId() ? true : false;
	}

	// 액터가 해당 댓글을 삭제할 수 있는지를 알려준다.
	public boolean actorCanDelete(Member actor, Reply reply) {
		return actorCanModify(actor, reply);
	}

}
