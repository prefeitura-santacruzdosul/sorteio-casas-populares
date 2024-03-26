unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image1: TImage;
    Label1: TLabel;
    ListBoxPESSOAS: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Timer1: TTimer;
    ValueListEditorCASAS: TValueListEditor;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private

    function ValidaCPF(numCPF: string): boolean;

  public

  end;

var
  Form1: TForm1;

implementation

uses LCLType;

{$R *.lfm}

{ TForm1 }


function TForm1.ValidaCPF(numCPF: string): boolean;
var
  cpf: string;
  x, total, dg1, dg2: Integer;
begin
  Result := True;

  for x:=1 to Length(numCPF) do
    if not (numCPF[x] in ['0'..'9', '-', '.', ' ']) then
        Result := False;

  if Result then
  begin
    cpf:='';
    for x:=1 to Length(numCPF) do
        if numCPF[x] in ['0'..'9'] then
            cpf:=cpf + numCPF[x];

    if Length(cpf) <> 11 then
      Result:=False
    else
    begin

      //case AnsiIndexStr(cpf,['00000000000','11111111111','22222222222',
      //     '33333333333','44444444444','55555555555','66666666666',
      //     '77777777777','88888888888','99999999999']) of
      //  0..9: Result:=False;
      //end;

      if Result then
      begin

        //***********
        //1° dígito *
        //***********
        total:=0;
        for x:=1 to 9 do
            total:=total + (StrToInt(cpf[x]) * x);
        dg1:=total mod 11;
        if dg1 = 10 then
            dg1:=0;
        //***********
        //2° dígito *
        //***********
        total:=0;
        for x:=1 to 8 do
            total:=total + (StrToInt(cpf[x + 1]) * (x));
        total:=total + (dg1 * 9);
        dg2:=total mod 11;
        if dg2 = 10 then
            dg2:=0;
        //*****************
        //Validação final *
        //*****************
        if (dg1 = StrToInt(cpf[10])) and
           (dg2 = StrToInt(cpf[11])) then
          Result := True
        else
          Result := False;
      end;
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i : Integer;
  linha, cpf : String;
  sTemp : TStringList;
begin
  // abrir arquivo com lista das pessoas (CPF nome)
  // e exibir no objeto ListBoxPESSOAS


  // abre janela de selecionar arquivo
  if OpenDialog1.Execute then
  begin

    try

      // limpa a lista de pessoas
      ListBoxPESSOAS.Items.Clear;

      // cria uma lista temporária para ler todas as linhas do arquivo
      sTemp := TStringList.Create;
      try

        // limpa lista temporária
        sTemp.Clear;

        // carrega o arquivo selecionado
        sTemp.LoadFromFile( OpenDialog1.FileName );

        // ler todas as linhas
        for  i := 0 to sTemp.Count - 1 do
        begin
          // ler uma linha
          linha := sTemp[i];

          // captura os primeiros 14 caracteres da linha
          cpf := Copy(linha, 1, 14);

          // testar e trancar a leitura caso não
          // seja um numero valido de CPF
          if not Self.ValidaCPF( cpf ) then
          begin
            raise Exception.Create('CPF inválido: ' + cpf +
              sLineBreak + 'Linha: ' + IntToStr(i+1));
          end;



          // adiciona a pessoa na lista
          ListBoxPESSOAS.Items.Add( linha );

        end;


        // aviso ao usuário
        Showmessage('Arquivo carregado com sucesso!'+sLineBreak+
          'Quantidade de pessoas: ' + IntToStr(ListBoxPESSOAS.Count) );

      finally
        // destrói (da memória) a lista temporária
        sTemp.Free;
      end;

    except
      on E: Exception do
      begin
        // em caso de erro na leitura

        // limpa a lista de pessoas
        ListBoxPESSOAS.Items.Clear;

        // repassa o erro adiante para o usuario
        raise;
      end;
    end;

  end;


end;

procedure TForm1.Button2Click(Sender: TObject);
var
  sTemp : TStringList;
  i : Integer;
  linha : String;
begin
  // abrir arquivo com lista das casas
  // e exibir no objeto ValueListEditorCASAS


  // uma obs sobre esse componente usado na lista das casas (direita):
  // ele não tem uma propriedade "ReadOnly"
  // para bloquear a edição/digitação de dados



  // abre janela de selecionar arquivo
  if OpenDialog1.Execute then
  begin

    // limpa a lista de pessoas
    ValueListEditorCASAS.Clear;



    // cria uma lista temporária para ler todas as linhas do arquivo
    sTemp := TStringList.Create;
    try

      // limpa lista temporária
      sTemp.Clear;

      // carrega o arquivo selecionado
      sTemp.LoadFromFile( OpenDialog1.FileName );

      // ler todas as linhas
      for  i := 0 to sTemp.Count - 1 do
      begin
        // ler uma linha (uma casa)
        linha := sTemp[i];


        // Acrescentar um caractere de igual '=' ao final de cada linha,
        // pois é a característica do componente "TValueListEditor",
        // ele trabalha com pares de informação (chave=informação)
        // e aqui tem o objetivo de guardar os pares "CASA=PESSOA"
        // https://wiki.freepascal.org/TValueListEditor
        if (linha[Length(linha)] <> '=') then
        begin
          linha := linha + '=';
        end;


        // adiciona a linha/casa na lista
        ValueListEditorCASAS.Strings.Add(linha);

      end;


      // escreve no topo da tela o nome do arquivo
      Label1.Caption := ExtractFileName(OpenDialog1.FileName) + ' (Qtde de Casas: ' + IntToStr(ValueListEditorCASAS.Strings.Count) + ')';
      Self.Caption := Self.Caption + ' ' + Label1.Caption;


      // aviso ao usuário
      Showmessage('Arquivo carregado com sucesso!'+sLineBreak+
        'Quantidade de casas : ' + IntToStr(ValueListEditorCASAS.Strings.Count) );

    finally
      // destrói (da memória) a lista temporária
      sTemp.Free;
    end;

  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  quantidade_pessoas,
  quantidade_casas : Integer;
begin

  // quantidade de pessoas aguardando serem sorteadas.
  quantidade_pessoas := ListBoxPESSOAS.Count;

  // quantidade de casas na lista da direita
  quantidade_casas := ValueListEditorCASAS.Strings.Count;



  // Testar e trancar o sorteio caso a quantidade de pessoas (esquerda)
  // seja DIFERENTE que a quantidade de casas (direita)
  if (quantidade_pessoas <> quantidade_casas) then
  begin

    raise Exception.Create('A quantidade de pessoas (esquerda) NÃO pode ser DIFERENTE que a quantidade de casas (direita):'+
      sLineBreak + 'Qtde de PESSOAS : ' + IntToStr(quantidade_pessoas) +
      sLineBreak + 'Qtde de CASAS   : ' + IntToStr(quantidade_casas));

  end;




  // Inicializa gerador de números aleatórios (PASCAL)
  // https://www.freepascal.org/docs-html/rtl/system/randomize.html
  Randomize;


  // Bloquear o clique nos 3 botões
  Button1.Enabled := False;
  Button2.Enabled := False;
  Button3.Enabled := False;


  // Ativar o temporizador, que a cada 1 segundo vai
  // sortear uma pessoa que está na lista da esquerda,
  // e encontrar a próxima "casa vazia" que está na lista da direita,
  // associando esta pessoa sorteada à "casa vazia"
  // e mover esta pessoa da esquerda para a direita.

  //Timer1.Enabled := False;
  Timer1.Enabled := True;



end;

procedure TForm1.Button4Click(Sender: TObject);
var
  nome_arquivo : String;
begin

  if ValueListEditorCASAS.Strings.Count = 0 then
  begin
    raise Exception.Create('Nenhuma Casa na Lista!');
  end;


  // Salvar um arquivo contendo a lista de casas com cada pessoa sorteada


  // nome do arquivo contendo data e hora...
  nome_arquivo := 'sorteio_' + FormatDateTime('yyyymmdd_hhnnss', Now()) + '.txt';

  ValueListEditorCASAS.Strings.SaveToFile( nome_arquivo );


  ShowMessage('Arquivo salvo com Sucesso!' + sLineBreak + sLineBreak + nome_arquivo);

end;

procedure TForm1.Button5Click(Sender: TObject);
begin

  //ShowMessage( Edit1.Text );

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  // Perguntar ao usuário se realmente deseja fechar o programa.
  if Application.MessageBox('Confirma Fechar Aplicação ?', 'Confirmação',
    MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) <> IDYES then
  begin

    // se clicar no NÃO, esse valor "caNone" não deixa fechar o programa.
    CloseAction := Forms.caNone;

  end;


end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  achou_casa_vazia : Boolean;
  indice_casa_vazia,
  quantidade_pessoas,
  quantidade_casas,
  sorteio_pessoa : Integer;
  pessoa : String;
begin



  // Sortear uma pessoa que está na lista da esquerda,
  // e encontrar a próxima "casa vazia" que está na lista da direita;
  // Associar a pessoa sorteada à casa encontrada,
  // e mover esta pessoa da esquerda para a direita.
  // O programa vai repetir esta operação até aparecer esta mensagem:
  // SORTEIO CONCLUÍDO - Nenhuma pessoa encontrada na Lista

  // Ao final do sorteio, deve clicar no "Botão 4 - Salvar" !!!


  // quantidade de pessoas aguardando serem sorteadas.
  quantidade_pessoas := ListBoxPESSOAS.Count;

  // quantidade de casas na lista da direita
  quantidade_casas := ValueListEditorCASAS.Strings.Count;



  // Testar e trancar o sorteio caso a quantidade de pessoas (esquerda)
  // seja maior que a quantidade de casas (direita)
  if (quantidade_pessoas > quantidade_casas) then
  begin
    // desativa o contador de tempo
    Timer1.Enabled:= False;

    ShowMessage('A quantidade de pessoas (esquerda) NÃO pode ser maior que a quantidade de casas (direita):'+
      sLineBreak + 'Qtde de PESSOAS : ' + IntToStr(quantidade_pessoas) +
      sLineBreak + 'Qtde de CASAS   : ' + IntToStr(quantidade_casas));

    Abort;
  end;



  // Testar e trancar o sorteio caso a lista de pessoas esteja vazia
  // (quantidade_pessoas igual a zero -> terminou o sorteio)
  if (quantidade_pessoas = 0) then
  begin
    // desativa o contador de tempo
    Timer1.Enabled:= False;

    // aviso no topo da tela
    Label1.Caption := 'SORTEIO CONCLUÍDO: ' + Label1.Caption;

    ShowMessage(
      Label1.Caption + sLineBreak +
      sLineBreak + 'Nenhuma pessoa encontrada na Lista.');

    Abort;
  end;


  // teste para verificar se existe apenas UMA pessoa na lista
  if quantidade_pessoas = 1 then
  begin

    // o índice da primeira pessoa na lista é igual a ZERO.
    sorteio_pessoa := 0;

  end
  else
  begin

    // https://www.freepascal.org/docs-html/rtl/system/random.html
    // "Random returns a random number larger or equal to 0 and strictly less than L."

    // sorteia um número (aleatório) entre ZERO e o número anterior à quantidade de pessoas
    sorteio_pessoa := Random( quantidade_pessoas );

    // O índice da primeira pessoa na lista é zero,
    // da segunda é 1, da terceira é 2, e assim por diante...
    // Por exemplo:
    // [0] -> pessoa 1
    // [1] -> pessoa 2
    // [2] -> pessoa 3
    // [3] -> pessoa 4

  end;


  // pega o NOME e CPF da pessoa sorteada
  pessoa := ListBoxPESSOAS.Items[ sorteio_pessoa ];


  // Testar e trancar o sorteio caso
  // não seja encontrado o nome de uma pessoa na lista
  if (pessoa = '') then
  begin
    // desativa o contador de tempo
    Timer1.Enabled := False;

    ShowMessage('Número sorteado não contém dados de uma pessoa!'+
      sLineBreak + 'Número Sorteado : ' + IntToStr(sorteio_pessoa)+
      sLineBreak + 'Quantidade de Pessoas : ' + IntToStr(quantidade_pessoas));

    Abort;
  end;


  // Encontra a próxima casa na lista que ainda
  // não tem uma pessoa já associada (casa vazia)
  indice_casa_vazia := 0;
  achou_casa_vazia  := False;

  // Laço que percorre a lista de casas, até encontrar uma "casa vazia"
  while (indice_casa_vazia < quantidade_casas) and (not achou_casa_vazia) do
  begin

    // Testar se esta é uma "casa vazia"
    if ValueListEditorCASAS.Strings.ValueFromIndex[ indice_casa_vazia ] = '' then
    begin
      // Encontrou uma "casa vazia" (Verdadeiro)
      achou_casa_vazia := True;
    end
    else
    begin
      // Ainda não encontrou uma "casa vazia", então incrementa (+1)
      // o índice para continuar percorrendo a lista de casas.
      indice_casa_vazia := indice_casa_vazia + 1;
    end;

  end;

  // Testar e trancar o sorteio caso não tenha encontrado uma "casa vazia",
  // isto é, uma casa que ainda não tenha os dados (CPF e nome) de uma pessoa.
  if (not achou_casa_vazia) then
  begin
    // desativa o contador de tempo
    Timer1.Enabled:= False;

    ShowMessage('Não foi encontrada uma casa!');

    Abort;
  end;


  // Testar se encontrou uma "casa vazia"
  if achou_casa_vazia then
  begin


    // ASSOCIA A CASA E A PESSOA SORTEADA
    ValueListEditorCASAS.Strings.ValueFromIndex[ indice_casa_vazia ] := pessoa;


    // remove a pessoa sorteada, da lista de pessoas (esquerda)
    ListBoxPESSOAS.Items.Delete( sorteio_pessoa );

  end;




end;

end.

