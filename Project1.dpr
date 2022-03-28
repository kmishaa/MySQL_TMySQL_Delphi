program Project1;

{$APPTYPE CONSOLE}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, MySQL, MySQLClasses, ComCtrls, Menus, ExtCtrls;

var
  MSQL : TMySQL;
  ending : string;

//http://www.delphikingdom.com/asp/viewitem.asp?catalogid=1318
begin
  MSQL := TMySQL.Create;
  MSQL.Host := 'localhost';
  MSQL.Port := 3306;
  MSQL.User := 'root';
  MSQL.Password := 'Mishana4626';

  if not MSQL.Connect then
  begin
    Writeln('Connection ERROR');
  end;
  Writeln('Connection is ready!');

  if MSQL.ExecSQL('CREATE DATABASE IF NOT EXISTS `my_db`') then
    MSQL.Database := 'my_db';

  if MSQL.Database <> 'my_db' then
    begin
      Writeln('DB creating ERROR');
   end;
   Writeln('Database succesfully created!');

   if not MSQL.ExecSQL(
        ' CREATE TABLE IF NOT EXISTS `Students` ('
      + '   `ID` INT AUTO_INCREMENT PRIMARY KEY,'
      + '   `Name` VARCHAR(20),'
      + '   `Surname` VARCHAR(30),'
      + '   `Age` INT)' )
    then
    begin
      Writeln('Tbl creating ERROR');
    end;
    Writeln('Table "Students" succesfully created!');



  MSQL.Disconnect;
  Writeln('Connection is over');
  Readln(ending);
end.
 