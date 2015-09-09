package com.bee.ic.service;

import com.bee.ic.dao.DetailDao;
import com.bee.ic.dao.RecordDao;
import com.bee.ic.dao.UserDao;
import com.bee.ic.domain.Detail;
import com.bee.ic.domain.Record;
import com.bee.ic.domain.User;
import com.bee.ic.util.DateUtil;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class IcmsService
{

  @Autowired
  private UserDao userDao;

  @Autowired
  private DetailDao detailDao;

  @Autowired
  private RecordDao recordDao;

  public void saveRecord(Record record)
  {
    this.recordDao.save(record);
  }

  public void updateRecord(Record record) {
    this.recordDao.update(record);
  }

  public Record getRecordDate() {
    String hql = "from Record r where r.nowDate = ?";
    List infoList = this.recordDao.find(hql, new Object[] { DateUtil.nowDate("yyyy-MM-dd") });
    if (infoList.size() == 0) {
      return null;
    }
    return (Record)infoList.get(0);
  }

  public User saveUser(User user)
  {
    this.userDao.save(user);
    return user;
  }

  public List<User> getAllUser() {
    return this.userDao.loadAll();
  }

  public List<User> getUserByPy(String py) {
    String hql = "from User u where u.pinyin = ?";
    return this.userDao.find(hql, new Object[] { py });
  }

  public void deleteUser(Integer id) {
    this.userDao.remove((User)this.userDao.get(id));
  }

  public void saveDetail(Detail detail) {
    this.detailDao.save(detail);
  }

  public void updateDetail(Detail detail) {
    this.detailDao.update(detail);
  }

  public Detail hasDetailByOrderDate(Date orderDate) {
    String hql = "from Detail d where d.orderDate = ?";
    List detailList = this.detailDao.find(hql, new Object[] { orderDate });
    if (detailList.size() == 0) {
      return null;
    }
    return (Detail)detailList.get(0);
  }
}