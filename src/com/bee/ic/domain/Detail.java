package com.bee.ic.domain;

import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="t_detail")
public class Detail extends BaseDomain
{
  private static final long serialVersionUID = 6808237068932777769L;
  private Date orderDate;
  private Integer xieOne;
  private Integer xieHalf;

  public Date getOrderDate()
  {
    return this.orderDate;
  }

  public void setOrderDate(Date orderDate)
  {
    this.orderDate = orderDate;
  }

  public Integer getXieOne()
  {
    return this.xieOne;
  }

  public void setXieOne(Integer xieOne)
  {
    this.xieOne = xieOne;
  }

  public Integer getXieHalf()
  {
    return this.xieHalf;
  }

  public void setXieHalf(Integer xieHalf)
  {
    this.xieHalf = xieHalf;
  }
}