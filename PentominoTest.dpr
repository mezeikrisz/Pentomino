program PentominoTest;

uses
  Forms,
  GUITestRunner in '..\DUnit_maradjon_itt\src\GUITestRunner.pas' {GUITestRunner},
  TestFramework in '..\DUnit_maradjon_itt\src\TestFramework.pas',
  Main in 'Main.pas' {frmMain},
  MainTest in 'MainTest.pas';

{$R *.res}

begin
  GUITestRunner.RunRegisteredTests;
end.
