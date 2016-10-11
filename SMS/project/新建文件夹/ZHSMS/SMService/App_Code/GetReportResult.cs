﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class Report
{
    // 接收短信的手机号码
    public string Destination { get; set; }
    // 状态报告
    public string Stat { get; set; }
}

public class GetReportResult
{
    // 调用接口返回的结果
    public string Result { get; set; }
    // 状态报告
    public List<Report> Reports { get; set; }
}
