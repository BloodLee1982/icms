package com.bee.ic.domain;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="t_user")
public class User extends BaseDomain
{
  private static final long serialVersionUID = -51116215795692613L;
  String name;
  String pinyin;

  public String getName()
  {
    return this.name;
  }

  public void setName(String name)
  {
    this.name = name;
  }

  public String getPinyin()
  {
    return this.pinyin;
  }

  public void setPinyin(String pinyin)
  {
    this.pinyin = pinyin;
  }
}
