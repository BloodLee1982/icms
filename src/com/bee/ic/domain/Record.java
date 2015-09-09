package com.bee.ic.domain;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="t_record")
public class Record extends BaseDomain
{
  private static final long serialVersionUID = -1186369925825640993L;
  private String info;
  private Date nowDate;

  @Column(columnDefinition="TEXT", nullable=true)
  public String getInfo()
  {
    return this.info;
  }

  public void setInfo(String info)
  {
    this.info = info;
  }

  public Date getNowDate()
  {
    return this.nowDate;
  }

  public void setNowDate(Date nowDate)
  {
    this.nowDate = nowDate;
  }
}