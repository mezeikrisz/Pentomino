unit MainTest;

interface

uses
  TestFrameWork, Main, Sysutils;

implementation

type
  TMainTest = class(TTestCase)
  private
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure testMozaikHasonlit;
    procedure testMozaikSerialize;
    procedure testMozaikDeSerialize;
    procedure testMozaikForgat;
    procedure testMozaikTukroz;
    procedure testMozaikNormalizal;
    procedure testMozaikValtoztat;
    procedure testJatekterHasonlit;
    procedure testJatekterSerialize;
    procedure testJatekterDeSerialize;
    procedure testJatekterLyukLenneEgy;
    procedure testJatekterLyukLenneKetto;
    procedure testJatekterLyukLenneHarom;
    procedure testJatekterLyukLenneNegy;
    procedure testJatekterKeresElsoUres;
    procedure testJatekterKirakhatoIde;
    procedure testJatekterKirak;
    procedure testJatekterLevesz;
    procedure testJatekterKeszVan;
  end;

{ TMainTest }

procedure TMainTest.SetUp;
begin
  inherited;
end;

procedure TMainTest.TearDown;
begin
  inherited;
end;

procedure TMainTest.testMozaikHasonlit;
var t: TNegyzet;
    mMozaikUres, mMozaikHosszu: TMozaik;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  //k�db�l nem tudok ett�l szebb t�mb �rt�kad�st. deklar�ci�ban megy (oMozaikTomb), k�db�l nem. lok�lis deklar�ci�ban sem
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikUres.Hasonlit(t), 'Mozaik Hasonlit 1');

  t[1, 1] := 'A';   t[1, 2] := 'A';   t[1, 3] := 'A';   t[1, 4] := 'A';   t[1, 5] := 'A';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHosszu.Hasonlit(t), 'Mozaik Hasonlit 2');

  mMozaikUres.Free;
  mMozaikHosszu.Free;
end;

procedure TMainTest.testMozaikSerialize;
var mMozaikUres, mMozaikHosszu: TMozaik;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  Check(mMozaikUres.Serialize = '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10, 'Mozaik Serialize 1');

  Check(mMozaikHosszu.Serialize = 'AAAAA'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10, 'Mozaik Serialize 2');

  mMozaikUres.Free;
  mMozaikHosszu.Free;
end;

procedure TMainTest.testMozaikDeSerialize;
var s: String;
    mMozaikMindegy: TMozaik;
begin
  mMozaikMindegy := TMozaik.Create(Ures);

  s := '*....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  Check(mMozaikMindegy.Serialize = s, 'Mozaik DeSerialize+Serialize 1');

  s := '.***.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  mMozaikMindegy.DeSerialize(s);
  Check(mMozaikMindegy.Serialize = s, 'Mozaik DeSerialize+Serialize 2');

  mMozaikMindegy.Free;

  //itt van az�rt egy tervez�si baki: a serialize-deserialize nem is a TMozaikhoz k�ne, hanem a benne szerepl� TNegyzethez, ugyanis ezek a f�ggv�nyek nem a teljes �llapotot pakolj�k ide-oda, pl biztosan nem megy �t a mozaiktipus, valtozatindex
  //ez am�gy csak a serialize/deserialize r�szn�l gond. Egyben kellenne futnia az �sszes adattagnak, elmenteni �rdemben nem lehet �gy.
  //de am�gy mintha a load-ban k�sz�ltem volna erre...
  //most �gy hagyom.

  //a k�t tengelyr�l mit tudunk? ser+deser rutinokban "i majd j" sorrend mind a ciklusokban, mind a t�mbindexben
  //ha stringesen ki�rjuk, akkor �gy �ll, mint a kezdeti t�mbkonstansokban (oMozaikTomb)
  //ha k�db�l adunk a t�mbnek �rt�ket, akkor "sorindex majd oszlopindex" a sorrend (testMozaikHasonlit)
  //minden szuper eddig. �sszes t�bbit is �talak�tani �gy!
  //TTeglalapn�l is "sorindex majd oszlopindex", "7 majd 11", "i majd j"
end;

procedure TMainTest.testMozaikForgat;
var t: TNegyzet;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TMozaik;
begin
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikHazteto.Forgat;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := 'C';   t[1, 4] := 'C';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := 'C';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Hasonlit(t), 'Mozaik Forgat 1, Hasonlit-tal');

  s := '.....'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.....'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Forgat;
  s := '.....'#13#10 +
       '.***.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.***.'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Forgat 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikTukroz;
var t: TNegyzet;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TMozaik;
begin
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikHazteto.Tukroz;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := 'C';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := 'C';   t[3, 5] := 'C';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Hasonlit(t), 'Mozaik Tukroz 1, Hasonlit-tal');

  s := '*....'#13#10 +
       '.*...'#13#10 +
       '..*..'#13#10 +
       '...*.'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Forgat;
  s := '....*'#13#10 +
       '...*.'#13#10 +
       '..*..'#13#10 +
       '.*...'#13#10 +
       '*....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Tukroz 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikNormalizal;
var t: TNegyzet;
    s: String;
    mMozaikEsbetu, mMozaikMindegy: TMozaik;
begin
  mMozaikEsbetu := TMozaik.Create(Esbetu);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikEsbetu.Forgat;
  mMozaikEsbetu.Forgat;
  mMozaikEsbetu.Normalizal;
  t[1, 1] := 'L';   t[1, 2] := 'L';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := 'L';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := 'L';   t[3, 3] := 'L';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikEsbetu.Hasonlit(t), 'Mozaik Normalizal 1, Hasonlit-tal');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '*....'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 2, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '.*...'#13#10 +
       '.*...'#13#10 +
       '**...'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 3, DeSer+Ser');

  s := '..*..'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '*....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 4, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '..***'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fOffsetJ = 2, 'Mozaik Normalizal 5, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '*****'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fOffsetJ = 4, 'Mozaik Normalizal 6, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fOffsetJ = 0, 'Mozaik Normalizal 7, offset');


  mMozaikEsbetu.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikValtoztat;
var t: TNegyzet;
    s: String;
    mMozaikUres, mMozaikElbetu: TMozaik;
    b: Boolean;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikElbetu := TMozaik.Create(Elbetu);

  b := mMozaikUres.Valtoztat;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(b = true, 'Ures Valtoztat, kimen� �rt�k true');
  Check(mMozaikUres.Hasonlit(t), 'Ures Valtoztat, eredm�ny t�mb Hasonlit-tal');
  b := mMozaikUres.Valtoztat;
  Check(b = false, 'Ures Valtoztat, kimen� �rt�k false');
  Check(mMozaikUres.Hasonlit(t), 'Ures Valtoztat megint, eredm�ny t�mb Hasonlit-tal');

  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 1, kimen� �rt�k true');
  Check(mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 1, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := '...B.'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 2, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 2, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 3, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 3, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BBBB.'#13#10 +
       'B....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 4, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 4, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BBBB.'#13#10 +
       '...B.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 5, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 5, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 6, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 6, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'B....'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 7, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 7, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 8, kimen� �rt�k true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 8, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = false, 'Elbetu Valtoztat 9, kimen� �rt�k false');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 9, Ser');

  mMozaikUres.Free;
end;

procedure TMainTest.testJatekterHasonlit;
var t: TTeglalap;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  //k�db�l nem tudok ett�l szebb t�mb �rt�kad�st. deklar�ci�ban megy (oMozaikTomb), k�db�l nem. lok�lis deklar�ci�ban sem
  t[-4, -4] := 'M'; t[-4, -3] := 'M'; t[-4, -2] := 'M'; t[-4, -1] := 'M'; t[-4, 0] := 'M'; t[-4, 1] := 'M'; t[-4, 2] := 'M'; t[-4, 3] := 'M'; t[-4, 4] := 'M'; t[-4, 5] := 'M'; t[-4, 6] := 'M'; t[-4, 7] := 'M'; t[-4, 8] := 'M'; t[-4, 9] := 'M'; t[-4, 10] := 'M'; t[-4, 11] := 'M'; t[-4, 12] := 'M'; t[-4, 13] := 'M'; t[-4, 14] := 'M'; t[-4, 15] := 'M';
  t[-3, -4] := 'M'; t[-3, -3] := 'M'; t[-3, -2] := 'M'; t[-3, -1] := 'M'; t[-3, 0] := 'M'; t[-3, 1] := 'M'; t[-3, 2] := 'M'; t[-3, 3] := 'M'; t[-3, 4] := 'M'; t[-3, 5] := 'M'; t[-3, 6] := 'M'; t[-3, 7] := 'M'; t[-3, 8] := 'M'; t[-3, 9] := 'M'; t[-3, 10] := 'M'; t[-3, 11] := 'M'; t[-3, 12] := 'M'; t[-3, 13] := 'M'; t[-3, 14] := 'M'; t[-3, 15] := 'M';
  t[-2, -4] := 'M'; t[-2, -3] := 'M'; t[-2, -2] := 'M'; t[-2, -1] := 'M'; t[-2, 0] := 'M'; t[-2, 1] := 'M'; t[-2, 2] := 'M'; t[-2, 3] := 'M'; t[-2, 4] := 'M'; t[-2, 5] := 'M'; t[-2, 6] := 'M'; t[-2, 7] := 'M'; t[-2, 8] := 'M'; t[-2, 9] := 'M'; t[-2, 10] := 'M'; t[-2, 11] := 'M'; t[-2, 12] := 'M'; t[-2, 13] := 'M'; t[-2, 14] := 'M'; t[-2, 15] := 'M';
  t[-1, -4] := 'M'; t[-1, -3] := 'M'; t[-1, -2] := 'M'; t[-1, -1] := 'M'; t[-1, 0] := 'M'; t[-1, 1] := 'M'; t[-1, 2] := 'M'; t[-1, 3] := 'M'; t[-1, 4] := 'M'; t[-1, 5] := 'M'; t[-1, 6] := 'M'; t[-1, 7] := 'M'; t[-1, 8] := 'M'; t[-1, 9] := 'M'; t[-1, 10] := 'M'; t[-1, 11] := 'M'; t[-1, 12] := 'M'; t[-1, 13] := 'M'; t[-1, 14] := 'M'; t[-1, 15] := 'M';
  t[0, -4] := 'M';  t[0, -3] := 'M';  t[0, -2] := 'M';  t[0, -1] := 'M';  t[0, 0] := 'M';  t[0, 1] := 'M';  t[0, 2] := 'M';  t[0, 3] := 'M';  t[0, 4] := 'M';  t[0, 5] := 'M';  t[0, 6] := 'M';  t[0, 7] := 'M';  t[0, 8] := 'M';  t[0, 9] := 'M';  t[0, 10] := 'M';  t[0, 11] := 'M';  t[0, 12] := 'M';  t[0, 13] := 'M';  t[0, 14] := 'M';  t[0, 15] := 'M';
  t[1, -4] := 'M';  t[1, -3] := 'M';  t[1, -2] := 'M';  t[1, -1] := 'M';  t[1, 0] := 'M';  t[1, 1] := '.';  t[1, 2] := '.';  t[1, 3] := '.';  t[1, 4] := '.';  t[1, 5] := '.';  t[1, 6] := '.';  t[1, 7] := '.';  t[1, 8] := '.';  t[1, 9] := '.';  t[1, 10] := '.';  t[1, 11] := 'M';  t[1, 12] := 'M';  t[1, 13] := 'M';  t[1, 14] := 'M';  t[1, 15] := 'M';
  t[2, -4] := 'M';  t[2, -3] := 'M';  t[2, -2] := 'M';  t[2, -1] := 'M';  t[2, 0] := 'M';  t[2, 1] := '.';  t[2, 2] := '.';  t[2, 3] := '.';  t[2, 4] := '.';  t[2, 5] := '.';  t[2, 6] := '.';  t[2, 7] := '.';  t[2, 8] := '.';  t[2, 9] := '.';  t[2, 10] := '.';  t[2, 11] := 'M';  t[2, 12] := 'M';  t[2, 13] := 'M';  t[2, 14] := 'M';  t[2, 15] := 'M';
  t[3, -4] := 'M';  t[3, -3] := 'M';  t[3, -2] := 'M';  t[3, -1] := 'M';  t[3, 0] := 'M';  t[3, 1] := '.';  t[3, 2] := '.';  t[3, 3] := '.';  t[3, 4] := '.';  t[3, 5] := '.';  t[3, 6] := '.';  t[3, 7] := '.';  t[3, 8] := '.';  t[3, 9] := '.';  t[3, 10] := '.';  t[3, 11] := 'M';  t[3, 12] := 'M';  t[3, 13] := 'M';  t[3, 14] := 'M';  t[3, 15] := 'M';
  t[4, -4] := 'M';  t[4, -3] := 'M';  t[4, -2] := 'M';  t[4, -1] := 'M';  t[4, 0] := 'M';  t[4, 1] := '.';  t[4, 2] := '.';  t[4, 3] := '.';  t[4, 4] := '.';  t[4, 5] := '.';  t[4, 6] := '.';  t[4, 7] := '.';  t[4, 8] := '.';  t[4, 9] := '.';  t[4, 10] := '.';  t[4, 11] := 'M';  t[4, 12] := 'M';  t[4, 13] := 'M';  t[4, 14] := 'M';  t[4, 15] := 'M';
  t[5, -4] := 'M';  t[5, -3] := 'M';  t[5, -2] := 'M';  t[5, -1] := 'M';  t[5, 0] := 'M';  t[5, 1] := '.';  t[5, 2] := '.';  t[5, 3] := '.';  t[5, 4] := '.';  t[5, 5] := '.';  t[5, 6] := '.';  t[5, 7] := '.';  t[5, 8] := '.';  t[5, 9] := '.';  t[5, 10] := '.';  t[5, 11] := 'M';  t[5, 12] := 'M';  t[5, 13] := 'M';  t[5, 14] := 'M';  t[5, 15] := 'M';
  t[6, -4] := 'M';  t[6, -3] := 'M';  t[6, -2] := 'M';  t[6, -1] := 'M';  t[6, 0] := 'M';  t[6, 1] := '.';  t[6, 2] := '.';  t[6, 3] := '.';  t[6, 4] := '.';  t[6, 5] := '.';  t[6, 6] := '.';  t[6, 7] := '.';  t[6, 8] := '.';  t[6, 9] := '.';  t[6, 10] := '.';  t[6, 11] := 'M';  t[6, 12] := 'M';  t[6, 13] := 'M';  t[6, 14] := 'M';  t[6, 15] := 'M';
  t[7, -4] := 'M';  t[7, -3] := 'M';  t[7, -2] := 'M';  t[7, -1] := 'M';  t[7, 0] := 'M';  t[7, 1] := 'M';  t[7, 2] := 'M';  t[7, 3] := 'M';  t[7, 4] := 'M';  t[7, 5] := 'M';  t[7, 6] := 'M';  t[7, 7] := 'M';  t[7, 8] := 'M';  t[7, 9] := 'M';  t[7, 10] := 'M';  t[7, 11] := 'M';  t[7, 12] := 'M';  t[7, 13] := 'M';  t[7, 14] := 'M';  t[7, 15] := 'M';
  t[8, -4] := 'M';  t[8, -3] := 'M';  t[8, -2] := 'M';  t[8, -1] := 'M';  t[8, 0] := 'M';  t[8, 1] := 'M';  t[8, 2] := 'M';  t[8, 3] := 'M';  t[8, 4] := 'M';  t[8, 5] := 'M';  t[8, 6] := 'M';  t[8, 7] := 'M';  t[8, 8] := 'M';  t[8, 9] := 'M';  t[8, 10] := 'M';  t[8, 11] := 'M';  t[8, 12] := 'M';  t[8, 13] := 'M';  t[8, 14] := 'M';  t[8, 15] := 'M';
  t[9, -4] := 'M';  t[9, -3] := 'M';  t[9, -2] := 'M';  t[9, -1] := 'M';  t[9, 0] := 'M';  t[9, 1] := 'M';  t[9, 2] := 'M';  t[9, 3] := 'M';  t[9, 4] := 'M';  t[9, 5] := 'M';  t[9, 6] := 'M';  t[9, 7] := 'M';  t[9, 8] := 'M';  t[9, 9] := 'M';  t[9, 10] := 'M';  t[9, 11] := 'M';  t[9, 12] := 'M';  t[9, 13] := 'M';  t[9, 14] := 'M';  t[9, 15] := 'M';
  t[10, -4] := 'M'; t[10, -3] := 'M'; t[10, -2] := 'M'; t[10, -1] := 'M'; t[10, 0] := 'M'; t[10, 1] := 'M'; t[10, 2] := 'M'; t[10, 3] := 'M'; t[10, 4] := 'M'; t[10, 5] := 'M'; t[10, 6] := 'M'; t[10, 7] := 'M'; t[10, 8] := 'M'; t[10, 9] := 'M'; t[10, 10] := 'M'; t[10, 11] := 'M'; t[10, 12] := 'M'; t[10, 13] := 'M'; t[10, 14] := 'M'; t[10, 15] := 'M';
  t[11, -4] := 'M'; t[11, -3] := 'M'; t[11, -2] := 'M'; t[11, -1] := 'M'; t[11, 0] := 'M'; t[11, 1] := 'M'; t[11, 2] := 'M'; t[11, 3] := 'M'; t[11, 4] := 'M'; t[11, 5] := 'M'; t[11, 6] := 'M'; t[11, 7] := 'M'; t[11, 8] := 'M'; t[11, 9] := 'M'; t[11, 10] := 'M'; t[11, 11] := 'M'; t[11, 12] := 'M'; t[11, 13] := 'M'; t[11, 14] := 'M'; t[11, 15] := 'M';

  Check(j.Hasonlit(t), 'Jatekter Hasonlit 1');
  j.Free;
end;

procedure TMainTest.testJatekterSerialize;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;
  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Jatekter Serialize');
  j.Free;
end;

procedure TMainTest.testJatekterDeSerialize;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;
  s := '..........'#13#10 +
       '..........'#13#10 +
       '....oo....'#13#10 +
       '....oo....'#13#10 +
       '....oo....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.Serialize = s, 'Mozaik DeSerialize+Serialize');
  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneEgy;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = false, 'LyukLenneEgy, k�t elemn�l nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = false, 'LyukLenneEgy, teli t�bl�n�l nincs lyuk, false legyen');

  s := '.DD.......'#13#10 +
       'DDD.......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 1');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 2');

  s := '.A........'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 4');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneKetto;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = false, 'LyukLenneKetto, k�t elemn�l nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = false, 'LyukLenneKetto, teli t�bl�n�l nincs lyuk, false legyen');

  s := 'AAAAA.....'#13#10 +
       '..F.......'#13#10 +
       'FFFF......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 1');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAA.'#13#10 +
       'AAAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 2');

  s := '.A........'#13#10 +
       '.A........'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 4');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 5');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneHarom;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, k�t elemn�l nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, teli t�bl�n�l nincs lyuk, false legyen');

  s := '..........'#13#10 +
       '...AAA....'#13#10 +
       '..A...A...'#13#10 +
       '...AAA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 1');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 2');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '..AA......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 4');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '.....AA...'#13#10 +
       '....A..A..'#13#10 +
       '.....A.A..'#13#10 +
       '......A...'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 5');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '.....AA...'#13#10 +
       '....A..A..'#13#10 +
       '....A.A...'#13#10 +
       '.....A....'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 6');

  s := '.AAAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       '.AAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, hat�rmenti k�nz�s 1');

  s := '.AAA..AAA.'#13#10 +
       'A.AAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'A.AAAAAAA.'#13#10 +
       '.AAA..AAA.'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, hat�rmenti k�nz�s 2');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneNegy;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, k�t elemn�l nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, teli t�bl�n�l nincs lyuk, false legyen');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAAA....'#13#10 +
       '.A....A...'#13#10 +
       '..AAAA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 1');

  s := '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 2');

  s := '..........'#13#10 +
       '..A.......'#13#10 +
       '.A.AA.....'#13#10 +
       '.A...A....'#13#10 +
       '..AAA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 3');

  s := '..........'#13#10 +
       '....A.....'#13#10 +
       '..AA.A....'#13#10 +
       '.A...A....'#13#10 +
       '..AAA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 4');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAA.....'#13#10 +
       '.A...A....'#13#10 +
       '..AA.A....'#13#10 +
       '....A.....'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 5');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAA.....'#13#10 +
       '.A...A....'#13#10 +
       '.A.AA.....'#13#10 +
       '..A.......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 6');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 7');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 8');

  s := '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 9');

  s := '....AA....'#13#10 +
       '...A..A...'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 10');

  s := '..........'#13#10 +
       '..A.......'#13#10 +
       '.A.A......'#13#10 +
       '.A..A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 11');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '.A.A......'#13#10 +
       '..A.......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 12');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 13');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '.A..A.....'#13#10 +
       '..AA......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 14');

  s := '..........'#13#10 +
       '...AAA....'#13#10 +
       '..A...A...'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 15');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '..A...A...'#13#10 +
       '...AAA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 16');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A..A....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 17');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 18');

  s := '....AA....'#13#10 +
       '...A..A...'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 19');

  s := '.AAAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       '.AAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, hat�rmenti k�nz�s 1');

  s := '.A.A..AA..'#13#10 +
       'A.AAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'A.AAAAAAA.'#13#10 +
       '.A.A..AA..'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, hat�rmenti k�nz�s 2');

  j.Free;
end;

procedure TMainTest.testJatekterKeresElsoUres;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 1) and (j.fElsoUresJ = 1), 'KeresElsoUres 1');

  s := 'AAA.......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 1) and (j.fElsoUresJ = 4), 'KeresElsoUres 2');

  s := 'AAAABBBCCC'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 2) and (j.fElsoUresJ = 1), 'KeresElsoUres 3');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDD.'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 2) and (j.fElsoUresJ = 10), 'KeresElsoUres 4');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDDD'#13#10 +
       'EEEEEEEEEE'#13#10 +
       'FFFFFFFFFF'#13#10 +
       'GGGGGGGGGG'#13#10 +
       'HHHHHHHHH.'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 6) and (j.fElsoUresJ = 10), 'KeresElsoUres 5');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDDD'#13#10 +
       'EEEEEEEEEE'#13#10 +
       'FFFFFFFFFF'#13#10 +
       'GGGGGGGGGG'#13#10 +
       'HHHHHHHHHH'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 7) and (j.fElsoUresJ = 11), 'KeresElsoUres 6, ki van rakva');

  j.Free;
end;

procedure TMainTest.testJatekterKirakhatoIde;
var s: String;
    j: TJatekTer;
    b: Boolean;
    mMozaikUres, mMozaikElbetu, mMozaikKereszt, mMozaikLepcso, mMozaikHosszu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikLepcso := TMozaik.Create(Lepcso);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikUres, 1, 1);
  Check(b, 'KirakhatoIde true 1');
  b := j.KirakhatoIde(mMozaikUres, 1, 10);
  Check(b, 'KirakhatoIde true 2');
  b := j.KirakhatoIde(mMozaikUres, 6, 10);
  Check(b, 'KirakhatoIde true 3');
  b := j.KirakhatoIde(mMozaikElbetu, 1, 1);
  Check(b, 'KirakhatoIde true 4');
  b := j.KirakhatoIde(mMozaikElbetu, 1, 9);
  Check(b, 'KirakhatoIde true 5');
  b := j.KirakhatoIde(mMozaikElbetu, 3, 9);
  Check(b, 'KirakhatoIde true 6');
  b := j.KirakhatoIde(mMozaikElbetu, 4, 9);
  Check(not b, 'KirakhatoIde false 7');
  b := j.KirakhatoIde(mMozaikElbetu, 3, 10);
  Check(not b, 'KirakhatoIde false 8');

  s := 'AAAAAAAAAA'#13#10 +
       'BBBBBBBB..'#13#10 +
       'CC.CC.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikElbetu, 2, 8);
  Check(not b, 'KirakhatoIde false 9');
  b := j.KirakhatoIde(mMozaikElbetu, 2, 9);
  Check(b, 'KirakhatoIde true 10');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 1);
  Check(not b, 'KirakhatoIde false 11');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 2);
  Check(not b, 'KirakhatoIde false 12');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 3);
  Check(b, 'KirakhatoIde true 13');

  s := 'AAAAAAAAAA'#13#10 +
       'BBBBBBBBBB'#13#10 +
       'CCCCCCCCCC'#13#10 +
       'DDDDDDDD.D'#13#10 +
       'EEEEEEE...'#13#10 +
       'FFFFFFFF.F'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikKereszt, 4, 7);
  Check(not b, 'KirakhatoIde false 14');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 8);
  Check(not b, 'KirakhatoIde false 15');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 9);
  Check(b, 'KirakhatoIde true 16');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 10);
  Check(not b, 'KirakhatoIde false 17');


  s := 'AAAAAAAAAA'#13#10 +
       'BBBBB.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikLepcso, 2, 5);
  Check(not b, 'KirakhatoIde false 18');
  b := j.KirakhatoIde(mMozaikLepcso, 2, 6);
  Check(b, 'KirakhatoIde true 19');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 5);
  Check(not b, 'KirakhatoIde false 20');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 6);
  Check(b, 'KirakhatoIde true 21');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 7);
  Check(not b, 'KirakhatoIde false 21');
  b := j.KirakhatoIde(mMozaikHosszu, 6, 10);
  Check(not b, 'KirakhatoIde false 22');

  mMozaikUres.Free;
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikLepcso.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterKirak;
var s: String;
    j: TJatekTer;
    mMozaikUres, mMozaikKereszt, mMozaikElbetu, mMozaikHosszu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  j.Kirak(mMozaikUres, 1, 1);
  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Kirak 1');

  j.Kirak(mMozaikHosszu, 1, 1);
  j.Kirak(mMozaikKereszt, 1, 6);
  j.Kirak(mMozaikElbetu, 3, 7);
  s := 'AAAAAE....'#13#10 +
       '....EEE...'#13#10 +
       '.....EBB..'#13#10 +
       '.......B..'#13#10 +
       '.......B..'#13#10 +
       '.......B..'#13#10;
  Check(j.Serialize = s, 'Kirak 2');

  mMozaikUres.Free;
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterLevesz;
var s: String;
    j: TJatekTer;
    mMozaikHosszu, mMozaikElbetu, mMozaikHazteto, mMozaikSonka, mMozaikKereszt, mMozaikPuska, mMozaikLapat, mMozaikCsunya, mMozaikTebetu, mMozaikLepcso, mMozaikUbetu, mMozaikEsbetu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikHosszu := TMozaik.Create(Hosszu);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikSonka := TMozaik.Create(Sonka);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikPuska := TMozaik.Create(Puska);
  mMozaikLapat := TMozaik.Create(Lapat);
  mMozaikCsunya :=TMozaik.Create(Csunya);
  mMozaikTebetu := TMozaik.Create(Tebetu);
  mMozaikLepcso := TMozaik.Create(Lepcso);
  mMozaikUbetu := TMozaik.Create(Ubetu);
  mMozaikEsbetu := TMozaik.Create(Esbetu);

  j.Kirak(mMozaikSonka, 1, 1);
  j.Kirak(mMozaikUbetu, 1, 4);
  j.Kirak(mMozaikCsunya, 1, 7);
  j.Kirak(mMozaikElbetu, 1, 9);
  j.Kirak(mMozaikLapat, 2, 3);
  j.Kirak(mMozaikKereszt, 2, 5);
  j.Kirak(mMozaikPuska, 2, 7);
  j.Kirak(mMozaikEsbetu, 3, 1);
  j.Kirak(mMozaikTebetu, 3, 9);
  j.Kirak(mMozaikHazteto, 4, 1);
  j.Kirak(mMozaikLepcso, 4, 6);
  j.Kirak(mMozaikHosszu, 6, 6);

  j.Levesz(mMozaikHosszu, 6, 6);
  j.Levesz(mMozaikLepcso, 4, 6);
  j.Levesz(mMozaikHazteto, 4, 1);
  j.Levesz(mMozaikTebetu, 3, 9);
  j.Levesz(mMozaikEsbetu, 3, 1);
  j.Levesz(mMozaikPuska, 2, 7);
  j.Levesz(mMozaikKereszt, 2, 5);
  j.Levesz(mMozaikLapat, 2, 3);
  j.Levesz(mMozaikElbetu, 1, 9);
  j.Levesz(mMozaikCsunya, 1, 7);
  j.Levesz(mMozaikUbetu, 1, 4);
  j.Levesz(mMozaikSonka, 1, 1);

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Levesz 1');

  mMozaikHosszu.Free;
  mMozaikElbetu.Free;
  mMozaikHazteto.Free;
  mMozaikSonka.Free;
  mMozaikKereszt.Free;
  mMozaikPuska.Free;
  mMozaikLapat.Free;
  mMozaikCsunya.Free;
  mMozaikTebetu.Free;
  mMozaikLepcso.Free;
  mMozaikUbetu.Free;
  mMozaikEsbetu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterKeszVan;
var s: String;
    j: TJatekTer;
    mMozaikHosszu, mMozaikElbetu, mMozaikHazteto, mMozaikSonka, mMozaikKereszt, mMozaikPuska, mMozaikLapat, mMozaikCsunya, mMozaikTebetu, mMozaikLepcso, mMozaikUbetu, mMozaikEsbetu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikHosszu := TMozaik.Create(Hosszu);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikSonka := TMozaik.Create(Sonka);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikPuska := TMozaik.Create(Puska);
  mMozaikLapat := TMozaik.Create(Lapat);
  mMozaikCsunya :=TMozaik.Create(Csunya);
  mMozaikTebetu := TMozaik.Create(Tebetu);
  mMozaikLepcso := TMozaik.Create(Lepcso);
  mMozaikUbetu := TMozaik.Create(Ubetu);
  mMozaikEsbetu := TMozaik.Create(Esbetu);

  Check(not j.KeszVan, 'KeszVan 1 false');
  j.Kirak(mMozaikSonka, 1, 1);
  j.Kirak(mMozaikUbetu, 1, 4);
  j.Kirak(mMozaikCsunya, 1, 7);
  j.Kirak(mMozaikElbetu, 1, 9);
  j.Kirak(mMozaikLapat, 2, 3);
  j.Kirak(mMozaikKereszt, 2, 5);
  j.Kirak(mMozaikPuska, 2, 7);
  j.Kirak(mMozaikEsbetu, 3, 1);
  j.Kirak(mMozaikTebetu, 3, 9);
  j.Kirak(mMozaikHazteto, 4, 1);
  j.Kirak(mMozaikLepcso, 4, 6);
  Check(not j.KeszVan, 'KeszVan 2 false');
  j.Kirak(mMozaikHosszu, 6, 6);
  Check(j.KeszVan, 'KeszVan 3 true');

  mMozaikHosszu.Free;
  mMozaikElbetu.Free;
  mMozaikHazteto.Free;
  mMozaikSonka.Free;
  mMozaikKereszt.Free;
  mMozaikPuska.Free;
  mMozaikLapat.Free;
  mMozaikCsunya.Free;
  mMozaikTebetu.Free;
  mMozaikLepcso.Free;
  mMozaikUbetu.Free;
  mMozaikEsbetu.Free;
  j.Free;
end;

initialization
  RegisterTest('', TMainTest.Suite);
end.

