unit NetLock;

interface

uses
  WinTypes;

{ Core routine that mimics Win32 parameter set }
function AMIGLockFile(Handle: smallint; FileOffsetLow, FileOffsetHigh,
                  LockBytesLow, LockBytesHigh: smallint): Bool;
{ Handle based routine that un/locks a given number of bytes }
function AMIGLockFileArea(Handle: smallint; FileOffset, LockBytes: Longint;
                      Unlock: Boolean): Bool;
{ File variable based routine that un/locks a given number of records }
function AMIGLockFileVarArea(var FileVar; RecordNumber, NumRecords: Longint;
                         Unlock: Boolean): Bool;
{ File variable based routine that un/locks one record }
function AMIGLockFileVar(var FileVar; RecordNumber: Longint;
                     Unlock: Boolean): Bool;

implementation

uses
  SysUtils, WinProcs;

const
  LockSpecifier: Byte = 0;

{ Core routine that mimics Win32 parameter set }
//
// This routine crashes the whole system under the 32 bit version
// using the built in lockfile function with same params instead
//
function AMIGLockFile(Handle: smallint; FileOffsetLow, FileOffsetHigh,
  LockBytesLow, LockBytesHigh: smallint): Bool; assembler;
asm
  mov ah, $5C
  mov al, LockSpecifier
  mov bx, Handle
  mov cx, FileOffsetHigh
  mov dx, FileOffsetLow
  mov si, LockBytesHigh
  mov di, LockBytesLow
  int $21
  jnc @1
  xor ax, ax
  jmp @2
 @1:
  mov ax, 1
 @2:
end;

{ Handle based routine that un/locks a given number of bytes }
function AMIGLockFileArea(Handle: smallint; FileOffset, LockBytes: Longint;
                      Unlock: Boolean): Bool;
begin
  LockSpecifier := Byte(Unlock);
  Result := LockFile(Handle, LoWord(FileOffset),
    HiWord(FileOffset), LoWord(LockBytes), HiWord(LockBytes));
end;

{ File variable based routine that un/locks a given number of records }
function AMIGLockFileVarArea(var FileVar; RecordNumber, NumRecords: Longint;
                         Unlock: Boolean): Bool;
begin
  with TFileRec(FileVar) do
    Result := AMIGLockFileArea(Handle, Recordnumber * longint(RecSize),
                           NumRecords * longint(RecSize), Unlock);
end;

{ File variable based routine that un/locks one record }
function AMIGLockFileVar(var FileVar; RecordNumber: Longint;
                        Unlock: Boolean): Bool;
begin
  Result := AMIGLockFileVarArea(FileVar, RecordNumber, 1, Unlock);
end;

end.
