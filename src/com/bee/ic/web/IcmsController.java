package com.bee.ic.web;

import com.bee.ic.domain.Detail;
import com.bee.ic.domain.Record;
import com.bee.ic.domain.User;
import com.bee.ic.service.IcmsService;
import com.bee.ic.util.DateUtil;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IcmsController
{

  @Autowired
  private IcmsService icmsService;

  @RequestMapping({"/index"})
  public ModelAndView cindex()
  {
    ModelAndView view = new ModelAndView();
    view.addObject("userList", this.icmsService.getAllUser());
    view.setViewName("index");
    return view;
  }
  @RequestMapping({"/addUser"})
  @ResponseBody
  public User addUser(User user) {
    return this.icmsService.saveUser(user);
  }
  @RequestMapping({"/findPyName"})
  @ResponseBody
  public List<User> findPyName(String py) {
    return this.icmsService.getUserByPy(py);
  }
  @RequestMapping({"/deleteUser"})
  @ResponseBody
  public int deleteUser(Integer id) {
    this.icmsService.deleteUser(id);
    return 1;
  }
  @RequestMapping({"/saveRoUpdateDetail"})
  @ResponseBody
  public int saveRoUpdateDetail(String orderDate, String detail, int one, int half) {
    Date tempDate = DateUtil.stringToDate(orderDate, "yyyy-MM-dd");
    Detail det = this.icmsService.hasDetailByOrderDate(tempDate);
    if (det == null) {
      det = new Detail();
      det.setOrderDate(tempDate);
      det.setXieOne(Integer.valueOf(one));
      det.setXieHalf(Integer.valueOf(half));
      this.icmsService.saveDetail(det);
    } else {
      det.setXieOne(Integer.valueOf(one));
      det.setXieHalf(Integer.valueOf(half));
      this.icmsService.updateDetail(det);
    }

    Record record = this.icmsService.getRecordDate();
    if (record == null) {
      record = new Record();
      record.setInfo(detail);
      record.setNowDate(DateUtil.nowDate("yyyy-MM-dd"));
      this.icmsService.saveRecord(record);
    } else {
      record.setInfo(detail);
      this.icmsService.updateRecord(record);
    }
    return 1;
  }
  @RequestMapping({"/rebuildNameList"})
  @ResponseBody
  public Record rebuildNameList() {
    Record re = this.icmsService.getRecordDate();
    return re;
  }
  @RequestMapping({"/deleteName"})
  @ResponseBody
  public int deleteName(Integer id) {
    this.icmsService.deleteUser(id);
    return 1;
  }
}
