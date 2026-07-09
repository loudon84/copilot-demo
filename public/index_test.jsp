<%@page import="com.landray.kmss.crm.client.util.CrmClientUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<%
    //获取当前创建人对象
    if (UserUtil.checkRole("ROLE_SDMSOM_ADMIN")) {// 管理员权限
        request.setAttribute("isROLE", "1");
    }else{
        request.setAttribute("isROLE", "0");	 //非管理员权限
    }
    pageContext.setAttribute("fdUser", UserUtil.getUser().getFdNo());

%>
<template:include ref="default.simple" pagewidth="95%">
    <template:replace name="head">
        <%@ include file="/sys/ui/jsp/jshead.jsp" %>
        <script type="text/javascript">
            seajs.use(['theme!form']);
        </script>
    </template:replace>
    <template:replace name="body">
        <div class="layui-container-fluid">
            <div class="container-wrap">
                <form class="layui-form layui-form-pane f-form" id='searchForm' lay-filter='searchForm'
                      action="javascript:;">
                    <div class='layui-row layui-col-space1 task-row search-model'>
                            <%-- <div class="layui-inline">
                                <label class="layui-form-label" style="font-size: larger; width: 70px;">状态</label>
                                <div class="layui-inline">
                                    <xform:select property="docStatus" showStatus="edit">
                                        <xform:enumsDataSource enumsType="crm_quote_doc_status"/>
                                    </xform:select>
                                </div>
                            </div> --%>
                        <div class="layui-inline">
                            <label class="layui-form-label" style="font-size: larger;">订单筛选</label>
                            <div class="layui-inline">
                                <c:choose>
                                    <c:when test="${ isROLE == '1' }">
                                        <select id="customer" name="customer">
                                            <option value="1" selected>我的订单</option>
                                            <option value="2" >所有订单</option>
                                        </select>
                                    </c:when>
                                    <c:when test="${ isROLE == '0' }">
                                        <select id="customer" name="customer">
                                            <option value="1" selected>我的订单</option>
                                        </select>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label" style="font-size: larger;">交易主体</label>
                            <div class="layui-inline">
                                <select id="orgCode" name="orgCode">
                                    <option value=""></option>
                                    <option value="101">101_芯智国际有限公司</option>
                                    <option value="102" >102_深圳市芯智科技有限公司</option>
                                    <option value="103" >103_芯云有限公司</option>
                                    <option value="104" >104_深圳市芯云信息科技有限公司</option>
                                    <option value="112" >112_SMART-CORE CLOUD PTE. LTD.</option>
                                    <option value="114" >114_芯达科技有限公司</option>
                                    <option value="115" >115_芯智科技股份有限公司</option>
                                    <option value="141" >141_志鼎有限公司</option>
                                    <option value="142" >142_深圳市志鼎科技有限公司</option>
                                    <option value="145" >145_SMART-CORE CLOUD PTE. LTD.</option>
                                    <option value="146" >146_芯智株式会社</option>
                                    <option value="148" >148_芯联有限公司</option>
                                    <option value="149" >149_深圳市芯联信息技术有限公司</option>
                                    <option value="151" >151_深圳市极眸智能有限责任公司</option>
                                    <option value="153" >153_新加坡公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label" style="font-size: larger;">日期区间</label>
                            <div class="layui-inline">
                                <select id="dateRange" name="dateRange">
                                    <option value="1">近半年</option>
                                    <option value="2" >近一年</option>
                                    <option value="3" >全部</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label" style="font-size: larger;">关键字搜索</label>
                            <div class="layui-inline" style="width: 220px;">
                                <input type="search" name="keyword" autocomplete="off" class="layui-input" title="精准搜索订单号、模糊搜索(客户名称、销售、订单类型、审批状态)"
                                       onchange="FDChange(this.value);" placeholder="精准、模糊搜索"/>
                            </div>
                            <input type="hidden" name="searchGj">
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn-sm" lay-submit lay-filter="data-search-btn"
                                    id="searchBtn_">
                                <i class="layui-icon">&#xe615;</i>
                                查询
                            </button>
                        </div>
                    </div>
                    <input type="hidden" name="fdUser" value="${fdUser}" />
                </form>
                <table id="ListTb" style="width: 90%" lay-filter="currentTableFilter">

                </table>
                <!-- 表头工具栏  -->
                <script type="text/html" id="table_toolbar">
                    <button class="layui-btn layui-btn-sm" lay-event="add" onclick="addDoc()">
                        <i class="layui-icon">&#xe608;</i> ${lfn:message('button.add')}
                    </button>
                    <button class="layui-btn layui-btn-sm" lay-event="add" onclick="getUpLoadTemp()">
                        <i class="layui-icon">&#xe608;</i> 订单批量更新
                    </button>
                    <button class="layui-btn layui-btn-sm" lay-event="add" onclick="getUpBrandAuthTemp()">
                        <i class="layui-icon">&#xe608;</i> 品牌权限批量更新
                    </button>
                    <button type="button" id="btnAiAnalytic" class="layui-btn layui-btn-sm">

                        <i class="layui-icon">&#xe608;</i> 模板识别
                    </button>
                    <button class="layui-btn layui-btn-sm" lay-event="att" onclick="getAttPerTemp()">
                        <i class="layui-icon">&#xe601;</i> 附件批量下载
                    </button>
                </script>
                <!-- 表格工具栏  -->
                <script type="text/html" id="barDemo">
                    <!-- <button class="layui-btn layui-btn-xs" lay-event="detailOrder">审批</button>-->
                    <button class="layui-btn layui-btn-xs layui-bg-red" lay-event="approvalAddre"  onmouseout="closeTip()" ><i class="layui-icon layui-icon-chrome" ></i>OA审批</button>
                    {{# if(d.apprStatusCode != 'CANCELLED') { }}

                    {{# } }}

                    {{# if(d.apprStatusCode == 'CANCELLED' || d.apprStatusCode == 'CANCELLING' || d.apprStatusCode == 'INPROCESSING' || d.apprStatusCode == 'REJECTED' || d.apprStatusCode == 'REPROCESS'){ }}
                    <button class="layui-btn layui-btn-xs layui-btn-disabled" lay-event="addOrder"  onmouseout="closeTip()" ><i class="layui-icon layui-icon-addition" ></i>新增行</button>
                    {{# } else { }}
                    <button class="layui-btn layui-btn-xs" lay-event="addOrder"  onmouseout="closeTip()" ><i class="layui-icon layui-icon-addition" ></i>新增行</button>
                    {{# } }}

                    <!-- {{# if(d.apprStatusCode != 'NEW' && d.apprStatusCode != 'CANCELLED') { }}
                         <button class="layui-btn layui-btn-xs" lay-event="editOrder" onmouseover="showTip('订单编辑', this)"  onmouseout="closeTip()" ><i class="layui-icon layui-icon-util" ></i></button>
                         <button class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delOrder" onmouseover="showTip('整单取消', this)"  onmouseout="closeTip()" ><i class="layui-icon layui-icon-delete" ></i></button>
                    {{# } }}-->

                </script>
                <script type="text/html" id="rank">
                    {{d.LAY_TABLE_INDEX+1}}
                </script>
            </div>
        </div>
        <!--         <script src="/crm/resource/layui/layui.all.js"></script>
        <link rel="stylesheet" href="/crm/resource/layui/css/layui.css" media="all"> -->
        <script src="/sdms/common/resource/layui/layui.js"></script>
        <link rel="stylesheet" href="/sdms/common/resource/layui/css/layui.css" media="all">
        <script src="/sdms/common/resource/js/crm-lite-jssdk.js"></script>
        <script>
            layui.use(['table', 'form','jquery'], function () {
                var table = layui.table;
                var form = layui.form;
                var $ = layui.jquery;

                var parentConfig  = "测试";
                //第一个实例
                table.render({
                    elem: '#ListTb',
                    toolbar: '#table_toolbar',
                    limit: 15,
                    skin: 'row',
                    size: 'sm',
                    even: true //隔行换色
                    ,
                    defaultToolbar: ['filter', {
                        title: '刷新' //标题
                        ,
                        layEvent: 'refresh' //事件名，用于 toolbar 事件中使用
                        ,
                        icon: 'layui-icon-refresh' //图标类名
                    }],
                    limits: [10, 15, 20, 25, 50, 100],
                    theme: '#1E9FFF',
                    url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=getTableDetailData' //数据接口
                    ,
                    page: true //开启分页
                    ,
                    height: 'full-40'//固定高度-即固定表头固定第一行首行
                    ,
                    cols: [[ //表头
                        {
                            type: "checkbox",
                            width: 40,
                            fixed: 'left'
                        },{
                            title: "${ lfn:message('crm-ds:crmDsTemple.fdOrder') }",
                            width: 60,
                            templet: '#rank',
                            fixed: 'left',
                            type: 'numbers'
                        }, {
                            field: 'fdId',
                            title: 'ID',
                            width: 0,
                            hide: true
                        }, {
                            field: 'orderNumber',
                            title: '订单编号',
                            align:'center',
                            fixed: 'left',
                            sort: true,
                            width: 130,
                            templet: function (d) {
                                return '<a class="com_btn_link" onclick="openJyView(' + "'" + d.headerId + "'" + ')" href="javascript:void(0);">' + d.orderNumber + '</a>';
                            }
                        }, {
                            field: 'custCode',
                            title: '客户代码',
                            align:'center',
                            sort: true,
                            width: 100
                        }, {
                            field: 'custCodeZ',
                            title: '客户子代码',
                            align:'center',
                            sort: true,
                            width: 110
                        }, {
                            field: 'custDesc',
                            title: '客户名称',
                            align:'center',
                            sort: true,
                            width: 160
                        }, {
                            field: 'orderType',
                            title: '订单类型',
                            align:'center',
                            sort: true,
                            width: 120
                        }, {
                            field: 'currCode',
                            title: '币种',
                            align:'center',
                            sort: true,
                            width: 70
                        }, {
                            field: 'orderedDate',
                            title: '订购日期',
                            align:'center',
                            sort: true,
                            width: 120
                        }, {
                            field: 'userName',
                            title: '销售员',
                            align:'center',
                            sort: true,
                            width: 110
                        }, {
                            field: 'zdName',
                            title: '制单人',
                            align:'center',
                            sort: true,
                            width: 100
                        }, {
                            field: 'apprStatus',
                            title: '审批状态',
                            align:'center',
                            sort: true,
                            width: 105
                        },{
                            field: 'flowStatusCode',
                            title: '单据状态',
                            align:'center',
                            sort: true,
                            width: 100
                        },{
                            field: 'statusDesc',
                            title: '是否批量更新',
                            align:'center',
                            sort: true,
                            width: 130
                        },{
                            field: 'attaNum',
                            title: '附件数量',
                            align:'center',
                            fixed: 'right',
                            sort: true,
                            width: 100,
                            templet: function(d) {
                                return '<span style="color: #FF5722; font-weight: bold;">'+d.attaNum+'</span>'; // 红色加粗
                            }
                        }, {
                            fixed: 'right',
                            title: '${ lfn:message('list.operation') }',
                            align:'center',
                            width: 170,
                            toolbar: '#barDemo'
                        }
                    ]],done: function(res, curr, count) {
                        // 方法1：全局修改所有表头
                        $('.layui-table-header th').css({
                            'background-color': '#f6f6f6',
                            'font-weight': 'normal'
                        });
                    }
                });

                //监听搜索操作
                form.on('submit(data-search-btn)', function (data) {
                    var result = JSON.stringify(data.field);
                    //执行搜索重载
                    table.reload('ListTb', {
                        page: {
                            curr: 1
                        },
                        where: {
                            searchParams: result
                        }
                    }, 'data');

                    return false;//不刷新整个页面，只刷新form
                });
                /**
                 * toolbar监听事件 新增&解析
                 */
                table.on('toolbar(currentTableFilter)', function (obj) {
                    /*      if (obj.event === 'refresh') { // 监听刷新操作
                             table.reload('ListTb', {
                                 page: {
                                     curr: 1
                                     //每次刷新都回到第一页，去掉为刷新当前页
                                 }
                             });
                         }
                         if (obj.event === 'delOrder') { // 监听删除操作
                             var checkStatus = table.checkStatus('ListTb'), data = checkStatus.data;
                             var selected = [];
                             $.each(data, function (idx, obj) {
                                 console.log(obj.fdId)
                                 selected.push(obj.fdId);
                             });
                             if (selected.length == 0) {
                                 layer.alert("${lfn:message('crm-common:crm.msg.tips0106')}");
                            return;
                        }
                        var param = {
                            "List_Selected": selected
                        };
                        layer.confirm('${lfn:message('crm-common:crm.msg.tips0105')}', function (index) {
                            $.ajax({
                                url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=deleteall',
                                data: $.param(param, true),
                                dataType: 'json',
                                type: 'POST',
                                success: function (data) {
                                    layer.msg('${lfn:message('crm-common:crm.msg.tips0107')}', {
                                        icon: 1,
                                        time: 1000
                                        //2秒关闭（如果不配置，默认是3秒）
                                    }, function () {
                                        table.reload('ListTb', {
                                            page: {
                                                curr: 1
                                            },
                                            where: {
                                                searchParams: ""
                                            }
                                        }, 'data');
                                    });
                                },
                                error: function (req) {
                                    if (req.responseJSON) {
                                        var data = req.responseJSON;
                                        layer.alert(data.title);
                                    } else {
                                        layer.alert('${lfn:message('crm-common:crm.msg.tips0108')}');
                                    }
                                }
                            });
                        }); 

                    } */
                });

                /**
                 * tool监听事件 查看列表工具箱
                 detailOrder  editOrder  delOrder
                 */
                table.on('tool(currentTableFilter)', function (obj) {
                    let isActive = '0';  //是否可操作单据
                    var data = obj.data; //获得当前行数据
                    if (obj.event === 'approvalAddre') { // 跳转审批
                        var approvalAddre  = data.approvalAddre;
                        if(approvalAddre != null && approvalAddre != undefined && approvalAddre != ""){
                            window.open("http://oa.smart-core.com.hk:2166"+approvalAddre, "_blank");
                        }else{
                            layer.alert('未推送审批！', {title: '提示', icon: 3});
                        }
                    }
                    if (obj.event === 'addOrder') { // 监听订单新增行
                        var fdOperatingUnit = data.orgcode;
                        var fdId  = data.headerId;
                        var fdOrderNumber  = data.orderNumber;

                        //验证订单是否可以操作
                        $.ajax({
                            url : Com_Parameter.ContextPath + "sdms/om/sdms_om_main/sdmsOmMain.do?method=getValidOmInfo",
                            dataType : "json",
                            data:{
                                omheaderId:fdId,
                                omType:'addLine'
                            },
                            async : false,
                            success : function(res) {
                                if(res.isoperation != '' && res.isoperation != 'null'){
                                    isActive = res.isoperation;
                                    if (isActive != '1'){
                                        layer.alert('该订单['+fdOrderNumber+']不可新增行！', {title: '错误', icon: 2});
                                    }
                                }
                            }
                        });

                        if (isActive == '1'){

                            const  h = new Map();
                            const  arr_l = new Map();
                            layui.use([ 'table', 'layer'], function(){
                                var table = layui.table;
                                var layer = layui.layer;
                                window.parent.layui.layer.open({
                                    title : '新增行',
                                    type : 2,
                                    shade : 0.2,
                                    maxmin : true,
                                    shadeClose : true,
                                    area : [ '100%', '100%' ],
                                    content: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=adline&fdOrderNumber=' + fdOrderNumber,
                                    btn: ['保存&提交审批', '取消'],
                                    yes: function(index,layero,that) {

                                        h.set('fdOperatingUnit',fdOperatingUnit);

                                        var numberInput = $(layero).find('iframe')[0].contentWindow;
                                        var fdId = numberInput.$("input[name='fdId']").val();
                                        h.set('fdId',fdId);
                                        /*     var fdCurrency = numberInput.$("input[name='fdCurrency']").val();
                                            h.set('fdCurrency',fdCurrency);
                                            var fdTerms = numberInput.$("input[name='fdTerms']").val();
                                            h.set('fdTerms',fdTerms);
                                            var fdPointCode = numberInput.$("input[name='fdPointCode']").val();
                                            h.set('fdPointCode',fdPointCode);
                                            var fdCustomerNum = numberInput.$("input[name='fdCustomerNum']").val();
                                            h.set('fdCustomerNum',fdCustomerNum);
                                            var fdCustomerName = numberInput.$("input[name='fdCustomerName']").val();
                                            h.set('fdCustomerName',fdCustomerName);
                                            var fdCustomerToNum = numberInput.$("input[name='fdCustomerToNum']").val();
                                            h.set('fdCustomerToNum',fdCustomerToNum);
                                            var fdSaleorId = numberInput.$("input[name='fdSaleorId']").val();
                                            h.set('fdSaleorId',fdSaleorId); */
                                        // 获取子页面表格数据
                                        numberInput.$("#TABLE_DocList_fdOmLine_Form input[name*='fdItemId']").each(function(index, obj) {
                                            if(obj.value != '') {
                                                const  l = new Map();
                                                var fdItem = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdItem']").val();
                                                if (fdItem != 'undefined' && fdItem != undefined){
                                                    l.set('fdItem',fdItem);//物料代码
                                                    var fdItemDescription = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdItemDescription']").val();
                                                    l.set('fdItemDescription',fdItemDescription);//物料代码
                                                    var fdcustItemNumber = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdcustItemNumber']").val();
                                                    l.set('fdcustItemNumber',fdcustItemNumber);//客户料号
                                                    var fdCustomerOrder = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustomerOrder']").val();
                                                    l.set('fdCustomerOrder',fdCustomerOrder);//客户订单	
                                                    var fdUnitSellingPrice = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdUnitSellingPrice']").val();
                                                    l.set('fdUnitSellingPrice',fdUnitSellingPrice);//销售单价
                                                    var fdTaxCode = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdTaxCode']").val();
                                                    l.set('fdTaxCode',fdTaxCode);//税码
                                                    var fdBrandAuthId = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdBrandAuthId']").val();
                                                    l.set('fdBrandAuthId',fdBrandAuthId);//品牌权限	
                                                    var fdPm = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPm']").val();
                                                    l.set('fdPm',fdPm);//PM
                                                    var fdBn = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdBn']").val();
                                                    l.set('fdBn',fdBn);//版本号
                                                    var fdorginalCountry = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdorginalCountry']").val();
                                                    l.set('fdorginalCountry',fdorginalCountry);//原产地
                                                    var fdCustShipNumber = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustShipNumber']").val();
                                                    l.set('fdCustShipNumber',fdCustShipNumber);//工厂库位
                                                    var fdCustOrderItems = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustOrderItems']").val();
                                                    l.set('fdCustOrderItems',fdCustOrderItems); //客户订单项次	
                                                    var fdUnitPrice = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdUnitPrice']").val();
                                                    l.set('fdUnitPrice',fdUnitPrice);//美元单价
                                                    var fdActualRate = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdActualRate']").val();
                                                    l.set('fdActualRate',fdActualRate);//实际汇率
                                                    var fdDeliveryRate = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdDeliveryRate']").val();
                                                    l.set('fdDeliveryRate',fdDeliveryRate);//送货费率
                                                    var fdPatentFees = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPatentFees']").val();
                                                    l.set('fdPatentFees',fdPatentFees);//专利费用
                                                    var fdOrderedQuantity = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdOrderedQuantity']").val();
                                                    l.set('fdOrderedQuantity',fdOrderedQuantity);//数量
                                                    var fdRequestDate = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdRequestDate']").val();
                                                    l.set('fdRequestDate',fdRequestDate);//需求日期
                                                    var fdPriceUnit = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPriceUnit']").val();
                                                    l.set('fdPriceUnit',fdPriceUnit);//打印单价
                                                    var fdLineTypeId = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdLineTypeId']").val();
                                                    l.set('fdLineTypeId',fdLineTypeId);//行类型
                                                    var fdLineType = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdLineType']").val();
                                                    l.set('fdLineType',fdLineType);//行类型
                                                    var fdMinPackQuantity = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdMinPackQuantity']").val();
                                                    l.set('fdMinPackQuantity',fdMinPackQuantity);//最小包装数量
                                                    var fdRebatePayNum = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdRebatePayNum']").val();
                                                    l.set('fdRebatePayNum',fdRebatePayNum);//rebate支付单号
                                                    var fdDepReceRatio = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdDepReceRatio']").val();
                                                    l.set('fdDepReceRatio',fdDepReceRatio);//应收定金比例
                                                    var fdDepositRatio = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdDepositRatio']").val();
                                                    l.set('fdDepositRatio',fdDepositRatio);//实收定金比例
                                                    var fdDepositAmount = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdDepositAmount']").val();
                                                    l.set('fdDepositAmount',fdDepositAmount);//实收定金金额
                                                    var fdRetWare = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdRetWare']").val();
                                                    l.set('fdRetWare',fdRetWare);//仓库
                                                    var fdLineComments = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdLineComments']").val();
                                                    l.set('fdLineComments',fdLineComments);//行备注
                                                    var fdPatentSpecialNum = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPatentSpecialNum']").val();
                                                    l.set('fdPatentSpecialNum',fdPatentSpecialNum);
                                                    arr_l.set(index,l);
                                                }
                                            }
                                        });
                                        h.set('lines',arr_l);

                                        const jsonObj = JSON.stringify(mapToObject(h));

                                        var ind = window.parent.layui.layer.load(); // 开启loading层
                                        $.ajax({
                                            url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=adLineMain',
                                            data: {
                                                jsonObj:jsonObj,
                                                fdOperatingUnit:fdOperatingUnit
                                            },
                                            dataType: 'json',
                                            type: 'POST',
                                            success: function (data) {
                                                if(data.code != '200'){
                                                    window.parent.layui.layer.close(ind); // 关闭loading层
                                                    window.parent.layui.layer.alert('新增订单行失败！'+data.msg, {title: '错误', icon: 2});
                                                }else{
                                                    window.parent.layui.layer.close(ind); // 关闭loading层
                                                    //window.parent.layui.layer.alert('新增订单行成功！', {title: '成功', icon: 1});
                                                    //关闭当前弹框页面  
                                                    window.parent.layui.layer.close(index);
                                                    layer.alert('新增订单行成功，是否推送OA审批?', {
                                                        title: '提示',
                                                        icon: 3,              // 问号图标
                                                        btn: ['是', '否'],
                                                        yes: function(index) {
                                                            //推送OA审批
                                                            pushSingleApprove(fdOperatingUnit,fdId);
                                                            layer.close(index);
                                                        },
                                                        btn2: function(index) {
                                                            // 放弃逻辑
                                                            layer.close(index);
                                                            table.reload('ListTb', {
                                                                page: {
                                                                    curr: 1
                                                                    //每次刷新都回到第一页，去掉为刷新当前页
                                                                }
                                                            });
                                                            //parent.layer.close(parent.layer.getFrameIndex(window.name)); // 关闭弹窗
                                                        },
                                                        cancel: function() {   // 点击关闭按钮
                                                            table.reload('ListTb', {
                                                                page: {
                                                                    curr: 1
                                                                    //每次刷新都回到第一页，去掉为刷新当前页
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                                /* setTimeout(function() {
                                                    location.reload(true);
                                                 }, 1000); */
                                            },
                                            error: function (req) {
                                                window.parent.layui.layer.alert('新增订单行失败！', {title: '错误', icon: 2});
                                                window.parent.layui.layer.close(ind); // 关闭loading层
                                                window.parent.layui.layer.close(index); // 关闭弹框
                                            }
                                        });


                                    },cancel: function(index) {
                                        //alert('取消1');
                                        //location.reload(true);
                                    },success: function(layero, index) {
                                        // 打开弹窗成功后，修改浏览器标签页标题
                                        parent.document.title = '销售订单 - 新增行';
                                    },end : function() {
                                        //关闭后，还原浏览器标签页标题
                                        parent.document.title = '订单工作台';
                                        //alert('取消2');
                                        //location.reload(true);
                                    }
                                });
                            });

                        }

                    }
                    if (obj.event === 'editOrder') { // 监听订单编辑
                        var fdOperatingUnit = data.orgcode;
                        var fdId  = data.headerId;
                        var orderNumber  = data.orderNumber;

                        //验证订单是否可以操作
                        $.ajax({
                            url : Com_Parameter.ContextPath + "sdms/om/sdms_om_main/sdmsOmMain.do?method=getValidOmInfo",
                            dataType : "json",
                            data:{
                                omheaderId:fdId,
                                omType:'editOrder'
                            },
                            async : false,
                            success : function(res) {
                                if(res.isoperation != '' && res.isoperation != 'null'){
                                    isActive = res.isoperation;
                                    if (isActive != '1'){
                                        layer.alert('该订单['+orderNumber+']不可编辑！', {title: '错误', icon: 2});
                                    }
                                }
                            }
                        });

                        if (isActive == '1'){
                            const  h = new Map();
                            const  arr_l = new Map();
                            layui.use([ 'table', 'layer'], function(){
                                var table = layui.table;
                                var layer = layui.layer;
                                window.parent.layui.layer.open({
                                    title : '编辑',
                                    type : 2,
                                    shade : 0.2,
                                    maxmin : true,
                                    shadeClose : true,
                                    area : [ '100%', '100%' ],
                                    content: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=updOm&fdId=' + fdId,
                                    btn: ['保存&提交审批', '取消'],
                                    yes: function(index,layero,that) {

                                        h.set('fdOperatingUnit',fdOperatingUnit);

                                        var numberInput = $(layero).find('iframe')[0].contentWindow;
                                        var fdId = numberInput.$("input[name='fdId']").val();
                                        h.set('fdId',fdId);
                                        var fdCurrency = numberInput.$("input[name='fdCurrency']").val();
                                        h.set('fdCurrency',fdCurrency);
                                        var fdTerms = numberInput.$("input[name='fdTerms']").val();
                                        h.set('fdTerms',fdTerms);
                                        var fdPointCode = numberInput.$("input[name='fdPointCode']").val();
                                        h.set('fdPointCode',fdPointCode);
                                        var fdCustomerNum = numberInput.$("input[name='fdCustomerNum']").val();
                                        h.set('fdCustomerNum',fdCustomerNum);
                                        var fdCustomerName = numberInput.$("input[name='fdCustomerName']").val();
                                        h.set('fdCustomerName',fdCustomerName);
                                        var fdCustomerToNum = numberInput.$("input[name='fdCustomerToNum']").val();
                                        h.set('fdCustomerToNum',fdCustomerToNum);
                                        var fdSaleorCode = numberInput.$("input[name='fdSaleorCode']").val();
                                        h.set('fdSaleorCode',fdSaleorCode);
                                        // 获取子页面表格数据
                                        numberInput.$("#TABLE_DocList_fdOmLine_Form input[name*='fdItemId']").each(function(index, obj) {
                                            if(obj.value != '') {
                                                const  l = new Map();
                                                var fdId = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdId']").val();
                                                l.set('fdId',fdId);//ID
                                                var fdItem = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdItem']").val();
                                                l.set('fdItem',fdItem);//物料代码
                                                var fdItemDescription = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdItemDescription']").val();
                                                l.set('fdItemDescription',fdItemDescription);//物料代码
                                                var fdcustItemNumber = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdcustItemNumber']").val();
                                                l.set('fdcustItemNumber',fdcustItemNumber);//客户料号
                                                var fdCustomerOrder = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustomerOrder']").val();
                                                l.set('fdCustomerOrder',fdCustomerOrder);//客户订单	
                                                var fdUnitSellingPrice = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdUnitSellingPrice']").val();
                                                l.set('fdUnitSellingPrice',fdUnitSellingPrice);//销售单价
                                                var fdTaxCode = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdTaxCode']").val();
                                                l.set('fdTaxCode',fdTaxCode);//税码
                                                var fdBrandAuthId = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdBrandAuthId']").val();
                                                l.set('fdBrandAuthId',fdBrandAuthId);//品牌权限	
                                                var fdPm = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPm']").val();
                                                l.set('fdPm',fdPm);//PM
                                                var fdBn = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdBn']").val();
                                                l.set('fdBn',fdBn);//版本号
                                                var fdorginalCountry = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdorginalCountry']").val();
                                                l.set('fdorginalCountry',fdorginalCountry);//原产地
                                                var fdCustShipNumber = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustShipNumber']").val();
                                                l.set('fdCustShipNumber',fdCustShipNumber);//工厂库位
                                                var fdCustOrderItems = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdCustOrderItems']").val();
                                                l.set('fdCustOrderItems',fdCustOrderItems); //客户订单项次	
                                                var fdUnitPrice = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdUnitPrice']").val();
                                                l.set('fdUnitPrice',fdUnitPrice);//美元单价
                                                var fdActualRate = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdActualRate']").val();
                                                l.set('fdActualRate',fdActualRate);//实际汇率
                                                var fdDeliveryRate = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdDeliveryRate']").val();
                                                l.set('fdDeliveryRate',fdDeliveryRate);//送货费率
                                                var fdPatentFees = numberInput.$("input[name='fdOmLine_Form["+ index +"].fdPatentFees']").val();
                                                l.set('fdPatentFees',fdPatentFees);//专利费用
                                                arr_l.set(index,l);
                                            }
                                        });
                                        h.set('lines',arr_l);
                                        const jsonObj = JSON.stringify(mapToObject(h));

                                        var ind = window.parent.layui.layer.load(); // 开启loading层
                                        $.ajax({
                                            url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=upEbsMain',
                                            data: {
                                                jsonObj:jsonObj,
                                                fdOperatingUnit:fdOperatingUnit
                                            },
                                            dataType: 'json',
                                            type: 'POST',
                                            success: function (data) {
                                                if(data.code != '200'){
                                                    window.parent.layui.layer.close(ind); // 关闭loading层
                                                    window.parent.layui.layer.alert('编辑订单失败！'+data.msg, {title: '错误', icon: 2}); // 显示失败消息
                                                }else{
                                                    window.parent.layui.layer.close(ind); // 关闭loading层
                                                    //window.parent.layui.layer.alert('编辑订单成功！', {title: '成功', icon: 1});
                                                    //关闭当前弹框页面  
                                                    window.parent.layui.layer.close(index);
                                                    layer.alert('编辑成功，是否推送OA审批?', {
                                                        title: '提示',
                                                        icon: 3,              // 问号图标
                                                        btn: ['是', '否'],
                                                        yes: function(index) {
                                                            //推送OA审批
                                                            pushSingleApprove(fdOperatingUnit,fdId);
                                                            layer.close(index);
                                                        },
                                                        btn2: function(index) {
                                                            // 放弃逻辑
                                                            layer.close(index);
                                                            table.reload('ListTb', {
                                                                page: {
                                                                    curr: 1
                                                                    //每次刷新都回到第一页，去掉为刷新当前页
                                                                }
                                                            });
                                                            //parent.layer.close(parent.layer.getFrameIndex(window.name)); // 关闭弹窗
                                                        },
                                                        cancel: function() {   // 点击关闭按钮
                                                            table.reload('ListTb', {
                                                                page: {
                                                                    curr: 1
                                                                    //每次刷新都回到第一页，去掉为刷新当前页
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                                /* setTimeout(function() {
                                                    location.reload(true);
                                                 }, 1000); */
                                            },
                                            error: function (req) {
                                                window.parent.layui.layer.alert('编辑订单失败！', {title: '错误', icon: 2});
                                                window.parent.layui.layer.close(ind); // 关闭loading层
                                                window.parent.layui.layer.close(index); // 关闭弹框
                                            }
                                        });


                                    },cancel: function(index) {
                                        //alert('取消1');
                                        //location.reload(true);
                                    },end : function() {
                                        //alert('取消2');
                                        //location.reload(true);
                                    }
                                });
                            });
                        }
                    }
                    if (obj.event === 'delOrder') { // 监听订单取消
                        var fdOperatingUnit = data.orgcode;
                        var fdHeaderId = data.headerId;
                        var fdOrderNumber = data.orderNumber;
                        //验证订单是否可以操作
                        $.ajax({
                            url : Com_Parameter.ContextPath + "sdms/om/sdms_om_main/sdmsOmMain.do?method=getValidOmInfo",
                            dataType : "json",
                            data:{
                                omheaderId:fdHeaderId
                            },
                            async : false,
                            success : function(res) {
                                if(res.isoperation != '' && res.isoperation != 'null'){
                                    isActive = res.isoperation;
                                    if (isActive != '0'){
                                        layer.alert('该订单['+fdOrderNumber+']存在交货计划行，不能取消整单！', {title: '错误', icon: 2});
                                    }
                                }
                            }
                        });

                        if (isActive == '0'){

                            layui.layer.open({
                                type: 2,
                                title : '[&nbsp&nbsp'+fdOrderNumber+'&nbsp&nbsp]&nbsp&nbsp整单取消原因',
                                //title: false,
                                //area: ['480px', '120px'],
                                area: ['500px', '170px'],
                                fixed: false, //不固定
                                scrollbar: false,
                                shadeClose:true,
                                closeBtn: 0,
                                maxmin: false,
                                anim:5,
                                content: '/sdms/om/resource/openCancelReason.jsp',
                                btn: ['确认', '取消'],
                                yes: function(index,layero,that) {
                                    //let iframeWin = $(layero).find('iframe')[0].contentWindow;
                                    //获取子页面参数
                                    let fdReason = $(layero).find('iframe')[0].contentWindow.$('select[name="fdReason"]').val();
                                    if (fdReason != ''){
                                        var ind = layer.load(); // 开启loading层
                                        $.ajax({
                                            url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=cancelEbsMain',
                                            data: {
                                                fdCancelYx:fdReason,
                                                fdHeaderId:fdHeaderId,
                                                fdOrderNumber:fdOrderNumber,
                                                fdOperatingUnit:fdOperatingUnit
                                            },
                                            dataType: 'json',
                                            type: 'POST',
                                            success: function (data) {
                                                if(data.code != '200'){
                                                    layer.alert('整单取消失败'+data.msg, {title: '错误', icon: 2}); // 显示失败消息
                                                    layer.close(ind); // 关闭loading层
                                                    layer.close(index); // 关闭弹框
                                                }else{
                                                    layer.close(ind); // 关闭loading层
                                                    layer.alert('整单取消申请已记录，请点击推送审批完成取消申请操作！', {title: '成功', icon: 1});
                                                    layer.close(index); // 关闭弹框
                                                }
                                                table.reload('ListTb', {
                                                    page: {
                                                        curr: 1
                                                        //每次刷新都回到第一页，去掉为刷新当前页
                                                    }
                                                });
                                            },
                                            error: function (req) {
                                                layer.alert('整单取消失败！', {title: '错误', icon: 2});
                                                layer.close(ind); // 关闭loading层
                                                layer.close(index); // 关闭弹框
                                            }
                                        });
                                    }else{
                                        layer.alert('整单取消失败', {title: '失败', icon: 2});
                                    }
                                    /* layer.close(index);
                                    alert('确认');
                                    addDocData(); */
                                },
                                error: function (req) {
                                    layer.alert('整单取消失败！', {title: '错误', icon: 2});
                                    layer.close(ind); // 关闭loading层
                                    layer.close(index); // 关闭弹框
                                }
                            });

                            //var fdOrderedQuantity = $("input[name='fdOmLine_Form["+ index +"].fdOrderedQuantity']").val();
                            //layer.msg('整单取消'+fdHeaderId, {icon: 1});
                            /*   layer.prompt({
                                    title: '[&nbsp'+fdOrderNumber+'&nbsp]&nbsp&nbsp整单取消原因',
                                    formType: 0 // 0 为文本框，1 为密码框，2 为多行文本框
                                  }, function(value, index) {
                                    // 点击确认后的回调
                                    //layer.msg('整单取消原因：' + value);
                                    var ind = layer.load(); // 开启loading层
                                    $.ajax({
                                        url: '/sdms/om/sdms_om_main/sdmsOmMain.do?method=cancelEbsMain',
                                        data: {
                                            fdCancelYx:value,
                                            fdHeaderId:fdHeaderId,
                                            fdOrderNumber:fdOrderNumber,
                                            fdOperatingUnit:fdOperatingUnit
                                         },
                                        dataType: 'json',
                                        type: 'POST',
                                        success: function (data) {
                                                if(data.code != '200'){
                                                  layer.alert('整单取消失败'+data.msg, {title: '错误', icon: 2}); // 显示失败消息
                                                  layer.close(ind); // 关闭loading层
                                                  layer.close(index); // 关闭弹框
                                              }else{
                                                  layer.close(ind); // 关闭loading层
                                                  layer.alert('整单取消成功！', {title: '成功', icon: 1});
                                                  layer.close(index); // 关闭弹框
                                              }
                                                    table.reload('ListTb', {
                                                     page: {
                                                         curr: 1
                                                         //每次刷新都回到第一页，去掉为刷新当前页
                                                     }
                                                 });
                                             
                                        },
                                        error: function (req) {
                                            layer.alert('整单取消失败！', {title: '错误', icon: 2});
                                            layer.close(ind); // 关闭loading层
                                            layer.close(index); // 关闭弹框
                                        }
                                    }); 
                                    
                                  });   */
                        }
                    }

                });

            });


            /**
             附件批量下载
             */
            function getAttPerTemp() {
                var checkStatus = layui.table.checkStatus('ListTb');
                var selectedData = checkStatus.data;
                if (selectedData.length === 0) {
                    layer.msg('请至少选择一项！');
                    return;
                }
                var docAll = "";
                selectedData.forEach(function(row, index) {
                    docAll =  row.orderNumber + "," + docAll ;
                });
                var userNo = $("input[name='fdUser']").val();
                if (userNo == null || userNo == undefined || userNo == "") {
                    layer.msg("操作人为空！", {icon: 2});
                    return;
                }
                if (docAll == null || docAll == undefined || docAll == "") {
                    layer.msg("订单编号为空！", {icon: 2});
                    return;
                }
                $.ajax({
                    url: Com_Parameter.ContextPath + "sdms/common/per/sdmsCommonPermAction.do?method=getApiDoc",
                    dataType: "json",
                    async: false,
                    success: function (res) {
                        if (res.docUrl != '' && res.docUrl != 'null') {
                            window.open(res.docUrl + "SDMS_SO1?order_list=" + docAll + "&username=" + userNo);
                        }
                    }
                });
            }


            /* 推送订单到OA审批 */
            function pushSingleApprove(fdOperatingUnit,headerId){

                if(fdOperatingUnit == null || fdOperatingUnit == undefined || fdOperatingUnit == ""){
                    dialog.alert("业务主体为空！");
                    return;
                }

                var ind = layer.load(); // 开启loading层
                $.ajax({
                    url : Com_Parameter.ContextPath + "sdms/om/sdms_om_main/sdmsOmMain.do?method=pushSingleApprove",
                    dataType : "json",
                    data:{
                        fdOperatingUnit:fdOperatingUnit,
                        headerId:headerId
                    },
                    async : false,
                    success : function(res) {
                        if(res.code != '200'){
                            layer.close(ind); // 关闭loading层
                            layer.alert('推送OA审批失败！'+res.msg, {title: '错误', icon: 2});
                        }else{
                            layer.close(ind); // 关闭loading层
                            layer.alert('推送OA审批成功！', {title: '成功', icon: 1});
                            table.reload('ListTb', {
                                page: {
                                    curr: 1
                                    //每次刷新都回到第一页，去掉为刷新当前页
                                }
                            });
                        }
                    }
                });
            }


            //嵌套 Map 转换 json
            function mapToObject(map) {
                const obj = {};
                for (const [key, value] of map) {
                    obj[key] = value instanceof Map ? mapToObject(value) : value;
                }
                return obj;
            };


            /*     function search_gj_Msg(val) {
            	layer.msg('整单取消原因：' + val);
              var searchGj = $("input[name='searchGj']").val();
                layui.use('layer', function () {
                    layui.layer.open({
                        type: 2,
                        offset: 'r',
                        title: false,
                        area: ['480px', '100vh'],
                        fixed: false, //不固定
                        scrollbar: false,
                        shadeClose: true,
                        closeBtn: 0,
                        maxmin: false,
                        anim: 5,
                        content: '/crm/client/crm_client_data_main/searchForCcdm.jsp',
                        success: function (layero, index) {
                            var iframe = window['layui-layer-iframe' + index];
                            //console.log(iframe);
                            iframe.child(searchGj);
                        },
                    });
                }); 
            }*/

            /* 搜索条件为空情况下  */
            function FDChange(val) {
                if (val == "" || val == null || val == undefined) {
                    layui.use(['table', 'layer'], function () {
                        var table = layui.table;
                        var layer = layui.layer;
                        //执行搜索重载
                        table.reload('ListTb', {
                            page: {
                                curr: 1
                            },
                            where: {
                                searchParams: ""
                            }
                        }, 'data');
                    })
                }
            }

            /* 编辑交易主体  */
            function openJyEdit(_id) {
                window.open("/sdms/om/sdms_om_main/sdmsOmMain.do?method=edit&fdId=" + _id);

            }

            /* 查看销售订单  */
            function openJyView(_id) {
                //记录筛选条件
                var customer = $("select[name='customer']").val();
                var keyword = $("input[name='keyword']").val();
                var orgCode = $("select[name='orgCode']").val();
                var dateRange = $("select[name='dateRange']").val();
                const data = {
                    customer,
                    orgCode,
                    dateRange,
                    keyword
                };
                layui.use([ 'table', 'layer' ], function() {
                    var table = layui.table;
                    var layer = layui.layer;
                    window.parent.layui.layer.open({
                        title : '查看',
                        type : 2,
                        shade : 0.2,
                        maxmin : true,
                        shadeClose : true,
                        area : [ '100%', '100%' ],
                        content : '/sdms/om/sdms_om_main/sdmsOmMain.do?method=view&fdId=' + _id,
                        btn: ['复制订单'],
                        yes: function(index,layero,that) {
                            //获取子页面参数
                            let fdOrderNumber = $(layero).find('iframe')[0].contentWindow.$('input[name="fdOrderNumber"]').val();
                            let fdOperatingUnitName = $(layero).find('iframe')[0].contentWindow.$('input[name="fdOperatingUnitName"]').val();
                            if (fdOrderNumber != '' && fdOperatingUnitName  != ''){
                                //关闭当前弹框页面  
                                //window.parent.layui.layer.close(index);
                                copyDocData(fdOrderNumber, fdOperatingUnitName);
                            }
                        },
                        success: function(layero, index) {
                            // 打开弹窗成功后，修改浏览器标签页标题
                            parent.document.title = '销售订单 - 查看';
                        },
                        end : function() {
                            //关闭后，还原浏览器标签页标题
                            parent.document.title = '订单工作台';
                            var result = JSON.stringify(data);
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : result
                                }
                            }, 'data');
                        }
                    });
                });
                //window.open("/sdms/om/sdms_om_main/sdmsOmMain.do?method=view&fdId=" + _id);
            }
            function openCustom(_id){
                window.open('/crm/client/crm_client_data_main/crmClientDataMain.do?method=view&fdId='+_id,'_blank');
            }

            function addDoc(){
                layui.use([ 'table', 'layer'], function(){
                    var table = layui.table;
                    var layer = layui.layer;
                    layui.layer.open({
                        type: 2,
                        title : '选择',
                        //title: false,
                        //area: ['480px', '120px'],
                        area: ['500px', '180px'],
                        fixed: false, //不固定
                        scrollbar: false,
                        shadeClose:true,
                        closeBtn: 0,
                        maxmin: false,
                        anim:5,
                        content: '/sdms/om/resource/openCompayQuote.jsp',
                        btn: ['确认', '取消'],
                        yes: function(index,layero,that) {
                            //let iframeWin = $(layero).find('iframe')[0].contentWindow;
                            //获取子页面参数
                            let fdBukrs = $(layero).find('iframe')[0].contentWindow.$('select[name="fdBukrs"]').val();
                            if (fdBukrs != ''){
                                //关闭当前弹框页面  
                                layer.close(index);
                                addDocData(fdBukrs);
                            }else{
                                layer.alert('获取交易主体失败！');
                            }
                            /* layer.close(index);
                            alert('确认');
                            addDocData(); */
                        },
                        cancel: function(index) {
                            alert('取消');
                        },
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });

            }
            /**
             附件解析
             */
            function getAttSoTemp(){
                layui.use([ 'table', 'layer'], function(){
                    var table = layui.table;
                    var layer = layui.layer;
                    layui.layer.open({
                        type: 2,
                        title : '选择',
                        //title: false,
                        //area: ['480px', '120px'],
                        area:  [ '100%', '100%' ],
                        fixed: false, //不固定
                        scrollbar: false,
                        shadeClose:true,
                        //closeBtn: 0,
                        maxmin: true,
                        anim:5,
                        content: '/sdms/om/resource/openAttSoTemp.jsp',
                        btn: ['生成订单', '取消'],
                        yes: function(index,layero,that) {
                            debugger;
                            //let iframeWin = $(layero).find('iframe')[0].contentWindow;
                            //获取子页面参数
                            var iframeWindow = window['layui-layer-iframe' + index]  //获取弹框页面
                                , submitID = 'LAY-user-front-submit' //弹框确定按钮
                                , submit = layero.find('iframe').contents().find('#' + submitID);//弹框确定按钮
                            //监听提交
                            var body = layer.getChildFrame('body', index);
                            var checkStatus = iframeWindow.layui.table.checkStatus('ListTb');//获取选中行
                            var items = checkStatus.data;
                            var json = "{ \"tempType\":" + JSON.stringify(items) + "}";
                            //let fdFile = $(layero).find('iframe')[0].contentWindow.$('input[name="uploadFileId"]').val();
                            if (json != null && json != ''){
                                //关闭当前弹框页面  
                                //layer.close(index);
                                addSoTemp(json,checkStatus.data.length);
                            }else{
                                layer.alert('识别销售模板失败！');
                            }
                            /* layer.close(index);
                            alert('确认');
                            addDocData(); */
                        },
                        cancel: function(index) {
                            //alert('点击取消');
                        },
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });

            }

            function getHostSdk() {
                var wins = [window];
                if (window.top && window.top !== window) {
                    wins.push(window.top);
                }
                for (var i = 0; i < wins.length; i++) {
                    var win = wins[i];
                    var sdk =
                        win.CopilotHostBridge ||
                        win.CopilotHostBridgeSDK ||
                        win.CopilotCrmLiteDemoSDK ||
                        win.CopilotCrmDesktopSDK;
                    if (sdk) return sdk;
                }
                return null;
            }

            /**
             * HostBridge v6 最小 pageContext（create 等无既有单据时可用）。
             * 协议必填：app、url；entityId/entityName/data 均可省略。
             */
            function buildMinimalPageContext(formType, extra) {
                extra = extra || {};
                var ctx = {
                    app: extra.app || 'sdms-om',
                    url: extra.url || window.location.href,
                    title: extra.title || document.title,
                    entityType: extra.entityType || formType || 'order',
                };
                if (extra.entityId) ctx.entityId = String(extra.entityId);
                if (extra.entityName) ctx.entityName = String(extra.entityName);
                if (extra.data && typeof extra.data === 'object') ctx.data = extra.data;
                return ctx;
            }
            
            function updateBridgeStatusPill(available) {
                var el = document.getElementById('desktopStatus');
                if (!el) return;
                el.innerText = available
                    ? 'HostBridge 可用'
                    : '普通浏览器 / 未检测到 HostBridge';
            }
            
            async function hostSubmit(product, input, trigger) {
                input = input || {};
                var bridge = getHostSdk();
                if (!bridge || typeof bridge.submit !== 'function') {
                    return { ok: false, message: 'HostBridge 未就绪' };
                }

                var formType = input.formType || 'order';
                var pageContext =
                    input.pageContext ||
                    buildMinimalPageContext(formType, input.pageContextExtra || (product ? { data: { product: product } } : {}));

                return bridge.submit({
                    formType: formType,
                    action: input.action,
                    skillName: input.skillName,
                    callbackUrl: input.callbackUrl,
                    pageContext: pageContext,
                    trigger: trigger,
                });
            }
            layui.use(['layer'], async function () {

                var sdk = getHostSdk();
                var versionEl = document.getElementById('sdkVersion');
                if (versionEl && sdk) {
                    versionEl.textContent = ' SDK ' + (sdk.version || '?') + ' / protocol ' + (sdk.protocolVersion || '?');
                }                

                document.getElementById('btnAiAnalytic').addEventListener('click', function () {
                    var submitPromise = hostSubmit(null, {
                        formType: 'order',
                        action: 'analytic',
                        skillName: 'crm-product-analytic',
                    }, { elementId: 'btnAiAnalytic', label: '模板识别' });
                    submitPromise.then(function (result) {
                        if (result && result.ok) layer.msg('已提交 AI 分析');
                        else layer.msg((result && result.message) || '已发出 fallback 事件（浏览器直开时无 Electron）');
                    }).catch(function (err) {
                        layer.msg('提交失败：' + (err && err.message ? err.message : String(err)));
                    });
                });
                    /*
                    console.log("调用Desktop模板识别生成订单");

                    // 调试信息
                    var sdk = getHostSdk();
                    console.log(sdk);
                    alert(sdk.isAvailable());
                    if (!sdk) {
                        window.parent.layui.layer.msg('SDK 未加载');
                        return;
                    }
                    
                    var result = await sdk.submit({
                        formType: 'product',
                        action: 'create',
                        skillName: 'default',
                        callbackUrl: window.location.href,
                        pageContext: null,
                        trigger: trigger,
                    });
                    alert(result);
                    return true;

                    // 构建最小化的参数
                    sdk.submit({
                        formType: 'order',      // 单据类型：订单
                        action: 'create',       // 动作：创建（解析附件生成订单）
                        pageContext: {
                            app: 'sdms-om',
                            url: window.location.href,
                            title: document.title,
                            entityType: 'order'
                        },
                        trigger: {
                            elementId: 'btnTemplateRecognize',
                            label: '模板识别'
                        }
                    }).then(function(result) {
                        console.log('submit result', result);
                        if (result && result.ok) {
                            window.parent.layui.layer.msg('已通知Desktop解析附件生成订单');
                        } else {
                            window.parent.layui.layer.msg((result && result.message) || '请求已发送');
                        }
                    }).catch(function(err) {
                        console.error('submit error', err);
                        window.parent.layui.layer.msg('发送失败：' + (err.message || '未知错误'));
                    });
                    
                }*/

            
            })

            /**
             订单批量更新
             */
            function getUpLoadTemp(){
                layui.use([ 'table', 'layer'], function(){
                    var table = layui.table;
                    var layer = layui.layer;
                    layui.layer.open({
                        type: 2,
                        title : '选择',
                        area:  [ '100%', '100%' ],
                        shadeClose:true,
                        maxmin: true,
                        content: '/sdms/om/resource/openUpLoadTemp.jsp',
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });

            }
            /**
             品牌权限批量更新
             */
            function getUpBrandAuthTemp(){
                layui.use([ 'table', 'layer'], function(){
                    var table = layui.table;
                    var layer = layui.layer;
                    layui.layer.open({
                        type: 2,
                        title : '选择',
                        area:  [ '100%', '100%' ],
                        shadeClose:true,
                        maxmin: true,
                        content: '/sdms/om/resource/openUpBrandAuthTemp.jsp',
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });

            }

            /* 新建销售订单*/
            function addDocData(val){
                localStorage.removeItem('parentInts'); // 使用后清理
                localStorage.removeItem('parentToChildData'); // 使用后清理
                layui.use([ 'table', 'layer' ], function() {
                    var table = layui.table;
                    var layer = layui.layer;
                    window.parent.layui.layer.open({
                        title : '新建',
                        type : 2,
                        shade : 0.2,
                        maxmin : true,
                        shadeClose : true,
                        area : [ '100%', '100%' ],
                        content : '/sdms/om/sdms_om_main/sdmsOmMain.do?method=add&fdBukrs='+val,
                        success: function(layero, index) {
                            // 打开弹窗成功后，修改浏览器标签页标题
                            parent.document.title = '销售订单 - 新建';
                        },
                        end : function() {
                            //关闭后，还原浏览器标签页标题
                            parent.document.title = '订单工作台';
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });
                //Com_OpenWindow("/sdms/om/sdms_om_main/sdmsOmMain.do?method=add");
            }

            /* window.parentData = {
          		  id: 456,
          		  user: { name: "李四", age: 30 }
          		}; */

            /* 新建销售订单*/
            function addSoTemp(val,ints){
                localStorage.setItem("parentInts", ints);
                localStorage.setItem('parentToChildData', val);
                layui.use([ 'table', 'layer' ], function() {
                    var table = layui.table;
                    var layer = layui.layer;
                    window.parent.layui.layer.open({
                        title : '模板解析导入',
                        type : 2,
                        shade : 0.2,
                        maxmin : true,
                        shadeClose : true,
                        area : [ '100%', '100%' ],
                        content : '/sdms/om/sdms_om_main/sdmsOmMain.do?method=adSoTemp',
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });
            }

            /* 复制销售订单*/
            function copyDocData(val1,val2){
                layui.use([ 'table', 'layer' ], function() {
                    var table = layui.table;
                    var layer = layui.layer;
                    window.parent.layui.layer.open({
                        title : '复制&新建',
                        type : 2,
                        shade : 0.2,
                        maxmin : true,
                        shadeClose : true,
                        area : [ '100%', '100%' ],
                        content : '/sdms/om/sdms_om_main/sdmsOmMain.do?method=copyOrder&fdOrderNumber='+val1+'&fdOu='+val2,
                        end : function() {
                            table.reload('ListTb', {
                                page : {
                                    curr : 1
                                },
                                where : {
                                    searchParams : ""
                                }
                            }, 'data');
                        }
                    });
                });
                //Com_OpenWindow("/sdms/om/sdms_om_main/sdmsOmMain.do?method=add");
            }

        </script>

        <!--         <script>
        // 鼠标悬停操作
        var tipIndex;
        function showTip(content, elem) {
        tipIndex = layer.tips(content, elem, {
        tips: [3, '#595959'], // 方向（1-4）和颜色
        time: -1,             // 不自动关闭
        maxWidth: 280         // 最大宽度
        });
        }
        function closeTip() {
        layer.close(tipIndex); // 关闭提示
        }
        </script> -->

        <style type="text/css">
            body, input, textarea, div, a, table, tr, td, th {
                font-size: 12px;
            }

            .layui-table .layui-input {
                height: 20px !important;
            }

            .layui-table-tool {
                padding: 5px 10px !important;
            }

            .layui-colla-title {
                position: relative;
                height: 30px;
                line-height: 30px;
                padding: 0 15px 0 35px;
            }

            .layui-table-page {
                background-color: #FFF;
                z-index: 99999;
                position: fixed;
                bottom: 0;
            }

            .layui-table-box {
                margin-bottom: 30px;
            }

            .layui-form-pane .layui-form-label {
                width: 110px;
                padding: 5px 15px;
                height: 30px;
                line-height: 20px;
                border-width: 1px;
                border-style: solid;
                border-radius: 2px 0 0 2px;
                text-align: center;
                background-color: #FBFBFB;
                overflow: hidden;
                box-sizing: border-box;
            }

            .container-wrap {
                height: 100%;
                padding: 10px;
                border: 1px solid #DCDCDC;
            }

            /* .search-model .layui-form-item .layui-btn {
                    height: 30px;
                    line-height: 30px;
                    width: 70px;
                    padding: 0px;
            } */
            .layui-btn-primary {
                border: 1px solid #C9C9C9;
                background-color: #fff;
                color: #fff;
            }

            .layui-input, .layui-select, .layui-textarea {
                height: 30px;
            }

            .layui-table-body tr:hover td {
                background-color: #a4c7ec !important; /* 淡蓝色背景 */
            }
        </style>
    </template:replace>
</template:include>
