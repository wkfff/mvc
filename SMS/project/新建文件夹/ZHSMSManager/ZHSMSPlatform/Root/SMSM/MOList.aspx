﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MOList.aspx.cs" Inherits="ZHSMSPlatform.Root.SMSM.MO_List" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>用户上行短信</title>
    <link type="text/css" rel="stylesheet" href="../../scripts/ui/skins/Aqua/css/ligerui-all.css" />
    <link type="text/css" rel="stylesheet" href="../images/style.css" />
    <link type="text/css" rel="stylesheet" href="../../css/pagination.css" />
    <link type="text/css" rel="stylesheet" href="../../JavaScript/Prompt/gridview.css" />
    <script type="text/javascript" src="../../JavaScript/Prompt/jquery-1.8.3.min.js"></script>
    <script type="text/javascript">
        $(function () {
            var color;
            $("#GridView1>tbody>tr:first~tr:even").css("backgroundColor", "#ebf5fc");
            $("#GridView1>tbody>tr:first~tr:odd").css("backgroundColor", "#d6e7fc");
            $("#GridView1>tbody>tr").mouseover(function () {
                color = $(this).css("backgroundColor");
                $(this).css("backgroundColor", "#fdfde2");
            });
            $("#GridView1>tbody>tr").mouseout(function () {
                $(this).css("backgroundColor", color);
            });
        });
    </script>
    <script type="text/javascript" src="../../scripts/jquery/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="../../scripts/ui/js/ligerBuild.min.js"></script>
    <script type="text/javascript" src="../js/function.js"></script>
    <script src="../../Script/formValidator/DateTimeMask.js" type="text/javascript"></script>
    <script src="../../Script/formValidator/datepicker/WdatePicker.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../JavaScript/Prompt/ymPrompt.js"></script>
    <link rel="stylesheet" type="text/css" href="../../JavaScript/Prompt/skin/qq/ymPrompt.css" />
    <link type="text/css" rel="stylesheet" href="../../css/tab.css" />
    <script type="text/javascript">
        $(document).ready(function () {
            LoadData();
        });
        function LoadData() {
            $.ajax({
                type: "POST",
                url: "../Enterprise/GetSMSMenu.ashx",
                data: {},
                dataType: "json",
                contentType: "application/json",
                success: function (obj) {
                    var sysModule = obj.SysModules;
                    $.each(sysModule, function (i, val) {
                        var str = "<ul>";
                        var list = val.Menus;
                        $.each(list, function (j, va) {
                            str = str + "<li><a href='" + va.MenuUrl + "?AccountID=<%=Request.QueryString["AccountID"]%>'><span>" + va.MenuTitle + "</span></a></li>";
                        });
                        str = str + "</ul>";
                        $("#tabsJ").append(str);
                        //  alert(str);
                    });
                },
                error: function (x, e) {
                    alert("数据获取异常……。");
                    //alert(x.responseText);
                }
            });
            }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="tabsJ">
        </div>
         <div style="clear:both;"></div>
        <div class="tab_con" style="display: block;">
            <table class="form_table">
                <tr>
                    <td>开始时间
                        <asp:TextBox ID="txt_S" runat="server" CssClass="txtInput normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txt_S" Display="Dynamic"
                            ErrorMessage="*请填写日期"></asp:RequiredFieldValidator>
                        结束时间
                        <asp:TextBox ID="txt_E" runat="server" CssClass="txtInput normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                           ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txt_E" Display="Dynamic"
                            ErrorMessage="*请填写日期"></asp:RequiredFieldValidator>

                        <asp:Button ID="btn_nn" runat="server" Text="查询" CssClass="btnSubmit" OnClick="btn_nn_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_message" runat="server" Text="没有接收短信" Font-Bold="True" Font-Size="Medium"></asp:Label>
                        <asp:Label ID="Label1" runat="server" Text="" Font-Bold="True" Font-Size="Medium"></asp:Label>
                        <asp:GridView ID="GridView1" CssClass="gridview" runat="server" AutoGenerateColumns="False" DataKeyNames="SPNumber"
                            Width="100%" OnRowDataBound="GridView1_RowDataBound" AllowPaging="True" OnDataBound="GridView1_DataBound"
                            OnPageIndexChanging="GridView1_PageIndexChanging" PageSize="15">
                            <PagerTemplate>
                                <table>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="MessageLabel" ForeColor="black" Text="页码:" runat="server" />
                                            <asp:DropDownList ID="PageDropDownList" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged"
                                                runat="server" />
                                            <asp:LinkButton CommandName="Page" CommandArgument="First" ID="linkBtnFirst" runat="server">首页</asp:LinkButton>
                                            <asp:LinkButton CommandName="Page" CommandArgument="Prev" ID="linkBtnPrev" runat="server">上一页</asp:LinkButton>
                                            <asp:LinkButton CommandName="Page" CommandArgument="Next" ID="linkBtnNext" runat="server">下一页</asp:LinkButton>
                                            <asp:LinkButton CommandName="Page" CommandArgument="Last" ID="linkBtnLast" runat="server">尾页</asp:LinkButton>
                                        </td>
                                        <td style="width: 460px"></td>
                                        <td>
                                            <asp:Label ID="CurrentPageLabel" ForeColor="black" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="SPNumber" HeaderText="通道号" />
                                <asp:BoundField DataField="UserNumber" HeaderText="电话号码" />
                                <asp:TemplateField HeaderText="消息内容">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" ToolTip='<%#Eval("Message") %>' Text='<%# Eval("Message").ToString().Length>20?Eval("Message").ToString().Substring(0,20)+"...":Eval("Message")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Serial" HeaderText="网关流水号" />
                                <asp:BoundField DataField="Gateway" HeaderText="网关" />
                                <asp:BoundField DataField="ReceiveTime" HeaderText="接收时间" />
                                <asp:BoundField DataField="Service" HeaderText="服务类型" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
