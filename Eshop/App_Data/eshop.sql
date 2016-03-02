/*============================*/
-- ��ҳ�Ĵ洢����
/*============================*/
--------------------------------

create procedure [sp_pageview]
@selectlist varchar(2000),		--�ֶ��б�
@tablename varchar(100),		--����
@fldName varchar(100),			-- ��ҳ�����ֶ���
@wherestr varchar(2000)=null,		--��ѯ����
@pageindex int=1,			--ҳ��
@pagesize int=15,			--ÿҳ��ʾ����
@orderstr varchar(2000)='order by [Number] desc',--�����ֶ�
@pagecount int output,			---��ҳ��
@allcount int output			---�ܼ�¼��
AS
begin

if @selectlist is null begin set @selectlist='*' end			----�ֶ������������Ϊ*
print @selectlist							----��ӡ������ֶ���Ϣ
if @pageindex is null or @pageindex<1 begin set @pageindex=1 end	----��ǰҳ�������С��1��Ϊ�ն�����1
print @pageindex
if @pagesize is null or @pagesize<1 begin set @pagesize=15 end		----ÿҳ��ʾ����
print @pagesize
declare @sql nvarchar(2000)
set @sql='select @allcount=count(*) from '+@tablename+' where 1=1 '+@wherestr
EXEC sp_executesql  @sql,N'@allcount int OUTPUT',@allcount output 
print @allcount
if (@allcount%@pagesize)=0 begin set @pagecount=@allcount/@pagesize end
else begin set @pagecount=(@allcount/@pagesize)+1 end
if @pageindex>@pagecount begin set @pageindex=@pagecount end
declare @pag int 
if @pagesize>1 begin set @pag=str((@pageindex-1)*@pagesize+1) end
else begin set @pag=0 end

declare @sqlstr varchar(4000)
if @allcount>@pagesize 
	begin 
	set @sqlstr='select top '+str(@pagesize)+' '+@selectlist+' from '+@tablename+' where '+@fldName+'  not in(select top '+str((@pageindex-1)*@pagesize)+' '+@fldName+' from '+@tablename+' where 1=1 '+@wherestr+@orderstr+')'+@wherestr+@orderstr
end
else
	begin
	set @sqlstr='select top '+str(@pagesize)+' '+@selectlist+' from '+@tablename+' where 1=1 '+@wherestr+@orderstr
end

print @sqlstr

SET NOCOUNT ON
    EXECUTE(@sqlstr)
    SET NOCOUNT OFF
    RETURN @@RowCount
END

/*======================�ۺ�����======================*/

/* ��̨����Ա�� */
create table [e_admin]
(
[Number]      varchar(50) primary key,		---����
[emid]        varchar(60),                  ---
[upid]        varchar(60),                  ---������
[Rank]        int null default (0),         ---�ȼ�
[CloseS]      int null default (0),         ---�Ƿ�ر�
[Aname]       varchar(20),                  ---�û���
[Apasswoid]   varchar(60),                  ---����
[RealityName] varchar(20),                  ---��ʵ����
[Lasttime]    varchar(200),                 ---���һ�ε�¼ʱ��
[Lotimes]     int null default (0),         ---��¼����
[Atime]       datetime not null default (getdate()),
)

/* �û��� */
create table [e_member]
(
[Number]      varchar(50) primary key,		---����
[Name]        varchar(50),                  ---��¼��
[Password]    varchar(50),                  ---����
[NickName]    varchar(50),                  ---�ǳ�
[Sex]         int null default (0),         ---�Ա�{0|���ܣ�1|�У�2|Ů}
[Birth]       varchar(50),                  ---��������
[Mobile]      varchar(20),                  ---�ֻ�����
[RealName]    varchar(50),                  ---��ʵ����
[UserPic]     varchar(200),                 ---ͷ��·��
[Email]       varchar(200),                 ---�����ַ
[Address]     varchar(200),                 ---��ס��ַ
[Content]     text,							---��Ա����
[LogIp]       varchar(50),                  ---��¼IP
[Lotimes]     int null default (0),         ---��¼����
[CloseS]      int null default (0),			---�Ƿ�ر�
[Atime]       datetime not null default (getdate()),
)

/* ���ͼƬ */
create table [e_ads_flash]
(
[Number]      varchar(50) primary key,		---����
[upid]        varchar(60),                  ---
[url]         varchar(200),                 ---����·��
[ImgS]        varchar(200),                 ---ͼƬ
[title]       varchar(200),                 ---����
[Description] varchar(255),                 ---ͼƬ����
[CloseS] int null default (0),				---�Ƿ�ر�
[Stat] int null default (0),				---����
[Reded] int null default (0),				---�Ƿ��Ƽ�
[Atime] datetime not null default (getdate()),
)

/* Flash�л�ͼƬ */
create table [e_flash]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(20),					---
[url]    varchar(200),					---����
[ImgS]   varchar(200),					---����ͼƬ
[title]  varchar(200),					---������
[Description] varchar(255),             ---ͼƬ����
[CloseS] int null default (0),			---�Ƿ�ر�
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[Stat]   int null default (0),			---����
[Atime]   datetime not null default (getdate()),
)

/* ��Ʒ���� */
create table [e_goods_cate]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),					---������
[title]  varchar(200),					---����
[sitetitle]   varchar(255),			          ---ҳ�����
[Keywords]    varchar(255),			          ---ҳ��ؼ���
[Description] varchar(255),			          ---ҳ������
[CloseS] int null default (0),			---�Ƿ�ر�
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[top]    int null default (0),		    ---�Ƽ���ʾ
[Stat]   int null default (0),			---����
[Grade]  int null default (0),	        ---�ȼ���
[Atime]   datetime not null default (getdate()),
)

/* �����ؼ��ʱ� */
create table [e_keydata]
(
[Number] varchar(50) primary key,		---����
[upid] varchar(50) null default ('0'),	---�������
[keywords] varchar(250),				---�ؼ���
[num] int null default (0),				---��������
[keydate] varchar(200),					---���һ������ʱ��
[UserHostAddress] varchar(200),			---�ͻ��˵� IP
[UserHostName] varchar(200),			---�ͻ��˵� DNS ��
[CloseS] int null default (0),			---�Ƿ�ر�
[Stat] int null default (0),			---����
[Reded] int null default (0),			---�Ƿ��Ƽ�
[hot] int null default (0),			    ---�Ƿ�����
[Atime] datetime not null default (getdate()),
)

/* �������� */
create table [e_navigation]
(
[Number]      varchar(50) primary key,		  ---����
[upid]        varchar(200),				      ---������
[title]       varchar(200),				      ---����
[sitetitle]   varchar(255),			          ---ҳ�����
[Keywords]    varchar(255),			          ---ҳ��ؼ���
[Description] varchar(255),			          ---ҳ������
[url]         varchar(200),				      ---����
[Stat]        int null default (0),		      ---����
[CloseS]      int null default (0),		      ---�Ƿ�ر�
[Reded]       int null default (0),			  ---�Ƿ��Ƽ�
[Atime]       datetime not null default (getdate()),
)

/* ������Ϣ */
create table [e_helplist]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),					---������
[title]  varchar(200),					---����
[url]    varchar(200),				    ---����
[CloseS] int null default (0),			---�Ƿ�ر�
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[Stat]   int null default (0),			---����
[Grade]  int null default (0),	        --- �ȼ���
[Atime]  datetime not null default (getdate()),
)

/* ������Ʒ�� */
create table [e_goods]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---һ��������
[upids]  varchar(50),                   ---����������
[emid]   varchar(50),                   ---��Ʒ���
[title]  varchar(200),					---����
[subtitle]  varchar(200),				---�ӱ���
[price]  money,                         ---�۸�   
[ImgS]   varchar(255),					---����ͼ
[BuyT]   int null default (0),			---�������
[ScanT]  int null default (0),			---�������
[sitetitle]   varchar(255),			    ---ҳ�����
[Keywords]    varchar(255),			    ---ҳ��ؼ���
[Description] varchar(255),			    ---ҳ������
[Content]  text,			            ---������Ϣ
[PackList] text,                        ---��װ�嵥
[CloseS] int null default (0),			---�Ƿ�ر�
[Stat]   int null default (0),			---����
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[hot] int null default (0),			    ---�Ƿ�����
[Atime] datetime not null default (getdate()),
)

/* ��Ʒ����ͼƬ */
create table [e_goods_pic]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---������
[title]  varchar(250),                  ---����
[ImgS]   text,                          ---ͼƬ·��
[CloseS] int null default (0),			---�Ƿ�ر�
[Stat]   int null default (0),			---����
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[Atime] datetime not null default (getdate()),
)

/* ���ﳵ */
create table [e_cart]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---�û����
[emid]   varchar(50),                   ---��Ʒ���
[title]  varchar(200),					---��Ʒ����
[price]  money,                         ---�۸�
[ImgS]   varchar(255),					---����ͼ
[count]  int null default (0),			---����
[Atime] datetime not null default (getdate()),
)


/* �ҵĶ��� */
create table [e_order]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---�û����
[emid]   varchar(50),                   ---��Ʒ���
[title]  varchar(200),					---��Ʒ����
[price]  money,                         ---�������
[ImgS]   varchar(255),					---����ͼ
[Stus]   int null default (0),			---����״̬{0|ȷ���ջ���1|����ɹ����2|��ɽ���}
[count]  int null default (0),			---����
[CloseS] int null default (0),			---�Ƿ�ر�
[Stat]   int null default (0),			---����
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[Atime] datetime not null default (getdate()),
)

/* �ջ���ַ */
create table [e_address]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---�û����
[receN]  varchar(50),                   ---�ջ���
[receA]  varchar(200),                  ---�ջ���ַ
[receAD] varchar(250),                  ---��ϸ��ַ
[Code]   varchar(20),                   ---�ʱ�
[Mobile] varchar(20),                   ---�ֻ�����
[Phone]  varchar(20),                   ---�̶��绰
[Atime] datetime not null default (getdate()),
)

/* ��Ʒ���� */
create table [e_appra]
(
[Number] varchar(50) primary key,		---����
[upid]   varchar(50),                   ---�û����
[emid]   varchar(50),                   ---��Ʒ���
[Name]   varchar(50),                   ---�û���
[title]  varchar(200),					---��Ʒ����
[Level]  int not null default(0),       ---���۵ȼ�{0|������1|������2|����}
[Content]   text,			            ---������Ϣ
[buyTime]   datetime,                   ---����ʱ��
[CloseS] int null default (0),			---�Ƿ�ر�
[Stat]   int null default (0),			---����
[Reded]  int null default (0),			---�Ƿ��Ƽ�
[Atime] datetime not null default (getdate()),
)