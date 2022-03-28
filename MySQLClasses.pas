unit MySQLClasses;

interface

uses Windows, SysUtils, MySQL;

type
  TMySqlNotifyEvent = procedure(Sender: TObject) of object;
  IMySQLQuery = interface;
  TMySQL = class;

  IMySQL = interface(IInterface)
    function GetConnected: Boolean;
    function GetConnectionCount: Integer;
    function GetMySQL: PMySQL;
    function GetDatabase: AnsiString;
    function GetHost: AnsiString;
    function GetPassword: AnsiString;
    function GetPort: Integer;
    function GetUser: AnsiString;
    function GetAffectedRows: Integer;
    function GetOnConnect: TMySqlNotifyEvent;
    function GetOnDisconnect: TMySqlNotifyEvent;
    procedure SetPort(Value: Integer);
    procedure SetHost(const Value: AnsiString);
    procedure SetPassword(const Value: AnsiString);
    procedure SetDatabase(const Value: AnsiString);
    procedure SetUser(const Value: AnsiString);
    procedure SetOnConnect(Value: TMySqlNotifyEvent);
    procedure SetOnDisconnect(Value: TMySqlNotifyEvent);

    //���������� ������ � ������� ������ ������������ ������.
    //� ������ ������ ���������� ������� ��� �� ������ ���������
    function MySQLObj: TMySQL;
    function Connect: Boolean;
    procedure Disconnect;
    function ExecSQL(const SQL: AnsiString): Boolean;
    function Query(const SQL: AnsiString): IMySQLQuery;
    function ErrorCode: Integer;
    function ErrorMessage: AnsiString;
    function GetStatus: AnsiString;

    property AffectedRows: Integer read GetAffectedRows;
    property Connected: Boolean read GetConnected;
    property ConnectionCount: Integer read GetConnectionCount;
    property MySQL: PMySQL read GetMySQL;
    property Port: Integer read GetPort write SetPort;
    property Host: AnsiString read GetHost write SetHost;
    property User: AnsiString read GetUser write SetUser;
    property Password: AnsiString read GetPassword write SetPassword;
    property Database: AnsiString read GetDatabase write SetDatabase;
    property OnConnect: TMySqlNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TMySqlNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    //property OnQuery: TOnQueryEvent read FOnQuery write FOnQuery;
  end;

  IMySQLQuery = interface(IInterface)
    function GetMySQL: IMySQL;
    function GetFieldCount: Integer;
    function GetRecNo: Integer;
    function GetRecordCount: Integer;
    function GetFieldName(Index: Integer): AnsiString;
    function GetField(Index: Integer): pmysql_field;
    function GetFieldIndex(const Name: AnsiString): Integer;
    function GetValues(FieldNo: Integer): AnsiString;
    function GetValueByName(const FieldName: AnsiString): AnsiString;

    function FetchRow(ARecNo: Integer = -1): Boolean;
    procedure GoToRow(ARecNo: Integer);

    function IsNull(FieldNo: Integer): Boolean;
    property MySQL: IMySQL read GetMySQL;
    property RecNo: Integer read GetRecNo;
    property RecordCount: Integer read GetRecordCount;
    property FieldCount: Integer read GetFieldCount;
    property FieldIndex[const Name: AnsiString]: Integer read GetFieldIndex;
    property FieldName[Index: Integer]: AnsiString read GetFieldName;
    property Fields[Index: Integer]: pmysql_field read GetField;
    property Values[FieldNo: Integer]: AnsiString read GetValues; default;
    property ValueByName[const FieldName: AnsiString]: AnsiString read GetValueByName;
  end;

  TMySQL = class(TInterfacedObject, IMySQL)
  private
    FConnectionCount: Integer;
    FMySQL: pmysql;
    FPort: Integer;
    FPassword: AnsiString;
    FDatabase: AnsiString;
    FHost: AnsiString;
    FUser: AnsiString;
    FOnConnect: TMySqlNotifyEvent;
    FOnDisconnect: TMySqlNotifyEvent;
    //FOnQuery: TOnQueryEvent;

    procedure SetConnect(Value: Boolean);
    { IMySQL }
    function MySQLObj: TMySQL;
    function GetConnected: Boolean;
    function GetConnectionCount: Integer;
    function GetMySQL: PMySQL;
    function GetDatabase: AnsiString;
    function GetHost: AnsiString;
    function GetPassword: AnsiString;
    function GetPort: Integer;
    function GetUser: AnsiString;
    function GetAffectedRows: Integer;
    function GetOnConnect: TMySqlNotifyEvent;
    function GetOnDisconnect: TMySqlNotifyEvent;
    procedure SetPort(Value: Integer);
    procedure SetHost(const Value: AnsiString);
    procedure SetPassword(const Value: AnsiString);
    procedure SetDatabase(const Value: AnsiString);
    procedure SetUser(const Value: AnsiString);
    procedure SetOnConnect(Value: TMySqlNotifyEvent);
    procedure SetOnDisconnect(Value: TMySqlNotifyEvent);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    { IMySQL }
    function Connect: Boolean; virtual;
    procedure Disconnect; virtual;
    function ExecSQL(const SQL: AnsiString): Boolean; virtual;
    function Query(const SQL: AnsiString): IMySQLQuery;
    function ErrorCode: Integer;
    function ErrorMessage: AnsiString;
    function GetStatus: AnsiString;

    { IMySQL }
    property AffectedRows: Integer read GetAffectedRows;
    property Connected: Boolean read GetConnected;
    property ConnectionCount: Integer read GetConnectionCount;
    property MySQL: PMySQL read GetMySQL;
    property Port: Integer read GetPort write SetPort default 3306;
    property Host: AnsiString read GetHost write SetHost;
    property User: AnsiString read GetUser write SetUser;
    property Password: AnsiString read GetPassword write SetPassword;
    property Database: AnsiString read GetDatabase write SetDatabase;
    property OnConnect: TMySqlNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TMySqlNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    //property OnQuery: TOnQueryEvent read FOnQuery write FOnQuery;
  end;

  TMySQLQuery = class(TInterfacedObject, IMySQLQuery)
  private
    FRecNo: Integer;
    FRecordCount: Integer;
    FFieldCount: Integer;
    FMySQL: IMySQL;
    FRow: pmysql_row;
    FRes: pmysql_res;
    FFields: pmysql_fields;
  private
    {IMySQLQuery}
    function GetMySQL: IMySQL;
    function GetFieldCount: Integer;
    function GetRecNo: Integer;
    function GetRecordCount: Integer;
    function GetFieldName(Index: Integer): AnsiString;
    function GetField(Index: Integer): pmysql_field;
    function GetFieldIndex(const Name: AnsiString): Integer;
    function GetValues(FieldNo: Integer): AnsiString;
    function GetValueByName(const FieldName: AnsiString): AnsiString;
  public
    constructor Create(AMySQL: IMySQL; ARes: pmysql_res);
    destructor Destroy; override;
  public
    {IMySQLQuery}
    function FetchRow(ARecNo: Integer = -1): Boolean;
    procedure GoToRow(ARecNo: Integer);
    {IMySQLQuery}
    function IsNull(FieldNo: Integer): Boolean;
    property MySQL: IMySQL read GetMySQL;
    property RecNo: Integer read GetRecNo;
    property RecordCount: Integer read GetRecordCount;
    property FieldCount: Integer read GetFieldCount;
    property FieldIndex[const Name: AnsiString]: Integer read GetFieldIndex;
    property FieldName[Index: Integer]: AnsiString read GetFieldName;
    property Fields[Index: Integer]: pmysql_field read GetField;
    property Values[FieldNo: Integer]: AnsiString read GetValues; default;
    property ValueByName[const FieldName: AnsiString]: AnsiString read GetValueByName;
  end;

function MySQLStr(MySQL: IMySQL; const Str: AnsiString; EmptyAsNull: Boolean=false): AnsiString;
function MySQLInsertId(MySQL: IMySQL): Integer;

var
  MySqlFormatSettings: TFormatSettings;

implementation

function MySQLInsertId(MySQL: IMySQL): Integer;
begin
  Result := mysql_insert_id(MySQL.MySQL);
end;

function MySQLStr(MySQL: IMySQL; const Str: AnsiString; EmptyAsNull: Boolean=false): AnsiString;
var
  I: Longint;
begin
  if Str = '' then
  begin
    if EmptyAsNull then
      Result := 'NULL'
    else
      Result := '""';
    Exit;
  end;
  SetLength(Result, Length(Str) * 2);
  I := mysql_real_escape_string(MySQL.MySQL, Pointer(Result), Pointer(Str), Length(Str));
  SetLength(Result, I);
  Result := '"' + Result + '"';
end;

{ TMySQL }

constructor TMySQL.Create;
begin
  inherited;
  FConnectionCount := 0;
  FPort := 3306;
  FHost := 'localhost';
end;

destructor TMySQL.Destroy;
begin
  Disconnect;
  inherited;
end;

function TMySQL.Connect: Boolean;
begin
  SetConnect(True);
  Result := Connected;
end;

procedure TMySQL.Disconnect;
begin
  SetConnect(False);
end;

procedure TMySQL.SetConnect(Value: Boolean);
var
  FConnected: Boolean;
  FConnection: pmysql;
begin
  if Value then
  begin
    if FConnectionCount = 0 then //���� ��� ��� �����������, ��
    begin
      if FPort = 0 then FPort := 3306;
      try
        FMySQL := mysql_init(nil);
        FConnection := mysql_real_connect(FMySQL, PAnsiChar(FHost), PAnsiChar(FUser),
          PAnsiChar(FPassword), PAnsiChar(FDatabase), FPort, nil, 0); //����������� � MySQL
        FConnected := FConnection <> nil;
      except
        FConnected := False;
      end;

    end else
      FConnected := True; //���� fconnectioncount > 0 ������
                          //�����-�� �� ��� ������ ������������
    if FConnected then
       Inc(FConnectionCount);

    if FConnectionCount = 1 then
      if Assigned(FOnConnect) then FOnConnect(Self);
  end else
  begin
    if FConnectionCount > 0 then
    begin
      Dec(FConnectionCount);

      if FConnectionCount = 0 then
      begin
        mysql_close(FMySQL);
        if Assigned(FOnDisconnect) then FOnDisconnect(Self);
      end;
    end;
  end;
end;

{
  ���������� ���������� �����, ���������� ��������� �������� UPDATE,
  ��������� ��������� �������� DELETE ���
  ����������� ��������� �������� INSERT.
  ����� ���� ������� ���������� ����� mysql_query() ��� ������ UPDATE, DELETE
  ��� INSERT.
  ��� ������ SELECT mysql_affected_rows() �������� ���������� mysql_num_rows().

  ������������ ��������:
  ����� ����� ������ ���� ����� ���������� �����, ������������ ����������� ���
  �����������. ���� ���������, ��� �� ���� �� ������� �� ���� ��������� ���
  ������� UPDATE, �� ���� �� ����� �� ������� � ������������ WHERE � ������
  ������� ��� ��� �� ���� ������ ��� �� ��� ��������.
  �������� -1 ����������, ��� ������ ������ ��������� ������ ��� ��� ���
  ������� SELECT ������� mysql_affected_rows() ���� ������� ������ ���?��
  ������� mysql_store_result().
}
function TMySQL.GetAffectedRows: Integer;
begin
  if not Connected then
  begin
    Result := 0;
    Exit;
  end;

  Result := mysql_affected_rows(FMySQL);
end;

function TMySQL.GetConnected: Boolean;
begin
  Result := FConnectionCount > 0;
end;

function TMySQL.GetConnectionCount: Integer;
begin
  Result := FConnectionCount;
end;

function TMySQL.GetDatabase: AnsiString;
begin
  Result := FDatabase;
end;

function TMySQL.GetHost: AnsiString;
begin
  Result := FHost;
end;

function TMySQL.GetMySQL: PMySQL;
begin
  Result := FMySQL;
end;

function TMySQL.GetOnConnect: TMySqlNotifyEvent;
begin
  Result := FOnConnect;
end;

function TMySQL.GetOnDisconnect: TMySqlNotifyEvent;
begin
  Result := FOnDisconnect;
end;

function TMySQL.GetPassword: AnsiString;
begin
  Result := FPassword;
end;

function TMySQL.GetPort: Integer;
begin
  Result := FPort;
end;

function TMySQL.GetStatus: AnsiString;
begin
  Result := AnsiString(mysql_sqlstate(FMySQL));
end;

function TMySQL.GetUser: AnsiString;
begin
  Result := FUser;
end;

function TMySQL.MySQLObj: TMySQL;
begin
  Result := Self;
end;

{
  ��������� ������ SQL, ��������� � ���������.
  ������ ������ ������ �������� �� ����� ������� SQL.
  ������ ��������� � ���� ������� � �������� ����������� ���������
  ����� � ������� (';') ��� \g.

  ������������ ��������
  True ��� �������� ���������� �������. False, ���� ��������� ������.
}
function TMySQL.ExecSQL(const SQL: AnsiString): Boolean;
begin
  if not Connected then
  begin
    Result := False;
    Exit;
  end;
  Result := mysql_real_query(FMySQL, PAnsiChar(SQL), Length(SQL)) = 0;
end;

{
  ��������� ������ SQL, ��������� � ���������.
  ������ ������ ������ �������� �� ����� ������� SQL.
  ������ ��������� � ���� ������� � �������� ����������� ���������
  ����� � ������� (';') ��� \g.

  ������������ ��������
  IMySQLQuery ��� �������� ���������� �������. nil, ���� ��������� ������,
  ��� ��� ������ ������.
}
function TMySQL.Query(const SQL: AnsiString): IMySQLQuery;
var
  FRes: pmysql_res;
begin
  if not Connected then
  begin
    Result := nil;
    Exit;
  end;

  if (mysql_real_query(FMySQL, PAnsiChar(SQL), Length(SQL)) = 0) then
  begin
    FRes := mysql_store_result(FMySQL);
    if FRes <> nil then
      Result := TMySQLQuery.Create(Self, FRes)
    else
      Result := nil;
  end else
    Result := nil;
  //if Assigned(FOnQuery) then FOnQuery(Self, sql);
end;

function TMySQL.ErrorCode: Integer;
begin
  Result := mysql_errno(FMySQL);
end;

function TMySQL.ErrorMessage: AnsiString;
begin
  Result := AnsiString(mysql_error(FMySQL));
end;

procedure TMySQL.SetPort(Value: Integer);
begin
  if Connected then Exit;
  FPort := Value;
end;

procedure TMySQL.SetHost(const Value: AnsiString);
begin
  if Connected then Exit;
  FHost := Value;
end;

procedure TMySQL.SetOnConnect(Value: TMySqlNotifyEvent);
begin
  FOnConnect := Value;
end;

procedure TMySQL.SetOnDisconnect(Value: TMySqlNotifyEvent);
begin
  FOnDisconnect := Value;
end;

procedure TMySQL.SetUser(const Value: AnsiString);
begin
  if Connected then Exit;
  FUser := Value;
end;

procedure TMySQL.SetPassword(const Value: AnsiString);
begin
  if Connected then Exit;
  FPassword := Value;
end;

{ ������������ � ���� ������. }
procedure TMySQL.SetDatabase(const Value: AnsiString);
begin
  if FDatabase = Value then Exit;

  if Value = '' then
  begin
    FDatabase := '';
    Exit;
  end;

  if Connected then
  begin
    if mysql_select_db(FMySQL, PAnsiChar(Value)) <> 0 then
      Exit;
  end;

  FDatabase := Value;
end;

{ TMySQLQuery }

constructor TMySQLQuery.Create(AMySQL: IMySQL; ARes: pmysql_res);
begin
  FRecNo := -1;
  FMySQL := AMySQL;
  FRes := ARes;
  FRecordCount := mysql_num_rows(FRes);
  FFieldCount := mysql_num_fields(FRes);
  FFields := mysql_fetch_fields(FRes);
end;

destructor TMySQLQuery.Destroy;
begin
  mysql_free_result(FRes);
  inherited;
end;

procedure TMySQLQuery.GoToRow(ARecNo: Integer);
begin
  if (ARecNo < 0) then ARecNo := 0
  else
  if (ARecNo >= RecordCount) then ARecNo := RecordCount - 1;

  mysql_data_seek(FRes, ARecNo);
  FRecNo := ARecNo;
  FRow := nil;
end;

{
  ���� ARecNo = -1 :
     ��������� ��������� ������ � �������������� ������ ������.
     (���� ������� ������ ��� �����������, �� ����������� ����� ������ ������.)
  ���� ARecNo <> -1 :
    ������� ������� � ������ ARecNo � ��������� � �� ��������������� ������ ������.
    (����������� ������ ����� ��������� �������� FetchRow)

  ������� ���������� True ���� ������� ������� ������ � False � ������ �������.
}
function TMySQLQuery.FetchRow(ARecNo: Integer = -1): Boolean;
begin
  if (ARecNo > -1) then
  begin
    GoToRow(ARecNo);
    FRecNo := FRecNo - 1;
  end;

  FRow := mysql_fetch_row(FRes);
  if FRow <> nil then
  begin
    Inc(FRecNo);
    Result := True;
  end else
    Result := False;
end;

function TMySQLQuery.IsNull(FieldNo: Integer): Boolean;
begin
  if FRow = nil then
    Result := True
  else
    Result := FRow[FieldNo] = nil;
end;

function TMySQLQuery.GetValues(FieldNo: Integer): AnsiString;
var
  lengths: Pointer;
  length: Integer;
begin
  if IsNull(FieldNo) then
    Result := ''
  else begin
    Lengths := mysql_fetch_lengths(FRes);
    if Lengths <> nil then
    begin
      length := PCardinal(LongInt(Lengths) + FieldNo * SizeOf(Cardinal))^;
      SetLength(Result, length);
      Move(FRow[FieldNo]^, Pointer(Result)^, length);
    end else
      Result := '';
  end;
end;

function TMySQLQuery.GetValueByName(const FieldName: AnsiString): AnsiString;
var
  Index: Integer;
begin
  Index := GetFieldIndex(FieldName);
  if Index < 0 then
    Result := ''
  else
    Result := GetValues(Index);
end;

function TMySQLQuery.GetField(Index: Integer): pmysql_field;
begin
  if (Index < 0) or (Index >= FFieldCount) then
    Result := nil
  else
    Result := @FFields[Index];
end;

function TMySQLQuery.GetFieldCount: Integer;
begin
  Result := FFieldCount;
end;

function TMySQLQuery.GetRecNo: Integer;
begin
  if FRow = nil then
    Result := -1
  else
    Result := FRecNo;
end;

function TMySQLQuery.GetRecordCount: Integer;
begin
  Result := FRecordCount;
end;

function TMySQLQuery.GetFieldIndex(const Name: AnsiString): Integer;
begin
  for Result := 0 to FieldCount-1 do
    if AnsiString(Fields[Result].name) = Name then
      exit;
  Result := -1;
end;

function TMySQLQuery.GetFieldName(Index: Integer): AnsiString;
begin
  Result := AnsiString(Fields[Index].name);
end;

function TMySQLQuery.GetMySQL: IMySQL;
begin
  Result := FMySQL;
end;
 
initialization
    MySqlFormatSettings.DecimalSeparator := '.';
    MySqlFormatSettings.DateSeparator := '-';
    MySqlFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    MySqlFormatSettings.TimeSeparator := ':';
    MySqlFormatSettings.ShortTimeFormat := 'hh:nn:ss';

end{$WARNINGS OFF}.
{
  ������ 1.0
  ----------
  [*]  ������ ��������� ������. (������� �����������)

  ������ 1.1
  ----------
  [*] TMySQL ��������� � IMySQL.
  ������:
      var
        MySQL: IMySQL;
      begin
        MySQL := TMySQL.Create;
        MySQL.Uset := 'root';
        ...... � ����� ��� ������
        ������� �� ������������ MyQSL �� ����
      end;

  [+] �������� FConnectionCount.
      ����� ���������� IMySQL.Connect, ��� �������! ����������, �������
      FConnectionCount �������������, IMySQL.Disconnect - ������� �����������.
      ������� ����������� ���������� ������ ����� ������� = 1,
      o��������� - ����� c������ = 0.

  [*] ������� property Fields
  [*] procedure Connect; ������� �� function Connect: Boolean; virtual;
  [*] ���������� FetchRow
  [+] ��������� function MySQLObj: TMySQL;
      �� ���������� IMySQL ����� �������� ���������� � �������
  [*] ���������� IMySQL.Values[X]
  [*] ���������� MySQLStr()
  [-] ������� IMySql.SetConnected(Value: Boolean);
      ����������� ��������� Connect/Disconnect
}
