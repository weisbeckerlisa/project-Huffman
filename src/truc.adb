with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with System.Assertions; use System.Assertions;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;

procedure truc is
    pragma Assertion_Policy (Assert => Check);
begin
    pragma Assert(1=2);
end;
