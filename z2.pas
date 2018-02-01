program z2;

const
  MAX_PASSENGERS=50;
  MAX_NAME=30;

type
  time = record
    h1, h2: 0..23;
    m1, m2: 0..59;
  end;

  name = string[MAX_NAME];

  bus = record
    t: time;
    passengers: array[1..MAX_PASSENGERS] of name;
    n: integer;                                         //broj putnika
  end;

  pointer = ^element;
  element = record
    b: bus;
    next: pointer;
  end;

  binary_file = file of time;

var
  list: pointer;
  passenger: name;
  n, i: integer;

procedure readList(var list: pointer);
var
  new_elem: pointer;
  input_file: binary_file;
begin
  assign(input_file, 'autobusi.dat');
  reset(input_file);

  list:=nil;
  while not eof(input_file) do
  begin
    new(new_elem);
    read(input_file, new_elem^.b.t);
    new_elem^.b.n:=0;
    new_elem^.next:=list;
    list:=new_elem;
  end;

  close(input_file);
end;

function duration(t: time): integer;
begin
  duration := t.h2*60 + t.m2 - t.h1*60 - t.m1;
end;

procedure sort(list: pointer);
var
  tek1, tek2: pointer;
  tmp: bus;
begin
  tek1:=list;
  while (tek1<>nil) do
  begin
    tek2:=tek1^.next;
    while (tek2<>nil) do
    begin
      if (duration(tek2^.b.t) < duration(tek1^.b.t)) then
      begin
        tmp:=tek1^.b;
        tek1^.b:=tek2^.b;
        tek2^.b:=tmp;
      end;
      tek2:=tek2^.next;
    end;
    tek1:=tek1^.next;
  end;
end;

procedure addPassenger(list: pointer; passenger: name);
var
  tek: pointer;
  found: boolean;
begin
  tek:=list;
  found:=false;

  while (tek<>nil) and (not found) do
  begin
    if (tek^.b.n < MAX_PASSENGERS) then
    begin
      tek^.b.n:=tek^.b.n+1;
      tek^.b.passengers[tek^.b.n]:=passenger;
      found:=true;
    end;
    tek:=tek^.next;
  end;

  if (not found) then
    writeln('Rezervacija se odbija.');

end;

procedure writeBus(b: bus);
var
  i: integer;
begin
  writeln(b.t.h1, ':', b.t.m1);
  for i:=1 to b.n do
    writeln(b.passengers[i]);
end;

procedure eraseList(var list: pointer);
var
  old: pointer;
begin
  while list<>nil do
  begin
    old:=list;
    list:=list^.next;
    dispose(old);
  end;
end;

procedure writeBuses(list: pointer);
begin
  while (list<>nil) do
  begin
    writeBus(list^.b);
    list:=list^.next;
  end;
end;

begin

  readList(list);
  sort(list);

  readln(n);
  for i:=1 to n do
  begin
    readln(passenger);
    addPassenger(list, passenger);
  end;

  writeBuses(list);

  eraseList(list);

end.
