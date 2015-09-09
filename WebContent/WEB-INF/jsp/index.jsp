<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%String path = request.getContextPath(); %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-type" content="text/html; charset=UTF-8">
<title>beexbee</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!-- Le styles -->
<script type="text/javascript" src="<%=path%>/js/jquery-1.10.2.min.js" ></script>
<script type="text/javascript" src="<%=path%>/js/bootstrap.min.js" ></script>
<script type="text/javascript" src="<%=path%>/js/jquery-ui.min.js" ></script>
<script type="text/javascript" src="<%=path%>/js/json2.js" ></script>
<script type="text/javascript" src="<%=path%>/js/jquery.ui.datepicker-zh-CN.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery.PrintArea.js" ></script>
<link rel="stylesheet" href="<%=path%>/css/jquery-ui.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<script type="text/javascript">
$(function() {
	$( "#datepicker" ).datepicker();
	$( "#datepicker" ).datepicker( "option", "dateFormat", "yy-mm-dd" );
	
	
	// 增加姓名
	$('#add').on('click', function() {
		if($('#name').val() == '') {
			alert('姓名不能为空');
			return false;
		}
		if($('#py').val() == '') {
			alert('拼音缩写不能为空');
			return false;
		}
		$.ajax({
			type: 'post',
			data: $('#addForm').serialize(),
			url : 'addUser.html',
			dataType : 'json',
			success : function(result) {
				var htm = '<div class="table-div ' + result.pinyin + '" data-pinyin="' + result.pinyin + '"><input type="checkbox" value="' + result.id
					+ '">  ' + result.name + '<a href="javascript:" data-id="' + result.id + '" style="color: red; text-decoration: none">X</a></div>'
					+ '<div id="'  +  result.id + '" class="table-div">0</div>';
				$('#namelist').append($(htm));
				$('#name').val('');
				$('#py').val('');
			},
			error : function(msg) {
				alert(msg);
				return;
			}
		});
	});
	
	// 拼音查找变色
	$('#pinyin').on('click', function() {
		$('.table-div').css('borderColor', '#2d2a2a');
		var pyj = $('#pyj').val();
		$('.' + pyj).css('borderColor', 'red');
		$('#pyj').val('');
	});
	
	// 蟹按钮
	$('.xie').on('click', function() {
		var box = new Array();
		$this = $(this);
		$(":checkbox").each(function(index, domEle) {
			if(domEle.checked==true) {
				box.push($(domEle).val());
			}
		});
		
		if(box.length == 0) {
			alert("请选择名字");
			return false;
		}
		var num = $this.val()/box.length;
		var temp = "";
		if(num.toString().substring(0, num.length).length >= 3) {
			temp = num.toString().substring(0, num.toString().indexOf(".") + 2);
		}
		
		for(var i = 0; i < box.length; i++) {
			$('#' + box[i]).text(Math.ceil(((parseFloat($('#' + box[i]).text()) + parseFloat(temp))*100))/100);
		}
		$(":checkbox").each(function(index, domEle) {
			domEle.checked=false;
		});
		var tempAttr = $this.attr("id");
		$("#tempAttr").val(tempAttr);
		if(tempAttr == "one") {
			$("#xieOneTemp").val(parseInt($("#xieOneTemp").val()) + 1);
		} else if(tempAttr == "half") {
			$("#xieHalfTemp").val(parseInt($("#xieHalfTemp").val()) + 1);
		} else {
			alert('出错！！！');
			return false;
		}
	});
	
	// 提交单子
	$('#sub').on('click', function() {
		if($("#datepicker").val() == "") {
			alert("请选择单据日期");
			return false;
		}
		
		var flag = false;
		$(".ajax").each(function(index, domEle) {
			if($(domEle).val() != 0) {
				flag = true;
			}
		});
		var record = {// 单品json
				info: []
		};
		$(".table-div:odd").each(function(index, domEle) {
			var temp = {id: null, name: null, price: null, pinyin: null};
			temp.name = (($(domEle).prev().text()).substring(1, ($(domEle).prev().text()).length - 1));
			temp.id = $(domEle).attr("id");
			temp.price = $(domEle).text();
			temp.pinyin = $($(domEle).prev()).data('pinyin');
			record.info.push(temp);
		});
		$('#info').val(JSON.stringify(record));
		if(flag) {
			alert("将提交之前的操作形成新的断点并无法返回！");
			$.ajax({
		  		type: "post",
		  		url: "saveRoUpdateDetail.html",
		  		cache: false,
		  		data: $('#subForm').serialize(),
		  		dataType: "json",
		  		success: function(msg) {
		  			alert("成功保存"+$("#datepicker").val()+"的数据。");
		  			$(".ajax").each(function(index, domEle) {
						$(domEle).val('');
					});
					$("#datepicker").val("");
		  		} 
		    });
		}
	});
	
	// 返回错误断点
	$('#rebuild').on('click', function() {
		$('#namelist').html('');
		var infoHtml = '';
		$.ajax({
	  		type: "get",
	  		url: "rebuildNameList.html",
	  		cache: false,
	  		dataType: "json",
	  		success: function(msg) {
	  			var infoObj = JSON.parse(msg.info);
	  			for(var i = 0; i < infoObj.info.length; i++) {
					infoHtml += '<div class="table-div ' + infoObj.info[i].pinyin + '" data-pinyin="' + infoObj.info[i].pinyin + '"><input type="checkbox" value="' + infoObj.info[i].id
					+ '">  ' + infoObj.info[i].name + '<a href="javascript:" data-id="' + infoObj.info[i].id + '" style="color: red; text-decoration: none">X</a></div>'
					+ '<div id="'  +  infoObj.info[i].id + '" class="table-div">' + infoObj.info[i].price + '</div>';
				} 
	  			$('#namelist').html(infoHtml);
	  		} 
	    });
	});
	
	// 打印表格
	$('#print').on('click', function() {
		$(":checkbox").remove();
		$("a").remove();
		$("#namelist").printArea();
	});
	
	// 打印空表格
	$('#printNull').on('click', function() {
		$(":checkbox").remove();
		$("a").remove();
		$(".table-div:odd").text('');
		$("#namelist").printArea();
	});
	
	// 删除名字
	$('body').on('click', 'a', function() {
		$this = $(this);
		$.ajax({
	  		type: "get",
	  		url: "deleteName.html",
	  		data: 'id=' + $this.data('id'),
	  		cache: false,
	  		dataType: "json",
	  		success: function(msg) {
	  			$this.parent().next().remove();
	  			$this.parent().remove();
	  		} 
	    });
	});
});
</script>
</head>
<body>
<div class="lead">
	<div class="logo">beexbee</div>
	<h4>大海湾提成统计系统</h4>
</div>
<div class="container main">
	<div class="row">
		<div class="col-xs-6 col-md-2 ic-lift">
			<div>
			<button class="btn btn-warning btn-lg col-xs-12 btn-public xie" id="half" value="3.3">
			<span>蟹半打</span>
			</button>
			<button class="btn btn-success btn-lg col-xs-12 btn-public xie" id="one" value="6.2">
			<span>蟹一打</span>
			</button>
			<div class="form-group input-group-lg text-left">
			<form id="subForm">
			    <label>日期：</label>   
				<input class="ajax" id="xieOneTemp" name="one" type="hidden" value="0">
				<input class="ajax" id="xieHalfTemp" name="half" type="hidden" value="0">
				<input class="ajax" id="info" name="detail" type="hidden" value="">
			    <input type="text" class="form-control" id="datepicker" name="orderDate" readonly="readonly">
			    <button type="button" class="btn btn-primary btn-lg" style="margin-top: 10px;" id="sub">
			  <span class="glyphicon glyphicon-ok"></span>  
			    提交</button>
			    </form>
			 </div>
			</div>
			<div class="form-group input-group-lg text-left">
			    <label>拼音简写：</label>
			    <input type="text" class="form-control" id="pyj" placeholder="拼音简写">
			    <button type="button" class="btn btn-primary btn-lg" style="margin-top: 10px;" id="pinyin">
			  <span class="glyphicon glyphicon-search"></span>    
			   查找姓名</button>
			</div>
			<div class="form-group input-group-lg text-left">
			    <label>增加姓名：</label>
			    <form id="addForm">
				    <input type="text" class="form-control" id="name" name="name" placeholder="姓名">
				    <input type="text" class="form-control" id="py" name="pinyin" placeholder="拼音简写">
				    <button type="button" class="btn btn-primary btn-lg" style="margin-top: 10px;" id="add">
			    </form>
			  <span class="glyphicon glyphicon-plus"></span>    
			    增加姓名</button>
			</div>
			<div>
				<button class="btn btn-primary btn-lg col-xs-12 btn-public" id="print">
				<span><span class="glyphicon glyphicon-print"></span>  打印表格</span>
				</button>
				<button class="btn btn-primary btn-lg col-xs-12 btn-public" id="rebuild">
				<span><span class="glyphicon glyphicon-share-alt"></span>  返回最后提交数据</span>
				</button>
				<button class="btn btn-primary btn-lg col-xs-12 btn-public" id="printNull">
				<span><span class="glyphicon glyphicon-print"></span>  打印空名字表格</span>
				</button>
			</div>
		</div>
		<div class="col-xs-12 col-md-9 cta">
		<div id="namelist" style="margin-left: 55px;width: 95%">
			<c:forEach var="user" items="${userList}" varStatus="stat">
				<div class="table-div ${user.pinyin}" data-pinyin="${user.pinyin}"><input type="checkbox" value="${user.id}">  ${user.name}<a href="javascript:" data-id="${user.id}" style="color: red; text-decoration: none">X</a></div>
				<div id="${user.id}" class="table-div">0</div>
			</c:forEach>
		</div>
		</div>
	</div>
</div>
</body>
</html>